/* Vexd Utility Module Core
*
* by the AMX Mod Dev Team
*
* This file is provided as is (no warranties).
*/

#if defined _vexdum_included
  #endinput
#endif
#define _vexdum_included

#include <VexdUM_const>

// Set Model (CS) Model would be "vip" for the vip model.
native CS_SetModel(index, const Model[]);

// Clear Model (CS)
native CS_ClearModel(index);

// Set Model (TFC)
native TFC_SetModel(index, const Model[], const Skin[]);

// Clear Model (TFC)
native TFC_ClearModel(index);

// Set Player's View to entity iTargetIndex.
native attach_view(iIndex, iTargetIndex);

// Set Player's Speak Flags.
native set_speak(iIndex, iSpeakFlags);

// Set map lighting, #OFF to disable.
native set_lights(const Lighting[]);

// Set things in an entities Entvars Struct. See HLSDK or look at examples to determine what different variables do.
native entity_get_int(iIndex, iVariable);
native entity_set_int(iIndex, iVariable, iNewValue);
native Float:entity_get_float(iIndex, iVariable); 
native entity_set_float(iIndex, iVariable, Float:fNewValue);
native entity_get_vector(iIndex, iVariable, Float:vRetVector[3]);
native entity_set_vector(iIndex, iVariable, Float:vNewVector[3]);
native entity_get_edict(iIndex, iVariable);
native entity_set_edict(iIndex, iVariable, iNewIndex);
native entity_get_string(iIndex, iVariable, szReturnValue[], iReturnLen); 
native entity_set_string(iIndex, iVariable, szNewValue[]);
native entity_get_byte(iIndex, iVariable);
native entity_set_byte(iIndex, iVariable, iNewValue);

// Hurts/Kills players in a sphere, like an explosion, Multiplier determines damage.
native RadiusDamage(Float:fExplodeAt[3], iDamageMultiplier, iRadiusMultiplier);

// Gives you a velocity in the direction a player is looking, iVelocity is the multiplier.
native VelocityByAim(iIndex, iVelocity, Float:vRetValue[3]);

// Will return the contents of a point (inside map? in sky? outside map? etc.)
native PointContents(Float:fCheckAt[3]);

// Creates an entity, will return the index of the created entity. ClassName must be valid.
native create_entity(szClassname[]);

// Dispatch a KeyValuePair, used for initalizing entities when a map spawns them.
native DispatchKeyValue(iIndex, szKey[], szValue[]);

// Runs the GameDLL's DispatchSpawn for an entity, I think it's used with DispatchKeyValue.
native DispatchSpawn(iIndex);

// Sets the model of an Entity.
native entity_set_model(iIndex, szModel[]);

// Proper origin setting, keeps updated with Half-Life engine.
native entity_set_origin(iIndex, Float:fNewOrigin[3]);

// Sets the Bounding Box Size of an entity.
native entity_set_size(iIndex, Float:vecMin[3], Float:vecMax[3]);

// Find an entity in the world, will return -1 if nothing is found
native find_entity(iIndex, szValue[]);

// Remove an entity from the world
native remove_entity(iIndex);

// Trace a line from Start(X, Y, Z) to End(X, Y, Z), will return the point hit in vReturn[3]
// Will return an entindex if an entity is hit.
native trace_line(iIgnoreEnt, Float:fStart[3], Float:fEnd[3], Float:vReturn[3]);

// Traces a line, and returns the normal to the plane hit in vReturn.
// Returns 0 if theres no normal.
native trace_normal(iIgnoreEnt, Float:fStart[3], Float:fEnd[3], Float:vReturn[3]);

// Changes a Vector to an Angle vector.
native vector_to_angle(Float:fVector[3], Float:vReturn[3]);

// Converts an angle to a vector.
native angle_to_vector(Float:fAngle[3], Float:vReturn[3]);

// Gets the length of a vector (float[3]).
native Float:vector_length(Float:vVector[3]);

// Gets the distance between 2 vectors (float[3]).
native Float:vector_distance(Float:vVector[3], Float:vVector2[3]);

// Set/Get What Engine Messages Are Blocked.
native set_msg_block(iMessage, iMessageFlags);
native get_msg_block(iMessage);

// Precache any file
native precache_generic(szFile[]);

// Precache event
native precache_event(type, szEvent[]);

// playback a precahced event
native playback_event(flags,invoker,eventindex,Float:delay,Float:origin[3],Float:angles[3],Float:fparam1,Float:fparam2,iparam1,iparam2,bparam1,bparam2);

// Gets an integer from iTarget's pvPrivateData at iOffset.
native get_offset_int(iTarget, iOffset);

// Sets an integer iValue in iTarget's pvPrivateData at iOffset.
native set_offset_int(iTarget, iOffset, iValue);

// Gets number of ents in a map
native get_num_ents();

// Checks if index is an existing ent
native is_entity(index);

// Get whole buffer containing keys and their data
native get_info_keybuffer(id, buffer[], length);

// Fake one entity touching another.
native fake_touch(iToucher, iTouched);

// Called once every server frame. May cause lag.
forward server_frame();

// Called when 2 entities touch.
forward entity_touch(entity1, entity2);

// Called on an entity's DispatchThink
forward entity_think(entity);

// Called before the engine calculates player movement, etc.
forward client_prethink(id);

// Called after the engine has calculated player movement
forward client_postthink(id);

// Called when a client types kill in console
forward client_kill(id);

// Called when an Emitting Sound is played Server-Side
forward emitsound(entity, const sample[]);

// Called when a model spawns
forward set_model(edict, const model[]);
//----------------------------------------------------------------------------------------------
// Maths
native abs(iInput);
native fabs(Float:flInput);
native asin(Float:flInput);
native sin(Float:flInput);
native sinh(Float:flInput);
native acos(Float:flInput);
native cos(Float:flInput);
native cosh(Float:flInput);
native atan(Float:flInput);
native atan2(Float:flInput1, Float:flInput2);
native tan(Float:flInput);
native tanh(Float:flInput);
