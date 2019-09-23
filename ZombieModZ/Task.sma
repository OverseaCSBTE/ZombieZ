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

public Task_SetLight(id)
{
	/*new szLight[2]
	get_pcvar_string(Cvar_Light,szLight,2)*/
	SetLight(id,g_light)
}
