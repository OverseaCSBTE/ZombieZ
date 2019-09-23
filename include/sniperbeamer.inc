/* SniperBeamer's Functions
*
* (c) 2003, SniperBeamer
* This file is provided as is (no warranties).
*
*/

#if defined _sniperbeamer_included
  #endinput
#endif
#define _sniperbeamer_included

//----------------------------------------------------------------------------------------------
/*
 Revives a player. (CS)
*/
stock user_revive(index)
{
	new ids[3]
	num_to_str(index,ids,2)
	user_spawn(index)
}

//----------------------------------------------------------------------------------------------
/*
 Kills a player without any message.
 Requires Vexd Utilities.
*/
stock user_silentkill(index)
{
	MessageBlock(gmsgDeathMsg,BLOCK_ONCE)
	user_kill(index,1)
}
//----------------------------------------------------------------------------------------------
/*
 Checks if weapon is primary. (CS 1.5)
*/
stock bool:is_primary(weapon)
{
	if (weapon==CSW_M3||weapon==CSW_XM1014||weapon==CSW_MP5NAVY||weapon==CSW_TMP
	 ||weapon==CSW_P90||weapon==CSW_MAC10||weapon==CSW_UMP45||weapon==CSW_AK47
	 ||weapon==CSW_SG552||weapon==CSW_M4A1||weapon==CSW_AUG||weapon==CSW_SCOUT
	 ||weapon==CSW_AWP||weapon==CSW_G3SG1||weapon==CSW_SG550||weapon==CSW_M249)
		return true
	return false
}
//----------------------------------------------------------------------------------------------
/*
 Checks if weapon is secondary. (CS 1.5)
*/
stock bool:is_secondary(weapon)
{
	if (weapon==CSW_USP||weapon==CSW_GLOCK18||weapon==CSW_DEAGLE||weapon==CSW_P228
	 ||weapon==CSW_ELITE||weapon==CSW_FIVESEVEN)
		return true
	return false
}
//----------------------------------------------------------------------------------------------
/*
 Fades the screen of a player permanent.
*/
stock fade_screen(index,red=255,green=0,blue=0,alpha=100)
{
	if (index==0) return
	message_begin(MSG_ONE,get_user_msgid("ScreenFade"),{0,0,0},index)
	write_short( 1<<0 )
	write_short( 1<<0 )
	write_short( 1<<2 )
	write_byte( red )
	write_byte( green )
	write_byte( blue )
	write_byte( alpha )
	message_end()
}
//----------------------------------------------------------------------------------------------
/*
 Generates a Death Message.
*/
stock make_deathmsg(killer,victim,headshot,weapon[])
{
	message_begin(MSG_ALL,get_user_msgid("DeathMsg"),{0,0,0},0)
	write_byte( killer )
	write_byte( victim )
	write_byte( headshot )
	write_string( weapon[] )
	message_end()
}
//----------------------------------------------------------------------------------------------
/*
 Checks if amx plugin is running.
*/
stock bool:plugin_running(name[])
{
	new filename[2],pname[31],version[2],author[2],status[16]
	for (new i=0; i<get_pluginsnum(); i++)
	{
		get_plugin(i,filename,2,pname,32,version,2,author,2,status,15)
		if (equali(pname,name) && equal(status,"running"))
			return true
	}
	return false
}
//----------------------------------------------------------------------------------------------