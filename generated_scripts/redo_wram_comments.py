#!/usr/bin/env python3
"""Fix stale WRAM address comments in wram.asm.

Recomputes the address of every label in wram.asm by emulating the RGBDS
0.6.x WRAM layout rules (SECTION orgs, macro expansion with \\1 args,
UNION/NEXTU/ENDU taking the max branch size, naked db/dw emitting 1/2 bytes,
integer division rounding down), then rewrites ONLY the existing 4-hex-digit
address comments ("; c001", ";cdd6", "; d430<TAB>joenote", "; d37f:", ...).
Prose comments and relative offset comments (";+$00") are left untouched,
and no comment is ever added or removed.

Constants are resolved by parsing the repository's constants.asm include
tree (EQU, DEF, =, const_def/const/const_skip/const_value chains), so the
script cannot silently rely on wrong constant values: if something it needs
cannot be evaluated, it aborts with a file:line message.

Idempotent: run it twice, the second run reports 0 fixed.
After running: rebuild the ROM (it must stay binary identical, comments
only) and cross-check the printed anchors against your .map file.
"""

import argparse
import re
import sys
from pathlib import Path


class AsmError(Exception):
    pass


def fail(msg):
    raise AsmError(msg)


# ---------------------------------------------------------------------------
# expression evaluation (rgbasm semantics: signed 32-bit, division rounds
# down, remainder takes the sign of the divisor -- same as Python)
# ---------------------------------------------------------------------------

class Expr:
    def __init__(self, text, env, ctx, used=None):
        self.s = text
        self.pos = 0
        self.env = env
        self.ctx = ctx
        self.used = used  # set collecting resolved constant names

    def err(self, msg):
        fail("%s in expression '%s' (%s)" % (msg, self.s, self.ctx))

    def peek(self):
        while self.pos < len(self.s) and self.s[self.pos] in " \t":
            self.pos += 1
        if self.pos >= len(self.s):
            return None
        return self.s[self.pos]

    def primary(self):
        c = self.peek()
        if c is None:
            self.err("unexpected end")
        if c == "(":
            self.pos += 1
            v = self.or_()
            if self.peek() != ")":
                self.err("missing ')'")
            self.pos += 1
            return v
        if c == "-":
            self.pos += 1
            return -self.primary()
        if c == "+":
            self.pos += 1
            return self.primary()
        if c == "~":
            self.pos += 1
            return ~self.primary()
        if c == "!":
            self.pos += 1
            return 1 if self.primary() == 0 else 0
        if c == "$":
            self.pos += 1
            m = re.match(r"[0-9a-fA-F]+", self.s[self.pos:])
            if not m:
                self.err("bad hexadecimal literal")
            self.pos += len(m.group(0))
            return int(m.group(0), 16)
        if c == "%":
            self.pos += 1
            m = re.match(r"[01]+", self.s[self.pos:])
            if not m:
                self.err("bad binary literal")
            self.pos += len(m.group(0))
            return int(m.group(0), 2)
        m = re.match(r"[A-Za-z_][A-Za-z0-9_]*", self.s[self.pos:])
        if m:
            self.pos += len(m.group(0))
            name = m.group(0)
            if name in self.env:
                if self.used is not None:
                    self.used.add(name)
                return self.env[name]
            self.err("unknown identifier '%s'" % name)
        m = re.match(r"\d+", self.s[self.pos:])
        if m:
            self.pos += len(m.group(0))
            return int(m.group(0), 10)
        self.err("unexpected character '%s'" % c)

    def mul(self):
        v = self.primary()
        while True:
            c = self.peek()
            if c == "*":
                self.pos += 1
                v = v * self.primary()
            elif c == "/":
                self.pos += 1
                v = v // self.primary()
            elif c == "%":
                self.pos += 1
                v = v % self.primary()
            else:
                return v

    def add(self):
        v = self.mul()
        while True:
            c = self.peek()
            if c == "+":
                self.pos += 1
                v = v + self.mul()
            elif c == "-":
                self.pos += 1
                v = v - self.mul()
            else:
                return v

    def shift(self):
        v = self.add()
        while True:
            c = self.peek()
            if c == "<" and self.s[self.pos:self.pos + 2] == "<<":
                self.pos += 2
                v = v << self.add()
            elif c == ">" and self.s[self.pos:self.pos + 2] == ">>":
                self.pos += 2
                v = v >> self.add()
            else:
                return v

    def and_(self):
        v = self.shift()
        while self.peek() == "&":
            self.pos += 1
            v = v & self.shift()
        return v

    def xor_(self):
        v = self.and_()
        while self.peek() == "^":
            self.pos += 1
            v = v ^ self.and_()
        return v

    def or_(self):
        v = self.xor_()
        while self.peek() == "|":
            self.pos += 1
            v = v | self.xor_()
        return v


