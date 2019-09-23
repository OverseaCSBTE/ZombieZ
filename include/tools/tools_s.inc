#if defined _tools_s_included
  #endinput
#endif
#define _tools_s_included

#include <tools/tools_version>

// String
native get_classname(Index, szClassname[], Len);
native set_classname(Index, szClassname[]);
native get_netname(Index, szNetname[], Len);
native set_netname(Index, szNetname[]);
native get_model(Index, szClassname[], Len);
native set_model(Index, szClassname[]);

native set_model2(Index, szClassname[]);
