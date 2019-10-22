stock Set_Kvd(entity, const key[], const value[], const classname[])
{
	set_kvd(0, KV_ClassName, classname)
	set_kvd(0, KV_KeyName, key)
	set_kvd(0, KV_Value, value)
	set_kvd(0, KV_fHandled, 0)

	dllfunc(DLLFunc_KeyValue, entity, 0)
}

stock Connect_Reset(id)
{
	g_respawning[id] = 0
	g_zombie[id] = 0
	g_hero[id] = 0
	g_sidekick[id] = 0
	g_zombieclass[id] = 0
	g_AliveCheckTime[id] = 0.0
	g_zbclass_keep[id] = -1
	MH_DrawRetina(id, "", 0, 1, 1, 1, 0.0)
	MH_DrawRetina(id, "", 0, 1, 1, 2, 0.0)

	set_task(1.0, "Task_ChangeTeam", id)
}

stock SetTeam(id, team)
{
	static params[1]
	params[0] = team
	if (task_exists(id + TASK_TEAM))
		remove_task(id + TASK_TEAM)
	set_task(0.1, "Task_SetTeam", id + TASK_TEAM, params, sizeof params)
}

stock GetRandomPlayer(iTeam)
{
	// Perpare all available players
	new iCount, iSlot[33]
	for(new i = 1; i < 33; i++)
	{
		if(is_user_alive(i))
		{
			iSlot[iCount] = i
			iCount++
		}
	}
	if(iTeam == 1) // Zombie
	{
		new iCounter
		for(new j = random_num(0, iCount - 1); iCounter < iCount; iCounter++)
		{
			if(g_zombie[iSlot[j]])
				return iSlot[j]
			j++
			
			if(j == iCount)
				j = 0
		}
		//PRINT("随机失败")
		return 0
	}
	if(iTeam == 2) // Human
	{
		new iCounter
		for(new j = random_num(0, iCount - 1); iCounter < iCount; iCounter++)
		{
			if(!g_zombie[iSlot[j]])
				return iSlot[j]
			j++
			
			if(j == iCount)
				j = 0
		}
		//PRINT("随机失败")
		return 0
	}
	return 0
}

stock Str_Count(const str[], searchchar)
{
	new count, i, len = strlen(str)
	for (i = 0; i <= len; i++)
	{
		if(str[i] == searchchar)
			count++
	}
	return count
}

stock SetRendering(entity, fx = kRenderFxNone, r = 255, g = 255, b = 255, render = kRenderNormal, amount = 16)
{
	static Float:color[3]
	color[0] = float(r)
	color[1] = float(g)
	color[2] = float(b)

	set_pev(entity, pev_renderfx, fx)
	set_pev(entity, pev_rendercolor, color)
	set_pev(entity, pev_rendermode, render)
	set_pev(entity, pev_renderamt, float(amount))
}

stock StripWeapons(id)
{
	set_pev(id, pev_button, pev(id, pev_button) & ~IN_ATTACK & ~IN_ATTACK2)

	dllfunc(DLLFunc_Use, g_player_weaponstrip, id)
}
