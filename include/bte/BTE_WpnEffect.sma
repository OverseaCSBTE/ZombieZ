// [BTE Weapon Effect FUNCTION]
public WpnEffect(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	if(g_skullaxe_stat[id] == KNIFE_PRE && g_skullaxe_timer[id] < get_gametime() && c_slot[g_weapon[id][0]] != 3)
	{
		Stock_Send_Anim(id,3)
		new iEnemy,iBody
		get_user_aiming(id,iEnemy,iBody)
		Pub_Fake_Damage_Guns(id,iEnemy,40.0,FAKE_TYPE_TRACEBLEED|FAKE_TYPE_CHECKPHIT,400.0)
		g_skullaxe_stat[id] = KNIFE_IDLE
	}
	if(c_type[g_weapon[id][0]] == WEAPONS_M134)
	{
		WE_M134(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_type[g_weapon[id][0]] == WEAPONS_LAUNCHER)
	{
		WE_Launcher(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_type[g_weapon[id][0]] == WEAPONS_BAZOOKA)
	{
		WE_Bazooka(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_type[g_weapon[id][0]] == WEAPONS_FLAMETHROWER)
	{
		WE_FlameThrower(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_INFINITY)
	{
		WE_Infinity(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_MUSKET)
	{
		WE_Musket(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_CROSSBOW)
	{
		WE_Crossbow(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_SKULL1)
	{
		WE_Skull1(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_CATAPULT)
	{
		WE_Catapult(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_CANNON)
	{
		WE_Cannon(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_VIOLIN)
	{
		WE_Volin(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_type[g_weapon[id][0]] == WEAPONS_SVDEX)
	{
		WE_Svdex(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_type[g_weapon[id][0]] == WEAPONS_M32)
	{
		WE_M32(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_M249EP)
	{
		WE_M249EP(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_SKULL8)
	{
		WE_SKULL8(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
	
	if(c_special[g_weapon[id][0]] == SPECIAL_SFMG&&get_pdata_float(iEnt,m_flNextPrimaryAttack)<0.0 && (pev(id,pev_button)&IN_ATTACK2) &&!get_pdata_int(iEnt, m_fInReload, 4))
	{
		g_sfmg_stat[id] = 1 - g_sfmg_stat[id]
		MH_SpecialEvent(id,6+g_sfmg_stat[id])
		set_pdata_float(iEnt,m_flNextPrimaryAttack,2.6,4)
		set_pdata_float(iEnt, m_flTimeWeaponIdle, 2.6,4)
		Stock_Send_Anim(id,g_sfmg_stat[id]?5:11)
		//g_sfmg_timer[id] = get_gametime() + 2.6
	}
	else if (iCswpn == CSW_KNIFE)
	{
		WE_Melee(id,iEnt,iClip,iBpAmmo,iCswpn)
	}
}
public WE_M249EP(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	static iButton
	iButton  = pev(id,pev_button)
	if(get_pdata_float(iEnt,m_flNextPrimaryAttack,4)<=0.0 && iButton & IN_ATTACK2)
	{
		set_pdata_float(iEnt,m_flNextPrimaryAttack,2.0,4)
		new iCallBack = Pub_Fake_Melee_Attack2(id,40.0,55.0)
		if(iCallBack != FAKE_RESULT_HIT_NONE)
		{
			emit_sound(id,CHAN_WEAPON,random_num(0,1)?"weapons/m249ep_hit2.wav":"weapons/m249ep_hit1.wav",1.0, ATTN_NORM, 0, PITCH_NORM)
			Stock_Send_Anim(id,5)
		}
		else
		{
			Stock_Send_Anim(id,6)
			emit_sound(id,CHAN_WEAPON,"weapons/m249ep_shoot3.wav",1.0, ATTN_NORM, 0, PITCH_NORM)//nn�Ҹ�
		}
	}
}
public WE_Svdex(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	if(get_pdata_float(iEnt, m_flTimeWeaponIdle, 4)<0.1)
	{
		if(c_special[g_weapon[id][0]] != SPECIAL_OICW)
		{
			set_pev(id,pev_viewmodel2,g_svdex_stat[id]?"models/bte_wpn/v_svdex_2.mdl":c_model_v[g_weapon[id][0]])
		}
		else set_pev(id,pev_viewmodel2,g_svdex_stat[id]?"models/bte_wpn/v_oicw_2.mdl":c_model_v[g_weapon[id][0]])
		Stock_Send_Anim(id,0)
		set_pdata_float(iEnt, m_flTimeWeaponIdle, 7.0,4)
	}
	
	static iButton,Float:vOrigin[3],Float:vAngle[3],Float:vVelocity[3],Float:vViewOfs[3],sKillEntName[32]
	static Float:vMins[3],Float:vMaxs[3]
	vMins[0] = vMins[1] = vMins[2] = -1.0
	vMaxs[0] = vMaxs[1] = vMaxs[2] = 1.0
	iButton  = pev(id,pev_button)
	pev(id, pev_v_angle, vAngle)
	if(iButton & IN_ATTACK2)
	{
		if(g_svdex_change_timer[id] > get_gametime()) return
		g_svdex_stat[id] = 1 - g_svdex_stat[id]
		Stock_Send_Anim(id,WEAPON_TOTALANIM[iCswpn])
		set_pdata_float(iEnt,m_flNextPrimaryAttack,g_svdex_stat[id]?c_l_timechange1[g_weapon[id][0]]:c_l_timechange2[g_weapon[id][0]],4)
		set_pdata_float(iEnt, m_flTimeWeaponIdle, g_svdex_stat[id]?c_l_timechange1[g_weapon[id][0]]:c_l_timechange2[g_weapon[id][0]],4)
		g_svdex_change_timer[id] = get_gametime() + 2.0//g_svdex_stat[id]?c_l_timechange1[g_weapon[id][0]]:c_l_timechange2[g_weapon[id][0]]
		//PRINT("%f",g_svdex_stat[id]?c_l_timechange1[g_weapon[id][0]]:c_l_timechange2[g_weapon[id][0]])
		g_svdex_timer[id] = get_gametime() + 2.0 //g_svdex_stat[id]?c_l_timechange1[g_weapon[id][0]]:c_l_timechange2[g_weapon[id][0]]
		if(g_svdex_stat[id])
		{
			Stock_Send_Hide_Msg(id,1)
			MH_DrawHolesImage(id,0,1,"scope_svdex",0.5,0.55,255,255,255,0,300.0,CHANNEL_SVDEX,-1)
		}
		else
		{
			MH_DrawHolesImage(id,0,1,"scope_svdex",0.5,0.55,255,255,255,0,0.0,CHANNEL_SVDEX,-1)
			Stock_Send_Hide_Msg(id,0)
		}
		return
	}
	if(!g_svdex_stat[id]) return
	set_pdata_float(iEnt,m_flNextPrimaryAttack,1.0,4)
	if(g_svdex_timer[id] > get_gametime()) return
	
	if(iButton & IN_ATTACK)
	{
		if(!g_svdex_ammo[id]) 
		{
			set_pev(id,pev_button,iButton &~ IN_ATTACK)
			return
		}
		if(!Stock_Can_Attack(id)) return
		emit_sound(id,CHAN_WEAPON,"weapons/m79_shoot1.wav",1.0, ATTN_NORM, 0, PITCH_NORM)
		g_svdex_ammo[id] --
		MH_SendZB3Data(id,5,g_svdex_ammo[id])
		Stock_Send_Anim(id,g_svdex_ammo[id]?WEAPON_TOTALANIM[iCswpn]+LAUNCER_Anim_Shoot:WEAPON_TOTALANIM[iCswpn]+LAUNCER_Anim_ShootLast)
		g_svdex_timer[id] = get_gametime()+ c_l_timereload[g_weapon[id][0]]				
		set_pdata_float(iEnt, m_flTimeWeaponIdle, c_l_timereload[g_weapon[id][0]]+0.2,4)
		Stock_Get_Postion(id,c_l_forward[g_weapon[id][0]],c_l_right[g_weapon[id][0]],c_l_up[g_weapon[id][0]],vOrigin)
		Stock_Velocity_By_Aim(vAngle,c_l_angle[g_weapon[id][0]],c_l_speed[g_weapon[id][0]],vVelocity)
		new iProjectile = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
		format(sKillEntName,31,"d_%s",c_model[g_weapon[id][0]])
		set_pev(iProjectile, pev_classname, sKillEntName)
		Set_Ent_Data(iProjectile,DEF_ENTCLASS,ENTCLASS_NADE)
		Set_Ent_Data(iProjectile,DEF_ENTID,g_weapon[id][0])
			
		engfunc(EngFunc_SetModel, iProjectile, "models/s_grenade.mdl")
		set_pev(iProjectile, pev_mins, vMins)
		set_pev(iProjectile, pev_maxs, vMaxs)			
		set_pev(iProjectile, pev_movetype, MOVETYPE_BOUNCE)
		set_pev(iProjectile ,pev_angles,vAngle)
		set_pev(iProjectile ,pev_origin , vOrigin)
		set_pev(iProjectile, pev_gravity, c_l_gravity[g_weapon[id][0]])
		set_pev(iProjectile ,pev_velocity,vVelocity)
		set_pev(iProjectile ,pev_owner , id)
		set_pev(iProjectile,pev_solid,SOLID_BBOX)
			
		vOrigin[2] -= 10.0
		message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
		write_byte(TE_EXPLOSION)
		engfunc(EngFunc_WriteCoord, vOrigin[0])
		engfunc(EngFunc_WriteCoord, vOrigin[1])
		engfunc(EngFunc_WriteCoord, vOrigin[2])
		write_short(g_cache_musket_smoke)
		write_byte(1)
		write_byte(10)
		write_byte(TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND |TE_EXPLFLAG_NOPARTICLES)
		message_end()			
		
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
		write_byte(TE_BEAMFOLLOW)
		write_short(iProjectile)
		write_short(g_cache_trail)
		write_byte(20)
		write_byte(6)
		write_byte(224)
		write_byte(224)
		write_byte(255)
		write_byte(220)
		message_end()	
		
		set_pev(id,pev_button,iButton &~ IN_ATTACK)
		return
	}
}
//nn�Ҹ�
public WE_Balrog5(iAttacker,iVictim)
{      
    if(get_gametime()>g_bl7_timer[iAttacker]+18.00)
    {
        g_bl7_timer[iAttacker] = get_gametime()
        g_bl5_shoottime[iAttacker] = 1
        client_print(iAttacker,print_chat,"Cleaned")
    }
    else
    {
        g_bl7_timer[iAttacker] = get_gametime()
    }
	if(iVictim != g_bl5_lastVictim[iAttacker])
	{
		g_bl5_shoottime[iAttacker] = 1
		g_bl5_lastVictim[iAttacker]= iVictim
		client_print(iAttacker,print_chat,"Target changed")
		return 1.00
	}
	else
	{
		g_bl5_shoottime[iAttacker] += 1
		if(g_bl5_shoottime[iAttacker]>4)
		{
			static vOri[3]
			pev(iVictim,pev_origin,vOri)
            static iOrigin[3]
            FVecIVec(vOri,iOrigin)
            message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
			write_byte(TE_EXPLOSION)
			write_coord(floatround(vOri[0]))
			write_coord(floatround(vOri[1]))
			write_coord(floatround(vOri[2])+18)
			write_short(g_cache_barlog5exp)
			write_byte(2)
			write_byte(10)
			write_byte(0)
			message_end()		           
			 
            g_bl5_anim[iAttacker] = 1 - g_bl5_anim[iAttacker]
            Stock_Send_Anim(iAttacker,g_bl5_anim[iAttacker]?6:7)	// Fix PlayBackEvent Bug
			if(g_bl5_shoottime[iAttacker]<24)
			{
				client_print(iAttacker,print_chat,"Damage*= %f",1.00+(g_bl5_shoottime[iAttacker]-3)*0.03)
				return 1.00+(g_bl5_shoottime[iAttacker]-3)*0.03				
			}
			else
			{
                client_print(iAttacker,print_chat,"Damage*= %f",1.6)
				return 1.6
			}	
			
		}
		else
		{
			return 1.00
		}
		
	}	
}
public WE_Balrog7(id)
{
	if(g_bl7_timer[id] > get_gametime())
	{
		g_bl7_timer[id] = get_gametime() + 0.5
		g_bl7_shoottime[id] ++
		if(g_bl7_shoottime[id]>4)
		{
			if(Stock_GetProbability(g_bl7_shoottime[id]-5))
			{
				new iX = g_bl7_shoottime[id]-5
				g_bl7_shoottime[id] = 0
				
				// Explosion
				static vOri[3],Float:fVec[3],Float:vOrigin[3]
				static Float:fRadius,Float:fDistance,Float:fDamage
				fRadius=100.0
				static Float:fRadiusDmg 
				fRadiusDmg= 120.0
				get_user_origin(id,vOri,3)
				IVecFVec(vOri,fVec)
				// Damage
				new iVictim = -1
				while ((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, fVec, fRadius)) != 0)
				{
					if (!pev_valid(iVictim)) continue;
					if(iVictim == id) continue
					
					pev(iVictim, pev_origin, vOrigin)
					fDistance = get_distance_f(fVec, vOrigin)
					if(fDistance>fRadius) continue
					fDamage = fRadiusDmg - floatmul(fRadiusDmg, floatdiv(fDistance, fRadius)) //get the damage value
					fDamage *= Stock_Adjust_Damage(fVec, iVictim, 0) //adjust
					if(fDamage<1.0) fDamage = 1.0
					Pub_Fake_Damage_Guns(id,iVictim,fDamage,FAKE_TYPE_GENER_HEAD,9999.0)
				}				
				// Effect
				message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
				write_byte(TE_EXPLOSION)
				write_coord(vOri[0])
				write_coord(vOri[1])
				write_coord(vOri[2])
				write_short(g_cache_explo)
				write_byte(10)
				write_byte(16)
				write_byte(TE_EXPLFLAG_NOPARTICLES)
				message_end()
				
				message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
				write_byte(TE_EXPLOSION)
				write_coord(vOri[0])
				write_coord(vOri[1])
				write_coord(vOri[2]+20)
				write_short(g_cache_barlog7exp)
				write_byte(5)
				write_byte(1)
				write_byte(TE_EXPLFLAG_NONE)
				message_end()

				// TODO Muz
			}
		}
	}
	else
	{
		g_bl7_timer[id] = get_gametime() + 0.5
		g_bl7_shoottime[id] = 1
	}	
}
public WE_Volin(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	static iPlay[33]
	static Float:fIdle
	fIdle = get_pdata_float(iEnt, m_flTimeWeaponIdle,4)
	if(10.0<fIdle<11.0 && !iPlay[id])
	{
		iPlay[id] = 1
		Stock_Send_Anim(id, 6)
	}
	else if(fIdle<10.0 || fIdle>11.0)
	{
		iPlay[id] = 0
	}
}
public WE_Cannon(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	static iButton,Float:fOrigin[3],Float:vRec[3],Float:vStart[3],Float:vPlrAngle[3],Float:iAngle[3],iFlame,Float:vVelocity[3]
	iButton  = pev(id,pev_button)
	set_pdata_int(iEnt,m_flNextPrimaryAttack,1.0)
	if(iButton & IN_ATTACK && g_cannon_timer[id]<get_gametime() && iBpAmmo )
	{
		if(!Stock_Can_Attack(id)) return
		Pub_Shake(id)
		Stock_Weapon_ShootSound(id)
		g_cannon_timer[id] = get_gametime()+3.5
		set_pdata_float(iEnt, m_flTimeWeaponIdle, 3.5,4)
		Stock_Send_Anim(id,1)
		iBpAmmo -- 
		MH_DrawExtraAmmo(id,WEAPON_AMMOID[iCswpn])
		Stock_Config_User_Bpammo(id,iCswpn,iBpAmmo,1)
		//Stock_Send_WeaponID_Msg(id,CSW_KNIFE,-1)
		Stock_Get_Postion(id,10.0,0.0,-10.0,fOrigin)
		message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
		write_byte(TE_EXPLOSION)
		engfunc(EngFunc_WriteCoord, fOrigin[0])
		engfunc(EngFunc_WriteCoord, fOrigin[1])
		engfunc(EngFunc_WriteCoord, fOrigin[2])
		write_short(g_cache_musket_smoke)
		write_byte(1)
		write_byte(20)
		write_byte(TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND |TE_EXPLFLAG_NOPARTICLES)
		message_end()
		vRec[0] = -c_recoil[g_weapon[id][0]]
		set_pev(id,pev_punchangle,vRec)
		//Stock_Weapon_ShootSound(id)
		// Effect
		Stock_Get_Postion(id,55.0,2.0,-1.0,vStart)
		pev(id,pev_v_angle,vPlrAngle)
		vPlrAngle[1] -= 18.0
		new Float:fSpeed = 320.0
		for(new i = 0;i<6;i++)
		{
			vPlrAngle[1] += random_float(2.0,10.0)
			
			angle_vector(vPlrAngle,ANGLEVECTOR_FORWARD,vVelocity)
			xs_vec_mul_scalar(vVelocity,fSpeed,vVelocity)
			
			iFlame = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
			set_pev(iFlame, pev_origin, vStart)
			set_pev(iFlame, pev_classname, "bte_cannonflame")
			set_pev(iFlame, pev_rendermode, kRenderTransAdd)
			set_pev(iFlame, pev_renderamt, 254.0)
			
			set_pev(iFlame, pev_animtime, get_gametime())
			set_pev(iFlame,pev_frame,0.0)
			set_pev(iFlame, pev_scale, 1.6)
			engfunc(EngFunc_SetModel, iFlame, "models/cso_flame.spr")
			dllfunc(DLLFunc_Spawn, iFlame)
			iAngle[2] -= random_num(1, 360)
			iAngle[0] = random_float(-180.0,180.0)
			iAngle[1] = random_float(-180.0,180.0)
			set_pev(iFlame, pev_angles, iAngle)
			set_pev(iFlame, pev_movetype, MOVETYPE_FLY)
			set_pev(iFlame, pev_mins, Float:{-1.0, -1.0, -1.0})
			set_pev(iFlame, pev_maxs, Float:{1.0, 1.0, 1.0})
			set_pev(iFlame, pev_solid, SOLID_TRIGGER)
			Set_Ent_Data(iFlame,DEF_ENTCLASS,ENTCLASS_CANNON)
			set_pev(iFlame,pev_velocity,vVelocity)
			set_pev(iFlame, pev_owner, id)
			set_pev(iFlame,pev_ltime,get_gametime()+1.2)
			set_pev(iFlame, pev_nextthink, get_gametime()+0.05)
		}
		// Effect End
		new iVictim = -1
		while ((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vStart, 350.0)) != 0)
		{
			if (id==iVictim || !pev_valid(iVictim)) continue;
			if(iVictim>33)
			{
				if(!pev(iVictim,pev_takedamage)) continue
				if(pev(iVictim,pev_spawnflags)&SF_BREAK_TRIGGER_ONLY) continue
				Pub_Fake_Damage_Guns(id,iVictim,30.0,0,350.0,id)
			}
			else
			{
				if(!is_user_alive(iVictim)) continue
				if(get_user_team(id) == get_user_team(iVictim)) continue
				if(  Stock_BTE_CheckAngle(id,iVictim) > floatcos(float(40),degrees) && Stock_Is_Direct(id,iVictim))  // 24 degree
				{
					Stock_Fake_KnockBack(id,iVictim,floatround(c_knockback[g_weapon[id][0]]))
					if(!is_user_bot(id) && bte_hms_get_skillstat(id) & (1<<1))
					{
						Pub_Fake_Damage_Guns(id,iVictim,40.0,FAKE_TYPE_HITHEAD|FAKE_TYPE_TRACEBLEED,350.0,id)
					}
					else
					{
						Pub_Fake_Damage_Guns(id,iVictim,40.0,FAKE_TYPE_GENER_HEAD|FAKE_TYPE_TRACEBLEED,350.0,id)
					}
					//Pub_Fake_KnockBack(id,iVictim,c_knockback[g_weapon[id][0]])
				}
			}
		}
	}
	iButton&=~IN_ATTACK
	set_pev(id,pev_button,iButton)
}
public WE_Catapult(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	static iButton,Float:vAngle[3],vOrigin[3],vOri[3]
	iButton  = pev(id,pev_button)
	set_pdata_int(iEnt,m_flNextPrimaryAttack,1.0)
	
	if(!Stock_Can_Attack(id)) return
	
	
	if(iButton & IN_ATTACK && g_cp_timer[id]<get_gametime() && iBpAmmo && g_cp_stat[id] == MUSKET_IDLE)
	{
		g_cp_timer[id] = get_gametime()+0.5
		g_cp_stat[id] = MUSKET_PREFIRE
		Stock_Send_Anim(id,3)
	}
	else if(g_cp_timer[id]<get_gametime() && g_cp_stat[id] == MUSKET_PREFIRE )
	{			
		if(iButton & IN_ATTACK)
		{
			Stock_Send_Anim(id,2)
		}
		else
		{
			Pub_Shake(id)
			Stock_Weapon_ShootSound(id)
			iBpAmmo--
			MH_DrawExtraAmmo(id,WEAPON_AMMOID[iCswpn])
			pev(id,pev_origin,vOrigin)
			pev(id,pev_angles,vAngle)
			engfunc(EngFunc_PlaybackEvent, (1<<1), id, 17, 0, vOrigin, vAngle, 0.0, 0.0, 0, 0, 0, 0) // CSW_DEAGLE
			Stock_Send_Anim(id,iBpAmmo?4:5)
			g_cp_stat[id] = MUSKET_IDLE
			Stock_Config_User_Bpammo(id,iCswpn,iBpAmmo,1)			
			//Stock_Send_WeaponID_Msg(id,CSW_KNIFE,-1)
			g_cp_timer[id]= get_gametime() + c_speed[g_weapon[id][0]]
			//Stock_Weapon_ShootSound(id)
			new iEnemy,iBody
			get_user_aiming(id,iEnemy,iBody)
			Pub_Fake_Damage_Guns(id,iEnemy,80.0,FAKE_TYPE_TRACEBLEED|FAKE_TYPE_CHECKPHIT,9999.0)
			Stock_Fake_KnockBack(id,iEnemy,floatround(c_knockback[g_weapon[id][0]]))
			get_user_origin(id,vOri,3)
			message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
			write_byte(TE_EXPLOSION)
			write_coord(vOri[0])
			write_coord(vOri[1])
			write_coord(vOri[2])
			write_short(g_cache_cp_smoke)
			write_byte(8)
			write_byte(10)
			write_byte(TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND |TE_EXPLFLAG_NOPARTICLES)
			message_end()
			//recoil
			new Float:vRec[3]
			vRec[0] = -c_recoil[g_weapon[id][0]]
			set_pev(id,pev_punchangle,vRec)
		}
	}
	iButton &=~ IN_ATTACK
	set_pev(id,pev_button,iButton)
}
public WE_Skull1(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	static iButton
	iButton  = pev(id,pev_button)
	if((iButton &IN_ATTACK2) && g_skull1_timer[id] < get_gametime() && iClip)
	{
		if(!Stock_Can_Attack(id)) return
		if(!get_pdata_int(iEnt, m_fInReload, 4))
		{
			ExecuteHamB(Ham_Weapon_PrimaryAttack,iEnt)
			g_skull1_timer[id] = get_gametime() + c_speed[g_weapon[id][0]] * 0.52
			set_pdata_float(iEnt,m_flNextPrimaryAttack,c_speed[g_weapon[id][0]] * 0.52)
			g_skull1_anim[id] = 1 - g_skull1_anim[id]
			Stock_Send_Anim(id,g_skull1_anim[id]?6:7)	// Fix PlayBackEvent Bug
		}
	}		
}
public WE_Crossbow(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	static iButton,Float:fOrigin[3], Float:fVelocity[3],fAngle[3]
	iButton  = pev(id,pev_button)
	if(iButton & IN_ATTACK)
	{
		if(iClip && g_crossbow_timer[id] < get_gametime() /*&& !get_pdata_int(iEnt, m_fInReload,4)*/)
		{
			if(!Stock_Can_Attack(id)) return
			Pub_Shake(id)
			Stock_Weapon_ShootSound(id)
			iClip--
			set_pdata_int(iEnt,m_iClip,iClip,4)
			g_crossbow_timer[id] = get_gametime()+ c_speed[g_weapon[id][0]]
			Stock_Send_Anim(id, 3)
			pev(id,pev_v_angle,fAngle)
			velocity_by_aim(id, 1600, fVelocity)
			new iArrow = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
			Stock_Get_Postion(id,10.0,2.0,-3.0,fOrigin)
			set_pev(iArrow, pev_classname, "d_crossbow")
			engfunc(EngFunc_SetModel, iArrow, "models/cso_bolt.mdl")
			set_pev(iArrow, pev_angles, fAngle)
			set_pev(iArrow, pev_origin, fOrigin)
			set_pev(iArrow, pev_mins, {-1.0, -1.0, -1.0})
			set_pev(iArrow, pev_maxs, {1.0, 1.0, 1.0})
			set_pev(iArrow, pev_movetype, MOVETYPE_TOSS)
			set_pev(iArrow, pev_solid, SOLID_TRIGGER)
			set_pev(iArrow, pev_owner, id)
			set_pev(iArrow,pev_gravity,0.08)
			set_pev(iArrow,pev_velocity,fVelocity)
			Set_Ent_Data(iArrow,DEF_ENTID,g_weapon[id][0])
			Set_Ent_Data(iArrow,DEF_ENTCLASS,ENTCLASS_BOLT)
			set_pev(iArrow,pev_nextthink,get_gametime()+0.02)
			//Stock_Weapon_ShootSound(id)
		}
		iButton&=~IN_ATTACK
		set_pev(id,pev_button,iButton)
	}
}
public WE_Musket(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	static iButton,Float:vOrigin[3],Float:vAngle[3]
	iButton  = pev(id,pev_button)
	set_pdata_int(iEnt,m_flNextPrimaryAttack,1.0)
	if(!Stock_Can_Attack(id)) return	
	if(iButton & IN_ATTACK && g_musket_timer[id]<get_gametime() && iBpAmmo)
	{
		if(g_musket_stat[id] == MUSKET_IDLE)
		{
			g_musket_timer[id] = get_gametime()+0.26
			g_musket_stat[id] = MUSKET_PREFIRE
		}
		Stock_Send_Anim(id,2)
		iButton&=~IN_ATTACK
		set_pev(id,pev_button,iButton)
	}
	if(g_musket_timer[id]<get_gametime() && g_musket_stat[id] == MUSKET_PREFIRE)
	{			
		Pub_Shake(id)
		Stock_Weapon_ShootSound(id)
		iBpAmmo --
		MH_DrawExtraAmmo(id,WEAPON_AMMOID[iCswpn])
		if(!iBpAmmo) set_pdata_int(iEnt,m_iClip,0,4)
		g_musket_stat[id] = MUSKET_IDLE
		//Stock_Send_WeaponID_Msg(id,CSW_KNIFE,-1)
		Stock_Config_User_Bpammo(id,iCswpn,iBpAmmo,1)
		pev(id,pev_origin,vOrigin)
		pev(id,pev_angles,vAngle)
		engfunc(EngFunc_PlaybackEvent, (1<<1), id, 17, 0, vOrigin, vAngle, 0.0, 0.0, 0, 0, 0, 0) // CSW_DEAGLE
		g_musket_timer[id]= get_gametime() + c_speed[g_weapon[id][0]]
		//Stock_Weapon_ShootSound(id)
		Stock_Send_Anim(id,iBpAmmo?3:4)
		new iEnemy,iBody
		get_user_aiming(id,iEnemy,iBody)
		set_pdata_float(iEnt,m_flTimeWeaponIdle , 20.0,4)
		Pub_Fake_Damage_Guns(id,iEnemy,60.0,FAKE_TYPE_TRACEBLEED|FAKE_TYPE_CHECKPHIT,9999.0,1)
		Stock_Fake_KnockBack(id,iEnemy,floatround(c_knockback[g_weapon[id][0]]))
		//recoil
		new Float:vRec[3]
		vRec[0] = -10.0
		set_pev(id,pev_punchangle,vRec)
		new Float:fOrigin[3],vOri[3]
		Stock_Get_Postion(id,10.0,0.0,-10.0,fOrigin)
		message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
		write_byte(TE_EXPLOSION)
		engfunc(EngFunc_WriteCoord, fOrigin[0])
		engfunc(EngFunc_WriteCoord, fOrigin[1])
		engfunc(EngFunc_WriteCoord, fOrigin[2])
		write_short(g_cache_musket_smoke)
		write_byte(1)
		write_byte(20)
		write_byte(TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND |TE_EXPLFLAG_NOPARTICLES)
		message_end()
		iButton&=~IN_ATTACK
		set_pev(id,pev_button,iButton)
	}

}
public WE_Infinity(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	static iButton,Float:vOrigin[3],Float:vAngle[3]
	iButton  = pev(id,pev_button)

	if(!get_pdata_int(iEnt, m_fInReload, 4) && (iButton & IN_ATTACK2) && g_infinity_timer[id] < get_gametime() && iClip && (!(iButton & IN_ATTACK)))
	{
		if(!Stock_Can_Attack(id)) return
		ExecuteHam(Ham_Weapon_PrimaryAttack,iEnt)
		//set_pev(id,pev_punchangle,g_vNull)
		g_infinity_timer[id] = get_gametime() + c_speed[g_weapon[id][0]]
		
		if(g_infinity_shoottimer[id] > get_gametime())
		{
			g_infinity_shoot[id] ++
			g_infinity_shoottimer[id] = get_gametime() + c_speed[g_weapon[id][0]] + 0.2
		}
		else
		{
			g_infinity_shoottimer[id] = get_gametime() + c_speed[g_weapon[id][0]] + 0.2
			g_infinity_shoot[id]  = 1
		}
		new Float:fRecoil[3]
		if(g_infinity_shoot[id] > 5)
		{
			
			if(g_infinity_anim[id])
			{
				fRecoil[1] = -0.3 *(g_infinity_shoot[id]-8)
			}
			else fRecoil[1] = 0.3 *(g_infinity_shoot[id]-8)
			if(fRecoil[1]>2.0) fRecoil[1] = 2.0
			if(fRecoil[1]<-2.0) fRecoil[1] = -2.0	
		}
		else fRecoil[1] = 0
		set_pev(id,pev_punchangle,fRecoil)
		
		if(g_infinity_change[id])
		{
			if(g_infinity_anim[id])
			{
				Stock_Send_Anim(id,SP_shoot_left_1)
			}
			else
			{
				Stock_Send_Anim(id, SP_shoot_right_1)
			}
		}
		else
		{
			if(g_infinity_anim[id])
			{
				Stock_Send_Anim(id,SP_shoot_left_2)
			}
			else
			{
				Stock_Send_Anim(id,SP_shoot_right_2)
			}
		}
		g_infinity_anim[id] = 1-g_infinity_anim[id]	
	}
}
public WE_Melee(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	new iButton,iTempBtn,Float:fDelay,Float:iDistance,Float:fSpeed,iCallBack,sSound[128],iHit,Float: fOrigin[3], Float:fAngle[3],Float: fVelocity[3]
	iButton  = pev(id,pev_button)
	
	if(get_pdata_float(iEnt,m_flNextPrimaryAttack,4)<=0.0 || c_special[g_weapon[id][0]] == SPECIAL_SKULLAXE || c_special[g_weapon[id][0]] == SPECIAL_DRAGONTAIL)
	{
		if(c_special[g_weapon[id][0]] == SPECIAL_HAMMER ) //hammer
		{
			if((iButton&IN_ATTACK)&&g_hammer_changing[id])
			{
				iButton&=~IN_ATTACK
				set_pev(id,pev_button,iButton)
				return
			}
			else if((iButton&IN_ATTACK)&&g_hammer_stat[id]) return
			else if(iButton&IN_ATTACK2)
			{
				if(g_hammer_changing[id]) 
				{
					iButton&=~IN_ATTACK2
					set_pev(id,pev_button,iButton)
					return
				}
				g_hammer_changing[id] = 1
				set_task(c_reload[g_weapon[id][0]],"Task_HammerChange",id+TASK_HAMMER_CHANGE)
				set_pdata_float(id,m_flNextAttack,c_reload[g_weapon[id][0]])
				Stock_Send_Anim(id,8)
				iButton&=~IN_ATTACK2
				set_pev(id,pev_button,iButton)
				return
			}
			else
			{
				goto GOTO_Hammer_Attack
			}
		}
		else
		{
GOTO_Hammer_Attack:
			// Skullaxe
			if(c_special[g_weapon[id][0]] == SPECIAL_SKULLAXE)
			{
				if(g_skullaxe_stat[id] == KNIFE_IDLE && g_skullaxe_timer[id] < get_gametime()&&iButton & IN_ATTACK && get_pdata_float(iEnt,m_flNextPrimaryAttack) <=0.0)
				{
					set_pdata_float(iEnt,m_flNextPrimaryAttack,c_k_speed1[g_weapon[id][3]])
					set_pdata_float(iEnt,m_flNextSecondaryAttack,c_k_speed1[g_weapon[id][3]])
					set_pdata_float(iEnt,m_flTimeWeaponIdle,c_k_speed1[g_weapon[id][3]]+3.0)
					PlaySeqence(id,c_seq[g_weapon[id][0]]+1)
					Stock_Send_Anim(id,2)
					g_skullaxe_stat[id] = KNIFE_PRE
					g_skullaxe_timer[id] = get_gametime() + c_k_delay1[g_weapon[id][3]] //Anim = 1.0s
				}
				if(g_skullaxe_stat[id] == KNIFE_PRE && g_skullaxe_timer[id] < get_gametime())
				{
					iCallBack = Pub_Fake_Melee_Attack(id,c_k_distance1[g_weapon[id][3]],0,FAKE_STAB)
	
					if(iCallBack == FAKE_RESULT_HIT_PLAYER )
					{
						Stock_Send_Anim(id,6)
						format(sSound,127,"weapons/%s_stab.wav",c_model[g_weapon[id][3]])
					}
					else if(iCallBack == FAKE_RESULT_HIT_WALL)
					{
						Stock_Send_Anim(id,6)
						format(sSound,127,"weapons/%s_hitwall.wav",c_model[g_weapon[id][3]])
					}
					else
					{
						Stock_Send_Anim(id,7)
						format(sSound,127,"weapons/%s_miss.wav",c_model[g_weapon[id][3]])
					}
					//set_pdata_float(id,m_flNextAttack,1.2)
					g_skullaxe_stat[id] = KNIFE_CD
					g_skullaxe_timer[id] = get_gametime() + 1.2
					set_pdata_float(id,m_flNextAttack,0.2)
					engfunc(EngFunc_EmitSound, id, CHAN_WEAPON, sSound, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
				}	
				else if(g_skullaxe_timer[id] < get_gametime() && g_skullaxe_stat[id] == KNIFE_CD)
				{
					g_skullaxe_stat[id] = KNIFE_IDLE
				}
				iButton&=~IN_ATTACK
				set_pev(id,pev_button,iButton)				
			}
			else if(c_special[g_weapon[id][0]] == SPECIAL_DRAGONTAIL)
			{
				if(g_dt_level[id] > 0.0 && g_dt_level[id] < get_gametime())
				{
					g_dt_level[id] = 0
					new iEffect = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
					pev(id, pev_v_angle, fAngle)
					fAngle[0] *= -1.0
					set_pev(iEffect, pev_classname, "bte_effect")	
					if(g_dt_stat[id])
					{
						set_pev(iEffect,pev_sequence,1)
					}
					else
					{
						set_pev(iEffect,pev_sequence,0)
					}						
		
					set_pev(iEffect, pev_mins, Float:{-1.0, -1.0, -1.0})
					set_pev(iEffect, pev_maxs, Float:{1.0, 1.0, 1.0})
					Stock_Get_Postion(id,10.0,5.0,-2.0,fOrigin)
					set_pev(iEffect, pev_movetype, MOVETYPE_NOCLIP)
					engfunc(EngFunc_SetModel, iEffect, "models/bte_wpn/ef_dragontail.mdl")
					set_pev(iEffect, pev_origin, fOrigin)
					set_pev(iEffect, pev_angles, fAngle)
					set_pev(iEffect, pev_solid, SOLID_NOT)	//store the enitty id
					set_pev(iEffect, pev_owner, id)
					Set_Ent_Data(iEffect,DEF_ENTCLASS,ENTCLASS_DRAGONTAIL)
					set_pev(iEffect, pev_rendermode, kRenderTransAdd)
					set_pev(iEffect, pev_renderamt, 255.0)
					set_pev(iEffect, pev_framerate,0)
					set_pev(iEffect, pev_nextthink,get_gametime()+0.01)
					iCallBack = Pub_Fake_Melee_Attack(id,c_k_distance1[g_weapon[id][3]],0,0)
					new sSound[128]
					if(iCallBack == FAKE_RESULT_HIT_PLAYER)
					{
						format(sSound,127,"weapons/%s_stab.wav",c_model[g_weapon[id][3]])
						iHit = 1
					}
					else if(iCallBack == FAKE_RESULT_HIT_WALL)
					{
						format(sSound,127,"weapons/%s_hitwall.wav",c_model[g_weapon[id][3]])
						iHit = 1
					}
					else // FAKE_RESULT_HIT_NONE
					{
						format(sSound,127,"weapons/%s_miss.wav",c_model[g_weapon[id][3]])
					}
					engfunc(EngFunc_EmitSound, id, CHAN_WEAPON, sSound, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
					set_pev(iEffect,pev_skin,iHit?0:1)
					return
				}
			}
			if(get_pdata_float(iEnt,m_flNextPrimaryAttack,4)>0.02 || get_pdata_float(iEnt,m_flNextSecondaryAttack,4)>0.02)
			{
				return
			}
			
			if( iButton & IN_ATTACK)
			{
				iTempBtn = 1
				fDelay = c_k_delay1[g_weapon[id][3]]
				iDistance  = c_k_distance1[g_weapon[id][3]]
				fSpeed = c_k_speed1[g_weapon[id][3]]
			}
			else if(iButton&IN_ATTACK2)
			{
				iTempBtn = 2
				fDelay = c_k_delay2[g_weapon[id][3]]
				iDistance  = c_k_distance2[g_weapon[id][3]]
				fSpeed = c_k_speed2[g_weapon[id][3]]
			}
			if(c_special[g_weapon[id][0]] == SPECIAL_DRAGONTAIL)
			{
				if(get_pdata_float(iEnt, 46,4)>0.0 ||  get_pdata_float(iEnt, 47,4)>=0.0) return
			}
			if(iTempBtn && fDelay && iDistance)
			{
				PlaySeqence(id,c_seq[g_weapon[id][0]]+1)				
				new pParam[2]
				pParam[0] = id
				pParam[1] = iTempBtn
				
				//Pre Anim
				new Float:vecStart[3], Float:vecTarget[3],Float:vecViewOfs[3]
				new trRes
				pev(id, pev_origin, vecStart) 
				pev(id, pev_view_ofs, vecViewOfs) 
				xs_vec_add(vecStart, vecViewOfs, vecStart)
				new sound[128]
		
				new Float:angle[3],Float:Forw[3]
				pev(id,pev_v_angle,angle)
				engfunc(EngFunc_MakeVectors,angle)
				global_get(glb_v_forward,Forw)
				xs_vec_mul_scalar(Forw,iDistance,Forw)
				xs_vec_add(vecStart, Forw, vecTarget)
		
				engfunc(EngFunc_TraceLine, vecStart, vecTarget, 0, id, trRes)
				
				set_pdata_float(id,m_flNextAttack,fSpeed)
				set_pdata_float(iEnt,46,fSpeed)
				new pHit = get_tr2(trRes, TR_pHit)
				if(pev_valid(pHit))
				{
					if(is_user_alive(pHit))
					{
						Stock_Send_Anim(id,iTempBtn==1?random_num(6,7):4) //Stab Hit
						set_task(fDelay,"Task_Delay_Attack",id+TASK_KNIFE_DELAY,pParam,2)
					}
				}
				else
				{
					new Float:flFraction
					get_tr2(trRes, TR_flFraction, flFraction)
					if(flFraction < 1.0)
					{
						Stock_Send_Anim(id,iTempBtn==1?random_num(6,7):4) //Stab Hit
						set_task(fDelay,"Task_Delay_Attack",id+TASK_KNIFE_DELAY,pParam,2)
					}
					else
					{
						new trRes2
						engfunc(EngFunc_TraceHull, vecStart, vecTarget, 0,HULL_HEAD,id, trRes2)
						new pHit = get_tr2(trRes2, TR_pHit)
						if(pev_valid(pHit))
						{
							if(is_user_alive(pHit))
							{
								Stock_Send_Anim(id,iTempBtn==1?random_num(6,7):4) //Stab Hit
								set_task(fDelay,"Task_Delay_Attack",id+TASK_KNIFE_DELAY,pParam,2)
							}
						}
						else
						{
							new Float:flFraction
							get_tr2(trRes2, TR_flFraction, flFraction)
							if(flFraction < 1.0)
							{
								Stock_Send_Anim(id,iTempBtn==1?random_num(6,7):4) //Stab Hit
								set_task(fDelay,"Task_Delay_Attack",id+TASK_KNIFE_DELAY,pParam,2)
								//client_print(1,print_chat,"LINE YES HIT")
							}
							else
							{
								Stock_Send_Anim(id,iTempBtn==1?random_num(6,7):5) //MISS
								//client_print(1,print_chat,"HULL FAIL")
								set_task(fDelay,"Task_Delay_Attack",id+TASK_KNIFE_DELAY,pParam,2)
							}
						}
						
					}
				}
				iButton &= ~ IN_ATTACK
				iButton &= ~ IN_ATTACK2
				set_pev(id,pev_button,iButton)
			}
		}
	}
}
public WE_FlameThrower(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	static iButton,Float:vOrigin[3],Float:vAngle[3],Float:vVelocity[3],Float:vViewOfs[3],sKillEntName[32]
	iButton = pev(id,pev_button)
	pev(id, pev_v_angle, vAngle)

	if (iButton & IN_ATTACK)
	{
		iButton &= ~IN_ATTACK
		set_pev(id,pev_button,iButton &~ IN_ATTACK)	
		if(get_pdata_int(iEnt,m_flNextPrimaryAttack) >0.0) return
		if(!iClip && iBpAmmo) return
		if(!iClip && !iBpAmmo)
		{
			Stock_Send_Anim(id,WEAPON_TOTALANIM[iCswpn])
			g_wpn_flame_isshooting[id] = 0
			return
		}	
		if(!Stock_Can_Attack(id)) return
		// Loop Sound
		if(g_wpn_flame_timer[id] < get_gametime())
		{
			/*if(c_special[g_weapon[id][0]] == SPECIAL_POISON)
			{
				g_wpn_flame_timer[id] = get_gametime()+1.97
			}
			else */g_wpn_flame_timer[id] = get_gametime()+1.0
			Stock_Weapon_ShootSound(id)
			Stock_Send_Anim(id,5)
		}
		if(c_recoil[g_weapon[id][0]])
		{
			new Float:vRec[3]
			vRec[0] = random_float(-c_recoil[g_weapon[id][0]],c_recoil[g_weapon[id][0]])
			vRec[1] = random_float(-c_recoil[g_weapon[id][0]],c_recoil[g_weapon[id][0]])
			set_pev(id,pev_punchangle,vRec)
		}
		iClip--
		set_pdata_int(iEnt,m_iClip,iClip)
		set_pdata_int(iEnt,m_flNextPrimaryAttack,c_speed[g_weapon[id][0]],4)
		set_pdata_float(iEnt, m_flTimeWeaponIdle, 10.0, 4)
		g_wpn_flame_isshooting[id] = 1
		new iProjectile = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
		Set_Ent_Data(iProjectile,DEF_ENTCLASS,ENTCLASS_FLAME)
		Set_Ent_Data(iProjectile,DEF_ENTID,g_weapon[id][0])
		Stock_Get_Postion(id,c_l_forward[g_weapon[id][0]],c_l_right[g_weapon[id][0]],c_l_up[g_weapon[id][0]],vOrigin)
		Stock_Velocity_By_Aim(vAngle,c_l_angle[g_weapon[id][0]],c_l_speed[g_weapon[id][0]],vVelocity)
		
		format(sKillEntName,31,"d_%s",c_model[g_weapon[id][0]])
		set_pev(iProjectile, pev_classname, sKillEntName)
		dllfunc(DLLFunc_Spawn, iProjectile)
		engfunc(EngFunc_SetSize,iProjectile,{0,0,0},{0,0,0})
		set_pev(iProjectile, pev_animtime, get_gametime())
		set_pev(iProjectile, pev_framerate, 1.0)
		vAngle[0] = random_float(-180.0,180.0)
		vAngle[1] = random_float(-180.0,180.0)
		vAngle[2] = random_float(-180.0,180.0)
		set_pev(iProjectile ,pev_angles,vAngle)
		set_pev(iProjectile, pev_movetype, MOVETYPE_FLY)		
		set_pev(iProjectile, pev_frame, 1.0)
		set_pev(iProjectile, pev_scale, 0.1)
		
		set_pev(iProjectile, pev_rendermode, kRenderTransAdd)
		set_pev(iProjectile, pev_renderamt, 254.0)
		if(c_special[g_weapon[id][0]] == SPECIAL_POISON)
		{
			engfunc(EngFunc_SetModel, iProjectile, "sprites/ef_smoke_poison.spr")
			if(g_wpn_poison_lighttimer[id] < get_gametime())
			{
				static Float:v2[3]
				Stock_Get_Postion(id,140.0,0,0,v2)
				static viOrigin[3]
				FVecIVec(v2,viOrigin)
				// Nightvision message
				message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, id)
				write_byte(TE_DLIGHT) // TE id
				write_coord(viOrigin[0]) // x
				write_coord(viOrigin[1]) // y
				write_coord(viOrigin[2]) // z
				write_byte(18)
				write_byte(50) 
				write_byte(255)
				write_byte(50)
				write_byte(10)
				write_byte(0)
				message_end()
				g_wpn_poison_lighttimer[id] = get_gametime() + 0.1
			}
		}
		else engfunc(EngFunc_SetModel, iProjectile, "models/cso_flame.spr")
		set_pev(iProjectile, pev_mins, Float:{0, 0, 0})
		set_pev(iProjectile, pev_maxs,	Float:{0, 0, 0})
		set_pev(iProjectile, pev_origin, vOrigin)
		static Float:vVel[3]
		pev(id,pev_velocity,vVel)
		vVel[0] *=0.95
		vVel[1] *=0.95
		vVel[2] *=0.95
		xs_vec_add(vVel,vVelocity,vVelocity)
		set_pev(iProjectile, pev_velocity, vVelocity)
		set_pev(iProjectile,pev_solid,SOLID_TRIGGER)
		set_pev(iProjectile, pev_owner, id)
		set_pev(iProjectile, pev_nextthink, get_gametime()+0.05)
		// Search Enemy
		static iEnemy,iBody
		get_user_aiming(id,iEnemy,iBody,380.0)
		if(iEnemy)
		{
			if(!is_user_bot(id) && bte_hms_get_skillstat(id) & (1<<1))
			{
				Pub_Fake_Damage_Guns(id,iEnemy,40.0,FAKE_TYPE_HITHEAD|FAKE_TYPE_TRACEBLEED,380.0,id)
			}
			else Pub_Fake_Damage_Guns(id,iEnemy,40.0,FAKE_TYPE_TRACEBLEED|FAKE_TYPE_GENER_HEAD,380.0,id)
		}
	}
	else if( g_wpn_flame_isshooting[id] )
	{
		Stock_Send_Anim(id,WEAPON_TOTALANIM[iCswpn])
		g_wpn_flame_isshooting[id] = 0
	}	
	iButton &= ~IN_ATTACK
	set_pev(id,pev_button,iButton &~ IN_ATTACK)	
}
public WE_Bazooka(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	static iButton,Float:vOrigin[3],Float:vAngle[3],Float:vVelocity[3],Float:vViewOfs[3],sKillEntName[32]
	static Float:vMins[3],Float:vMaxs[3]
	vMins[0] = vMins[1] = vMins[2] = -1.0
	vMaxs[0] = vMaxs[1] = vMaxs[2] = 1.0
	iButton = pev(id,pev_button)
	pev(id, pev_v_angle, vAngle)
	
	if (iButton & IN_ATTACK)
	{
		iButton &= ~IN_ATTACK
		set_pev(id,pev_button,iButton &~ IN_ATTACK)	
		
		if(get_pdata_float(id, m_flNextAttack) > 0.0 || !iClip) return
		if(!Stock_Can_Attack(id)) return
		Stock_Weapon_ShootSound(id)
		Pub_Shake(id)
		if(c_recoil[g_weapon[id][0]])
		{
			new Float:vRec[3]
			vRec[0] = c_recoil[g_weapon[id][0]]
			set_pev(id,pev_punchangle,vRec)
		}
		PlaySeqence(id,c_seq[g_weapon[id][0]]+1)
		iClip--
		set_pdata_int(iEnt,m_iClip,iClip)
		set_pdata_float(id, m_flNextAttack,c_speed[g_weapon[id][0]])
		set_pdata_int(iEnt,m_flNextPrimaryAttack,c_speed[g_weapon[id][0]],4)
		set_pdata_float(iEnt, m_flTimeWeaponIdle, c_speed[g_weapon[id][0]], 4)
		Stock_Send_Anim(id,1)
		
		new iProjectile = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
		
		format(sKillEntName,31,"d_%s",c_model[g_weapon[id][0]])
		set_pev(iProjectile, pev_classname, sKillEntName)
		set_pev(iProjectile, pev_mins, vMins)
		set_pev(iProjectile, pev_maxs,	vMaxs)
		set_pev(iProjectile ,pev_angles,vAngle)
		set_pev(iProjectile, pev_movetype, MOVETYPE_FLY)
		Set_Ent_Data(iProjectile,DEF_ENTCLASS,ENTCLASS_NADE)
		Set_Ent_Data(iProjectile,DEF_ENTID,g_weapon[id][0])
		Stock_Get_Postion(id,c_l_forward[g_weapon[id][0]],c_l_right[g_weapon[id][0]],c_l_up[g_weapon[id][0]],vOrigin)
		Stock_Velocity_By_Aim(vAngle,c_l_angle[g_weapon[id][0]],c_l_speed[g_weapon[id][0]],vVelocity)
		if(c_special[g_weapon[id][0]] == SPECIAL_BAZOOKA) 
		{
			engfunc(EngFunc_SetModel, iProjectile, "models/s_grenade_spark.mdl")
		}
		else engfunc(EngFunc_SetModel, iProjectile, "models/s_grenade.mdl")
		set_pev(iProjectile, pev_origin, vOrigin)
		set_pev(iProjectile, pev_velocity, vVelocity)

		set_pev(iProjectile, pev_solid, SOLID_BBOX)	//store the enitty id
		set_pev(iProjectile, pev_owner, id)
		if(c_l_lighteffect[g_weapon[id][0]]) set_pev(iProjectile,pev_effects, EF_LIGHT)
		
		//拖尾效果
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
		write_byte(TE_BEAMFOLLOW)
		write_short(iProjectile)
		write_short(g_cache_trail)
		write_byte(20)
		write_byte(6)
		write_byte(224)
		write_byte(224)
		write_byte(255)
		write_byte(220)
		message_end()		
		//
		//枪口烟雾
		vOrigin[2] -= 10.0
		message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
		write_byte(TE_EXPLOSION)
		engfunc(EngFunc_WriteCoord, vOrigin[0])
		engfunc(EngFunc_WriteCoord, vOrigin[1])
		engfunc(EngFunc_WriteCoord, vOrigin[2])
		write_short(g_cache_musket_smoke)
		write_byte(1)
		write_byte(10)
		write_byte(TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND |TE_EXPLFLAG_NOPARTICLES)
		message_end()
		
		if(c_special[g_weapon[id][0]] == SPECIAL_AT4CS)
		{
			for(new i=1 ;i <33;i++)
			{
				if(Pub_Get_Player_Zoom(id) && i!=id && is_user_alive(i) && Stock_BTE_CheckAngle(id,i)>floatcos(9.0,degrees) && Stock_Is_Direct(id,i))
				{
					Set_Ent_Data(iProjectile,DEF_ENTSTAT,i)
					set_pev(iProjectile,pev_nextthink,get_gametime()+0.1)
					break
				}
			}
		}
	}
}
public WE_Launcher(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	static iButton,Float:vOrigin[3],Float:vAngle[3],Float:vVelocity[3],Float:vViewOfs[3],sKillEntName[32]
	static Float:vMins[3],Float:vMaxs[3]
	vMins[0] = vMins[1] = vMins[2] = -1.0
	vMaxs[0] = vMaxs[1] = vMaxs[2] = -1.0
	iButton = pev(id,pev_button)
	pev(id, pev_v_angle, vAngle)
	
	set_pdata_int(iEnt,m_flNextPrimaryAttack,1.0)
	set_pdata_float(iEnt, m_flTimeWeaponIdle, 1.0, 4)
	if(iButton & IN_ATTACK || (c_special[g_weapon[id][0]] == SPECIAL_FIRECRAKER && iButton & IN_ATTACK2))
	{
		if(g_wpn_launcher_timer[id]<get_gametime())
		{
			if(!iBpAmmo) 
			{
				set_pev(id,pev_button,iButton &~ IN_ATTACK)
				return
			}
			if(!Stock_Can_Attack(id)) return
			Pub_Shake(id)
			Stock_Weapon_ShootSound(id)
			iBpAmmo --
			MH_DrawExtraAmmo(id,WEAPON_AMMOID[iCswpn])
			Stock_Config_User_Bpammo(id,iCswpn,iBpAmmo,1)
			Stock_Send_Anim(id,iBpAmmo?WEAPON_TOTALANIM[iCswpn]+LAUNCER_Anim_Shoot:WEAPON_TOTALANIM[iCswpn]+LAUNCER_Anim_ShootLast)
			g_wpn_launcher_timer[id] = get_gametime()+ c_l_timereload[g_weapon[id][0]]				
			Stock_Get_Postion(id,c_l_forward[g_weapon[id][0]],c_l_right[g_weapon[id][0]],c_l_up[g_weapon[id][0]],vOrigin)
			Stock_Velocity_By_Aim(vAngle,c_l_angle[g_weapon[id][0]],c_l_speed[g_weapon[id][0]],vVelocity)
			new iProjectile = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
			format(sKillEntName,31,"d_%s",c_model[g_weapon[id][0]])
			set_pev(iProjectile, pev_classname, sKillEntName)
			Set_Ent_Data(iProjectile,DEF_ENTCLASS,ENTCLASS_NADE)
			Set_Ent_Data(iProjectile,DEF_ENTID,g_weapon[id][0])
				
			if(c_special[g_weapon[id][0]] == SPECIAL_FIRECRAKER)
			{
				engfunc(EngFunc_SetModel, iProjectile, "models/s_grenade_spark.mdl")
				Stock_TE_Sprits(id, vOrigin, g_cache_firecraker_muzzle, 3, 200)
				client_cmd(id,"spk weapons/firecracker-wick.wav")
			}
			else engfunc(EngFunc_SetModel, iProjectile, "models/s_grenade.mdl")
			if(c_special[g_weapon[id][0]] == SPECIAL_FIRECRAKER && (iButton & IN_ATTACK2)) 
			{
				Set_Ent_Data(iProjectile,DEF_ENTSTAT,1)
				set_pev(iProjectile,pev_nextthink,get_gametime()+2.0)
			}
			set_pev(iProjectile, pev_mins, vMins)
			set_pev(iProjectile, pev_maxs, vMaxs)
			//engfunc(EngFunc_SetSize,iProjectile, vMins,vMaxs)
			
			set_pev(iProjectile, pev_movetype, MOVETYPE_BOUNCE)
			set_pev(iProjectile ,pev_angles,vAngle)
			set_pev(iProjectile ,pev_origin , vOrigin)
			set_pev(iProjectile, pev_gravity, c_l_gravity[g_weapon[id][0]])
			set_pev(iProjectile ,pev_velocity,vVelocity)
			set_pev(iProjectile ,pev_owner , id)
			set_pev(iProjectile,pev_solid,SOLID_BBOX)
				
			//枪口烟雾
			vOrigin[2] -= 10.0
			message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
			write_byte(TE_EXPLOSION)
			engfunc(EngFunc_WriteCoord, vOrigin[0])
			engfunc(EngFunc_WriteCoord, vOrigin[1])
			engfunc(EngFunc_WriteCoord, vOrigin[2])
			write_short(g_cache_musket_smoke)
			write_byte(1)
			write_byte(10)
			write_byte(TE_EXPLFLAG_NODLIGHTS | TE_EXPLFLAG_NOSOUND |TE_EXPLFLAG_NOPARTICLES)
			message_end()
			//拖尾效果
			message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
			write_byte(TE_BEAMFOLLOW)
			write_short(iProjectile)
			write_short(g_cache_trail)
			write_byte(c_special[g_weapon[id][0]] == SPECIAL_M79 ? 30 : 30) // 5
			write_byte(6)
			write_byte(c_special[g_weapon[id][0]] == SPECIAL_FIRECRAKER?255:224)
			write_byte(c_special[g_weapon[id][0]] == SPECIAL_FIRECRAKER?110:224)
			write_byte(c_special[g_weapon[id][0]] == SPECIAL_FIRECRAKER?110:255)
			write_byte(220)
			message_end()
			
			set_pev(id,pev_button,iButton &~ IN_ATTACK)
			
			return
		}
	}
}				
public WE_M134(id,iEnt,iClip,iBpAmmo,iCswpn)
{
	static iButton,iFireing
	iButton = pev(id,pev_button)
	if(!Stock_Can_Attack(id)) return

	if(iButton & IN_ATTACK)
	{
		//静止
		iFireing = 0
		if(!iClip && g_wpn_m134_stat[id] == M134_SPINNING) //没子弹的情况
		{
			Pub_Set_MaxSpeed(id,c_gravity[g_weapon[id][0]])
			Stock_Send_Anim(id,WEAPON_TOTALANIM[iCswpn] + M134_Anim_FireAfter)
			set_pdata_int(iEnt,m_flNextPrimaryAttack,1.0) 
			g_wpn_m134_timer[id] = get_gametime()+1.0
			set_pdata_float(iEnt, m_flTimeWeaponIdle, 1.0, 4)
			g_wpn_m134_stat[id] = M134_IDLE
			set_pev(id,pev_button,(iButton & ~ IN_ATTACK))
		}
		if(g_wpn_m134_stat[id] == M134_IDLE)
		{
			if(g_wpn_m134_timer[id] <= get_gametime() && iClip)
			{
				Pub_Set_MaxSpeed(id,c_gravity[g_weapon[id][0]]*0.4)
				Stock_Send_Anim(id,WEAPON_TOTALANIM[iCswpn] + M134_Anim_FireReady)
				set_pdata_float(iEnt, m_flTimeWeaponIdle, 2.0, 4)
				set_pdata_int(iEnt,m_flNextPrimaryAttack,1.0) //预热是2.0秒
				g_wpn_m134_timer[id] = get_gametime()+1.0
				g_wpn_m134_stat[id] = M134_SPIN_UP
				set_pev(id,pev_button,(iButton & ~ IN_ATTACK))
			}
		}
		if(g_wpn_m134_stat[id] == M134_SPIN_UP && g_wpn_m134_timer[id] < get_gametime())
		{
			// 射射射
			Pub_Set_MaxSpeed(id,c_gravity[g_weapon[id][0]]*0.4)
			g_wpn_m134_stat[id] = M134_SPINNING
			iFireing = 1
		}
		if(g_wpn_m134_stat[id] == M134_SPIN_DOWN && iClip)
		{
			// Nice 重新振作起来
			Pub_Set_MaxSpeed(id,c_gravity[g_weapon[id][0]]*0.4)
			Stock_Send_Anim(id,WEAPON_TOTALANIM[iCswpn] + M134_Anim_FireChange)
			set_pdata_int(iEnt,m_flNextPrimaryAttack,1.0)
			set_pdata_float(iEnt, m_flTimeWeaponIdle, 1.0, 4)
			g_wpn_m134_timer[id] = get_gametime()+1.0 // 1.0秒后就可以射了
			g_wpn_m134_stat[id] = M134_SPIN_UP
			set_pev(id,pev_button,(iButton & ~ IN_ATTACK))
		}
	}
	else if(!(iButton & IN_ATTACK2))
	{
		//情况1 在预热发射前放弃预热
		if(g_wpn_m134_stat[id] == M134_SPIN_UP)
		{
			Pub_Set_MaxSpeed(id,c_gravity[g_weapon[id][0]])
			Stock_Send_Anim(id,WEAPON_TOTALANIM[iCswpn] + M134_Anim_IdleChange)
			set_pdata_int(iEnt,m_flNextPrimaryAttack,1.5) // 1.5秒内无法预热
			g_wpn_m134_timer[id] = get_gametime()+1.5
			set_pdata_float(iEnt, m_flTimeWeaponIdle, 1.5, 4)
			g_wpn_m134_stat[id] = M134_IDLE
			set_pev(id,pev_button,(iButton & ~ IN_ATTACK))
		}
		// 情况2 在发射的时候停止
		if(g_wpn_m134_stat[id] == M134_SPINNING)
		{
			Pub_Set_MaxSpeed(id,c_gravity[g_weapon[id][0]])
			Stock_Send_Anim(id,WEAPON_TOTALANIM[iCswpn] + M134_Anim_FireAfter)
			set_pdata_int(iEnt,m_flNextPrimaryAttack,1.0) // 给你1.0秒的时间重新启动
			g_wpn_m134_timer[id] = get_gametime()+1.0
			set_pdata_float(iEnt, m_flTimeWeaponIdle, 1.0, 4)
			g_wpn_m134_stat[id] = M134_SPIN_DOWN
			set_pev(id,pev_button,(iButton & ~ IN_ATTACK))
		}
		if(g_wpn_m134_stat[id] == M134_SPIN_DOWN && g_wpn_m134_timer[id] < get_gametime())
		{
			Pub_Set_MaxSpeed(id,c_gravity[g_weapon[id][0]])
			// 1.3秒已过 没机会了 只能重新启动
			g_wpn_m134_stat[id] = M134_IDLE
			set_pev(id,pev_button,(iButton & ~ IN_ATTACK))
		}
	}
	else if(c_special[g_weapon[id][0]] == SPECIAL_M134EX)
	{
		if(iButton & IN_ATTACK2 && iClip)
		{
			if(g_wpn_m134_stat[id] == M134_IDLE)
			{
				if(g_wpn_m134_timer[id] <= get_gametime() && iClip)
				{
					Pub_Set_MaxSpeed(id,c_gravity[g_weapon[id][0]]*0.4)
					set_pdata_float(iEnt, m_flTimeWeaponIdle, 50.0, 4)
					Stock_Send_Anim(id,WEAPON_TOTALANIM[iCswpn] + M134_Anim_FireReady)
					set_pdata_int(iEnt,m_flNextPrimaryAttack,2.0) //预热是2.0秒
					g_wpn_m134_timer[id] = get_gametime()+2.0
					g_wpn_m134_stat[id] = M134_SPIN_UP
					set_pev(id,pev_button,(iButton & ~ IN_ATTACK2))
				}
			}
			if( (g_wpn_m134_stat[id] == M134_SPINNING && iFireing) || (g_wpn_m134_stat[id] != M134_IDLE  && g_wpn_m134_timer[id] < get_gametime()))
			{
				// 射射射
				Pub_Set_MaxSpeed(id,c_gravity[g_weapon[id][0]]*0.4)
				set_pdata_float(iEnt, m_flTimeWeaponIdle, 50.0, 4)
				g_wpn_m134_timer[id] = get_gametime() + 1.0
				g_wpn_m134_stat[id] = M134_SPINNING
				Stock_Send_Anim(id,WEAPON_TOTALANIM[iCswpn] + M134_Anim_FireChange)
				set_pev(id,pev_button,(iButton & ~ IN_ATTACK2))
			}
		}
		iFireing = 0
	}
}
public WE_M32(id,iEnt,iClip,iAmmo,iCswpn)
{
	static iButton
	iButton  = pev(id,pev_button)
	if(iButton&IN_RELOAD && get_pdata_int(iEnt,m_flNextPrimaryAttack) < 0.1 && !g_m32_reload[id])
	{
		set_pev(id,pev_button,(iButton & ~ IN_RELOAD))		
		g_m32_reload[id] = 1
	}
	else if(!iClip && iAmmo && get_pdata_int(iEnt,m_flNextPrimaryAttack) < 0.1 && !g_m32_reload[id]) g_m32_reload[id] =1

	if(iAmmo && iClip < c_clip[g_weapon[id][0]] && get_pdata_int(iEnt,m_flNextPrimaryAttack) < 0.1 && g_m32_reload[id] ==1)
	{
		// Start Reload
		set_pdata_float(iEnt,m_flTimeWeaponIdle,10.0)
		g_m32_reload[id] = 2
		set_pdata_float(iEnt,m_flNextPrimaryAttack,0.7)
		set_pdata_float(iEnt,m_flNextSecondaryAttack,0.7)
		Stock_Send_Anim(id,5)
	}
	if(g_m32_reload[id] == 2 &&get_pdata_int(iEnt,m_flNextPrimaryAttack) < 0.1 && iAmmo && iClip < c_clip[g_weapon[id][0]])
	{
		set_pdata_float(iEnt,m_flNextPrimaryAttack,0.9)
		set_pdata_float(iEnt,m_flNextSecondaryAttack,0.5)
		g_m32_reload[id] = 3
		Stock_Send_Anim(id,3)
	}
	if(g_m32_reload[id] == 3 && get_pdata_int(iEnt,m_flNextPrimaryAttack) < 0.1)
	{
		iClip ++
		iAmmo --
		set_pdata_int(iEnt,m_iClip,iClip)
		Stock_Config_User_Bpammo(id,c_wpnchange[g_weapon[id][0]] , iAmmo,1)
		g_m32_reload[id] = 2
	}
	if( (!iAmmo|| iClip == c_clip[g_weapon[id][0]]) && g_m32_reload[id] == 2)
	{
		g_m32_reload[id] = 0
		Stock_Send_Anim(id,4)
		set_pdata_float(iEnt,m_flNextPrimaryAttack,0.8)
		set_pdata_float(iEnt,m_flNextSecondaryAttack,0.9)
	}		
	if (iButton & IN_ATTACK)
	{
		if(get_pdata_int(iEnt,m_flNextSecondaryAttack) > 0.0 || !iClip || g_freezetime) return
		
		Stock_Weapon_ShootSound(id)
		new Float:vRec[3]
		vRec[0] = -15.0
		set_pev(id,pev_punchangle,vRec)
		Stock_Send_Anim(id,2)	
		g_m32_reload[id] =0
		Pub_Reset_Zoom(id)
		
		new Float: fOrigin[3], Float:fAngle[3],Float: fVelocity[3],sKillEntName[32]
		pev(id, pev_v_angle, fAngle)
		set_pdata_float(iEnt,m_flNextPrimaryAttack,c_speed[g_weapon[id][0]])
		set_pdata_float(iEnt,m_flNextSecondaryAttack,c_speed[g_weapon[id][0]])
		
		new iProjectile = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
		format(sKillEntName,31,"d_%s",c_model[g_weapon[id][0]])
		set_pev(iProjectile, pev_classname, sKillEntName)
		engfunc(EngFunc_SetModel, iProjectile, "models/s_grenade.mdl")
		set_pev(iProjectile, pev_mins, Float:{-1.0, -1.0, -1.0})
		set_pev(iProjectile, pev_maxs, Float:{1.0, 1.0, 1.0})
		
		Stock_Get_Postion(id,c_l_forward[g_weapon[id][0]],c_l_right[g_weapon[id][0]],c_l_up[g_weapon[id][0]],fOrigin)
		Stock_Velocity_By_Aim(fAngle,c_l_angle[g_weapon[id][0]],c_l_speed[g_weapon[id][0]],fVelocity)
		set_pev(iProjectile, pev_movetype, MOVETYPE_BOUNCE)
		
		iClip--
		set_pdata_int(iEnt,m_iClip,iClip)

		set_pev(iProjectile, pev_origin, fOrigin)
		set_pev(iProjectile, pev_velocity, fVelocity)
		set_pev(iProjectile,pev_gravity,c_l_gravity[g_weapon[id][0]])
		set_pev(iProjectile, pev_angles, fAngle)
		set_pev(iProjectile, pev_solid, SOLID_BBOX)	//store the enitty id
		set_pev(iProjectile, pev_owner, id)
		Set_Ent_Data(iProjectile,DEF_ENTCLASS,ENTCLASS_NADE)
		Set_Ent_Data(iProjectile,DEF_ENTID,g_weapon[id][0])
		message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
		write_byte(TE_BEAMFOLLOW)
		write_short(iProjectile)
		write_short(g_cache_trail)
		write_byte(7)
		write_byte(6)
		write_byte(224)
		write_byte(224)
		write_byte(255)
		write_byte(220)
		message_end()
	}
	iButton & ~ IN_ATTACK
	iButton & ~ IN_RELOAD
	set_pev(id,pev_button,iButton)		
}