def eval_expr(text, env, ctx, used=None):
    e = Expr(text, env, ctx, used)
    v = e.or_()
    if e.pos < len(e.s):
        e.err("trailing garbage at '%s'" % e.s[e.pos:])
    return v


# ---------------------------------------------------------------------------
# shared line regexes
# ---------------------------------------------------------------------------

RE_MACRO = re.compile(r"^\s*MACRO\s+([A-Za-z_]\w*)", re.IGNORECASE)
RE_ENDM = re.compile(r"^\s*endm\s*$", re.IGNORECASE)
RE_IF = re.compile(r"^\s*(IF|ELIF)\s+(.+)$", re.IGNORECASE)
RE_ELSE = re.compile(r"^\s*else\s*$", re.IGNORECASE)
RE_ENDC = re.compile(r"^\s*endc\s*$", re.IGNORECASE)
RE_INCLUDE = re.compile(r'INCLUDE\s+"([^"]+)"')
RE_DEF_PREFIX = re.compile(r"^DEF\s+", re.IGNORECASE)
RE_CONST_DEF = re.compile(r"^const_def\s*(.*)$", re.IGNORECASE)
RE_CONST_SKIP = re.compile(r"^const_skip\s*(.*)$", re.IGNORECASE)
RE_CONST_VALUE = re.compile(r"^const_value\s*(\+?=)\s*(.+)$", re.IGNORECASE)
RE_CONST = re.compile(r"^const\s+([A-Za-z_]\w*)\s*$", re.IGNORECASE)
RE_EQU = re.compile(r"^([A-Za-z_]\w*)\s+EQU\s+(.+)$", re.IGNORECASE)
RE_ASSIGN = re.compile(r"^([A-Za-z_]\w*)\s*=\s*(.+)$")
RE_SECTION = re.compile(r'^\s*SECTION\s+"([^"]*)",\s*(\w+)\s*(?:\[(.+)\])?\s*$')
RE_LABEL = re.compile(r"^([A-Za-z_.][\w.]*)::?")
RE_DS = re.compile(r"^ds\s+(.+)$", re.IGNORECASE)
RE_WORD = re.compile(r"^([A-Za-z_]\w*)\s*(.*)$")
RE_MSUB = re.compile(r"\\(\d)")
RE_LABEL_START = re.compile(r"^\s*([A-Za-z_.][\w.]*)::?")
# an address comment: ";" + optional blanks + exactly 4 hex digits not
# followed by another hex digit (so ;+$00, prose, 3/5-digit tokens, etc.
# are never touched)
RE_ADDR_COMMENT = re.compile(r"^;(\s*)([0-9a-fA-F]{4})(?![0-9a-fA-F])")


# ---------------------------------------------------------------------------
# constants: parse the constants.asm include tree
# ---------------------------------------------------------------------------

def read_text(path, strict_ascii):
    data = path.read_bytes()
    try:
        return data.decode("ascii")
    except UnicodeDecodeError:
        if strict_ascii:
            fail("%s is not pure ASCII; refusing to touch it" % path)
        # the constants tree contains charmap.asm with UTF-8 kana; those
        # lines are irrelevant here, decode leniently
        return data.decode("utf-8", errors="replace")


