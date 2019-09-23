#if defined _tools_v_included
  #endinput
#endif
#define _tools_v_included

#include <tools/tools_version>

// Vector
native get_angles(Index, Float:Angles[3]);
native set_angles(Index, Float:Angles[3]);
native get_velocity(Index, Float:Velocity[3]);
native set_velocity(Index, Float:Velocity[3]);
native get_rendercolor(Index, Float:RGB[3]);
native set_rendercolor(Index, Float:RGB[3]);
native get_origin(Index, Float:Origin[3]);
native set_origin(Index, Float:Origin[3]);
native get_mins(Index, Float:Mins[3]);
native set_mins(Index, Float:Mins[3]);
native get_maxs(Index, Float:Maxs[3]);
native set_maxs(Index, Float:Maxs[3]);
