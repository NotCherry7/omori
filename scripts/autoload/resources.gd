extends Node

# TITLES

const MENU_WHITE_TITLE = preload("res://labelSettings/menu_white_title.tres")
const MENU_GRAY_TITLE = preload("res://labelSettings/menu_gray_title.tres")

# MUSIC

const TUSSLE_AMONG_TREES = preload("res://audio/battle/015 - Tussle Among Trees.mp3")
const THREE_BAR_LOGOS = preload("res://audio/music/027 - Three Bar Logos.mp3")
const CHAOS_ASSEMBLY = preload("res://audio/music/036 - CHAOS ASSEMBLY.mp3")
const TROUBLE_NEVER_ALWAYS = preload("res://audio/music/039 - Trouble - NEVER-ALWAYS.mp3")
const YOU_WERE_WRONG_GO_BACK = preload("res://audio/music/040 - You Were Wrong. Go Back..mp3")
const IT_MEANS_EVERYTHING = preload("res://audio/music/060 - It Means Everything..mp3")
const THOSE_WHO_FORGET_HISTORY = preload("res://audio/music/072 - Those Who Forget History.mp3")
const PYREFLY_FOREST_CATS_CRADLE = preload("res://audio/music/074 - Pyrefly Forest - Cat_s Cradle.mp3")

# BATTLE BACKGROUNDS

const BA_SPACE_BG = preload("res://assets/backgrounds/battleback_dw_pluto.png")
const BG_BURNING_CITY = preload("res://assets/backgrounds/battlebacks_dw_jawsum.png")
const BG_SPOTLIGHT = preload("res://assets/backgrounds/battleback_bs_something.png")
const BG_HIGHWAY = preload("res://assets/backgrounds/battleback_dw_highway.png")
const BG_HEAVEN = preload("res://assets/backgrounds/battleback_dw_perfectheart.png")
const BG_SPACE = preload("res://assets/backgrounds/battleback_dw_pluto.png")
const BG_PUFFS = preload("res://assets/backgrounds/battleback_dw_slimegirls.png")
const BG_PARK = preload("res://assets/backgrounds/battleback_ft_park.png")
const BG_PLAZA = preload("res://assets/backgrounds/battleback_ft_plaza.png")
const BG_HEART = preload("res://assets/backgrounds/battleback_sw_sweetheart.png")
const BG_DW_FOREST = preload("res://assets/backgrounds/battleback_vf_default.png")





# BACKGROUNDS
const NEUTRAL_BG = preload("res://ui/battle/emotions/backgrounds/neutral.png")
const HAPPY_BG = preload("res://ui/battle/emotions/backgrounds/happy.png")
const ECSTATIC_BG = preload("res://ui/battle/emotions/backgrounds/ecstatic.png")
const MANIC_BG = preload("res://ui/battle/emotions/backgrounds/manic.png")
const SAD_BG = preload("res://ui/battle/emotions/backgrounds/sad.png")
const DEPRESSED_BG = preload("res://ui/battle/emotions/backgrounds/depressed.png")
const MISERABLE_BG = preload("res://ui/battle/emotions/backgrounds/miserable.png")
const ANGRY_BG = preload("res://ui/battle/emotions/backgrounds/angry.png")
const ENRAGED_BG = preload("res://ui/battle/emotions/backgrounds/enraged.png")
const FURIOUS_BG = preload("res://ui/battle/emotions/backgrounds/furious.png")
const AFRAID_BG = preload("res://ui/battle/emotions/backgrounds/afraid.png")
const STRESSED_OUT_BG = preload("res://ui/battle/emotions/backgrounds/stressed_out.png")


# TEXTS
const NEUTRAL_TEXT = preload("res://ui/battle/emotions/text/neutral.png")
const HAPPY_TEXT = preload("res://ui/battle/emotions/text/happy.png")
const ECSTATIC_TEXT = preload("res://ui/battle/emotions/text/ecstatic.png")
const MANIC_TEXT = preload("res://ui/battle/emotions/text/manic.png")
const SAD_TEXT = preload("res://ui/battle/emotions/text/sad.png")
const DEPRESSED_TEXT = preload("res://ui/battle/emotions/text/depressed.png")
const MISERABLE_TEXT = preload("res://ui/battle/emotions/text/miserable.png")
const ANGRY_TEXT = preload("res://ui/battle/emotions/text/angry.png")
const ENRAGED_TEXT = preload("res://ui/battle/emotions/text/enraged.png")
const FURIOUS_TEXT = preload("res://ui/battle/emotions/text/furious.png")
const AFRAID_TEXT = preload("res://ui/battle/emotions/text/afraid.png")
const STRESSED_OUT_TEXT = preload("res://ui/battle/emotions/text/stressed_out.png")


