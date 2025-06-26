INCLUDE "constants.asm"

NPC_SPRITES_1 EQU $4
NPC_SPRITES_2 EQU $5

GFX EQU $4

PICS_1 EQU $2F
PICS_2 EQU $A
PICS_3 EQU $B
PICS_4 EQU $C
PICS_5 EQU $D
PICS_6 EQU $30
PICS_7 EQU $31

INCLUDE "home.asm"


SECTION "bank1",ROMX,BANK[$1]

INCLUDE "data/maps/facing.asm"

INCLUDE "engine/black_out.asm"

INCLUDE "engine/battle/safari_zone.asm"

INCLUDE "engine/titlescreen.asm"
INCLUDE "engine/load_mon_data.asm"

INCLUDE "data/items/item_prices.asm"
INCLUDE "text/item_names.asm"

INCLUDE "engine/overworld/oam.asm"
INCLUDE "engine/oam_dma.asm"

INCLUDE "engine/print_waiting_text.asm"

INCLUDE "engine/overworld/map_sprite_functions1.asm"

INCLUDE "engine/overworld/item.asm"
INCLUDE "engine/overworld/movement.asm"

INCLUDE "engine/cable_club.asm"

INCLUDE "engine/menu/main_menu.asm"

INCLUDE "engine/oak_speech.asm"

INCLUDE "engine/special_warps.asm"

INCLUDE "engine/menu/naming_screen.asm"

INCLUDE "engine/oak_speech2.asm"

INCLUDE "engine/subtract_paid_money.asm"

INCLUDE "engine/menu/swap_items.asm"

INCLUDE "engine/overworld/pokemart.asm"

INCLUDE "engine/overworld/pokecenter.asm"

INCLUDE "engine/overworld/set_blackout_map.asm"

INCLUDE "engine/display_text_id_init.asm"
INCLUDE "engine/menu/draw_start_menu.asm"

INCLUDE "engine/overworld/cable_club_npc.asm"

INCLUDE "engine/menu/text_box.asm"

INCLUDE "engine/battle/moveEffects/drain_hp_effect.asm"

INCLUDE "engine/menu/players_pc.asm"

INCLUDE "engine/remove_pokemon.asm"

INCLUDE "engine/display_pokedex.asm"

SECTION "bank3",ROMX,BANK[$3]

INCLUDE "engine/joypad.asm"

INCLUDE "data/maps/map_songs.asm"

INCLUDE "data/maps/map_header_banks.asm"

INCLUDE "engine/overworld/clear_variables.asm"
INCLUDE "engine/overworld/player_state.asm"
INCLUDE "engine/overworld/poison.asm"
INCLUDE "engine/overworld/tileset_header.asm"
INCLUDE "engine/overworld/daycare_exp.asm"

INCLUDE "data/maps/hide_show_data.asm"

INCLUDE "engine/overworld/field_move_messages.asm"

INCLUDE "engine/items/inventory.asm"

INCLUDE "engine/overworld/wild_mons.asm"

INCLUDE "engine/items/items.asm"

INCLUDE "engine/menu/draw_badges.asm"

INCLUDE "engine/overworld/update_map.asm"
INCLUDE "engine/overworld/cut.asm"
INCLUDE "engine/overworld/missable_objects.asm"
INCLUDE "engine/overworld/push_boulder.asm"

INCLUDE "engine/add_mon.asm"
INCLUDE "engine/flag_action.asm"
INCLUDE "engine/heal_party.asm"
INCLUDE "engine/bcd.asm"
INCLUDE "engine/init_player_data.asm"
INCLUDE "engine/get_bag_item_quantity.asm"
INCLUDE "engine/pathfinding.asm"
INCLUDE "engine/hp_bar.asm"
INCLUDE "engine/hidden_object_functions3.asm"

SECTION "NPC Sprites 1", ROMX, BANK[NPC_SPRITES_1]

OakAideSprite:         INCBIN "gfx/sprites/oak_aide.2bpp"
RockerSprite:          INCBIN "gfx/sprites/rocker.2bpp"
SwimmerSprite:         INCBIN "gfx/sprites/swimmer.2bpp"
WhitePlayerSprite:     INCBIN "gfx/sprites/white_player.2bpp"
GymHelperSprite:       INCBIN "gfx/sprites/gym_helper.2bpp"
OldPersonSprite:       INCBIN "gfx/sprites/old_person.2bpp"
MartGuySprite:         INCBIN "gfx/sprites/mart_guy.2bpp"
FisherSprite:          INCBIN "gfx/sprites/fisher.2bpp"
OldMediumWomanSprite:  INCBIN "gfx/sprites/old_medium_woman.2bpp"
NurseSprite:           INCBIN "gfx/sprites/nurse.2bpp"
CableClubWomanSprite:  INCBIN "gfx/sprites/cable_club_woman.2bpp"
MrMasterballSprite:    INCBIN "gfx/sprites/mr_masterball.2bpp"
LaprasGiverSprite:     INCBIN "gfx/sprites/lapras_giver.2bpp"
WardenSprite:          INCBIN "gfx/sprites/warden.2bpp"
SsCaptainSprite:       INCBIN "gfx/sprites/ss_captain.2bpp"
Fisher2Sprite:         INCBIN "gfx/sprites/fisher2.2bpp"
BlackbeltSprite:       INCBIN "gfx/sprites/blackbelt.2bpp"
GuardSprite:           INCBIN "gfx/sprites/guard.2bpp"
BallSprite:            INCBIN "gfx/sprites/ball.2bpp"
BoulderSprite:         INCBIN "gfx/sprites/boulder.2bpp"
PaperSheetSprite:      INCBIN "gfx/sprites/paper_sheet.2bpp"
BookMapDexSprite:      INCBIN "gfx/sprites/book_map_dex.2bpp"
ClipboardSprite:       INCBIN "gfx/sprites/clipboard.2bpp"
LyingOldManSprite:     INCBIN "gfx/sprites/lying_old_man.2bpp"

SECTION "Graphics", ROMX, BANK[GFX]
PokemonLogoGraphics:            INCBIN "gfx/mainmenu/pokemon_logo.2bpp"
FontGraphics:                   INCBIN "gfx/tiles/font.1bpp"
FontGraphicsEnd:
ABTiles:                        INCBIN "gfx/tiles/AB.2bpp"
HpBarAndStatusGraphics:         INCBIN "gfx/tiles/hp_bar_and_status.2bpp"
HpBarAndStatusGraphicsEnd:
BattleHudTiles1:                INCBIN "gfx/tiles/battle_hud1.1bpp"
BattleHudTiles1End:
BattleHudTiles2:                INCBIN "gfx/tiles/battle_hud2.1bpp"
BattleHudTiles3:                INCBIN "gfx/tiles/battle_hud3.1bpp"
BattleHudTiles3End:

NintendoCopyrightLogoGraphics:  INCBIN "gfx/mainmenu/copyright.2bpp"

GamefreakLogoGraphics:          INCBIN "gfx/mainmenu/gamefreak.2bpp"
GamefreakLogoGraphicsEnd:
Unk9Graphic:                    INCBIN "gfx/tiles/unk_9.2bpp"
Unk9GraphicEnd:
TextBoxGraphics:                INCBIN "gfx/tiles/text_box.2bpp"
TextBoxGraphicsEnd:
PokedexTileGraphics:            INCBIN "gfx/tiles/pokedex.2bpp"
PokedexTileGraphicsEnd:
WorldMapTileGraphics:           INCBIN "gfx/tiles/town_map.2bpp"
WorldMapTileGraphicsEnd:
PlayerCharacterTitleGraphics:   INCBIN "gfx/mainmenu/player_title.2bpp"
PlayerCharacterTitleGraphicsEnd:


SECTION "Battle (bank 4)", ROMX, BANK[$4]

INCLUDE "engine/overworld/is_player_just_outside_map.asm"
INCLUDE "engine/menu/status_screen.asm"
INCLUDE "engine/menu/party_menu.asm"

RedPicFront:: INCBIN "gfx/trainer/red.pic"
ShrinkPic1::  INCBIN "gfx/trainer/shrink1.pic"
ShrinkPic2::  INCBIN "gfx/trainer/shrink2.pic"

INCLUDE "engine/turn_sprite.asm"
INCLUDE "engine/menu/start_sub_menus.asm"
INCLUDE "engine/items/tms.asm"
INCLUDE "engine/battle/end_of_battle.asm"
INCLUDE "engine/battle/wild_encounters.asm"
INCLUDE "engine/battle/moveEffects/recoil_effect.asm"
INCLUDE "engine/battle/moveEffects/conversion_effect.asm"
INCLUDE "engine/battle/moveEffects/haze_effect.asm"
INCLUDE "engine/battle/moveEffects/tri_attack_effect.asm"

INCLUDE "engine/battle/get_trainer_name.asm"
INCLUDE "engine/random.asm"

;joenote - adding exp bar
EXPBarGraphics:  INCBIN "gfx/tiles/exp_bar.2bpp"
EXPBarGraphicsEnd:

SECTION "NPC Sprites 2", ROMX, BANK[NPC_SPRITES_2]

RedCyclingSprite:     INCBIN "gfx/sprites/cycling.2bpp"
RedSprite:            INCBIN "gfx/sprites/red.2bpp"
BlueSprite:           INCBIN "gfx/sprites/blue.2bpp"
OakSprite:            INCBIN "gfx/sprites/oak.2bpp"
BugCatcherSprite:     INCBIN "gfx/sprites/bug_catcher.2bpp"
LassSprite:           INCBIN "gfx/sprites/lass.2bpp"
BlackHairBoy1Sprite:  INCBIN "gfx/sprites/black_hair_boy_1.2bpp"
LittleGirlSprite:     INCBIN "gfx/sprites/little_girl.2bpp"
FatBaldGuySprite:     INCBIN "gfx/sprites/fat_bald_guy.2bpp"
GamblerSprite:        INCBIN "gfx/sprites/gambler.2bpp"
BlackHairBoy2Sprite:  INCBIN "gfx/sprites/black_hair_boy_2.2bpp"
GirlSprite:           INCBIN "gfx/sprites/girl.2bpp"
HikerSprite:          INCBIN "gfx/sprites/hiker.2bpp"
FoulardWomanSprite:   INCBIN "gfx/sprites/foulard_woman.2bpp"
GentlemanSprite:      INCBIN "gfx/sprites/gentleman.2bpp"
DaisySprite:          INCBIN "gfx/sprites/daisy.2bpp"
BikerSprite:          INCBIN "gfx/sprites/biker.2bpp"
SailorSprite:         INCBIN "gfx/sprites/sailor.2bpp"
CookSprite:           INCBIN "gfx/sprites/cook.2bpp"
BikeShopGuySprite:    INCBIN "gfx/sprites/bike_shop_guy.2bpp"
MrFujiSprite:         INCBIN "gfx/sprites/mr_fuji.2bpp"
GiovanniSprite:       INCBIN "gfx/sprites/giovanni.2bpp"
RocketSprite:         INCBIN "gfx/sprites/rocket.2bpp"
MediumSprite:         INCBIN "gfx/sprites/medium.2bpp"
WaiterSprite:         INCBIN "gfx/sprites/waiter.2bpp"
ErikaSprite:          INCBIN "gfx/sprites/erika.2bpp"
MomGeishaSprite:      INCBIN "gfx/sprites/mom_geisha.2bpp"
BrunetteGirlSprite:   INCBIN "gfx/sprites/brunette_girl.2bpp"
LanceSprite:          INCBIN "gfx/sprites/lance.2bpp"
MomSprite:            INCBIN "gfx/sprites/mom.2bpp"
BaldingGuySprite:     INCBIN "gfx/sprites/balding_guy.2bpp"
YoungBoySprite:       INCBIN "gfx/sprites/young_boy.2bpp"
GameboyKidSprite:     INCBIN "gfx/sprites/gameboy_kid.2bpp"
AgathaSprite:         INCBIN "gfx/sprites/agatha.2bpp"
BrunoSprite:          INCBIN "gfx/sprites/bruno.2bpp"
LoreleiSprite:        INCBIN "gfx/sprites/lorelei.2bpp"
SeelSprite:           INCBIN "gfx/sprites/seel.2bpp"


SECTION "Battle (bank 5)", ROMX, BANK[$5]

INCLUDE "engine/load_pokedex_tiles.asm"
INCLUDE "engine/overworld/map_sprites.asm"
INCLUDE "engine/overworld/emotion_bubbles.asm"
INCLUDE "engine/evolve_trade.asm"
INCLUDE "engine/battle/moveEffects/substitute_effect.asm"
INCLUDE "engine/menu/pc.asm"


SECTION "bank6",ROMX,BANK[$6]

INCLUDE "data/maps/headers/celadoncity.asm"
INCLUDE "data/maps/objects/celadoncity.asm"
CeladonCityBlocks: INCBIN "maps/celadoncity.blk"

INCLUDE "data/maps/headers/pallettown.asm"
INCLUDE "data/maps/objects/pallettown.asm"
PalletTownBlocks: INCBIN "maps/pallettown.blk"

INCLUDE "data/maps/headers/viridiancity.asm"
INCLUDE "data/maps/objects/viridiancity.asm"
ViridianCityBlocks: INCBIN "maps/viridiancity.blk"

INCLUDE "data/maps/headers/pewtercity.asm"
INCLUDE "data/maps/objects/pewtercity.asm"
PewterCityBlocks: INCBIN "maps/pewtercity.blk"

INCLUDE "data/maps/headers/ceruleancity.asm"
INCLUDE "data/maps/objects/ceruleancity.asm"
CeruleanCityBlocks: INCBIN "maps/ceruleancity.blk"

