#if defined _tools_pv_included
  #endinput
#endif
#define _tools_pv_included

#include <tools/tools_version>

native get_private_int(Index, Offset);
native set_private_int(Index, Offset, Value);
native Float:get_private_float(Index, Offset);
native set_private_float(Index, Offset, Float:Value);