def parse_constants(root):
    env = {}
    used_files = []

    def process_file(rel, depth):
        if depth > 32:
            fail("INCLUDE nesting too deep (cycle?) at %s" % rel)
        path = root / rel
        if not path.is_file():
            fail("missing include '%s'" % rel)
        used_files.append(rel)
        lines = read_text(path, strict_ascii=False).split("\n")
        in_macro = False
        if_stack = []
        for i, raw in enumerate(lines):
            line_no = i + 1
            ctx = "%s:%d" % (rel, line_no)
            if RE_MACRO.match(raw):
                in_macro = True
                continue
            if RE_ENDM.match(raw):
                in_macro = False
                continue
            if in_macro:
                continue
            code = raw.split(";", 1)[0].strip()
            if not code:
                continue
            active = all(if_stack)
            m = RE_IF.match(code)
            if m:
                val = eval_expr(m.group(2), env, ctx) != 0
                if_stack.append(val if active else False)
                continue
            if RE_ELSE.match(code):
                if if_stack:
                    if_stack[-1] = not if_stack[-1]
                continue
            if RE_ENDC.match(code):
                if if_stack:
                    if_stack.pop()
                continue
            if not active:
                continue
            if code.upper().startswith("INCLUDE"):
                m = RE_INCLUDE.search(code)
                if not m:
                    fail("%s: malformed INCLUDE" % ctx)
                process_file(m.group(1), depth + 1)
                continue
            body = RE_DEF_PREFIX.sub("", code, count=1)
            m = RE_CONST_DEF.match(body)
            if m:
                args = m.group(1).strip()
                if args:
                    parts = [eval_expr(a.strip(), env, ctx) for a in args.split(",")]
                    env["const_value"] = parts[0]
                    env["const_inc"] = parts[1] if len(parts) > 1 else 1
                else:
                    env["const_value"] = 0
                    env["const_inc"] = 1
                continue
            m = RE_CONST_SKIP.match(body)
            if m:
                arg = m.group(1).strip()
                n = eval_expr(arg, env, ctx) if arg else 1
                env["const_value"] = env.get("const_value", 0) \
                    + env.get("const_inc", 1) * n
                continue
            m = RE_CONST_VALUE.match(body)
            if m:
                if m.group(1) == "+=":
                    env["const_value"] = env.get("const_value", 0) \
                        + eval_expr(m.group(2), env, ctx)
                else:
                    env["const_value"] = eval_expr(m.group(2), env, ctx)
                continue
            m = RE_CONST.match(body)
            if m:
                name = m.group(1)
                env[name] = env.get("const_value", 0)
                env["const_value"] = env.get("const_value", 0) + 1
                continue
            m = RE_EQU.match(body)
            if m:
                env[m.group(1)] = eval_expr(m.group(2), env, ctx)
                continue
            m = RE_ASSIGN.match(body)
            if m:
                env[m.group(1)] = eval_expr(m.group(2), env, ctx)
                continue
            # anything else (labels, charmap, macro invocations, data) is
            # irrelevant for constant resolution: ignore silently
        if if_stack:
            fail("unbalanced IF/ENDC in %s" % rel)

    process_file("constants.asm", 0)
    return env, used_files


# ---------------------------------------------------------------------------
# wram.asm: compute the address of every label
# ---------------------------------------------------------------------------

