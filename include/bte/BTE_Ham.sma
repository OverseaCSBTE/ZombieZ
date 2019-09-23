// [BTE Hamsandwich FORWARD FUNCTION]
#define DMG_HE (1<<24)
#define ITEM_FLAG_SELECTONEMPTY       1
#define ITEM_FLAG_NOAUTORELOAD        2
#define ITEM_FLAG_NOAUTOSWITCHEMPTY   4
#define ITEM_FLAG_LIMITINWORLD        8
#define ITEM_FLAG_EXHAUSTIBLE        16
public HamF_Weapon_Secondary_Post(iEnt)
{
	static id
	id = get_pdata_cbase(iEnt,m_pPlayer,4)
	if(c_k_speed2[g_weapon[id][0]])
	{
		set_pdata_float(iEnt, m_flNextPrimaryAttack, c_k_speed2[g_weapon[id][0]], 4)
		set_pdata_float(iEnt, m_flNextSecondaryAttack, c_k_speed2[g_weapon[id][0]], 4)
		set_pdata_float(iEnt, m_flTimeWeaponIdle, c_k_speed1[g_weapon[id][0]], 4)
	}
	set_pdata_float(iEnt, m_flTimeWeaponIdle, 3.0, 4)
	// Play Sequence
	PlaySeqence(id,c_seq[g_weapon[id][0]]+1)
	return HAM_IGNORED
}
public HamF_InfoTarget_Think(iEnt)
{
	static iEntClass,iIdwpn,Float:fFrame,Float:fScale
	iEntClass = Get_Ent_Data(iEnt,DEF_ENTCLASS)
	iIdwpn = Get_Ent_Data(iEnt,DEF_ENTID)
	if(iEntClass == ENTCLASS_KILLME)
	{
		engfunc(EngFunc_RemoveEntity,iEnt)
	}
	
	if(c_special[iIdwpn] == SPECIAL_FIRECRAKER)
	{
		Pub_Grenade_Explode(iEnt,0)
		engfunc(EngFunc_RemoveEntity,iEnt)
		return
	}
	else if(iEntClass == ENTCLASS_FLAME)
	{
		static isPoison,Float:fFrameMax
		fFrameMax = c_special[iIdwpn] == SPECIAL_POISON?g_cache_frame_poison:g_cache_frame_flame
		pev(iEnt,pev_frame,fFrame)
		pev(iEnt,pev_scale,fScale)
		//Touch something
		if(Get_Ent_Data(iEnt,DEF_ENTSTAT))
		{
			set_pev(iEnt,pev_velocity,g_vNull)
			fFrame+=(fFrameMax/22.0)
			fScale+=(fFrameMax/220.0)
		}
		else //not touch
		{
			if(fFrame > (fFrameMax/3.0))
			{
				fFrame+=(fFrameMax/22.0)
				fScale+=(fFrameMax/220.0)
			}
			else
			{
				fFrame+=(fFrameMax/44.0)
				fScale+=(fFrameMax/440.0)
				
			}
		}
		if(fFrame>=fFrameMax) 
		{
			engfunc(EngFunc_RemoveEntity,iEnt)
			return
		}
		set_pev(iEnt,pev_frame,fFrame)
		set_pev(iEnt,pev_scale,fScale)
		set_pev(iEnt,pev_nextthink,get_gametime()+0.05)
		return
	}
	else if(iEntClass == ENTCLASS_BOLT)
	{
		static Float:vAngle[3]
		Stock_Get_Velocity_Angle(iEnt,vAngle)
		set_pev(iEnt,pev_angles,vAngle)
		set_pev(iEnt,pev_nextthink,get_gametime()+0.03)
	}
	else if(iEntClass == ENTCLASS_NADE)
	{
		if(Get_Ent_Data(iEnt,DEF_ENTSTAT)) // AT4CS
		{
			static iTarget
			iTarget = Get_Ent_Data(iEnt,DEF_ENTSTAT)
			if(iTarget && is_user_alive(iTarget))
			{
				static Float:vOri[3]
				pev(iTarget,pev_origin,vOri)
				Stock_Ent_Move_To(iEnt, vOri, floatround(c_l_speed[Get_Ent_Data(iEnt,DEF_ENTID)]))
				set_pev(iEnt,pev_nextthink,get_gametime()+0.1)
			}
			else Set_Ent_Data(iEnt,DEF_ENTSTAT,0)
		}
	}
	else if(iEntClass == ENTCLASS_DRAGONTAIL)  //AT4CS
	{
		static Float:fRenderMount
		pev(iEnt, pev_renderamt, fRenderMount)
		fRenderMount -= 5.0
		if(fRenderMount<=0.0)
		{
			engfunc(EngFunc_RemoveEntity,iEnt)
			return
		}
		set_pev(iEnt,pev_renderamt,fRenderMount)
		set_pev(iEnt,pev_nextthink,get_gametime()+0.01)
	}
	else if(iEntClass == ENTCLASS_CANNON)
	{
		static Float:fFrame,Float:fLtime
		pev(iEnt,pev_frame,fFrame)
		pev(iEnt,pev_ltime,fLtime)
		//Touch something
		fFrame+=1.0
		if(fFrame>=22.00) 
		{
			engfunc(EngFunc_RemoveEntity,iEnt)
			return
		}
		set_pev(iEnt,pev_frame,fFrame)
		if(fLtime<get_gametime())
		{
			engfunc(EngFunc_RemoveEntity,iEnt)
			return
		}			
		set_pev(iEnt,pev_nextthink,get_gametime()+0.05)
	}
	return
}
public HamF_Touch_Grenade(iEnt,iTouched)
{
	static iOwner
	iOwner = pev(iEnt,pev_owner)
	if(iOwner == iTouched) return
	if(c_special[Get_Wpn_Data(iEnt,DEF_ID)] == SPECIAL_HOLYBOMB)
	{
		set_pev(iEnt,pev_dmgtime,0.1)
	}
	return
}
public HamF_InfoTarget_Touch(iPtr,iPtd)
{
	static iClass ,iOwner,iWpnID
	iClass = Get_Ent_Data(iPtr,DEF_ENTCLASS)
	iWpnID = Get_Ent_Data(iPtr,DEF_ENTID)
	if(iClass  == ENTCLASS_NADE)
	{
		if(c_special[iWpnID] == SPECIAL_FIRECRAKER && Get_Ent_Data(iPtr,DEF_ENTSTAT))
		{
			emit_sound(iPtr,CHAN_WEAPON,random_num(0,1)?"weapons/firecracker_bounce1.wav":"weapons/firecracker_bounce2.wav",1.0, ATTN_NORM, 0, PITCH_NORM)
			return HAM_IGNORED
		}
		Pub_Grenade_Explode(iPtr,0)
		engfunc(EngFunc_RemoveEntity,iPtr)
		return HAM_IGNORED
	}
	else if(iClass == ENTCLASS_FLAME)
	{
		new name[32]
		pev(iPtd,pev_classname,name,31)
		
		iOwner = pev(iPtr,pev_owner)
		if(iOwner == iPtd) return HAM_IGNORED
		Set_Ent_Data(iPtr,DEF_ENTSTAT,1)
		if(!pev_valid(iPtd)) return HAM_IGNORED
		if(iOwner != iPtd)  
		{
			set_pev(iPtr,pev_solid,SOLID_NOT)
		}
	}
	else if(iClass == ENTCLASS_BOLT)
	{
		new iOwner  = pev(iPtr,pev_owner)
		if(iPtd == iOwner) return HAM_IGNORED
		if(pev_valid(iPtd))
		{
			new trRes,Float:vecStart[3],Float:Forw[3],Float:vecEnd[3],Float:angle[3],Float:direction[3]
			pev(iPtr, pev_origin, vecStart) 
			
			Stock_Get_Velocity_Angle(iPtr, angle)
			engfunc(EngFunc_MakeVectors, angle)
			global_get(glb_v_forward,direction)
			xs_vec_mul_scalar(direction,20.0,Forw)
			xs_vec_add(vecStart, Forw, vecEnd)
			xs_vec_mul_scalar(direction,-5.0,Forw)
			xs_vec_add(vecStart, Forw, vecStart)
			
			engfunc(EngFunc_TraceLine, vecStart, vecEnd, 0, iOwner, trRes)	
			if(0<iPtd<33) 
			{
				set_pdata_int(iPtd,75,get_tr2(trRes,TR_iHitgroup))
				Stock_Fake_KnockBack(iOwner,iPtd,floatround(c_knockback[g_weapon[iOwner][0]]))
			}
			if(iPtd>0) Pub_Fake_Damage_Guns(iOwner,iPtd,50.0,FAKE_TYPE_TRACEBLEED|FAKE_TYPE_CHECKPHIT,9999.0,iPtr)
		}
		engfunc(EngFunc_RemoveEntity, iPtr)
		return HAM_IGNORED
	}
	return HAM_IGNORED
}
public HamF_Killed(id, idattacker, shouldgib)
{	
	set_pev(id, pev_weaponmodel, 0)
	Pub_Killed_Reset(id)
	Pub_Holster_Reset(id,0)
	if(is_user_bot(id)) Stock_ResetBotMoney(id)
	if(pev_valid(g_p_modelent[id]))
	{
		Stock_Set_Vis(g_p_modelent[id],0) 
	}
	if(g_c_iStripDroppedHe)
	{
		new sz[64]
		for(new i=1;i<4;i++)
		{
			if(i==1) copy(sz,63,"weapon_hegrenade")
			else if(i==2) copy(sz,63,"weapon_smokegrenade")
			else copy(sz,63,"weapon_flashbang")
			new wEnt
			while((wEnt = engfunc(EngFunc_FindEntityByString,wEnt,"classname",sz)) && pev(wEnt,pev_owner) != id) {}
			if(wEnt)
			{
				ExecuteHamB(Ham_Weapon_RetireWeapon,wEnt)	
				if(!ExecuteHamB(Ham_RemovePlayerItem,id,wEnt))  continue
				ExecuteHamB(Ham_Item_Kill, wEnt)
			}
		}
	}
	return HAM_IGNORED;
}
public HamF_Weapon_WeaponIdle(iEnt)
{
	static id,iId,iMaxClip,iClip,fInSpecialReload,iBpAmmo,iDftMaxClip,iSlot
	id = get_pdata_cbase(iEnt, m_pPlayer, 4)
	iSlot = ExecuteHam(Ham_Item_ItemSlot,iEnt)
	if(iSlot == 3 )
	{
		if(get_pdata_float(iEnt,m_flNextPrimaryAttack)<0.1 && get_pdata_float(iEnt,m_flNextSecondaryAttack)<0.1 && get_pdata_float(id,m_flNextAttack)<0.1)
		{
			PlaySeqence(id,c_seq[g_weapon[id][0]])
		}
	}
	else PlaySeqence(id,c_seq[g_weapon[id][0]])
	
	if(c_special[g_weapon[id][0]] == SPECIAL_SFMG && get_pdata_float(iEnt, m_flTimeWeaponIdle, 4)<0.1)
	{
		Stock_Send_Anim(id,g_sfmg_stat[id]?6:0)
		set_pdata_float(iEnt, m_flTimeWeaponIdle, 10.0,4)
		return HAM_IGNORED
	}
	if(c_special[g_weapon[id][0]] == SPECIAL_ZG && get_pdata_float(iEnt, m_flTimeWeaponIdle, 4)<0.1)
	{
		if(pev(id,pev_weaponanim) == WEAPON_TOTALANIM[c_wpnchange[g_weapon[id][0]]])
		{
			Stock_Send_Anim(id,0)
		}
		else Stock_Send_Anim(id,random_num(0,1)?0:WEAPON_TOTALANIM[c_wpnchange[g_weapon[id][0]]])
		set_pdata_float(iEnt, m_flTimeWeaponIdle, 7.0,4)
		return HAM_IGNORED
	}
	
	if(c_type[g_weapon[id][0]] == WEAPONS_SHOTGUN) return HAM_IGNORED
	if( get_pdata_float(iEnt, m_flTimeWeaponIdle, 4) > 0.0 ) return HAM_IGNORED
	
	iId = get_pdata_int(iEnt, m_iId, 4)
	iMaxClip =c_clip[g_weapon[id][0]]
	iClip = get_pdata_int(iEnt, m_iClip, 4)
	fInSpecialReload = get_pdata_int(iEnt, m_fInSpecialReload, 4)
	
	if( !iClip && !fInSpecialReload ) return HAM_IGNORED
	if( fInSpecialReload )
	{
		iBpAmmo = get_pdata_int(id, 381, 5)
		iDftMaxClip = MAXCLIP[iId]
		
		if( iClip < iMaxClip && iClip == iDftMaxClip && iBpAmmo )
		{
			Pub_Shotgun_Reload(iEnt, iId, iMaxClip, iClip, iBpAmmo, id)
			return HAM_IGNORED
		}
		else if( iClip == iMaxClip && iClip != iDftMaxClip )
		{
			Stock_Send_Anim( id, SHOTGUN_after_reload )
			
			set_pdata_int(iEnt, m_fInSpecialReload, 0, 4)
			set_pdata_float(iEnt, m_flTimeWeaponIdle, 1.5, 4)
		}
	}
	return HAM_IGNORED
}
public HamF_TakeDamage(iVictim, iInflictor, iAttacker, Float:fDamage, iDamageType)
{
	static Float:fXDamage,iWpnEnt,iButton
	if(iVictim<1 || iVictim>32 || iAttacker<1 || iAttacker>32) return HAM_IGNORED // Only Player Damage can GO
	if (iVictim == iAttacker) return HAM_IGNORED
	if(!is_user_connected(iAttacker) || !is_user_connected(iVictim)) return HAM_IGNORED// Not Connected
	iButton = pev(iAttacker,pev_button)
	if (iDamageType & DMG_HE) //He Damage
	{
		// Fix DMG
		static iWpnID
		iWpnID = Get_Wpn_Data(iInflictor,DEF_ID)
		if(iWpnID) fDamage*=c_damage[iWpnID]
		SetHamParamFloat(4, fDamage)
		return HAM_IGNORED
	}
	// 用来修复某些SB利用延迟武器造成睾伤害的Bug
	if(iInflictor >31)
	{
		if(c_damage[Get_Ent_Data(iInflictor,DEF_ENTID)]) fXDamage = c_damage[Get_Ent_Data(iInflictor,DEF_ENTID)]
		else fXDamage = 1.0
		fDamage *= fXDamage
		SetHamParamFloat(4, fDamage)
		return HAM_IGNORED
	}			
			
	if(g_double[iAttacker][0])
	{
		fXDamage = c_d_damage[g_weapon[iAttacker][0]]
	}
	else
	{
		fXDamage = c_damage[g_weapon[iAttacker][0]]
	}
	if(!fXDamage) fXDamage = 1.0
	

	fDamage *= fXDamage

	if(c_special[g_weapon[iAttacker][0]] == SPECIAL_STRONGKNIFE)
	{
		if(Stock_Check_Back(iVictim,iAttacker)) fDamage *= 3.0
	}
	else if(c_special[g_weapon[iAttacker][0]] == SPECIAL_SFMG && g_sfmg_stat[iAttacker])
	{
		fDamage *= 0.88
	}	
	else if(c_special[g_weapon[iAttacker][0]] == SPECIAL_INFINITY &&  ( iButton & IN_ATTACK2))
	{
		fDamage *= 0.829
	}	
	else if(c_special[g_weapon[iAttacker][0]] == SPECIAL_SKULL1 &&  ( iButton & IN_ATTACK2))
	{
		fDamage *= 0.623
	}		
	else if(c_special[g_weapon[iAttacker][0]] == SPECIAL_BALROG5)
	{       
		static Float:dmg
		dmg=WE_Balrog5(iAttacker,iVictim)
		fDamage *= dmg
		
	}
	// Set Knife KnockBack Here & Knife Secondary Attack Damage
	if(get_user_weapon(iAttacker) == CSW_KNIFE && !c_k_delay2[g_weapon[iAttacker][0]])
	{
		static iButton
		iButton = pev(iAttacker,pev_button)
		if(iButton & IN_ATTACK2 && c_k_damage2[g_weapon[iAttacker][0]]) fDamage *= c_k_damage2[g_weapon[iAttacker][0]]
		Stock_Fake_KnockBack(iAttacker,iVictim,floatround(c_knockback[g_weapon[iAttacker][0]]))
	}
	SetHamParamFloat(4, fDamage)

	return HAM_IGNORED
}
public HamF_Weapon_PrimaryAttack(iEnt)
{
	static id
	id = get_pdata_cbase(iEnt, m_pPlayer, 4)
	g_attacking[id] = 1
	return HAM_IGNORED
}
public HamF_Weapon_PrimaryAttack_Post(iEnt)
{		
	static id,iCswpn,iSlot,iClip,Float:fRecoil,Float:vPunchAngle[3],Float:fNextAttack
	id = get_pdata_cbase(iEnt,m_pPlayer,4)
	iCswpn = get_pdata_int(iEnt, m_iId, 4)
	iSlot = ExecuteHam(Ham_Item_ItemSlot,iEnt)
	iClip = get_pdata_int(iEnt, m_iClip, 4)

	
	if(g_attacking[id] = 1) // If Attacking
	{
		if(c_special[g_weapon[id][0]] == SPECIAL_SFSNIPER)
		{
			set_pdata_float(iEnt, m_flTimeWeaponIdle, 2.7, 4) // fix bug
		}
		// Set Recoil
		if(c_type[g_weapon[id][0]] == WEAPONS_SPSHOOT && iClip)
		{
			set_pdata_int(iEnt,m_iFamasShotsFired,10)
			set_pdata_float(iEnt,m_flFamasShoot,get_gametime()+c_sp_speed[g_weapon[id][0]])
		}
		fRecoil = c_recoil[g_weapon[id][0]]
		if (fRecoil && iClip)
		{
			g_attacking[id] = 0
			pev(id, pev_punchangle, vPunchAngle)
			xs_vec_mul_scalar(vPunchAngle, fRecoil, vPunchAngle)
			set_pev(id, pev_punchangle, vPunchAngle)
			Pub_Shake(id)
		}
		// Set Attack
		if(c_slot[g_weapon[id][0]] != WPN_KNIFE) // Not Knife
		{
			fNextAttack = (g_double[id][0] == 0?c_speed[g_weapon[id][0]]:c_d_speed[g_weapon[id][0]])
			if (fNextAttack>0.0) 
			{
				if(g_c_fZoomRateOfFireMultiple>0.1 && Pub_Get_Player_Zoom(id) && iCswpn!=CSW_SG550 && iCswpn!= CSW_G3SG1) fNextAttack *= g_c_fZoomRateOfFireMultiple
				set_pdata_float(iEnt, m_flNextPrimaryAttack, fNextAttack, 4)
			}
			// 
			if(c_special[g_weapon[id][0]] == SPECIAL_BALROG7 && iClip)
			{
				WE_Balrog7(id)
			}	
			else if(c_special[g_weapon[id][0]] == SPECIAL_SFMG && g_sfmg_stat[id])
			{
				set_pdata_float(iEnt, m_flNextPrimaryAttack, fNextAttack*0.5952, 4)
			}
		}
		else if(iSlot == WPN_KNIFE && c_k_speed1[g_weapon[id][0]])
		{
			set_pdata_float(iEnt, m_flNextPrimaryAttack, c_k_speed1[g_weapon[id][0]], 4)
			set_pdata_float(iEnt, m_flNextSecondaryAttack, c_k_speed1[g_weapon[id][0]], 4)
			set_pdata_float(iEnt, m_flTimeWeaponIdle, c_k_speed1[g_weapon[id][0]]+2.0, 4) // fix bug
			
			//
			if(c_special[g_weapon[id][0]] == SPECIAL_KATANA)
			{
				new iTr, Float:vecSrc[3], Float: vecEnd[3],Float:vecAngle[3]
				pev(id, pev_origin, vecSrc)
				pev(id, pev_view_ofs, vecEnd)
				xs_vec_add(vecSrc, vecEnd, vecSrc)
				
				static Float:vecForward[3]
				pev(id,pev_v_angle,vecAngle)
				engfunc(EngFunc_MakeVectors,vecAngle)
				global_get(glb_v_forward, vecForward)
				xs_vec_mul_scalar(vecForward, c_k_distance1[g_weapon[id][0]], vecForward)
				xs_vec_add(vecSrc, vecForward, vecEnd)
				engfunc(EngFunc_TraceLine, vecSrc, vecEnd, DONT_IGNORE_MONSTERS, id, iTr)	
				static Float:flFraction
				get_tr2(iTr, TR_flFraction, flFraction)
				
				if ((flFraction != 1.0) || pev_valid(get_tr2(iTr, TR_pHit)) )
				{
					set_pdata_float(iEnt, 46, c_k_speed1[g_weapon[id][0]]/3.5, 4)
					set_pdata_float(iEnt, 47, c_k_speed1[g_weapon[id][0]]/3.5, 4)
					return HAM_IGNORED
				}
				else engfunc(EngFunc_TraceHull, vecSrc, vecEnd, DONT_IGNORE_MONSTERS, HULL_HEAD,id, iTr)
				get_tr2(iTr, TR_flFraction, flFraction)
				
				if (flFraction != 1.0|| pev_valid(get_tr2(iTr, TR_pHit)) )
				{
					set_pdata_float(iEnt, 46, c_k_speed1[g_weapon[id][0]]/3.5, 4)
					set_pdata_float(iEnt, 47, c_k_speed1[g_weapon[id][0]]/3.5, 4)
					return HAM_IGNORED
				}
			}
			else if(c_special[g_weapon[id][0]] == SPECIAL_DRAGONTAIL)
			{
				// Color Check
				new iTr, Float:vecSrc[3], Float: vecEnd[3],Float:vecAngle[3],iHit
				pev(id, pev_origin, vecSrc)
				pev(id, pev_view_ofs, vecEnd)
				xs_vec_add(vecSrc, vecEnd, vecSrc)
				
				static Float:vecForward[3]
				pev(id,pev_v_angle,vecAngle)
				engfunc(EngFunc_MakeVectors,vecAngle)
				global_get(glb_v_forward, vecForward)
				xs_vec_mul_scalar(vecForward, c_k_distance1[g_weapon[id][0]], vecForward)
				xs_vec_add(vecSrc, vecForward, vecEnd)
				engfunc(EngFunc_TraceLine, vecSrc, vecEnd, DONT_IGNORE_MONSTERS, id, iTr)	
				static Float:flFraction
				get_tr2(iTr, TR_flFraction, flFraction)
				
				if ((flFraction != 1.0) || pev_valid(get_tr2(iTr, TR_pHit)) )
				{
					iHit = 1
				}
				else engfunc(EngFunc_TraceHull, vecSrc, vecEnd, DONT_IGNORE_MONSTERS, HULL_HEAD,id, iTr)
				get_tr2(iTr, TR_flFraction, flFraction)
				
				if (flFraction != 1.0|| pev_valid(get_tr2(iTr, TR_pHit)) )
				{
					iHit = 1
				}
				
				g_dt_level[id] = get_gametime()+ 0.5
				new iEffect = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
				new Float: fOrigin[3], Float:fAngle[3],Float: fVelocity[3]
				pev(id, pev_v_angle, fAngle)
				fAngle[0] *= -1.0
				set_pev(iEffect, pev_classname, "bte_effect")
				g_dt_stat[id] = 1 - g_dt_stat[id]	
				if(g_dt_stat[id])
				{
					Stock_Send_Anim(id,2)
					set_pev(iEffect,pev_sequence,0)
				}
				else
				{
					Stock_Send_Anim(id,3)
					set_pev(iEffect,pev_sequence,1)
				}						
				
				set_pev(iEffect, pev_mins, Float:{-1.0, -1.0, -1.0})
				set_pev(iEffect, pev_maxs, Float:{1.0, 1.0, 1.0})
				Stock_Get_Postion(id,10.0,5.0,-2.0,fOrigin)
				set_pev(iEffect, pev_movetype, MOVETYPE_NOCLIP)
				Set_Ent_Data(iEffect,DEF_ENTCLASS,ENTCLASS_DRAGONTAIL)
				engfunc(EngFunc_SetModel, iEffect, "models/bte_wpn/ef_dragontail.mdl")
				set_pev(iEffect, pev_origin, fOrigin)
				set_pev(iEffect, pev_angles, fAngle)
				set_pev(iEffect, pev_solid, SOLID_NOT)
				set_pev(iEffect, pev_owner, id)
				set_pev(iEffect, pev_rendermode, kRenderTransAdd)
				set_pev(iEffect, pev_renderamt, 200.0)
				set_pev(iEffect,pev_skin,iHit?0:1)
				set_pev(iEffect, pev_framerate,0)
				set_pev(iEffect, pev_nextthink,get_gametime()+0.01)
			}
		}
		// Play Sequence
		PlaySeqence(id,c_seq[g_weapon[id][0]]+1)
	}
	return HAM_IGNORED	
}
public HamF_Item_PostFrame(iEnt)
{
	static id,iBpAmmo,iClip,iSlot,iAmmoType,iInReload,Float:fNextAttack,iMaxClip,iTemp,iCswpn,iButton,iInSpecialReload
	id = get_pdata_cbase(iEnt, m_pPlayer, 4)
	iCswpn = get_pdata_int(iEnt,m_iId,4)
	iSlot = ExecuteHam(Ham_Item_ItemSlot,iEnt)
	iClip = get_pdata_int(iEnt, m_iClip, 4)
	iAmmoType = m_rgAmmo_player_Slot0 + get_pdata_int(iEnt, m_iPrimaryAmmoType, 4)
	iBpAmmo = get_pdata_int(id, iAmmoType, 5)
	iInReload = get_pdata_int(iEnt, m_fInReload, 4)
	fNextAttack = get_pdata_float(id, m_flNextAttack, 5)
	iMaxClip = g_double[id][0]?c_d_clip[g_weapon[id][0]]:c_clip[g_weapon[id][0]]
	iButton = pev(id,pev_button)
	
	// Check Silent
	if ( CSWPN_SILENT & (1<<iCswpn) && get_pdata_int(iEnt, m_fSilent, 4) ) g_silen[id] = 1
	else g_silen[id] = 0
	
	if(c_type[g_weapon[id][0]] == WEAPONS_SPSHOOT)
	{
		if(get_pdata_int(iEnt,m_iFamasShotsFired)>=9+c_sp_times[g_weapon[id][0]])
		{
			set_pdata_int(iEnt,m_iFamasShotsFired,10)
			set_pdata_float(iEnt,m_flFamasShoot,0)
		}
	}
	
	if(CSWPN_SHOTGUNS & (1<<iCswpn) && c_type[g_weapon[id][0]] != WEAPONS_SHOTGUN)
	{
		if( iButton & IN_ATTACK && get_pdata_float(iEnt, m_flNextPrimaryAttack, 4) <= 0.0 ) return HAM_IGNORED
		if( iButton & IN_RELOAD  )
		{
			if( iClip >= iMaxClip )
			{
				set_pev(id, pev_button, iButton & ~IN_RELOAD)
				set_pdata_float(iEnt, m_flNextPrimaryAttack, 0.5, 4) 
			}
			else if( iClip == MAXCLIP[iCswpn] )
			{
				if( iBpAmmo ) Pub_Shotgun_Reload(iEnt, iCswpn, iMaxClip, iClip, iBpAmmo, id)
			}
		}
		return HAM_IGNORED
	}
		
	// Update Clip (Reload End)
	if( iInReload && fNextAttack <= 0.0 )
	{
		iTemp = min(iMaxClip - iClip, iBpAmmo)
		set_pdata_int(iEnt, m_iClip, iClip + iTemp, 4)
		set_pdata_int(id, iAmmoType, iBpAmmo-iTemp, 5)
		set_pdata_int(iEnt, m_fInReload, 0, 4)
		set_pdata_int(iEnt, m_fInSpecialReload, 0, 4)
	}
	if(fNextAttack<0.0 && g_dchanging[id])
	{
		g_dchanging[id] = 0
		g_double[id][0] = 1 - g_double[id][0]
	}

	// Update Reload Prediction Animation
	if( iButton & IN_RELOAD && !iInReload && c_type[g_weapon[id][0]] != WEAPONS_LAUNCHER && c_special[g_weapon[id][0]] != SPECIAL_CANNON)
	{
		if( iClip >= iMaxClip)
		{			
			set_pev(id, pev_button, iButton & ~IN_RELOAD)
			if( CSWPN_SILENT & (1<<iCswpn) && !get_pdata_int(iEnt, m_fSilent, 4) )
			{
				Stock_Send_Anim( id, iCswpn == CSW_USP ? 8 : 7 )
			}
			else
			{
				Stock_Send_Anim(id, 0)
			}
			if(c_special[g_weapon[id][0]] == SPECIAL_SFMG)
			{
				Stock_Send_Anim(id,g_sfmg_stat[id]?6:0)
			}
			//set_pdata_float(iEnt, m_flTimeWeaponIdle, 0, 4)
		}
	}
	
	// Check Zoom
	if(iButton & IN_ATTACK2)
	{
		Pub_Set_Zoom(id,g_weapon[id][0])
	}
	// !! Weapon Effect
	WpnEffect(id,iEnt,iClip,iBpAmmo,iCswpn)
	return HAM_IGNORED
}
public HamF_Weapon_Reload(iEnt)
{
	static id,iAmmoType,iAmmo,iClip,iInReload,Float:fReload,iCswpn
	iCswpn = get_pdata_int(iEnt,m_iId,4)
	id = get_pdata_cbase(iEnt, m_pPlayer, 4)
	iAmmoType = get_pdata_int(iEnt, m_iPrimaryAmmoType, 4)
	iAmmo = get_pdata_int(id, m_rgAmmo_player_Slot0 + iAmmoType)
	iInReload = get_pdata_int(iEnt, m_fInReload, 4)
	
	if(c_type[g_weapon[id][0]] != WEAPONS_SHOTGUN && CSWPN_SHOTGUNS & (1<<iCswpn)) return HAM_IGNORED
	if(c_type[g_weapon[id][0]] == WEAPONS_M32) return HAM_SUPERCEDE
	if(c_type[g_weapon[id][0]] == WEAPONS_LAUNCHER) return HAM_SUPERCEDE

	if (iAmmo <= 0) return HAM_IGNORED
	if(!g_double[id][0] && iClip == c_clip[g_weapon[id][0]]) return HAM_IGNORED
	if (g_double[id][0] && iClip == c_d_clip[g_weapon[id][0]]) return HAM_IGNORED
	
	if (!iInReload)
	{
		if(c_special[g_weapon[id][0]] == SPECIAL_INFINITY) PlaySeqence(id,c_seq[g_weapon[id][0]]+3)
		else if(c_special[g_weapon[id][0]] == SPECIAL_SKULL3 && get_user_weapon(id) == c_d_cswpn[g_weapon[id][0]])  PlaySeqence(id,29)
		else PlaySeqence(id,c_seq[g_weapon[id][0]]+2)
		Pub_Reset_Zoom(id) // Reset Zoom
		//
		if(c_special[g_weapon[id][0]] == SPECIAL_INFINITY)
		{
			g_infinity_change[id] = 1-g_infinity_change[id] 
		}
		//
		fReload = c_reload[g_weapon[id][0]]?c_reload[g_weapon[id][0]]:WEAPON_DELAY[c_wpnchange[g_weapon[id][0]]]
		if(g_double[id][0]) fReload = c_d_reload[g_weapon[id][0]]?c_d_reload[g_weapon[id][0]]:WEAPON_DELAY[c_wpnchange[g_weapon[id][0]]]
		ExecuteHam(Ham_Weapon_Reload, iEnt)
		set_pdata_float(id, m_flNextAttack, fReload)
		set_pdata_int(iEnt, m_fInReload, 1, 4)
		if(c_special[g_weapon[id][0]] != SPECIAL_SFMG)set_pdata_float(iEnt, m_flTimeWeaponIdle, fReload, 4)
		if(c_type[g_weapon[id][0]] == WEAPONS_DOUBLE && g_double[id][0]) Stock_Send_Anim(id,RELOAD_ANIM[c_d_cswpn[g_weapon[id][0]]])
		else if(c_type[g_weapon[id][0]] == WEAPONS_SHOTGUN) Stock_Send_Anim(id,WEAPON_TOTALANIM[c_wpnchange[g_weapon[id][0]]])
		else Stock_Send_Anim(id,RELOAD_ANIM[c_wpnchange[g_weapon[id][0]]])
		if(c_special[g_weapon[id][0]] == SPECIAL_SFMG)
		{
			Stock_Send_Anim(id,g_sfmg_stat[id]?9:3)
		}
		return HAM_SUPERCEDE
	}
	return HAM_IGNORED
}
public HamF_Item_Holster_Post(iEnt)
{	
	static id ; id = get_pdata_cbase(iEnt, m_pPlayer, 4)
	static iCswpn ; iCswpn = get_pdata_int(iEnt, m_iId, 4)
	static iSlot ; iSlot = ExecuteHam(Ham_Item_ItemSlot,iEnt)
	static iClip ; iClip = get_pdata_int(iEnt, m_iClip,4)
	static iBpAmmo
	
	if(id && iSlot <5 && is_user_alive(id))
	{
		Pub_Holster_Reset(id,iEnt)
		iBpAmmo = Stock_Config_User_Bpammo(id,iCswpn,0,0)
		Stock_Store_Wpn_Current(id,iSlot,iClip,iBpAmmo)
		Stock_Reset_Wpn_Slot(id,0)
	}
	return HAM_IGNORED
}

