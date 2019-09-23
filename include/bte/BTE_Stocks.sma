// [BTE STOCK FUNCTION]
stock Stock_Set_Kvd(entity, const key[], const value[], const classname[])
{
	set_kvd(0, KV_ClassName, classname)
	set_kvd(0, KV_KeyName, key)
	set_kvd(0, KV_Value, value)
	set_kvd(0, KV_fHandled, 0)

	dllfunc(DLLFunc_KeyValue, entity, 0)
}
stock Stock_FireCracker_Effect(Float:vOrigin[3],Float:vColor[3])
{
	new iEntity = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "env_sprite"))
	Stock_Set_Kvd(iEntity,"model","sprites/spark1.spr","cycle_sprite")
	Stock_Set_Kvd(iEntity,"framerate","15.0","cycle_sprite")
	set_pev(iEntity,pev_spawnflags,SF_SPRITE_ONCE)
	dllfunc(DLLFunc_Spawn,iEntity)
	set_pev(iEntity,pev_scale,0.7)
	set_pev(iEntity,pev_rendercolor,vColor)
	set_pev(iEntity, pev_rendermode, kRenderTransAdd)
	set_pev(iEntity, pev_renderamt, 255.0)
	set_pev(iEntity,pev_origin,vOrigin)
}
stock Stock_SetRendering(entity, fx = kRenderFxNone, r = 255, g = 255, b = 255, render = kRenderNormal, amount = 16)
{
	static Float:color[3]
	color[0] = float(r)
	color[1] = float(g)
	color[2] = float(b)
	
	set_pev(entity, pev_renderfx, fx)
	set_pev(entity, pev_rendercolor, color)
	set_pev(entity, pev_rendermode, render)
	set_pev(entity, pev_renderamt, float(amount))
}
public Stock_Fake_KnockBack(id,iVic,iKb)
{
	if(0<id<33)
	{
		if(get_user_team(id) == get_user_team(iVic))
		return
	}
	new Float:vAttacker[3],Float:vVictim[3],Float:vVelocity[3]
	pev(id,pev_origin,vAttacker)
	pev(iVic,pev_origin,vVictim)
	
	xs_vec_sub(vVictim, vAttacker, vVictim)
	
	pev(iVic,pev_velocity,vVelocity)
	xs_vec_mul_scalar(vVictim, float(iKb), vVictim)
	
	xs_vec_add(vVelocity, vVictim, vVelocity)
	set_pev(iVic,pev_velocity,vVelocity)
}
stock Stock_Send_WeaponID_Msg(id,iCswpn,iClip)
{
	if(is_user_connected(id))
	{
		message_begin(MSG_ONE_UNRELIABLE,g_msgCurWeapon,_,id)
		write_byte(1)
		write_byte(iCswpn)
		write_short(iClip)
		message_end()
	}
}
stock Stock_Send_Hide_Msg(id,iHide)
{
	message_begin(MSG_ONE_UNRELIABLE, g_msgHideWeapon, _, id)
	write_byte((iHide == 1)?(1<<6):0)
	message_end()
}
stock Stock_Can_Attack(id)
{
	if(g_freezetime) return 0
	else return 1
}
stock Stock_Weapon_ShootSound(id)
{
    client_print(id,print_chat,"sb")
	emit_sound(id,CHAN_WEAPON,g_double[id][0]?c_sound2[g_weapon[id][0]]:c_sound1[g_weapon[id][0]],1.0, ATTN_NORM, 0, PITCH_NORM)
}
stock Stock_M134Shell(id)
{
	if(g_m134_shelltime[id]+0.2>get_gametime()) return
	g_m134_shelltime[id]=get_gametime()
	
	message_begin(MSG_ONE_UNRELIABLE, g_msgScreenShake, _, id)
	write_short((1<<12)*6) 
	write_short((1<<12)*3) 
	write_short((1<<12)*13) 
	message_end()
		
	new Float:vecOrigin[3],Float:vecVelocity[3],Float:vecO2[3],Float:vecStart[3]
	new i=random_num(0,1)
	Stock_Get_Postion(id,14.0,5.0,10.0,vecStart)
	Stock_Get_Postion(id,16.0,i?random_float(-12.0,-7.0):random_float(12.0,7.0),-8.0,vecO2)
	Stock_Get_Postion(id,16.0,i?random_float(6.0,10.0):random_float(-10.0,-6.0),10.0,vecOrigin)
	
	Stock_Get_Speed_Vector(vecO2,vecOrigin,130.0, vecVelocity)
		
	engfunc(EngFunc_MessageBegin, MSG_BROADCAST, SVC_TEMPENTITY, vecStart, 0);
	write_byte(TE_MODEL);
	engfunc(EngFunc_WriteCoord, vecStart[0]);
	engfunc(EngFunc_WriteCoord, vecStart[1]);
	engfunc(EngFunc_WriteCoord, vecStart[2]);
	engfunc(EngFunc_WriteCoord, vecVelocity[0]);
	engfunc(EngFunc_WriteCoord, vecVelocity[1]);
	engfunc(EngFunc_WriteCoord, vecVelocity[2]);
	engfunc(EngFunc_WriteAngle, random_float(10.0, 60.0));
	write_short(g_cache_m134shell);
	write_byte( 1);
	write_byte ( 35 );
	message_end();
}
stock Stock_GetProbability(iMax) // 0-10
{
	if(iMax>=random_num(1,10)) return 1
	return 0	
}
stock Stock_TE_Sprits(id, Float:origin[3], sprite, scale, brightness)
{	
	message_begin(MSG_ONE, SVC_TEMPENTITY, _, id)
	write_byte(TE_SPRITE)
	write_coord(floatround(origin[0]))
	write_coord(floatround(origin[1]))
	write_coord(floatround(origin[2]))
	write_short(sprite)
	write_byte(scale) 
	write_byte(brightness)
	message_end()
}
stock Stock_SfSniperTracer(const Float:Source[ 3 ], const Float:Velocity[ 3 ],Float:fLife)
{
	new iProjectile = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "info_target"))
	set_pev(iProjectile, pev_classname, "Tracer")
	set_pev(iProjectile,pev_origin,Source)
	Set_Ent_Data(iProjectile,DEF_ENTCLASS,ENTCLASS_KILLME)

	set_pev(iProjectile, pev_movetype, MOVETYPE_NOCLIP)

	engfunc(EngFunc_SetModel, iProjectile, "models/bte_wpn/v_usp.mdl")
	set_pev(iProjectile, pev_origin, Source)
	set_pev(iProjectile, pev_velocity, Velocity)
	set_pev(iProjectile,pev_nextthink,get_gametime()+1.0)
	
	Stock_SetRendering(iProjectile, kRenderFxGlowShell, 0, 0, 0, kRenderTransAlpha, 0)
	
	//set_pev(iProjectile,pev_ltime,fLife)
	
	//拖尾效果
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
	write_byte(TE_BEAMFOLLOW)
	write_short(iProjectile)
	write_short(g_cache_trail)
	write_byte(20)
	write_byte(3)
	write_byte(0)
	write_byte(0)
	write_byte(255)
	write_byte(255)
	message_end()	