def parse_wram(lines, env):
    # pre-scan macro definitions
    macros = {}
    i = 0
    n = len(lines)
    while i < n:
        m = RE_MACRO.match(lines[i])
        if m:
            body = []
            j = i + 1
            while j < n and not RE_ENDM.match(lines[j]):
                body.append(lines[j])
                j += 1
            if j >= n:
                fail("wram.asm:%d: unterminated MACRO %s" % (i + 1, m.group(1)))
            macros[m.group(1)] = body
            i = j + 1
        else:
            i += 1

    labels = {}
    sections = []  # [name, start, end]
    used_constants = set()
    addr = None
    union_stack = []  # [start, max]
    # frame: [name, lines, idx, line_base]
    frames = [["<file>", lines, 0, 1]]

    guard = 0
    while frames:
        guard += 1
        if guard > 200000:
            fail("runaway macro expansion in wram.asm")
        fr = frames[-1]
        if fr[2] >= len(fr[1]):
            frames.pop()
            continue
        raw = fr[1][fr[2]]
        line_no = fr[3] + fr[2]
        if fr[0] == "<file>":
            ctx = "wram.asm:%d" % line_no
        else:
            ctx = "wram.asm:%d (macro %s, invoked at this line)" % (line_no, fr[0])
        fr[2] += 1

        if RE_MACRO.match(raw):
            # skip the definition body in the main pass
            while fr[2] < len(fr[1]) and not RE_ENDM.match(fr[1][fr[2]]):
                fr[2] += 1
            fr[2] += 1  # skip the ENDM line
            continue

        m = RE_SECTION.match(raw)
        if m:
            if m.group(2) != "WRAM0":
                fail("%s: unsupported section type %s (only WRAM0 is expected)"
                     % (ctx, m.group(2)))
            if sections:
                sections[-1][2] = addr
            addr = eval_expr(m.group(3), env, ctx, used_constants) \
                if m.group(3) is not None else 0xC000
            sections.append([m.group(1), addr, addr])
            union_stack = []
            continue

        code = raw.split(";", 1)[0].strip()
        if not code:
            continue
        if code.upper().startswith("INCLUDE"):
            # constants.asm: resolved beforehand; sram.asm: SRAM, out of scope
            continue

        m = RE_EQU.match(code)
        if m:
            env[m.group(1)] = eval_expr(m.group(2), env, ctx, used_constants)
            continue

        u = code.upper()
        if u == "UNION":
            if addr is None:
                fail("%s: UNION outside of a section" % ctx)
            union_stack.append([addr, 0])
            continue
        if u == "NEXTU":
            if not union_stack:
                fail("%s: NEXTU without UNION" % ctx)
            t = union_stack[-1]
            t[1] = max(t[1], addr - t[0])
            addr = t[0]
            continue
        if u == "ENDU":
            if not union_stack:
                fail("%s: ENDU without UNION" % ctx)
            t = union_stack.pop()
            t[1] = max(t[1], addr - t[0])
            addr = t[0] + t[1]
            continue

        # one or more labels at line start
        while True:
            lm = RE_LABEL.match(code)
            if not lm:
                break
            lab = lm.group(1)
            if addr is None:
                fail("%s: label '%s' outside of a section" % (ctx, lab))
            if lab.startswith("."):
                # local label: address kept for reference only, never used
                # for comment rewriting (its parent scoping is not tracked)
                labels[lab] = addr
            else:
                if lab in labels and labels[lab] != addr:
                    fail("%s: label '%s' redefined ($%04x -> $%04x)"
                         % (ctx, lab, labels[lab], addr))
                labels[lab] = addr
            code = code[lm.end():].strip()
        if not code:
            continue

        m = RE_DS.match(code)
        if m:
            addr += eval_expr(m.group(1), env, ctx, used_constants)
            continue
        u = code.upper()  # recompute: 'code' had its labels stripped above
        if u == "DB":
            addr += 1  # naked db: reserves 1 byte (no initializer in WRAM)
            continue
        if u == "DW":
            addr += 2
            continue

        wm = RE_WORD.match(code)
        if wm and wm.group(1) in macros:
            name = wm.group(1)
            rest = wm.group(2).strip()
            args = [a.strip() for a in rest.split(",")] if rest else []
            expanded = []
            for body_line in macros[name]:
                def repl(mm, args=args, name=name, ctx=ctx):
                    k = int(mm.group(1))
                    if k < 1 or k > len(args):
                        fail("%s: macro %s has no argument \\%d" % (ctx, name, k))
                    return args[k - 1]
                expanded.append(RE_MSUB.sub(repl, body_line))
            frames.append([name, expanded, 0, line_no])
            continue

        fail("%s: unrecognized line: %s" % (ctx, raw.strip()[:60]))

    if union_stack:
        fail("wram.asm: unterminated UNION")
    if sections:
        sections[-1][2] = addr
    return labels, sections, used_constants


# ---------------------------------------------------------------------------
# comment rewriting
# ---------------------------------------------------------------------------