INCLUDE "data/maps/headers/vermilioncity.asm"
INCLUDE "data/maps/objects/vermilioncity.asm"
VermilionCityBlocks: INCBIN "maps/vermilioncity.blk"

INCLUDE "data/maps/headers/fuchsiacity.asm"
INCLUDE "data/maps/objects/fuchsiacity.asm"
FuchsiaCityBlocks: INCBIN "maps/fuchsiacity.blk"

INCLUDE "engine/play_time.asm"

INCLUDE "scripts/pallettown.asm"
INCLUDE "scripts/viridiancity.asm"
INCLUDE "scripts/pewtercity.asm"
INCLUDE "scripts/ceruleancity.asm"
INCLUDE "scripts/vermilioncity.asm"
INCLUDE "scripts/celadoncity.asm"
INCLUDE "scripts/fuchsiacity.asm"

INCLUDE "data/maps/headers/blueshouse.asm"
INCLUDE "scripts/blueshouse.asm"
INCLUDE "data/maps/objects/blueshouse.asm"
BluesHouseBlocks: INCBIN "maps/blueshouse.blk"

INCLUDE "data/maps/headers/vermilionhouse3.asm"
INCLUDE "scripts/vermilionhouse3.asm"
INCLUDE "data/maps/objects/vermilionhouse3.asm"
VermilionHouse3Blocks: INCBIN "maps/vermilionhouse3.blk"

INCLUDE "data/maps/headers/indigoplateaulobby.asm"
INCLUDE "scripts/indigoplateaulobby.asm"
INCLUDE "data/maps/objects/indigoplateaulobby.asm"
IndigoPlateauLobbyBlocks: INCBIN "maps/indigoplateaulobby.blk"

INCLUDE "data/maps/headers/silphco4.asm"
INCLUDE "scripts/silphco4.asm"
INCLUDE "data/maps/objects/silphco4.asm"
SilphCo4Blocks: INCBIN "maps/silphco4.blk"

INCLUDE "data/maps/headers/silphco5.asm"
INCLUDE "scripts/silphco5.asm"
INCLUDE "data/maps/objects/silphco5.asm"
SilphCo5Blocks: INCBIN "maps/silphco5.blk"

INCLUDE "data/maps/headers/silphco6.asm"
INCLUDE "scripts/silphco6.asm"
INCLUDE "data/maps/objects/silphco6.asm"
SilphCo6Blocks: INCBIN "maps/silphco6.blk"

INCLUDE "engine/overworld/npc_movement.asm"
INCLUDE "engine/overworld/doors.asm"
INCLUDE "engine/overworld/ledges.asm"


SECTION "bank7",ROMX,BANK[$7]

INCLUDE "data/maps/headers/cinnabarisland.asm"
INCLUDE "data/maps/objects/cinnabarisland.asm"
CinnabarIslandBlocks: INCBIN "maps/cinnabarisland.blk"

INCLUDE "data/maps/headers/route1.asm"
INCLUDE "data/maps/objects/route1.asm"
Route1Blocks: INCBIN "maps/route1.blk"

UndergroundPathEntranceRoute8Blocks: INCBIN "maps/undergroundpathentranceroute8.blk"

OaksLabBlocks: INCBIN "maps/oakslab.blk"

Route16HouseBlocks:
Route2HouseBlocks:
SaffronHouse1Blocks:
SaffronHouse2Blocks:
VermilionHouse1Blocks:
NameRaterBlocks:
LavenderHouse1Blocks:
LavenderHouse2Blocks:
CeruleanHouse1Blocks:
PewterHouse1Blocks:
PewterHouse2Blocks:
ViridianHouseBlocks: INCBIN "maps/viridianhouse.blk"

CeladonMansion5Blocks:
SchoolBlocks: INCBIN "maps/school.blk"

CeruleanHouseTrashedBlocks: INCBIN "maps/ceruleanhousetrashed.blk"

DiglettsCaveEntranceRoute11Blocks:
DiglettsCaveRoute2Blocks: INCBIN "maps/diglettscaveroute2.blk"

INCLUDE "text/monster_names.asm"

INCLUDE "engine/clear_save.asm"

INCLUDE "engine/predefs7.asm"

INCLUDE "scripts/cinnabarisland.asm"

INCLUDE "scripts/route1.asm"

INCLUDE "data/maps/headers/oakslab.asm"
INCLUDE "scripts/oakslab.asm"
INCLUDE "data/maps/objects/oakslab.asm"

INCLUDE "data/maps/headers/viridianmart.asm"
INCLUDE "scripts/viridianmart.asm"
INCLUDE "data/maps/objects/viridianmart.asm"
ViridianMartBlocks: INCBIN "maps/viridianmart.blk"

INCLUDE "data/maps/headers/school.asm"
INCLUDE "scripts/school.asm"
INCLUDE "data/maps/objects/school.asm"

INCLUDE "data/maps/headers/viridianhouse.asm"
INCLUDE "scripts/viridianhouse.asm"
INCLUDE "data/maps/objects/viridianhouse.asm"

INCLUDE "data/maps/headers/pewterhouse1.asm"
INCLUDE "scripts/pewterhouse1.asm"
INCLUDE "data/maps/objects/pewterhouse1.asm"

INCLUDE "data/maps/headers/pewterhouse2.asm"
INCLUDE "scripts/pewterhouse2.asm"
INCLUDE "data/maps/objects/pewterhouse2.asm"

INCLUDE "data/maps/headers/ceruleanhousetrashed.asm"
INCLUDE "scripts/ceruleanhousetrashed.asm"
INCLUDE "data/maps/objects/ceruleanhousetrashed.asm"

INCLUDE "data/maps/headers/ceruleanhouse1.asm"
INCLUDE "scripts/ceruleanhouse1.asm"
INCLUDE "data/maps/objects/ceruleanhouse1.asm"

INCLUDE "data/maps/headers/bikeshop.asm"
INCLUDE "scripts/bikeshop.asm"
INCLUDE "data/maps/objects/bikeshop.asm"
BikeShopBlocks: INCBIN "maps/bikeshop.blk"

INCLUDE "data/maps/headers/lavenderhouse1.asm"
INCLUDE "scripts/lavenderhouse1.asm"
INCLUDE "data/maps/objects/lavenderhouse1.asm"

INCLUDE "data/maps/headers/lavenderhouse2.asm"
INCLUDE "scripts/lavenderhouse2.asm"
INCLUDE "data/maps/objects/lavenderhouse2.asm"

INCLUDE "data/maps/headers/namerater.asm"
INCLUDE "scripts/namerater.asm"
INCLUDE "data/maps/objects/namerater.asm"

INCLUDE "data/maps/headers/vermilionhouse1.asm"
INCLUDE "scripts/vermilionhouse1.asm"
INCLUDE "data/maps/objects/vermilionhouse1.asm"

INCLUDE "data/maps/headers/vermiliondock.asm"
INCLUDE "scripts/vermiliondock.asm"
INCLUDE "data/maps/objects/vermiliondock.asm"
VermilionDockBlocks: INCBIN "maps/vermiliondock.blk"

INCLUDE "data/maps/headers/celadonmansion5.asm"
INCLUDE "scripts/celadonmansion5.asm"
INCLUDE "data/maps/objects/celadonmansion5.asm"

INCLUDE "data/maps/headers/fuchsiamart.asm"
INCLUDE "scripts/fuchsiamart.asm"
INCLUDE "data/maps/objects/fuchsiamart.asm"
FuchsiaMartBlocks: INCBIN "maps/fuchsiamart.blk"

INCLUDE "data/maps/headers/saffronhouse1.asm"
INCLUDE "scripts/saffronhouse1.asm"
INCLUDE "data/maps/objects/saffronhouse1.asm"

;joenote - adding Mateo's move relearner/deleter files
INCLUDE "scripts/move_deleter.asm"
INCLUDE "scripts/move_relearner.asm"

INCLUDE "data/maps/headers/saffronhouse2.asm"
INCLUDE "scripts/saffronhouse2.asm"
INCLUDE "data/maps/objects/saffronhouse2.asm"

INCLUDE "data/maps/headers/diglettscaveroute2.asm"
INCLUDE "scripts/diglettscaveroute2.asm"
INCLUDE "data/maps/objects/diglettscaveroute2.asm"

INCLUDE "data/maps/headers/route2house.asm"
INCLUDE "scripts/route2house.asm"
INCLUDE "data/maps/objects/route2house.asm"

INCLUDE "data/maps/headers/route5gate.asm"
INCLUDE "scripts/route5gate.asm"
INCLUDE "data/maps/objects/route5gate.asm"
Route5GateBlocks: INCBIN "maps/route5gate.blk"

INCLUDE "data/maps/headers/route6gate.asm"
INCLUDE "scripts/route6gate.asm"
INCLUDE "data/maps/objects/route6gate.asm"
Route6GateBlocks: INCBIN "maps/route6gate.blk"

INCLUDE "data/maps/headers/route7gate.asm"
INCLUDE "scripts/route7gate.asm"
INCLUDE "data/maps/objects/route7gate.asm"
Route7GateBlocks: INCBIN "maps/route7gate.blk"

INCLUDE "data/maps/headers/route8gate.asm"
INCLUDE "scripts/route8gate.asm"
INCLUDE "data/maps/objects/route8gate.asm"
Route8GateBlocks: INCBIN "maps/route8gate.blk"

INCLUDE "data/maps/headers/undergroundpathentranceroute8.asm"
INCLUDE "scripts/undergroundpathentranceroute8.asm"
INCLUDE "data/maps/objects/undergroundpathentranceroute8.asm"

INCLUDE "data/maps/headers/powerplant.asm"
INCLUDE "scripts/powerplant.asm"
INCLUDE "data/maps/objects/powerplant.asm"
PowerPlantBlocks: INCBIN "maps/powerplant.blk"

INCLUDE "data/maps/headers/diglettscaveroute11.asm"
INCLUDE "scripts/diglettscaveroute11.asm"
INCLUDE "data/maps/objects/diglettscaveroute11.asm"

INCLUDE "data/maps/headers/route16house.asm"
INCLUDE "scripts/route16house.asm"
INCLUDE "data/maps/objects/route16house.asm"

INCLUDE "data/maps/headers/route22gate.asm"
INCLUDE "scripts/route22gate.asm"
INCLUDE "data/maps/objects/route22gate.asm"
Route22GateBlocks: INCBIN "maps/route22gate.blk"

INCLUDE "data/maps/headers/billshouse.asm"
INCLUDE "scripts/billshouse.asm"
INCLUDE "data/maps/objects/billshouse.asm"
BillsHouseBlocks: INCBIN "maps/billshouse.blk"

INCLUDE "data/maps/headers/billsgarden.asm"
INCLUDE "scripts/billsgarden.asm"
INCLUDE "data/maps/objects/billsgarden.asm"
BillsGardenBlocks: INCBIN "maps/billsgarden.blk"

INCLUDE "data/maps/headers/volcano1f.asm"
INCLUDE "scripts/volcano1f.asm"
INCLUDE "data/maps/objects/volcano1f.asm"
Volcano1FBlocks: INCBIN "maps/volcano1f.blk"

INCLUDE "data/maps/headers/volcanob1f.asm"
INCLUDE "scripts/volcanob1f.asm"
INCLUDE "data/maps/objects/volcanob1f.asm"
VolcanoB1FBlocks: INCBIN "maps/volcanob1f.blk"

INCLUDE "data/maps/headers/volcanob2f.asm"
INCLUDE "scripts/volcanob2f.asm"
INCLUDE "data/maps/objects/volcanob2f.asm"
VolcanoB2FBlocks: INCBIN "maps/volcanob2f.blk"

INCLUDE "engine/menu/oaks_pc.asm"

INCLUDE "engine/hidden_object_functions7.asm"

INCLUDE "engine/debug/debug_menu.asm"
INCLUDE "engine/debug/debug_party.asm"

SECTION "Battle (bank 9)", ROMX, BANK[$9]
INCLUDE "engine/battle/print_type.asm"
INCLUDE "engine/battle/moveEffects/focus_energy_effect.asm"

;bank A stuff
INCLUDE "engine/battle/moveEffects/leech_seed_effect.asm"

;bank B stuff
INCLUDE "engine/battle/moveEffects/mist_effect.asm"
INCLUDE "engine/battle/moveEffects/one_hit_ko_effect.asm"

;bank C stuff
INCLUDE "engine/battle/display_effectiveness.asm"
TrainerInfoTextBoxTileGraphics:  INCBIN "gfx/tiles/trainer_info.2bpp"
TrainerInfoTextBoxTileGraphicsEnd:
CircleTile:                      INCBIN "gfx/tiles/circle_tile.2bpp"
BadgeNumbersTileGraphics:        INCBIN "gfx/tiles/badge_numbers.2bpp"
INCLUDE "engine/items/tmhm.asm"
INCLUDE "engine/battle/scale_sprites.asm"
INCLUDE "engine/battle/moveEffects/pay_day_effect.asm"
INCLUDE "engine/game_corner_slots2.asm"

;bank D stuff
INCLUDE "engine/titlescreen2.asm"
INCLUDE "engine/battle/link_battle_versus_text.asm"
INCLUDE "engine/slot_machine.asm"
INCLUDE "engine/overworld/pewter_guys.asm"
INCLUDE "engine/multiply_divide.asm"
INCLUDE "engine/game_corner_slots.asm"

SECTION "Battle (bank A)", ROMX, BANK[$A]
;migrated content to bank 9

