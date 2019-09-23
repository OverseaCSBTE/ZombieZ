//----------------------------------------------------------------------------------------------
// Abstract Methods that must be implemented by a save superhero include file...
//
// writeMemoryTable()
// loadXP( id, key[] )
// cleanXP()
//----------------------------------------------------------------------------------------------
/*

//Use this to create the tables
CREATE TABLE `sh_saveskills` (
	`SH_KEY` varchar(34) binary NOT NULL default '',
	`SKILL_NUMBER` int(10) unsigned NOT NULL default '0',
	`HERO_NAME` varchar(25) NOT NULL default '',
	PRIMARY KEY  (`SH_KEY`,`SKILL_NUMBER`)
) TYPE=MyISAM COMMENT='SUPERHERO Skill Saving Table';

CREATE TABLE `sh_savexp` (
	`SH_KEY` varchar(34) binary NOT NULL default '',
	`PLAYER_NAME` varchar(32) binary NOT NULL default '',
	`LAST_PLAY_DATE` timestamp(14) NOT NULL,
	`XP` int(10) unsigned NOT NULL default '0',
	`HUDHELP` tinyint(1) unsigned NOT NULL default '1',
	`SKILL_COUNT` int(3) unsigned NOT NULL default '0',
	PRIMARY KEY  (`SH_KEY`)
) TYPE=MyISAM COMMENT='SUPERHERO XP Saving Table';


//Upgrade from old Version
ALTER TABLE `sh_savexp` ADD `HUDHELP` TINYINT( 1 ) UNSIGNED DEFAULT '1' NOT NULL AFTER `XP` ;

*/

#if defined _shsave_included || !defined SHCORE
	#endinput
#endif
#define _shsave_included

#if defined AMXX_VERSION
	#include <dbi>
	new Sql:gMySQL = SQL_FAILED
#else
	#include <mysql>
	new gMySQL = 0
#endif

// Global to this save class
new gVaultFile[128]