public HamF_Set_Player_Maxspeed_Post(id)
{
	if(!is_user_alive(id)) return HAM_IGNORED
	if(g_freezetime)
	{
		set_pev(id,pev_maxspeed,0.1)
		return HAM_IGNORED		
	}
	
	if(!g_fPlrMaxspeed[id])
	{
		g_fPlrMaxspeed[id] = 250.0
	}
	set_pev(id,pev_maxspeed,g_fPlrMaxspeed[id])
	return HAM_IGNORED		
}
public HamF_AddPlayerItem(id,iEnt)
{	
	static iCswpn; iCswpn = get_pdata_int(iEnt, m_iId, 4)
	static iSlot; iSlot = ExecuteHam(Ham_Item_ItemSlot,iEnt)
	static iDouble; iDouble = Get_Wpn_Data(iEnt,DEF_ISDOUBLE)
	static isDoubleWpn
	
	if(g_modruning == BTE_MOD_ZB1)
	{
		if(iCswpn == CSW_C4 ||iCswpn == CSW_FLASHBANG ||iCswpn == CSW_SMOKEGRENADE) return HAM_SUPERCEDE
	}

	if(!(CSWPN_NOTREMOVE & (1<<iCswpn)))
	{
		// Update Player HUD
		if(Get_Wpn_Data(iEnt,DEF_ID)) g_weapon[id][iSlot] = Get_Wpn_Data(iEnt,DEF_ID)
		Set_Wpn_Data(iEnt,DEF_ID,g_weapon[id][iSlot])
		
		if(c_type[g_weapon[id][iSlot]] == WEAPONS_DOUBLE) isDoubleWpn = 1
		else isDoubleWpn = 0			
		// Set Ammo
		if(Get_Wpn_Data(iEnt,DEF_ISDROPPED))
		{
			g_user_ammo[id][iSlot] = Get_Wpn_Data(iEnt,DEF_AMMO)
		}
		// Update Clip if needed
		if(Get_Wpn_Data(iEnt,DEF_CLIP)) g_user_clip[id][iSlot] = Get_Wpn_Data(iEnt,DEF_CLIP)
		if(isDoubleWpn && Get_Wpn_Data(iEnt,DEF_ISDROPPED))
		{
			if(iCswpn == c_d_cswpn[g_weapon[id][iSlot]]) g_double[id][1]= 1
			else g_double[id][1]= 0
		}
		
		// If Pickup a double weapon
		if(c_type[g_weapon[id][iSlot]] == WEAPONS_DOUBLE && Get_Wpn_Data(iEnt,DEF_ISDROPPED))
		{
			ExecuteHam(Ham_AddPlayerItem,id,iEnt)
			if(iCswpn == c_d_cswpn[g_weapon[id][iSlot]]) Stock_Give_Cswpn(id,WEAPON_NAME[c_wpnchange[g_weapon[id][iSlot]]])
			else Stock_Give_Cswpn(id,WEAPON_NAME[c_d_cswpn[g_weapon[id][iSlot]]],1)
			return HAM_SUPERCEDE
		}
		static sTxt[32]
		if(iDouble)
		{
			format(sTxt,31,"weapon_%s_2",c_model[g_weapon[id][iSlot]])
			message_begin(MSG_ONE,g_msgWeaponList, {0,0,0}, id);
			write_string(sTxt)
			write_byte(WEAPON_AMMOID[c_d_cswpn[g_weapon[id][iSlot]]])
			write_byte(c_ammo[g_weapon[id][iSlot]])
			write_byte(-1)
			write_byte(-1)
			write_byte(c_slot[g_weapon[id][iSlot]]-1)
			write_byte(CSWPN_POSITION[c_d_cswpn[g_weapon[id][iSlot]]])
			write_byte(c_d_cswpn[g_weapon[id][iSlot]])
			write_byte(0)
			message_end()	
		}
		else
		{
			format(sTxt,31,"weapon_%s",c_model[g_weapon[id][iSlot]])
			message_begin(MSG_ONE,g_msgWeaponList, {0,0,0}, id);
			write_string(sTxt)
			write_byte(WEAPON_AMMOID[iCswpn])
			write_byte(c_ammo[g_weapon[id][iSlot]])
			write_byte(-1)
			write_byte(-1)
			write_byte(c_slot[g_weapon[id][iSlot]]-1)
			write_byte(CSWPN_POSITION[iCswpn])
			write_byte(iCswpn)
			write_byte(0)
			message_end()
		}
	}
	return HAM_IGNORED
}
public HamF_Spawn_Player_Post(id)
{
	if(!is_user_alive(id)) return HAM_IGNORED
	if(is_user_bot(id)) Stock_ResetBotMoney(id)
	for(new i=1;i<5;i++)
	{
		if(get_pdata_cbase(id,m_rgpPlayerItems+i,5)<1)
		{
			Stock_Reset_Wpn_Slot(id,i)
			Pub_Give_Default_Wpn(id,i)
		}
	}
	if(is_user_bot(id) && g_modruning != BTE_MOD_GD) // Give Bot Weapon
	{
		// Primary
		remove_task(id+TASK_BOT_WEAPON)
		//cs_set_user_money(id,0)
		set_task(3.0,"Task_Bot_Weapon",id+TASK_BOT_WEAPON)
	}
	return HAM_IGNORED
}	
public HamF_Spawn_Weapon(iEnt)
{
	if(!Get_Wpn_Data(iEnt,DEF_SPAWN)) 
	{
		engfunc(EngFunc_RemoveEntity,iEnt)
		return HAM_SUPERCEDE
	}
	return HAM_IGNORED
}
public HamF_Item_Deploy(iEnt)
{
	static id 
	id = get_pdata_cbase(iEnt, m_pPlayer, 4)
	if(!is_user_alive(id)) return HAM_SUPERCEDE
}
public HamF_Item_Deploy_Post(iEnt)
{
	new id,iCswpn,iSlot,Float:fDeployTime
	id = get_pdata_cbase(iEnt, m_pPlayer, 4)
	iCswpn =  get_pdata_int(iEnt, m_iId, 4)
	iSlot = ExecuteHam(Ham_Item_ItemSlot,iEnt)

	if(iSlot>4 || id<1 || id>33) return HAM_IGNORED
	if(CSWPN_NOTREMOVE & (1<<iCswpn)) return HAM_IGNORED
	
	Stock_Set_Wpn_Current(id,iSlot)
	if(is_user_connected(id))
	{
		Pub_Deploy_Reset(iEnt,id,iCswpn)
	}
	
	if(iSlot!=3 && iSlot!=4)
	{
		// Update BpAmmo
		Stock_Config_User_Bpammo(id, iCswpn, g_user_ammo[id][0],1)
		// Update Clip if needed
		if(g_user_clip[id][0] || c_type[g_weapon[id][0]] == WEAPONS_LAUNCHER)
		{
			set_pdata_int(iEnt, m_iClip, g_user_clip[id][0],4)
			g_user_clip[id][0] = 0
		}	
			// Check Double
		if(c_type[g_weapon[id][0]] == WEAPONS_DOUBLE)
		{
			static iClip2,iNum,iBpAmmo
			iBpAmmo = Stock_Config_User_Bpammo(id, iCswpn,0,0)
			iClip2 = get_pdata_int(iEnt, m_iClip, 4)
			if(  iCswpn == c_d_cswpn[g_weapon[id][0]] && iClip2 > c_d_clip[g_weapon[id][0]])
			{
				iNum = iClip2 - c_d_clip[g_weapon[id][0]]
				set_pdata_int(iEnt, m_iClip, c_d_clip[g_weapon[id][0]],4)
				Stock_Config_User_Bpammo(id, iCswpn, iBpAmmo+iNum,1)
			}
			else if(iCswpn == c_wpnchange[g_weapon[id][0]]&& iClip2>c_clip[g_weapon[id][0]])
			{
				iNum = iClip2 - c_clip[g_weapon[id][0]]
				set_pdata_int(iEnt, m_iClip, c_clip[g_weapon[id][0]],4)
				Stock_Config_User_Bpammo(id, iCswpn, iBpAmmo+iNum,1)
			}
		}
		Pub_DeploySet(iEnt,id,iCswpn)
	}
	
	if(iSlot==3)
	{
		set_pdata_float(iEnt,m_flTimeWeaponIdle,5.0)
	}
	// Update View Model
	if(c_special[g_weapon[id][0]] == SPECIAL_DRAGONTAIL)
	{
		Stock_Send_Anim(id,1)
	}
	if(c_type[g_weapon[id][0]] == WEAPONS_DOUBLE)
	{
		if(iCswpn == c_d_cswpn[g_weapon[id][0]]) 
		{
			set_pev(id, pev_viewmodel2, c_model_v2[g_weapon[id][0]])
		}
		else set_pev(id, pev_viewmodel2,c_model_v[g_weapon[id][0]])
	}
	else set_pev(id, pev_viewmodel2,c_model_v[g_weapon[id][0]])
		
	if(c_special[g_weapon[id][0]] == SPECIAL_HAMMER)
	{
		if(g_hammer_stat[id])
		{
			set_pev(id, pev_viewmodel2, "models/bte_wpn/v_hammer_2.mdl")
			if(!(bte_hms_get_skillstat(id) & (1<<0))) Pub_Set_MaxSpeed(id,c_gravity[g_weapon[id][0]]-100.0)
		}
		else
		{
			set_pev(id, pev_viewmodel2, "models/bte_wpn/v_hammer.mdl")
		}
	}
	Pub_Create_P_Model(id,g_weapon[id][0])
	PlaySeqence(id,c_seq[g_weapon[id][0]])
	if(c_type[g_weapon[id][0]] ==  WEAPONS_DOUBLE)
	{
		if(g_double[id][0] && g_dchanging[id] && iCswpn == c_d_cswpn[g_weapon[id][0]])
		{
			Stock_Send_Anim(id,DEPLOY_ANIM[c_d_cswpn[g_weapon[id][0]]])
		}
		else if(!g_double[id][0] && g_dchanging[id] && iCswpn == c_wpnchange[g_weapon[id][0]])
		{
			Stock_Send_Anim(id,DEPLOY_ANIM[c_wpnchange[g_weapon[id][0]]])
		}
		else if(!g_double[id][0] && iCswpn == c_d_cswpn[g_weapon[id][0]])
		{
			Stock_Send_Anim(id,WEAPON_TOTALANIM[iCswpn])
			g_dchanging[id] = 1
			set_pdata_float(id, m_flNextAttack,c_d_timechange2[g_weapon[id][0]],5)
		}
		else if(g_double[id][0] && iCswpn == c_wpnchange[g_weapon[id][0]])
		{
			Stock_Send_Anim(id,WEAPON_TOTALANIM[iCswpn])
			g_dchanging[id] = 1
			set_pdata_float(id, m_flNextAttack,c_d_timechange1[g_weapon[id][0]],5)
		}
	}
	if(c_special[g_weapon[id][0]] == SPECIAL_SKULL3 && iCswpn == c_d_cswpn[g_weapon[id][0]])
	{
		engfunc(EngFunc_SetModel, g_p_modelent[id], "models/bte_wpn/p_skull3dual.mdl")
		PlaySeqence(id,26)
	}
	if(g_dchanging[id])
	{
		if(!(bte_hms_get_skillstat(id) & (1<<0))) Pub_Set_MaxSpeed(id,g_double[id][0]?c_gravity[g_weapon[id][0]]:c_d_gravity[g_weapon[id][0]])
	}
	else
	{	
		if(!(bte_hms_get_skillstat(id) & (1<<0))) Pub_Set_MaxSpeed(id,g_double[id][0]?c_d_gravity[g_weapon[id][0]]:c_gravity[g_weapon[id][0]])
	}
	// Set Deploy Time if needed
	fDeployTime = g_double[id][0]?c_d_deploy[g_weapon[id][0]]:c_deploy[g_weapon[id][0]]
	if(fDeployTime>0.0) set_pdata_float(id, m_flNextAttack,fDeployTime,5)

	return HAM_SUPERCEDE
}
public HamF_TraceAttack(iVictim, iAttacker, Float:fDamage, Float:vDir[3], iTr, iDamageType)
{
	if(iVictim<1 || iVictim>32 || iAttacker<1 || iAttacker>32) return HAM_IGNORED // Only Player Damage can GO
	if (iVictim == iAttacker) return HAM_IGNORED
	if(!is_user_connected(iAttacker) || !is_user_connected(iVictim)) return HAM_IGNORED// Not Connected
	if(get_user_weapon(iAttacker)==29) return HAM_IGNORED
	
	if (g_freezetime) return HAM_SUPERCEDE
	if (get_user_team(iAttacker)==get_user_team(iVictim) && !get_pcvar_num(cvar_friendlyfire)) return HAM_SUPERCEDE
	if (!(iDamageType & DMG_BULLET)) return HAM_IGNORED
		

	static vOrigin1[3], vOrigin2[3],Float:vVelocity[3],Float:fXRecoil
	get_user_origin(iVictim, vOrigin1)
	get_user_origin(iAttacker, vOrigin2)
	pev(iVictim, pev_velocity, vVelocity)

	if(g_c_iKnockBackUseDmg) xs_vec_mul_scalar(vDir, fDamage, vDir)
	if(g_double[iAttacker][0])
	{
		fXRecoil = c_d_knockback[g_weapon[iAttacker][0]]
	}
	else
	{
		fXRecoil= c_knockback[g_weapon[iAttacker][0]]
	}
	if (c_knockback[g_weapon[iAttacker][0]]) xs_vec_mul_scalar(vDir, c_knockback[g_weapon[iAttacker][0]], vDir)
	else return HAM_IGNORED

	xs_vec_add(vVelocity, vDir, vDir)
	set_pev(iVictim, pev_velocity, vDir)
	return HAM_IGNORED
}
