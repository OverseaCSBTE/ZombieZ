#if defined _tools_o_included
  #endinput
#endif
#define _tools_o_included

#include <tools/tools_version>

// Other
native precache_event(Id, const Name[]);
native precache_generic(const Name[]);
native get_user_angles(Index, Angles[3]);
native set_user_angles(Index, Angles[3]);
native get_value_by_key(Index, szKey[], szValue[], Len);
native get_decal_index(const szDecalName[]);
native set_rendering(index,fx=kRenderFxNone, r=255,g=255,b=255, render=kRenderNormal,amount=16);
native FindEntityKeyValue(Index, szKey[], szValue[]);

native is_entity(Index);

// Float Vars:
// vReturnVars[0] = flFraction
// vReturnVars[1] = flPlaneDist
//
// Integer Vars:
// intReturnVars[0] = fAllSolid
// intReturnVars[1] = fInOpen
// intReturnVars[2] = fInWater
// intReturnVars[3] = fStartSolid
// intReturnVars[4] = iHitgroup
native trace_line(iIgnoreEnt,Float:fStart[3],Float:fEnd[3],Float:vReturn[3],Float:flReturnVars[2],intReturnVars[5]);

native base64encode(str[],ret[],ret_len);
native base64decode(str[],ret[],ret_len);