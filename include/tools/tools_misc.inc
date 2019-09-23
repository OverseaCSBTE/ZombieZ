#if defined _tools_misc_included
  #endinput
#endif
#define _tools_misc_included

#include <tools/tools_version>

stock is_player(id) {
	new class[128]
	if (is_entity(id)) {
		get_classname(id,class,sizeof(class))
		if (equali(class,"player")) {
			return 1
		}
	}
	return 0
}
