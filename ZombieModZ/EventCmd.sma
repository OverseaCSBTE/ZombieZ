public Event_HLTV()
{
	g_endround = 0
	g_newround = 0
	g_supplybox_count = 0
	//g_human_morale[0] = 0
	//g_levelmax_check = 0
	remove_task(TASK_MAKEZOMBIE)
	remove_task(TASK_MAKEZOMBIE2)

	if (g_startcount) g_rount_count += 1

	g_ForcerespawnTime = 0.0;
	
	if (g_startcount)
	{
		for (new id = 1; id < 33; id++)
		{
			if(!is_user_connected(id)) continue
			
			g_human[id] = 0;

			set_pev(id,pev_gravity,1.0)
			//RoundStartValue(id)
			SetLight(id,g_light)
			//RenderingHuman(id,1)

			set_task(random_float(0.5,1.0),"Make_Human_Msg",id)
			g_zombie[id] = 0
			g_AliveCheckTime[id] = 0.0
			
			if (task_exists(id + TASK_SHOWINGMENU))
			{
				remove_task(id + TASK_SHOWINGMENU);
				GAME_DrawMenu(id, "-");
			}
			
			if (g_zbselected[id])
			{
				g_zbselected[id] = 0;
				GAME_SendData(id, 12, 0);
			}
		}
	}
}

public Event_DeathMsg()
{
	
}

public LogEvent_RoundStart()
{
	if (g_rount_count)
	{
		new Float:round_time;
		round_time = get_cvar_float("mp_roundtime") * 60.0;

		//if (task_exists(TASK_FORCEWIN)) remove_task(TASK_FORCEWIN);
		//set_task(round_time,"HumanWin",TASK_FORCEWIN);

		//SetBlockRound(1);
		//PlaySound(0, SND_ROUND_START);
		
		//g_count_down = COUNT_DOWN_START
		//Task_CountDown()
		//if (task_exists(TASK_MAKEZOMBIE)) remove_task(TASK_MAKEZOMBIE)
		//set_task(1.0, "Task_CountDown", TASK_MAKEZOMBIE, _, _, "b")
		//SelectHostZombie()
	}
}

public LogEvent_RoundEnd()
{
	//if (task_exists(TASK_FORCEWIN)) remove_task(TASK_FORCEWIN);
	//RemoveNamedEntity(SUPPLYBOX_CLASSNAME)

	g_endround = 1

	g_newround = 0

	/*
	if (g_startcount && g_count_down == -1)
	{
		new humans = Stock_GetPlayer(0)
		if (humans)
		{
			g_score_human += 1
			//PlaySound(0, SND_WIN_HUMAN)
			GAME_EndBoard(1, 2);
			//MH_DrawTargaImage(0,"mode\\zb3\\humanwin",1,1,255,255,255,0.5,0.35,0,11,5.0)

			//for(new i =1;i<33;i++)
				//if(!g_zombie[i] && is_user_connected(i)) UpdateFrags(i, 7)
		}
		else
		{
			g_score_zombie += 1
			//PlaySound(0, SND_WIN_ZOMBIE)
			GAME_EndBoard(2, 2);
			//MH_DrawTargaImage(0,"mode\\zb3\\zombiewin",1,1,255,255,255,0.5,0.35,0,11,5.0)

			//for(new i =1;i<33;i++)
				//if(g_zombie[i] && is_user_connected(i)) UpdateFrags(i, 1)
		}
	}
	*/
}

public CMD_ChooseTeam(id)
{
	//ShowKeepMenu(id)
	return PLUGIN_HANDLED
}