/*
 	message_begin( MSG_BROADCAST, SVC_TEMPENTITY )
	write_byte(TE_BEAMFOLLOW)
	write_short(ent)				//entity
	write_short(sprites_trail_index)		//model
	write_byte(5)		//10)//life
	write_byte(3)		//5)//width
	write_byte(209)					//r, hegrenade
	write_byte(120)					//g, gas-grenade
	write_byte(9)					//b
	write_byte(200)		//brightness
	message_end()					//move PHS/PVS data sending into here (SEND_ALL, SEND_PVS, SEND_PHS)
*/	
}
stock Stock_UserTracer ( const Float:Source[ 3 ], const Float:Velocity[ 3 ], Life, Color, Length )
{
	message_begin( MSG_BROADCAST, SVC_TEMPENTITY);
	write_byte( TE_USERTRACER );
	write_coord_f( Source[ 0 ] );
	write_coord_f( Source[ 1 ] );
	write_coord_f( Source[ 2 ] );
	write_coord_f( Velocity[ 0 ] );
	write_coord_f( Velocity[ 1 ] );
	write_coord_f( Velocity[ 2 ] );
	write_byte( Life * 10 );
	write_byte( Color );
	write_byte( Length );
	message_end();
}
stock Stock_Check_Back(iEnemy,id)
{
	new Float:anglea[3], Float:anglev[3]
	pev(iEnemy, pev_v_angle, anglea)
	pev(id, pev_v_angle, anglev)
	new Float:angle = anglea[1] - anglev[1] 
	if(angle < -180.0) angle += 360.0
	if(angle <= 60.0 && angle >= -60.0) return 1
	return 0
}
stock Stock_Aim_At_Origin(id, Float:target[3], Float:angles[3])
{
	static Float:vec[3]
	pev(id,pev_origin,vec)
	vec[0] = target[0] - vec[0]
	vec[1] = target[1] - vec[1]
	vec[2] = target[2] - vec[2]
	engfunc(EngFunc_VecToAngles,vec,angles)
	angles[0] *= -1.0, angles[2] = 0.0
}
stock Stock_Ent_Move_To(ent, Float:target[3], speed)
{
	// set vel
	static Float:vec[3]
	Stock_Aim_At_Origin(ent,target,vec)
	engfunc(EngFunc_MakeVectors, vec)
	global_get(glb_v_forward, vec)
	vec[0] *= speed
	vec[1] *= speed
	vec[2] *= speed
	set_pev(ent, pev_velocity, vec)
		
	// turn to target
	new Float:angle[3]
	Stock_Aim_At_Origin(ent, target, angle)
	angle[0] = 0.0
	set_pev(ent, pev_angles, angle)
}
stock Stock_Get_Velocity_Angle(entity, Float:output[3])
{
	static Float:velocity[3]
	pev(entity, pev_velocity, velocity)
	vector_to_angle(velocity, output)
	if( output[0] > 90.0 ) output[0] = -(360.0 - output[0])
}
stock Float:Stock_BTE_CheckAngle(id,iTarget)
{
	new Float:vOricross[2],Float:fRad,Float:vId_ori[3],Float:vTar_ori[3],Float:vId_ang[3],Float:fLength,Float:vForward[3]
	
	pev(id,pev_origin,vId_ori)
	pev(iTarget,pev_origin,vTar_ori)
	
	pev(id,pev_angles,vId_ang)
	for(new i=0;i<2;i++)
	{
		vOricross[i] = vTar_ori[i] - vId_ori[i]
	}
	
	fLength = floatsqroot(vOricross[0]*vOricross[0] + vOricross[1]*vOricross[1])
	
	if(fLength<=0.0)
	{
		vOricross[0]=0.0
		vOricross[1]=0.0
	}
	else
	{
		vOricross[0]=vOricross[0]*(1.0/fLength)
		vOricross[1]=vOricross[1]*(1.0/fLength)
	}
	
	engfunc(EngFunc_MakeVectors,vId_ang)
	global_get(glb_v_forward,vForward)
	
	fRad = vOricross[0]*vForward[0]+vOricross[1]*vForward[1]
	
	return fRad   //->   RAD 90' = 0.5rad
}
stock Stock_Get_Speed_Vector(const Float:origin1[3],const Float:origin2[3],Float:speed, Float:new_velocity[3])
{
	new_velocity[0] = origin2[0] - origin1[0]
	new_velocity[1] = origin2[1] - origin1[1]
	new_velocity[2] = origin2[2] - origin1[2]
	new Float:num = floatsqroot(speed*speed / (new_velocity[0]*new_velocity[0] + new_velocity[1]*new_velocity[1] + new_velocity[2]*new_velocity[2]))
	new_velocity[0] *= num
	new_velocity[1] *= num
	new_velocity[2] *= num
}
stock Float:Stock_Adjust_Damage(Float:fPoint[3], ent, ignored) 
{
	new Float:fOrigin[3],tr,Float:fFraction
	pev(ent, pev_origin, fOrigin)
	engfunc(EngFunc_TraceLine, fPoint, fOrigin, DONT_IGNORE_MONSTERS, ignored, tr)
	get_tr2(tr, TR_flFraction, fFraction)
	if ( fFraction == 1.0 || get_tr2( tr, TR_pHit ) == ent ) return 1.0
	return 0.6
}
stock Stock_Velocity_By_Aim(Float:vAngle[3],Float:fAngleOffset,Float:fMulti,Float:vVelocity[3])
{
	static Float:vForward[3],Float:vAngleTemp[3]
	xs_vec_copy(vAngle,vAngleTemp)
	vAngleTemp[0] += fAngleOffset
	angle_vector(vAngleTemp,ANGLEVECTOR_FORWARD,vForward)
	xs_vec_mul_scalar(vForward,fMulti, vVelocity)

		/*vVelocity[0] = floatcos(vAngle[1], degrees) * fMulti
		vVelocity[1] = floatsin(vAngle[1], degrees) * fMulti
		vVelocity[2] = floatcos(vAngle[0]+fAngleOffset, degrees) * fMulti
		return 1*/
}
stock Stock_Get_Postion(id,Float:forw,Float:right,Float:up,Float:vStart[])
{
	static Float:vOrigin[3], Float:vAngle[3], Float:vForward[3], Float:vRight[3], Float:vUp[3]
	
	pev(id, pev_origin, vOrigin)
	pev(id, pev_view_ofs,vUp)
	xs_vec_add(vOrigin,vUp,vOrigin)
	pev(id, pev_v_angle, vAngle)
	
	angle_vector(vAngle,ANGLEVECTOR_FORWARD,vForward)
	angle_vector(vAngle,ANGLEVECTOR_RIGHT,vRight)
	angle_vector(vAngle,ANGLEVECTOR_UP,vUp)
	
	vStart[0] = vOrigin[0] + vForward[0] * forw + vRight[0] * right + vUp[0] * up
	vStart[1] = vOrigin[1] + vForward[1] * forw + vRight[1] * right + vUp[1] * up
	vStart[2] = vOrigin[2] + vForward[2] * forw + vRight[2] * right + vUp[2] * up
}
stock Stock_EmitSound(id,sSound[],iChan)
{
	emit_sound(id,iChan,sSound,1.0, ATTN_NORM, 0, PITCH_NORM)
}
stock Stock_Send_Anim(id,iAnim)
{
	if(!is_user_alive(id)) return;
	
	set_pev(id, pev_weaponanim, iAnim)
	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, _, id)
	write_byte(iAnim)
	write_byte(pev(id, pev_body))
	message_end()
}
stock Stock_Get_Idwpn_FromSz(sModel[])
{
	strtolower(sModel)
	for(new i=1; i<MAX_WPN; i++)
	{
		if (equali(c_model[i], sModel)) 
		{
			return i;
		}
	}
	return 0;
}
stock Stock_Config_User_Bpammo(id, iCswpn, iAmmo,iSet = 0)
{
	static iOffset
	switch(iCswpn)
	{
		case CSW_AWP: iOffset = OFFSET_AWM_AMMO;
		case CSW_SCOUT,CSW_AK47,CSW_G3SG1: iOffset = OFFSET_SCOUT_AMMO;
		case CSW_M249: iOffset = OFFSET_PARA_AMMO;
		case CSW_M4A1,CSW_FAMAS,CSW_AUG,CSW_SG550,CSW_GALI,CSW_SG552: iOffset = OFFSET_FAMAS_AMMO;
		case CSW_M3,CSW_XM1014: iOffset = OFFSET_M3_AMMO;
		case CSW_USP,CSW_UMP45,CSW_MAC10: iOffset = OFFSET_USP_AMMO;
		case CSW_FIVESEVEN,CSW_P90: iOffset = OFFSET_FIVESEVEN_AMMO;
		case CSW_DEAGLE: iOffset = OFFSET_DEAGLE_AMMO;
		case CSW_P228: iOffset = OFFSET_P228_AMMO;
		case CSW_GLOCK18,CSW_MP5NAVY,CSW_TMP,CSW_ELITE: iOffset = OFFSET_GLOCK_AMMO;
		case CSW_FLASHBANG: iOffset = OFFSET_FLASH_AMMO;
		case CSW_HEGRENADE: iOffset = OFFSET_HE_AMMO;
		case CSW_SMOKEGRENADE: iOffset = OFFSET_SMOKE_AMMO;
		case CSW_C4: iOffset = OFFSET_C4_AMMO;
		default: return 0;
	}
	if(iSet) set_pdata_int(id, iOffset, iAmmo, OFFSET_LINUX_WEAPONS)
	else return get_pdata_int(id, iOffset, OFFSET_LINUX_WEAPONS)
}
stock Stock_Kill_Item(id,iEnt)
{
	ExecuteHam(Ham_Weapon_RetireWeapon,iEnt)	
	if(ExecuteHam(Ham_RemovePlayerItem,id,iEnt))
	{
		ExecuteHam(Ham_Item_Kill, iEnt)
	}
}
stock Stock_Strip_Slot(id,iRemoveSlot) 
{
	new weapons[32], num
	get_user_weapons(id, weapons, num)
	for (new i = 0; i < num; i++)
	{
		static iSlot; iSlot = Stock_Get_Wpn_Slot(weapons[i])
		if (iSlot == iRemoveSlot)
		{
			set_pev(id,pev_weapons,(pev(id,pev_weapons)&~(1<<(weapons[i]))))
			new iEnt
			while((iEnt = engfunc(EngFunc_FindEntityByString,iEnt,"classname",WEAPON_NAME[weapons[i]])) && pev(iEnt,pev_owner) != id) {}
			if(iEnt)
			{
				ExecuteHamB(Ham_Weapon_RetireWeapon,iEnt)	
				if(ExecuteHamB(Ham_RemovePlayerItem,id,iEnt))
				{
					ExecuteHamB(Ham_Item_Kill, iEnt)
				}
			}
		}
	}
}
stock Stock_Set_Vis(iEnt, iVis = 1) 
{
	set_pev(iEnt, pev_effects, iVis == 1 ? pev(iEnt, pev_effects) & ~EF_NODRAW : pev(iEnt, pev_effects) | EF_NODRAW)
}
stock Stock_Give_Cswpn(id, const item[],iDouble=0,iAmmo=0)
{
	static iEnt
	iEnt = engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, item))
	
	set_pev(iEnt, pev_spawnflags, pev(iEnt, pev_spawnflags) | SF_NORESPAWN)
	Set_Wpn_Data(iEnt,DEF_SPAWN,1)
	dllfunc(DLLFunc_Spawn, iEnt)
	if(iDouble)
	{
		Set_Wpn_Data(iEnt,DEF_ISDOUBLE,1)
	}
	if(iAmmo)
	{
		Set_Wpn_Data(iEnt,DEF_AMMO,iAmmo)
	}
	dllfunc(DLLFunc_Touch, iEnt, id)
	//set_pdata_int(iEnt,m_iDefaultAmmo,0,4)
	
	if(pev(iEnt,pev_owner)!=id) engfunc(EngFunc_RemoveEntity, iEnt)
	return iEnt
}
stock Stock_Get_Wpn_Slot(iWpn)
{
	if(PRIMARY_WEAPONS_BIT_SUM & (1<<iWpn))
	{
		return WPN_RIFLE
	}
	else if(SECONDARY_WEAPONS_BIT_SUM & (1<<iWpn))
	{
		return WPN_PISTOL
	}
	else if(iWpn==CSW_KNIFE)
	{
		return WPN_KNIFE
	}
	else if(iWpn == CSW_HEGRENADE)
	{
		return WPN_HE
	}
	else if(iWpn == CSW_C4)
	{
		return 5
	}
	else return 6 //FLASHBANG SMOKEBANG
}
stock Stock_Reset_Wpn_Slot(id,iSlot)
{
	g_weapon[id][iSlot] = 0
	g_user_ammo[id][iSlot] = 0
	g_user_clip[id][iSlot] = 0
	if(iSlot <2)
	{
		g_double[id][iSlot] = 0
	}
}
stock Stock_Set_Wpn_Current(id,iSlot)
{
	g_weapon[id][0] = g_weapon[id][iSlot]
	g_user_ammo[id][0] = g_user_ammo[id][iSlot]
	g_user_clip[id][0] = g_user_clip[id][iSlot]
	if(iSlot <2)
	{
		g_double[id][0] = g_double[id][iSlot]
	}
}
stock Stock_Store_Wpn_Current(id,iSlot,iClip,iAmmo)
{
	g_weapon[id][iSlot] = g_weapon[id][0]
	g_user_ammo[id][iSlot] = iAmmo
	// Save for double
	if(c_type[g_weapon[id][iSlot]] == WEAPONS_DOUBLE)
	{
		// Save clip
		g_user_clip[id][iSlot] = iClip
	}
	else g_user_clip[id][iSlot] = 0
	if(iSlot <2)
	{
		g_double[id][iSlot] = g_double[id][0]
	}	
}
stock Stock_Mywpn_Check_Cached(model[],iSlot=0)
{
	if(equal(model,"knife")) return 1
	if(equal(model,"glock18")) return 1
	if(equal(model,"usp")) return 1
	switch (iSlot)
	{
		case WPN_RIFLE:
		{
			for (new i=0; i<MAX_MYWPN_RIFLES; i++)
			{
				if (equali(g_mywpn_r_cache[i], model)) return 1;
			}
			return 0;
		}
		case WPN_PISTOL:
		{
			for (new i=0; i<MAX_MYWPN_PISTOLS; i++)
			{
				if (equali(g_mywpn_p_cache[i], model)) return 1;
			}
			return 0;
		}
		case WPN_KNIFE:
		{
			for (new i=0; i<MAX_MYWPN_KNIFES; i++)
			{
				if (equali(g_mywpn_k_cache[i], model)) return 1;
			}
			return 0;
		}
		case WPN_HE:
		{
			for (new i=0; i<MAX_MYWPN_HES; i++)
			{
				if (equali(g_mywpn_h_cache[i], model)) return 1;
			}
			return 0;
		}
		case 5: //Hack
		{
			for(new i=0;i<g_custom_weapon_count;i++)
			{
				if(equali(g_custom_weapon[i],model)) 
				{
					return 1
				}
			}
			return 0
		}
		default:
		{
			if(Stock_Mywpn_Check_Cached(model,1))
			{
				return 1
			}
			else if(Stock_Mywpn_Check_Cached(model,2))
			{
				return 1
			}
			else if(Stock_Mywpn_Check_Cached(model,3))
			{
				return 1
			}
			else if(Stock_Mywpn_Check_Cached(model,4))
			{
				return 1
			}
			else if(Stock_Mywpn_Check_Cached(model,5))
			{
				return 1
			}
			
			else return 0
		}			 
	}
	return 0;
}
stock Float:Stock_Get_Body_Dmg(iBody)
{
	switch (iBody)
	{
		case HIT_GENERIC: return 1.0
		case 1: return 4.14
		case 2,3 : return 1.0
		case 4,5,6,7 : return 1.0
		default :return 1.0
	}
}
stock Stock_TraceBleed(iPlayer, Float:fDamage, Float:vecDir[3], iTr)
{
	//if (ExecuteHam(Ham_BloodColor, iPlayer) == DONT_BLEED)
		//return
	
	if (fDamage == 0)
		return
	
	new Float:vecTraceDir[3]
	new Float:fNoise
	new iCount, iBloodTr

	if (fDamage < 10)
	{
		fNoise = 0.1
		iCount = 1
	}
	else if (fDamage < 25)
	{
		fNoise = 0.2
		iCount = 2
	}
	else
	{
		fNoise = 0.3
		iCount = 4
	}

	for (new i = 0; i < iCount; i++)
	{		
		xs_vec_mul_scalar(vecDir, -1.0, vecTraceDir)

		vecTraceDir[0] += random_float(-fNoise, fNoise)
		vecTraceDir[1] += random_float(-fNoise, fNoise)
		vecTraceDir[2] += random_float(-fNoise, fNoise)

		static Float:vecEndPos[3]
		get_tr2(iTr, TR_vecEndPos, vecEndPos)
		xs_vec_mul_scalar(vecTraceDir, -0.5, vecTraceDir)
		xs_vec_add(vecTraceDir, vecEndPos, vecTraceDir)
		engfunc(EngFunc_TraceLine, vecEndPos, vecTraceDir, IGNORE_MONSTERS, iPlayer, iBloodTr)

		static Float:flFraction
		get_tr2(iBloodTr, TR_flFraction, flFraction)
		
		if (flFraction != -1.0)
			Stock_BloodDecalTrace(iBloodTr, ExecuteHam(Ham_BloodColor, iPlayer))
	}
}
stock Stock_BloodDecalTrace(iTrace, iBloodColor)
{
	switch (random_num(0, 5))
	{
		case 0: 
		{
			Stock_DecalTrace(iTrace, engfunc(EngFunc_DecalIndex, "{blood1"))
		}
		case 1: 
		{
			Stock_DecalTrace(iTrace, engfunc(EngFunc_DecalIndex, "{blood2"))
		}
		case 2: 
		{
			Stock_DecalTrace(iTrace, engfunc(EngFunc_DecalIndex, "{blood3"))
		}
		case 3: 
		{
			Stock_DecalTrace(iTrace, engfunc(EngFunc_DecalIndex, "{blood4"))
		}
		case 4: 
		{
			Stock_DecalTrace(iTrace, engfunc(EngFunc_DecalIndex, "{blood5"))
		}
		case 5: 
		{
			Stock_DecalTrace(iTrace, engfunc(EngFunc_DecalIndex, "{blood6"))
		}
	}
}
stock Stock_DecalTrace(iTrace, iDecalNumber)
{
	if (iDecalNumber < 0)
		return

	static Float:flFraction
	get_tr2(iTrace, TR_flFraction, flFraction)
	
	if (flFraction == 1.0)
		return

	new iHit = get_tr2(iTrace, TR_pHit)
	
	if (pev_valid(iHit))
	{
		if ((pev(iHit, pev_solid) != SOLID_BSP && pev(iHit, pev_movetype) != MOVETYPE_PUSHSTEP))
			return	
	}
	else 
		iHit = 0

	new iMessage = TE_DECAL
	if (iHit != 0)
	{
		if (iDecalNumber > 255)
		{
			iDecalNumber -= 256
			iMessage = TE_DECALHIGH
		}
	}
	else
	{
		iMessage = TE_WORLDDECAL
		if (iDecalNumber > 255)
		{
			iDecalNumber -= 256
			iMessage= TE_WORLDDECALHIGH
		}
	}
	
	static Float:vecEndPos[3]
	get_tr2(iTrace, TR_vecEndPos, vecEndPos)
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
	write_byte(iMessage)
	engfunc(EngFunc_WriteCoord, vecEndPos[0])
	engfunc(EngFunc_WriteCoord, vecEndPos[1])
	engfunc(EngFunc_WriteCoord, vecEndPos[2])
	write_byte(iDecalNumber)
	if (iHit) write_short(iHit)
	message_end()
}
stock Stock_BloodEffect(Float:vecOri[3])
{
	//if(!get_pcvar_num(cvar_friendlyfire)) return
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY) 
	write_byte(TE_BLOODSPRITE)
	engfunc(EngFunc_WriteCoord,vecOri[0])
	engfunc(EngFunc_WriteCoord,vecOri[1])
	engfunc(EngFunc_WriteCoord,vecOri[2])
	write_short(g_cache_bloodspray)
	write_short(g_cache_blood)
	write_byte(75)
	write_byte(6)
	message_end()
}
stock Stock_Is_Direct(id,id2)
{
	new Float:v1[3],Float:v2[3],Float:v3[3]
	pev(id,pev_origin,v1)
	pev(id2,pev_origin,v2)
	pev(id,pev_view_ofs,v3)
	xs_vec_add(v1,v3,v1)
	pev(id2,pev_view_ofs,v3)
	xs_vec_add(v2,v3,v2)
	
	new tr
	engfunc(EngFunc_TraceLine, v1, v2, DONT_IGNORE_MONSTERS, id, tr)
	return (get_tr2(tr, TR_pHit ) == id2)
}
///////////////////////////////////////////////////////////////// 后方高能 /////////////////////////////////////////////////////
stock Pub_Fake_Damage_Guns(iAttacker,iVictim,Float:fDamage,iDamagetype,Float:fDistance = 9999.0,iEntity = 0)
{
	static Float:fDamagerange
	fDamagerange = g_c_fFloatDamagePercent
	if(iVictim>32) // 攻击可以受到伤害的实体
	{
		if(!pev(iVictim,pev_takedamage)) return FAKE_RESULT_HIT_WALL
		if(pev(iVictim,pev_spawnflags)&SF_BREAK_TRIGGER_ONLY) return FAKE_RESULT_HIT_WALL
		
		ExecuteHamB(Ham_TakeDamage,iVictim,iEntity?iEntity:iAttacker,iAttacker,fDamage,DMG_CLUB)
		return FAKE_RESULT_HIT_WALL
	}
	
	// Prepare Data
	static Float:vecStart[3], Float:vecTarget[3],Float:vecViewOfs[3],Float:vecVictim[3],trRes,Float:vAngle[3],Float:vForw[3],iBody,Float:fDamageTemp,Float:vDirection[3],trRes2
	pev(iAttacker, pev_origin, vecStart) 
	pev(iAttacker, pev_view_ofs, vecViewOfs) 
	xs_vec_add(vecStart, vecViewOfs, vecStart) 
	pev(iVictim, pev_origin, vecVictim)
	if(get_distance_f(vecVictim,vecStart)>fDistance) return FAKE_RESULT_HIT_NONE
	
	if( (iDamagetype & FAKE_TYPE_HITHEAD) && iVictim && iVictim<33) // Make Sure Player
	{
		fDamageTemp = fDamage * random_float(1.0-fDamagerange,1.0+fDamagerange)
		// HEAD!!!
		fDamageTemp *= Stock_Get_Body_Dmg(1)
		set_pdata_int(iVictim,75,1)
		ExecuteHamB(Ham_TakeDamage,iVictim,iEntity?iEntity:iAttacker,iAttacker,fDamageTemp,DMG_CLUB)
		return FAKE_RESULT_HIT_PLAYER
	}
	
	pev(iAttacker,pev_v_angle,vAngle)
	engfunc(EngFunc_MakeVectors,vAngle)
	global_get(glb_v_forward,vForw)
	xs_vec_mul_scalar(vForw,fDistance,vForw)
	xs_vec_add(vecStart, vForw, vecTarget)
	engfunc(EngFunc_TraceLine, vecStart, vecTarget, 0, iAttacker, trRes)
	if(get_tr2(trRes,TR_pHit) == iVictim && (iDamagetype & FAKE_TYPE_CHECKPHIT)) //直接可以命中
	{
		set_tr2(trRes, TR_flFraction, get_distance_f(vecStart, vecTarget) / fDistance)
		if(iDamagetype & FAKE_TYPE_GENER_HEAD)
		{
			set_tr2(trRes,TR_iHitgroup,random_num(HIT_CHEST,HIT_RIGHTLEG))
		}
		iBody= get_tr2(trRes,TR_iHitgroup)
		fDamageTemp = fDamage * random_float(1.0-fDamagerange,1.0+fDamagerange)
		fDamageTemp *= Stock_Get_Body_Dmg(iBody)
		set_pdata_int(iVictim,75,iBody)
		ExecuteHamB(Ham_TakeDamage,iVictim,iEntity?iEntity:iAttacker,iAttacker,fDamageTemp,DMG_CLUB)
		get_tr2(trRes,TR_vecEndPos,vecTarget)
		
		if(iDamagetype & FAKE_TYPE_TRACEBLEED)
		{
			if(0<get_tr2(trRes,TR_pHit)<33)
			{
				if(get_user_team(iAttacker) != get_user_team(iVictim))
				{
					Stock_TraceBleed(iVictim,fDamage,vecTarget, trRes)
					Stock_BloodEffect(vecTarget)
				}
			}
		}
		return FAKE_RESULT_HIT_PLAYER
	}		
	else
	{
		pev(iVictim,pev_origin,vecTarget)
		engfunc(EngFunc_TraceLine, vecStart, vecTarget, 0, iAttacker, trRes2)
	
		xs_vec_sub(vecStart,vecTarget,vDirection)
		set_tr2(trRes2, TR_flFraction, get_distance_f(vecStart, vecTarget) / fDistance)
		if(iDamagetype & FAKE_TYPE_GENER_HEAD)
		{
			set_tr2(trRes2,TR_iHitgroup,random_num(HIT_CHEST,HIT_RIGHTLEG))
		}
		
		fDamageTemp = fDamage * random_float(1.0-fDamagerange,1.0+fDamagerange)
		set_pdata_int(iVictim,75,get_tr2(trRes2,TR_iHitgroup))
		if(iDamagetype & FAKE_TYPE_CHECKDIRECT && !Stock_Is_Direct(iAttacker,iVictim))  return FAKE_RESULT_HIT_NONE
		ExecuteHamB(Ham_TakeDamage,iVictim,iEntity?iEntity:iAttacker,iAttacker,fDamageTemp,DMG_CLUB)
		
		if(iDamagetype & FAKE_TYPE_TRACEBLEED)
		{
			if(0<get_tr2(trRes,TR_pHit)<33)
			{
				if(get_user_team(iAttacker) != get_user_team(iVictim))
				{
					Stock_TraceBleed(iVictim,fDamage,vecTarget, trRes)
					Stock_BloodEffect(vecTarget)
				}
			}
		}
		return FAKE_RESULT_HIT_PLAYER
	}
	return FAKE_RESULT_HIT_WALL
}
stock Stock_ResetBotMoney(id)
{
	cs_set_user_money(id,0)
}