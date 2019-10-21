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
	bot_quota = get_cvar_pointer("bot_quota")

	register_clcmd("chooseteam","CMD_ChooseTeam")
	
	server_cmd("bot_stop 1")
	server_cmd("sypb_stop 1")
}

public plugin_precache()
{
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