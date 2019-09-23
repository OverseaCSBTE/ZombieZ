#if defined _tools_msg_included
  #endinput
#endif
#define _tools_msg_included

#include <tools/tools_version>

native MESSAGE_BEGIN(Dest, Msg_type, Float:Origin[3]={0.0,0.0,0.0},Player=0);
native MESSAGE_END();
native WRITE_BYTE(X);
native WRITE_CHAR(X);
native WRITE_SHORT(X);
native WRITE_LONG(X);
native WRITE_ENTITY(X);
native WRITE_ANGLE(X);
native WRITE_COORD(Float:X);
native WRITE_STRING(X[]);
