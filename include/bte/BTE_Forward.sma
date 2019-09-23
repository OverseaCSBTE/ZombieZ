// [BTE Fakemeta FORWARD FUNCTION]
public Forward_TraceHull_Post( Float:vecSrc[3], Float:vecEnd[3], noMonsters, hull, iAttacker, iTr)
{
	static iButton,Float:flFraction,iTr2, Float:vecSrc[3], Float:vecForward[3]
	if (!is_user_alive(iAttacker)) return FMRES_IGNORED	
	if (get_user_weapon(iAttacker) != CSW_KNIFE) return FMRES_IGNORED
	if (!g_weapon[iAttacker][0]) return FMRES_IGNORED
	//if (is_user_bot(iAttacker)) return FMRES_IGNORED
		
	
	iButton = pev(iAttacker, pev_button)
	if (!(iButton & IN_ATTACK) && !(iButton & IN_ATTACK2)) return FMRES_IGNORED
	get_tr2(iTr, TR_flFraction, flFraction)
	
	if (flFraction != 1.0)  return FMRES_IGNORED
	pev(iAttacker, pev_origin, vecSrc)
	pev(iAttacker, pev_view_ofs, vecEnd)
	xs_vec_add(vecSrc, vecEnd, vecSrc)

	global_get(glb_v_forward, vecForward)
	if ((iButton & IN_ATTACK) && c_k_distance1[g_weapon[iAttacker][0]]) xs_vec_mul_scalar(vecForward, c_k_distance1[g_weapon[iAttacker][0]], vecForward)
	else if ((iButton & IN_ATTACK2) && c_k_distance2[g_weapon[iAttacker][0]]) xs_vec_mul_scalar(vecForward, c_k_distance2[g_weapon[iAttacker][0]], vecForward)
	xs_vec_add(vecSrc, vecForward, vecEnd)
	engfunc(EngFunc_TraceHull, vecSrc, vecEnd, DONT_IGNORE_MONSTERS, HULL_HEAD,iAttacker, iTr)

	return FMRES_SUPERCEDE
}
public Forward_TraceLine_Post(Float:vecStart[3], Float:vecEnd[3], iNoMonsters, iAttacker, iTr)
{
	static Float:vecTemp[3], Float:vecDir[3],iButton,Float:flFraction,Float:vecSrc[3],Float:vecForward[3]
	static iCswpn
	
	if (!is_user_alive(iAttacker)) return FMRES_IGNORED
	if (!g_weapon[iAttacker][0]) return FMRES_IGNORED
	if (is_user_bot(iAttacker)) return FMRES_IGNORED
	if (bte_get_user_zombie(iAttacker)) return FMRES_IGNORED
	iCswpn = get_user_weapon(iAttacker)
	if (iCswpn != CSW_KNIFE)
	{
		if(iCswpn != CSW_AWP && iCswpn != CSW_SCOUT && iCswpn != CSW_SG550 && iCswpn != CSW_G3SG1)  return FMRES_IGNORED
		if(!get_pcvar_num(cvar_SniperPrecision)) return FMRES_IGNORED
		static Float:fPrecision 
		fPrecision = 0		
		xs_vec_sub(vecEnd, vecStart, vecDir)
		vecDir[0] /= 8192.0
		vecDir[1] /= 8192.0
		vecDir[2] /= 8192.0
		
		global_get(glb_v_forward, vecTemp)
		xs_vec_sub(vecDir, vecTemp, vecDir)
		xs_vec_mul_scalar(vecDir, fPrecision, vecDir)
		xs_vec_add(vecDir, vecTemp, vecDir)
		xs_vec_mul_scalar(vecDir, 8192.0, vecDir)
		xs_vec_add(vecDir, vecStart, vecEnd)
		engfunc(EngFunc_TraceLine, vecStart, vecEnd, iNoMonsters, iAttacker, iTr)
		return FMRES_SUPERCEDE
	}		
	iButton = pev(iAttacker, pev_button)
	if (!(iButton & IN_ATTACK) && !(iButton & IN_ATTACK2)) return FMRES_IGNORED
	get_tr2(iTr, TR_flFraction, flFraction)
	if (flFraction != 1.0)  return FMRES_IGNORED
		
	pev(iAttacker, pev_origin, vecSrc)
	pev(iAttacker, pev_view_ofs, vecEnd)
	xs_vec_add(vecSrc, vecEnd, vecSrc)
	global_get(glb_v_forward, vecForward)
	if ((iButton & IN_ATTACK) && c_k_distance1[g_weapon[iAttacker][0]]) xs_vec_mul_scalar(vecForward, c_k_distance1[g_weapon[iAttacker][0]], vecForward)
	else if ((iButton & IN_ATTACK2) && c_k_distance2[g_weapon[iAttacker][0]]) xs_vec_mul_scalar(vecForward, c_k_distance2[g_weapon[iAttacker][0]], vecForward)
	xs_vec_add(vecSrc, vecForward, vecEnd)
	engfunc(EngFunc_TraceLine, vecSrc, vecEnd, DONT_IGNORE_MONSTERS, iAttacker, iTr)
	return FMRES_SUPERCEDE
}
public Forward_FindEntityInSphere(iStartEnt,Float:vPos[3],Float:fRange)
{
	static id
	if(fRange == 350.0)
	{
		id = Get_Wpn_Data(iStartEnt,DEF_OWNER)
		if(id && pev(iStartEnt,pev_iuser2)!=1111) // ZombieBomb
		{
			message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
			write_byte(TE_EXPLOSION)
			engfunc(EngFunc_WriteCoord,vPos[0])
			engfunc(EngFunc_WriteCoord,vPos[1])
			engfunc(EngFunc_WriteCoord,vPos[2])
			write_short(c_he_spr[Get_Wpn_Data(iStartEnt,DEF_ID)])
			write_byte(40)
			write_byte(30)
			write_byte(TE_EXPLFLAG_NONE)
			message_end()
		}
	}
	return FMRES_IGNORED
}
public Forward_UpdateClientData_Post(id,iWeapon,iCD)
{
	if(c_type[g_weapon[id][0]] == WEAPONS_M134 && g_wpn_m134_stat[id] == M134_IDLE)
	{
		set_cd(iCD,CD_flNextAttack,get_gametime()+1.0)
	}
	else if(c_type[g_weapon[id][0]] == WEAPONS_LAUNCHER || c_type[g_weapon[id][0]] == WEAPONS_BAZOOKA || c_type[g_weapon[id][0]] == WEAPONS_FLAMETHROWER || c_special[g_weapon[id][0]] == SPECIAL_MUSKET
	 || c_special[g_weapon[id][0]] == SPECIAL_CROSSBOW || c_special[g_weapon[id][0]] == SPECIAL_CATAPULT || c_special[g_weapon[id][0]] == SPECIAL_CANNON || c_type[g_weapon[id][0]] == WEAPONS_M32)
	{
		set_cd(iCD,CD_flNextAttack,get_gametime()+1.0)
	}
}
public Forward_PlaybackEvent(iFlags, id, iEvent, iDelay, Float:vecOrigin[3], Float:vecAngle[3], Float:flParam1, Float:flParam2, iParam1, iParam2, bParam1, bParam2)
{
	if(!is_user_alive(id)) return FMRES_IGNORED
	
	new sound[128]
	if (g_double[id][0] && c_sound[g_weapon[id][0]] == 2)
	{
		if (!g_silen[id]) format(sound, charsmax(sound), "%s", c_sound2[g_weapon[id][0]])
		else format(sound, charsmax(sound), "%s", c_sound2_silen[g_weapon[id][0]])
	}
	else
	{
		if (!g_silen[id]) format(sound, charsmax(sound), "%s", c_sound1[g_weapon[id][0]])
		else format(sound, charsmax(sound), "%s", c_sound1_silen[g_weapon[id][0]])
	}
	emit_sound(id, CHAN_WEAPON,sound,1.0, ATTN_NORM, 0, PITCH_NORM)
	
	if(g_shoottimer[id] < get_gametime())
	{
		g_shoottimes[id] = 1
	}
	else g_shoottimes[id] ++
	g_shoottimer[id] = get_gametime()+0.3
	
	if(c_type[g_weapon[id][0]] == WEAPONS_SPSHOOT)
	{
		static pAct
		pAct = get_pdata_cbase(id,m_pActiveItem)
		if(pAct>0 && get_pdata_int(pAct,m_iFamasShotsFired)>10) 
		{
			engfunc(EngFunc_PlaybackEvent, FEV_GLOBAL , id, WEAPON_EVENT[c_wpnchange[g_weapon[id][0]]], iDelay, vecOrigin, vecAngle, flParam1 , flParam2, iParam1, iParam2, bParam1, bParam2)
			return FMRES_SUPERCEDE
		}
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_TRACER  ||  c_special[g_weapon[id][0]] == SPECIAL_SFSNIPER)
	{
		// Trace
		new Float:vecStart[3],Float:vDest[3]
		velocity_by_aim(id,5000,vDest)
		Stock_Get_Postion(id,13.0,13.0,-8.0,vecStart)
		if(c_special[g_weapon[id][0]] == SPECIAL_SFSNIPER) Stock_SfSniperTracer(vecStart, vDest,5.0)
		else Stock_UserTracer ( vecStart, vDest, 3,3, 10 )
	}
	else if((c_special[g_weapon[id][0]] == SPECIAL_INFINITY || c_special[g_weapon[id][0]] == SPECIAL_SKULL1) && pev(id,pev_button) & IN_ATTACK2)
	{
		engfunc(EngFunc_PlaybackEvent, FEV_GLOBAL , id, iEvent, iDelay, vecOrigin, vecAngle, flParam1 , flParam2, iParam1, iParam2, bParam1, bParam2)
		return FMRES_SUPERCEDE
	}
	return FMRES_IGNORED
}
public Forward_ClientCommand(id)
{
	new iDouble
	if(!is_user_alive(id)) return FMRES_IGNORED
	new sCmd[32]
	read_argv(0,sCmd,31)
	
	new a = 0 
	do {
		if (equali(g_Aliases[a], sCmd) || equali(g_Aliases2[a], sCmd))
		{ 
			return PLUGIN_HANDLED 
		}
	}  while(++a < MAXMENUPOS)
	
	if(equal(sCmd,"weapon_",7))
	{
		for(new i=1;i<=CSW_P90;i++)
		{
			if(equal(sCmd,WEAPON_NAME[i]))
			return FMRES_IGNORED
		}
		
		if(equal(sCmd[strlen(sCmd)-2], "_2")) iDouble = 1
		replace(sCmd,31,"weapon_","")
		replace(sCmd,31,"_2","")
		
		for(new i=1;i<=sizeof(c_model)-1;i++)
		{
			if(equal(sCmd,c_model[i]))
			{
				if(!iDouble) client_cmd(id,WEAPON_NAME[c_wpnchange[i]])
				else client_cmd(id,WEAPON_NAME[c_d_cswpn[i]])
				return FMRES_SUPERCEDE						
			}
		}
	}
	return FMRES_IGNORED
}
public Forward_EmitSound(id,channel,sample[],Float:volume,Float:attenuation,flags,pitch)
{
	static iCswpn
	if (!is_user_connected(id)) return FMRES_IGNORED
	iCswpn = get_user_weapon(id)
	if (iCswpn == CSW_KNIFE)
	{
		static szNew[64]
		if(sample[13] == '_' && sample[14] == 's' && sample[15] == 'l' && sample[16] == 'a' ) copy(szNew, 63, c_sound_miss[g_weapon[id][0]])
		else if(sample[13] == '_' && sample[14] == 'h' && sample[15] == 'i' && sample[16] == 't' && sample[17] != 'w') copy(szNew, 63, c_sound_hit[g_weapon[id][0]])
		else if(sample[13] == '_' && sample[14] == 'h' && sample[15] == 'i' && sample[16] == 't' && sample[17] == 'w') copy(szNew, 63, c_sound_hitwall[g_weapon[id][0]])
		else if(sample[13] == '_' && sample[14] == 's' && sample[15] == 't' && sample[16] == 'a' ) copy(szNew, 63, c_sound_stab[g_weapon[id][0]])
		else 
		{
			return FMRES_IGNORED
		}
		if (strlen(szNew)) emit_sound(id,channel,szNew,volume,attenuation,flags,pitch)
		return FMRES_SUPERCEDE
	}
	return FMRES_IGNORED;
}
public Forward_SetModel(iEnt,const szModel[])
{
	static iCswpn,iWpnEnt,iSlot,id,iLen
	iLen = strlen(szModel)
	if (iLen < 8) return FMRES_IGNORED
	// Fix Map Weapon Precache
	if(g_iBlockSetModel)
	{
		if(szModel[7] == 'w' && szModel[8] == '_')
		{
			engfunc(EngFunc_RemoveEntity,iEnt)
			return FMRES_SUPERCEDE
		}
	}
	
	if(szModel[7] == 'p' && szModel[8] == 'l' && szModel[8] == 'a' && szModel[8] == 'y') return FMRES_IGNORED
	else if( (szModel[8] == '_' && szModel[9] == 'h' && szModel[10] == 'e')) // grenade
	{
		id = pev(iEnt, pev_owner)
		g_lasthe[id] = g_weapon[id][4]
		engfunc(EngFunc_SetModel, iEnt, c_model_w[g_weapon[id][4]])
		set_pev(iEnt,pev_body,c_w_body[g_weapon[id][4]])
		Set_Wpn_Data(iEnt,DEF_ID,g_weapon[id][4])
		Set_Wpn_Data(iEnt,DEF_OWNER,id)
		Stock_Reset_Wpn_Slot(id,4)
		return FMRES_SUPERCEDE
	}	
	//models/shield/p_shield_
	else if( iLen>26 && szModel[7] == 's' &&szModel[8] == 'h' &&szModel[9] == 'i' &&szModel[10] == 'e')
	{
		engfunc(EngFunc_RemoveEntity,iEnt)
		return FMRES_SUPERCEDE
	}
	//models/w_weaponbox.mdl
	else if(iLen>15 && szModel[7] == 'w' &&szModel[15] == 'b' &&szModel[16] == 'o' &&szModel[17] == 'x')
	{
		Set_Wpn_Data(iEnt,DEF_ISWEAPONBOX,1)
		return FMRES_IGNORED
	}
	else if(iLen>11 && szModel[7] == 'w' &&szModel[8] == '_' &&szModel[9] == 'c' &&szModel[10] == '4')
	{
		return FMRES_IGNORED
	}
	/*models/grenade.mdl
	else if(iLen>10 && szModel[7] == 'g' &&szModel[8] == 'r' &&szModel[9] == 'e' &&szModel[10] == 'n')
	{
		return FMRES_SUPERCEDE
	}*/
	//models/w_
	else if(szModel[7] != 'w' || szModel[8] != '_') 
	{
		Util_Log("SetModel Skip:%s",szModel)
		return FMRES_IGNORED
	}
	if(get_pdata_int(iEnt,m_iDefaultAmmo,4))
	{
		return FMRES_SUPERCEDE
	}
	if(Get_Wpn_Data(iEnt,DEF_ISWEAPONBOX)) // weaponbox entity
	{
		id = pev(iEnt, pev_owner)	
		for(new i=0;i<6;i++)
		{
			iWpnEnt = get_pdata_cbase(iEnt,m_rgpWeaponBoxPlayerItems+i,4)
			if(iWpnEnt>0)
			{				
				iCswpn = get_pdata_int(iWpnEnt,m_iId,4)
				if(CSWPN_NOTREMOVE & (1<<iCswpn)) return FMRES_IGNORED	
				
				// Double Check!
				if(c_type[g_weapon[id][iSlot]] == WEAPONS_DOUBLE)
				{
					static pNext
					pNext = get_pdata_cbase(id,m_rgpPlayerItems+1,5)
					if(pNext>1)
					{
						// Kill This Item
						static iWpn2
						iWpn2 = get_pdata_int(pNext,m_iId,4)
						set_pev(id,pev_weapons,pev(id,pev_weapons)&~(1<<iWpn2))
						Stock_Kill_Item(id,pNext)
					}
				}
				iSlot = ExecuteHam(Ham_Item_ItemSlot,iWpnEnt)
				Set_Wpn_Data(iWpnEnt,DEF_ID,g_weapon[id][iSlot])
				Set_Wpn_Data(iWpnEnt,DEF_SPAWN,1)
				Set_Wpn_Data(iWpnEnt,DEF_AMMO,g_user_ammo[id][iSlot])
				Set_Wpn_Data(iWpnEnt,DEF_ISDROPPED,1)
				//if(c_type[g_weapon[id][iSlot]] == WEAPONS_DOUBLE) Set_Wpn_Data(iWpnEnt,DEF_CLIP,g_user_clip[id][iSlot])
				engfunc(EngFunc_SetModel, iEnt, c_model_w[g_weapon[id][iSlot]])
				set_pev(iEnt,pev_body,c_w_body[g_weapon[id][iSlot]])
				Stock_Reset_Wpn_Slot(id,iSlot)
				
				if(g_c_fWeaponLastTime>0.1) set_pev(iEnt,pev_nextthink,get_gametime()+g_c_fWeaponLastTime)
				return FMRES_SUPERCEDE		
			}
		}		
	}
	return FMRES_SUPERCEDE // May be occur a BUG?
}

public Forward_PrecaceResource(sResource[])
{			
	for (new i = 0; i < g_iBlockNums; i++)
	{
		if (equal(g_sBlockResource[i], sResource))
		{
			return FMRES_SUPERCEDE
		}
	}
			
	return FMRES_IGNORED
}
public Forward_PrecacheEvent(type, const name[]) 
{
	return FMRES_IGNORED
}