//----------------------------------------------------------------------------------------------
public saving_init()
{

	register_cvar("sh_mysql_host","localhost")
	register_cvar("sh_mysql_user","SuperHeroModUser")
	register_cvar("sh_mysql_pass","")
	register_cvar("sh_mysql_db","sherodb")

	register_concmd("amx_shvaulttosql","adminCopyVault", ADMIN_RCON,"- Copies vault XP to MySQL, should only be done once.")

	#if defined AMXX_VERSION
		get_localinfo("amxx_vault",gVaultFile,127)
	#else
		#if defined AMX_NEW
			copy(gVaultFile,127,"addons/amx/config/vault.ini")
		#else
			copy(gVaultFile,127,"addons/amx/vault.ini")
		#endif
	#endif
}
//----------------------------------------------------------------------------------------------
public adminCopyVault(id,levelx,cidx)
{
	if (!cmd_access(id,levelx,cidx,1)) return

	mySQLConnect()

	#if defined AMXX_VERSION
		if ( gMySQL <= SQL_FAILED ) return
	#else
		if ( gMySQL < 1 ) return
	#endif

	// Open up the vault file - read line by line
	// Use vault to delete to any data over a certain age
	if ( !file_exists(gVaultFile) ) return

	console_print(id,"Please wait while the XP data is copied")

	// Read through the file looking for shinfo entries - Check the epoch time to see if deletion should happen
	new lengthRead, nextLine = 0
	new data[512]

	while ((nextLine = read_file(gVaultFile,nextLine,data,511,lengthRead)) != 0) {
		if ( lengthRead > 0 && containi(data, "shinfo") == 0 ) {
			parseXP(gMemoryTableSize - 1, data)
		}
	}

	// OK now load the XP for any players playing
	new key[35]

	for ( new x = 1; x <= SH_MAXSLOTS; x++ ) {
		if (!is_user_connected(x)) continue
		getSaveKey(x, key)
		loadXP(x, key)
	}
	console_print(id,"Saved XP has been copied from the vault to the MySQL Database Successfully")

}
//----------------------------------------------------------------------------------------------
public parseXP(id, const data[] )
{
	// "name" epochtime XP HUDHELP "SKILL1" "SKILL2" ...
	new heroIndex
	new Left[32], Right[512]

	copy(Right, 511, data)

	//Get the key out
	strbrkqt(Right, Left, 31, Right, 511)
	replace(Left, 31, "shinfo.", "" )
	copy( gMemoryTableKeys[id], 34, Left)

	//Get the name out
	strbrkqt(Right, Left, 31, Right, 511)
	copy( gMemoryTableNames[id], 31, Left)

	//Get the epochtime out
	strbrkqt(Right, Left, 31, Right, 511)

	//Get the XP out and save it
	strbrkqt(Right, Left, 31, Right, 511)
	gMemoryTableXP[id] = str_to_num(Left)

	//Get the HUD Status out
	strbrkqt(Right, Left, 31, Right, 511)

	//Now load in all the skills
	new powerCount = 0
	new MaxPowers = min(get_cvar_num("sh_maxpowers"), SH_MAXLEVELS)

	while ( strlen(Right) > 0 && powerCount < MaxPowers ) {
		strbrkqt(Right, Left, 31, Right, 511)
		heroIndex = findHero(Left)
		if ( heroIndex >= 0 )  {
			if ( getHeroLevel(heroIndex) <= gPlayerLevel[id] ) {
				gMemoryTablePowers[id][0] = ++powerCount
				gMemoryTablePowers[id][powerCount] = heroIndex
			}
		}
	}
	
	// Now save it to the SQL database
	writeData(id)
}
//----------------------------------------------------------------------------------------------
public writeMemoryTable()
{
	if ( !shModActive() ) return
	if ( get_cvar_num("sh_savexp")==0 ) return

	debugMessage("Writing XP Data to SQL Database",0,3)

	// Write Memory Table to File
	for (new x =1; x < gMemoryTableCount; x++) {
		if ( strlen(gMemoryTableKeys[x])>0 ) {
			writeData(x)
		}
		// Can even clear the MemoryKey - if a player is disconnected no reason to save again and again...
		copy(gMemoryTableKeys[x], 34, "")
	}

	// No need to keep disconnected player around...
	gMemoryTableCount = 33
}
//----------------------------------------------------------------------------------------------
//
//AMXX SQL API Code
//
#if defined AMXX_VERSION
//----------------------------------------------------------------------------------------------
public plugin_modules()
{
	require_module("fun")
	require_module("mysql")
	require_module("engine")
	require_module("Counter-Strike")	
}
//----------------------------------------------------------------------------------------------
public mySQLConnect()
{
	if ( gMySQL == SQL_OK ) return

	new host[64],user[32],pass[32],db[32],error[128]

	get_cvar_string("sh_mysql_host",host,63)
	get_cvar_string("sh_mysql_user",user,31)
	get_cvar_string("sh_mysql_pass",pass,31)
	get_cvar_string("sh_mysql_db",db,31)

	if ( !strlen(host) && !strlen(user) && !strlen(db) ) {
		get_cvar_string("amx_mysql_host",host,63)
		get_cvar_string("amx_mysql_user",user,31)
		get_cvar_string("amx_mysql_pass",pass,31)
		get_cvar_string("amx_mysql_db",db,31)
	}

	gMySQL = dbi_connect(host,user,pass,db,error,127)
	if( gMySQL <= SQL_FAILED) {
		server_print("SuperHero MySQL connect error: '%s' (%s,%s,%s)",error,host,user,db)
	}
}
//----------------------------------------------------------------------------------------------
public writeData(x)
{
	// Flushes data in memory table position x to database...
	mySQLConnect()
	if ( gMySQL <= SQL_FAILED ) return

	new error[128],sql[512]
	new Result:retval

	format(sql, 511, "REPLACE INTO `sh_savexp` VALUES ('%s','%s',SYSDATE(),'%d','%d','%d')", gMemoryTableKeys[x], gMemoryTableNames[x],gMemoryTableXP[x],gMemoryTableHHelp[x],gMemoryTablePowers[x][0] )
	retval = dbi_query(gMySQL,sql)
	if( retval == RESULT_FAILED) {
		dbi_error(gMySQL,error,127)
		server_print("Superero Error Writing MySQL XP for %s: '%s' - '%s'", gMemoryTableKeys[x], sql, error)
		return
	}
	dbi_free_result(retval)

	// Saving by SuperHeroName since the hero order in the plugin.ini can change...
	for ( new p = 1; p <= gMemoryTablePowers[x][0]; p++) {
		new heroIndex=gMemoryTablePowers[x][p]
		format(sql, 511, "REPLACE INTO `sh_saveskills` VALUES ('%s','%d','%s')", gMemoryTableKeys[x],p,gSuperHeros[heroIndex][hero] )
		retval = dbi_query(gMySQL,sql)
		if( retval == RESULT_FAILED) {
			dbi_error(gMySQL,error,127)
			server_print("Superero Error Writing MySQL XP for %s: '%s' - '%s'", gMemoryTableKeys[x], sql, error)
			return
		}
		dbi_free_result(retval)
	}
}
//----------------------------------------------------------------------------------------------
public loadXP( id, key[] )
{

	mySQLConnect()
	if ( gMySQL <= SQL_FAILED ) return false

	new sql[512], error[128]
	new xp[10], skillCount[10], hudHelp[3]
	new Result:retvalxp, Result:retvalskill
	new skills = 0

	format(sql, 511, "SELECT `XP`, `HUDHELP`, `SKILL_COUNT` FROM `sh_savexp` WHERE `SH_KEY` = '%s'", key)
	retvalxp = dbi_query(gMySQL,sql)
	if (retvalxp == RESULT_FAILED) {
		dbi_error(gMySQL,error,127)
		server_print("Superero Error Loading MySQL XP for %s: '%s' - '%s'", key, sql, error)
		return false
	}
	else if (retvalxp == RESULT_NONE) {
		dbi_error(gMySQL,error,127)
		format(debugt,127,"No Saved XP Loaded for %s: '%s'", key, error)
		debugMessage(debugt,id)
		return true
	}

	if (dbi_nextrow(retvalxp) > 0) {

		dbi_field(retvalxp, 1, xp, 9)
		gPlayerXP[id] = str_to_num(xp)
		gPlayerLevel[id] = getLevel(id)
		setLevel(id, gPlayerLevel[id] )

		dbi_field(retvalxp, 2, hudHelp, 2)
		hudHelpStatus[id] = str_to_num(hudHelp) ? true : false

		dbi_field(retvalxp, 3, skillCount, 9)

		format(sql, 511, "SELECT `HERO_NAME` FROM `sh_saveskills` WHERE `SH_KEY` = '%s' AND `SKILL_NUMBER` <= '%s'", key, skillCount )
		retvalskill = dbi_query(gMySQL,sql)

		if (retvalskill == RESULT_FAILED) {
			dbi_error(gMySQL,error,127)
			server_print("Superero Error Loading MySQL XP for %s: '%s' - '%s'", key, sql, error)
			return false
		}
		gPlayerPowers[id][0] = 0
		while ( dbi_nextrow(retvalskill) > 0 ) {
			new heroName[25]
			dbi_field(retvalskill, 1, heroName, 24)
			new heroIndex = getHeroIndex(heroName)
			if ( heroIndex >= 0 && getHeroLevel(heroIndex) <= gPlayerLevel[id] ) {
				gPlayerPowers[id][0]= ++skills
				gPlayerPowers[id][skills] = heroIndex
				initHero(id, heroIndex)
			}
		}
		dbi_free_result(retvalskill)
		updateMemoryTable(id)
	}
	dbi_free_result(retvalxp)

	return true
}
//----------------------------------------------------------------------------------------------
public cleanXP(bool:clearAll)
{
	if ( !clearAll && (!shModActive() || get_cvar_num("sh_savexp") == 0)) return

	new error[128], sql[255]
	new Result:retval

	mySQLConnect()
	if ( gMySQL <= SQL_FAILED ) return

	if (clearAll) {
		format(sql, 254, "TRUNCATE TABLE `sh_saveskills`")
		retval = dbi_query(gMySQL,sql)
		if( retval == RESULT_FAILED) {
			dbi_error(gMySQL,error,127)
			server_print("SuperHero: Couldn't Erase XP: '%s' - '%s'", sql, error)
			return
		}
		dbi_free_result(retval)

		format(sql, 254, "TRUNCATE TABLE `sh_savexp`")
		retval = dbi_query(gMySQL,sql)
		if( retval == RESULT_FAILED) {
			dbi_error(gMySQL,error,127)
			server_print("SuperHero: Couldn't Erase XP: '%s' - '%s'", sql, error)
			return
		}
		dbi_free_result(retval)
	}
	else {
		format(sql, 254, "DELETE FROM `sh_saveskills` USING `sh_saveskills`, `sh_savexp` WHERE sh_savexp.`SH_KEY` = sh_saveskills.`SH_KEY` AND sh_savexp.`LAST_PLAY_DATE` < (SYSDATE() - INTERVAL '%d' DAY)", get_cvar_num("sh_xpsavedays") )
		retval = dbi_query(gMySQL,sql)
		if( retval == RESULT_FAILED) {
			dbi_error(gMySQL,error,127)
			server_print("SuperHero Couldn't Clean XP: '%s' - '%s'", sql, error)
			return
		}
		dbi_free_result(retval)

		format(sql, 254, "DELETE FROM `sh_savexp` WHERE `LAST_PLAY_DATE` < (SYSDATE() - INTERVAL '%d' DAY)", get_cvar_num("sh_xpsavedays") )
		retval = dbi_query(gMySQL,sql)
		if( retval == RESULT_FAILED) {
			dbi_error(gMySQL,error,127)
			server_print("SuperHero Couldn't Clean XP: '%s' - '%s'", sql, error)
			return
		}
		dbi_free_result(retval)

		format(sql, 254, "DELETE FROM `sh_saveskills` USING `sh_saveskills`, `sh_savexp` WHERE sh_savexp.`SH_KEY` = sh_saveskills.`SH_KEY` AND sh_saveskills.`SKILL_NUMBER` > sh_savexp.`SKILL_COUNT`")
		retval = dbi_query(gMySQL,sql)
		if( retval == RESULT_FAILED ) {
			dbi_error(gMySQL,error,127)
			server_print("SuperHero Couldn't Clean XP: '%s' - '%s'", sql, error)
			return
		}
		dbi_free_result(retval)

	}
}
//----------------------------------------------------------------------------------------------
public saving_end()
{
	dbi_close(gMySQL)
}
//----------------------------------------------------------------------------------------------
//
//AMX SQL API Code
//
#else
//----------------------------------------------------------------------------------------------
public mySQLConnect()
{
	if (gMySQL > 0 ) return

	new host[64],user[32],pass[32],db[32],error[128]

	get_cvar_string("sh_mysql_host",host,63)
	get_cvar_string("sh_mysql_user",user,31)
	get_cvar_string("sh_mysql_pass",pass,31)
	get_cvar_string("sh_mysql_db",db,31)

	if ( !strlen(host) && !strlen(user) && !strlen(db) ) {
		get_cvar_string("amx_mysql_host",host,63)
		get_cvar_string("amx_mysql_user",user,31)
		get_cvar_string("amx_mysql_pass",pass,31)
		get_cvar_string("amx_mysql_db",db,31)
	}

	gMySQL = mysql_connect(host,user,pass,db,error,127)
	if( gMySQL < 1) {
		server_print("SuperHero MySQL connect error: '%s' (%s,%s,%s) - %d",error,host,user,db,gMySQL)
	}
}
//----------------------------------------------------------------------------------------------
public writeData(x)
{
	// Flushes data in memory table position x to database...
	mySQLConnect()
	if ( gMySQL < 1 ) return

	new error[128],sql[512]

	format(sql, 511, "REPLACE INTO `sh_savexp` VALUES ('%s','%s',SYSDATE(),'%d','%d','%d')", gMemoryTableKeys[x], gMemoryTableNames[x],gMemoryTableXP[x],gMemoryTableHHelp[x],gMemoryTablePowers[x][0] )
	if(mysql_query(gMySQL,sql) < 1) {
		mysql_error(gMySQL,error,127)
		server_print("Superero Error Writing MySQL XP for %s: '%s' - '%s' - %d", gMemoryTableKeys[x], sql, error, gMySQL)
		return
	}

	// Saving by SuperHeroName since the hero order in the plugin.ini can change...
	for ( new p = 1; p <= gMemoryTablePowers[x][0]; p++) {
		new heroIndex=gMemoryTablePowers[x][p]
		format(sql, 511, "REPLACE INTO `sh_saveskills` VALUES ('%s','%d','%s')", gMemoryTableKeys[x],p,gSuperHeros[heroIndex][hero] )
		if(mysql_query(gMySQL,sql) < 1) {
			mysql_error(gMySQL,error,127)
			server_print("Superero Error Writing MySQL XP for %s: '%s' - '%s' - %d", gMemoryTableKeys[x], sql, error, gMySQL)
			return
		}
	}
}
//----------------------------------------------------------------------------------------------
public loadXP( id, key[] )
{

	mySQLConnect()
	if ( gMySQL < 1 ) return false

	new error[128]
	new sql[512]
	new xp[10]
	new skillCount[10], hudHelp[3]
	new skills=0

	format(sql, 511, "SELECT `XP`, `HUDHELP`, `SKILL_COUNT` FROM `sh_savexp` WHERE `SH_KEY` = '%s'", key)
	if(mysql_query(gMySQL,sql) < 1) {
		mysql_error(gMySQL,error,127)
		format(debugt,127,"No Saved XP Loaded: %s:'%s'",key,error)
		debugMessage(debugt,id)
	}
	else {
		if (mysql_nextrow(gMySQL) > 0) {
			
			mysql_getfield(gMySQL, 1, xp, 9)
			gPlayerXP[id]=str_to_num(xp)
			gPlayerLevel[id]=getLevel(id)
			setLevel(id, gPlayerLevel[id] )

			mysql_getfield(gMySQL, 2, hudHelp, 2)
			hudHelpStatus[id] = str_to_num(hudHelp) ? true : false

			mysql_getfield(gMySQL, 3, skillCount, 9)
			format(sql, 511, "SELECT `HERO_NAME` FROM `sh_saveskills` WHERE `SH_KEY` = '%s' AND `SKILL_NUMBER` <= '%s'", key, skillCount )
			if ( mysql_query(gMySQL,sql) >= 1 ) {
				gPlayerPowers[id][0]=0
				while ( mysql_nextrow(gMySQL) > 0 ) {
					new heroName[25]
					mysql_getfield(gMySQL, 1, heroName, 24)
					new heroIndex=getHeroIndex(heroName)
					if ( heroIndex>=0 && getHeroLevel(heroIndex)<=gPlayerLevel[id] ) {
						gPlayerPowers[id][0]=++skills
						gPlayerPowers[id][skills]=heroIndex
						initHero(id, heroIndex)
					}
				}
			}
			updateMemoryTable(id)
		}
	}
	return true
}
//----------------------------------------------------------------------------------------------
public cleanXP(bool:clearAll)
{
	if ( !clearAll && (!shModActive() || get_cvar_num("sh_savexp") == 0)) return

	new error[127], sql[255]

	mySQLConnect()
	if ( gMySQL < 1) return

	if (clearAll) {
		format(sql, 254, "TRUNCATE TABLE `sh_saveskills`")
		if (mysql_query(gMySQL, sql) < 1) {
			mysql_error(gMySQL,error,127)
			server_print("SuperHero: Couldn't Erase XP: '%s' - '%s' - %d", sql, error, gMySQL)
			return
		}
		format(sql, 254, "TRUNCATE TABLE `sh_savexp`")
		if (mysql_query(gMySQL, sql) < 1) {
			mysql_error(gMySQL,error,127)
			server_print("SuperHero: Couldn't Erase XP: '%s' - '%s' - %d", sql, error, gMySQL)
			return
		}
	}
	else {
		format(sql, 254, "DELETE FROM `sh_saveskills` USING `sh_saveskills`, `sh_savexp` WHERE sh_savexp.`SH_KEY` = sh_saveskills.`SH_KEY` AND sh_savexp.`LAST_PLAY_DATE` < (SYSDATE() - INTERVAL '%d' DAY)", get_cvar_num("sh_xpsavedays") )
		if (mysql_query(gMySQL, sql) < 1) {
			mysql_error(gMySQL,error,127)
			server_print("SuperHero Couldn't Clean XP: '%s' - '%s' - %d", sql, error, gMySQL)
			return
		}

		format(sql, 254, "DELETE FROM `sh_savexp` WHERE `LAST_PLAY_DATE` < (SYSDATE() - INTERVAL '%d' DAY)", get_cvar_num("sh_xpsavedays") )
		if (mysql_query(gMySQL, sql) < 1) {
			mysql_error(gMySQL,error,127)
			server_print("SuperHero: Couldn't Clean XP: '%s' - '%s' - %d", sql, error, gMySQL)
			return
		}

		format(sql, 254, "DELETE FROM `sh_saveskills` USING `sh_saveskills`, `sh_savexp` WHERE sh_savexp.`SH_KEY` = sh_saveskills.`SH_KEY` AND sh_saveskills.`SKILL_NUMBER` > sh_savexp.`SKILL_COUNT`")
		if (mysql_query(gMySQL, sql) < 1) {
			mysql_error(gMySQL,error,127)
			server_print("SuperHero: Couldn't Clean XP: '%s' - '%s' - %d", sql, error, gMySQL)
			return
		}
	}
}
//----------------------------------------------------------------------------------------------
public saving_end()
{
	mysql_close(gMySQL)
}
//----------------------------------------------------------------------------------------------
#endif