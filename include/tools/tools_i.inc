#if defined _tools_i_included
  #endinput
#endif
#define _tools_i_included

#include <tools/tools_version>

// Integer
native get_movetype(Index);
native set_movetype(Index, Type);
native get_effects(Index);
native set_effects(Index, Type);
native get_renderfx(Index);
native set_renderfx(Index, Fx=kRenderFxNone);
native get_rendermode(Index);
native set_rendermode(Index, Mode=kRenderNormal);
native get_sequence(Index);
native set_sequence(Index, Sequence);
native get_iuser(Index, Number);
native set_iuser(Index, Number, Value);
native get_solid(Index);
native set_solid(Index, Value);