SECTION "Battle (bank B)", ROMX, BANK[$B]
;migrated content to bank 9

SECTION "Battle (bank C)", ROMX, BANK[$C]
;migrated content to bank 9

SECTION "Battle (bank D)", ROMX, BANK[$D]
;migrated content to bank 9

SECTION "bankE",ROMX,BANK[$E]

INCLUDE "data/moves/moves.asm"
BaseStats: INCLUDE "data/pokemons/base_stats.asm"
INCLUDE "data/pokemons/cries.asm"
INCLUDE "engine/battle/scroll_draw_trainer_pic.asm"
INCLUDE "engine/battle/trainer_ai.asm"
INCLUDE "engine/battle/draw_hud_pokeball_gfx.asm"
INCLUDE "engine/evos_moves.asm"
INCLUDE "engine/battle/moveEffects/heal_effect.asm"
INCLUDE "engine/battle/moveEffects/transform_effect.asm"
INCLUDE "engine/battle/moveEffects/reflect_light_screen_effect.asm"
INCLUDE "engine/battle/moveEffects/trapping_effect.asm"

SECTION "bankF",ROMX,BANK[$F]

INCLUDE "engine/battle/core.asm"
INCLUDE "engine/battle/effects.asm"

SECTION "bank10",ROMX,BANK[$10]

INCLUDE "engine/menu/pokedex.asm"
INCLUDE "engine/trade.asm"
INCLUDE "engine/intro.asm"
INCLUDE "engine/trade2.asm"
INCLUDE "engine/menu/movedex.asm"
INCLUDE "data/moves/movedex_type_palettes.asm"


SECTION "bank11",ROMX,BANK[$11]

INCLUDE "data/maps/headers/lavendertown.asm"
INCLUDE "data/maps/objects/lavendertown.asm"
LavenderTownBlocks: INCBIN "maps/lavendertown.blk"

ViridianPokecenterBlocks: INCBIN "maps/viridianpokecenter.blk"

SafariZoneRestHouse1Blocks:
SafariZoneRestHouse2Blocks:
SafariZoneRestHouse3Blocks:
SafariZoneRestHouse4Blocks: INCBIN "maps/safarizoneresthouse1.blk"

INCLUDE "scripts/lavendertown.asm"

INCLUDE "engine/pokedex_rating.asm"

INCLUDE "data/maps/headers/viridianpokecenter.asm"
INCLUDE "scripts/viridianpokecenter.asm"
INCLUDE "data/maps/objects/viridianpokecenter.asm"

INCLUDE "data/maps/headers/mansion1.asm"
INCLUDE "scripts/mansion1.asm"
INCLUDE "data/maps/objects/mansion1.asm"
Mansion1Blocks: INCBIN "maps/mansion1.blk"

INCLUDE "data/maps/headers/rocktunnel1.asm"
INCLUDE "scripts/rocktunnel1.asm"
INCLUDE "data/maps/objects/rocktunnel1.asm"
RockTunnel1Blocks: INCBIN "maps/rocktunnel1.blk"

INCLUDE "data/maps/headers/seafoamislands1.asm"
INCLUDE "scripts/seafoamislands1.asm"
INCLUDE "data/maps/objects/seafoamislands1.asm"
SeafoamIslands1Blocks: INCBIN "maps/seafoamislands1.blk"

INCLUDE "data/maps/headers/ssanne3.asm"
INCLUDE "scripts/ssanne3.asm"
INCLUDE "data/maps/objects/ssanne3.asm"
SSAnne3Blocks: INCBIN "maps/ssanne3.blk"

INCLUDE "data/maps/headers/victoryroad3.asm"
INCLUDE "scripts/victoryroad3.asm"
INCLUDE "data/maps/objects/victoryroad3.asm"
VictoryRoad3Blocks: INCBIN "maps/victoryroad3.blk"

INCLUDE "data/maps/headers/rockethideout1.asm"
INCLUDE "scripts/rockethideout1.asm"
INCLUDE "data/maps/objects/rockethideout1.asm"
RocketHideout1Blocks: INCBIN "maps/rockethideout1.blk"

INCLUDE "data/maps/headers/rockethideout2.asm"
INCLUDE "scripts/rockethideout2.asm"
INCLUDE "data/maps/objects/rockethideout2.asm"
RocketHideout2Blocks: INCBIN "maps/rockethideout2.blk"

INCLUDE "data/maps/headers/rockethideout3.asm"
INCLUDE "scripts/rockethideout3.asm"
INCLUDE "data/maps/objects/rockethideout3.asm"
RocketHideout3Blocks: INCBIN "maps/rockethideout3.blk"

INCLUDE "data/maps/headers/rockethideout4.asm"
INCLUDE "scripts/rockethideout4.asm"
INCLUDE "data/maps/objects/rockethideout4.asm"
RocketHideout4Blocks: INCBIN "maps/rockethideout4.blk"

INCLUDE "data/maps/headers/rockethideoutelevator.asm"
INCLUDE "scripts/rockethideoutelevator.asm"
INCLUDE "data/maps/objects/rockethideoutelevator.asm"
RocketHideoutElevatorBlocks: INCBIN "maps/rockethideoutelevator.blk"

INCLUDE "data/maps/headers/silphcoelevator.asm"
INCLUDE "scripts/silphcoelevator.asm"
INCLUDE "data/maps/objects/silphcoelevator.asm"
SilphCoElevatorBlocks: INCBIN "maps/silphcoelevator.blk"

INCLUDE "data/maps/headers/safarizoneeast.asm"
INCLUDE "scripts/safarizoneeast.asm"
INCLUDE "data/maps/objects/safarizoneeast.asm"
SafariZoneEastBlocks: INCBIN "maps/safarizoneeast.blk"

INCLUDE "data/maps/headers/safarizonenorth.asm"
INCLUDE "scripts/safarizonenorth.asm"
INCLUDE "data/maps/objects/safarizonenorth.asm"
SafariZoneNorthBlocks: INCBIN "maps/safarizonenorth.blk"

INCLUDE "data/maps/headers/safarizonecenter.asm"
INCLUDE "scripts/safarizonecenter.asm"
INCLUDE "data/maps/objects/safarizonecenter.asm"
SafariZoneCenterBlocks: INCBIN "maps/safarizonecenter.blk"

INCLUDE "data/maps/headers/safarizoneresthouse1.asm"
INCLUDE "scripts/safarizoneresthouse1.asm"
INCLUDE "data/maps/objects/safarizoneresthouse1.asm"

INCLUDE "data/maps/headers/safarizoneresthouse2.asm"
INCLUDE "scripts/safarizoneresthouse2.asm"
INCLUDE "data/maps/objects/safarizoneresthouse2.asm"

INCLUDE "data/maps/headers/safarizoneresthouse3.asm"
INCLUDE "scripts/safarizoneresthouse3.asm"
INCLUDE "data/maps/objects/safarizoneresthouse3.asm"

INCLUDE "data/maps/headers/safarizoneresthouse4.asm"
INCLUDE "scripts/safarizoneresthouse4.asm"
INCLUDE "data/maps/objects/safarizoneresthouse4.asm"

INCLUDE "data/maps/headers/unknowndungeon2.asm"
INCLUDE "scripts/unknowndungeon2.asm"
INCLUDE "data/maps/objects/unknowndungeon2.asm"
UnknownDungeon2Blocks: INCBIN "maps/unknowndungeon2.blk"

INCLUDE "data/maps/headers/unknowndungeon3.asm"
INCLUDE "scripts/unknowndungeon3.asm"
INCLUDE "data/maps/objects/unknowndungeon3.asm"
UnknownDungeon3Blocks: INCBIN "maps/unknowndungeon3.blk"

INCLUDE "data/maps/headers/rocktunnel2.asm"
INCLUDE "scripts/rocktunnel2.asm"
INCLUDE "data/maps/objects/rocktunnel2.asm"
RockTunnel2Blocks: INCBIN "maps/rocktunnel2.blk"

INCLUDE "data/maps/headers/seafoamislands2.asm"
INCLUDE "scripts/seafoamislands2.asm"
INCLUDE "data/maps/objects/seafoamislands2.asm"
SeafoamIslands2Blocks: INCBIN "maps/seafoamislands2.blk"

INCLUDE "data/maps/headers/seafoamislands3.asm"
INCLUDE "scripts/seafoamislands3.asm"
INCLUDE "data/maps/objects/seafoamislands3.asm"
SeafoamIslands3Blocks: INCBIN "maps/seafoamislands3.blk"

INCLUDE "data/maps/headers/seafoamislands4.asm"
INCLUDE "scripts/seafoamislands4.asm"
INCLUDE "data/maps/objects/seafoamislands4.asm"
SeafoamIslands4Blocks: INCBIN "maps/seafoamislands4.blk"

INCLUDE "data/maps/headers/seafoamislands5.asm"
INCLUDE "scripts/seafoamislands5.asm"
INCLUDE "data/maps/objects/seafoamislands5.asm"
SeafoamIslands5Blocks: INCBIN "maps/seafoamislands5.blk"

INCLUDE "engine/overworld/hidden_objects.asm"


SECTION "bank12",ROMX,BANK[$12]

INCLUDE "data/maps/headers/route7.asm"
INCLUDE "data/maps/objects/route7.asm"
Route7Blocks: INCBIN "maps/route7.blk"

CeladonPokecenterBlocks:
RockTunnelPokecenterBlocks:
MtMoonPokecenterBlocks: INCBIN "maps/mtmoonpokecenter.blk"

Route18GateBlocks:
Route15GateBlocks:
Route11GateBlocks: INCBIN "maps/route11gate.blk"

Route18GateUpstairsBlocks:
Route16GateUpstairsBlocks:
Route12GateUpstairsBlocks:
Route15GateUpstairsBlocks:
Route11GateUpstairsBlocks: INCBIN "maps/route11gateupstairs.blk"

INCLUDE "engine/predefs12.asm"

INCLUDE "scripts/route7.asm"

INCLUDE "data/maps/headers/redshouse1f.asm"
INCLUDE "scripts/redshouse1f.asm"
INCLUDE "data/maps/objects/redshouse1f.asm"
RedsHouse1FBlocks: INCBIN "maps/redshouse1f.blk"

INCLUDE "data/maps/headers/celadonmart3.asm"
INCLUDE "scripts/celadonmart3.asm"
INCLUDE "data/maps/objects/celadonmart3.asm"
CeladonMart3Blocks: INCBIN "maps/celadonmart3.blk"

INCLUDE "data/maps/headers/celadonmart4.asm"
INCLUDE "scripts/celadonmart4.asm"
INCLUDE "data/maps/objects/celadonmart4.asm"
CeladonMart4Blocks: INCBIN "maps/celadonmart4.blk"

INCLUDE "data/maps/headers/celadonmartroof.asm"
INCLUDE "scripts/celadonmartroof.asm"
INCLUDE "data/maps/objects/celadonmartroof.asm"
CeladonMartRoofBlocks: INCBIN "maps/celadonmartroof.blk"

INCLUDE "data/maps/headers/celadonmartelevator.asm"
INCLUDE "scripts/celadonmartelevator.asm"
INCLUDE "data/maps/objects/celadonmartelevator.asm"
CeladonMartElevatorBlocks: INCBIN "maps/celadonmartelevator.blk"

INCLUDE "data/maps/headers/celadonmansion1.asm"
INCLUDE "scripts/celadonmansion1.asm"
INCLUDE "data/maps/objects/celadonmansion1.asm"
CeladonMansion1Blocks: INCBIN "maps/celadonmansion1.blk"

INCLUDE "data/maps/headers/celadonmansion2.asm"
INCLUDE "scripts/celadonmansion2.asm"
INCLUDE "data/maps/objects/celadonmansion2.asm"
CeladonMansion2Blocks: INCBIN "maps/celadonmansion2.blk"

INCLUDE "data/maps/headers/celadonmansion3.asm"
INCLUDE "scripts/celadonmansion3.asm"
INCLUDE "data/maps/objects/celadonmansion3.asm"
CeladonMansion3Blocks: INCBIN "maps/celadonmansion3.blk"

INCLUDE "data/maps/headers/celadonmansion4.asm"
INCLUDE "scripts/celadonmansion4.asm"
INCLUDE "data/maps/objects/celadonmansion4.asm"
CeladonMansion4Blocks: INCBIN "maps/celadonmansion4.blk"

INCLUDE "data/maps/headers/celadonpokecenter.asm"
INCLUDE "scripts/celadonpokecenter.asm"
INCLUDE "data/maps/objects/celadonpokecenter.asm"

INCLUDE "data/maps/headers/celadongym.asm"
INCLUDE "scripts/celadongym.asm"
INCLUDE "data/maps/objects/celadongym.asm"
CeladonGymBlocks: INCBIN "maps/celadongym.blk"

INCLUDE "data/maps/headers/celadongamecorner.asm"
INCLUDE "scripts/celadongamecorner.asm"
INCLUDE "data/maps/objects/celadongamecorner.asm"
CeladonGameCornerBlocks: INCBIN "maps/celadongamecorner.blk"

INCLUDE "data/maps/headers/celadonmart5.asm"
INCLUDE "scripts/celadonmart5.asm"
INCLUDE "data/maps/objects/celadonmart5.asm"
CeladonMart5Blocks: INCBIN "maps/celadonmart5.blk"

INCLUDE "data/maps/headers/celadonprizeroom.asm"
INCLUDE "scripts/celadonprizeroom.asm"
INCLUDE "data/maps/objects/celadonprizeroom.asm"
CeladonPrizeRoomBlocks: INCBIN "maps/celadonprizeroom.blk"

