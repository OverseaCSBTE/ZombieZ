#if defined _tools_version_included
  #endinput
#endif
#define _tools_version_included

#if defined TOOLS_VERSION
#else
#define TOOLS_VERSION 4
#define TOOLS_VERSION_STR 1.0.3
#endif

native tools_version();
native tools_version_str(szVersion[], Len);
