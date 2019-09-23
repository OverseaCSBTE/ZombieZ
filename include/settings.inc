/*
 * Configuration Setting address helper function library
 *
 * By Ravenous Bugblatter Beast
 * ravenousbugblatterbeast@hotmail.com
 * http://www.ravenousbugblatterbeast.pwp.blueyonder.co.uk
 *
 */

#if defined _settings_included
  #endinput
#endif
#define _settings_included

#include <admin>
#include <core>
#include <string>
#include <plugin>

/* Reads line "i" from "file" into "Line", trims it and removes comments */
stock readline(File[],i,Line[]) {
  /* File line numbers are indexed from 1, not 0, hence the +1 */
  readfile(File,Line,i,MAX_DATA_LENGTH);

  /* Remove trailing comment or nullify the string if its nothing but a comment */
  new pos = strstr(Line, "//");
  if (pos >= 0) {
    Line[pos] = NULL_CHAR;
  }

  /* Remove spaces and tabs */
  strtrim(Line," ^t",2);
}



/* Reads a numeric value from the vault and bounds checks it
 *
 * name = Name of setting in vault.
 * output = Variable to which the result is written.
 * defaultval = Value to set output to, when name is missing from vault or out of the valid range
 * minimum = Minimum legal value
 * maximum = Maximum legal value
 *
 * Returns 1 if a legal value was found in vault, 0 if it wasn't.
 */
stock readvaultnum(name[],&output,defaultval,minimum,maximum) {
  new Buffer[10]="";
  get_vaultdata(name,Buffer,10);
  output = defaultval;
  if (strlen(Buffer)>0) {
    output = strtonum(Buffer);
    if ((output <minimum) || (output > maximum)) {
      output = defaultval;
      return 1;
    }
  }
  return 0;
}

/* Writes a numeric value to the vault
 *
 * name = Name of setting in value.
 * value = Value to write
 */
stock writevaultnum(name[],value) {
  new Buffer[10];
  numtostr(value,Buffer);
  set_vaultdata(name,Buffer);
  return 0;
}

/* Reads a numeric value from the HLData argument passed to admin commands
 *
 * HLData = HLData as passed by admin mod to your admin command function.
 * output = Variable to which the result is written.
 * defaultval = Value to set output to when the user supplied value is missing or out of the valid range
 * minimum = Minimum legal value
 * maximum = Maximum legal value
 *
 * Returns 1 if a legal value was supplied in HLdata, 0 if it wasn't.
 */
stock readHLnum(HLData,&output,defaultval,minimum,maximum) {
  new Data[MAX_DATA_LENGTH];
  convert_string(HLData,Data,MAX_DATA_LENGTH);
  output = defaultval;
  if (strlen(Data) > 0) {
    output = strtonum(Data);
    if ((output <minimum) || (output > maximum)) {
      output = defaultval;
    }
    return 1;
  }
  return 0;
}


/* Prints a string with a numeric insert in the callers console
 *
 * msg = String to write
 * value = Value to insert
 */
stock ShowLine(msg[],value) {
  new data[MAX_TEXT_LENGTH];
  snprintf(data,MAX_TEXT_LENGTH,msg,value);
  selfmessage(data);
}

/* Reads an on/off value from the HLData argument passed to admin commands
 * Accepts "on", "off", or any numeric value and returns 1 for "on", 0 for "off" and
 * the actual value if a numeric argument is supplied.
 *
 * HLData = HLData as passed by admin mod to your admin command function.
 * output = Variable to which the result is written.
 * defaultval = Value to set output to when the user supplied value is missing or out of the valid range
 * minimum = Minimum legal value
 * maximum = Maximum legal value (Usually 1)
 *
 * Returns 1 if a legal value was supplied in HLdata, 0 if it wasn't.
 */

stock readHLonoff(HLData,&output,defaultval,minimum,maximum,onval=1) {
  /* Read setting from halflife string */
  new Data[MAX_DATA_LENGTH];
  convert_string(HLData,Data,MAX_DATA_LENGTH);
  if (strlen(Data) > 0) {
    if (streq(Data,"on")) {
      output = onval;
      return 1;
    } else if (streq(Data,"off")) {
      output = 0;
      return 1;
    } else {
      output = strtonum(Data);
      if ((output <minimum) || (output > maximum)) {
        output = defaultval;
      }
      return 1;
    }
  }
  return 0;
}