INCLUDE "data/maps/headers/celadondiner.asm"
INCLUDE "scripts/celadondiner.asm"
INCLUDE "data/maps/objects/celadondiner.asm"
CeladonDinerBlocks: INCBIN "maps/celadondiner.blk"

INCLUDE "data/maps/headers/celadonhouse.asm"
INCLUDE "scripts/celadonhouse.asm"
INCLUDE "data/maps/objects/celadonhouse.asm"
CeladonHouseBlocks: INCBIN "maps/celadonhouse.blk"

INCLUDE "data/maps/headers/celadonhotel.asm"
INCLUDE "scripts/celadonhotel.asm"
INCLUDE "data/maps/objects/celadonhotel.asm"
CeladonHotelBlocks: INCBIN "maps/celadonhotel.blk"

INCLUDE "data/maps/headers/mtmoonpokecenter.asm"
INCLUDE "scripts/mtmoonpokecenter.asm"
INCLUDE "data/maps/objects/mtmoonpokecenter.asm"

INCLUDE "data/maps/headers/rocktunnelpokecenter.asm"
INCLUDE "scripts/rocktunnelpokecenter.asm"
INCLUDE "data/maps/objects/rocktunnelpokecenter.asm"

INCLUDE "data/maps/headers/route11gate.asm"
INCLUDE "scripts/route11gate.asm"
INCLUDE "data/maps/objects/route11gate.asm"

INCLUDE "data/maps/headers/route11gateupstairs.asm"
INCLUDE "scripts/route11gateupstairs.asm"
INCLUDE "data/maps/objects/route11gateupstairs.asm"

INCLUDE "data/maps/headers/route12gate.asm"
INCLUDE "scripts/route12gate.asm"
INCLUDE "data/maps/objects/route12gate.asm"
Route12GateBlocks: INCBIN "maps/route12gate.blk"

INCLUDE "data/maps/headers/route12gateupstairs.asm"
INCLUDE "scripts/route12gateupstairs.asm"
INCLUDE "data/maps/objects/route12gateupstairs.asm"

INCLUDE "data/maps/headers/route15gate.asm"
INCLUDE "scripts/route15gate.asm"
INCLUDE "data/maps/objects/route15gate.asm"

INCLUDE "data/maps/headers/route15gateupstairs.asm"
INCLUDE "scripts/route15gateupstairs.asm"
INCLUDE "data/maps/objects/route15gateupstairs.asm"

INCLUDE "data/maps/headers/route16gate.asm"
INCLUDE "scripts/route16gate.asm"
INCLUDE "data/maps/objects/route16gate.asm"
Route16GateBlocks: INCBIN "maps/route16gate.blk"

INCLUDE "data/maps/headers/route16gateupstairs.asm"
INCLUDE "scripts/route16gateupstairs.asm"
INCLUDE "data/maps/objects/route16gateupstairs.asm"

INCLUDE "data/maps/headers/route18gate.asm"
INCLUDE "scripts/route18gate.asm"
INCLUDE "data/maps/objects/route18gate.asm"

INCLUDE "data/maps/headers/route18gateupstairs.asm"
INCLUDE "scripts/route18gateupstairs.asm"
INCLUDE "data/maps/objects/route18gateupstairs.asm"

INCLUDE "data/maps/headers/mtmoon1f.asm"
INCLUDE "scripts/mtmoon1f.asm"
INCLUDE "data/maps/objects/mtmoon1f.asm"
MtMoon1FBlocks: INCBIN "maps/mtmoon1f.blk"

INCLUDE "data/maps/headers/mtmoonb2f.asm"
INCLUDE "scripts/mtmoonb2f.asm"
INCLUDE "data/maps/objects/mtmoonb2f.asm"
MtMoonB2FBlocks: INCBIN "maps/mtmoonb2f.blk"

INCLUDE "data/maps/headers/safarizonewest.asm"
INCLUDE "scripts/safarizonewest.asm"
INCLUDE "data/maps/objects/safarizonewest.asm"
SafariZoneWestBlocks: INCBIN "maps/safarizonewest.blk"

INCLUDE "data/maps/headers/safarizonesecrethouse.asm"
INCLUDE "scripts/safarizonesecrethouse.asm"
INCLUDE "data/maps/objects/safarizonesecrethouse.asm"
SafariZoneSecretHouseBlocks: INCBIN "maps/safarizonesecrethouse.blk"


SECTION "bank13",ROMX,BANK[$13]

SECTION "Trainer Pics 1", ROMX
YoungsterPic::     INCBIN "gfx/trainer/youngster.pic"
BugCatcherPic::    INCBIN "gfx/trainer/bugcatcher.pic"
LassPic::          INCBIN "gfx/trainer/lass.pic"
SailorPic::        INCBIN "gfx/trainer/sailor.pic"
JrTrainerMPic::    INCBIN "gfx/trainer/jr.trainerm.pic"
JrTrainerFPic::    INCBIN "gfx/trainer/jr.trainerf.pic"
PokemaniacPic::    INCBIN "gfx/trainer/pokemaniac.pic"
SuperNerdPic::     INCBIN "gfx/trainer/supernerd.pic"
HikerPic::         INCBIN "gfx/trainer/hiker.pic"
BikerPic::         INCBIN "gfx/trainer/biker.pic"
BurglarPic::       INCBIN "gfx/trainer/burglar.pic"
EngineerPic::      INCBIN "gfx/trainer/engineer.pic"
FisherPic::        INCBIN "gfx/trainer/fisher.pic"
SwimmerPic::       INCBIN "gfx/trainer/swimmer.pic"
CueBallPic::       INCBIN "gfx/trainer/cueball.pic"
GamblerPic::       INCBIN "gfx/trainer/gambler.pic"
BeautyPic::        INCBIN "gfx/trainer/beauty.pic"
PsychicPic::       INCBIN "gfx/trainer/psychic.pic"
RockerPic::        INCBIN "gfx/trainer/rocker.pic"
JugglerPic::       INCBIN "gfx/trainer/juggler.pic"
TamerPic::         INCBIN "gfx/trainer/tamer.pic"
BirdKeeperPic::    INCBIN "gfx/trainer/birdkeeper.pic"
BlackbeltPic::     INCBIN "gfx/trainer/blackbelt.pic"
Rival1Pic::        INCBIN "gfx/trainer/rival1.pic"


SECTION "bank14",ROMX,BANK[$14]

INCLUDE "data/maps/headers/route22.asm"
INCLUDE "data/maps/objects/route22.asm"
Route22Blocks: INCBIN "maps/route22.blk"

INCLUDE "data/maps/headers/route20.asm"
INCLUDE "data/maps/objects/route20.asm"
Route20Blocks: INCBIN "maps/route20.blk"

INCLUDE "data/maps/headers/route23.asm"
INCLUDE "data/maps/objects/route23.asm"
Route23Blocks: INCBIN "maps/route23.blk"

INCLUDE "data/maps/headers/route24.asm"
INCLUDE "data/maps/objects/route24.asm"
Route24Blocks: INCBIN "maps/route24.blk"

INCLUDE "data/maps/headers/route25.asm"
INCLUDE "data/maps/objects/route25.asm"
Route25Blocks: INCBIN "maps/route25.blk"

INCLUDE "data/maps/headers/indigoplateau.asm"
INCLUDE "scripts/indigoplateau.asm"
INCLUDE "data/maps/objects/indigoplateau.asm"
IndigoPlateauBlocks: INCBIN "maps/indigoplateau.blk"

INCLUDE "data/maps/headers/saffroncity.asm"
INCLUDE "data/maps/objects/saffroncity.asm"
SaffronCityBlocks: INCBIN "maps/saffroncity.blk"
INCLUDE "scripts/saffroncity.asm"

INCLUDE "scripts/route20.asm"
INCLUDE "scripts/route22.asm"
INCLUDE "scripts/route23.asm"
INCLUDE "scripts/route24.asm"
INCLUDE "scripts/route25.asm"

INCLUDE "data/maps/headers/victoryroad2.asm"
INCLUDE "scripts/victoryroad2.asm"
INCLUDE "data/maps/objects/victoryroad2.asm"
VictoryRoad2Blocks: INCBIN "maps/victoryroad2.blk"

INCLUDE "data/maps/headers/mtmoonb1f.asm"
INCLUDE "scripts/mtmoonb1f.asm"
INCLUDE "data/maps/objects/mtmoonb1f.asm"
MtMoonB1FBlocks: INCBIN "maps/mtmoonb1f.blk"

INCLUDE "data/maps/headers/silphco7.asm"
INCLUDE "scripts/silphco7.asm"
INCLUDE "data/maps/objects/silphco7.asm"
SilphCo7Blocks: INCBIN "maps/silphco7.blk"

INCLUDE "data/maps/headers/mansion2.asm"
INCLUDE "scripts/mansion2.asm"
INCLUDE "data/maps/objects/mansion2.asm"
Mansion2Blocks: INCBIN "maps/mansion2.blk"

INCLUDE "data/maps/headers/mansion3.asm"
INCLUDE "scripts/mansion3.asm"
INCLUDE "data/maps/objects/mansion3.asm"
Mansion3Blocks: INCBIN "maps/mansion3.blk"

INCLUDE "data/maps/headers/mansion4.asm"
INCLUDE "scripts/mansion4.asm"
INCLUDE "data/maps/objects/mansion4.asm"
Mansion4Blocks: INCBIN "maps/mansion4.blk"

INCLUDE "engine/battle/init_battle_variables.asm"
INCLUDE "engine/battle/moveEffects/paralyze_effect.asm"

INCLUDE "engine/overworld/card_key.asm"

INCLUDE "engine/menu/prize_menu.asm"

INCLUDE "engine/hidden_object_functions14.asm"

SECTION "Trainer Pics 2", ROMX
ProfOakPic::       INCBIN "gfx/trainer/prof.oak.pic"
ChiefPic::		   INCBIN "gfx/trainer/chief.pic"	;joenote - not enough rom space
ScientistPic::     INCBIN "gfx/trainer/scientist.pic"
GiovanniPic::      INCBIN "gfx/trainer/giovanni.pic"
RocketPic::        INCBIN "gfx/trainer/rocket.pic"
CooltrainerMPic::  INCBIN "gfx/trainer/cooltrainerm.pic"
CooltrainerFPic::  INCBIN "gfx/trainer/cooltrainerf.pic"
BrunoPic::         INCBIN "gfx/trainer/bruno.pic"
BrockPic::         INCBIN "gfx/trainer/brock.pic"
MistyPic::         INCBIN "gfx/trainer/misty.pic"
LtSurgePic::       INCBIN "gfx/trainer/lt.surge.pic"
ErikaPic::         INCBIN "gfx/trainer/erika.pic"	;joenote - use her yellow sprite to ditch the funerary clothes
KogaPic::          INCBIN "gfx/trainer/koga.pic"
BlainePic::        INCBIN "gfx/trainer/blaine.pic"
SabrinaPic::       INCBIN "gfx/trainer/sabrina.pic"
GentlemanPic::     INCBIN "gfx/trainer/gentleman.pic"
Rival2Pic::        INCBIN "gfx/trainer/rival2.pic"
Rival3Pic::        INCBIN "gfx/trainer/rival3.pic"
LoreleiPic::       INCBIN "gfx/trainer/lorelei.pic"
ChannelerPic::     INCBIN "gfx/trainer/channeler.pic"
AgathaPic::        INCBIN "gfx/trainer/agatha.pic"
LancePic::         INCBIN "gfx/trainer/lance.pic"
JaninePic::        INCBIN "gfx/trainer/janine.pic"
JennyPic::         INCBIN "gfx/trainer/jenny.pic"
JoyPic::           INCBIN "gfx/trainer/joy.pic"
JessieJamesPic::   INCBIN "gfx/trainer/jessiejames.pic"
MFujiPic::         INCBIN "gfx/trainer/mfuji.pic"
SachaPic::         INCBIN "gfx/trainer/sacha.pic"
SoldierPic::       INCBIN "gfx/trainer/soldier.pic"

SECTION "bank15",ROMX,BANK[$15]

INCLUDE "data/maps/headers/route2.asm"
INCLUDE "data/maps/objects/route2.asm"
Route2Blocks: INCBIN "maps/route2.blk"

INCLUDE "data/maps/headers/route3.asm"
INCLUDE "data/maps/objects/route3.asm"
Route3Blocks: INCBIN "maps/route3.blk"

INCLUDE "data/maps/headers/route4.asm"
INCLUDE "data/maps/objects/route4.asm"
Route4Blocks: INCBIN "maps/route4.blk"

INCLUDE "data/maps/headers/route5.asm"
INCLUDE "data/maps/objects/route5.asm"
Route5Blocks: INCBIN "maps/route5.blk"

INCLUDE "data/maps/headers/route9.asm"
INCLUDE "data/maps/objects/route9.asm"
Route9Blocks: INCBIN "maps/route9.blk"

INCLUDE "data/maps/headers/route13.asm"
INCLUDE "data/maps/objects/route13.asm"
Route13Blocks: INCBIN "maps/route13.blk"

INCLUDE "data/maps/headers/route14.asm"
INCLUDE "data/maps/objects/route14.asm"
Route14Blocks: INCBIN "maps/route14.blk"

INCLUDE "data/maps/headers/route17.asm"
INCLUDE "data/maps/objects/route17.asm"
Route17Blocks: INCBIN "maps/route17.blk"

INCLUDE "data/maps/headers/route19.asm"
INCLUDE "data/maps/objects/route19.asm"
Route19Blocks: INCBIN "maps/route19.blk"

