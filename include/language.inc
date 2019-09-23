/*
 * Multi-Lingual function library
 *
 * By Ravenous Bugblatter Beast
 * ravenousbugblatterbeast@hotmail.com
 * http://www.ravenousbugblatterbeast.pwp.blueyonder.co.uk
 *
 *
 * This include file contains the functions necessary to support multi-lingual
 * messaging in your plugins.
 *
 *
 * Remember that the player must have plugin_blatt_language installed with your plugin
 * in order for them to choose a language.
 *
 *
 * Functions:
 *
 * language_init()  -  You must call this from plugin_init()
 * language_update()  -  Used for communication with plugin_blatt_language - ignore
 *
 * language_get(UserIndex)  -  Returns a players chosen language ID
 * language_getbyname(UserName)  -  As above
 *
 * language_say(UserIndex,MessageList,Location)  -  Sends a message to the user in their chosen language.
 * language_saybyname(UserName,MessageList,Location)  -  As above using user name instead of index to identify user
 * language_sayall(MessageList,Locaiton)  -  Sends a message to all users in their chosen languages
 *
 * language_sayf(UserIndex,MessageList,Location,...) - Same as langauge_say, with a format string
 * language_saybynamef(UserName,MessageList,Location,...) - Same as langauge_saybyname, with a format string
 * language_sayallf(MessageList,Locaiton,...) - Same as language_sayallf, with a format string
 *
 *
 *
 *
 * Message Lists
 *
 * You declare a MessageList for use with this plugin by creating a string with the | character
 * seperating the versions for each language. English must be the first language and must always
 * be present. The order for other languages is:
 *
 * 1: English
 * 2: French
 * 3: German
 * 4: Spanish
 *
 * E.g.
 * new g_MSG_ONE[] = "One|Un|Ein|Uno";
 *
 * If you do not have a transalation for a particular language available, leave an empty message
 * in the string - .e.g If you have no german translation, the above string would be:
 *
 * new g_MSG_ONE[] = "One|Un||Uno";
 *
 *
 *
 * Formatted Message Lists
 *
 * If you use the "sayf" versions of the functions, you can include snprintf-type format strings in the message lists.
 * However, unlike printf you must include a number between the % and the letter code - e.g. "%2s" instead of "%s". The
 * number is the position of the argument in the argument list. This allows you to repeat the same argument twice, and
 * to place the arguments in a different order in different languages as the grammar may demand.
 * e.g.
 *
 * new g_MSG_INSERT[] = "Player %1s has chosen map %2s|La carte %2s a choisie par le joueur %1s";
 * language_sayallf(g_MSG_INSERT.print_pretty,PlayerName,Mapname);
 *
 * Supported format goes are %1s = string, %1i and %1d = integer and %1c = character. For %1c provide a number value containing
 * the ascii code of the character.
 *
 *
 *
 * Location
 *
 * The location argument should be one of: print_console, print_center,  print_chat, print_tty, print_pretty
 *
 */

#if defined _language_included
  #endinput
#endif
#define _language_included


/* Versions of adminmod 2.50.56 or later define ADMINMOD_VERISON.
 * If its not defined, assume this is 2.50.50 */
#if !defined(ADMINMOD_VERSION)
  #define ADMINMOD_VERSION 25050
#endif


#define LANGUAGE_MAX_WIDTH 600;
#define DEFAULT_DEFAULT_LANGUAGE 1;
#define MIN_DEFAULT_LANGUAGE 1;
#define MAX_DEFAULT_LANGUAGE 3;

new g_Languages[MAX_PLAYERS] = "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@";
new g_Width[256];
new g_DefaultLanguage = DEFAULT_DEFAULT_LANGUAGE;
/*
 * All plugins must call language_init() from their plugin_init(). No "stock" specifier
 * is used, so a compiler warning is generated if they don't.
 */
