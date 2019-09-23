/*
 * basic mathematic operations.
 * jonathan shusta <jon@wroth.org>
 *
 */

#if defined _math_included
  #endinput
#endif
#define _math_included

#include <float>

stock const Float:M_PI = 3.14159265358979323846264338327950288419716939937510
stock const Float:M_E  = 2.71828182845904523536028747135266250

stock floor(Float:n) { return floatround(n,floatround_floor); }

stock ceil(Float:n) { return floatround(n,floatround_ceil); }