INCLUDE "data/maps/headers/route21.asm"
INCLUDE "data/maps/objects/route21.asm"
Route21Blocks: INCBIN "maps/route21.blk"

VermilionHouse2Blocks: INCBIN "maps/vermilionhouse2.blk"
Route12HouseBlocks: INCBIN "maps/route12house.blk"
DayCareMBlocks: INCBIN "maps/daycarem.blk"

FuchsiaHouse3Blocks: INCBIN "maps/fuchsiahouse3.blk"

INCLUDE "engine/battle/experience.asm"

INCLUDE "scripts/route2.asm"
INCLUDE "scripts/route3.asm"
INCLUDE "scripts/route4.asm"
INCLUDE "scripts/route5.asm"
INCLUDE "scripts/route9.asm"
INCLUDE "scripts/route13.asm"
INCLUDE "scripts/route14.asm"
INCLUDE "scripts/route17.asm"
INCLUDE "scripts/route19.asm"
INCLUDE "scripts/route21.asm"

INCLUDE "data/maps/headers/vermilionhouse2.asm"
INCLUDE "scripts/vermilionhouse2.asm"
INCLUDE "data/maps/objects/vermilionhouse2.asm"

INCLUDE "data/maps/headers/celadonmart2.asm"
INCLUDE "scripts/celadonmart2.asm"
INCLUDE "data/maps/objects/celadonmart2.asm"
CeladonMart2Blocks: INCBIN "maps/celadonmart2.blk"

INCLUDE "data/maps/headers/fuchsiahouse3.asm"
INCLUDE "scripts/fuchsiahouse3.asm"
INCLUDE "data/maps/objects/fuchsiahouse3.asm"

INCLUDE "data/maps/headers/daycarem.asm"
INCLUDE "scripts/daycarem.asm"
INCLUDE "data/maps/objects/daycarem.asm"

INCLUDE "data/maps/headers/route12house.asm"
INCLUDE "scripts/route12house.asm"
INCLUDE "data/maps/objects/route12house.asm"

INCLUDE "data/maps/headers/silphco8.asm"
INCLUDE "scripts/silphco8.asm"
INCLUDE "data/maps/objects/silphco8.asm"
SilphCo8Blocks: INCBIN "maps/silphco8.blk"

INCLUDE "engine/menu/diploma.asm"

INCLUDE "engine/overworld/trainers.asm"


SECTION "bank16",ROMX,BANK[$16]

INCLUDE "data/maps/headers/route6.asm"
INCLUDE "data/maps/objects/route6.asm"
Route6Blocks: INCBIN "maps/route6.blk"

INCLUDE "data/maps/headers/route8.asm"
INCLUDE "data/maps/objects/route8.asm"
Route8Blocks: INCBIN "maps/route8.blk"

INCLUDE "data/maps/headers/route10.asm"
INCLUDE "data/maps/objects/route10.asm"
Route10Blocks: INCBIN "maps/route10.blk"

INCLUDE "data/maps/headers/route11.asm"
INCLUDE "data/maps/objects/route11.asm"
Route11Blocks: INCBIN "maps/route11.blk"

INCLUDE "data/maps/headers/route12.asm"
INCLUDE "data/maps/objects/route12.asm"
Route12Blocks: INCBIN "maps/route12.blk"

INCLUDE "data/maps/headers/route15.asm"
INCLUDE "data/maps/objects/route15.asm"
Route15Blocks: INCBIN "maps/route15.blk"

INCLUDE "data/maps/headers/route16.asm"
INCLUDE "data/maps/objects/route16.asm"
Route16Blocks: INCBIN "maps/route16.blk"

INCLUDE "data/maps/headers/route18.asm"
INCLUDE "data/maps/objects/route18.asm"
Route18Blocks: INCBIN "maps/route18.blk"

	INCBIN "maps/unusedblocks58d7d.blk"

INCLUDE "engine/battle/common_text.asm"

INCLUDE "engine/experience.asm"

INCLUDE "engine/overworld/oaks_aide.asm"

INCLUDE "scripts/route6.asm"
INCLUDE "scripts/route8.asm"
INCLUDE "scripts/route10.asm"
INCLUDE "scripts/route11.asm"
INCLUDE "scripts/route12.asm"
INCLUDE "scripts/route15.asm"
INCLUDE "scripts/route16.asm"
INCLUDE "scripts/route18.asm"

INCLUDE "data/maps/headers/fanclub.asm"
INCLUDE "scripts/fanclub.asm"
INCLUDE "data/maps/objects/fanclub.asm"
FanClubBlocks: INCBIN "maps/fanclub.blk"

INCLUDE "data/maps/headers/silphco2.asm"
INCLUDE "scripts/silphco2.asm"
INCLUDE "data/maps/objects/silphco2.asm"
SilphCo2Blocks: INCBIN "maps/silphco2.blk"

INCLUDE "data/maps/headers/silphco3.asm"
INCLUDE "scripts/silphco3.asm"
INCLUDE "data/maps/objects/silphco3.asm"
SilphCo3Blocks: INCBIN "maps/silphco3.blk"

INCLUDE "data/maps/headers/silphco10.asm"
INCLUDE "scripts/silphco10.asm"
INCLUDE "data/maps/objects/silphco10.asm"
SilphCo10Blocks: INCBIN "maps/silphco10.blk"

INCLUDE "data/maps/headers/lance.asm"
INCLUDE "scripts/lance.asm"
INCLUDE "data/maps/objects/lance.asm"
LanceBlocks: INCBIN "maps/lance.blk"

INCLUDE "data/maps/headers/halloffameroom.asm"
INCLUDE "scripts/halloffameroom.asm"
INCLUDE "data/maps/objects/halloffameroom.asm"
HallofFameRoomBlocks: INCBIN "maps/halloffameroom.blk"

INCLUDE "engine/overworld/saffron_guards.asm"


SECTION "bank17",ROMX,BANK[$17]

SaffronMartBlocks:
LavenderMartBlocks:
CeruleanMartBlocks:
VermilionMartBlocks: INCBIN "maps/vermilionmart.blk"

CopycatsHouse2FBlocks:
RedsHouse2FBlocks: INCBIN "maps/redshouse2f.blk"

Museum1FBlocks: INCBIN "maps/museum1f.blk"

Museum2FBlocks: INCBIN "maps/museum2f.blk"

SaffronPokecenterBlocks:
VermilionPokecenterBlocks:
LavenderPokecenterBlocks:
PewterPokecenterBlocks: INCBIN "maps/pewterpokecenter.blk"

UndergroundPathEntranceRoute7Blocks:
UndergroundPathEntranceRoute7CopyBlocks:
UndergroundPathEntranceRoute6Blocks:
UndergroundPathEntranceRoute5Blocks: INCBIN "maps/undergroundpathentranceroute5.blk"

Route2GateBlocks:
ViridianForestEntranceBlocks:
ViridianForestExitBlocks: INCBIN "maps/viridianforestexit.blk"

INCLUDE "data/maps/headers/redshouse2f.asm"
INCLUDE "scripts/redshouse2f.asm"
INCLUDE "data/maps/objects/redshouse2f.asm"

INCLUDE "engine/predefs17.asm"

INCLUDE "data/maps/headers/museum1f.asm"
INCLUDE "scripts/museum1f.asm"
INCLUDE "data/maps/objects/museum1f.asm"

INCLUDE "data/maps/headers/museum2f.asm"
INCLUDE "scripts/museum2f.asm"
INCLUDE "data/maps/objects/museum2f.asm"

INCLUDE "data/maps/headers/pewtergym.asm"
INCLUDE "scripts/pewtergym.asm"
INCLUDE "data/maps/objects/pewtergym.asm"
PewterGymBlocks: INCBIN "maps/pewtergym.blk"

INCLUDE "data/maps/headers/pewterpokecenter.asm"
INCLUDE "scripts/pewterpokecenter.asm"
INCLUDE "data/maps/objects/pewterpokecenter.asm"

INCLUDE "data/maps/headers/ceruleanpokecenter.asm"
INCLUDE "scripts/ceruleanpokecenter.asm"
INCLUDE "data/maps/objects/ceruleanpokecenter.asm"
CeruleanPokecenterBlocks: INCBIN "maps/ceruleanpokecenter.blk"

INCLUDE "data/maps/headers/ceruleangym.asm"
INCLUDE "scripts/ceruleangym.asm"
INCLUDE "data/maps/objects/ceruleangym.asm"
CeruleanGymBlocks: INCBIN "maps/ceruleangym.blk"

INCLUDE "data/maps/headers/ceruleanmart.asm"
INCLUDE "scripts/ceruleanmart.asm"
INCLUDE "data/maps/objects/ceruleanmart.asm"

INCLUDE "data/maps/headers/lavenderpokecenter.asm"
INCLUDE "scripts/lavenderpokecenter.asm"
INCLUDE "data/maps/objects/lavenderpokecenter.asm"

INCLUDE "data/maps/headers/lavendermart.asm"
INCLUDE "scripts/lavendermart.asm"
INCLUDE "data/maps/objects/lavendermart.asm"

INCLUDE "data/maps/headers/vermilionpokecenter.asm"
INCLUDE "scripts/vermilionpokecenter.asm"
INCLUDE "data/maps/objects/vermilionpokecenter.asm"

INCLUDE "data/maps/headers/vermilionmart.asm"
INCLUDE "scripts/vermilionmart.asm"
INCLUDE "data/maps/objects/vermilionmart.asm"

INCLUDE "data/maps/headers/vermiliongym.asm"
INCLUDE "scripts/vermiliongym.asm"
INCLUDE "data/maps/objects/vermiliongym.asm"
VermilionGymBlocks: INCBIN "maps/vermiliongym.blk"

INCLUDE "data/maps/headers/copycatshouse2f.asm"
INCLUDE "scripts/copycatshouse2f.asm"
INCLUDE "data/maps/objects/copycatshouse2f.asm"

INCLUDE "data/maps/headers/fightingdojo.asm"
INCLUDE "scripts/fightingdojo.asm"
INCLUDE "data/maps/objects/fightingdojo.asm"
FightingDojoBlocks: INCBIN "maps/fightingdojo.blk"

INCLUDE "data/maps/headers/saffrongym.asm"
INCLUDE "scripts/saffrongym.asm"
INCLUDE "data/maps/objects/saffrongym.asm"
SaffronGymBlocks: INCBIN "maps/saffrongym.blk"

INCLUDE "data/maps/headers/saffronmart.asm"
INCLUDE "scripts/saffronmart.asm"
INCLUDE "data/maps/objects/saffronmart.asm"

INCLUDE "data/maps/headers/silphco1.asm"
INCLUDE "scripts/silphco1.asm"
INCLUDE "data/maps/objects/silphco1.asm"
SilphCo1Blocks: INCBIN "maps/silphco1.blk"

INCLUDE "data/maps/headers/saffronpokecenter.asm"
INCLUDE "scripts/saffronpokecenter.asm"
INCLUDE "data/maps/objects/saffronpokecenter.asm"

INCLUDE "data/maps/headers/viridianforestexit.asm"
INCLUDE "scripts/viridianforestexit.asm"
INCLUDE "data/maps/objects/viridianforestexit.asm"

INCLUDE "data/maps/headers/route2gate.asm"
INCLUDE "scripts/route2gate.asm"
INCLUDE "data/maps/objects/route2gate.asm"

INCLUDE "data/maps/headers/viridianforestentrance.asm"
INCLUDE "scripts/viridianforestentrance.asm"
INCLUDE "data/maps/objects/viridianforestentrance.asm"

INCLUDE "data/maps/headers/undergroundpathentranceroute5.asm"
INCLUDE "scripts/undergroundpathentranceroute5.asm"
INCLUDE "data/maps/objects/undergroundpathentranceroute5.asm"

INCLUDE "data/maps/headers/undergroundpathentranceroute6.asm"
INCLUDE "scripts/undergroundpathentranceroute6.asm"
INCLUDE "data/maps/objects/undergroundpathentranceroute6.asm"

INCLUDE "data/maps/headers/undergroundpathentranceroute7.asm"
INCLUDE "scripts/undergroundpathentranceroute7.asm"
INCLUDE "data/maps/objects/undergroundpathentranceroute7.asm"

INCLUDE "data/maps/headers/undergroundpathentranceroute7copy.asm"
INCLUDE "scripts/undergroundpathentranceroute7copy.asm"
INCLUDE "data/maps/objects/undergroundpathentranceroute7copy.asm"

INCLUDE "data/maps/headers/silphco9.asm"
INCLUDE "scripts/silphco9.asm"
INCLUDE "data/maps/objects/silphco9.asm"
SilphCo9Blocks: INCBIN "maps/silphco9.blk"

INCLUDE "data/maps/headers/victoryroad1.asm"
INCLUDE "scripts/victoryroad1.asm"
INCLUDE "data/maps/objects/victoryroad1.asm"
VictoryRoad1Blocks: INCBIN "maps/victoryroad1.blk"

INCLUDE "engine/predefs17_2.asm"

INCLUDE "engine/hidden_object_functions17.asm"


SECTION "bank18",ROMX,BANK[$18]

ViridianForestBlocks:    INCBIN "maps/viridianforest.blk"
UndergroundPathNSBlocks: INCBIN "maps/undergroundpathns.blk"
UndergroundPathWEBlocks: INCBIN "maps/undergroundpathwe.blk"

INCBIN "maps/unusedblocks60258.blk"

SSAnne10Blocks:
SSAnne9Blocks: INCBIN "maps/ssanne9.blk"