language_init() {
  readvaultnum("bblanguage_default",g_DefaultLanguage,DEFAULT_DEFAULT_LANGUAGE,MIN_DEFAULT_LANGUAGE,MAX_DEFAULT_LANGUAGE);
  plugin_registercmd("language_update","language_update",ACCESS_ALL,"");

  new i=0;

  for (i=0;i<256;i++) {
    g_Width[i] = 7;
  }

  /* These are the pixel withs of each character in counter-strike's console font */
  g_Width['a'] = 7;
  g_Width['b'] = 7;
  g_Width['c'] = 7;
  g_Width['d'] = 7;
  g_Width['e'] = 7;
  g_Width['f'] = 5;
  g_Width['g'] = 7;
  g_Width['h'] = 7;
  g_Width['i'] = 3;
  g_Width['j'] = 3;
  g_Width['k'] = 6;
  g_Width['l'] = 3;
  g_Width['m'] = 9;
  g_Width['n'] = 7;
  g_Width['o'] = 7;
  g_Width['p'] = 7;
  g_Width['q'] = 7;
  g_Width['r'] = 5;
  g_Width['s'] = 7;
  g_Width['t'] = 4;
  g_Width['u'] = 3;
  g_Width['v'] = 7;
  g_Width['w'] = 11;
  g_Width['x'] = 7;
  g_Width['y'] = 7;
  g_Width['z'] = 7;

  g_Width['1'] = 5;
  g_Width['2'] = 7;
  g_Width['3'] = 7;
  g_Width['4'] = 7;
  g_Width['5'] = 7;
  g_Width['6'] = 7;
  g_Width['7'] = 7;
  g_Width['8'] = 7;
  g_Width['9'] = 7;
  g_Width['0'] = 7;
  g_Width['-'] = 5;
  g_Width['='] = 7;

  g_Width['A'] = 9;
  g_Width['B'] = 8;
  g_Width['C'] = 8;
  g_Width['D'] = 8;
  g_Width['E'] = 7;
  g_Width['F'] = 7;
  g_Width['G'] = 9;
  g_Width['H'] = 8;
  g_Width['I'] = 3;
  g_Width['J'] = 6;
  g_Width['K'] = 8;
  g_Width['L'] = 7;
  g_Width['M'] = 9;
  g_Width['N'] = 8;
  g_Width['O'] = 9;
  g_Width['P'] = 7;
  g_Width['Q'] = 9;
  g_Width['R'] = 8;
  g_Width['S'] = 8;
  g_Width['T'] = 7;
  g_Width['U'] = 8;
  g_Width['V'] = 9;
  g_Width['W'] = 12;
  g_Width['X'] = 8;
  g_Width['Y'] = 9;
  g_Width['Z'] = 8;

  g_Width['!'] = 3;
  g_Width['@'] = 12;
  g_Width['#'] = 7;
  g_Width['$'] = 7;
  g_Width['%'] = 11;
  g_Width['^^'] = 7;
  g_Width['&'] = 8;
  g_Width['*'] = 5;
  g_Width['('] = 5;
  g_Width[')'] = 5;
  g_Width['_'] = 8;
  g_Width['+'] = 7;

  g_Width['['] = 4;
  g_Width[']'] = 4;
  g_Width['{'] = 5;
  g_Width['}'] = 6;
  g_Width[';'] = 3;
  g_Width['^''] = 3;
  g_Width['\'] = 5;
  g_Width[':'] = 3;
  g_Width['"'] = 5;
  g_Width['|'] = 3;
  g_Width['.'] = 4;
  g_Width[','] = 4;
  g_Width['/'] = 5;
  g_Width['<'] = 7;
  g_Width['>'] = 7;
  g_Width['?'] = 7;
  g_Width[' '] = 8;

  return 0;
}



/*
 * Receives updates on player's preferred languages from plugin_blatt_language
 * Should not be called from anywhere else
 */
public language_update(HLCommand,HLData,HLUserName,UserIndex) {
  new Data[MAX_DATA_LENGTH];
  convert_string(HLData,Data,MAX_DATA_LENGTH);

  if (strlen(Data)==MAX_PLAYERS-1) {
    strcpy(g_Languages,Data,MAX_PLAYERS);
  }
  else {
    snprintf(Data,MAX_DATA_LENGTH,"Language update got %i, expected %i",strlen(Data),MAX_PLAYERS);
    log("ERROR: language_update received invalid data");
  }

  return PLUGIN_CONTINUE;
}



/* Extracts the message in the requested language from a messagelist
 * If the list contains no message for the requested language, the
 * English message is returned.
 */
public language_message(MessageList[],Index,Message[]) {

  new c=strcount(MessageList, '|');
  if (Index > c) {
    Index=0;
  }

  new i=0;
  new st=0;
  new ed=0;

  while (st<Index) {
    if (MessageList[i] == '|') {
      st++;
    }
    i++;
  }

  st=i; /* st now contains start index */

  if (Index == c) {
    ed = strlen(MessageList);
  }
  else {
    while (MessageList[i] != '|') {
      i++;
    }
    ed = i;
  }

  /* ed now cotnain stop index+1 */

  new out=0;
  while (st < ed) {
    Message[out] = MessageList[st];
    out++;
    st++;
  }
  Message[out]=0;

}



/*
 * Returns the language index for the preferred language of the
 * specified player index. No stock as amx has a bug that stock functions
 * can't see global varaibles properly + all plugins that use this include must
 * call it in order to do anything usefull, even if call is by virtue of using
 * one of the language_say family of functions rather than direct.
 */
language_get(UserIndex) {
  if (UserIndex<=0) {
    /* Server console use */
    return g_DefaultLanguage-1;
  }
  if (g_Languages[UserIndex-1] < 65) {
    return g_DefaultLanguage-1;
  }
  return max(0,g_Languages[UserIndex-1]-65);
}

stock language_getbyname(UserName[]) {
  new Index;
  if (get_userindex(UserName,Index)) {
    return language_get(Index);
  }
  return 0;
}




/* Inserts linefeeds in the message a appropraite points
 * for the chosen location.
 *
 * NOTE: All processing of languages has finised by this point
 * You can call this function directly as a replacement for messageex
 * to automatically insert linefeeds at the required places for
 * each location.
 */

stock language_output(UserName[],MessageIn[],print_type:Location,iTime,iRed,iGreen,iBlue) {
  new msg[MAX_TEXT_LENGTH+4]; /* 200 characters may wrap onto 4 lines */
  new i=0;
  new j=0;
  new c=strlen(MessageIn);
  new width=0;
  new linelen=0;

  while (i<c) {
    width+=g_Width[MessageIn[i]];
    if ((MessageIn[i]=='^n') || (width > LANGUAGE_MAX_WIDTH) || (((Location==print_type:print_center) || (Location==print_type:print_pretty)) && (linelen>77))){

      /* Going to break line, search back for a suitable character */
      if (MessageIn[i]!='^n') {
        new oi=i;
        new oj=j;
        while ((MessageIn[i] != ' ') && (j>0)) {
          i--;
          j--;
        }
        if (j==0) {
          i=oi;
          j=oj;
        }
      }

      if ((Location==print_type:print_center) || (Location==print_type:print_pretty)) {
        if (msg[j] == ' ') {
          msg[j]='^n';
          i++;
          j++;
        }
        else {
          msg[j]='^n';
          j++;
        }
      } else {
        if (MessageIn[i]=='^n') {
          i++;
        }
        msg[j]=NULL_CHAR;
        messageex(UserName,msg,Location);
        j=0;
      }
      width=g_Width[MessageIn[i]];
      linelen=0;
    }
    msg[j]=MessageIn[i];
    j++;
    i++;
    linelen++;
  }
  msg[j]=NULL_CHAR;

#if ADMINMOD_VERSION >= 25055
  if (Location==print_type:print_pretty) {
    centersayex(UserName,msg,iTime,iRed,iGreen,iBlue);
  }
  else {
    messageex(UserName,msg,Location);
  }
#else
  /* This is pointless but prevents compiler warnings on 2.50.50 */
  iTime=iRed;
  iRed=iTime;
  iGreen=iBlue;
  iBlue=iGreen;
  messageex(UserName,msg,Location);
#endif

}


/*
 * Sends a message to the specified player in their preferred language
 * Location is as for messageex function
 */
stock language_say(Index,MessageList[],print_type:Location,iTime=10,iRed=255,iGreen=255,iBlue=255) {

  new Message[MAX_TEXT_LENGTH];
  language_message(MessageList,language_get(Index),Message);

  new Name[MAX_NAME_LENGTH];

  if (Index>0) {
    if (playerinfo(Index,Name,MAX_NAME_LENGTH)) {
      language_output(Name,Message,Location,iTime,iRed,iGreen,iBlue);
    }
  }
  else {
    log(Message);
  }
}



/*
 * Sends a message to the specified player in their preferred language
 * Location is as for messageex function
 */
stock language_saybyname(Name[],MessageList[],print_type:Location,iTime=10,iRed=255,iGreen=255,iBlue=255)
{
  new Message[MAX_TEXT_LENGTH];
  language_message(MessageList,language_getbyname(Name),Message);
  language_output(Name,Message,Location,iTime,iRed,iGreen,iBlue);
}



/*
 * Sends a message all players in their preferred language
 * Location is as for messageex function
 */
stock language_sayall(MessageList[],print_type:Location,iTime=10,iRed=255,iGreen=255,iBlue=255) {
  new c = maxplayercount();
  new Name[MAX_NAME_LENGTH];
  new dummy;
  new i;
  new wonid;
  new team;
  new dead;
  new AuthID[MAX_AUTHID_LENGTH];

  for(i=1;i<=c;i++) {
    if (playerinfo(i,Name,MAX_NAME_LENGTH,dummy,wonid,team,dead,AuthID)) {
      if ((strcmp(AuthID,"BOT") != 0)) {
        new Message[MAX_TEXT_LENGTH];
        language_message(MessageList,language_get(i),Message);
        language_output(Name,Message,Location,iTime,iRed,iGreen,iBlue);
      }
    }
  }
}



/*
 * Sends a message to the specified player in their preferred language
 * Location is as for messageex function
 */
stock language_sayf(Index,MessageList[],print_type:Location,iTime,iRed,iGreen,iBlue,...) {

  new Messagef[MAX_TEXT_LENGTH];
  new Message[MAX_TEXT_LENGTH];
  language_message(MessageList,language_get(Index),Messagef);


  /* My implementation of snprintf - must be inserted rather than
   * called as a function in order to work properly :( */
  new i=0;
  new j=0;
  new apos=0;
  new aval=0;
  new num[16];
  new c = strlen(Messagef);
  new arg;
  while((i<c) && (j<MAX_TEXT_LENGTH-1)) {
    if(Messagef[i] != '%') {
      Message[j] = Messagef[i];
      j++;
    }
    else {
      if (Messagef[i+1] == '%') {
        Message[j] = '%';
        i++;
        j++;
      }
      else {
        arg=(Messagef[i+1]-49);
        if ((arg<0) || (arg>9)) {
          plugin_message("ERROR: Message format error in language_sayf - character other than 1-9 after a %%");
          return;
        }
        arg+=7;
        if (Messagef[i+2] == 'c') {
          Message[j] = getarg(arg);
          j++;
          i=i+2;
        } else if ((Messagef[i+2] == 'd') || (Messagef[i+2] == 'i'))  {
          numtostr(getarg(arg),num);
          strcat(Message,num,MAX_TEXT_LENGTH);
          j=j+strlen(num);
          i=i+2;
        } else if (Messagef[i+2] == 's') {
          apos=0;
          aval=getarg(arg,apos);
          while ((aval != 0) && (j<MAX_TEXT_LENGTH-1)) {
            Message[j] = aval;
            apos++;
            j++;
            aval=getarg(arg,apos);
          }
          i=i+2;
        } else {
          plugin_message("ERROR: Message format error in language_sayf - character other than c/d/i/s 2 after a %%");
          return;
        }
      }
    }
    i++;
  }
  Message[j] = 0;
  /* End of snprintf implementation */


  new Name[MAX_NAME_LENGTH];

  if (Index>0) {
    if (playerinfo(Index,Name,MAX_NAME_LENGTH)) {
      language_output(Name,Message,Location,iTime,iRed,iGreen,iBlue);
    }
  } else {
    log(Message);
  }
}



/*
 * Sends a message to the specified player in their preferred language
 * Location is as for messageex function
 */
stock language_saybynamef(Name[],MessageList[],print_type:Location,iTime,iRed,iGreen,iBlue,...)
{
  new Messagef[MAX_TEXT_LENGTH];
  new Message[MAX_TEXT_LENGTH];
  language_message(MessageList,language_getbyname(Name),Messagef);

  /* My implementation of snprintf - must be inserted rather than
   * called as a function in order to work properly :( */
  new i=0;
  new j=0;
  new apos=0;
  new aval=0;
  new num[16];
  new c = strlen(Messagef);
  new arg;
  while((i<c) && (j<MAX_TEXT_LENGTH-1)) {
    if(Messagef[i] != '%') {
      Message[j] = Messagef[i];
      j++;
    }
    else {
      if (Messagef[i+1] == '%') {
        Message[j] = '%';
        i++;
        j++;
      }
      else {
        arg=(Messagef[i+1]-49);
        if ((arg<0) || (arg>9)) {
          plugin_message("ERROR: Message format error in language_sayf - character other than 1-9 after a %%");
          return;
        }
        arg+=7;
        if (Messagef[i+2] == 'c') {
          Message[j] = getarg(arg);
          j++;
          i=i+2;
        } else if ((Messagef[i+2] == 'd') || (Messagef[i+2] == 'i'))  {
          numtostr(getarg(arg),num);
          strcat(Message,num,MAX_TEXT_LENGTH);
          j=j+strlen(num);
          i=i+2;
        } else if (Messagef[i+2] == 's') {
          apos=0;
          aval=getarg(arg,apos);
          while ((aval != 0) && (j<MAX_TEXT_LENGTH-1)) {
            Message[j] = aval;
            apos++;
            j++;
            aval=getarg(arg,apos);
          }
          i=i+2;
        } else {
          plugin_message("ERROR: Message format error in language_sayf - character other than c/d/i/s 2 after a %%");
          return;
        }
      }
    }
    i++;
  }
  Message[j] = 0;
  /* End of snprintf implementation */


  language_output(Name,Message,Location,iTime,iRed,iGreen,iBlue);
}



/*
 * Sends a message all players in their preferred language
 * Location is as for messageex function
 */
stock language_sayallf(MessageList[],print_type:Location,iTime,iRed,iGreen,iBlue,...) {
  new plc = maxplayercount();
  new Name[MAX_NAME_LENGTH];
  new dummy;
  new wonid;
  new team;
  new dead;
  new pl;
  new AuthID[MAX_AUTHID_LENGTH];

  for(pl=1;pl<=plc;pl++) {
    if (playerinfo(pl,Name,MAX_NAME_LENGTH,dummy,wonid,team,dead,AuthID)) {
      if ((streq(AuthID,"BOT") == 0)) {
        new Messagef[MAX_TEXT_LENGTH];
        new Message[MAX_TEXT_LENGTH];
        language_message(MessageList,language_get(pl),Messagef);

        /* My implementation of snprintf - must be inserted rather than
         * called as a function in order to work properly :( */
        new i=0;
        new j=0;
        new apos=0;
        new aval=0;
        new num[16];
        new c = strlen(Messagef);
        new arg;
        while((i<c) && (j<MAX_TEXT_LENGTH-1)) {
          if(Messagef[i] != '%') {
            Message[j] = Messagef[i];
            j++;
          }
          else {
            if (Messagef[i+1] == '%') {
              Message[j] = '%';
              i++;
              j++;
            }
            else {
              arg=(Messagef[i+1]-49);
              if ((arg<0) || (arg>9)) {
                plugin_message("ERROR: Message format error in language_sayf - character other than 1-9 after a %%");
                return;
              }
              arg+=6; /* NOTE: This is different to the other copies as there are only 6 fixed args */
              if (Messagef[i+2] == 'c') {
                Message[j] = getarg(arg);
                j++;
                i=i+2;
              } else if ((Messagef[i+2] == 'd') || (Messagef[i+2] == 'i'))  {
                numtostr(getarg(arg),num);
                strcat(Message,num,MAX_TEXT_LENGTH);
                j=j+strlen(num);
                i=i+2;
              } else if (Messagef[i+2] == 's') {
                apos=0;
                aval=getarg(arg,apos);
                while ((aval != 0) && (j<MAX_TEXT_LENGTH-1)) {
                  Message[j] = aval;
                  apos++;
                  j++;
                  aval=getarg(arg,apos);
                }
                i=i+2;
              } else {
                plugin_message("ERROR: Message format error in language_sayf - character other than c/d/i/s 2 after a %%");
                return;
              }
            }
          }
          i++;
        }
        Message[j] = 0;
        /* End of snprintf implementation */

        language_output(Name,Message,Location,iTime,iRed,iGreen,iBlue);
      }
    }
  }
}


/*
 * Sends a message all players that are dead in their preferred language
 * Location is as for messageex function
 */
stock language_saydeadf(MessageList[],print_type:Location,iTime,iRed,iGreen,iBlue,...) {
  new plc = maxplayercount();
  new Name[MAX_NAME_LENGTH];
  new dummy;
  new wonid;
  new team;
  new dead;
  new pl;
  new AuthID[MAX_AUTHID_LENGTH];

  for(pl=1;pl<=plc;pl++) {
    if (playerinfo(pl,Name,MAX_NAME_LENGTH,dummy,wonid,team,dead,AuthID)) {
      if ((streq(AuthID,"BOT") == 0) && (dead==1)) {
        new Messagef[MAX_TEXT_LENGTH];
        new Message[MAX_TEXT_LENGTH];
        language_message(MessageList,language_get(pl),Messagef);

        /* My implementation of snprintf - must be inserted rather than
         * called as a function in order to work properly :( */
        new i=0;
        new j=0;
        new apos=0;
        new aval=0;
        new num[16];
        new c = strlen(Messagef);
        new arg;
        while((i<c) && (j<MAX_TEXT_LENGTH-1)) {
          if(Messagef[i] != '%') {
            Message[j] = Messagef[i];
            j++;
          }
          else {
            if (Messagef[i+1] == '%') {
              Message[j] = '%';
              i++;
              j++;
            }
            else {
              arg=(Messagef[i+1]-49);
              if ((arg<0) || (arg>9)) {
                plugin_message("ERROR: Message format error in language_sayf - character other than 1-9 after a %%");
                return;
              }
              arg+=6; /* NOTE: This is different to the other copies as there are only 6 fixed args */
              if (Messagef[i+2] == 'c') {
                Message[j] = getarg(arg);
                j++;
                i=i+2;
              } else if ((Messagef[i+2] == 'd') || (Messagef[i+2] == 'i'))  {
                numtostr(getarg(arg),num);
                strcat(Message,num,MAX_TEXT_LENGTH);
                j=j+strlen(num);
                i=i+2;
              } else if (Messagef[i+2] == 's') {
                apos=0;
                aval=getarg(arg,apos);
                while ((aval != 0) && (j<MAX_TEXT_LENGTH-1)) {
                  Message[j] = aval;
                  apos++;
                  j++;
                  aval=getarg(arg,apos);
                }
                i=i+2;
              } else {
                plugin_message("ERROR: Message format error in language_sayf - character other than c/d/i/s 2 after a %%");
                return;
              }
            }
          }
          i++;
        }
        Message[j] = 0;
        /* End of snprintf implementation */

        language_output(Name,Message,Location,iTime,iRed,iGreen,iBlue);
      }
    }
  }
}
