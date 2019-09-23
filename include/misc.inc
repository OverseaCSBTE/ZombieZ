/* Include file for misc module
   2003 - Lazy
*/

#if defined _misc_included
  #endinput
#endif
#define _misc_included

/* Returns the player's flags */
native get_player_flags(id);

/* Returns the player's class (TFC ONLY) */
native get_player_class(id);

/* Returns the current key the player is pressing */
native get_player_keypress(id);

/* Gets the type of solid the player is looking at */
native get_contents(id);

/* Sets the current player's class (TFC ONLY) */
native set_player_class(id, classnum);

/* Sets the current player's team (TFC ONLY) */
native set_player_team(id, team);

/* BETA - Entity creation */
native create_entity(entname[], classname[], model[], origin[], drop_to_floor, renderfx, rendermode, renderamt, render_red, render_green, render_blue, solid_type);
native remove_entity(entnum);
native kill_entity(entindex);
native render_entity(entindex, renderfx, rendermode, renderamount, red, green, blue);
native rotate_entity(entindex, xaxis, yaxis, zaxis);
native move_entity(entindex, x, y, z);
native create_monster(monster[], model[], origin[], use_custom, xaxis, yaxis, zaxis, health, render_fx, render_mode, render_amt, render_r, render_g, render_b, Float:gravity, solid, movetype, spawnflags);
native set_view(index1, index2);
native get_classname(index, classname[], ilen);
native create_bot(name[]);
native get_texture(id, text[], ilen);

/* Flag defines */
#define	FL_FLY				(1<<0)	// Changes the SV_Movestep() behavior to not need to be on ground
#define	FL_SWIM				(1<<1)	// Changes the SV_Movestep() behavior to not need to be on ground (but stay in water)
#define	FL_CONVEYOR			(1<<2)
#define	FL_CLIENT			(1<<3)
#define	FL_INWATER			(1<<4)
#define	FL_MONSTER			(1<<5)
#define	FL_GODMODE			(1<<6)
#define	FL_NOTARGET			(1<<7)
#define	FL_SKIPLOCALHOST		(1<<8)	// Don't send entity to local host, it's predicting this entity itself
#define	FL_ONGROUND			(1<<9)	// At rest / on the ground
#define	FL_PARTIALGROUND		(1<<10)	// not all corners are valid
#define	FL_WATERJUMP			(1<<11)	// player jumping out of water
#define FL_FROZEN			(1<<12) // Player is frozen for 3rd person camera
#define FL_FAKECLIENT			(1<<13)	// JAC: fake client, simulated server side; don't send network messages to them
#define FL_DUCKING			(1<<14)	// Player flag -- Player is fully crouched
#define FL_FLOAT			(1<<15)	// Apply floating force to this entity when in water
#define FL_GRAPHED			(1<<16) // worldgraph has this ent listed as something that blocks a connection
#define FL_IMMUNE_WATER			(1<<17)
#define	FL_IMMUNE_SLIME			(1<<18)
#define FL_IMMUNE_LAVA			(1<<19)
#define FL_PROXY			(1<<20)	// This is a spectator proxy
#define FL_ALWAYSTHINK			(1<<21)	// Brush model flag -- call think every frame regardless of nextthink - ltime (for constantly changing velocity/path)
#define FL_BASEVELOCITY			(1<<22)	// Base velocity has been applied this frame (used to convert base velocity into momentum)
#define FL_MONSTERCLIP			(1<<23)	// Only collide in with monsters who have FL_MONSTERCLIP set
#define FL_ONTRAIN			(1<<24) // Player is _controlling_ a train, so movement commands should be ignored on client during prediction.
#define FL_WORLDBRUSH			(1<<25)	// Not moveable/removeable brush entity (really part of the world, but represented as an entity for transparency or something)
#define FL_SPECTATOR           		(1<<26) // This client is a spectator, don't run touch functions, etc.
#define FL_CUSTOMENTITY			(1<<29)	// This is a custom entity
#define FL_KILLME			(1<<30)	// This entity is marked for death -- This allows the engine to kill ents at the appropriate time
#define FL_DORMANT			(1<<31)	// Entity is dormant, no updates to client

/* Solid */

#define	SOLID_NOT				0		// no interaction with other objects
#define	SOLID_TRIGGER				1		// touch on edge, but not blocking
#define	SOLID_BBOX				2		// touch on edge, block
#define	SOLID_SLIDEBOX				3		// touch on edge, but not an onground
#define	SOLID_BSP				4		// bsp clip, touch on edge, block

/* Movetype */

#define	MOVETYPE_NONE			0		// never moves
#define MOVETYPE_ANGLENOCLIP		1
#define MOVETYPE_ANGLECLIP		2
#define	MOVETYPE_WALK			3		// Player only - moving on the ground
#define	MOVETYPE_STEP			4		// gravity, special edge handling -- monsters use this
#define	MOVETYPE_FLY			5		// No gravity, but still collides with stuff
#define	MOVETYPE_TOSS			6		// gravity/collisions
#define	MOVETYPE_PUSH			7		// no clip to world, push and crush
#define	MOVETYPE_NOCLIP			8		// No gravity, no collisions, still do velocity/avelocity
#define	MOVETYPE_FLYMISSILE		9		// extra size to monsters
#define	MOVETYPE_BOUNCE			10		// Just like Toss, but reflect velocity when contacting surfaces
#define MOVETYPE_BOUNCEMISSILE		11		// bounce w/o gravity
#define MOVETYPE_FOLLOW			12		// track movement of aiment
#define	MOVETYPE_PUSHSTEP		13		// BSP model that needs physics/world collisions (uses nearest hull for world collision)

/* Contents */

#define	CONTENTS_EMPTY		-1
#define	CONTENTS_SOLID		-2
#define	CONTENTS_WATER		-3
#define	CONTENTS_SLIME		-4
#define	CONTENTS_LAVA		-5
#define	CONTENTS_SKY		-6
#define	CONTENTS_ORIGIN		-7		// removed at csg time
#define	CONTENTS_CLIP		-8		// changed to contents_solid
#define	CONTENTS_CURRENT_0	-9
#define	CONTENTS_CURRENT_90	-10
#define	CONTENTS_CURRENT_180	-11
#define	CONTENTS_CURRENT_270	-12
#define	CONTENTS_CURRENT_UP	-13
#define	CONTENTS_CURRENT_DOWN	-14
#define CONTENTS_TRANSLUCENT	-15
#define	CONTENTS_LADDER		-16

/* Player Classes */

#define PC_UNDEFINED		0 
#define PC_SCOUT		1 
#define PC_SNIPER		2 
#define PC_SOLDIER		3 
#define PC_DEMOMAN		4 
#define PC_MEDIC		5 
#define PC_HVYWEAP		6 
#define PC_PYRO			7
#define PC_SPY			8
#define PC_ENGINEER		9
#define PC_RANDOM		10
#define PC_CIVILIAN		11
#define PC_LASTCLASS		12 	