INCLUDE "data/maps/headers/pokemontower1.asm"
INCLUDE "scripts/pokemontower1.asm"
INCLUDE "data/maps/objects/pokemontower1.asm"
PokemonTower1Blocks: INCBIN "maps/pokemontower1.blk"

INCLUDE "data/maps/headers/pokemontower2.asm"
INCLUDE "scripts/pokemontower2.asm"
INCLUDE "data/maps/objects/pokemontower2.asm"
PokemonTower2Blocks: INCBIN "maps/pokemontower2.blk"

INCLUDE "data/maps/headers/pokemontower3.asm"
INCLUDE "scripts/pokemontower3.asm"
INCLUDE "data/maps/objects/pokemontower3.asm"
PokemonTower3Blocks: INCBIN "maps/pokemontower3.blk"

INCLUDE "data/maps/headers/pokemontower4.asm"
INCLUDE "scripts/pokemontower4.asm"
INCLUDE "data/maps/objects/pokemontower4.asm"
PokemonTower4Blocks: INCBIN "maps/pokemontower4.blk"

INCLUDE "data/maps/headers/pokemontower5.asm"
INCLUDE "scripts/pokemontower5.asm"
INCLUDE "data/maps/objects/pokemontower5.asm"
PokemonTower5Blocks: INCBIN "maps/pokemontower5.blk"

INCLUDE "data/maps/headers/pokemontower6.asm"
INCLUDE "scripts/pokemontower6.asm"
INCLUDE "data/maps/objects/pokemontower6.asm"
PokemonTower6Blocks: INCBIN "maps/pokemontower6.blk"

INCBIN "maps/unusedblocks60cef.blk"

INCLUDE "data/maps/headers/pokemontower7.asm"
INCLUDE "scripts/pokemontower7.asm"
INCLUDE "data/maps/objects/pokemontower7.asm"
PokemonTower7Blocks: INCBIN "maps/pokemontower7.blk"

INCLUDE "data/maps/headers/celadonmart1.asm"
INCLUDE "scripts/celadonmart1.asm"
INCLUDE "data/maps/objects/celadonmart1.asm"
CeladonMart1Blocks: INCBIN "maps/celadonmart1.blk"

INCLUDE "engine/overworld/cinnabar_lab.asm"

INCLUDE "data/maps/headers/viridianforest.asm"
INCLUDE "scripts/viridianforest.asm"
INCLUDE "data/maps/objects/viridianforest.asm"

INCLUDE "data/maps/headers/ssanne1.asm"
INCLUDE "scripts/ssanne1.asm"
INCLUDE "data/maps/objects/ssanne1.asm"
SSAnne1Blocks: INCBIN "maps/ssanne1.blk"

INCLUDE "data/maps/headers/ssanne2.asm"
INCLUDE "scripts/ssanne2.asm"
INCLUDE "data/maps/objects/ssanne2.asm"
SSAnne2Blocks: INCBIN "maps/ssanne2.blk"

INCLUDE "data/maps/headers/ssanne4.asm"
INCLUDE "scripts/ssanne4.asm"
INCLUDE "data/maps/objects/ssanne4.asm"
SSAnne4Blocks: INCBIN "maps/ssanne4.blk"

INCLUDE "data/maps/headers/ssanne5.asm"
INCLUDE "scripts/ssanne5.asm"
INCLUDE "data/maps/objects/ssanne5.asm"
SSAnne5Blocks: INCBIN "maps/ssanne5.blk"

INCLUDE "data/maps/headers/ssanne6.asm"
INCLUDE "scripts/ssanne6.asm"
INCLUDE "data/maps/objects/ssanne6.asm"
SSAnne6Blocks: INCBIN "maps/ssanne6.blk"

INCLUDE "data/maps/headers/ssanne7.asm"
INCLUDE "scripts/ssanne7.asm"
INCLUDE "data/maps/objects/ssanne7.asm"
SSAnne7Blocks: INCBIN "maps/ssanne7.blk"

INCLUDE "data/maps/headers/ssanne8.asm"
INCLUDE "scripts/ssanne8.asm"
INCLUDE "data/maps/objects/ssanne8.asm"
SSAnne8Blocks: INCBIN "maps/ssanne8.blk"

INCLUDE "data/maps/headers/ssanne9.asm"
INCLUDE "scripts/ssanne9.asm"
INCLUDE "data/maps/objects/ssanne9.asm"

INCLUDE "data/maps/headers/ssanne10.asm"
INCLUDE "scripts/ssanne10.asm"
INCLUDE "data/maps/objects/ssanne10.asm"

INCLUDE "data/maps/headers/undergroundpathns.asm"
INCLUDE "scripts/undergroundpathns.asm"
INCLUDE "data/maps/objects/undergroundpathns.asm"

INCLUDE "data/maps/headers/undergroundpathwe.asm"
INCLUDE "scripts/undergroundpathwe.asm"
INCLUDE "data/maps/objects/undergroundpathwe.asm"

INCLUDE "data/maps/headers/diglettscave.asm"
INCLUDE "scripts/diglettscave.asm"
INCLUDE "data/maps/objects/diglettscave.asm"
DiglettsCaveBlocks: INCBIN "maps/diglettscave.blk"

INCLUDE "data/maps/headers/silphco11.asm"
INCLUDE "scripts/silphco11.asm"
INCLUDE "data/maps/objects/silphco11.asm"
SilphCo11Blocks: INCBIN "maps/silphco11.blk"

;joenote - moved these here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INCLUDE "data/maps/headers/tradecenter.asm"
INCLUDE "scripts/tradecenter.asm"
INCLUDE "data/maps/objects/tradecenter.asm"
TradeCenterBlocks: INCBIN "maps/tradecenter.blk"

INCLUDE "data/maps/headers/colosseum.asm"
INCLUDE "scripts/colosseum.asm"
INCLUDE "data/maps/objects/colosseum.asm"
ColosseumBlocks: INCBIN "maps/colosseum.blk"

INCLUDE "engine/give_pokemon.asm"

INCLUDE "engine/predefs.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INCLUDE "engine/hidden_object_functions18.asm"


SECTION "bank19",ROMX,BANK[$19]
Overworld_GFX:     INCBIN "gfx/tilesets/overworld.2bpp"
Overworld_Block:   INCBIN "gfx/blocksets/overworld.bst"

RedsHouse1_GFX:
RedsHouse2_GFX:    INCBIN "gfx/tilesets/reds_house.2bpp"
	ds 16
RedsHouse1_Block:
RedsHouse2_Block:  INCBIN "gfx/blocksets/reds_house.bst"

House_GFX:         INCBIN "gfx/tilesets/house.2bpp"
House_Block:       INCBIN "gfx/blocksets/house.bst"
Mansion_GFX:       INCBIN "gfx/tilesets/mansion.2bpp"
Mansion_Block:     INCBIN "gfx/blocksets/mansion.bst"
ShipPort_GFX:      INCBIN "gfx/tilesets/ship_port.2bpp"
ShipPort_Block:    INCBIN "gfx/blocksets/ship_port.bst"
Interior_GFX:      INCBIN "gfx/tilesets/interior.2bpp"
Interior_Block:    INCBIN "gfx/blocksets/interior.bst"


SECTION "bank1A",ROMX,BANK[$1A]

INCLUDE "engine/battle/decrement_pp.asm"

Version_GFX:
INCBIN "gfx/mainmenu/blueversion.1bpp" ; 10 tiles
Version_GFXEnd:

Plateau_GFX:       INCBIN "gfx/tilesets/plateau.2bpp"
Plateau_Block:     INCBIN "gfx/blocksets/plateau.bst"
Dojo_GFX:
Gym_GFX:           INCBIN "gfx/tilesets/gym.2bpp"
Dojo_Block:
Gym_Block:         INCBIN "gfx/blocksets/gym.bst"

Mart_GFX:
Pokecenter_GFX:    INCBIN "gfx/tilesets/pokecenter.2bpp"
Mart_Block:
Pokecenter_Block:  INCBIN "gfx/blocksets/pokecenter.bst"

ForestGate_GFX:
Museum_GFX:
Gate_GFX:          INCBIN "gfx/tilesets/gate.2bpp"
ForestGate_Block:
Museum_Block:
Gate_Block:        INCBIN "gfx/blocksets/gate.bst"

Forest_GFX:        INCBIN "gfx/tilesets/forest.2bpp"
Forest_Block:      INCBIN "gfx/blocksets/forest.bst"


SECTION "bank1B",ROMX,BANK[$1B]

Facility_GFX:      INCBIN "gfx/tilesets/facility.2bpp"
Facility_Block:    INCBIN "gfx/blocksets/facility.bst"
Cemetery_GFX:      INCBIN "gfx/tilesets/cemetery.2bpp"
Cemetery_Block:    INCBIN "gfx/blocksets/cemetery.bst"
Cavern_GFX:        INCBIN "gfx/tilesets/cavern.2bpp"
Cavern_Block:      INCBIN "gfx/blocksets/cavern.bst"
Lobby_GFX:         INCBIN "gfx/tilesets/lobby.2bpp"
Lobby_Block:       INCBIN "gfx/blocksets/lobby.bst"
Ship_GFX:          INCBIN "gfx/tilesets/ship.2bpp"
Ship_Block:        INCBIN "gfx/blocksets/ship.bst"


SECTION "bank1C",ROMX,BANK[$1C]

INCLUDE "engine/hall_of_fame.asm"
INCLUDE "engine/overworld/healing_machine.asm"
INCLUDE "engine/overworld/player_animations.asm"
INCLUDE "engine/battle/ghost_marowak_anim.asm"
INCLUDE "engine/battle/battle_transitions.asm"
INCLUDE "engine/town_map.asm"
INCLUDE "engine/mon_party_sprites.asm"
INCLUDE "engine/palettes.asm"
INCLUDE "engine/save.asm"


SECTION "bank1D",ROMX,BANK[$1D]

CopycatsHouse1FBlocks: INCBIN "maps/copycatshouse1f.blk"

CinnabarMartBlocks:
PewterMartBlocks: INCBIN "maps/pewtermart.blk"

FuchsiaHouse1Blocks: INCBIN "maps/fuchsiahouse1.blk"

CinnabarPokecenterBlocks:
FuchsiaPokecenterBlocks: INCBIN "maps/fuchsiapokecenter.blk"

CeruleanHouse2Blocks: INCBIN "maps/ceruleanhouse2.blk"

INCLUDE "engine/HoF_room_pc.asm"

INCLUDE "engine/status_ailments.asm"

INCLUDE "engine/items/itemfinder.asm"

INCLUDE "scripts/ceruleancity2.asm"

INCLUDE "data/maps/headers/viridiangym.asm"
INCLUDE "scripts/viridiangym.asm"
INCLUDE "data/maps/objects/viridiangym.asm"
ViridianGymBlocks: INCBIN "maps/viridiangym.blk"

INCLUDE "data/maps/headers/pewtermart.asm"
INCLUDE "scripts/pewtermart.asm"
INCLUDE "data/maps/objects/pewtermart.asm"

INCLUDE "data/maps/headers/unknowndungeon1.asm"
INCLUDE "scripts/unknowndungeon1.asm"
INCLUDE "data/maps/objects/unknowndungeon1.asm"
UnknownDungeon1Blocks: INCBIN "maps/unknowndungeon1.blk"

INCLUDE "data/maps/headers/ceruleanhouse2.asm"
INCLUDE "scripts/ceruleanhouse2.asm"
INCLUDE "data/maps/objects/ceruleanhouse2.asm"

INCLUDE "engine/menu/vending_machine.asm"

INCLUDE "data/maps/headers/fuchsiahouse1.asm"
INCLUDE "scripts/fuchsiahouse1.asm"
INCLUDE "data/maps/objects/fuchsiahouse1.asm"

INCLUDE "data/maps/headers/fuchsiapokecenter.asm"
INCLUDE "scripts/fuchsiapokecenter.asm"
INCLUDE "data/maps/objects/fuchsiapokecenter.asm"

INCLUDE "data/maps/headers/fuchsiahouse2.asm"
INCLUDE "scripts/fuchsiahouse2.asm"
INCLUDE "data/maps/objects/fuchsiahouse2.asm"
FuchsiaHouse2Blocks: INCBIN "maps/fuchsiahouse2.blk"

INCLUDE "data/maps/headers/safarizoneentrance.asm"
INCLUDE "scripts/safarizoneentrance.asm"
INCLUDE "data/maps/objects/safarizoneentrance.asm"
SafariZoneEntranceBlocks: INCBIN "maps/safarizoneentrance.blk"

INCLUDE "data/maps/headers/fuchsiagym.asm"
INCLUDE "scripts/fuchsiagym.asm"
INCLUDE "data/maps/objects/fuchsiagym.asm"
FuchsiaGymBlocks: INCBIN "maps/fuchsiagym.blk"

INCLUDE "data/maps/headers/fuchsiameetingroom.asm"
INCLUDE "scripts/fuchsiameetingroom.asm"
INCLUDE "data/maps/objects/fuchsiameetingroom.asm"
FuchsiaMeetingRoomBlocks: INCBIN "maps/fuchsiameetingroom.blk"

INCLUDE "data/maps/headers/cinnabargym.asm"
INCLUDE "scripts/cinnabargym.asm"
INCLUDE "data/maps/objects/cinnabargym.asm"
CinnabarGymBlocks: INCBIN "maps/cinnabargym.blk"

INCLUDE "data/maps/headers/lab1.asm"
INCLUDE "scripts/lab1.asm"
INCLUDE "data/maps/objects/lab1.asm"
Lab1Blocks: INCBIN "maps/lab1.blk"

