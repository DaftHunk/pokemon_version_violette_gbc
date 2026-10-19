; Pikachu's Beach minigame - Mon gfx assets
; Floating section: the linker places this wherever it fits.
; These are always loaded with banked copies (FarCopyData / CopyVideoData).

SECTION "Pikachu's Beach Mons Graphics", ROMX

SurfingPikachuIntroGFX:: INCBIN "gfx/pikachus_beach/intro_pikachu.2bpp"
SurfingPikachuIntroGFXEnd::
ASSERT SurfingPikachuIntroGFXEnd - SurfingPikachuIntroGFX == 48 tiles

SurfingPikachuGameplayMonGFX:: INCBIN "gfx/pikachus_beach/surfing_pikachu.2bpp"
SurfingPikachuGameplayMonGFXEnd::
ASSERT SurfingPikachuGameplayMonGFXEnd - SurfingPikachuGameplayMonGFX == 192 tiles

PikachusBeachPrinterPikachuGraphics:: INCBIN "gfx/pikachus_beach/printer_pikachu.2bpp"
PikachusBeachPrinterPikachuGraphicsEnd::
ASSERT PikachusBeachPrinterPikachuGraphicsEnd - PikachusBeachPrinterPikachuGraphics == 30 tiles
