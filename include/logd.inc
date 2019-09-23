/* LogD functions
*
* (c) Copyright 2002, dJeyL
* This file is provided as is (no warranties).
*/

#if defined _logd_included
  #endinput
#endif
#define _logd_included

/* Tells LogD about which events to handle.
* This has to be called in plugin_init(). */
native logd_init();


/* 1: CVar */
forward logd_cvar(cvar[],value[]);

/* 2: Log */
forward logd_log(flag[]);

/* 3: Map */
forward logd_map(flag[],map[],optional[]);

/* 4: RCon */
forward logd_rcon(message[]);

/* 5: Host name */
forward logd_hostname(hostname[]);

/* 6: Server say */
forward logd_server_say(chat[]);

/* 50: Connection */
forward logd_connect(id,ip_port[]);

/* 51: Enter game */
forward logd_enter(player);

/* 52: Disconnection */
forward logd_disconnect(player);

/* 53: Suicide */
forward logd_suicide(player);

/* 54: Team selection */
forward logd_team_select(id,team[]);

/* 55: Role selection */
forward logd_role_select(id,role[]);

/* 56: Change name */
forward logd_name_change(id,newname[]);

/* 57: Kill */
forward logd_kill(id1,id2,weapon[],optional[]);

/* 58: Injure */
forward logd_injure(id1,id2,gun[],damage);

/* 59: Player vs player action */
forward logd_players_action(id1,id2,action[]);

/* 60: Player action */
forward logd_player_action(id,action[]);

/* 61: Team action */
forward logd_team_action(team[],action[],optional[]);

/* 62: World action */
forward logd_world_action(action[]);

/* 63: Chat */
forward logd_chat(id,flag[],chat[]);

/* 64: Team alliance */
forward logd_team_alliance(team1[],team2[]);

/* 65: Team score report */
forward logd_team_score(team[],score,players,optional[]);

/* 66: Private chat */
forward logd_private_chat(id1,id2,chat[]);