INCLUDE "data/maps/headers/lab2.asm"
INCLUDE "scripts/lab2.asm"
INCLUDE "data/maps/objects/lab2.asm"
Lab2Blocks: INCBIN "maps/lab2.blk"

INCLUDE "data/maps/headers/lab3.asm"
INCLUDE "scripts/lab3.asm"
INCLUDE "data/maps/objects/lab3.asm"
Lab3Blocks: INCBIN "maps/lab3.blk"

INCLUDE "data/maps/headers/lab4.asm"
INCLUDE "scripts/lab4.asm"
INCLUDE "data/maps/objects/lab4.asm"
Lab4Blocks: INCBIN "maps/lab4.blk"

INCLUDE "data/maps/headers/cinnabarpokecenter.asm"
INCLUDE "scripts/cinnabarpokecenter.asm"
INCLUDE "data/maps/objects/cinnabarpokecenter.asm"

INCLUDE "data/maps/headers/cinnabarmart.asm"
INCLUDE "scripts/cinnabarmart.asm"
INCLUDE "data/maps/objects/cinnabarmart.asm"

INCLUDE "data/maps/headers/copycatshouse1f.asm"
INCLUDE "scripts/copycatshouse1f.asm"
INCLUDE "data/maps/objects/copycatshouse1f.asm"

INCLUDE "data/maps/headers/rival.asm"
INCLUDE "scripts/rival.asm"
INCLUDE "data/maps/objects/rival.asm"
RivalBlocks: INCBIN "maps/rival.blk"

INCLUDE "data/maps/headers/lorelei.asm"
INCLUDE "scripts/lorelei.asm"
INCLUDE "data/maps/objects/lorelei.asm"
LoreleiBlocks: INCBIN "maps/lorelei.blk"

INCLUDE "data/maps/headers/bruno.asm"
INCLUDE "scripts/bruno.asm"
INCLUDE "data/maps/objects/bruno.asm"
BrunoBlocks: INCBIN "maps/bruno.blk"

INCLUDE "data/maps/headers/agatha.asm"
INCLUDE "scripts/agatha.asm"
INCLUDE "data/maps/objects/agatha.asm"
AgathaBlocks: INCBIN "maps/agatha.blk"

INCLUDE "engine/menu/league_pc.asm"

INCLUDE "engine/overworld/hidden_items.asm"
INCLUDE "engine/evolution.asm"


SECTION "bank1E",ROMX,BANK[$1E]

INCLUDE "engine/battle/animations.asm"

INCLUDE "engine/overworld/cut2.asm"
INCLUDE "engine/overworld/ssanne.asm"

INCLUDE "data/moves/animations.asm"


SECTION "Engine Spillover", ROMX

INCLUDE "engine/menu/item_descriptions.asm"

;joenote - adding female trainer sprites
FPlayerCharacterTitleGraphics:   INCBIN "gfx/mainmenu/player_title_f.2bpp"
FPlayerCharacterTitleGraphicsEnd:
RedPicFBack::          INCBIN "gfx/trainerback/redb_f.pic"
RedPicFFront::         INCBIN "gfx/trainer/red_f.pic"
RedFSprite:            INCBIN "gfx/sprites/redf.2bpp"
RedFCyclingSprite:     INCBIN "gfx/sprites/cyclingf.2bpp"
SeelFSprite:           INCBIN "gfx/sprites/seelf.2bpp"

RedFishingTilesFront: INCBIN "gfx/tiles/red_fishing_tile_front.2bpp"
RedFishingTilesBack:  INCBIN "gfx/tiles/red_fishing_tile_back.2bpp"
RedFishingTilesSide:  INCBIN "gfx/tiles/red_fishing_tile_side.2bpp"
RedFishingRodTiles:   INCBIN "gfx/tiles/red_fishingrod_tiles.2bpp"

RedFFishingTilesFront: INCBIN "gfx/tiles/redF_fishing_tile_front.2bpp"
RedFFishingTilesBack:  INCBIN "gfx/tiles/redF_fishing_tile_back.2bpp"
RedFFishingTilesSide:  INCBIN "gfx/tiles/redF_fishing_tile_side.2bpp"

SECTION "bank2D",ROMX,BANK[$2D]	;joenote - This is a known empty bank. Going to start moving stuff here

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;this is a bunch of custom functions and stuff, so leave it all together in the same bank
INCLUDE "custom_functions/func_ai.asm"
INCLUDE "custom_functions/func_battle.asm"
INCLUDE "custom_functions/func_enc_gen.asm"
INCLUDE "custom_functions/func_misc.asm"
INCLUDE "custom_functions/func_monlists.asm"
INCLUDE "custom_functions/func_overworld.asm"
INCLUDE "custom_functions/func_shiny.asm"
INCLUDE "custom_functions/func_nuzlocke.asm"
INCLUDE "custom_functions/func_stat_reset.asm"
INCLUDE "engine/battle/stats_functions.asm"	
INCLUDE "engine/battle/exp_bar_print.asm"	
INCLUDE "custom_functions/fisher_yates.asm"
INCLUDE "engine/battle/load_pics.asm"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

TradingAnimationGraphics:
INCBIN "gfx/tiles/game_boy.2bpp"
INCBIN "gfx/tiles/link_cable.2bpp"
TradingAnimationGraphicsEnd:

; Pokeball traveling through the link cable.
TradingAnimationGraphics2: INCBIN "gfx/tiles/trade2.2bpp"
TradingAnimationGraphics2End:

;joenote - moved this out of trainer_ai.asm in bank $E to here. 
;Now there is lots of space for custom trainers and rosters
INCLUDE "engine/battle/read_trainer_party.asm"
INCLUDE "data/moves/trainer_moves.asm"
INCLUDE "data/battle/trainer_parties.asm"

INCLUDE "engine/items/tm_prices.asm"
INCLUDE "data/maps/collision_tile_ids.asm"

SECTION "bank2E",ROMX,BANK[$2E]	
;gbcnote - This bank will hold the bg map attributes for the gameboy color among other stuff

;include the bgmap files from pokemon yellow
INCLUDE "data/maps/bg_map_attributes.asm"
INCLUDE "engine/bg_map_attributes.asm"

INCLUDE "engine/gamefreak.asm"	;gbcnote - moved here to make space
INCLUDE "engine/in_game_trades.asm"	;joenote - moved here to make space
INCLUDE "engine/learn_move.asm"	;joenote - moved in order to have more space
INCLUDE "engine/overworld/elevator.asm"	;joenote - moving this to make space

INCLUDE "custom_functions/func_gamma.asm"
INCLUDE "custom_functions/func_extra_menu.asm"
INCLUDE "custom_functions/func_move_secrets.asm"
INCLUDE "custom_functions/func_linkbattlecomms.asm"

SECTION "Pics 1", ROMX, BANK[PICS_1]
INCLUDE "constants/pic_banks/pic1.asm"

SECTION "Pics 2", ROMX, BANK[PICS_2]
INCLUDE "constants/pic_banks/pic2.asm"

SECTION "Pics 3", ROMX, BANK[PICS_3]
INCLUDE "constants/pic_banks/pic3.asm"

SECTION "Pics 4", ROMX, BANK[PICS_4]
INCLUDE "constants/pic_banks/pic4.asm"

SECTION "Pics 5", ROMX, BANK[PICS_5]
INCLUDE "constants/pic_banks/pic5.asm"

SECTION "Pics 6", ROMX, BANK[PICS_6]
INCLUDE "constants/pic_banks/pic6.asm"

SECTION "Pics 7", ROMX, BANK[PICS_7]
INCLUDE "constants/pic_banks/pic7.asm"

RedPicBack::           INCBIN "gfx/trainerback/redb.pic"
OldManPic::            INCBIN "gfx/trainerback/oldman.pic"

INCLUDE "text/tmhm_names.asm"	;joenote - adding name list for tm and hm items
tmhmNamesEnd:

INCLUDE "data/wildPokemons/super_rod.asm"	;joenote - moving all the super rod data here

SECTION "bank32",ROMX,BANK[$32]	
INCLUDE "custom_functions/func_enhancedcolor.asm"
INCLUDE "custom_functions/func_bag.asm"
INCLUDE "custom_functions/func_emuchecks.asm"
INCLUDE "engine/overworld/cut3.asm"
INCLUDE "engine/menu/multi_choice_menu.asm"
INCLUDE "engine/menu/text_multi_button_prompt.asm"
INCLUDE "engine/menu/change_box_menu.asm"

Lab_GFX:           INCBIN "gfx/tilesets/lab.2bpp"
Lab_Block:         INCBIN "gfx/blocksets/lab.bst"
Club_GFX:          INCBIN "gfx/tilesets/club.2bpp"
Club_Block:        INCBIN "gfx/blocksets/club.bst"
Underground_GFX:   INCBIN "gfx/tilesets/underground.2bpp"
Underground_Block: INCBIN "gfx/blocksets/underground.bst"
Reactor_GFX:       INCBIN "gfx/tilesets/reactor.2bpp"
Reactor_Block:     INCBIN "gfx/blocksets/reactor.bst"
Volcano_GFX:       INCBIN "gfx/tilesets/volcano.2bpp"
Volcano_Block:     INCBIN "gfx/blocksets/volcano.bst"

