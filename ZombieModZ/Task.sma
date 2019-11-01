enum Task(+= 2000)
{
	TaskCheckPoints = 1000
}

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

public Task_CheckPoints(task)
{
	new id = task - TaskCheckPoints

	if (is_user_alive(id))
	{
		if (UserUnusedLevel[id] >= 1)
		{
			msgbegin(MSG_ONE, gZombieZ, id)
			//engfunc(EngFunc_MessageBegin, MSG_ONE, gZombieZ, {0.0, 0.0, 0.0}, index)
			//engfunc(EngFunc_MessageBegin, MSG_ONE, gZombieZ)
			write_byte(1)
			write_string("Evolve")
			message_end()
			return
		}
		else
		{
			msgbegin(MSG_ONE, gZombieZ, id)
			//engfunc(EngFunc_MessageBegin, MSG_ONE, gZombieZ, {0.0, 0.0, 0.0}, index)
			//engfunc(EngFunc_MessageBegin, MSG_ONE, gZombieZ)
			write_byte(0)
			message_end()
			return

		}
	}
	else if (!is_user_alive(id))
	{
		msgbegin(MSG_ONE, gZombieZ, id)
		write_byte(0)
		message_end()
		return
	}
}