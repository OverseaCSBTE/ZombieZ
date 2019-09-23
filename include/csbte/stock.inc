stock HamHook:BTE_RegisterHam(Ham:function, const EntityClass[], const Callback[], Post = 0)
{
	new ent = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, EntityClass))
	new HamHook:ham = RegisterHamFromEntity(function, ent, Callback, Post)
	engfunc(EngFunc_RemoveEntity, ent)
	return ham
}

stock BTE_GetKeyNum(infobuffer, key[])
{
	static value[32]
	BTE_InfoKeyValue(infobuffer, key, value, charsmax(value))
	return str_to_num(value)
}

stock Float:BTE_GetKeyFloat(infobuffer, key[])
{
	static value[32]
	BTE_InfoKeyValue(infobuffer, key, value, charsmax(value))
	return str_to_float(value)
}

stock BTE_SendWeaponAnim(id, anim = -1, body = 0)
{
	set_pev(id, pev_weaponanim, anim)
	message_begin(MSG_ONE, SVC_WEAPONANIM, _, id)
	write_byte(anim)
	write_byte(body)
	message_end()
}