/* Checks various access levels are set */

stock configError(msg[]) {
  plugin_message("***************************************************");
  plugin_message("***************************************************");
  plugin_message("** Configuration Error - Please Refrer to manual **");
  plugin_message("**                                               **");
  plugin_message("**                                               **");
  plugin_message("**                                               **");
  plugin_message("**                                               **");
  plugin_message(msg);
  plugin_message("**                                               **");
  plugin_message("**                                               **");
  plugin_message("**                                               **");
  plugin_message("**                                               **");
  plugin_message("***************************************************");
  plugin_message("***************************************************");
}
stock checkFileAccessRead() {
  if (getvar("file_access_read") == 1) {
    return 1;
  }

  configError("You must set file_access_read to 1 in your adminmod.cfg");
  return 0;
}

stock checkFileAccessWrite() {
  if (getvar("file_access_write") == 1) {
    return 1;
  }
  configError("You must set file_access_write to 1 in your adminmod.cfg");
  return 0;
}

stock checkAllowClientExec() {
  if (getvar("allow_client_exec") == 1) {
    return 1;
  }
  configError("You must set allow_client_exec to 1 in your adminmod.cfg");
  return 0;
}

stock checkVaultOK() {
  new Data[MAX_DATA_LENGTH];
  if (getstrvar("admin_vault_file",Data,MAX_DATA_LENGTH)==1) {
    if (strlen(Data) >0) {
      return 1;
    }
  }
  configError("You must set admin_vault_file to a valid filename in your adminmod.cfg");
  return 0;
}

stock checkMapsOK() {
  new Data[MAX_DATA_LENGTH];
  if (getstrvar("maps_file",Data,MAX_DATA_LENGTH)==1) {
    if (strlen(Data) >0) {
      if (fileexists(Data)) {
        if (Data[0] == '/' || Data[0] == '\' || Data[1] == ':') {
          new msg[MAX_TEXT_LENGTH];
          snprintf(msg,MAX_TEXT_LENGTH,"Your maps_file %s is an absolute path. You must use a relative path.",Data);
          configError(msg);
          return 0;
        }
        return 1;
      }
      else {
        new msg[MAX_TEXT_LENGTH];
        if (streq(Data,"0")) {
          snprintf(msg,MAX_TEXT_LENGTH,"maps_file is 0 in your adminmod.cfg. Set it to the name of your maps file.",Data);
        }
        else {
          snprintf(msg,MAX_TEXT_LENGTH,"Your maps_file %s cannot be found.",Data);
        }
        configError(msg);
        return 0;
      }
    }
  }
  configError("You must set maps_file to a valid filename in your adminmod.cfg");
  return 0;
}

stock checkAdminVoteAutostart() {
  if (getvar("admin_vote_autostart") == 0) {
    return 1;
  }
  configError("You must set admin_vote_autostart to 0 in your adminmod.cfg");
  return 0;
}

stock checkLanguage() {
  if (plugin_checkcommand("bblanguage_report")>0) {
      return 1;
  }
  plugin_message("WARNING: Install plugin_blatt_language to enable the multi-lingual features of this plugin.");
  return 0;
}

stock checkMinRate() {
  if (getvar("sv_minrate") != 0) {
    return 1;
  }

  configError("You must set sv_minrate - see the manual for details.");
  return 0;
}

stock checkMaxRate() {
  if (getvar("sv_maxrate") != 0) {
    return 1;
  }

  configError("You must set sv_maxrate - see the manual for details.");
  return 0;
}

stock getfilelocation(location[],name[]) {
  new i;
  new l;
  if (get_vaultdata("bbdir",location,MAX_TEXT_LENGTH)) {
    l=strlen(location);
    if (l>0) {
      for (i=0;i<l;i++) {
        if (location[i]=='\') { location[i]='/'; }
      }
      if (location[l-1] != '/') {
        location[l] = '/';
        location[l+1] = NULL_CHAR;
      }
      strcat(location,name,MAX_TEXT_LENGTH);
      if (fileexists(location)) {
        return 1;
      }
    }
  }

  strcpy(location,"addons/adminmod/config/",MAX_TEXT_LENGTH);
  strcat(location,name,MAX_TEXT_LENGTH);
  if (fileexists(location)) {
    return 1;
  }

  strcpy(location,name,MAX_TEXT_LENGTH);
  if (fileexists(location)) {
    return 1;
  }
  return 0;
}