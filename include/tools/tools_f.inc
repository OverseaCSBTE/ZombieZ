#if defined _tools_f_included
  #endinput
#endif
#define _tools_f_included

#include <tools/tools_version>

// Float
native Float:get_frags(Index);
native set_frags(Index, Float:Frags);
native Float:get_renderamt(Index);
native set_renderamt(Index, Float:Amount=128.0);
native Float:get_gravity(Index);
native set_gravity(Index, Float:Gravity);
