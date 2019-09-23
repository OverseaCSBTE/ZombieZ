/*
	Base on Zombie Mod 3 & Zombie Mod 5 Modified
*/

#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <xs>
#include <round_terminator>
#include <improve_api>
#include "bte_api.inc"
#include "metahook.inc"
#include "cdll_dll.h"
#include "ZombieModZ/inc.inc"

#define PLUGIN "BTE Zombie ModZ"
#define VERSION "Alpha build001"
#define AUTHOR "15minutes & NekoMeow"
// ==================================================================
//#define _DEBUG
// ==================================================================
#include "ZombieModZ/Vars.sma"
#include "ZombieModZ/Stocks.sma"
#include "ZombieModZ/Task.sma"
#include "ZombieModZ/Util.sma"
#include "ZombieModZ/Public.sma"
#include "ZombieModZ/ReadFile.sma"
#include "ZombieModZ/Forward.sma"
#include "ZombieModZ/Ham.sma"
#include "ZombieModZ/EventCmd.sma"
#include "ZombieModZ/Natives.sma"
#include "ZombieModZ/Menu.sma"
// ==================================================================

new bot_quota

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_event("HLTV", "Event_HLTV", "a", "1=0", "2=0")
	register_event("DeathMsg", "Event_DeathMsg", "a")

	register_logevent("LogEvent_RoundStart",2, "1=Round_Start")
	register_logevent("LogEvent_RoundEnd", 2, "1=Round_End")
	
	// ImproveAPI
	gmsgSpecial = engfunc(EngFunc_RegUserMsg, "Special2", -1);
	
	register_clcmd("chooseteam","CMD_ChooseTeam")
	register_clcmd("bte_zbz_select_zombie","CMD_SelectZombie")
	register_clcmd("weapon_zombibomb","CMD_ZombiBomb")
	register_clcmd("weapon_zombibomb2","CMD_ZombiBomb2")

	// Ham
	RegisterHam(Ham_Player_PreThink, "player", "HamF_PreThink")
	RegisterHam(Ham_Spawn, "player", "HamF_Spawn_Player");
	RegisterHam(Ham_Spawn, "player", "HamF_Spawn_Player_Post",1)
	RegisterHam(Ham_Killed, "player", "HamF_Killed")
	RegisterHam(Ham_Killed, "player", "HamF_Killed_Post",1)
	RegisterHam(Ham_TakeDamage, "player", "HamF_TakeDamage")
	
	RegisterHam(Ham_Touch, "weaponbox", "HamF_TouchWeaponBox")
	
	RegisterHam(Ham_Think, "grenade", "HamF_Think_Grenade")
	RegisterHam(Ham_Touch, "grenade", "HamF_Touch_Zombiebomb2")

	RegisterHam(Ham_Item_Deploy, "weapon_hegrenade", "HamF_ZombieDeploy",1)
	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_hegrenade", "HamF_GrenadePrimaryAttack_Post",1)
	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_hegrenade", "HamF_GrenadePrimaryAttack")

	RegisterHam(Ham_Item_Deploy, "weapon_flashbang", "HamF_ZombieDeploy",1)
	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_flashbang", "HamF_GrenadePrimaryAttack_Post",1)
	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_flashbang", "HamF_GrenadePrimaryAttack")

	RegisterHam(Ham_Item_Deploy, "weapon_knife", "HamF_ZombieDeploy",1)
	
	RegisterHam(Ham_Think, "info_target", "HamF_ThinkEButton")
	
	RegisterHam(Ham_Use, "func_button", "HamF_UseSupplyBox", 1)
	RegisterHam(Ham_Touch, "func_button", "HamF_TouchSupplyBox")

	// Fakemeta
	register_forward(FM_EmitSound, "Forward_EmitSound")
	register_forward(FM_SetModel, "Forward_SetModel")
	register_forward(FM_ClientKill, "Forward_ClientKill")
	register_forward(FM_PlayerPostThink, "Forward_PlayerPostThink", 1);
	register_forward(FM_StartFrame, "Forward_StartFrame", 1);
	unregister_forward(FM_Spawn, gFwSpawn)

	// Message ID
	gDeathMsg = get_user_msgid("DeathMsg")
	gMsgScoreAttrib = get_user_msgid("ScoreAttrib")
	gMsgStatusIcon = get_user_msgid("StatusIcon")
	gMsgScoreInfo = get_user_msgid("ScoreInfo")
	gMsgScenario = get_user_msgid("Scenario")
	gMsgHostagePos = get_user_msgid("HostagePos")
	gMsgFlashBat = get_user_msgid("FlashBat")
	gMsgNVGToggle = get_user_msgid("NVGToggle")
	gMsgTextMsg = get_user_msgid("TextMsg")
	gMsgSendAudio = get_user_msgid("SendAudio")
	gMsgTeamScore = get_user_msgid("TeamScore")
	gMsgScreenFade = get_user_msgid("ScreenFade");
	gMsgClCorpse = get_user_msgid("ClCorpse")
	gMsgScreenShake = get_user_msgid("ScreenShake")
	gMsgWeaponList = get_user_msgid("WeaponList")
	gMsgTeamInfo = get_user_msgid("TeamInfo")
	
	// Message Hook
	set_msg_block(gMsgNVGToggle, BLOCK_SET)
	set_msg_block(gMsgScenario, BLOCK_SET)
	set_msg_block(gMsgHostagePos, BLOCK_SET)
	
	register_message(gMsgTextMsg, "Message_TextMsg")
	register_message(gMsgSendAudio, "Message_SendAudio")
	register_message(gMsgTeamScore, "Message_TeamScore")
	register_message(gMsgClCorpse, "Message_ClCorpse")
	register_message(gMsgStatusIcon, "Message_StatusIcon")
	register_message(gMsgScoreInfo, "Message_ScoreInfo")
	
	register_clcmd("nightvision", "CMD_Nightvision")
	
	register_clcmd("bte_zbz_reinforce", "CMD_Reinforce")
	
	Cvar_HolsterBomb = register_cvar("bte_zbz_holster_zombiebomb", "1")
	Cvar_Jump = register_cvar("zb3_enable_jump", "1")
	bot_quota = get_cvar_pointer("bot_quota")
	gFwUserInfected = CreateMultiForward("bte_zb_infected", ET_IGNORE, FP_CELL, FP_CELL)

	LoadPlayerSpawns()
	LoadBoxSpawns()
	
	// Run Command
	server_cmd("bte_wpn_buyzone 0")
	server_cmd("bte_wpn_free 0")
	server_cmd("sypb_gamemode 2")
	server_cmd("mp_autoteambalance 0")
	
	server_cmd("bot_stop 1")
	server_cmd("sypb_stop 1")
}

