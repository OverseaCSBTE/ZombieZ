// [BTE Public FUNCTION]
public Pub_Shake(id)
{
	if(!c_shake[g_weapon[id][0]]) return
	if(c_special[g_weapon[id][0]] == SPECIAL_SKULL1 && pev(id,pev_button) & IN_ATTACK) return
	if(c_type[g_weapon[id][0]] == WEAPONS_M134)
	{
		if(g_shoottimes[id]>8)
		{
			static iTarget
			iTarget = max(c_shake[g_weapon[id][0]],g_shoottimes[id]/3)
			message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, id)
			write_short((1<<12)*c_shake[g_weapon[id][0]]) 
			write_short((1<<12)*1) 
			write_short((1<<12)*c_shake[g_weapon[id][0]]) 
			message_end()
		}
		else return 
	}
	else
	{
		message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, id)
		write_short((1<<12)*c_shake[g_weapon[id][0]]) 
		write_short((1<<12)*1) 
		write_short((1<<12)*c_shake[g_weapon[id][0]]) 
		message_end()
	}
}
public Pub_Buy_Named_Wpn(id,sName[])
{
	for(new i=1;i<=sizeof(c_model)-1;i++)
	{
		if(equal(sName,c_model[i]))
		{
			if(g_mywpn_enable)
			{
				if(Stock_Mywpn_Check_Cached(sName,1))
				{
					Pub_Give_Wpn_Check(id,i)
				}
				else if(Stock_Mywpn_Check_Cached(sName,2))
				{
					Pub_Give_Wpn_Check(id,i)
				}
				else if(Stock_Mywpn_Check_Cached(sName,3))
				{
					Pub_Give_Wpn_Check(id,i)
				}
				else if(Stock_Mywpn_Check_Cached(sName,4))
				{
					Pub_Give_Wpn_Check(id,i)
				}
				else return 0
					
			}
			else Pub_Give_Wpn_Check(id,i)
			return 1
		}
	}
	Util_Log("Failed to give weapon: %s",sName)
	return 0
}
public PlaySeqence(id,iSeq)
{
	if(!c_seq[g_weapon[id][0]]) return
	if(!is_user_alive(id)) return
	new iDuck , iOffset
	if(pev(id,pev_flags)&FL_DUCKING) iDuck = 1
	
	if(c_special[g_weapon[id][0]] == SPECIAL_M79 || c_special[g_weapon[id][0]] == SPECIAL_FIRECRAKER)
	{
		InitiateSequence(id,19)
		return
	}
	if(c_special[g_weapon[id][0]] == SPECIAL_SKULL3 && get_user_weapon(id) == c_d_cswpn[g_weapon[id][0]] && iSeq!=26 && iSeq !=29)
	{
		iSeq +=13				
	}
	if(get_user_weapon(id) == 29) iOffset = -2
	else if(c_special[g_weapon[id][0]] == SPECIAL_INFINITY|| (c_special[g_weapon[id][0]] == SPECIAL_SKULL3 && get_user_weapon(id) == c_d_cswpn[g_weapon[id][0]])) iOffset =-4
	else iOffset =-3
	if(!iDuck)
	{
		InitiateSequence(id,iSeq)
	}
	else InitiateSequence(id,iSeq+iOffset)
	
}
InitiateSequence ( const player, const sequence )
{
	if(!is_user_alive(player)) return
	static iDuck
	if(pev(player,pev_flags) & FL_DUCKING)
	{
		iDuck = 1
	}
	else iDuck = 0
	if(bte_get_user_zombie(player)) set_pev(player,pev_gaitsequence,iDuck?2:1)
	set_pev( player, pev_sequence, sequence );
	set_pev( player, pev_frame, 0 );
	set_pev( player, pev_framerate, 1.0); 

	OrpheuCall( handleResetSequenceInfo, player );
}
public OrpheuHookReturn:Orpheu_SetAnimation ( const id, const Anim )
{
	if(!is_user_alive(id)) return OrpheuIgnored
	if(!c_seq[g_weapon[id][0]]) return OrpheuIgnored
	
	set_pev( id, pev_gaitsequence, Pub_Get_GaitSeq(id));

	return OrpheuSupercede;
}
public Pub_Get_GaitSeq(id)
{
	static iFlag,Float:vVel[3],Float:fSpeed
	iFlag = pev(id,pev_flags)
	pev(id,pev_velocity,vVel)
	fSpeed = vector_length(vVel)
	if(pev(id,pev_waterlevel)>1)
	{
		if ( fSpeed <= 0.1 )
		{
			return 9
		}
		else return 8
	}		
	if(pev(id,pev_movetype) == MOVETYPE_FLY)
	{
		if(iFlag & FL_DUCKING) return 2
		else return 1
	}
	if(iFlag & FL_DUCKING)
	{
		if(fSpeed <=0.1)
		{
			return 2
		}
		else return 5
	}
	else if(!(iFlag & FL_ONGROUND)) return 6
	else if(fSpeed > 0) return 4
	else return 1
}
public Pub_Grenade_Explode(iEnt,iKnockBack)
{	
	static iAttacker ,iIdwpn
	iAttacker= pev(iEnt, pev_owner)
	iIdwpn =  Get_Ent_Data(iEnt,DEF_ENTID)
	
	static Float:vEntOrigin[3], Float:fDistance, Float:fDamage, Float:fNadeDmg, Float:fRadius, Float:vOrigin[3]
	fNadeDmg = c_l_damage[iIdwpn]
	fRadius = c_l_radius[iIdwpn]
	pev(iEnt, pev_origin, vEntOrigin)
	vEntOrigin[2] += 1.0
	
	//  TE_MESSAGE
	message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
	write_byte(TE_WORLDDECAL)
	write_coord_f(vEntOrigin[0])
	write_coord_f(vEntOrigin[1])
	write_coord_f(vEntOrigin[2])
	write_byte(random_num(46,48))
	message_end()
	
	new iVictim = -1
	while ((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vEntOrigin, fRadius)) != 0)
	{
		if (!pev_valid(iVictim)) continue;
		
		pev(iVictim, pev_origin, vOrigin)
		fDistance = get_distance_f(vOrigin, vEntOrigin)
		if(fDistance>fRadius) continue
		fDamage = fNadeDmg - floatmul(fNadeDmg, floatdiv(fDistance, fRadius))
		fDamage *= Stock_Adjust_Damage(vEntOrigin, iVictim, 0) //adjust
		
		if(fDamage<1.0) fDamage = 1.0
		if(iKnockBack && iVictim>0 && iVictim <33 && iVictim!=iAttacker)
		{
			// create effect
			new Float:old_velocity[3], Float:velocity[3]
			new Float:fForce = (1.0 - fDistance / fRadius ) * float(c_knockback[iIdwpn])
			Stock_Get_Speed_Vector(vEntOrigin, vOrigin, fForce, velocity);
			pev(iVictim, pev_velocity, old_velocity)
			xs_vec_add(velocity, old_velocity, velocity)
			set_pev(iVictim, pev_velocity, velocity)
		}
		if(iVictim!=iAttacker) 
		{
			Pub_Fake_Damage_Guns(iAttacker,iVictim,fDamage,FAKE_TYPE_GENER_HEAD,9999.0,iEnt)
		}
	}
	
	if(c_special[iIdwpn] == SPECIAL_FIRECRAKER)
	{
		static Float:vColor[3][3]
		vColor[0][0] = vColor[0][1]= 255.0
		vColor[0][2] = 0
		vColor[1][0] = vColor[1][1] = vColor[1][2] = 100.0
		vColor[2][0] = 50.0
		vColor[2][1] = 200.0
		vColor[2][2] = 50.0
		
		for(new i = 0;i<3;i++)
		{
			static Float:vOrigin[3]	
			vOrigin[0] = vEntOrigin[0] + random_float(-100.0,100.0)
			vOrigin[1] = vEntOrigin[1] + random_float(-100.0,100.0)
			vOrigin[2] = vEntOrigin[2] + random_float(20.0,150.0)
			Stock_FireCracker_Effect(vOrigin,vColor[i])
		}	
		message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
		write_byte(TE_EXPLOSION)
		write_coord(floatround(vEntOrigin[0]))
		write_coord(floatround(vEntOrigin[1]))
		write_coord(floatround(vEntOrigin[2]))
		write_short(g_cache_firecraker_exp)
		write_byte(20)
		write_byte(30)
		write_byte(TE_EXPLFLAG_NONE)
		message_end()
	}
	else
	{
		message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
		write_byte(TE_EXPLOSION)
		write_coord(floatround(vEntOrigin[0]))
		write_coord(floatround(vEntOrigin[1]))
		write_coord(floatround(vEntOrigin[2]))
		write_short(g_cache_explo)
		write_byte(20)
		write_byte(30)
		write_byte(0)
		message_end()
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(5)
		write_coord(floatround(vEntOrigin[0]))
		write_coord(floatround(vEntOrigin[1]))
		write_coord(floatround(vEntOrigin[2]))
		write_short(g_cache_smoke)
		write_byte(35)
		write_byte(5)
		message_end()
	}
}
public Pub_Set_Zoom(id,iIdwpn)
{
	static iZoom 
	iZoom = c_zoom[iIdwpn]
	//Check Can Zoom
	if (!g_double[id][0] && !iZoom) return
	if(g_double[id][0] && !c_d_zoom[iIdwpn]) return
	if(!iZoom) return
	if(get_pdata_float(id, m_flNextAttack, 5) > 0.0) return	
	
	if(CSWPN_SNIPER & (1<<c_wpnchange[iIdwpn])) return
	if(CSWPN_FIRSTZOOM & (1<<c_wpnchange[iIdwpn])) return
	//
	if (iZoom == ZOOMTYPE_AUG)
	{
		if(g_zoom[id] == 1) Pub_Reset_Zoom(id)
		else
		{
			cs_set_user_zoom(id, CS_SET_AUGSG552_ZOOM,1)
			g_zoom[id] = 1
			client_cmd(id,"spk weapons/zoom")
		}
	}
	else if(iZoom == ZOOMTYPE_ONCE)
	{
		if(g_zoom[id] == 1) Pub_Reset_Zoom(id)
		else
		{
			cs_set_user_zoom(id, CS_SET_FIRST_ZOOM,1)
			g_zoom[id] = 1
			client_cmd(id,"spk weapons/zoom")
		}
	}
	else if(iZoom == ZOOMTYPE_SNIPER)
	{
		new iZoomType = cs_get_user_zoom(id)
		g_zoom[id] = 1
		switch (iZoomType)
		{
			case CS_SET_FIRST_ZOOM:
			{
				client_cmd(id,"spk weapons/zoom")
				cs_set_user_zoom(id, CS_SET_SECOND_ZOOM,1)
			}
			case CS_SET_SECOND_ZOOM:
			{
				cs_set_user_zoom( id, CS_RESET_ZOOM,1)
				g_zoom[id] = 0
			}
			case CS_RESET_ZOOM,CS_SET_NO_ZOOM:
			{
				client_cmd(id,"spk weapons/zoom")
				cs_set_user_zoom(id, CS_SET_FIRST_ZOOM,1)
			}
			default : cs_set_user_zoom( id, CS_RESET_ZOOM,1) // May be Bug?
		}	
	}
	// Set Next Scope Time
	set_pdata_float(id, m_flNextAttack, 0.3,5)
}
public Pub_Get_Player_Zoom(id)
{
	static iZoom
	iZoom = get_pdata_int(id,m_iFOV,5)
	return (iZoom < 90)
}
public Pub_Set_MaxSpeed(id,Float:fSpeed)
{
	// Set Gravity
	if(c_special[g_weapon[id][0]] == SPECIAL_HAMMER) 
	{
		if(g_hammer_stat[id])
		{
			g_fPlrMaxspeed[id] = c_gravity[g_weapon[id][0]] - 100.0
		}
		else
		{
			g_fPlrMaxspeed[id] = c_gravity[g_weapon[id][0]]
		}
		ExecuteHamB(Ham_Item_PreFrame,id)
		return
	}
	g_fPlrMaxspeed[id] = fSpeed
	ExecuteHamB(Ham_Item_PreFrame,id)
}
public Pub_Create_P_Model(id,iIdwpn)
{
	if(!is_user_alive(id)) return
	set_pev(id, pev_weaponmodel, 0)
	if(pev_valid(g_p_modelent[id]))
	{
		Stock_Set_Vis(g_p_modelent[id]) 
		engfunc(EngFunc_SetModel, g_p_modelent[id], c_model_p[iIdwpn])
		set_pev(g_p_modelent[id],pev_body,c_p_body[iIdwpn])
		set_pev(g_p_modelent[id] ,pev_sequence,c_p_seq[iIdwpn])
		return
	}	
	new iEnt = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	set_pev(iEnt, pev_classname, "bte_p_model")
	engfunc(EngFunc_SetModel, iEnt, c_model_p[iIdwpn])
	set_pev(iEnt, pev_mins, {-1.0, -1.0, -1.0})
	set_pev(iEnt, pev_maxs, {1.0, 1.0, 1.0})
	set_pev(iEnt, pev_movetype, MOVETYPE_FOLLOW)
	set_pev(iEnt, pev_solid, SOLID_NOT)
	set_pev(iEnt,pev_aiment,id)
	set_pev(iEnt,pev_body,c_p_body[iIdwpn])
	set_pev(iEnt ,pev_sequence,c_p_seq[iIdwpn])	
	g_p_modelent[id] = iEnt
}
public Pub_Give_Wpn_Check(id,idwpn)
{
	if (!is_user_alive(id) || !c_wpnchange[idwpn] || !c_buy[idwpn]) return;
	static szMsg[128],iMoney
	
	if(bte_get_user_zombie(id)) return
	if(!g_buyzone[id] && get_pcvar_num(cvar_freebuyzone))
	{
		format(szMsg,127,"%L",LANG_PLAYER,"BTE_WPN_NOTICE_NOT_IN_BUYZONE")
		client_print(id,print_chat,szMsg)
		return
	}
	// Check Mod Buy
	if(c_buymod[idwpn])
	{
		if( !(c_buymod[idwpn] & (1<<g_modruning)))
		{
			format(szMsg,127,"%L",LANG_PLAYER,"BTE_WPN_NOTICE_NOT_PROPER_MODE")
			client_print(id,print_chat,szMsg)
			return
		}
	}			
	iMoney = cs_get_user_money(id)-c_cost[idwpn]
	if(iMoney<0 && !get_pcvar_num(cvar_freebuy))
	{
		format(szMsg,127,"%L",LANG_PLAYER,"BTE_WPN_NOTICE_NOT_ENOUGH_MONEY")
		client_print(id,print_chat,szMsg)
		return
	}
	if(iMoney && !get_pcvar_num(cvar_freebuy)) cs_set_user_money(id,iMoney,1)
	
	Pub_Give_Idwpn(id, idwpn,0)
}
public Pub_Give_Idwpn(id,idwpn,iType)
{
	if (!c_wpnchange[idwpn]) return;
	static szMsg[128],iCswpn,iSlot
	
	if(iType)
	{
		new iMoney = cs_get_user_money(id)-c_cost[idwpn]
		if(iMoney<0 && !get_pcvar_num(cvar_freebuy))
		{
			return
		}
	}
	
	if (!is_user_alive(id))
	{
		format(szMsg, charsmax(szMsg), "%L", LANG_PLAYER, "BTE_WPN_NOTICE_NOT_ALIVE")
		client_print(id,print_chat,szMsg)
		return;
	}
	if (bte_get_user_zombie(id) && !iType)
	{
		format(szMsg, charsmax(szMsg), "%L", LANG_PLAYER, "BTE_WPN_NOTICE_NOT_HUMAN")
		client_print(id,print_chat,szMsg)
		return;
	}
	if(bte_wpn_get_mod_running() == BTE_MOD_ZB1 && !bte_get_user_zombie(id) && iType != 1)
	{
		if(g_modbuylimit[id][c_slot[idwpn]])
		{
			format(szMsg, charsmax(szMsg), "%L", LANG_PLAYER, "BTE_WPN_NOTICE_MOD_BUYTIMES_LIMIT")
			client_print(id,print_chat,szMsg)
			return
		}
		g_modbuylimit[id][c_slot[idwpn]] = 1
	}
	if(!bte_get_user_zombie(id) && !iType) g_save_guns[id][c_slot[idwpn]] = idwpn // save
	
	Stock_Strip_Slot(id,c_slot[idwpn]) // Strip weapon
	
	iCswpn = c_wpnchange[idwpn]
	iSlot = c_slot[idwpn]

	// Set Value	
	g_weapon[id][iSlot] = idwpn
	g_user_ammo[id][iSlot] = c_ammo[idwpn]
	if(c_type[idwpn] == WEAPONS_SVDEX)
	{
		g_svdex_ammo[id] = c_l_nade[idwpn]
		MH_SendZB3Data(id,5,g_svdex_ammo[id])
	}
	
	// Update Pickup & Ammo HUD
	if(c_slot[idwpn] == WPN_KNIFE) Stock_Give_Cswpn(id, WEAPON_NAME[CSW_KNIFE])
	else if(c_slot[idwpn] == WPN_HE)
	{
		Stock_Give_Cswpn(id, WEAPON_NAME[CSW_HEGRENADE])
	}
	else
	{
		Pub_Give_Reset(id,idwpn)
		if(!g_modruning) // None Mode
		{
			g_user_ammo[id][iSlot] = 0
			g_user_clip[id][iSlot] = c_clip[idwpn]
			if(is_user_bot(id)) 
			{
				g_user_ammo[id][iSlot] = c_ammo[idwpn]
			}
			if(c_type[idwpn] == WEAPONS_LAUNCHER)
			{
				if(c_clip[idwpn]) g_user_clip[id][iSlot] = c_clip[idwpn]
				Stock_Give_Cswpn(id, WEAPON_NAME[iCswpn],0,c_l_nade[idwpn])
			}
			else
			{
				Stock_Give_Cswpn(id, WEAPON_NAME[iCswpn])
				if(c_type[idwpn] == WEAPONS_DOUBLE)
				{
					Stock_Give_Cswpn(id, WEAPON_NAME[c_d_cswpn[idwpn]],1)
				}		
			}	
		} 
		else
		{
			g_user_clip[id][iSlot] = c_clip[idwpn]
			new iTimes
			if(c_clip[idwpn])
			{
				iTimes = c_ammo[idwpn]/c_clip[idwpn]
			}
			else iTimes = c_ammo[idwpn]/1
			if(c_type[idwpn] == WEAPONS_LAUNCHER)
			{
				if(c_clip[idwpn]) g_user_clip[id][iSlot] = c_clip[idwpn]
				Stock_Give_Cswpn(id, WEAPON_NAME[iCswpn],0,c_l_nade[idwpn])
			}
			else
			{
				Stock_Give_Cswpn(id, WEAPON_NAME[iCswpn])
				if(c_type[idwpn] == WEAPONS_DOUBLE)
				{
					Stock_Give_Cswpn(id, WEAPON_NAME[c_d_cswpn[idwpn]],1)
				}		
			}
			for(new i=0;i<iTimes;i++)
			{
				message_begin(MSG_ONE_UNRELIABLE, g_msgAmmoPickup, _, id)
				write_byte(WEAPON_AMMOID[c_wpnchange[idwpn]])
				write_byte(c_clip[idwpn])
				message_end()
			}
			g_user_ammo[id][iSlot] = c_ammo[idwpn]
			if(g_modruning == BTE_MOD_ZB1 && c_type[idwpn] != WEAPONS_LAUNCHER)
			{
				static iGiveAmmo
				iGiveAmmo = c_ammo[idwpn]*2
				if(c_ammo[idwpn] > 199) iGiveAmmo = c_ammo[idwpn] 
				g_user_ammo[id][iSlot] = iGiveAmmo		
			}
		}
	}
	// Give Special Ammo
	if(c_special[idwpn] == SPECIAL_MUSKET)
	{
		g_user_ammo[id][iSlot] = c_ammo[idwpn]
	}
	else if(c_type[idwpn] == WEAPONS_LAUNCHER)
	{
		g_user_ammo[id][iSlot] = c_l_nade[idwpn]
	}
}
public Pub_Give_Default_Wpn(id,iType)
{
	if(iType == 1 || iType == 4) return
	if(iType == 3)
	{
		g_weapon[id][3] = 1
		Stock_Give_Cswpn(id, WEAPON_NAME[CSW_KNIFE])
		return
	}
	if(get_user_team(id) == 1)
	{
		g_weapon[id][2] = 2
		g_user_ammo[id][2] = 24
		Stock_Give_Cswpn(id, WEAPON_NAME[CSW_GLOCK18])
	}
	else 
	{
		g_weapon[id][2] = 3
		g_user_ammo[id][2] = 24
		Stock_Give_Cswpn(id, WEAPON_NAME[CSW_USP])
	}
}
public Pub_Init()
{
	register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR)
	register_dictionary("bte_wpn.bte")
	
	get_configsdir(g_szConfigDir, charsmax(g_szConfigDir))
	get_mapname(g_szMapName, charsmax(g_szMapName))
	formatex(g_szLogName, charsmax(g_szLogName),"%s/%s", g_szConfigDir,BTE_LOG_FILE)
	if(file_exists(g_szLogName))
	{
		delete_file(g_szLogName)
		Util_Log("Previous log has been deleted!")
		Util_Log("BTE Weapon Version:2.0 2013-1-25 10:00!")
	}
}
public Pub_ShutDown()
{
	Util_Log("Server Shutdown!")
}
public Pub_Reset_Zoom(id)
{
	g_zoom[id] = 0
	cs_set_user_zoom( id, CS_RESET_ZOOM,1) 
	Pub_Set_MaxSpeed(id,g_double[id][0]?c_d_gravity[g_weapon[id][0]]:c_gravity[g_weapon[id][0]])
}
public Pub_Shotgun_Reload(iEnt, iId, iMaxClip, iClip, iBpAmmo, id)
{
	if(iBpAmmo <= 0 || iClip == iMaxClip)
		return

	if(get_pdata_int(iEnt, m_flNextPrimaryAttack, 4) > 0.0)
		return

	switch( get_pdata_int(iEnt, m_fInSpecialReload, 4) )
	{
		case 0:
		{
			Stock_Send_Anim( id , SHOTGUN_start_reload )
			set_pdata_int(iEnt, m_fInSpecialReload, 1, 4)
			set_pdata_float(id, m_flNextAttack, 0.55, 5)
			set_pdata_float(iEnt, m_flTimeWeaponIdle, 0.55, 4)
			set_pdata_float(iEnt, m_flNextPrimaryAttack, 0.55, 4)
			set_pdata_float(iEnt, m_flNextSecondaryAttack, 0.55, 4)
			return
		}
		case 1:
		{
			if( get_pdata_float(iEnt, m_flTimeWeaponIdle, 4) > 0.0 )
			{
				return
			}
			set_pdata_int(iEnt, m_fInSpecialReload, 2, 4)
			//emit_sound(id, CHAN_ITEM, random_num(0,1) ? "weapons/reload1.wav" : "weapons/reload3.wav", 1.0, ATTN_NORM, 0, 85 + random_num(0,0x1f))
			Stock_Send_Anim( id, SHOTGUN_insert )

			set_pdata_float(iEnt, m_flTimeWeaponIdle, iId == CSW_XM1014 ? 0.30 : 0.45, 4)
		}
		default:
		{
			if( ++iClip == iMaxClip )
			{
				set_pdata_int(id, g_iAmmoOffsets[iId], 0, 4)
			}
			set_pdata_int(iEnt, m_iClip, iClip, 4)
			set_pdata_int(id, 381, iBpAmmo-1, 5)
			set_pdata_int(iEnt, m_fInSpecialReload, 1, 4)
		}
	}
}
 public Pub_Fake_Melee_Attack(iAttacker,Float:fRange,iAngle,iBtn)
{
	new Float:fDmg = 55.0
	new Float:vecOri1[3],Float:vecOri2[3]
	pev(iAttacker,pev_origin,vecOri1)
	if(iAngle>180) //all
	{
		new iVictim = -1
		new iCheck
		while ((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vecOri1, fRange)) != 0)
		{
			if (iAttacker==iVictim || !pev_valid(iVictim)) continue;
			if((!Stock_BTE_CheckAngle(iAttacker,iVictim)>floatcos(float(iAngle),degrees))) continue
			if(!pev(iVictim,pev_takedamage)) continue
			if(pev(iVictim,pev_spawnflags)&SF_BREAK_TRIGGER_ONLY) continue
			
			iCheck++
			
			if(iBtn == 2) fDmg *= c_k_damage2[g_weapon[iAttacker][3]]
		
			Pub_Fake_Damage_Guns(iAttacker,iVictim,fDmg,FAKE_TYPE_GENER_HEAD|FAKE_TYPE_TRACEBLEED|FAKE_TYPE_CHECKDIRECT,fRange)
		}
		if(iCheck) return  FAKE_RESULT_HIT_PLAYER
		else return FAKE_RESULT_HIT_NONE
	}
	else if(0<iAngle<=180/* &&iBtn==FAKE_STAB*/)
	{
		iAngle/=2
		
		new iVictim = -1
		new iCheck
		while ((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vecOri1, fRange)) != 0)
		{
			
			
			if (iAttacker==iVictim || !pev_valid(iVictim)) continue;
			if(!pev(iVictim,pev_takedamage)) continue
			if(!(Stock_BTE_CheckAngle(iAttacker,iVictim)>floatcos(float(iAngle),degrees))) continue
			if(pev(iVictim,pev_spawnflags)&SF_BREAK_TRIGGER_ONLY) continue
			iCheck++
			
			fDmg *= c_k_damage2[g_weapon[iAttacker][3]]
			Pub_Fake_Damage_Guns(iAttacker,iVictim,fDmg,FAKE_TYPE_GENER_HEAD|FAKE_TYPE_TRACEBLEED|FAKE_TYPE_CHECKDIRECT,fRange)
		}
		if(iCheck) return  FAKE_RESULT_HIT_PLAYER
		else return FAKE_RESULT_HIT_NONE
	}
	else //angle=0.0
	{
		new Float:vecStart[3], Float:vecTarget[3],Float:vecViewOfs[3]
		new trRes
		pev(iAttacker, pev_origin, vecStart) 
		pev(iAttacker, pev_view_ofs, vecViewOfs) 
		xs_vec_add(vecStart, vecViewOfs, vecStart) 
			
		new Float:angle[3],Float:Forw[3]
		pev(iAttacker,pev_v_angle,angle)
		engfunc(EngFunc_MakeVectors,angle)
		global_get(glb_v_forward,Forw)
		xs_vec_mul_scalar(Forw,fRange,Forw)
	
		xs_vec_add(vecStart, Forw, vecTarget)
		engfunc(EngFunc_TraceLine, vecStart, vecTarget, 0, iAttacker, trRes)
		new Float:flFraction
		get_tr2(trRes, TR_flFraction, flFraction)
		
		new pHit = get_tr2(trRes, TR_pHit)
		if(pev_valid(pHit))
		{
			if(is_user_alive(pHit))
			{
				new hit=get_tr2(trRes,TR_iHitgroup)
				new Float:dmg = fDmg

				new Float:endPos[3]
				get_tr2(trRes,TR_vecEndPos,endPos)

				set_tr2(trRes, TR_flFraction, get_distance_f(vecStart, vecTarget) / fRange)
				set_pdata_int(pHit,75,get_tr2(trRes,TR_iHitgroup))
								dmg *= Stock_Get_Body_Dmg(hit)
				if(iBtn == 2) dmg *= c_k_damage2[g_weapon[iAttacker][3]]

				ExecuteHamB(Ham_TakeDamage,pHit,iAttacker,iAttacker,dmg,DMG_CLUB)
				
				if(get_user_team(iAttacker) != get_user_team(pHit) || bte_npc_is_npc(pHit)) Stock_BloodEffect(endPos)
				return FAKE_RESULT_HIT_PLAYER
			}
			else
			{
				if(!pev(pHit,pev_takedamage)) return FAKE_RESULT_HIT_WALL
				if(pev(pHit,pev_spawnflags)&SF_BREAK_TRIGGER_ONLY) return FAKE_RESULT_HIT_WALL
				new Float:dmg = 30.0 //=knife_get_damage_attack(hit)
				if(iBtn == 2) dmg *= c_k_damage2[g_weapon[iAttacker][3]]

				ExecuteHamB(Ham_TakeDamage,pHit,iAttacker,iAttacker,dmg,DMG_CLUB)
				return FAKE_RESULT_HIT_WALL
			}
				
		}
		else if(flFraction < 1.0)
		{
			return FAKE_RESULT_HIT_WALL
		}
		else //use tracehull now
		{
			new trRes2
			engfunc(EngFunc_TraceHull, vecStart, vecTarget, 0,HULL_HEAD, iAttacker, trRes2)
			new pHit = get_tr2(trRes2, TR_pHit)
			if(pev_valid(pHit))
			{
				if(is_user_alive(pHit))
				{
					new hit=get_tr2(trRes2,TR_iHitgroup)
					new Float:dmg= fDmg//=knife_get_damage_attack(hit)

					new Float:endPos[3]
					get_tr2(trRes2,TR_vecEndPos,endPos)
					set_tr2(trRes2, TR_flFraction, get_distance_f(vecStart, vecTarget) / fRange)
					set_pdata_int(pHit,75,get_tr2(trRes2,TR_iHitgroup))
					dmg *= Stock_Get_Body_Dmg(hit)
					if(iBtn == 2) dmg *= c_k_damage2[g_weapon[iAttacker][3]]
					
					ExecuteHamB(Ham_TakeDamage,pHit,iAttacker,iAttacker,dmg,DMG_CLUB)
					
					if(get_user_team(iAttacker) != get_user_team(pHit) || bte_npc_is_npc(pHit)) Stock_BloodEffect(endPos)
					return FAKE_RESULT_HIT_PLAYER
				}
				else
				{
					if(!pev(pHit,pev_takedamage)) return FAKE_RESULT_HIT_WALL
					if(pev(pHit,pev_spawnflags)&SF_BREAK_TRIGGER_ONLY) return FAKE_RESULT_HIT_WALL
					new Float:dmg = fDmg //=knife_get_damage_attack(hit)
					if(iBtn == 2) dmg *= c_k_damage2[g_weapon[iAttacker][3]]

					ExecuteHamB(Ham_TakeDamage,pHit,iAttacker,iAttacker,dmg,DMG_CLUB)
					return FAKE_RESULT_HIT_WALL
				}
			}
			else
			{
				get_tr2(trRes2, TR_flFraction, flFraction)
				if(flFraction < 1.0)
				{
					return FAKE_RESULT_HIT_WALL
				}
				else
				{
					return FAKE_RESULT_HIT_NONE
				}
			}
		}
	}
}
public Pub_Fake_Melee_Attack2(iAttacker,Float:fRange,Float:fDamage)
{
	new Float:fDmg = fDamage
	new Float:vecOri1[3],Float:vecOri2[3]
	pev(iAttacker,pev_origin,vecOri1)

	new Float:vecStart[3], Float:vecTarget[3],Float:vecViewOfs[3]
	new trRes
	pev(iAttacker, pev_origin, vecStart) 
	pev(iAttacker, pev_view_ofs, vecViewOfs) 
	xs_vec_add(vecStart, vecViewOfs, vecStart) 
			
	new Float:angle[3],Float:Forw[3]
	pev(iAttacker,pev_v_angle,angle)
	engfunc(EngFunc_MakeVectors,angle)
	global_get(glb_v_forward,Forw)
	xs_vec_mul_scalar(Forw,fRange,Forw)
	
	xs_vec_add(vecStart, Forw, vecTarget)
	engfunc(EngFunc_TraceLine, vecStart, vecTarget, 0, iAttacker, trRes)
	new Float:flFraction
	get_tr2(trRes, TR_flFraction, flFraction)
		
	new pHit = get_tr2(trRes, TR_pHit)
	if(pev_valid(pHit))
	{
		if(is_user_alive(pHit))
		{
			new hit=get_tr2(trRes,TR_iHitgroup)
			new Float:dmg = fDmg
			new Float:endPos[3]
			get_tr2(trRes,TR_vecEndPos,endPos)
			set_tr2(trRes, TR_flFraction, get_distance_f(vecStart, vecTarget) / fRange)
			set_pdata_int(pHit,75,get_tr2(trRes,TR_iHitgroup))
			dmg *= Stock_Get_Body_Dmg(hit)
			ExecuteHamB(Ham_TakeDamage,pHit,iAttacker,iAttacker,dmg,DMG_CLUB)
			if(get_user_team(iAttacker) != get_user_team(pHit) || bte_npc_is_npc(pHit)) Stock_BloodEffect(endPos)
			return FAKE_RESULT_HIT_PLAYER
		}
		else
		{
			if(!pev(pHit,pev_takedamage)) return FAKE_RESULT_HIT_WALL
			if(pev(pHit,pev_spawnflags)&SF_BREAK_TRIGGER_ONLY) return FAKE_RESULT_HIT_WALL
			new Float:dmg = 30.0
			ExecuteHamB(Ham_TakeDamage,pHit,iAttacker,iAttacker,dmg,DMG_CLUB)
			return FAKE_RESULT_HIT_WALL
		}	
	}
	else if(flFraction < 1.0)
	{
		return FAKE_RESULT_HIT_WALL
	}
	else //use tracehull now
	{
		new trRes2
		engfunc(EngFunc_TraceHull, vecStart, vecTarget, 0,HULL_HEAD, iAttacker, trRes2)
		new pHit = get_tr2(trRes2, TR_pHit)
		if(pev_valid(pHit))
		{
			if(is_user_alive(pHit))
			{
				new hit=get_tr2(trRes2,TR_iHitgroup)
				new Float:dmg= fDmg
				new Float:endPos[3]
				get_tr2(trRes2,TR_vecEndPos,endPos)
				set_tr2(trRes2, TR_flFraction, get_distance_f(vecStart, vecTarget) / fRange)
				set_pdata_int(pHit,75,get_tr2(trRes2,TR_iHitgroup))
				dmg *= Stock_Get_Body_Dmg(hit)
				ExecuteHamB(Ham_TakeDamage,pHit,iAttacker,iAttacker,dmg,DMG_CLUB)
				
				if(get_user_team(iAttacker) != get_user_team(pHit) || bte_npc_is_npc(pHit)) Stock_BloodEffect(endPos)
				return FAKE_RESULT_HIT_PLAYER
			}
			else
			{
				if(!pev(pHit,pev_takedamage)) return FAKE_RESULT_HIT_WALL
				if(pev(pHit,pev_spawnflags)&SF_BREAK_TRIGGER_ONLY) return FAKE_RESULT_HIT_WALL
				new Float:dmg = fDmg
				ExecuteHamB(Ham_TakeDamage,pHit,iAttacker,iAttacker,dmg,DMG_CLUB)
				return FAKE_RESULT_HIT_WALL
			}
		}
		else
		{
			get_tr2(trRes2, TR_flFraction, flFraction)
				if(flFraction < 1.0)
			{
				return FAKE_RESULT_HIT_WALL
			}
			else
			{
				return FAKE_RESULT_HIT_NONE
			}
		}
	}
}
public Pub_Give_Named_Wpn(id,sName[],iType)
{
	for(new i=1;i<=sizeof(c_model)-1;i++)
	{
		if(equal(sName,c_model[i]))
		{
			if(g_mywpn_enable)
			{
				if(Stock_Mywpn_Check_Cached(sName,1))
				{
					Pub_Give_Idwpn(id, i,iType)
				}
				else if(Stock_Mywpn_Check_Cached(sName,2))
				{
					Pub_Give_Idwpn(id, i,iType)
				}
				else if(Stock_Mywpn_Check_Cached(sName,3))
				{
					Pub_Give_Idwpn(id, i,iType)
				}
				else if(Stock_Mywpn_Check_Cached(sName,4))
				{
					Pub_Give_Idwpn(id, i,iType)
				}
				else if(Stock_Mywpn_Check_Cached(sName,5))
				{
					Pub_Give_Idwpn(id, i,iType)
				}					
			}
			else Pub_Give_Idwpn(id, i,iType)
			return 1
		}
	}
	Util_Log("FAILED Give %d : %s",id,sName)
	return 0
}
public Pub_DeploySet(iEnt,id,iCswpn)
{
	if(c_special[g_weapon[id][0]] == SPECIAL_M79 || c_special[g_weapon[id][0]] == SPECIAL_FIRECRAKER)
	{
		Stock_Send_Hide_Msg(id,1)
		Stock_Send_WeaponID_Msg(id,CSW_KNIFE,-1)
		if(MH_IsMetaHookPlayer(id)) 
		{
			MH_DrawHolesImage(id,0,1,"scope_svdex",0.5,0.55,255,255,255,0,300.0,CHANNEL_SVDEX,-1)
			MH_DrawExtraAmmo(id,WEAPON_AMMOID[c_wpnchange[g_weapon[id][0]]])
		}
	}
	else if(c_type[g_weapon[id][0]] == WEAPONS_SVDEX)
	{
		MH_SendZB3Data(id,5,g_svdex_ammo[id])
	}
	else if(c_type[g_weapon[id][0]] ==WEAPONS_M32 )
	{
		Stock_Send_Hide_Msg(id,1)
		if(MH_IsMetaHookPlayer(id)) 
		{
			MH_DrawHolesImage(id,0,1,"scope_svdex",0.5,0.55,255,255,255,0,300.0,CHANNEL_SVDEX,-1)
		}
		Stock_Send_Anim(id,6)
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_MUSKET)
	{
		Stock_Send_WeaponID_Msg(id,CSW_KNIFE,-1)
		g_musket_timer[id] = get_gametime() + 1.0
		g_musket_stat[id] = MUSKET_IDLE
		MH_DrawExtraAmmo(id,WEAPON_AMMOID[c_wpnchange[g_weapon[id][0]]])
	}
	// Set Special Draw Animation
	else if(c_special[g_weapon[id][0]] == SPECIAL_SFMG)
	{
		Stock_Send_Anim(id,g_sfmg_stat[id]?10:4)
		MH_SpecialEvent(id,6+g_sfmg_stat[id])
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_SFSNIPER)
	{
		Stock_Send_Anim(id,2)
	}	
	else if(c_type[g_weapon[id][0]] == WEAPONS_M32 )
	{
		Stock_Send_Hide_Msg(id,1)
		if(MH_IsMetaHookPlayer(id)) 
		{
			MH_DrawHolesImage(id,0,1,"scope_svdex",0.5,0.55,255,255,255,0,300.0,CHANNEL_SVDEX,-1)
		}
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_CATAPULT)
	{
		new iClip3 = get_pdata_int(iEnt, m_iClip, 4)
		if(iClip3) Stock_Send_Anim(id,6)
		else Stock_Send_Anim(id,7)
		Stock_Send_WeaponID_Msg(id,CSW_KNIFE,-1)
		MH_DrawExtraAmmo(id,WEAPON_AMMOID[c_wpnchange[g_weapon[id][0]]])
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_CANNON)
	{
		Stock_Send_WeaponID_Msg(id,CSW_KNIFE,-1)
		MH_DrawExtraAmmo(id,WEAPON_AMMOID[c_wpnchange[g_weapon[id][0]]])
		if(g_cannon_timer[id] < get_gametime()) g_cannon_timer[id] = get_gametime() +c_deploy[g_weapon[id][0]]
	}
	else
	{
		Stock_Send_Hide_Msg(id,0)
	}
}
public Pub_Deploy_Reset(iEnt,id,iCswpn)
{
	MH_DrawHolesImage(id,0,1,"scope_svdex",0.5,0.55,255,255,255,0,0,CHANNEL_SVDEX,-1)
	g_wpn_flame_isshooting[id] = 0
	g_svdex_stat[id] = 0
	Stock_Send_Hide_Msg(id,0)
}
public Pub_Killed_Reset(id)
{
	
}
public Pub_DisConnectReset(id)
{
	Stock_Reset_Wpn_Slot(id,0)
	Stock_Reset_Wpn_Slot(id,1)
	Stock_Reset_Wpn_Slot(id,2)
	Stock_Reset_Wpn_Slot(id,3)
	Stock_Reset_Wpn_Slot(id,4)
}
public Pub_Give_Reset(id,idwpn)
{
	if(c_slot[idwpn] == 1)
	{
		g_double[id][c_slot[idwpn]] = 0
		g_sfmg_stat[id] = 0
		MH_SpecialEvent(id,6+g_sfmg_stat[id])
	}
}
public Pub_Holster_Reset(id,iEnt)
{
	Task_Reset(id)
	g_dchanging[id] = 0
	if(iEnt>1) set_pdata_float(iEnt,m_flFamasShoot,0)
	g_wpn_m134_stat[id] = M134_IDLE
	g_wpn_m134_timer[id] = 0
	g_infinity_shoot[id] = 0
	g_infinity_shoottimer[id] = 0
	g_dt_level[id] = 0
	g_musket_stat[id] = MUSKET_IDLE
	g_cp_stat[id] = MUSKET_IDLE
	g_m32_reload[id] =0
	/*if(g_dchanging[id] && iEnt)
	{
		static iSlot
		iSlot = ExecuteHam(Ham_Item_ItemSlot,iEnt)
		 g_double_save_clip[id]g_user_clip[iSlot][id]
		g_user_ammo[iSlot][id] = g_double_save_ammo[id]
		g_double_save_clip[id] = g_double_save_ammo[id] = 0
	}*/
	g_dchanging[id] = 0
}