def rewrite_comments(lines, labels):
    changed = []
    total = 0
    for idx, raw in enumerate(lines):
        line_no = idx + 1
        code = raw.split(";", 1)[0]
        lm = RE_LABEL_START.match(code)
        if not lm:
            continue
        lab = lm.group(1)
        if lab.startswith(".") or lab not in labels:
            continue
        semi = raw.find(";")
        if semi < 0:
            continue
        comment = raw[semi:]
        cm = RE_ADDR_COMMENT.match(comment)
        if not cm:
            continue
        total += 1
        correct = "%04x" % labels[lab]
        if cm.group(2).lower() == correct:
            continue
        changed.append((line_no, lab, cm.group(2).lower(), correct))
        lines[idx] = raw[:semi] + ";" + cm.group(1) + correct + comment[cm.end():]
    return changed, total


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

ANCHOR_NAMES = [
    "wSpriteStateData1", "wSpriteStateData2", "wOAMBuffer",
    "wMainDataStart", "wMainDataEnd",
    "wPokedexOwned", "wPokedexSeen",
    "wMissableObjectFlags", "wItemBallFlags", "wMissableObjectList",
    "wSavedRngSeed", "wItemBallList", "wStack",
]


def main(argv=None):
    ap = argparse.ArgumentParser(
        description="Fix stale 4-hex address comments in wram.asm "
                    "by recomputing the real WRAM layout.")
    ap.add_argument("--dry-run", action="store_true",
                    help="report the changes without writing the file")
    args = ap.parse_args(argv)

    root = None
    for cand in Path(__file__).resolve().parents:
        if (cand / "wram.asm").is_file() and (cand / "constants.asm").is_file():
            root = cand
            break
    if root is None:
        fail("cannot locate the repository root (wram.asm + constants.asm) "
             "in the parent directories of this script")

    print("repo root: %s" % root)
    print("parsing constants.asm include tree...")
    env, used_files = parse_constants(root)
    print("  %d files, %d constants resolved" % (len(used_files), len(env)))

    wram_path = root / "wram.asm"
    data = wram_path.read_bytes()
    # ISO-8859-1: every byte maps to exactly one char and back, so the
    # round trip is byte-exact for ANY file (UTF-8 or otherwise). The only
    # bytes ever modified are ASCII hex digits inside address comments;
    # non-ASCII bytes (accents in prose comments) pass through untouched.
    text = data.decode("iso-8859-1")
    crlf = "\r\n" in text
    if crlf:
        text = text.replace("\r\n", "\n")
    lines = text.split("\n")

    labels, sections, used_constants = parse_wram(lines, env)

    print("\nConstants used by the wram.asm layout (from the repo):")
    for name in sorted(used_constants):
        print("  %s = %d ($%x)" % (name, env[name], env[name]))

    print("\nComputed anchors (cross-check against the .map after build):")
    for name in ANCHOR_NAMES:
        if name in labels:
            print("  $%04x  %s" % (labels[name], name))
        else:
            print("  ?????  %s (label not found)" % name)
    for name, start, end in sections:
        print("  SECTION '%s': $%04x -> $%04x (%d bytes)"
              % (name, start, end, end - start))
    if "wMainDataStart" in labels and "wMainDataEnd" in labels:
        size = labels["wMainDataEnd"] - labels["wMainDataStart"]
        print("  MainData size: %d bytes ($%03x)"
              % (size, size))

    changed, total = rewrite_comments(lines, labels)
    print("\n%d/%d address comments fixed:" % (len(changed), total))
    for line_no, lab, old, new in changed:
        print("  line %d: %s: $%s -> $%s" % (line_no, lab, old, new))

    if not changed:
        print("nothing to fix: wram.asm address comments are up to date")
        return 0

    new_text = "\n".join(lines)
    if crlf:
        new_text = new_text.replace("\n", "\r\n")
    new_data = new_text.encode("iso-8859-1")
    if len(new_data) != len(data):
        fail("internal error: file size would change (%d -> %d bytes); "
             "aborting without writing" % (len(data), len(new_data)))
    if args.dry_run:
        print("dry run: wram.asm left unchanged")
    else:
        wram_path.write_bytes(new_data)
        print("wrote %s (%d bytes, unchanged size)" % (wram_path, len(new_data)))
        print("re-run this script to confirm idempotence (expect 0 fixed), "
              "then rebuild: the ROM must stay binary identical")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except AsmError as exc:
        sys.exit("fix_wram_comments.py: error: %s" % exc)