public plugin_precache()
{
	// Sound & Ents
	g_objective_ents = ArrayCreate(32, 1)
	sound_human_death = ArrayCreate(64, 1)
	sound_female_death = ArrayCreate(64, 1)
	sound_zombie_coming = ArrayCreate(64, 1)
	sound_zombie_comeback = ArrayCreate(64, 1)
	sound_zombie_attack = ArrayCreate(64, 1)
	sound_zombie_hitwall = ArrayCreate(64, 1)
	sound_zombie_swing = ArrayCreate(64, 1)
	
	// Zombie Class
	zombie_name = ArrayCreate(64, 1)
	zombie_model = ArrayCreate(64,1)
	zombie_gravity = ArrayCreate(1, 1)
	zombie_speed = ArrayCreate(1, 1)
	zombie_knockback = ArrayCreate(1, 1)
	zombie_sound_death1 = ArrayCreate(64, 1)
	zombie_sound_death2 = ArrayCreate(64, 1)
	zombie_sound_hurt1 = ArrayCreate(64, 1)
	zombie_sound_hurt2 = ArrayCreate(64, 1)
	zombie_viewmodel_host = ArrayCreate(64, 1)
	zombie_viewmodel_origin = ArrayCreate(64, 1)
	zombie_modelindex_host = ArrayCreate(1, 1)
	zombie_modelindex_origin = ArrayCreate(1, 1)
	zombie_wpnmodel = ArrayCreate(64, 1)
	zombie_wpnmodel2 = ArrayCreate(64, 1)
	zombie_sound_heal = ArrayCreate(64, 1)
	zombie_sound_evolution = ArrayCreate(64, 1)
	zombiebom_viewmodel = ArrayCreate(64, 1)
	zombiebom_viewmodel2 = ArrayCreate(64, 1)
	zombie_sex = ArrayCreate(1, 1)
	zombie_modelindex = ArrayCreate(1, 1)
	zombie_xdamage = ArrayCreate(1, 1)
	zombie_xdamage2 = ArrayCreate(1, 1)
	zombie_hosthand = ArrayCreate(1, 1)
	
	LoadConfig()
	LoadConfigMap()
	
	// Precache Sound
	new i, buffer[128]

	for (i = 0; i < ArraySize(sound_zombie_comeback); i++)
	{
		ArrayGetString(sound_zombie_comeback, i, buffer, charsmax(buffer))
		engfunc(EngFunc_PrecacheSound, buffer)
	}
	for (i = 0; i < ArraySize(sound_human_death); i++)
	{
		ArrayGetString(sound_human_death, i, buffer, charsmax(buffer))
		engfunc(EngFunc_PrecacheSound, buffer)
	}
	for (i = 0; i < ArraySize(sound_female_death); i++)
	{
		ArrayGetString(sound_female_death, i, buffer, charsmax(buffer))
		engfunc(EngFunc_PrecacheSound, buffer)
	}
	for (i = 0; i < ArraySize(sound_zombie_attack); i++)
	{
		ArrayGetString(sound_zombie_attack, i, buffer, charsmax(buffer))
		engfunc(EngFunc_PrecacheSound, buffer)
	}
	for (i = 0; i < ArraySize(sound_zombie_hitwall); i++)
	{
		ArrayGetString(sound_zombie_hitwall, i, buffer, charsmax(buffer))
		engfunc(EngFunc_PrecacheSound, buffer)
	}
	for (i = 0; i < ArraySize(sound_zombie_swing); i++)
	{
		ArrayGetString(sound_zombie_swing, i, buffer, charsmax(buffer))
		engfunc(EngFunc_PrecacheSound, buffer)
	}
	
	precache_sound(SUPPLYBOX_SOUND_PICKUP)
	precache_sound(ZOMBIEBOM_SOUND_EXP)
	
	// Precache Models
	engfunc(EngFunc_PrecacheModel, SUPPLYBOX_MODEL)
	engfunc(EngFunc_PrecacheModel, ZOMBIEBOMB_MODEL_P)
	engfunc(EngFunc_PrecacheModel, ZOMBIEBOMB_MODEL_W)
	engfunc(EngFunc_PrecacheModel, "sprites/e_button01.spr")

	cache_spr_zombie_respawn = precache_model("sprites/zb_respawn.spr")
	cache_spr_zombiebomb_exp = engfunc(EngFunc_PrecacheModel, "sprites/zombiebomb_exp.spr")

	// Hero Model
	format(buffer, charsmax(buffer), "models/player/%s/%s.mdl", HERO_MODEL_MALE, HERO_MODEL_MALE)
	HERO_MODEL_MALE_INDEX = engfunc(EngFunc_PrecacheModel, buffer)
	format(buffer, charsmax(buffer), "models/player/%s/%s.mdl", HERO_MODEL_FEMALE, HERO_MODEL_FEMALE)
	HERO_MODEL_FEMALE_INDEX = engfunc(EngFunc_PrecacheModel, buffer)
	
	// Precache ??
	RegisterHam(Ham_Precache, "hostage_entity", "HamF_HostagePrecache")
	gFwSpawn = register_forward(FM_Spawn, "Forward_Spawn")
	g_player_weaponstrip = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "player_weaponstrip"))
	dllfunc(DLLFunc_Spawn, g_player_weaponstrip)
	
	new ent
	if (g_ambience_fog)
	{
		ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_fog"))
		if (pev_valid(ent))
		{
			Set_Kvd(ent, "density", g_fog_density, "env_fog")
			Set_Kvd(ent, "rendercolor", g_fog_color, "env_fog")
		}
	}
	if (g_ambience_rain)
		engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_rain"))
	if (g_ambience_snow)
		engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_snow"))

	ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_map_parameters"))
	Set_Kvd(ent, "buying", "3", "info_map_parameters")
	dllfunc(DLLFunc_Spawn, ent)
	
	if (g_sky_enable)
	{
		set_cvar_string("sv_skyname", g_skyname)
	}
}

