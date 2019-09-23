// [BTE Menu FUNCTION]

public cmd_wpn_menu(id)
{
	if(!is_user_alive(id)) return PLUGIN_HANDLED
	if(g_modruning == BTE_MOD_GD|| g_modruning == BTE_MOD_DR) return PLUGIN_HANDLED
	
	new title[64],item_name[6][256]
	format(title, charsmax(title), "%L",LANG_PLAYER,"BTE_WPN_MENU_BUY_MENU_TITLE")
	format(item_name[1], 31, "%L",LANG_PLAYER,"BTE_WPN_MENU_BUY_MENU_R")
	format(item_name[2], 31, "%L",LANG_PLAYER,"BTE_WPN_MENU_BUY_MENU_P")
	format(item_name[3], 31, "%L",LANG_PLAYER,"BTE_WPN_MENU_BUY_MENU_K")
	format(item_name[4], 31, "%L",LANG_PLAYER,"BTE_WPN_MENU_BUY_MENU_H")
	format(item_name[5], 255, "%L",LANG_PLAYER,"BTE_WPN_MENU_BUY_MENU_REBUY",c_name[g_save_guns[id][1]],c_name[g_save_guns[id][2]],c_name[g_save_guns[id][3]],c_name[g_save_guns[id][4]])
	
	new mHandleID = menu_create(title, "menu_wpn_handler")
	menu_additem(mHandleID, item_name[1], "R", 0)
	menu_additem(mHandleID, item_name[2], "P", 0)
	menu_additem(mHandleID, item_name[3], "K", 0)
	menu_additem(mHandleID, item_name[4], "H", 0)
	menu_additem(mHandleID, item_name[5], "Q", 0)
	
	menu_display(id, mHandleID, 0)
}
public menu_wpn_handler(id, menu, item)
{
	if (item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	
	new cmdbuy[32], name[32], access
	
	new title[64],item_name[32][32]
	
	menu_item_getinfo(menu, item, access, cmdbuy, 31, name, 31, access)
	menu_destroy(menu)
	
	
	if(equal(cmdbuy,"R"))
	{
		new title[64], fun_name[32]
		format(title, charsmax(title), "%L",LANG_PLAYER,"BTE_WPN_MENU_SELECT_MENU_R_TITLE")
		format(fun_name, charsmax(fun_name), "menu_mywpn_handler")
	
		new mHandleID = menu_create(title, fun_name)
		if(g_mywpn_enable)
		{
			for (new i=0; i<MAX_MYWPN_RIFLES; i++)
			{
				new idwpn
		
				idwpn = Stock_Get_Idwpn_FromSz(g_mywpn_r_cache[i])
		
				if (!idwpn || !c_wpnchange[idwpn] || !c_buy[idwpn]) continue;
				if (c_team[idwpn] && get_user_team(id)!=c_team[idwpn]) continue;
				if(c_buymod[idwpn] && !(c_buymod[idwpn] & (1<<g_modruning))) continue
			
				new wpn_cost = c_cost[idwpn]
				new item_name[128], idweapon[32]
				format(item_name, charsmax(item_name), "%L",LANG_PLAYER,"BTE_WPN_MENU_BUYSTYLE", c_name[idwpn], wpn_cost)
				format(idweapon, charsmax(idweapon), "%i", idwpn)
		
				menu_additem(mHandleID, item_name, idweapon, 0)
			}
		}
		else
		{
			for(new i=0 ; i<=g_wpn_count[WPN_RIFLE] ;i++)
			{
				new idwpn
				idwpn = Stock_Get_Idwpn_FromSz(c_model[g_wpn_count_match[WPN_RIFLE][i]])
				if (!idwpn || !c_wpnchange[idwpn] || !c_buy[idwpn]) continue;
		
				if (c_team[idwpn] && get_user_team(id)!=c_team[idwpn]) continue;
				if(! (PRIMARY_WEAPONS_BIT_SUM & (1<<c_wpnchange[idwpn])) ) continue
				if(c_buymod[idwpn] && !(c_buymod[idwpn] & (1<<g_modruning))) continue
				new wpn_cost = c_cost[idwpn]
				new item_name[128], idweapon[32]
				format(item_name, charsmax(item_name), "%L",LANG_PLAYER,"BTE_WPN_MENU_BUYSTYLE", c_name[idwpn], wpn_cost)
				format(idweapon, charsmax(idweapon), "%i", idwpn)
		
				menu_additem(mHandleID, item_name, idweapon, 0)
			}
		}
	
		menu_display(id, mHandleID, 0)
		
	}
	else if(equal(cmdbuy,"P"))
	{
		new title[64], fun_name[32]
		format(title, charsmax(title), "%L",LANG_PLAYER,"BTE_WPN_MENU_SELECT_MENU_P_TITLE")
		format(fun_name, charsmax(fun_name), "menu_mywpn_handler")
	
		new mHandleID = menu_create(title, fun_name)
		if(g_mywpn_enable)
		{
			for (new i=0; i<MAX_MYWPN_PISTOLS; i++)
			{
				new idwpn
		
				idwpn = Stock_Get_Idwpn_FromSz(g_mywpn_p_cache[i])
		
				if (!idwpn || !c_wpnchange[idwpn] || !c_buy[idwpn]) continue;
				if(c_buymod[idwpn] && !(c_buymod[idwpn] & (1<<g_modruning))) continue
				if (c_team[idwpn] && get_user_team(id)!=c_team[idwpn]) continue;
			
				new wpn_cost = c_cost[idwpn]
				new item_name[128], idweapon[32]
				format(item_name, charsmax(item_name), "%L",LANG_PLAYER,"BTE_WPN_MENU_BUYSTYLE", c_name[idwpn], wpn_cost)
				format(idweapon, charsmax(idweapon), "%i", idwpn)
		
				menu_additem(mHandleID, item_name, idweapon, 0)
			}
		}
		else
		{
			for(new i=0 ; i<=g_wpn_count[WPN_PISTOL] ;i++)
			{
				new idwpn
				idwpn = Stock_Get_Idwpn_FromSz(c_model[g_wpn_count_match[WPN_PISTOL][i]])
				if (!idwpn || !c_wpnchange[idwpn] || !c_buy[idwpn]) continue;
				if(c_buymod[idwpn] && !(c_buymod[idwpn] & (1<<g_modruning))) continue
				if (c_team[idwpn] && get_user_team(id)!=c_team[idwpn]) continue;
				if(! (SECONDARY_WEAPONS_BIT_SUM & (1<<c_wpnchange[idwpn])) ) continue
				new wpn_cost = c_cost[idwpn]
				new item_name[128], idweapon[32]
				format(item_name, charsmax(item_name), "%L",LANG_PLAYER,"BTE_WPN_MENU_BUYSTYLE", c_name[idwpn], wpn_cost)
				format(idweapon, charsmax(idweapon), "%i", idwpn)
		
				menu_additem(mHandleID, item_name, idweapon, 0)
			}
		}
	
		menu_display(id, mHandleID, 0)
		
	}
	else if(equal(cmdbuy,"K"))
	{
		new title[64], fun_name[32]
		format(title, charsmax(title), "%L",LANG_PLAYER,"BTE_WPN_MENU_SELECT_MENU_K_TITLE")
		format(fun_name, charsmax(fun_name), "menu_mywpn_handler")
	
		new mHandleID = menu_create(title, fun_name)
		if(g_mywpn_enable)
		{
			for (new i=0; i<MAX_MYWPN_KNIFES; i++)
			{
				new idwpn
		
				idwpn = Stock_Get_Idwpn_FromSz(g_mywpn_k_cache[i])
		
				if (!idwpn || !c_wpnchange[idwpn] || !c_buy[idwpn]) continue;
				if(c_buymod[idwpn] && !(c_buymod[idwpn] & (1<<g_modruning))) continue
				if (c_team[idwpn] && get_user_team(id)!=c_team[idwpn]) continue;
			
				new wpn_cost = c_cost[idwpn]
				new item_name[128], idweapon[32]
				format(item_name, charsmax(item_name), "%L",LANG_PLAYER,"BTE_WPN_MENU_BUYSTYLE", c_name[idwpn], wpn_cost)
				format(idweapon, charsmax(idweapon), "%i", idwpn)
		
				menu_additem(mHandleID, item_name, idweapon, 0)
			}
		}
		else
		{
			for(new i=0 ; i<=g_wpn_count[WPN_KNIFE] ;i++)
			{
				new idwpn
				idwpn = Stock_Get_Idwpn_FromSz(c_model[g_wpn_count_match[WPN_KNIFE][i]])
				if (!idwpn || !c_wpnchange[idwpn] || !c_buy[idwpn]) continue;
				if(c_buymod[idwpn] && !(c_buymod[idwpn] & (1<<g_modruning))) continue
				if (c_team[idwpn] && get_user_team(id)!=c_team[idwpn]) continue;
				if(c_wpnchange[idwpn] !=29 ) continue
				new wpn_cost = c_cost[idwpn]
				new item_name[128], idweapon[32]
				format(item_name, charsmax(item_name), "%L",LANG_PLAYER,"BTE_WPN_MENU_BUYSTYLE", c_name[idwpn], wpn_cost)
				format(idweapon, charsmax(idweapon), "%i", idwpn)
		
				menu_additem(mHandleID, item_name, idweapon, 0)
			}
		}
	
		menu_display(id, mHandleID, 0)
	}
	else if(equal(cmdbuy,"H"))
	{
		new title[64], fun_name[32]
		format(title, charsmax(title), "%L",LANG_PLAYER,"BTE_WPN_MENU_SELECT_MENU_H_TITLE")
		format(fun_name, charsmax(fun_name), "menu_mywpn_handler")
	
		new mHandleID = menu_create(title, fun_name)
		if(g_mywpn_enable)
		{
			for (new i=0; i<MAX_MYWPN_HES; i++)
			{
				new idwpn
		
				idwpn = Stock_Get_Idwpn_FromSz(g_mywpn_h_cache[i])
		
				if (!idwpn || !c_wpnchange[idwpn] || !c_buy[idwpn]) continue;
				if(c_buymod[idwpn] && !(c_buymod[idwpn] & (1<<g_modruning))) continue
				if (c_team[idwpn] && get_user_team(id)!=c_team[idwpn]) continue;
			
				new wpn_cost = c_cost[idwpn]
				new item_name[128], idweapon[32]
				format(item_name, charsmax(item_name), "%L",LANG_PLAYER,"BTE_WPN_MENU_BUYSTYLE", c_name[idwpn], wpn_cost)
				format(idweapon, charsmax(idweapon), "%i", idwpn)
		
				menu_additem(mHandleID, item_name, idweapon, 0)
			}
		}
		else
		{
			for(new i=0 ; i<=g_wpn_count[WPN_HE] ;i++)
			{
				new idwpn
				idwpn = Stock_Get_Idwpn_FromSz(c_model[g_wpn_count_match[WPN_HE][i]])
				if (!idwpn || !c_wpnchange[idwpn] || !c_buy[idwpn]) continue;
				if(c_buymod[idwpn] && !(c_buymod[idwpn] & (1<<g_modruning))) continue
				if (c_team[idwpn] && get_user_team(id)!=c_team[idwpn]) continue;
				if(c_wpnchange[idwpn]!=4) continue
				new wpn_cost = c_cost[idwpn]
				new item_name[128], idweapon[32]
				format(item_name, charsmax(item_name), "%L",LANG_PLAYER,"BTE_WPN_MENU_BUYSTYLE", c_name[idwpn], wpn_cost)
				format(idweapon, charsmax(idweapon), "%i", idwpn)
		
				menu_additem(mHandleID, item_name, idweapon, 0)
			}
		}
	
		menu_display(id, mHandleID, 0)
	}
	else if(equal(cmdbuy,"Q"))
	{
		if(g_save_guns[id][1]) Pub_Give_Wpn_Check(id,g_save_guns[id][1])
		if(g_save_guns[id][2]) Pub_Give_Wpn_Check(id,g_save_guns[id][2])
		if(g_save_guns[id][3]) Pub_Give_Wpn_Check(id,g_save_guns[id][3])
		if(g_save_guns[id][4]) Pub_Give_Wpn_Check(id,g_save_guns[id][4])
	}
	return PLUGIN_HANDLED
}
public menu_mywpn_handler(id, menu, item)
{
	if (item == MENU_EXIT)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new idwpn[32], name[32], access
	menu_item_getinfo(menu, item, access, idwpn, 31, name, 31, access)

	new idweapon = str_to_num(idwpn)
	Pub_Give_Wpn_Check(id, idweapon)
	
	menu_destroy(menu)
	return PLUGIN_HANDLED
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1034\\ f0\\ fs16 \n\\ par }
*/
