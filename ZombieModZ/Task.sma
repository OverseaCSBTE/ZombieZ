public Task_ChangeTeam(id)
{
	SetTeam(id, 2)
}

public Task_SetTeam(params[1], taskid)
{
	new id = ID_TEAM
	
	if (task_exists(id + TASK_TEAM))
		remove_task(id + TASK_TEAM)
}

public Task_Register_Bots(id)
{
	if (g_hamczbots || !is_user_connected(id)) return

	RegisterHamFromEntity(Ham_Spawn, id, "HamF_Spawn_Player")
	RegisterHamFromEntity(Ham_Spawn, id, "HamF_Spawn_Player_Post", 1)
	RegisterHamFromEntity(Ham_TakeDamage, id, "HamF_TakeDamage")
	//RegisterHamFromEntity(Ham_Killed, id, "HamF_Killed")
	//RegisterHamFromEntity(Ham_Killed, id, "HamF_Killed_Post", 1)
	g_hamczbots = 1
	//if (is_user_alive(id)) fw_PlayerSpawn_Post(id)
}
