// [BTE API FUNCTION]
#include "BTE_API.inc"
#include <orpheu_stocks>
#include <orpheu_memory>
public plugin_natives()
{
	new config_dir[64], url_none[64], url_td[64], url_ze[64],url_npc[64],url_zb1[64],url_gd[64],url_dr[64],url_zb3[64]
	get_configsdir(config_dir, charsmax(config_dir))
	format(url_none, charsmax(url_none), "%s/plugins-none.ini", config_dir)
	format(url_td, charsmax(url_td), "%s/plugins-td.ini", config_dir)
	format(url_ze, charsmax(url_ze), "%s/plugins-ze.ini", config_dir)
	format(url_npc, charsmax(url_npc), "%s/plugins-npc.ini", config_dir)
	format(url_zb1, charsmax(url_zb1), "%s/plugins-zb1.ini", config_dir)
	format(url_gd, charsmax(url_gd), "%s/plugins-gd.ini", config_dir)
	format(url_dr, charsmax(url_dr), "%s/plugins-dr.ini", config_dir)
	format(url_zb3, charsmax(url_zb3), "%s/plugins-zb3.ini", config_dir)
	
	// get modruning
	if (file_exists(url_none)) g_modruning = BTE_MOD_NONE
	else if (file_exists(url_td)) g_modruning = BTE_MOD_TD
	else if (file_exists(url_ze)) g_modruning = BTE_MOD_ZE
	else if (file_exists(url_npc)) g_modruning = BTE_MOD_NPC
	else if (file_exists(url_zb1)) g_modruning = BTE_MOD_ZB1
	else if (file_exists(url_gd)) g_modruning = BTE_MOD_GD
	else if (file_exists(url_dr)) g_modruning = BTE_MOD_DR
	else if (file_exists(url_zb3)) 
	{
		g_isZomMod3 = 1
		g_modruning = BTE_MOD_ZB1
	}

	// reg native
	if (!g_isZomMod3)
	{
		register_native("bte_hms_get_skillstat","Native_NoValue",1)
	}
	if(g_modruning != BTE_MOD_ZB1 && g_modruning != BTE_MOD_ZE)
	{
		register_native("bte_get_user_zombie","Native_NoValue",1)
	}
	if(g_modruning != BTE_MOD_NPC)
	{
		register_native("bte_npc_is_npc","Native_NoValue",1)
	}
		
	register_native("bte_wpn_get_wpn_data","Native_get_wpn_data",1)
	register_native("bte_wpn_get_is_admin","Native_get_is_admin",1)
	register_native("bte_wpn_give_named_wpn","Native_give_named_wpn",1)
	register_native("bte_wpn_set_playerwpn_model","Native_set_playerwpn_model",1)
	register_native("bte_wpn_get_playerwpn_model","Native_get_playerwpn_model",1)
	register_native("bte_wpn_get_wpn_name","Native_get_wpn_name",1)
	register_native("bte_wpn_en_to_cn_name","Native_en_to_cn_name",1)
	register_native("bte_wpn_menu_add_item","Native_menu_add_item",1)
	register_native("bte_wpn_get_mod_running","Native_get_mod_running",1)
	register_native("bte_wpn_precache_named_weapon","Native_precache_named_weapon",1)
	register_native("bte_wpn_strip_weapon","Native_strip_weapon",1)
	register_native("bte_wpn_set_maxspeed","Native_set_maxspeed",1)
	register_native("bte_wpn_set_fullammo","Native_set_fullammo",1)
	register_native("bte_wpn_set_ammo","Native_set_ammo",1)
	register_native("bte_wpn_get_ammo","Native_get_ammo",1)
}
public Native_get_ammo(id,slot)
{
	// check if current weapon slot == slot
	static iSlot,iEnt,iAmmoType,iAmmo
	iSlot = c_slot[g_weapon[id][0]]
	if(iSlot == slot)
	{
		iEnt = get_pdata_cbase(id,m_rgpPlayerItems+slot,5)
		if(iEnt<1) return 0
		iAmmoType = get_pdata_int(iEnt, m_iPrimaryAmmoType, 4)
		iAmmo = get_pdata_int(id, m_rgAmmo_player_Slot0 + iAmmoType)
		return iAmmo
	}
	else
	{
		return g_user_ammo[id][slot]
	}
}
public Native_set_ammo(id,slot,ammo)
{
	// check if current weapon slot == slot
	static iSlot,iEnt,iAmmoType,iAmmo
	iSlot = c_slot[g_weapon[id][0]]
	if(iSlot == slot)
	{
		iEnt = get_pdata_cbase(id,m_rgpPlayerItems+slot,5)
		if(iEnt<1) return
		iAmmoType = get_pdata_int(iEnt, m_iPrimaryAmmoType, 4)
		set_pdata_int(id, m_rgAmmo_player_Slot0 + iAmmoType,ammo,4)
	}
	else
	{
		g_user_ammo[id][slot] = ammo
	}
}
public Native_set_fullammo(id)
{
	while (cmd_buy_ammo(id,1,1)){}
	while (cmd_buy_ammo(id,2,1)){}
	g_svdex_ammo[id] = 10
	MH_SendZB3Data(id,5,10)
}
public Native_set_maxspeed(id,Float:fSpeed)
{
	Pub_Set_MaxSpeed(id,fSpeed)
}
public Native_strip_weapon(id,iSlot)
{
	Stock_Strip_Slot(id,iSlot)
}
public Native_precache_named_weapon(sWeapon[])
{
	param_convert(1)
	copy(g_custom_weapon[g_custom_weapon_count++],15,sWeapon)
	return 1
}	
public Native_get_mod_running()
{
	return g_modruning
}
public Native_NoValue(iNone)
{
	return 0
}
public Native_menu_add_item(hMenu,iSlot)
{
	new sTemp[32]
	if(g_mywpn_enable) // use mywpn
	{
		for(new i=0;i<g_mywpn_cachenum[iSlot];i++)
		{
			if(iSlot == 1)
			{
				Native_Local_en_to_cn_name(g_mywpn_r_cache[i],sTemp)
				menu_additem(hMenu, sTemp, g_mywpn_r_cache[i], 0)
			}
			else if(iSlot == 2)
			{
				Native_Local_en_to_cn_name(g_mywpn_p_cache[i],sTemp)
				menu_additem(hMenu, sTemp, g_mywpn_p_cache[i], 0)
			}
			else if(iSlot == 3)
			{
				Native_Local_en_to_cn_name(g_mywpn_k_cache[i],sTemp)
				menu_additem(hMenu, sTemp, g_mywpn_k_cache[i], 0)
			}
			else if(iSlot == 4)
			{
				Native_Local_en_to_cn_name(g_mywpn_h_cache[i],sTemp)
				menu_additem(hMenu, sTemp, g_mywpn_h_cache[i], 0)
			}
		}
	}
	else
	{
		for(new i=1;i<=g_wpn_count[iSlot];i++)
		{
			menu_additem(hMenu, c_name[g_wpn_count_match[iSlot][i]], c_model[g_wpn_count_match[iSlot][i]], 0)
		}
	}
}
public Native_Local_en_to_cn_name(sEn[],sCn[])
{
	for(new i=1;i<g_wpn_count[0];i++)
	{
		if(equal(c_model[i],sEn))
		{
			copy(sCn,charsmax(sCn),c_name[i])
		}
	}
}
public Native_en_to_cn_name(sEn[],sCn[])
{
	param_convert(1)
	param_convert(2)
	for(new i=1;i<g_wpn_count[0];i++)
	{
		if(equal(c_model[i],sEn))
		{
			copy(sCn,charsmax(sCn),c_name[i])
		}
	}
}
public Native_get_wpn_name(id,iCurrent,iType,sName[])
{
	param_convert(4)
	if(iType == BTE_WPNDATA_CN_NAME)
	{
		copy(sName,charsmax(sName),iCurrent?c_name[iCurrent]:c_name[g_weapon[id][0]])
	}
	else copy(sName,charsmax(sName),iCurrent?c_model[iCurrent]:c_model[g_weapon[id][0]])
}
public Native_get_playerwpn_model(id)
{
	return g_p_modelent[id]
}
public Native_set_playerwpn_model(id,iVis,sModel[],iBody,iSeq)
{
	param_convert(3)
	if(iVis)
	{
		Stock_Set_Vis(g_p_modelent[id]) 
		engfunc(EngFunc_SetModel, g_p_modelent[id], sModel)
		set_pev(g_p_modelent[id],pev_body,iBody)
		//set_pev(g_p_modelent[id] ,pev_p_idwpn,iIdwpn)
		set_pev(g_p_modelent[id] ,pev_sequence,iSeq)
	}
	else Stock_Set_Vis(g_p_modelent[id],0) 
}
public Native_give_named_wpn(id,sName[])
{
	param_convert(2)
	Pub_Give_Named_Wpn(id,sName,1)
}
public Native_get_is_admin(id)
{
	return (get_user_flags(id) & ADMIN_KICK)?1:0
}
public Float:Native_get_wpn_data(id,idwpn,iSlot,iSection,iSet,fValue)
{
	if(idwpn)
	{
SEARCH_START:
		switch (iSection)
		{
			case BTE_WPNDATA_DAMAGE:
			{
				if(iSet)
				{
					c_damage[idwpn] = fValue
				}
				else return c_damage[idwpn]
			}
			case BTE_WPNDATA_SPEED:
			{
				if(iSet)
				{
					c_speed[idwpn] = fValue
				}
				else return c_speed[idwpn]
			}
			case BTE_WPNDATA_CLIP:
			{
				if(iSet)
				{
					c_clip[idwpn] = floatround(fValue)
				}
				else return float(c_clip[idwpn])
			}
			case BTE_WPNDATA_AMMO:
			{
				if(iSet)
				{
					c_ammo[idwpn] = floatround(fValue)
				}
				else return float(c_ammo[idwpn])
			}
			case BTE_WPNDATA_RECOIL:
			{
				if(iSet)
				{
					c_recoil[idwpn] = fValue
				}
				else return c_recoil[idwpn]
			}
			case BTE_WPNDATA_GRAVITY:
			{
				if(iSet)
				{
					c_gravity[idwpn] = floatround(fValue)
				}
				else return float(c_gravity[idwpn])
			}
			case BTE_WPNDATA_KNOCKBACK:
			{
				if(iSet)
				{
					c_knockback[idwpn] = fValue
				}
				else return c_knockback[idwpn]
			}
			case BTE_WPNDATA_COST:
			{
				if(iSet)
				{
					c_cost[idwpn] = floatround(fValue)
				}
				else return float(c_cost[idwpn])
			}
			case BTE_WPNDATA_BUY:
			{
				if(iSet)
				{
					c_buy[idwpn] = floatround(fValue)
				}
				else return float(c_damage[idwpn])
			}
			case BTE_WPNDATA_DMGZB:
			{
				if(iSet)
				{
					c_dmgzb[idwpn] = floatround(fValue)
				}
				else return c_dmgzb[idwpn]
			}
			default : return 0 
		}
	}
	else
	{
		idwpn = g_weapon[id][iSlot]
		goto SEARCH_START
	}
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0\\ deflang1033\\ deflangfe2052{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/