const RED_POINTER_RIGHT = preload("res://ui/redPointerRight.png")
const GRAY_POINTER_RIGHT = preload("res://ui/grayPointerRight.png")
const BOUNCE_SIDEWAYS = preload("res://shaders/bounce_sideways.gdshader")


#const BRENNA_SKETCH = preload("res://assets/faces/brennaNew.png")
const BRENNA_SKETCH = preload("res://assets/faces/BrennaSketch900.png")
const LUKE_SKETCH = preload("res://assets/faces/LukeSketch900.png")

const NATHAN_FACE = preload("res://characters/nathan/nathanFace-2.png.png")

const BAR_0_1_2 = preload("res://ui/battle/energy/bar/bar012.png")
const BAR_3_4 = preload("res://ui/battle/energy/bar/bar34.png")
const BAR_5_6 = preload("res://ui/battle/energy/bar/bar56.png")
const BAR_7_8_9 = preload("res://ui/battle/energy/bar/bar789.png")
const BAR_10 = preload("res://ui/battle/energy/bar/bar-10.png")

const ORB_0 = preload("res://ui/battle/energy/orbs/orb_0.png")
const ORB_1 = preload("res://ui/battle/energy/orbs/orb_1.png")
const ORB_2 = preload("res://ui/battle/energy/orbs/orb_2.png")
const ORB_3 = preload("res://ui/battle/energy/orbs/orb_3.png")
const ORB_4 = preload("res://ui/battle/energy/orbs/orb_4.png")
const ORB_5 = preload("res://ui/battle/energy/orbs/orb_5.png")
const ORB_6 = preload("res://ui/battle/energy/orbs/orb_6.png")
const ORB_7 = preload("res://ui/battle/energy/orbs/orb_7.png")
const ORB_8 = preload("res://ui/battle/energy/orbs/orb_8.png")
const ORB_9 = preload("res://ui/battle/energy/orbs/orb_9.png")
const ORB_10 = preload("res://ui/battle/energy/orbs/orb_10.png")

# BATTLE SFX

const SFX_BRENNA_ATTACK = preload("res://audio/sfx/battle/brenna_attack.ogg")
const SFX_LUKE_ATTACK = preload("res://audio/sfx/battle/BA_basic_attack_kel.ogg")
const SFX_ATTACK_SOLID = preload("res://audio/sfx/battle/BA_basic_attack_solid.ogg")
const SFX_BATTLE_ENCOUNTER_1 = preload("res://audio/sfx/battle/BA_battle_encounter_1.ogg")
const SFX_RELEASE_ENERGY = preload("res://audio/sfx/battle/BA_releaSE_energy.ogg")
const SFX_RELEASE_ENERGY_ATTACK = preload("res://audio/sfx/battle/BA_releaSE_energy.ogg")
const SFX_RUN = preload("res://audio/sfx/battle/BA_run.ogg")
const SFX_STAT_DOWN_2 = preload("res://audio/sfx/battle/BA_stat_down2.ogg")
const SFX_STAT_DOWN_3 = preload("res://audio/sfx/battle/BA_stat_down3.ogg")
const SFX_STAT_DOWN = preload("res://audio/sfx/battle/BA_Stat_Down.ogg")
const SFX_STAT_UP_2 = preload("res://audio/sfx/battle/BA_stat_up2.ogg")
const SFX_STAT_UP = preload("res://audio/sfx/battle/BA_stat_up.ogg")
const SFX_SPRAY = preload("res://audio/sfx/battle/spray3.mp3")
const LIFE_JAM_SPREAD = preload("res://audio/sfx/battle/BA_life_jam.ogg")
const LIFE_JAM_REVIVE = preload("res://audio/sfx/battle/BA_life_jam_1.ogg")
const HEAL_JUICE = preload("res://audio/sfx/battle/BA_heal_juice.ogg")
const HEAL_HEART = preload("res://audio/sfx/battle/BA_Heart_Heal.ogg")
const SFX_CRITICAL_HIT = preload("res://audio/sfx/battle/BA_CRITICAL_HIT.ogg")
const SFX_MUNCH = preload("res://audio/sfx/battle/GEN_munch.ogg")

const SFX_NEW_SKILL = preload("res://audio/tiles/SE_New_Skill.ogg")


const BRENNA_SPRITE = preload("res://characters/brenna/BrennaAndLuke-2.png (8).png")
const LUKE_SPRITE = preload("res://characters/luke (player)/lukeTransparent.png")