public client_putinserver(id)
{
	Connect_Reset(id)
	
	// Reg Ham Zbot
	if (is_user_zbot(id) && !g_hamczbots && get_pcvar_num(bot_quota) > 0)
		set_task(0.1, "Task_Register_Bots", id)
		
	set_task(0.1,"Task_SetLight",id)
}

public client_disconnect(id)
{
	if (task_exists(TASK_MAKEZOMBIE) && g_zbselected[id])
	{
		g_zbselected[id] = 0
		
		new iRan = GetRandomPlayer(2)
		
		if(!iRan)
			return
		
		g_zbselected[iRan] = 1
		MH_SendZB3Data(iRan, 20, g_count_down - 1)
	}
}

public plugin_cfg()
{
	new cfgdir[32]
	get_configsdir(cfgdir, charsmax(cfgdir))

	server_cmd("exec %s/%s", cfgdir, CVAR_FILE)
}

stock is_user_zbot(id)
{
	if (!is_user_bot(id))
		return 0;

	new tracker[2], friends[2], ah[2]
	get_user_info(id,"tracker",tracker,1)
	get_user_info(id,"friends",friends,1)
	get_user_info(id,"_ah",ah,1)

	if (tracker[0] == '0' && friends[0] == '0' && ah[0] == '0')
		return 0; // PodBot / YaPB / SyPB

	return 1; // Zbot
}