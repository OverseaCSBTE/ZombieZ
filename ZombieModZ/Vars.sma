// Message ID
new gDeathMsg, gMsgScoreAttrib, gMsgStatusIcon, gMsgScoreInfo, gMsgScenario, 
gMsgHostagePos, gMsgFlashBat, gMsgNVGToggle, gMsgTextMsg, gMsgSendAudio, 
gMsgTeamScore, gMsgScreenFade, gMsgClCorpse, gMsgScreenShake, gMsgWeaponList, 
gMsgTeamInfo

// Cvar
new Cvar_HolsterBomb, Cvar_Jump

// Fakemeta
new gFwSpawn, gFwUserInfected, gFwDummyResult

// Arrays
new Array:g_objective_ents, Array:sound_human_death, Array:sound_female_death, Array:sound_zombie_coming, Array:sound_zombie_comeback, Array:sound_zombie_attack, Array:sound_zombie_hitwall, Array:sound_zombie_swing

// Zombie Arrays
new Array:zombie_name, Array:zombie_model, Array:zombie_gravity, 
Array:zombie_speed, Array:zombie_knockback, 
Array:zombie_sound_death1, Array:zombie_sound_death2, 
Array:zombie_sound_hurt1, Array:zombie_sound_hurt2, 
Array:zombie_viewmodel_host, Array:zombie_viewmodel_origin, 
Array:zombie_modelindex_host, Array:zombie_modelindex_origin, 
Array:zombie_wpnmodel, Array:zombie_wpnmodel2, 
Array:zombie_sound_heal, Array:zombie_sound_evolution, 
Array:zombiebom_viewmodel, Array:zombiebom_viewmodel2, 
Array:zombie_sex, Array:zombie_modelindex, 
Array:zombie_xdamage, Array:zombie_xdamage2, Array:zombie_hosthand

// Hero
new HERO_MODEL_MALE[64], HERO_MODEL_FEMALE[64]
new HERO_HEALTH = 3000
new HERO_MODEL_MALE_INDEX, HERO_MODEL_FEMALE_INDEX

// Supplybox
new Float:SUPPLYBOX_TIME, Float:SUPPLYBOX_TIME_FIRST
new SUPPLYBOX_CLASSNAME[] = "bte_supplybox", 
SUPPLYBOX_SOUND_PICKUP[]="zombi/get_box.wav", 
SUPPLYBOX_SOUND_DROP[]="zombi/zombi_box.wav"
new const SUPPLYBOX_MODEL[]="models/supplybox.mdl"

new SUPPLYBOX_NUM, SUPPLYBOX_MAX

new Float:g_spawns[MAX_SPAWNS][3][3], Float:g_spawns_box[MAX_SPAWNS][3]
new g_spawnCount, g_spawnCount_box

// ZombiBomb
new Float:ZOMBIEBOM_RADIUS=400.0, Float:ZOMBIEBOM_POWER=1500.0
new ZOMBIEBOM_SOUND_EXP[]="zombi/zombi_bomb_exp.wav"
new ZOMBIEBOMB_MODEL_W[]="models/w_zombibomb.mdl", 
ZOMBIEBOMB_MODEL_P[]="models/p_zombibomb.mdl"

// Cache
new cache_spr_zombie_respawn, cache_spr_zombiebomb_exp

// Enviroments
new g_light[2], g_skyname[32], g_fog_density[32], g_fog_color[32]
new g_sky_enable, g_ambience_rain, g_ambience_fog, g_ambience_snow

// Zombie
new ZB_LV1_HEALTH, ZB_LV1_ARMOR
new ZB_LV2_HEALTH, ZB_LV2_ARMOR
new ZB_LV3_HEALTH, ZB_LV3_ARMOR

// Settings
new Float:c_flHostHead[2], Float:c_flHostSpeed[2], Float:c_flHostJump[2]
new Float:RESTORE_HEALTH_TIME, RESTORE_HEALTH_LV1, RESTORE_HEALTH_LV2
new Float:ZOMBIEBOM_DAMAGE
new RESPAWN_TIME_WAIT = 2, ALIVE_TERM = 30, FORCERESPAWN_TIME = 45
new levelupsound

// ImproveAPI
new gmsgSpecial

// Need To Sort
new	g_newround, g_endround, 
g_startcount, g_rount_count, 
g_supplybox_count, g_count_down, g_count_down2, g_hamczbots

new Float:g_evolution[33], Float:g_flTotalDmg[33]
new	g_level[33], g_nvg[33], 
g_restore_health[33], g_respawning[33], g_respawn_count[33], 
g_hero[33], g_human[33], 
g_zombie[33], g_zbselected[33],g_zombie_die[33], g_zombieclass[33], 
g_zombie_health_start[33], g_zombie_armor_start[33], g_zbclass_keep[33], 
g_sidekick[33], g_iTankercount[33]

new Float:g_AliveCheckTime[33], Float:g_ForcerespawnTime

new g_szLogName[128]
new g_player_weaponstrip