SECTION "PARTY ICONS 1", ROMX
MonIcons::
INCBIN "gfx/pokemon/icons/null.2bpp"
INCBIN "gfx/pokemon/icons/bulbasaur.2bpp"
INCBIN "gfx/pokemon/icons/ivysaur.2bpp"
INCBIN "gfx/pokemon/icons/venusaur.2bpp"
INCBIN "gfx/pokemon/icons/charmander.2bpp"
INCBIN "gfx/pokemon/icons/charmeleon.2bpp"
INCBIN "gfx/pokemon/icons/charizard.2bpp"
INCBIN "gfx/pokemon/icons/squirtle.2bpp"
INCBIN "gfx/pokemon/icons/wartortle.2bpp"
INCBIN "gfx/pokemon/icons/blastoise.2bpp"
INCBIN "gfx/pokemon/icons/caterpie.2bpp"
INCBIN "gfx/pokemon/icons/metapod.2bpp"
INCBIN "gfx/pokemon/icons/butterfree.2bpp"
INCBIN "gfx/pokemon/icons/weedle.2bpp"
INCBIN "gfx/pokemon/icons/kakuna.2bpp"
INCBIN "gfx/pokemon/icons/beedrill.2bpp"
INCBIN "gfx/pokemon/icons/pidgey.2bpp"
INCBIN "gfx/pokemon/icons/pidgeotto.2bpp"
INCBIN "gfx/pokemon/icons/pidgeot.2bpp"
INCBIN "gfx/pokemon/icons/rattata.2bpp"
INCBIN "gfx/pokemon/icons/raticate.2bpp"
INCBIN "gfx/pokemon/icons/spearow.2bpp"
INCBIN "gfx/pokemon/icons/fearow.2bpp"
INCBIN "gfx/pokemon/icons/ekans.2bpp"
INCBIN "gfx/pokemon/icons/arbok.2bpp"
INCBIN "gfx/pokemon/icons/pikachu.2bpp"
INCBIN "gfx/pokemon/icons/raichu.2bpp"
INCBIN "gfx/pokemon/icons/sandshrew.2bpp"
INCBIN "gfx/pokemon/icons/sandslash.2bpp"
INCBIN "gfx/pokemon/icons/nidoran_f.2bpp"
INCBIN "gfx/pokemon/icons/nidorina.2bpp"
INCBIN "gfx/pokemon/icons/nidoqueen.2bpp"
INCBIN "gfx/pokemon/icons/nidoran_m.2bpp"
INCBIN "gfx/pokemon/icons/nidorino.2bpp"
INCBIN "gfx/pokemon/icons/nidoking.2bpp"
INCBIN "gfx/pokemon/icons/clefairy.2bpp"
INCBIN "gfx/pokemon/icons/clefable.2bpp"
INCBIN "gfx/pokemon/icons/vulpix.2bpp"
INCBIN "gfx/pokemon/icons/ninetales.2bpp"
INCBIN "gfx/pokemon/icons/jigglypuff.2bpp"
INCBIN "gfx/pokemon/icons/wigglytuff.2bpp"
INCBIN "gfx/pokemon/icons/zubat.2bpp"
INCBIN "gfx/pokemon/icons/golbat.2bpp"
INCBIN "gfx/pokemon/icons/oddish.2bpp"
INCBIN "gfx/pokemon/icons/gloom.2bpp"
INCBIN "gfx/pokemon/icons/vileplume.2bpp"
INCBIN "gfx/pokemon/icons/paras.2bpp"
INCBIN "gfx/pokemon/icons/parasect.2bpp"
INCBIN "gfx/pokemon/icons/venonat.2bpp"
INCBIN "gfx/pokemon/icons/venomoth.2bpp"
INCBIN "gfx/pokemon/icons/diglett.2bpp"
INCBIN "gfx/pokemon/icons/dugtrio.2bpp"
INCBIN "gfx/pokemon/icons/meowth.2bpp"
INCBIN "gfx/pokemon/icons/persian.2bpp"
INCBIN "gfx/pokemon/icons/psyduck.2bpp"
INCBIN "gfx/pokemon/icons/golduck.2bpp"
INCBIN "gfx/pokemon/icons/mankey.2bpp"
INCBIN "gfx/pokemon/icons/primeape.2bpp"
INCBIN "gfx/pokemon/icons/growlithe.2bpp"
INCBIN "gfx/pokemon/icons/arcanine.2bpp"
INCBIN "gfx/pokemon/icons/poliwag.2bpp"
INCBIN "gfx/pokemon/icons/poliwhirl.2bpp"
INCBIN "gfx/pokemon/icons/poliwrath.2bpp"
INCBIN "gfx/pokemon/icons/abra.2bpp"
INCBIN "gfx/pokemon/icons/kadabra.2bpp"
INCBIN "gfx/pokemon/icons/alakazam.2bpp"
INCBIN "gfx/pokemon/icons/machop.2bpp"
INCBIN "gfx/pokemon/icons/machoke.2bpp"
INCBIN "gfx/pokemon/icons/machamp.2bpp"
INCBIN "gfx/pokemon/icons/bellsprout.2bpp"
INCBIN "gfx/pokemon/icons/weepinbell.2bpp"
INCBIN "gfx/pokemon/icons/victreebel.2bpp"
INCBIN "gfx/pokemon/icons/tentacool.2bpp"
INCBIN "gfx/pokemon/icons/tentacruel.2bpp"
INCBIN "gfx/pokemon/icons/geodude.2bpp"
INCBIN "gfx/pokemon/icons/graveler.2bpp"
INCBIN "gfx/pokemon/icons/golem.2bpp"
INCBIN "gfx/pokemon/icons/ponyta.2bpp"
INCBIN "gfx/pokemon/icons/rapidash.2bpp"
INCBIN "gfx/pokemon/icons/slowpoke.2bpp"
INCBIN "gfx/pokemon/icons/slowbro.2bpp"
INCBIN "gfx/pokemon/icons/magnemite.2bpp"
INCBIN "gfx/pokemon/icons/magneton.2bpp"
INCBIN "gfx/pokemon/icons/farfetchd.2bpp"
INCBIN "gfx/pokemon/icons/doduo.2bpp"
INCBIN "gfx/pokemon/icons/dodrio.2bpp"
INCBIN "gfx/pokemon/icons/seel.2bpp"
INCBIN "gfx/pokemon/icons/dewgong.2bpp"
INCBIN "gfx/pokemon/icons/grimer.2bpp"
INCBIN "gfx/pokemon/icons/muk.2bpp"
INCBIN "gfx/pokemon/icons/shellder.2bpp"
INCBIN "gfx/pokemon/icons/cloyster.2bpp"
INCBIN "gfx/pokemon/icons/gastly.2bpp"
INCBIN "gfx/pokemon/icons/haunter.2bpp"
INCBIN "gfx/pokemon/icons/gengar.2bpp"
INCBIN "gfx/pokemon/icons/onix.2bpp"
INCBIN "gfx/pokemon/icons/drowzee.2bpp"
INCBIN "gfx/pokemon/icons/hypno.2bpp"
INCBIN "gfx/pokemon/icons/krabby.2bpp"
INCBIN "gfx/pokemon/icons/kingler.2bpp"
INCBIN "gfx/pokemon/icons/voltorb.2bpp"
INCBIN "gfx/pokemon/icons/electrode.2bpp"
INCBIN "gfx/pokemon/icons/exeggcute.2bpp"
INCBIN "gfx/pokemon/icons/exeggutor.2bpp"
INCBIN "gfx/pokemon/icons/cubone.2bpp"
INCBIN "gfx/pokemon/icons/marowak.2bpp"
INCBIN "gfx/pokemon/icons/hitmonlee.2bpp"
INCBIN "gfx/pokemon/icons/hitmonchan.2bpp"
INCBIN "gfx/pokemon/icons/lickitung.2bpp"
INCBIN "gfx/pokemon/icons/koffing.2bpp"
INCBIN "gfx/pokemon/icons/weezing.2bpp"
INCBIN "gfx/pokemon/icons/rhyhorn.2bpp"
INCBIN "gfx/pokemon/icons/rhydon.2bpp"
INCBIN "gfx/pokemon/icons/chansey.2bpp"
INCBIN "gfx/pokemon/icons/tangela.2bpp"
INCBIN "gfx/pokemon/icons/kangaskhan.2bpp"
INCBIN "gfx/pokemon/icons/horsea.2bpp"
INCBIN "gfx/pokemon/icons/seadra.2bpp"
INCBIN "gfx/pokemon/icons/goldeen.2bpp"
INCBIN "gfx/pokemon/icons/seaking.2bpp"
INCBIN "gfx/pokemon/icons/staryu.2bpp"
INCBIN "gfx/pokemon/icons/starmie.2bpp"
INCBIN "gfx/pokemon/icons/mr_mime.2bpp"
INCBIN "gfx/pokemon/icons/scyther.2bpp"
INCBIN "gfx/pokemon/icons/jynx.2bpp"
INCBIN "gfx/pokemon/icons/electabuzz.2bpp"
INCBIN "gfx/pokemon/icons/magmar.2bpp"
INCBIN "gfx/pokemon/icons/pinsir.2bpp"


SECTION "PARTY ICONS 2", ROMX
MonIcons2::
INCBIN "gfx/pokemon/icons/tauros.2bpp"
INCBIN "gfx/pokemon/icons/magikarp.2bpp"
INCBIN "gfx/pokemon/icons/gyarados.2bpp"
INCBIN "gfx/pokemon/icons/lapras.2bpp"
INCBIN "gfx/pokemon/icons/ditto.2bpp"
INCBIN "gfx/pokemon/icons/eevee.2bpp"
INCBIN "gfx/pokemon/icons/vaporeon.2bpp"
INCBIN "gfx/pokemon/icons/jolteon.2bpp"
INCBIN "gfx/pokemon/icons/flareon.2bpp"
INCBIN "gfx/pokemon/icons/porygon.2bpp"
INCBIN "gfx/pokemon/icons/omanyte.2bpp"
INCBIN "gfx/pokemon/icons/omastar.2bpp"
INCBIN "gfx/pokemon/icons/kabuto.2bpp"
INCBIN "gfx/pokemon/icons/kabutops.2bpp"
INCBIN "gfx/pokemon/icons/aerodactyl.2bpp"
INCBIN "gfx/pokemon/icons/snorlax.2bpp"
INCBIN "gfx/pokemon/icons/articuno.2bpp"
INCBIN "gfx/pokemon/icons/zapdos.2bpp"
INCBIN "gfx/pokemon/icons/moltres.2bpp"
INCBIN "gfx/pokemon/icons/dratini.2bpp"
INCBIN "gfx/pokemon/icons/dragonair.2bpp"
INCBIN "gfx/pokemon/icons/dragonite.2bpp"
INCBIN "gfx/pokemon/icons/mewtwo.2bpp"
INCBIN "gfx/pokemon/icons/mew.2bpp"
INCBIN "gfx/pokemon/icons/steelix.2bpp"
INCBIN "gfx/pokemon/icons/scizor.2bpp"
INCBIN "gfx/pokemon/icons/umbreon.2bpp"
INCBIN "gfx/pokemon/icons/kingdra.2bpp"
INCBIN "gfx/pokemon/icons/sneasel.2bpp"
INCBIN "gfx/pokemon/icons/misdreavus.2bpp"
INCBIN "gfx/pokemon/icons/larvitar.2bpp"
INCBIN "gfx/pokemon/icons/pupitar.2bpp"
INCBIN "gfx/pokemon/icons/tyranitar.2bpp"
INCBIN "gfx/pokemon/icons/hooh.2bpp"
INCBIN "gfx/pokemon/icons/missingno.2bpp"

SECTION "NPC Sprites 3", ROMX
JennySprite:          INCBIN "gfx/sprites/jenny.2bpp"
JessieSprite:         INCBIN "gfx/sprites/jessie.2bpp"
JamesSprite:          INCBIN "gfx/sprites/james.2bpp"
ClefairySprite:       INCBIN "gfx/sprites/pokemons/clefairy.2bpp"
SlowbroSprite:        INCBIN "gfx/sprites/pokemons/slowbro.2bpp"
BirdSprite:           INCBIN "gfx/sprites/pokemons/bird.2bpp"
SnorlaxSprite:        INCBIN "gfx/sprites/pokemons/snorlax.2bpp"
OmanyteSprite:        INCBIN "gfx/sprites/pokemons/omanyte.2bpp"
OldAmberSprite:       INCBIN "gfx/sprites/pokemons/old_amber.2bpp"
ArticunoSprite:       INCBIN "gfx/sprites/pokemons/articuno.2bpp"
ChanseySprite:        INCBIN "gfx/sprites/pokemons/chansey.2bpp"
CuboneSprite:         INCBIN "gfx/sprites/pokemons/cubone.2bpp"
DoduoSprite:          INCBIN "gfx/sprites/pokemons/doduo.2bpp"
FearowSprite:         INCBIN "gfx/sprites/pokemons/fearow.2bpp"
JigglypuffSprite:     INCBIN "gfx/sprites/pokemons/jigglypuff.2bpp"
KangaskhanSprite:     INCBIN "gfx/sprites/pokemons/kangaskhan.2bpp"
LaprassSprite:        INCBIN "gfx/sprites/pokemons/lapras.2bpp"
MachokeSprite:        INCBIN "gfx/sprites/pokemons/machoke.2bpp"
MachopSprite:         INCBIN "gfx/sprites/pokemons/machop.2bpp"
MeowthSprite:         INCBIN "gfx/sprites/pokemons/meowth.2bpp"
MewtwoSprite:         INCBIN "gfx/sprites/pokemons/mewtwo.2bpp"
MoltresSprite:        INCBIN "gfx/sprites/pokemons/moltres.2bpp"
NidoranFSprite:       INCBIN "gfx/sprites/pokemons/nidoranF.2bpp"
NidoranMSprite:       INCBIN "gfx/sprites/pokemons/nidoranM.2bpp"
NidorinoSprite:       INCBIN "gfx/sprites/pokemons/nidorino.2bpp"
PidgeotSprite:        INCBIN "gfx/sprites/pokemons/pidgeot.2bpp"
PidgeySprite:         INCBIN "gfx/sprites/pokemons/pidgey.2bpp"
PikachuSprite:        INCBIN "gfx/sprites/pokemons/pikachu.2bpp"
PolywrathSprite:      INCBIN "gfx/sprites/pokemons/polywrath.2bpp"
PsyduckSprite:        INCBIN "gfx/sprites/pokemons/psyduck.2bpp"
Seel2Sprite:          INCBIN "gfx/sprites/pokemons/seel.2bpp"
SlowpokeSprite:       INCBIN "gfx/sprites/pokemons/slowpoke.2bpp"
SpearowSprite:        INCBIN "gfx/sprites/pokemons/spearow.2bpp"
VoltorbSprite:        INCBIN "gfx/sprites/pokemons/voltorb.2bpp"
WigglytuffSprite:     INCBIN "gfx/sprites/pokemons/wigglytuff.2bpp"
ZapdosSprite:         INCBIN "gfx/sprites/pokemons/zapdos.2bpp"
MewSprite:            INCBIN "gfx/sprites/pokemons/mew.2bpp"

SECTION "Type Icons", ROMX

NormalTypeIcon::     INCBIN "gfx/tiles/type_icons/normal.2bpp"
FightingTypeIcon::   INCBIN "gfx/tiles/type_icons/fighting.2bpp"
FlyingTypeIcon::     INCBIN "gfx/tiles/type_icons/flying.2bpp"
PoisonTypeIcon::     INCBIN "gfx/tiles/type_icons/poison.2bpp"
GroundTypeIcon::     INCBIN "gfx/tiles/type_icons/ground.2bpp"
RockTypeIcon::       INCBIN "gfx/tiles/type_icons/rock.2bpp"
TypelessIcon::       INCBIN "gfx/tiles/type_icons/typeless.2bpp"
BugTypeIcon::        INCBIN "gfx/tiles/type_icons/bug.2bpp"
GhostTypeIcon::      INCBIN "gfx/tiles/type_icons/ghost.2bpp"
FireTypeIcon::       INCBIN "gfx/tiles/type_icons/fire.2bpp"
WaterTypeIcon::      INCBIN "gfx/tiles/type_icons/water.2bpp"
GrassTypeIcon::      INCBIN "gfx/tiles/type_icons/grass.2bpp"
ElectricTypeIcon::   INCBIN "gfx/tiles/type_icons/electric.2bpp"
PsychicTypeIcon::    INCBIN "gfx/tiles/type_icons/psychic_gbc.2bpp"
IceTypeIcon::        INCBIN "gfx/tiles/type_icons/ice.2bpp"
DragonTypeIcon::     INCBIN "gfx/tiles/type_icons/dragon.2bpp"
SteelTypeIcon::      INCBIN "gfx/tiles/type_icons/steel.2bpp"
DarkTypeIcon::       INCBIN "gfx/tiles/type_icons/dark.2bpp"

SECTION "Menu Prompt Graphics", ROMX

PokedexPromptGraphics::  INCBIN "gfx/tiles/prompts_pokedex.2bpp"
PokedexPromptGraphicsEnd::
MovedexPromptGraphics::  INCBIN "gfx/tiles/prompts_movedex.2bpp"
MovedexPromptGraphicsEnd::
MovedexUI::          INCBIN "gfx/tiles/movedex_ui.1bpp"
MovedexUIEnd::
PokedexDataUI::	INCBIN "gfx/tiles/left_right.1bpp"
PokedexDataUIEnd::
MapAreasUI::	INCBIN "gfx/tiles/area_type_ui.2bpp"
MapAreasUIEnd::
FishingWaterIcons:: INCBIN "gfx/tiles/mon_fishing_water_icons.1bpp"
ExtraMenuBorderConnectors:: INCBIN "gfx/tiles/extra_menu_border_connectors.2bpp"
FromToChangeBoxPrompt:: INCBIN "gfx/tiles/from_to_change_box_prompt.2bpp"
