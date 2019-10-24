/*
	Base on Zombie Mod 3 & Zombie Mod 5 and CSIE Zombie Z
*/
// ==================================================================
// Preprocessor
#pragma compress 1
// ==================================================================

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

// ==================================================================
// Define
// ==================================================================
#define PLUGIN "BTE Zombie ModZ"
#define VERSION "Alpha02"
#define AUTHOR "NekoMeow"
#define MaxPlayer 33
#define MaxLevel 30
// ==================================================================
//#define _DEBUG
// ==================================================================
#include "ZombieModZ/Enum.sma"
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

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	// Event
	register_event("HLTV", "Event_HLTV", "a", "1=0", "2=0")
	register_event("DeathMsg", "Event_DeathMsg", "a")

	// LogEvent
	register_logevent("LogEvent_RoundStart",2, "1=Round_Start")
	register_logevent("LogEvent_RoundEnd", 2, "1=Round_End")
	
	// ImproveAPI
	gmsgSpecial = engfunc(EngFunc_RegUserMsg, "Special2", -1);
	bot_quota = get_cvar_pointer("bot_quota")

	// Ham
	RegisterHam(Ham_Spawn, "player", "HamF_Spawn_Player");
	RegisterHam(Ham_Spawn, "player", "HamF_Spawn_Player_Post",1)

	register_clcmd("chooseteam","CMD_ChooseTeam")

	gZombieZ = engfunc(EngFunc_RegUserMsg, "DieHardZombieZ", -1)
	
	server_cmd("bot_stop 1")
	server_cmd("sypb_stop 1")
}

public plugin_precache()
{

}

public client_putinserver(id)
{
	Connect_Reset(id)
	
	// Reg Ham Zbot
	if (is_user_zbot(id) && !g_hamczbots && get_pcvar_num(bot_quota) > 0)
		set_task(0.1, "Task_Register_Bots", id)
}

public client_disconnect(id)
{

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