 // [BTE Task Function]
 enum TASK_LIST(+=2000)
 {
	TASK_HAMMER_CHANGE = 1000,
	TASK_KNIFE_DELAY,
	TASK_BOT_WEAPON,
	TASK_BUFF
 }
 public Task_Bot_Weapon(iTaskid)
{
	static id ; id = iTaskid - TASK_BOT_WEAPON
	static iType
	if(!g_modruning) iType = 1
	else iType = 0
	if(g_modruning == BTE_MOD_GD) return
	if(g_mywpn_enable)
	{
		new iSize = g_mywpn_cachenum[WPN_RIFLE] - 1
		Pub_Give_Named_Wpn(id,g_mywpn_r_cache[random_num(0,iSize)],iType)
		iSize = g_mywpn_cachenum[WPN_PISTOL] - 1
		Pub_Give_Named_Wpn(id,g_mywpn_p_cache[random_num(0,iSize)],iType)
		iSize = g_mywpn_cachenum[WPN_KNIFE] - 1
		Pub_Give_Named_Wpn(id,g_mywpn_k_cache[random_num(0,iSize)],iType)
		iSize = g_mywpn_cachenum[WPN_HE] - 1
		if(random_num(0,1)) Pub_Give_Named_Wpn(id,g_mywpn_h_cache[random_num(0,iSize)],iType)
	}
	else 
	{
		new iSize = g_wpn_count[WPN_RIFLE]
		Pub_Give_Named_Wpn(id,c_model[g_wpn_count_match[WPN_RIFLE][random_num(1,iSize)]],iType)
		iSize = g_wpn_count[WPN_PISTOL]
		Pub_Give_Named_Wpn(id,c_model[g_wpn_count_match[WPN_PISTOL][random_num(1,iSize)]],iType)
		iSize = g_wpn_count[WPN_KNIFE]
		Pub_Give_Named_Wpn(id,c_model[g_wpn_count_match[WPN_KNIFE][random_num(1,iSize)]],iType)
		iSize = g_wpn_count[WPN_HE]
		Pub_Give_Named_Wpn(id,c_model[g_wpn_count_match[WPN_HE][random_num(1,iSize)]],iType)
	}	
}
 public Task_Reset(id)
 {
	remove_task(id+TASK_HAMMER_CHANGE)
	remove_task(id+TASK_KNIFE_DELAY)
	g_hammer_changing[id]=0
 }
 public Task_HammerChange(iTask)
{
	new id = iTask - TASK_HAMMER_CHANGE
	g_hammer_stat[id]=1-g_hammer_stat[id]
	g_hammer_changing[id]=0
	if(g_hammer_stat[id])
	{
		set_pev(id, pev_viewmodel2, "models/bte_wpn/v_hammer_2.mdl")
		Pub_Set_MaxSpeed(id,c_gravity[g_weapon[id][0]] - 100)
	}
	else
	{
		set_pev(id, pev_viewmodel2, "models/bte_wpn/v_hammer.mdl")
		Pub_Set_MaxSpeed(id,c_gravity[g_weapon[id][0]])
	}
	Stock_Send_Anim(id,0)
}
 public Task_Delay_Attack(pParam[])
{
	new id = pParam[0]
	new iBtn = pParam[1]
	new Float:fRange = iBtn==FAKE_SLASH?c_k_distance1[g_weapon[id][3]]:c_k_distance2[g_weapon[id][3]]
	
	// BALROG9 EFFECT
	if(c_special[g_weapon[id][0]] == SPECIAL_BALROG9 && iBtn==FAKE_STAB)
	{
		new Float:vOri[3],Float:vecForward[3]
		Stock_Get_Postion(id,15.0,0,0,vOri)
		
		message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
		write_byte(TE_EXPLOSION)
		write_coord(floatround(vOri[0]))
		write_coord(floatround(vOri[1]))
		write_coord(floatround(vOri[2]))
		write_short(g_cache_barlog7exp)
		write_byte(2)
		write_byte(5)
		write_byte(TE_EXPLFLAG_NONE)
		message_end()
		
		new iVictim = -1
		const Float:fRadiusDmg = 50.0
		while ((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vOri, c_k_distance1[g_weapon[id][0]])) != 0)
		{
			if (!pev_valid(iVictim)) continue;
			if(iVictim == id) continue
			
			pev(iVictim, pev_origin, vecForward)
			new Float:fDistance = get_distance_f(vOri, vecForward)
			if(fDistance>c_k_distance1[g_weapon[id][0]]) continue
			new Float:fDamage = fRadiusDmg - floatmul(fRadiusDmg, floatdiv(fDistance, c_k_distance1[g_weapon[id][0]])) //get the damage value
			fDamage *= Stock_Adjust_Damage(vOri, iVictim, 0) //adjust
			if(fDamage<1.0) fDamage = 1.0
			Pub_Fake_Damage_Guns(id,iVictim,fDamage,FAKE_TYPE_GENER_HEAD,9999.0)
		}
		return
	}
	
	if(!is_user_alive(id)) return
	new sSound[128]
	
	new iCallback = Pub_Fake_Melee_Attack(id,fRange,iBtn==FAKE_SLASH?0:c_k_angle[g_weapon[id][3]],iBtn)
	if(iCallback == FAKE_RESULT_HIT_PLAYER)
	{
		format(sSound,127,"weapons/%s_stab.wav",c_model[g_weapon[id][3]])
	}
	else if(iCallback == FAKE_RESULT_HIT_WALL)
	{
		format(sSound,127,"weapons/%s_hitwall.wav",c_model[g_weapon[id][3]])
	}
	else
	{
		format(sSound,127,"weapons/%s_miss.wav",c_model[g_weapon[id][3]])
	}
	engfunc(EngFunc_EmitSound, id, CHAN_WEAPON, sSound, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
	if(c_special[g_weapon[id][0]] == SPECIAL_DRAGONTAIL && iBtn==FAKE_STAB)
	{
		Stock_Send_Anim(id,6)
	}
}
 public Task_Register_Bot(id)
 {
	 if (g_hamczbots || !is_user_connected(id) || !get_pcvar_num(cvar_botquota)) return
	 
	 RegisterHamFromEntity(Ham_TakeDamage, id, "HamF_TakeDamage")
	 RegisterHamFromEntity(Ham_TraceAttack, id, "HamF_TraceAttack")
	 RegisterHamFromEntity(Ham_Spawn, id, "HamF_Spawn_Player_Post",1)
	 RegisterHamFromEntity(Ham_Killed, id, "HamF_Killed", 1)
	 RegisterHamFromEntity(Ham_AddPlayerItem, id,"HamF_AddPlayerItem")
	 g_hamczbots = 1
 }