; Pikachu's Beach minigame - common gfx assets
; This file has no SECTION: it is included inside SECTION "bank13" in main.asm,
; so the engine can read these graphics with same-bank CopyData calls.
; Copy the FR graphics from yumepokered's translation/fra/gfx/pikachus_beach/
; into gfx/pikachus_beach/ (renamed, without the .fra part):
;   background.fra.png -> background.png
;   title.fra.2bpp     -> title.png
;   gameplay_effects.fra.png -> gameplay_effects.png
; and from gfx/pikachus_beach/: beach.png, frame.png, printer_common.png

PikachusBeachBGGraphics:: INCBIN "gfx/pikachus_beach/background.2bpp"
PikachusBeachBGGraphicsEnd::

PikachusBeachTitleGFX:: INCBIN "gfx/pikachus_beach/title.2bpp"
PikachusBeachTitleGFXEnd::
ASSERT PikachusBeachTitleGFXEnd - PikachusBeachTitleGFX == 78 tiles ; hard-coded size in PikachusBeachIntro

PikachusBeachBeachAndFrameGFX::
PikachusBeachBeachGFX:: INCBIN "gfx/pikachus_beach/beach.2bpp"
PikachusBeachFrameGFX:: INCBIN "gfx/pikachus_beach/frame.2bpp"
PikachusBeachBeachAndFrameGFXEnd::

PikachusBeachGameplayEffectsGraphics:: INCBIN "gfx/pikachus_beach/gameplay_effects.2bpp"
PikachusBeachGameplayEffectsGraphicsEnd::

PikachusBeachPrinterCommonGraphics:: INCBIN "gfx/pikachus_beach/printer_common.2bpp"
PikachusBeachPrinterCommonGraphicsEnd::
