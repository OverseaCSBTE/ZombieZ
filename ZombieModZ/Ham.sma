public HamF_HostagePrecache(iEnt)
{
	Util_Log("Hostage Precache Disabled.")
	return HAM_SUPERCEDE;
}

public HamF_Spawn_Player(id)
{
	return HAM_IGNORED;
}

public HamF_Spawn_Player_Post(id)
{
	if (!is_user_alive(id)) return

	if (task_exists(id+TASK_SPAWN)) remove_task(id+TASK_SPAWN)
	
	SetRendering(id)
	StripWeapons(id)
	bte_wpn_give_named_wpn(id, "knife")
	bte_wpn_give_named_wpn(id, "usp")

	set_pev(id, pev_skin, 0);

	CreateProfile(id)

	// ZombieZ Function
}

public HamF_TakeDamage(victim, inflictor, attacker, Float:damage, damage_type)
{
	return HAM_IGNORED
}
