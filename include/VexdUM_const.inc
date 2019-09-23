/* Vexd Utility Module Defines
*
* by the AMX Mod Dev Team
*
* This file is provided as is (no warranties).
*/

#if defined _vexdum_const_included
  #endinput
#endif
#define _vexdum_const_included

#define SPEAK_NORMAL	0
#define SPEAK_MUTED	1
#define SPEAK_ALL	2
#define SPEAK_LISTENALL	4

#define BLOCK_NOT	0
#define BLOCK_ONCE	1
#define BLOCK_SET	2

#define ANGLEVECTORS_FORWARD	1
#define ANGLEVECTORS_RIGHT	2
#define ANGLEVECTORS_UP		3

// Int
enum {
	EV_INT_gamestate,
	EV_INT_oldbuttons,
	EV_INT_groupinfo,
	EV_INT_iuser1,
	EV_INT_iuser2,
	EV_INT_iuser3,
	EV_INT_iuser4,
	EV_INT_weaponanim,
	EV_INT_pushmsec,
	EV_INT_bInDuck,
	EV_INT_flTimeStepSound,
	EV_INT_flSwimTime,
	EV_INT_flDuckTime,
	EV_INT_iStepLeft,
	EV_INT_movetype,
	EV_INT_solid,
	EV_INT_skin,			
	EV_INT_body,
	EV_INT_effects,
	EV_INT_light_level,
	EV_INT_sequence,
	EV_INT_gaitsequence,
	EV_INT_modelindex,
	EV_INT_playerclass,
	EV_INT_waterlevel,
	EV_INT_watertype,
	EV_INT_spawnflags,
	EV_INT_flags,
	EV_INT_colormap,
	EV_INT_team,
	EV_INT_fixangle,
	EV_INT_weapons,
	EV_INT_rendermode,
	EV_INT_renderfx,
	EV_INT_button,
	EV_INT_impulse,
	EV_INT_deadflag,
};

// Float
enum {
	EV_FL_impacttime,
	EV_FL_starttime,
	EV_FL_idealpitch,
	EV_FL_pitch_speed,
	EV_FL_ideal_yaw,
	EV_FL_yaw_speed,
	EV_FL_ltime,
	EV_FL_nextthink,
	EV_FL_gravity,
	EV_FL_friction,
	EV_FL_frame,
	EV_FL_animtime,
	EV_FL_framerate,
	EV_FL_health,
	EV_FL_frags,
	EV_FL_takedamage,
	EV_FL_max_health,
	EV_FL_teleport_time,
	EV_FL_armortype,
	EV_FL_armorvalue,
	EV_FL_dmg_take,
	EV_FL_dmg_save,
	EV_FL_dmg,
	EV_FL_dmgtime,
	EV_FL_speed,
	EV_FL_air_finished,
	EV_FL_pain_finished,
	EV_FL_radsuit_finished,
	EV_FL_scale,
	EV_FL_renderamt,
	EV_FL_maxspeed,
	EV_FL_fov,
	EV_FL_flFallVelocity,
	EV_FL_fuser1,
	EV_FL_fuser2,
	EV_FL_fuser3,
	EV_FL_fuser4,
};

// Vector
enum {
	EV_VEC_origin,
	EV_VEC_oldorigin,
	EV_VEC_velocity,
	EV_VEC_basevelocity,
	EV_VEC_clbasevelocity,
	EV_VEC_movedir,
	EV_VEC_angles,
	EV_VEC_avelocity,
	EV_VEC_punchangle,
	EV_VEC_v_angle,
	EV_VEC_endpos,
	EV_VEC_startpos,
	EV_VEC_absmin,
	EV_VEC_absmax,
	EV_VEC_mins,
	EV_VEC_maxs,
	EV_VEC_size,
	EV_VEC_rendercolor,
	EV_VEC_view_ofs,
	EV_VEC_vuser1,
	EV_VEC_vuser2,
	EV_VEC_vuser3,
	EV_VEC_vuser4,
};

// Edict
enum {
	EV_ENT_chain,
	EV_ENT_dmg_inflictor,
	EV_ENT_enemy,
	EV_ENT_aiment,
	EV_ENT_owner,
	EV_ENT_groundentity,
	EV_ENT_pContainingEntity,
	EV_ENT_euser1,
	EV_ENT_euser2,
	EV_ENT_euser3,
	EV_ENT_euser4,
};

