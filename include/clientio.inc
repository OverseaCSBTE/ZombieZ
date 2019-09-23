/*
 * Client IO helper function library
 *
 * By Ravenous Bugblatter Beast
 * ravenousbugblatterbeast@hotmail.com
 * http://www.ravenousbugblatterbeast.pwp.blueyonder.co.uk
 *
 */


#if defined _clientio_included
  #endinput
#endif
#define _clientio_included

/* MAX_AUTHID_LENGTH+1 for escape */
#define MAX_EAUTHID_LENGTH 40

#include <admin>
#include <core>
#include <string>

stock isbot(AuthID[]) {
  return (strcmp(AuthID,"BOT")==0);
}

stock ishuman(AuthID[]) {
  return (strcmp(AuthID,"BOT")!=0);
}

stock safe_execclient(username[],cmd[]) {
  new AuthID[MAX_AUTHID_LENGTH];
  if (get_userAuthID(username,AuthID)) {
    if (ishuman(AuthID)) {
      execclient(username,cmd);
    }
  }
}

stock safe_execteam(team,cmd[],includedead) {
  new userid = 0;
  new wonid=0;
  new AuthID[MAX_AUTHID_LENGTH];
  new teamid = 0;
  new username[200];
  new i=0;
  new x = 0;
  new dead=0;

  x = maxplayercount();
  for(i=1; i<=x; i=i+1) {
    if (playerinfo(i, username, 200, userid, wonid,teamid,dead,AuthID)==1) {
      if (ishuman(AuthID) && (teamid==team) && (includedead || (dead==0))) {
        execclient(username, cmd);
      }
    }
  }
}

stock safe_execall(cmd[]) {
  new userid = 0;
  new wonid=0;
  new team=0;
  new dead=0;
  new AuthID[MAX_AUTHID_LENGTH];
  new username[200];
  new i=0;
  new x = 0;

  x = maxplayercount();
  for(i=1; i<=x; i=i+1) {
    if(playerinfo(i, username, 200, userid, wonid,team,dead,AuthID)==1) {
      if (ishuman(AuthID)) {
        execclient(username, cmd);
      }
    }
  }
}

/* Builds up a message with no line longer than 78 characters
 * suitable for use with centresay */
stock BuildLine(msg[],txt[],extra,&linelen) {
  new txtlen = strlen(txt);
  if (strlen(txt) + extra + linelen >=78) {
    strcat(msg,"^n",MAX_TEXT_LENGTH);
    linelen=0;
  }
  strcat(msg,txt,MAX_TEXT_LENGTH);
  linelen=linelen + txtlen + extra;
}


stock adminpresent(level) {
  new i;
  new m = maxplayercount();
  new wonid=0;
  new team=0;
  new dead=0;
  new AuthID[MAX_AUTHID_LENGTH];
  new dummy;
  new name[MAX_NAME_LENGTH];

  for(i=1;i<=m;i++) {
    if (playerinfo(i,name,MAX_NAME_LENGTH,dummy,wonid,team,dead,AuthID)) {
      if (access(level,name)) {
        return 1;
      }
    }
  }

  return 0;
}

stock realplayercount(&bots) {
  new i;
  new c=0;
  new m = maxplayercount();
  new wonid=0;
  new team=0;
  new dead=0;
  new AuthID[MAX_AUTHID_LENGTH];
  new dummy;
  new name[MAX_NAME_LENGTH];

  bots=0;
  for(i=1;i<=m;i++) {
    if (playerinfo(i,name,MAX_NAME_LENGTH,dummy,wonid,team,dead,AuthID)) {
      if (isbot(AuthID)) {
        bots++;
      }
      else {
        c++;
      }
    }
  }

  return c;
}

stock safe_convert(HLString,String[],MaxLength) {
  convert_string(HLString,String,MaxLength);
  new l = strlen(String);

  if (l>0) {
    if (String[l-1] == 13) {
      String[l-1] = NULL_CHAR;
    }
  }
}


stock bury_all() {
  new userid = 0;
  new wonid=0;
  new team=0;
  new dead=0;
  new AuthID[MAX_AUTHID_LENGTH];
  new username[MAX_NAME_LENGTH];
  new c=0;
  new i=0;

  c = maxplayercount();
  for(i=1; i<=c; i=i+1) {
    if(playerinfo(i, username, MAX_NAME_LENGTH, userid, wonid,team,dead,AuthID)==1) {
      if (dead == 0) {
        new x, y, z;
        get_userorigin(username, x, y, z);
        teleport(username, x, y, (z-25));
      }
    }
  }
  return 0;
}

stock get_indexFromAuthID(AuthID[]) {
    new EscapedAuthID[MAX_EAUTHID_LENGTH];
    new i;
    EscapedAuthID[0]='\';
    EscapedAuthID[1]=0;
    strcat(EscapedAuthID,AuthID,MAX_EAUTHID_LENGTH);
    if (get_userindex(EscapedAuthID,i)) {
      return i;
    }
    return 0;
}