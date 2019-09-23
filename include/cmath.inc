/*
 * AMX CMath routines.
 * jonathan shusta <jon@wroth.org>
 *
 */

#if defined _cmath_included
	#endinput
#endif
#define _cmath_included

#include <float>

native abs(n)
native Float:fabs( Float:n )
native Float:sin( Float:theta )
native Float:cos( Float:theta )
native Float:tan( Float:theta )
native Float:asin( Float:theta )
native Float:acos( Float:theta )
native Float:atan( Float:theta )
native Float:atan2( Float:y, Float:x )