const FA_LUKE_SPRITE = preload("res://characters/luke (player)/FA_luke.png")
const FA_BRENNA_SPRITE = preload("res://characters/brenna/FA_brenna.png")

# SNACKS

const SNACK_LIFE_JAM = preload("res://assets/images/snacks/life_jam.png")
const SNACK_POPCORN = preload("res://assets/images/snacks/popcorn.png")
# TOYS

const TOY_AIR_HORN = preload("res://assets/images/toys/air_horn.png")
const TOY_CONFETTI = preload("res://assets/images/toys/confetti.png")
const TOY_DANDELION = preload("res://assets/images/toys/dandelion.png")
const TOY_DYNAMITE = preload("res://assets/images/toys/dynamite.png")
const TOY_JACKS = preload("res://assets/images/toys/jacks.png")
const TOY_POETRY_BOOK = preload("res://assets/images/toys/poetry_book.png")
const TOY_PRESENT = preload("res://assets/images/toys/present.png")
const TOY_RUBBER_BAND = preload("res://assets/images/toys/rubber_band.png")
const TOY_SPARKLER = preload("res://assets/images/toys/sparkler.png")

# WEAPONS

const WEAPON_KATANA = preload("res://assets/images/weapons/katana.png")
const WEAPON_SPRAY_CAN = preload("res://assets/images/weapons/spray_can.png")

# CHARMS

const CHARM_BOW = preload("res://assets/images/charms/bow.png")
const CHARM_SUNGLASSES = preload("res://assets/images/charms/sunglasses.png")

# DIALOG FACES

const BRENNA_NEUTRAL = preload("res://assets/dialog/faces/brenna_neutral.png")
const BRENNA_ANGRY = preload("res://assets/dialog/faces/brenna_angry.png")
const BRENNA_ENRAGED = preload("res://assets/dialog/faces/brenna_enraged.png")
const BRENNA_FURIOUS = preload("res://assets/dialog/faces/brenna_furious.png")
const BRENNA_HAPPY = preload("res://assets/dialog/faces/brenna_happy.png")
const BRENNA_ECSTATIC = preload("res://assets/dialog/faces/brenna_ecstatic.png")
const BRENNA_MANIC = preload("res://assets/dialog/faces/brenna_manic.png")
const BRENNA_SAD = preload("res://assets/dialog/faces/brenna_sad.png")
const BRENNA_DEPRESSED = preload("res://assets/dialog/faces/brenna_depressed.png")
const BRENNA_MISERABLE = preload("res://assets/dialog/faces/brenna_miserable.png")

const LUKE_NEUTRAL = preload("res://assets/dialog/faces/luke_neutral.png")
const LUKE_HAPPY = preload("res://assets/dialog/faces/luke_happy.png")
const LUKE_ECSTATIC = preload("res://assets/dialog/faces/luke_ecstatic.png")
const LUKE_MANIC = preload("res://assets/dialog/faces/luke_manic.png")
const LUKE_ANGRY = preload("res://assets/dialog/faces/luke_angry.png")
const LUKE_ENRAGED = preload("res://assets/dialog/faces/luke_enraged.png")
const LUKE_FURIOUS = preload("res://assets/dialog/faces/luke_furious.png")
const LUKE_SAD = preload("res://assets/dialog/faces/luke_sad.png")
const LUKE_DEPRESSED = preload("res://assets/dialog/faces/luke_depressed.png")
const LUKE_MISERABLE = preload("res://assets/dialog/faces/luke_miserable.png")


const FA_LUKE_NEUTRAL = preload("res://assets/dialog/faces/fa_luke_neutral.png")
const FA_LUKE_SAD = preload("res://assets/dialog/faces/fa_luke_sad.png")
const FA_LUKE_DEPRESSED = preload("res://assets/dialog/faces/fa_luke_depressed.png")
const FA_LUKE_MISERABLE = preload("res://assets/dialog/faces/fa_luke_miserable.png")
const FA_LUKE_HAPPY = preload("res://assets/dialog/faces/fa_luke_happy.png")
const FA_LUKE_ECSTATIC = preload("res://assets/dialog/faces/fa_luke_ecstatic.png")
const FA_LUKE_MANIC = preload("res://assets/dialog/faces/fa_luke_manic.png")
const FA_LUKE_ANGRY = preload("res://assets/dialog/faces/fa_luke_angry.png")
const FA_LUKE_ENRAGED = preload("res://assets/dialog/faces/fa_luke_enraged.png")
const FA_LUKE_FURIOUS = preload("res://assets/dialog/faces/fa_luke_furious.png")