// String
enum {
	EV_SZ_classname,
	EV_SZ_globalname,
	EV_SZ_model,
	EV_SZ_target,
	EV_SZ_targetname,
	EV_SZ_netname,
	EV_SZ_message,
	EV_SZ_noise,
	EV_SZ_noise1,
	EV_SZ_noise2,
	EV_SZ_noise3,
	EV_SZ_viewmodel,
	EV_SZ_weaponmodel,
};

// Byte
enum {
	EV_BYTE_controller0,
	EV_BYTE_controller1,
	EV_BYTE_controller2,
	EV_BYTE_controller3,
	EV_BYTE_controller4,
	EV_BYTE_blending0,
	EV_BYTE_blending1,
};

#define IN_ATTACK		(1 << 0)
#define IN_JUMP			(1 << 1)
#define IN_DUCK			(1 << 2)
#define IN_FORWARD		(1 << 3)
#define IN_BACK			(1 << 4)
#define IN_USE			(1 << 5)
#define IN_CANCEL		(1 << 6)
#define IN_LEFT			(1 << 7)
#define IN_RIGHT		(1 << 8)
#define IN_MOVELEFT		(1 << 9)
#define IN_MOVERIGHT		(1 << 10)
#define IN_ATTACK2		(1 << 11)
#define IN_RUN			(1 << 12)
#define IN_RELOAD		(1 << 13)
#define IN_ALT1			(1 << 14)
#define IN_SCORE		(1 << 15)

// Changes the SV_Movestep() behavior to not need to be on ground
#define	FL_FLY			(1<<0)

// Changes the SV_Movestep() behavior to not need to be on ground (but stay in water)
#define	FL_SWIM			(1<<1)

#define	FL_CONVEYOR		(1<<2)
#define	FL_CLIENT		(1<<3)
#define	FL_INWATER		(1<<4)
#define	FL_MONSTER		(1<<5)
#define	FL_GODMODE		(1<<6)
#define	FL_NOTARGET		(1<<7)

// Don't send entity to local host, it's predicting this entity itself
#define	FL_SKIPLOCALHOST	(1<<8)

// At rest / on the ground
#define	FL_ONGROUND		(1<<9)

// not all corners are valid
#define	FL_PARTIALGROUND	(1<<10)

// player jumping out of water
#define	FL_WATERJUMP		(1<<11)

// Player is frozen for 3rd person camera
#define FL_FROZEN		(1<<12)

// JAC: fake client, simulated server side; don't send network messages to them
#define FL_FAKECLIENT		(1<<13)

// Player flag -- Player is fully crouched
#define FL_DUCKING		(1<<14)

// Apply floating force to this entity when in water
#define FL_FLOAT		(1<<15)

// worldgraph has this ent listed as something that blocks a connection
#define FL_GRAPHED		(1<<16)

#define FL_IMMUNE_WATER		(1<<17)
#define	FL_IMMUNE_SLIME		(1<<18)
#define FL_IMMUNE_LAVA		(1<<19)

// This is a spectator proxy
#define FL_PROXY		(1<<20)

// Brush model flag -- call think every frame regardless of nextthink - ltime (for constantly changing velocity/path)
#define FL_ALWAYSTHINK		(1<<21)

// Base velocity has been applied this frame (used to convert base velocity into momentum)
#define FL_BASEVELOCITY		(1<<22)

// Only collide in with monsters who have FL_MONSTERCLIP set
#define FL_MONSTERCLIP		(1<<23)

// Player is _controlling_ a train, so movement commands should be ignored on client during prediction.
#define FL_ONTRAIN		(1<<24)

// Not moveable/removeable brush entity (really part of the world, but represented as an entity for transparency or something)
#define FL_WORLDBRUSH		(1<<25)

// This client is a spectator, don't run touch functions, etc.
#define FL_SPECTATOR           	(1<<26)

// This is a custom entity
#define FL_CUSTOMENTITY		(1<<29)

// This entity is marked for death -- This allows the engine to kill ents at the appropriate time
#define FL_KILLME		(1<<30)

// Entity is dormant, no updates to client
#define FL_DORMANT		(1<<31)

