// [BTE Event Command Function]
public message_SetFOV(msgid,type,id)
{
	static iFov
	iFov = get_msg_arg_int(1)
	if(g_c_fZoomGravityMultiple>0.1 && iFov<90)
	{
		static Float:fZoomSpeed
		fZoomSpeed = g_double[id][0]?(c_d_gravity[g_weapon[id][0]] * g_c_fZoomGravityMultiple):(c_gravity[g_weapon[id][0]] * g_c_fZoomGravityMultiple)
		Pub_Set_MaxSpeed(id,fZoomSpeed)
	}
	else if(iFov>=90)
	{
		Pub_Set_MaxSpeed(id,g_double[id][0]?c_d_gravity[g_weapon[id][0]]:c_gravity[g_weapon[id][0]])
	}
}
public message_DeathMsg()
{
	static iKiller, sWeapon[32],iAttackerWeapon
	new sWeaponChange[32],sSprites[32]
	iKiller = get_msg_arg_int(1)
	if(iKiller < 1 || iKiller >32) return PLUGIN_CONTINUE

	get_msg_arg_string(4, sWeapon, charsmax(sWeapon))	
	if (sWeapon[0] == 'g' && sWeapon[1] == 'r' && sWeapon[2] == 'e' && sWeapon[3] == 'n')  // grenade
	{
		format(sWeapon, charsmax(sWeapon),"%s",c_model[g_lasthe[iKiller]])
		set_msg_arg_string(4, sWeapon)	
		return PLUGIN_CONTINUE
	}
	if(sWeapon[0] == 'd' && sWeapon[1] == '_')
	{
		format(sWeaponChange,31,"%s",sWeapon[2])
		set_msg_arg_string(4, sWeaponChange)
		return PLUGIN_CONTINUE
	}	
	iAttackerWeapon  = g_weapon[iKiller][0]
	if (c_type[iAttackerWeapon]==WEAPONS_DOUBLE && g_double[iKiller][0]) format(sSprites, charsmax(sSprites), "%s_2", c_model[iAttackerWeapon])
	else format(sSprites, charsmax(sSprites), "%s", c_model[iAttackerWeapon])
	set_msg_arg_string(4, sSprites)	
	return PLUGIN_CONTINUE
}
public Event_HLTV()
{
	for(new i=1 ; i<33 ;i++)
	{
		for(new iq =1 ;iq<5;iq++)
		{
			g_modbuylimit[i][iq] = 0
		}
	}
	g_freezetime = 1
	server_cmd("sv_maxvelocity 9999.0")
}
public Event_StatusIcon(id)
{
	g_buyzone[id] = read_data(1)
}
public LogEvent_Round_Start()
{
	g_freezetime = 0
}
public cmd_block(id)
{
	return PLUGIN_HANDLED
}
public cmd_buy_mywpn(id)
{
	if(g_modruning == BTE_MOD_GD||g_modruning == BTE_MOD_DR) return PLUGIN_HANDLED
	new sCmd[32]
	read_argv(1,sCmd,31)
	
	Pub_Buy_Named_Wpn(id,sCmd)
	return PLUGIN_HANDLED
}
public cmd_wpn_reload_data()
{
	Read_WeaponsINI(0)
}
public cmd_test(id)
{
	Stock_Send_Anim(id,WEAPON_TOTALANIM[get_user_weapon(id)])
}
public cmd_buyfullammo1(id)
{
	while (cmd_buy_ammo(id,1,0)){}
	return PLUGIN_HANDLED
}
public cmd_buyfullammo2(id)
{
	while (cmd_buy_ammo(id,2,0)){}
	return PLUGIN_HANDLED
}
public cmd_buyammo1(id)
{	
	cmd_buy_ammo(id,1,0)		
	return PLUGIN_HANDLED	
}
public cmd_buyammo2(id)
{	
	cmd_buy_ammo(id,2,0)		
	return PLUGIN_HANDLED	
}
stock Stock_Check_Buy()
{
	if(g_modruning == BTE_MOD_DR || g_modruning == BTE_MOD_ZE || g_modruning == BTE_MOD_ZB1 || g_modruning == BTE_MOD_GD) return 0
	return 1
}
public cmd_buy_ammo(id,iSlot,iFree)
{
	if(!Stock_Check_Buy() && !iFree) return 0
	static iEnt,iAmmoType,iAmmo,iWpnID,iMoney
	if(!g_buyzone[id] && get_pcvar_num(cvar_freebuyzone)) return 0
	iEnt = get_pdata_cbase(id,m_rgpPlayerItems+iSlot,5)
	
	if(iEnt<1)
	{
		//PRINT("No Weapons!")
		return 0
	}
	iAmmoType = get_pdata_int(iEnt, m_iPrimaryAmmoType, 4)
	iAmmo = get_pdata_int(id, m_rgAmmo_player_Slot0 + iAmmoType)
	iWpnID = Get_Wpn_Data(iEnt,DEF_ID)
	
	// Launcher Ammo
	if(c_type[iWpnID] == WEAPONS_LAUNCHER)
	{
		if(iAmmo >= c_l_nade[iWpnID]) 
		{
			//PRINT("Full Ammo!")
			return 0
		}
		iMoney = iFree?16000:cs_get_user_money(id)
		iMoney -= c_l_costammo[iWpnID]
		if(iMoney>-1)
		{
			Stock_EmitSound(id, sound_buyammo, CHAN_ITEM)
			ExecuteHam(Ham_GiveAmmo,id,1,WEAPON_AMMOTYPE[c_wpnchange[iWpnID]],c_l_costammo[iWpnID])
			if(!iFree) cs_set_user_money(id,iMoney,1)
			// Also Update g_user_ammo
			g_user_ammo[id][iSlot] = get_pdata_int(id, m_rgAmmo_player_Slot0 + iAmmoType)
			return 1
		}
		else
		{
			message_begin(MSG_ONE,g_msgBlinkAcct,_,id)
			write_byte(5)
			message_end()
		}
		return 0
	}
	else
	{
		new iCheck
		static iEnt2,iAmmoType2,iAmmo2,pActive
		// 修复子弹重复问题
		// 寻找武器是否存在
		iEnt2 = get_pdata_cbase(id,iSlot==2?m_rgpPlayerItems+1:m_rgpPlayerItems+2,5)
		pActive = get_pdata_cbase(id,m_pActiveItem,5)
		// 修复DOUBLE子弹类型相同
		if(iEnt>0)
		{
			// 获得子弹类型
			iAmmoType2 = get_pdata_int(iEnt, m_iPrimaryAmmoType, 4)
			// 如果子弹类型相同,保存弹药
			if(iAmmoType == iAmmoType2 && pActive>0 && pActive == iEnt2)
			{
				iCheck = 1
				iAmmo2 = iAmmo
				set_pdata_int(id, m_rgAmmo_player_Slot0 + iAmmoType,iSlot==2?g_user_ammo[id][2]:g_user_ammo[id][1])
				iAmmo = (iSlot==2?g_user_ammo[id][2]:g_user_ammo[id][1])
			}
		}
		if(iAmmo >= c_ammo[iWpnID]) 
		{
			//PRINT("Full Ammo!")
			if(iCheck) set_pdata_int(id, m_rgAmmo_player_Slot0 + iAmmoType,iAmmo2)
			return 0
		}
		iMoney = iFree?16000:cs_get_user_money(id)
		iMoney -= c_ammocost[iWpnID]
		if(iMoney>-1)
		{
			Stock_EmitSound(id, sound_buyammo, CHAN_ITEM)
			ExecuteHam(Ham_GiveAmmo,id,c_clip[iWpnID],WEAPON_AMMOTYPE[c_wpnchange[iWpnID]],c_ammo[iWpnID])
			if(!iFree) cs_set_user_money(id,iMoney,1)
			// Also Update g_user_ammo
			g_user_ammo[id][iSlot] = get_pdata_int(id, m_rgAmmo_player_Slot0 + iAmmoType)
			// 还原弹药
			if(iCheck) set_pdata_int(id, m_rgAmmo_player_Slot0 + iAmmoType,iAmmo2)
			return 1
		}
		else
		{
			message_begin(MSG_ONE,g_msgBlinkAcct,_,id)
			write_byte(5)
			message_end()
		}
	}
	return 0
}