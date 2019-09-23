// [BTE Read File Function]
public Read_Config_File()
{
	format(g_szConfigFile, charsmax(g_szConfigFile), "%s/%s", g_szConfigDir, BTE_CONFIG_FILE)
	if (!file_exists(g_szConfigFile))
	{
		Util_Log("Couldn't Open Config File:%s!",BTE_CONFIG_FILE)
		set_fail_state("ERROR!See bte_wpn_log.log for detail")
	}
	new linedata[1024], key[64], value[960]
	new file = fopen(g_szConfigFile, "rt")
	
	while (file && !feof(file))
	{
		fgets(file, linedata, charsmax(linedata))
		replace(linedata, charsmax(linedata), "^n", "")
		if (!linedata[0] || linedata[0] == ';')
		{
			continue;
		}
		strtok(linedata, key, charsmax(key), value, charsmax(value), '=')
		trim(key)
		trim(value)
		
		if(equal(key,"WeaponLastTime")) g_c_fWeaponLastTime = str_to_float(value)
		if(equal(key,"KnockBackUseDmg")) g_c_iKnockBackUseDmg = str_to_num(value)
		if(equal(key,"StripDroppedHe")) g_c_iStripDroppedHe = str_to_num(value)
		if(equal(key,"FloatDamagePercent")) g_c_fFloatDamagePercent = str_to_float(value)
		if(equal(key,"ZoomGravityMultiple")) g_c_fZoomGravityMultiple = str_to_float(value)
		if(equal(key,"ZoomRateOfFireMultiple")) g_c_fZoomRateOfFireMultiple = str_to_float(value)
		if(equal(key,"GenerateBuyUI")) g_c_iGenerateBuyUI = str_to_num(value)
	}
}
public Read_WeaponsINI(isPrecache)
{
	for(new i = 0 ;i<5;i++)
	{
		g_wpn_count[i] = 0	// 0 = 1+2+3+4
		for(new j=0 ;j<200;j++)
		{
			g_wpn_count_match[i][j] = 0
		}
	}
	new sPath[64]
	format(sPath, charsmax(sPath), "%s/%s", g_szConfigDir, BTE_WPN_FILE)
		
	if (!file_exists(sPath))
	{
		Util_Log("Couldn't Open Weapons File:%s!",BTE_WPN_FILE)
		set_fail_state("ERROR!See bte_wpn_log.log for detail")
	}
	new linedata[1024], key[64], value[960]
	new file = fopen(sPath, "rt")
	new idwpn = 1
		
	new iSectiolTotal = sizeof(g_bte_replace)
	new iSectiolTotal2 = sizeof(g_bte_replace2)
	while (file && !feof(file))
	{
		new iStartSection[SECTION_STARTNUM] // memset
		if(idwpn == 1)
		{
			format(linedata,charsmax(linedata),"%L",LANG_PLAYER,"BTE_WPN_1")
		}
		else if(idwpn == 2)
		{
			format(linedata,charsmax(linedata),"%L",LANG_PLAYER,"BTE_WPN_2")
		}
		else if(idwpn == 3)
		{
			format(linedata,charsmax(linedata),"%L",LANG_PLAYER,"BTE_WPN_3")
		}
		else fgets(file, linedata, charsmax(linedata))
		replace(linedata, charsmax(linedata), "^n", "")
		if (!linedata[0] || linedata[0] == ';') continue;
		
		replace_all(linedata, charsmax(linedata), ",", "")
		for(new iSec=0;iSec<iSectiolTotal;iSec++)
		{
			if(containi(linedata,g_bte_replace[iSec])>-1)
			{
				replace_all(linedata, charsmax(linedata), g_bte_replace[iSec], ",")
				iStartSection[iSec] = 1
			}
		}

		for(new iSec=0;iSec<iSectiolTotal2;iSec++)
		{
			if(containi(linedata,g_bte_replace2[iSec])>-1)
			{
				replace_all(linedata, charsmax(linedata), g_bte_replace2[iSec], ",")
				//PRINT(g_bte_replace2[iSec])
			}
		}		
		
		static sTemp[512];
		strtok(linedata, key, charsmax(key), value, charsmax(value), ',')
		new i
		while (value[0] != 0 && copy(sTemp,511,value) && strtok(value, key, charsmax(key), value, charsmax(value), ','))
		{
			if(i < SECTION_STARTNUM && !iStartSection[i])
			{
				i ++;
				copy(value,255,sTemp)
				continue;
			}
			switch (i)
			{
				case SECTION_TYPE: c_type[idwpn] = str_to_num(key)
				case SECTION_NAME: 
				{	
					format(c_name[idwpn], 63, "%s", key)
				}
				case SECTION_MODEL: 
				{
					format(c_model[idwpn], 31, "%s", key)
				}
				case SECTION_CSWPN: 
				{
					c_wpnchange[idwpn] = str_to_num(key)
					if(PRIMARY_WEAPONS_BIT_SUM & (1<<c_wpnchange[idwpn]))
					{
						c_slot[idwpn] = WPN_RIFLE
						g_wpn_count[WPN_RIFLE] += 1
						g_wpn_count_match[WPN_RIFLE][g_wpn_count[WPN_RIFLE]] = idwpn
					}
					else if(SECONDARY_WEAPONS_BIT_SUM & (1<<c_wpnchange[idwpn]))
					{
						c_slot[idwpn] = WPN_PISTOL
						g_wpn_count[WPN_PISTOL] += 1
						g_wpn_count_match[WPN_PISTOL][g_wpn_count[WPN_PISTOL]] = idwpn
					}
					else if(c_wpnchange[idwpn] == CSW_KNIFE)
					{
						c_slot[idwpn] = WPN_KNIFE
						g_wpn_count[WPN_KNIFE] += 1
						g_wpn_count_match[WPN_KNIFE][g_wpn_count[WPN_KNIFE]] = idwpn
					}
					else if(c_wpnchange[idwpn] != CSW_C4)
					{
							c_slot[idwpn] = WPN_HE
							g_wpn_count[WPN_HE] += 1
							g_wpn_count_match[WPN_HE][g_wpn_count[WPN_HE]] = idwpn
					}
				}					
				case SECTION_DAMAGE: c_damage[idwpn] = str_to_float(key)
				case SECTION_SPEED: c_speed[idwpn] = str_to_float(key)
				case SECTION_ZOOM: c_zoom[idwpn] = str_to_num(key)
				case SECTION_CLIP: c_clip[idwpn] = str_to_num(key)
				case SECTION_AMMO: {
                    if(bte_wpn_get_mod_running()==BTE_MOD_ZB1)
                    {
                        c_ammo[idwpn] = str_to_num(key)*2
                    }else
                    {
                        c_ammo[idwpn] = str_to_num(key)
                    }
                }
				case SECTION_AMMOCOST : c_ammocost[idwpn] = str_to_num(key)
				case SECTION_RECOIL: c_recoil[idwpn] = str_to_float(key)
				case SECTION_GRAVITY: c_gravity[idwpn] = str_to_float(key)
				case SECTION_KNOCKBACK: c_knockback[idwpn] = str_to_float(key)
				case SECTION_RELOAD: c_reload[idwpn] = str_to_float(key)
				case SECTION_DEPLOY: c_deploy[idwpn] = str_to_float(key)
				case SECTION_COST: c_cost[idwpn] = str_to_num(key)
				case SECTION_SOUND: c_sound[idwpn] = str_to_num(key)
				case SECTION_TEAM: c_team[idwpn] = str_to_num(key)
				case SECTION_BUY: c_buy[idwpn] = str_to_num(key)
				case SECTION_DMG_ZB: c_dmgzb[idwpn] = str_to_float(key)
				case SECTION_DMG_ZS: c_dmgzs[idwpn] = str_to_float(key)
				case SECTION_DMG_HMS: c_dmghms[idwpn] = str_to_float(key)
				case SECTION_BUYMOD : c_buymod[idwpn] = str_to_num(key)
				case SECTION_SPECIAL: c_special[idwpn] = str_to_num(key)
				case SECTION_SHAKE: c_shake[idwpn] = str_to_num(key)
				case SECTION_P_SUB: 
				{
					format(c_p_sub[idwpn],63,key)
				}
				case SECTION_P_BODY: c_p_body[idwpn] = str_to_num(key)
				case SECTION_W_SUB: 
				{
					format(c_w_sub[idwpn],63,key)
				}
				case SECTION_W_BODY: c_w_body[idwpn] = str_to_num(key)
				case SECTION_P_SEQ : c_p_seq[idwpn] = str_to_num(key)
				case SECTION_SEQ : c_seq[idwpn] = str_to_num(key)
				case SECTION_SEQFRAMERATE : c_seqframerate[idwpn] = str_to_float(key)
			}
			if (c_slot[idwpn]  == WPN_KNIFE)
			{
				switch (i)
				{
					case SECTION_K_SPEED1: c_k_speed1[idwpn] = str_to_float(key)
					case SECTION_K_SPEED2: c_k_speed2[idwpn] = str_to_float(key)
					case SECTION_K_DISTANCE1: c_k_distance1[idwpn] = str_to_float(key)
					case SECTION_K_DISTANCE2: c_k_distance2[idwpn] = str_to_float(key)
					case SECTION_K_DAMAGE2: c_k_damage2[idwpn] = str_to_float(key)
					case SECTION_K_DELAY1: c_k_delay1[idwpn] = str_to_float(key)
					case SECTION_K_DELAY2:c_k_delay2[idwpn] = str_to_float(key)
					case SECTION_K_ANGLE: c_k_angle[idwpn] = str_to_num(key)
					case SECTION_K_SEQUENCE: c_k_sequence[idwpn] = str_to_num(key)
				}
			}	
			else if (c_type[idwpn] == WEAPONS_DOUBLE)
			{
				switch (i)
				{
					case SECTION_D_CSWPN : c_d_cswpn[idwpn] = str_to_num(key)
					case SECTION_D_TIMECHANGE1: c_d_timechange1[idwpn] = str_to_float(key)
					case SECTION_D_TIMECHANGE2: c_d_timechange2[idwpn] = str_to_float(key)
					case SECTION_D_DAMAGE: c_d_damage[idwpn] = str_to_float(key)
					case SECTION_D_SPEED: c_d_speed[idwpn] = str_to_float(key)
					case SECTION_D_ZOOM: c_d_zoom[idwpn] = str_to_num(key)
					case SECTION_D_RECOIL: c_d_recoil[idwpn] = str_to_float(key)
					case SECTION_D_CLIP: c_d_clip[idwpn] = str_to_num(key)
					case SECTION_D_RELOAD: c_d_reload[idwpn] = str_to_float(key)
					case SECTION_D_DEPLOY: c_d_deploy[idwpn] = str_to_float(key)
					case SECTION_D_KNOCKBACK: c_d_knockback[idwpn] = str_to_float(key)
					case SECTION_D_GRAVITY: c_d_gravity[idwpn] = str_to_float(key)
				}
			}
			else if (c_type[idwpn] == WEAPONS_LAUNCHER || c_type[idwpn] == WEAPONS_BAZOOKA || c_type[idwpn] == WEAPONS_FLAMETHROWER || c_type[idwpn] == WEAPONS_M32
			 || c_type[idwpn] == WEAPONS_SVDEX)
			{
				switch (i)
				{
					case SECTION_L_NADE: c_l_nade[idwpn] = str_to_num(key)
					case SECTION_L_COSTAMMO: c_l_costammo[idwpn] = str_to_num(key)
					case SECTION_L_TIMECHANGE1: c_l_timechange1[idwpn] = str_to_float(key)
					case SECTION_L_TIMECHANGE2: c_l_timechange2[idwpn] = str_to_float(key)
					case SECTION_L_TIMERELOAD: c_l_timereload[idwpn] = str_to_float(key)
					case SECTION_L_KNOCKBACK: c_l_knockback[idwpn] = str_to_float(key)
					case SECTION_L_RADIUS: c_l_radius[idwpn] = str_to_float(key)
					case SECTION_L_DAMAGE: c_l_damage[idwpn] = str_to_float(key)
					case SECTION_L_GRAVITY: c_l_gravity[idwpn] = str_to_float(key)
					case SECTION_L_LIGHTEFFECT: c_l_lighteffect[idwpn] = str_to_num(key)
					case SECTION_L_SPEED: c_l_speed[idwpn] = str_to_float(key)
					case SECTION_L_TYPE: c_l_type[idwpn] = str_to_num(key)
					case SECTION_L_ANGLE: c_l_angle[idwpn] = str_to_float(key)
					case SECTION_L_FORWARD : c_l_forward[idwpn] =  str_to_float(key)
					case SECTION_L_RIGHT : c_l_right[idwpn] =  str_to_float(key)
					case SECTION_L_UP : c_l_up[idwpn] =  str_to_float(key)
					
				}
			}
			else if (c_type[idwpn] == WEAPONS_SPSHOOT)
			{
				switch (i)
				{
					case SECTION_SP_SPEED: c_sp_speed[idwpn] = str_to_float(key)
					case SECTION_SP_TIMES: c_sp_times[idwpn] = str_to_num(key)	
				}
			}
			i++
		}
		if(!isPrecache)
		{
			idwpn ++
			continue
		}
		
			
		if((g_mywpn_enable && Stock_Mywpn_Check_Cached(c_model[idwpn],c_slot[idwpn]) && c_buy[idwpn])|| (!g_mywpn_enable)||(Stock_Mywpn_Check_Cached(c_model[idwpn],5)))
		{		
BTE_GD_PRECACHE:
			// Create Models and Sound
			if(c_p_sub[idwpn][0] && strlen(c_p_sub[idwpn])>2)
			{
				format(c_model_p[idwpn], 63, "%s/%s.mdl", MODEL_URL,c_p_sub[idwpn])
			}
			else
			{
				format(c_model_p[idwpn], 63, "%s/p_%s.mdl", MODEL_URL,c_model[idwpn])
			}
			if(c_w_sub[idwpn][0]&& strlen(c_w_sub[idwpn])>2)
			{
				format(c_model_w[idwpn], 63, "%s/%s.mdl", MODEL_URL,c_w_sub[idwpn])
			}
			else
			{
				format(c_model_w[idwpn], 63, "%s/w_%s.mdl", MODEL_URL,c_model[idwpn])
			}
			format(c_model_v[idwpn], 63, "%s/v_%s.mdl", MODEL_URL,c_model[idwpn])		
			format(c_sound1[idwpn], 63, "weapons/%s_shoot1.wav", c_model[idwpn])
			format(c_sound1_silen[idwpn], 63, "weapons/%s_shoot1_silen.wav", c_model[idwpn])
			format(c_sound2[idwpn], 63, "weapons/%s_shoot2.wav", c_model[idwpn])
			format(c_sound2_silen[idwpn], 63, "weapons/%s_shoot2_silen.wav", c_model[idwpn])	
			precache_model(c_model_p[idwpn])
			precache_model(c_model_v[idwpn])
			if(c_slot[idwpn]!=WPN_KNIFE) precache_model(c_model_w[idwpn])
			if (c_sound[idwpn] && c_slot[idwpn]!=WPN_KNIFE && c_slot[idwpn]!=WPN_HE) precache_sound(c_sound1[idwpn])
			
			if (c_type[idwpn]==WEAPONS_DOUBLE)
			{
				format(c_model_v2[idwpn], 63, "%s/v_%s_2.mdl", MODEL_URL,c_model[idwpn])
				precache_model(c_model_v2[idwpn])	
				if (c_sound[idwpn]==2) precache_sound(c_sound2[idwpn])	 
			}
			else if (c_slot[idwpn]==WPN_KNIFE)
			{		
				format(c_sound_miss[idwpn], 63, "weapons/%s_miss.wav", c_model[idwpn])
				format(c_sound_hitwall[idwpn], 63, "weapons/%s_hitwall.wav", c_model[idwpn])
				format(c_sound_hit[idwpn], 63, "weapons/%s_hit1.wav", c_model[idwpn])
				format(c_sound_stab[idwpn], 63, "weapons/%s_stab.wav", c_model[idwpn])
				precache_sound(c_sound_miss[idwpn])
				precache_sound(c_sound_hitwall[idwpn])
				precache_sound(c_sound_hit[idwpn])
				precache_sound(c_sound_stab[idwpn])
			}
			else if(c_slot[idwpn] == WPN_HE)
			{
				//format(c_he_snd[idwpn], 63, "%s/%s_exp.wav",SOUND_URL, c_model[idwpn])
				new g_sprites_exp[64]
				format(g_sprites_exp, 63, "%s/%s_exp.spr", SPR_URL,c_model[idwpn])
				//precache_sound(c_he_snd[idwpn])
				c_he_spr[idwpn] = engfunc(EngFunc_PrecacheModel,g_sprites_exp)
			}
			else if (c_type[idwpn]==WEAPONS_LAUNCHER)
			{
				format(c_model_v2[idwpn], 63, "%s/v_%s_2.mdl", MODEL_URL,c_model[idwpn])		
				if (c_l_type[idwpn])
				{
					c_model_v2[idwpn] = c_model_v[idwpn]
					c_sound2[idwpn] = c_sound1[idwpn]
					c_sound1_silen[idwpn] = c_sound1[idwpn]
					c_sound2_silen[idwpn] = c_sound1[idwpn]
				}
				else
				{
					precache_model(c_model_v2[idwpn])
					precache_sound(c_sound2[idwpn])
					if (c_sound[idwpn]==2)
					{
						precache_sound(c_sound2[idwpn])
						precache_sound(c_sound2_silen[idwpn])
					}
				}
			}		
			if (CSWPN_SILENT & (1<<c_wpnchange[idwpn]))
			{
				if (c_type[idwpn]==WEAPONS_DOUBLE)
				{
					if (c_sound[idwpn]==2) precache_sound(c_sound2_silen[idwpn])
				}
				else  precache_sound(c_sound1_silen[idwpn])
			}
		}
		idwpn++
		g_wpn_count[0] += 1
	}
}
public Read_MyWeapon()
{
	new sPath[64]
	format(sPath, charsmax(sPath), "%s/%s", g_szConfigDir, BTE_MYWPN_FILE)
	if (!file_exists(sPath))
	{
		Util_Log("Couldn't Open My Weapon File:%s!",BTE_MYWPN_FILE)
		set_fail_state("ERROR!See bte_wpn_log.log for detail")
	}
	new linedata[1024], key[64], value[960], iLine, lineset[1024]
	new file = fopen(sPath, "rt")
	
	while (file && !feof(file))
	{
		fgets(file, linedata, charsmax(linedata))
		replace(linedata, charsmax(linedata), "^n", "")
		if (!linedata[0] || linedata[0] == ';')
		{
			iLine++
			continue;
		}
		strtok(linedata, key, charsmax(key), value, charsmax(value), '=')
		trim(key)
		trim(value)
		
		if(equali(key, "LOADALLWEAPONS"))
		{
			g_mywpn_enable = !(str_to_num(value))
		}		
		//Rifles
		else if(equali(key, "RIFLES"))
		{
			strtolower(value)
			new e
			while (e<MAX_MYWPN_RIFLES && value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
			{
				trim(key)
				trim(value)
				format(g_mywpn_r_cache[e], 31, "%s", key)
				e++
				g_mywpn_cachenum[WPN_RIFLE] ++
			}
		}
		//Pistols
		else if(equali(key, "PISTOLS"))
		{
			format(value,charsmax(value),"%s,usp,glock18",value)
			strtolower(value)
			new e
			while (e<MAX_MYWPN_PISTOLS && value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
			{
				trim(key)
				trim(value)
				format(g_mywpn_p_cache[e], 31, "%s", key)
				e++
				g_mywpn_cachenum[WPN_PISTOL] ++
			}
		}
		//Knives
		else if(equali(key, "KNIFES"))
		{
			format(value,charsmax(value),"%s,knife",value)
			strtolower(value)
			new e
			while (e<MAX_MYWPN_KNIFES && value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
			{
				trim(key)
				trim(value)
				format(g_mywpn_k_cache[e], 31, "%s", key)
				e++
				g_mywpn_cachenum[WPN_KNIFE] ++
			}
		}
		//Hes
		else if(equali(key, "HEGRENADES"))
		{
			strtolower(value)
			new e
			while (e<MAX_MYWPN_HES && value[0] != 0 && strtok(value, key, charsmax(key), value, charsmax(value), ','))
			{
				trim(key)
				trim(value)
				format(g_mywpn_h_cache[e], 31, "%s", key)
				e++
				g_mywpn_cachenum[WPN_HE] ++
			}
		}
		iLine++
	}
}
public Read_Block_Res()
{
	new sPath[129]
	format(sPath, 127, "%s/bte_config/bte_blockresource.txt", g_szConfigDir)
	if (!file_exists(sPath)) 
	{
		Util_Log("Block Resource File Not Found!")
		set_fail_state("ERROR!See bte_wpn_log.log for detail")
	}
	new iFile = fopen(sPath, "r")
	new sBuffer[512]
	while (iFile && !feof(iFile))
	{
		fgets(iFile,sBuffer,511)
		replace_all(sBuffer,511,"^n","")
		copy(g_sBlockResource[g_iBlockNums++],511,sBuffer)
	}
	fclose(iFile)
	Util_Log("Block Resource File Read Successfully!")
}