// no interaction with other objects
#define	SOLID_NOT		0

// touch on edge, but not blocking
#define	SOLID_TRIGGER		1

// touch on edge, block
#define	SOLID_BBOX		2

// touch on edge, but not an onground
#define	SOLID_SLIDEBOX		3

// bsp clip, touch on edge, block
#define	SOLID_BSP		4

// never moves
#define	MOVETYPE_NONE		0

#define MOVETYPE_ANGLENOCLIP	1
#define MOVETYPE_ANGLECLIP	2

// Player only - moving on the ground
#define	MOVETYPE_WALK		3

// gravity, special edge handling -- monsters use this
#define	MOVETYPE_STEP		4

// No gravity, but still collides with stuff
#define	MOVETYPE_FLY		5

// gravity/collisions
#define	MOVETYPE_TOSS		6

// no clip to world, push and crush
#define	MOVETYPE_PUSH		7

// No gravity, no collisions, still do velocity/avelocity
#define	MOVETYPE_NOCLIP		8

// extra size to monsters
#define	MOVETYPE_FLYMISSILE	9

// Just like Toss, but reflect velocity when contacting surfaces
#define	MOVETYPE_BOUNCE		10

// bounce w/o gravity
#define MOVETYPE_BOUNCEMISSILE	11

// track movement of aiment
#define MOVETYPE_FOLLOW		12

// BSP model that needs physics/world collisions (uses nearest hull for world collision)
#define	MOVETYPE_PUSHSTEP	13

#define	CONTENTS_EMPTY		-1
#define	CONTENTS_SOLID		-2
#define	CONTENTS_WATER		-3
#define	CONTENTS_SLIME		-4
#define	CONTENTS_LAVA		-5
#define	CONTENTS_SKY		-6

// removed at csg time
#define	CONTENTS_ORIGIN		-7

// changed to contents_solid
#define	CONTENTS_CLIP		-8

#define	CONTENTS_CURRENT_0	-9
#define	CONTENTS_CURRENT_90	-10
#define	CONTENTS_CURRENT_180	-11
#define	CONTENTS_CURRENT_270	-12
#define	CONTENTS_CURRENT_UP	-13
#define	CONTENTS_CURRENT_DOWN	-14
#define CONTENTS_TRANSLUCENT	-15
#define	CONTENTS_LADDER		-16

// generic damage was done
#define DMG_GENERIC		0

// crushed by falling or moving object
#define DMG_CRUSH		(1 << 0)

// shot
#define DMG_BULLET		(1 << 1)

// cut, clawed, stabbed
#define DMG_SLASH		(1 << 2)

// heat burned
#define DMG_BURN		(1 << 3)

// frozen
#define DMG_FREEZE		(1 << 4)

// fell too far
#define DMG_FALL		(1 << 5)

// explosive blast damage
#define DMG_BLAST		(1 << 6)

// crowbar, punch, headbutt
#define DMG_CLUB		(1 << 7)

// electric shock
#define DMG_SHOCK		(1 << 8)

// sound pulse shockwave
#define DMG_SONIC		(1 << 9)

// laser or other high energy beam
#define DMG_ENERGYBEAM		(1 << 10)

// with this bit OR'd in, no damage type will be able to gib victims upon death
#define DMG_NEVERGIB		(1 << 12)

// with this bit OR'd in, any damage type can be made to gib victims upon death.
#define DMG_ALWAYSGIB		(1 << 13)

// Drowning
#define DMG_DROWN		(1 << 14)

// mask for time-based damage
#define DMG_TIMEBASED		(~(0x3fff))

// slows affected creature down
#define DMG_PARALYZE		(1 << 15)

// nerve toxins, very bad
#define DMG_NERVEGAS		(1 << 16)

// blood poisioning
#define DMG_POISON		(1 << 17)

// radiation exposure
#define DMG_RADIATION		(1 << 18)

// drowning recovery
#define DMG_DROWNRECOVER	(1 << 19)

// toxic chemicals or acid burns
#define DMG_ACID		(1 << 20)

// in an oven
#define DMG_SLOWBURN		(1 << 21)

// in a subzero freezer
#define DMG_SLOWFREEZE		(1 << 22)

// Hit by air raid (done to distinguish grenade from mortar)
#define DMG_MORTAR		(1 << 23)
