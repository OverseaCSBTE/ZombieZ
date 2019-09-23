enum {GF_UNSPECIFIED = 0,GF_HEGRENADE, GF_FLASHBANG, GF_SMOKEGRENADE}
enum {GF_DESTROYED = 0, GF_CREATE, GF_ALIVE }

forward touch_forward( value1, value2 );

// grenadeid = entityindex. grenade_state = 0 - destroyed, 1 - first created, 2 - alive.
// ownerid = playerindex. model = 0 - unspecified, 1 - hegrenade, 2 - flashbang, 3 - smokegrenade
// For now, model is only sent when grenade_state == 1.
forward grenade_forward(grenadeid, grenade_state, ownerid, model);
