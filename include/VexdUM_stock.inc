/* Vexd Utility Module Stocks
*
* by the AMX Mod Dev Team
*
* This file is provided as is (no warranties).
*/

#if defined _vexdum_stock_included
  #endinput
#endif
#define _vexdum_stock_included

stock DotProduct(Float:vec1[3], Float:vec2[3])
{
	return (vec1[0] * vec2[0]) + (vec1[1] * vec2[1]) + (vec1[2] * vec2[2])
}

stock fake_kill(killer, victim, headshot, weapon[], log)
{
	// Create the fake message in top right corner
	message_begin(MSG_ALL, get_user_msgid("DeathMsg"), {0,0,0}, 0)
	write_byte(killer)
	write_byte(victim)
	write_byte(headshot)
	write_string(weapon)
	message_end()

	// Kill the victim
	user_kill(victim, 1)

	// Acknowledge the killers kill
	set_user_frags(killer, get_user_frags(killer) + (killer != victim ? 1 : -1))

	// Server logging
	if(log)
	{
		new kname[32], vname[32], kauthid[32], vauthid[32], kteam[10], vteam[10]

		// Info On Killer
		get_user_name(killer, kname, 31)
		get_user_team(killer, kteam, 9)
		get_user_authid(killer, kauthid, 31)
 
		// Info On Victim
		get_user_name(victim, vname, 31)
		get_user_team(victim, vteam, 9)
		get_user_authid(victim, vauthid, 31)
		
		// Log Kill
		if(killer == victim)
		{
			log_message("^"%s<%d><%s><%s>^" committed suicide with ^"%s^"", 
				kname, get_user_userid(killer), kauthid, kteam, weapon)
		}
		else
		{
			log_message("^"%s<%d><%s><%s>^" killed ^"%s<%d><%s><%s>^" with ^"%s^"", 
				kname, get_user_userid(killer), kauthid, kteam, 
 				vname, get_user_userid(victim), vauthid, vteam, weapon)
		}
	}
	return 1
}

stock fake_damage(victim, szClassname[], Float:damage, damagetype)
{
	new entity = create_entity("trigger_hurt")
	if(entity)
	{
		DispatchKeyValue(entity, "classname", "trigger_hurt")
		new szDamage[16]
		format(szDamage, 15, "%f", damage * 2)
		DispatchKeyValue(entity, "dmg", szDamage)
		format(szDamage,15, "%i", damagetype)
		DispatchKeyValue(entity, "damagetype", szDamage)
		DispatchKeyValue(entity, "origin", "8192 8192 8192")
		DispatchSpawn(entity)
		entity_set_string(entity, EV_SZ_classname, szClassname)
		fake_touch(entity, victim)
		remove_entity(entity)
		return 1
	}
	return 0
}

stock get_user_button(id)
{
	return entity_get_int(id, EV_INT_button)
}

stock get_user_oldbutton(id)
{
	return Entvars_Get_Int(id, EV_INT_oldbuttons)
}

stock get_entity_flags(ent)
{
	return Entvars_Get_Int(ent, EV_INT_flags)
}

stock get_entity_distance(ent1, ent2)
{
	new Float:orig1[3], Float:orig2[3]
	entity_get_vector(ent1, EV_VEC_origin, orig1)
	entity_get_vector(ent2, EV_VEC_origin, orig2)
 
	return floatround(vector_distance(orig1, orig2))
}

stock get_grenade(id)
{
	new iGrenade = FindEntity(-1, "grenade")
	while(iGrenade > 0)
	{
		if(entity_get_edict(iGrenade, EV_ENT_owner) == id)
			return iGrenade

		iGrenade = find_entity(iGrenade, "grenade")
	}

	return 0
}

stock get_brush_entity_origin(ent, Float:orig[3])
{
	new Float:Min[3], Float:Max[3]
	entity_get_vector(ent, EV_VEC_mins, Min)
	entity_get_vector(ent, EV_VEC_maxs, Max)
	for(new a = 0; a < 3; a++)
		orig[a] = (Min[a] + Max[a]) / 2

	return orig[0] && orig[1] && orig[2]
}

stock remove_entities(eName[])
{
	new iEntity = find_entity(-1, eName)
	while(iEntity > 0)
	{
		remove_entity(iEntity)
		iEntity = find_entity(-1, eName)
	}

	return 1
}

stock ViewContents(id)
{
	new origin[3],Float:Orig[3]
	get_user_origin( id, origin, 3 )
	for(new a = 0; a < 3; a++)
	{
		Orig[a] = float(origin[a])
	}
	return PointContents(Orig)
}

stock bool:CheckFlag(ent,flag) 
{
	switch(flag) 
	{
		case FL_FLY: 		if(entity_get_int(ent, EV_INT_flags) & FL_FLY) 		return true
		case FL_SWIM: 		if(entity_get_int(ent, EV_INT_flags) & FL_SWIM)		return true
		case FL_CONVEYOR:	if(entity_get_int(ent, EV_INT_flags) & FL_CONVEYOR)		return true
		case FL_CLIENT:		if(entity_get_int(ent, EV_INT_flags) & FL_CLIENT)		return true
		case FL_INWATER:	if(entity_get_int(ent, EV_INT_flags) & FL_INWATER)		return true
		case FL_MONSTER:	if(entity_get_int(ent, EV_INT_flags) & FL_MONSTER)		return true
		case FL_GODMODE:	if(entity_get_int(ent, EV_INT_flags) & FL_GODMODE)		return true
		case FL_NOTARGET:	if(entity_get_int(ent, EV_INT_flags) & FL_NOTARGET)		return true
		case FL_SKIPLOCALHOST:	if(entity_get_int(ent, EV_INT_flags) & FL_SKIPLOCALHOST)	return true
		case FL_ONGROUND:	if(entity_get_int(ent, EV_INT_flags) & FL_ONGROUND)		return true
		case FL_PARTIALGROUND:	if(entity_get_int(ent, EV_INT_flags) & FL_PARTIALGROUND)	return true
		case FL_WATERJUMP:	if(entity_get_int(ent, EV_INT_flags) & FL_WATERJUMP)		return true
		case FL_FROZEN:		if(entity_get_int(ent, EV_INT_flags) & FL_FROZEN)		return true
		case FL_FAKECLIENT:	if(entity_get_int(ent, EV_INT_flags) & FL_FAKECLIENT)		return true
		case FL_DUCKING:	if(entity_get_int(ent, EV_INT_flags) & FL_DUCKING)		return true
		case FL_FLOAT:		if(entity_get_int(ent, EV_INT_flags) & FL_FLOAT)		return true
		case FL_GRAPHED:	if(entity_get_int(ent, EV_INT_flags) & FL_GRAPHED)		return true
		case FL_IMMUNE_WATER:	if(entity_get_int(ent, EV_INT_flags) & FL_IMMUNE_WATER)	return true
		case FL_IMMUNE_SLIME:	if(entity_get_int(ent, EV_INT_flags) & FL_IMMUNE_SLIME)	return true
		case FL_IMMUNE_LAVA:	if(entity_get_int(ent, EV_INT_flags) & FL_IMMUNE_LAVA)		return true
		case FL_PROXY:		if(entity_get_int(ent, EV_INT_flags) & FL_PROXY)		return true
		case FL_ALWAYSTHINK:	if(entity_get_int(ent, EV_INT_flags) & FL_ALWAYSTHINK)		return true
		case FL_BASEVELOCITY:	if(entity_get_int(ent, EV_INT_flags) & FL_BASEVELOCITY)	return true
		case FL_MONSTERCLIP:	if(entity_get_int(ent, EV_INT_flags) & FL_MONSTERCLIP)		return true
		case FL_ONTRAIN:	if(entity_get_int(ent, EV_INT_flags) & FL_ONTRAIN)		return true
		case FL_WORLDBRUSH:	if(entity_get_int(ent, EV_INT_flags) & FL_WORLDBRUSH)		return true
		case FL_SPECTATOR:	if(entity_get_int(ent, EV_INT_flags) & FL_SPECTATOR)		return true
		case FL_CUSTOMENTITY:	if(entity_get_int(ent, EV_INT_flags) & FL_CUSTOMENTITY)	return true
		case FL_KILLME:		if(entity_get_int(ent, EV_INT_flags) & FL_KILLME)		return true
		case FL_DORMANT:	if(entity_get_int(ent, EV_INT_flags) & FL_DORMANT)		return true
	}
	return false
}

stock get_speed(ent)
{
	new Float:Vel[3]
	entity_get_vector(ent, EV_VEC_velocity, Vel)

	return floatround(vector_length(Vel))
}

stock IVecFVec(iVec[3], Float:fVec[3])
{
	for(new a = 0; a < 3; a++)
	{
		fVec[a] = float(iVec[a])
	}
	return 1
}

stock FVecIVec(Float:fVec[3], iVec[3])
{
	for(new a = 0; a < 3; a++)
	{
		iVec[a] = floatround(fVec[a])
	}
	return 1
}

stock set_rendering(index, fx=kRenderFxNone, r=255, g=255, b=255, render=kRenderNormal, amount=16)
{
	entity_set_int(index, EV_INT_renderfx, fx)
	new Float:RenderColor[3]
	RenderColor[0] = float(r)
	RenderColor[1] = float(g)
	RenderColor[2] = float(b)
	entity_set_vector(index, EV_VEC_rendercolor, RenderColor)
	entity_set_int(index, EV_INT_rendermode, render)
	entity_set_float(index, EV_FL_renderamt, float(amount))
}

stock set_entity_flags(ent ,flag, onoff) 
{
	if((entity_get_int(ent, EV_INT_flags) & flag) > 0) 
	{
		if(onoff == 1)
		{		
			return 2
		}
		else
		{
			entity_set_int(ent, EV_INT_flags, entity_get_int(ent, EV_INT_flags) - flag)
			return 1
		}
	}
	else 
	{
		if(onoff == 0)
		{
			return 2
		}
		else
		{
			entity_set_int(ent, EV_INT_flags, entity_get_int(ent, EV_INT_flags) + flag)
			return 1
		}
	}
	return 0
}
