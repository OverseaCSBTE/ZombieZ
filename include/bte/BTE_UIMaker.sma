// [BTE UI MAKER FUNCTION]

// ##################### LINE DEFINE #########################
#define 	RES_C	"		^"ControlName^"		^"%s^"^n"
#define		RES_F	"		^"fieldName^"		^"%s^"^n"
#define		RES_X	"		^"xpos^"			^"%d^"^n"
#define		RES_Y	"		^"ypos^"			^"%d^"^n"

#define		RES_W	"		^"wide^"			^"%d^"^n"
#define		RES_T	"		^"tall^"			^"%d^"^n"
#define		RES_A	"		^"autoResize^"		^"%d^"^n"
#define		RES_P	"		^"pinCorner^"		^"%d^"^n"
#define		RES_V	"		^"visible^"		^"%d^"^n"
#define		RES_E	"		^"enabled^"		^"%d^"^n"
#define		RES_TAB	"		^"tabPosition^"		^"%d^"^n"
#define 	RES_LABEL "		^"labelText^"		^"%s^"^n"
#define 	RES_TA	"		^"textAlignment^"		^"%s^"^n"
#define 	RES_DT	"		^"dulltext^"		^"%d^"^n"
#define 	RES_BT	"		^"brighttext^"		^"%d^"^n"
#define 	RES_FONT	"		^"font^"			^"%s^"^n"
#define 	RES_WP	"		^"wrap^"			^"%d^"^n"
#define 	RES_SI	"		^"scaleImage^"		^"%d^"^n"
#define 	RES_I	"		^"image^"			^"%s^"^n"
#define		RES_CMD	"		^"command^"		^"%s^"^n"
#define 	RES_FR	"		^"fillColor^"		^"%s^"^n"
#define 	RES_Z	"		^"zpos^"		^"%d^"^n"
#define 	RES_D	"		^"Default^"		^"%d^"^n"
#define 	RES_COST	"		^"cost^"		^"%d^"^n"
public BTE_MakeUI_MyWeapon()
{
	new iRifleClass
	new sTitle[64]
	new iTeam = 1
	for(new iClass = WPN_RIFLE ;iClass<= WPN_HE ;iClass++)
	{
TEAM_PAGE_START:

		new iMax = g_mywpn_cachenum[iClass]
		new sFile[64],sURL[64]
		switch (iClass)
		{
			case WPN_RIFLE: 
			{
				copy(sFile,63,"Resource/UI/BTE_MyWpn")
			}
			case WPN_PISTOL: 
			{
				copy(sFile,63,"Resource/UI/BTE_MyWpn_Pistol")
				copy(sTitle,63,"#csbte_title_mywpn_pistol")
			}
			case WPN_KNIFE: 
			{
				copy(sFile,63,"Resource/UI/BTE_MyWpn_Melee")
				copy(sTitle,63,"#csbte_title_mywpn_melee")
			}
			case WPN_HE: 
			{
				copy(sFile,63,"Resource/UI/BTE_MyWpn_Equipment")
				copy(sTitle,63,"#csbte_title_mywpn_he")
			}
		}
		
		// Machinegun 4
		// Shotgun 1
		// SubMachinegun 2
		// Rifle 3
PAGE_RIFLE_START:
		
		if(iClass == WPN_RIFLE)
		{
			iRifleClass ++
			copy(sFile,63,"Resource/UI/BTE_MyWpn")
			switch (iRifleClass)
			{
				case 1: 
				{
					format(sFile,63,"%s_Shotgun",sFile)
					copy(sTitle,63,"#csbte_title_mywpn_shotgun")
				}
				case 2: 
				{
					format(sFile,63,"%s_SubMachinegun",sFile)
					copy(sTitle,63,"#csbte_title_mywpn_submachinegun")
				}
				case 3: 
				{
					format(sFile,63,"%s_Rifle",sFile)
					copy(sTitle,63,"#csbte_title_mywpn_rifle")
				}
				case 4: 
				{
					format(sFile,63,"%s_Machinegun",sFile)
					copy(sTitle,63,"#csbte_title_mywpn_machinegun")
				}
				case 5: 
				{
					if(iTeam == 1)
					{
						iTeam =2
						iRifleClass = 0
						goto PAGE_RIFLE_START
					}						
					else goto PAGE_END_3
				}
			}
		}

		copy(sURL,63,sFile)
			
		// Prepare List
		new iCountTeam
		new iIdwpn
		new iMatch[100]
		new iTeamCount
		for(new i=0 ;i<iMax;i++)
		{
			switch (iClass)
			{
				case WPN_RIFLE:
				{
					iIdwpn = Stock_Get_Idwpn_FromSz(g_mywpn_r_cache[i])
				}
				case WPN_PISTOL:
				{
					iIdwpn = Stock_Get_Idwpn_FromSz(g_mywpn_p_cache[i])
				}
				case WPN_KNIFE:
				{
					iIdwpn = Stock_Get_Idwpn_FromSz(g_mywpn_k_cache[i])
				}
				case WPN_HE:
				{
					iIdwpn = Stock_Get_Idwpn_FromSz(g_mywpn_h_cache[i])
				}
			}
			if(c_team[iIdwpn] == iTeam || c_team[iIdwpn] == 0)
			{
				iTeamCount++
				iMatch[iTeamCount] = iIdwpn
			}
		}
		new iMod = iTeamCount % 9 //PageMax 9
		new iPageTotal = iTeamCount / 9 + (iMod)?1:0 //PageItemsMax 20
		new iPageEndItem[20]
		//Save Every Page Items max
		for(new iTemp = 1 ; iTemp<=iPageTotal ;iTemp++)
		{
			if(iTemp<iPageTotal) 
			{
				iPageEndItem[iTemp] = (9 *(iTemp-1))
			}
			else
			{
				iPageEndItem[iTemp] = (9 *(iTemp-1)) + (iTeamCount % 9)
			}
		}
		new iCountTotalMatch[5][30]
		new iCountTotal[5]
		if(iClass == WPN_RIFLE)
		{
			//Get Class Total
			
			for(new i = 1;i <=iTeamCount;i++)
			{
				if(c_wpnchange[iMatch[i]] == CSW_M3  || c_wpnchange[iMatch[i]] == CSW_XM1014)
				{
					iCountTotal[1]++
					iCountTotalMatch[1][iCountTotal[1]] = iMatch[i]
				}
				else if(c_wpnchange[iMatch[i]] == CSW_P90  || c_wpnchange[iMatch[i]] == CSW_UMP45 || c_wpnchange[iMatch[i]] == CSW_MP5NAVY  || c_wpnchange[iMatch[i]] == CSW_TMP)
				{
					iCountTotal[2]++
					iCountTotalMatch[2][iCountTotal[2]] = iMatch[i]
				}
				else if(c_wpnchange[iMatch[i]] == CSW_M249)
				{
					iCountTotal[4]++
					iCountTotalMatch[4][iCountTotal[4]] = iMatch[i]
				}
				else
				{
					iCountTotal[3]++
					iCountTotalMatch[3][iCountTotal[3]] = iMatch[i]
				}
			}
			//
			iMod = iCountTotal[iRifleClass] % 9 //PageMax 9
			iPageTotal = iCountTotal[iRifleClass] / 9
			if(iMod>0) iPageTotal++
			//Save Every Page Items max
			for(new iTemp = 1 ; iTemp<=iPageTotal ;iTemp++)
			{
				if(iTemp<iPageTotal) 
				{
					iPageEndItem[iTemp] = 9 *iTemp
				}
				else
				{
					iPageEndItem[iTemp] = (9 *(iTemp-1)) + (iCountTotal[iRifleClass] % 9)
				}
			}
			//log_amx("RIFLETOTAL:%d iClass:%d TOTLE:%d iMod %d D9 :%d LOGMAX %d %d %d",iTeamCount,iRifleClass,iCountTotal[iRifleClass],iMod,iCountTotal[iRifleClass] / 9 ,iPageTotal,iPageEndItem[1],iPageEndItem[2])
				
		}
					
		
		
		new sFName[64]
		for(new iPageCur = 1;iPageCur<=iPageTotal;iPageCur++)
		{
			format(sFile,63,"%s_%d.res",sURL,iPageCur)
			copy(sFName,63,sFile)
			delete_file(sFile)
			new g_file_ct = fopen(sFile, "a")
			//HEAD
			fprintf(g_file_ct, "^"%s^"^n{^n	^"Weapons_list^"^n	{^n",sFile);
			//TITLE BASE
			fprintf(g_file_ct, RES_C,"WizardSubPanel")
			fprintf(g_file_ct, RES_F,"Weapons_list")
			fprintf(g_file_ct, RES_X,50)
			fprintf(g_file_ct, RES_Y,10)
			fprintf(g_file_ct, RES_W,552)
			fprintf(g_file_ct, RES_T,448)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TAB,0)
			fprintf(g_file_ct, "	}^n")
			fprintf(g_file_ct, "	^"Title^"^n	{^n")
			fprintf(g_file_ct, RES_C,"Label")
			fprintf(g_file_ct, RES_F,"Title")
			fprintf(g_file_ct, RES_X,76)
			fprintf(g_file_ct, RES_Y,22)
			fprintf(g_file_ct, RES_W,500)
			fprintf(g_file_ct, RES_T,48)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TAB,0)
			fprintf(g_file_ct, RES_LABEL,sTitle)
			fprintf(g_file_ct, RES_TA,"west")
			fprintf(g_file_ct, RES_DT,0)
			fprintf(g_file_ct, RES_BT,0)
			fprintf(g_file_ct, RES_FONT,"Title")
			fprintf(g_file_ct, RES_WP,0)
			fprintf(g_file_ct, "	}^n")
			fprintf(g_file_ct, "	^"ItemInfo_bg^"^n	{^n")
			fprintf(g_file_ct, RES_C,"ImagePanel")
			fprintf(g_file_ct, RES_F,"ItemInfo_bg")
			fprintf(g_file_ct, RES_X,250)
			fprintf(g_file_ct, RES_Y,115)
			fprintf(g_file_ct, RES_W,320)
			fprintf(g_file_ct, RES_T,275)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TA,"center")
			fprintf(g_file_ct, RES_I,"resource/control/info_mywpn")
			fprintf(g_file_ct, RES_SI,1)
			fprintf(g_file_ct, "	}^n")
			
			fprintf(g_file_ct, "	^"ItemInfo^"^n	{^n")
			fprintf(g_file_ct, RES_C,"Panel")
			fprintf(g_file_ct, RES_F,"ItemInfo")
			fprintf(g_file_ct, RES_X,260)
			fprintf(g_file_ct, RES_Y,125)
			fprintf(g_file_ct, RES_W,320)
			fprintf(g_file_ct, RES_T,270)
			fprintf(g_file_ct, RES_A,3)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TAB,0)
			fprintf(g_file_ct, "	}^n")
			// CONTENT
			fprintf(g_file_ct, "//###################### GENERATE BY BTE WPN ^n");
			//PAGE
// prev
			if(iPageCur >1)
			{
				fprintf(g_file_ct, "	^"page_prev_bg^"^n	{^n")
				fprintf(g_file_ct, RES_C,"ImagePanel")
				fprintf(g_file_ct, RES_F,"page_prev_bg")
				fprintf(g_file_ct, RES_X,115)
				fprintf(g_file_ct, RES_Y,400)
				fprintf(g_file_ct, RES_W,45)
				fprintf(g_file_ct, RES_T,17)
				fprintf(g_file_ct, RES_A,0)
				fprintf(g_file_ct, RES_P,0)
				fprintf(g_file_ct, RES_V,1)
				fprintf(g_file_ct, RES_E,0)
				fprintf(g_file_ct, RES_TA,"west")
				fprintf(g_file_ct, RES_I,"resource/control/button/btn_mywpn_page")
				fprintf(g_file_ct, RES_SI,1)
				fprintf(g_file_ct, "	}^n")
				fprintf(g_file_ct, "	^"page_prev_cmd^"^n	{^n")
				fprintf(g_file_ct, RES_C,"MouseOverPanelButton")
				fprintf(g_file_ct, RES_F,"page_prev_cmd")
				fprintf(g_file_ct, RES_X,115)
				fprintf(g_file_ct, RES_Y,400)
				fprintf(g_file_ct, RES_W,45)
				fprintf(g_file_ct, RES_T,17)
				fprintf(g_file_ct, RES_A,0)
				fprintf(g_file_ct, RES_P,2)
				fprintf(g_file_ct, RES_V,1)
				fprintf(g_file_ct, RES_E,1)
				fprintf(g_file_ct, RES_TAB,0)
				
				fprintf(g_file_ct, RES_LABEL,"#Cstrike_prev")
				fprintf(g_file_ct, RES_TA,"west")
				fprintf(g_file_ct, RES_DT,0)
				fprintf(g_file_ct, RES_BT,0)
				format(sFile,63,"%s_%d.res",sURL,iPageCur-1)
				fprintf(g_file_ct, RES_CMD,sFile)
				fprintf(g_file_ct, "	}^n")
			}
			// cancel
			fprintf(g_file_ct, "	^"CancelButton-bg^"^n	{^n")
			fprintf(g_file_ct, RES_C,"ImagePanel")
			fprintf(g_file_ct, RES_F,"CancelButton-bg")
			fprintf(g_file_ct, RES_X,60)
			fprintf(g_file_ct, RES_Y,374)
			fprintf(g_file_ct, RES_W,186)
			fprintf(g_file_ct, RES_T,26)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TA,"center")
			fprintf(g_file_ct, RES_I,"resource/control/blank_slot")
			fprintf(g_file_ct, RES_SI,1)
			fprintf(g_file_ct, "	}^n")
			fprintf(g_file_ct, "	^"CancelButton-key^"^n	{^n")
			fprintf(g_file_ct, RES_C,"ImagePanel")
			fprintf(g_file_ct, RES_F,"CancelButton-key")
			fprintf(g_file_ct, RES_X,62)
			fprintf(g_file_ct, RES_Y,377)
			fprintf(g_file_ct, RES_W,20)
			fprintf(g_file_ct, RES_T,20)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TA,"center")
			fprintf(g_file_ct, RES_I,"resource/control/keyboard")
			fprintf(g_file_ct, RES_SI,1)
			fprintf(g_file_ct, "	}^n")
			fprintf(g_file_ct, "	^"CancelButton^"^n	{^n")
			fprintf(g_file_ct, RES_C,"MouseOverPanelButton")
			fprintf(g_file_ct, RES_F,"CancelButton")
			fprintf(g_file_ct, RES_X,62)
			fprintf(g_file_ct, RES_Y,374)
			fprintf(g_file_ct, RES_W,186)
			fprintf(g_file_ct, RES_T,26)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,2)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TAB,1)
			fprintf(g_file_ct, RES_LABEL,"#csbte_Cstrike_Cancel")
			fprintf(g_file_ct, RES_TA,"west")
			fprintf(g_file_ct, RES_DT,0)
			fprintf(g_file_ct, RES_BT,0)
			fprintf(g_file_ct, RES_CMD,"vguicancel")
			fprintf(g_file_ct, RES_D,1)
			fprintf(g_file_ct, "	}^n")
			// current
			fprintf(g_file_ct, "	^"page_curr_bg^"^n	{^n")
			fprintf(g_file_ct, RES_C,"ImagePanel")
			fprintf(g_file_ct, RES_F,"page_curr_bg")
			fprintf(g_file_ct, RES_X,170)
			fprintf(g_file_ct, RES_Y,400)
			fprintf(g_file_ct, RES_W,45)
			fprintf(g_file_ct, RES_T,17)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,0)
			fprintf(g_file_ct, RES_TA,"west")
			fprintf(g_file_ct, RES_I,"resource/control/button/btn_mywpn_page")
			fprintf(g_file_ct, RES_SI,1)
			fprintf(g_file_ct, "	}^n")
			fprintf(g_file_ct, "	^"page_curr_cmd^"^n	{^n")
			fprintf(g_file_ct, RES_C,"MouseOverPanelButton")
			fprintf(g_file_ct, RES_F,"page_curr_cmd")
			fprintf(g_file_ct, RES_X,170)
			fprintf(g_file_ct, RES_Y,400)
			fprintf(g_file_ct, RES_W,45)
			fprintf(g_file_ct, RES_T,17)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,2)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TAB,0)
			new buffer[8]
			format(buffer,7," %d / %d",iPageCur,iPageTotal)
			fprintf(g_file_ct, RES_LABEL,buffer)
			fprintf(g_file_ct, RES_TA,"west")
			fprintf(g_file_ct, RES_DT,0)
			fprintf(g_file_ct, RES_BT,0)
			format(sFile,63,"%s_%d.res",sURL,iPageCur)
			fprintf(g_file_ct, RES_CMD,sFile)
			fprintf(g_file_ct, "	}^n")
			//next
			if(iPageCur < iPageTotal)
			{
				fprintf(g_file_ct, "	^"page_next_bg^"^n	{^n")
				fprintf(g_file_ct, RES_C,"ImagePanel")
				fprintf(g_file_ct, RES_F,"page_next_bg")
				fprintf(g_file_ct, RES_X,220)
				fprintf(g_file_ct, RES_Y,400)
				fprintf(g_file_ct, RES_W,45)
				fprintf(g_file_ct, RES_T,17)
				fprintf(g_file_ct, RES_A,0)
				fprintf(g_file_ct, RES_P,0)
				fprintf(g_file_ct, RES_V,1)
				fprintf(g_file_ct, RES_E,0)
				fprintf(g_file_ct, RES_TA,"west")
				fprintf(g_file_ct, RES_I,"resource/control/button/btn_mywpn_page")
				fprintf(g_file_ct, RES_SI,1)
				fprintf(g_file_ct, "	}^n")
				fprintf(g_file_ct, "	^"page_next_cmd^"^n	{^n")
				fprintf(g_file_ct, RES_C,"MouseOverPanelButton")
				fprintf(g_file_ct, RES_F,"page_next_cmd")
				fprintf(g_file_ct, RES_X,220)
				fprintf(g_file_ct, RES_Y,400)
				fprintf(g_file_ct, RES_W,45)
				fprintf(g_file_ct, RES_T,17)
				fprintf(g_file_ct, RES_A,0)
				fprintf(g_file_ct, RES_P,2)
				fprintf(g_file_ct, RES_V,1)
				fprintf(g_file_ct, RES_E,1)
				fprintf(g_file_ct, RES_TAB,0)
				
				fprintf(g_file_ct, RES_LABEL,"#Cstrike_next")
				fprintf(g_file_ct, RES_TA,"west")
				fprintf(g_file_ct, RES_DT,0)
				fprintf(g_file_ct, RES_BT,0)
				format(sFile,63,"%s_%d.res",sURL,iPageCur+1)
				fprintf(g_file_ct, RES_CMD,sFile)
				fprintf(g_file_ct, "	}^n")
			}
			fprintf(g_file_ct, "//###################### GENERATE BY BTE WPN ^n");
			// TEAM
			fprintf(g_file_ct, "	^"team_current_bg^"^n	{^n")
			fprintf(g_file_ct, RES_C,"ImagePanel")
			fprintf(g_file_ct, RES_F,"team_current_bg")
			fprintf(g_file_ct, RES_X,60)
			fprintf(g_file_ct, RES_Y,95)
			fprintf(g_file_ct, RES_W,92)
			fprintf(g_file_ct, RES_T,20)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,0)
			fprintf(g_file_ct, RES_TA,"west")
			fprintf(g_file_ct, RES_I,"resource/control/button/btn_mywpn_team_select")
			fprintf(g_file_ct, RES_SI,1)
			fprintf(g_file_ct, "	}^n")
			fprintf(g_file_ct, "	^"team_current_cmd^"^n	{^n")
			fprintf(g_file_ct, RES_C,"MouseOverPanelButton")
			fprintf(g_file_ct, RES_F,"team_current_cmd")
			fprintf(g_file_ct, RES_X,60)
			fprintf(g_file_ct, RES_Y,95)
			fprintf(g_file_ct, RES_W,92)
			fprintf(g_file_ct, RES_T,20)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,2)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TAB,0)
			
			new sBuff[64]
			if(iTeam == 1)
			{
				copy(sBuff,63," TE Weapons")
			}
			else copy(sBuff,63," CT Weapons")
			fprintf(g_file_ct, RES_LABEL,sBuff)
			fprintf(g_file_ct, RES_TA,"west")
			fprintf(g_file_ct, RES_DT,0)
			fprintf(g_file_ct, RES_BT,0)

			format(sFile,63,"%s_%d.res",sURL,iPageCur)
			fprintf(g_file_ct, RES_CMD,sFile)
			fprintf(g_file_ct, "	}^n")

			fprintf(g_file_ct, "	^"team_other_bg^"^n	{^n")
			fprintf(g_file_ct, RES_C,"ImagePanel")
			fprintf(g_file_ct, RES_F,"team_other_bg")
			fprintf(g_file_ct, RES_X,152)
			fprintf(g_file_ct, RES_Y,98)
			fprintf(g_file_ct, RES_W,93)
			fprintf(g_file_ct, RES_T,17)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,0)
			fprintf(g_file_ct, RES_TA,"west")
			fprintf(g_file_ct, RES_I,"resource/control/button/btn_mywpn_team")
			fprintf(g_file_ct, RES_SI,1)
			fprintf(g_file_ct, "	}^n")
			fprintf(g_file_ct, "	^"team_other_cmd^"^n	{^n")
			fprintf(g_file_ct, RES_C,"MouseOverPanelButton")
			fprintf(g_file_ct, RES_F,"team_other_cmd")
			fprintf(g_file_ct, RES_X,152)
			fprintf(g_file_ct, RES_Y,98)
			fprintf(g_file_ct, RES_W,93)
			fprintf(g_file_ct, RES_T,17)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,2)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TAB,0)

			if(iTeam == 1)
			{
				format(sFile,63,"%s_CT_%d.res",sURL,iPageCur)
				copy(sBuff,63," &J - CT Weapons")
			}
			else 
			{
				format(sFile,63,"%s_TE_%d.res",sURL,iPageCur)
				copy(sBuff,63," &J - TE Weapons")
			}
			fprintf(g_file_ct, RES_LABEL,sBuff)
			fprintf(g_file_ct, RES_TA,"west")
			fprintf(g_file_ct, RES_DT,0)
			fprintf(g_file_ct, RES_BT,0)
			fprintf(g_file_ct, RES_CMD,sFile)
			fprintf(g_file_ct, "	}^n")
			fprintf(g_file_ct, "//###################### GENERATE BY BTE WPN ^n");
			// Weapon
			new iCount = 0 // 4 * 5
			new iCur = 0
			for(new iRow = 1 ; iRow <=9 ;iRow++ )
			{
				iCur = iRow + 9*(iPageCur - 1)
				if(iCur > iPageEndItem[iPageCur]) goto PAGE_END_2
				
				if(iClass  == WPN_RIFLE) iMatch = iCountTotalMatch[iRifleClass]
					
				static iPosX ; iPosX = 60
				static iPosY ; iPosY = 116 + 26*(iRow -1)
				static sBuffer[32]
				format(sBuffer,31,"%s_bg",c_model[iMatch[iCur]])
				
				fprintf(g_file_ct, "	^"%s^"^n	{^n",sBuffer)
				fprintf(g_file_ct, RES_C,"ImagePanel")
				fprintf(g_file_ct, RES_F,sBuffer)
				fprintf(g_file_ct, RES_X,iPosX)
				fprintf(g_file_ct, RES_Y,iPosY)
				fprintf(g_file_ct, RES_W,186)
				fprintf(g_file_ct, RES_T,26)
				fprintf(g_file_ct, RES_A,0)
				fprintf(g_file_ct, RES_P,0)
				fprintf(g_file_ct, RES_V,1)
				fprintf(g_file_ct, RES_E,1)
				fprintf(g_file_ct, RES_TA,"center")
				fprintf(g_file_ct, RES_I,"resource/control/blankslot_mywpn")
				fprintf(g_file_ct, RES_SI,1)
				fprintf(g_file_ct, "	}^n")
				
				format(sBuffer,31,"%s_key",c_model[iMatch[iCur]])
				
				fprintf(g_file_ct, "	^"%s^"^n	{^n",sBuffer)
				fprintf(g_file_ct, RES_C,"ImagePanel")
				fprintf(g_file_ct, RES_F,sBuffer)
				fprintf(g_file_ct, RES_X,iPosX+3)
				fprintf(g_file_ct, RES_Y,iPosY+3)
				fprintf(g_file_ct, RES_W,20)
				fprintf(g_file_ct, RES_T,20)
				fprintf(g_file_ct, RES_A,0)
				fprintf(g_file_ct, RES_P,0)
				fprintf(g_file_ct, RES_V,1)
				fprintf(g_file_ct, RES_E,1)
				fprintf(g_file_ct, RES_TA,"center")
				fprintf(g_file_ct, RES_I,"resource/control/keyboard")
				fprintf(g_file_ct, RES_SI,1)
				fprintf(g_file_ct, "	}^n")
				
				format(sBuffer,31,"%s_img",c_model[iMatch[iCur]])
				
				fprintf(g_file_ct, "	^"%s^"^n	{^n",sBuffer)
				fprintf(g_file_ct, RES_C,"ImagePanel")
				fprintf(g_file_ct, RES_F,sBuffer)
				fprintf(g_file_ct, RES_X,iPosX+110)
				fprintf(g_file_ct, RES_Y,iPosY)
				fprintf(g_file_ct, RES_W,76)
				fprintf(g_file_ct, RES_T,26)
				fprintf(g_file_ct, RES_A,0)
				fprintf(g_file_ct, RES_P,0)
				fprintf(g_file_ct, RES_V,1)
				fprintf(g_file_ct, RES_E,0)
				fprintf(g_file_ct, RES_TA,"west")
				format(sBuffer,31,"gfx/vgui/wpn/%s",c_model[iMatch[iCur]])
				fprintf(g_file_ct, RES_I,sBuffer)
				fprintf(g_file_ct, RES_SI,1)
				fprintf(g_file_ct, "	}^n")
				
				format(sBuffer,31,"weapon_%s",c_model[iMatch[iCur]])
				
				fprintf(g_file_ct, "	^"%s^"^n	{^n",sBuffer)
				fprintf(g_file_ct, RES_C,"MouseOverPanelButton")
				fprintf(g_file_ct, RES_F,sBuffer)
				fprintf(g_file_ct, RES_X,iPosX)
				fprintf(g_file_ct, RES_Y,iPosY)
				fprintf(g_file_ct, RES_W,186)
				fprintf(g_file_ct, RES_T,26)
				fprintf(g_file_ct, RES_A,0)
				fprintf(g_file_ct, RES_P,2)
				fprintf(g_file_ct, RES_V,1)
				fprintf(g_file_ct, RES_E,1)
				fprintf(g_file_ct, RES_TAB,0)
				format(sBuffer,31,"  &%d    %s",iRow,c_name[iMatch[iCur]])
				fprintf(g_file_ct, RES_LABEL,sBuffer)
				fprintf(g_file_ct, RES_TA,"west")
				fprintf(g_file_ct, RES_DT,0)
				fprintf(g_file_ct, RES_BT,0)
				new sCmd[64]
				format(sCmd,63,"bte_buy_wpn %s",c_model[iMatch[iCur]])
				fprintf(g_file_ct, RES_CMD,sCmd)
				fprintf(g_file_ct, RES_COST,c_cost[iMatch[iCur]])
				fprintf(g_file_ct, "	}^n")
			}
PAGE_END_2:
			fprintf(g_file_ct, "}^n")
			fclose(g_file_ct)
			// copy file
			format(sFile,63,"%s",sFName)
			copy(sFName,strlen(sFName)-4,sFName)
			
			new sCopyFile[63]
			new sCopyFile2[63]
			new temp[2000]
			//
			if(iTeam == 1)
			{
				format(sCopyFile,63,"%s_%d_TER.res",sURL,iPageCur)
				format(sCopyFile2,63,"%s_TE_%d_CT.res",sURL,iPageCur)
			}
			else
			{
				format(sCopyFile,63,"%s_%d_CT.res",sURL,iPageCur)
				format(sCopyFile2,63,"%s_CT_%d_TER.res",sURL,iPageCur)
			}				
			delete_file(sCopyFile)
			delete_file(sCopyFile2)
			new file1 = fopen(sFile, "rt")
			new file2 = fopen(sCopyFile, "at+");
			new file3 = fopen(sCopyFile2,"at+")
			
			while (fgets(file1, temp, 1999))
			{
				fprintf(file2, temp);
				fprintf(file3, temp);
			}
			fclose(file1), fclose(file2),fclose(file3)
			// copy again
			/*if(iTeam == 1)
			{
				format(sFile,63,"%s_CT_%d_TER.res",sURL,iPageCur)
				Stock_Copy_File(sCopyFile,sFile)
			}
			else
			{
				format(sFile,63,"%s_TE_%d_CT.res",sURL,iPageCur)
				Stock_Copy_File(sCopyFile,sFile)
			}*/
			
			if(iClass == WPN_RIFLE && iPageCur == iPageTotal )
			{
				goto PAGE_RIFLE_START
			}
PAGE_END_3:
		} // End Page
		if(iTeam == 1)
		{
			iTeam = 2
			goto TEAM_PAGE_START
		}
		else
		{
			iTeam = 1
		}
	} // End Class
}
public BTE_MakeUI_ShopWeapon()
{
	// === Primary Weapon === ///
	
	for(new iClass = WPN_RIFLE ;iClass<= WPN_HE ;iClass++)
	{
		// Get How many weapons
		new iMax = g_wpn_count[iClass]
		new iMod = iMax % 20
		new iPageTotal = iMax / 20
		if(iMod>0) iPageTotal++
		new iPageEndItem[20]
		
		//Save Every Page Items max
		for(new iTemp = 1 ; iTemp<=iPageTotal ;iTemp++)
		{
			if(iTemp<iPageTotal) 
			{
				iPageEndItem[iTemp] = 20 *iTemp
			}
			else
			{
				iPageEndItem[iTemp] = (20 *(iTemp-1))
				if(iMod == 0)
				{
					iPageEndItem[iTemp] +=20
				}
				else
				{
					iPageEndItem[iTemp] += (iMax % 20)
				}
			}
		}
		//log_amx("ITEM %d %d",iClass,iMax)
		//log_amx("MAX %d %d",iPageEndItem[1],iPageTotal)
			
		new sFile[64]
		new sURL[64]
		switch (iClass)
		{
			case WPN_RIFLE: copy(sFile,63,"Resource/UI/BTE_Shop_Primary")
			case WPN_PISTOL: copy(sFile,63,"Resource/UI/BTE_Shop_Secondary")
			case WPN_KNIFE: copy(sFile,63,"Resource/UI/BTE_Shop_Melee")
			case WPN_HE: copy(sFile,63,"Resource/UI/BTE_Shop_Grenade")
		}
		copy(sURL,63,sFile)
		// Create Every Page
		for(new iPageCur = 1;iPageCur<=iPageTotal;iPageCur++)
		{
			format(sFile,63,"%s_%d.res",sURL,iPageCur)
			delete_file(sFile)
			
			new g_file_ct = fopen(sFile, "a")
			//HEAD
			fprintf(g_file_ct, "^"%s^"^n{^n	^"BTEWpnList^"^n	{^n",sFile);
			//TITLE BASE
			fprintf(g_file_ct, RES_C,"WizardSubPanel")
			fprintf(g_file_ct, RES_F,"BTEWpnList")
			fprintf(g_file_ct, RES_X,50)
			fprintf(g_file_ct, RES_Y,10)
			fprintf(g_file_ct, RES_W,552)
			fprintf(g_file_ct, RES_T,448)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TAB,0)
			fprintf(g_file_ct, "	}^n")
			fprintf(g_file_ct, "	^"Title^"^n	{^n")
			fprintf(g_file_ct, RES_C,"Label")
			fprintf(g_file_ct, RES_F,"Title")
			fprintf(g_file_ct, RES_X,76)
			fprintf(g_file_ct, RES_Y,22)
			fprintf(g_file_ct, RES_W,500)
			fprintf(g_file_ct, RES_T,48)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TAB,0)
			fprintf(g_file_ct, RES_LABEL,"#csbte_shop_info")
			fprintf(g_file_ct, RES_TA,"west")
			fprintf(g_file_ct, RES_DT,0)
			fprintf(g_file_ct, RES_BT,0)
			fprintf(g_file_ct, RES_FONT,"Title")
			fprintf(g_file_ct, RES_WP,0)
			fprintf(g_file_ct, "	}^n")
			fprintf(g_file_ct, "	^"ItemInfo^"^n	{^n")
			fprintf(g_file_ct, RES_C,"Panel")
			fprintf(g_file_ct, RES_F,"ItemInfo")
			fprintf(g_file_ct, RES_X,0)
			fprintf(g_file_ct, RES_Y,0)
			fprintf(g_file_ct, RES_W,0)
			fprintf(g_file_ct, RES_T,0)
			fprintf(g_file_ct, RES_A,3)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TAB,0)
			fprintf(g_file_ct, "	}^n")
			// CONTENT
			fprintf(g_file_ct, "//###################### GENERATE BY BTE WPN ^n");
			
			// PAGE
			// prev
			if(iPageCur >1)
			{
				fprintf(g_file_ct, "	^"page_prev_bg^"^n	{^n")
				fprintf(g_file_ct, RES_C,"ImagePanel")
				fprintf(g_file_ct, RES_F,"page_prev_bg")
				fprintf(g_file_ct, RES_X,325)
				fprintf(g_file_ct, RES_Y,50)
				fprintf(g_file_ct, RES_W,45)
				fprintf(g_file_ct, RES_T,17)
				fprintf(g_file_ct, RES_A,0)
				fprintf(g_file_ct, RES_P,0)
				fprintf(g_file_ct, RES_V,1)
				fprintf(g_file_ct, RES_E,0)
				fprintf(g_file_ct, RES_TA,"west")
				fprintf(g_file_ct, RES_I,"resource/control/button/btn_mywpn_page")
				fprintf(g_file_ct, RES_SI,1)
				fprintf(g_file_ct, "	}^n")
				fprintf(g_file_ct, "	^"page_prev_cmd^"^n	{^n")
				fprintf(g_file_ct, RES_C,"MouseOverPanelButton")
				fprintf(g_file_ct, RES_F,"page_prev_cmd")
				fprintf(g_file_ct, RES_X,325)
				fprintf(g_file_ct, RES_Y,50)
				fprintf(g_file_ct, RES_W,45)
				fprintf(g_file_ct, RES_T,17)
				fprintf(g_file_ct, RES_A,0)
				fprintf(g_file_ct, RES_P,2)
				fprintf(g_file_ct, RES_V,1)
				fprintf(g_file_ct, RES_E,1)
				fprintf(g_file_ct, RES_TAB,0)
				
				fprintf(g_file_ct, RES_LABEL," &P - Prev")
				fprintf(g_file_ct, RES_TA,"west")
				fprintf(g_file_ct, RES_DT,0)
				fprintf(g_file_ct, RES_BT,0)
				format(sFile,63,"%s_%d.res",sURL,iPageCur-1)
				fprintf(g_file_ct, RES_CMD,sFile)
				fprintf(g_file_ct, "	}^n")
			}
			// current
			fprintf(g_file_ct, "	^"page_curr_bg^"^n	{^n")
			fprintf(g_file_ct, RES_C,"ImagePanel")
			fprintf(g_file_ct, RES_F,"page_curr_bg")
			fprintf(g_file_ct, RES_X,370)
			fprintf(g_file_ct, RES_Y,50)
			fprintf(g_file_ct, RES_W,45)
			fprintf(g_file_ct, RES_T,17)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,0)
			fprintf(g_file_ct, RES_TA,"west")
			fprintf(g_file_ct, RES_I,"resource/control/button/btn_mywpn_page")
			fprintf(g_file_ct, RES_SI,1)
			fprintf(g_file_ct, "	}^n")
			fprintf(g_file_ct, "	^"page_curr_cmd^"^n	{^n")
			fprintf(g_file_ct, RES_C,"MouseOverPanelButton")
			fprintf(g_file_ct, RES_F,"page_curr_cmd")
			fprintf(g_file_ct, RES_X,370)
			fprintf(g_file_ct, RES_Y,50)
			fprintf(g_file_ct, RES_W,45)
			fprintf(g_file_ct, RES_T,17)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,2)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TAB,0)
			new buffer[8]
			format(buffer,7," %d / %d",iPageCur,iPageTotal)
			fprintf(g_file_ct, RES_LABEL,buffer)
			fprintf(g_file_ct, RES_TA,"west")
			fprintf(g_file_ct, RES_DT,0)
			fprintf(g_file_ct, RES_BT,0)
			format(sFile,63,"%s_%d.res",sURL,iPageCur)
			fprintf(g_file_ct, RES_CMD,sFile)
			fprintf(g_file_ct, "	}^n")
			//next
			if(iPageCur < iPageTotal)
			{
				fprintf(g_file_ct, "	^"page_next_bg^"^n	{^n")
				fprintf(g_file_ct, RES_C,"ImagePanel")
				fprintf(g_file_ct, RES_F,"page_next_bg")
				fprintf(g_file_ct, RES_X,415)
				fprintf(g_file_ct, RES_Y,50)
				fprintf(g_file_ct, RES_W,45)
				fprintf(g_file_ct, RES_T,17)
				fprintf(g_file_ct, RES_A,0)
				fprintf(g_file_ct, RES_P,0)
				fprintf(g_file_ct, RES_V,1)
				fprintf(g_file_ct, RES_E,0)
				fprintf(g_file_ct, RES_TA,"west")
				fprintf(g_file_ct, RES_I,"resource/control/button/btn_mywpn_page")
				fprintf(g_file_ct, RES_SI,1)
				fprintf(g_file_ct, "	}^n")
				fprintf(g_file_ct, "	^"page_next_cmd^"^n	{^n")
				fprintf(g_file_ct, RES_C,"MouseOverPanelButton")
				fprintf(g_file_ct, RES_F,"page_next_cmd")
				fprintf(g_file_ct, RES_X,415)
				fprintf(g_file_ct, RES_Y,50)
				fprintf(g_file_ct, RES_W,45)
				fprintf(g_file_ct, RES_T,17)
				fprintf(g_file_ct, RES_A,0)
				fprintf(g_file_ct, RES_P,2)
				fprintf(g_file_ct, RES_V,1)
				fprintf(g_file_ct, RES_E,1)
				fprintf(g_file_ct, RES_TAB,0)
				
				fprintf(g_file_ct, RES_LABEL," &N - Next")
				fprintf(g_file_ct, RES_TA,"west")
				fprintf(g_file_ct, RES_DT,0)
				fprintf(g_file_ct, RES_BT,0)
				format(sFile,63,"%s_%d.res",sURL,iPageCur+1)
				fprintf(g_file_ct, RES_CMD,sFile)
				fprintf(g_file_ct, "	}^n")
			}
			fprintf(g_file_ct, "//###################### GENERATE BY BTE WPN ^n");
			// ===== PAGE END =====
			new iCount = 0 // 4 * 5
			new iCur = 0
			for(new iLine = 1;iLine <=5 ;iLine++)
			{
				for(new iRow = 1 ; iRow <=4 ;iRow++ )				
				{
					iCur = 4*(iLine -1) + iRow
					if(iCur > iPageEndItem[iPageCur]) goto PAGE_END_1
					
					static iPosX ; iPosX = 30 + 146*(iRow -1)
					static iPosY ; iPosY = 84 + 72*(iLine -1)
					static iRead ; iRead = iCur + 20*(iPageCur -1)
					static sBuffer[32]
					format(sBuffer,31,"%s_bg",c_model[g_wpn_count_match[iClass][iRead]])
					//log_amx("PROCSS : %d %s",iRead,c_model[g_wpn_count_match[iClass][iRead]])
					
					fprintf(g_file_ct, "	^"%s^"^n	{^n",sBuffer)
					fprintf(g_file_ct, RES_C,"ImagePanel")
					fprintf(g_file_ct, RES_F,sBuffer)
					fprintf(g_file_ct, RES_X,iPosX)
					fprintf(g_file_ct, RES_Y,iPosY)
					fprintf(g_file_ct, RES_W,138)
					fprintf(g_file_ct, RES_T,64)
					fprintf(g_file_ct, RES_A,0)
					fprintf(g_file_ct, RES_P,0)
					fprintf(g_file_ct, RES_V,1)
					fprintf(g_file_ct, RES_E,1)
					fprintf(g_file_ct, RES_TA,"center")
					fprintf(g_file_ct, RES_I,"resource/control/item_bg")
					fprintf(g_file_ct, RES_SI,1)
					fprintf(g_file_ct, "	}^n")
					
					format(sBuffer,31,"%s_bgwpn",c_model[g_wpn_count_match[iClass][iRead]])
					
					fprintf(g_file_ct, "	^"%s^"^n	{^n",sBuffer)
					fprintf(g_file_ct, RES_C,"ImagePanel")
					fprintf(g_file_ct, RES_F,sBuffer)
					fprintf(g_file_ct, RES_X,iPosX)
					fprintf(g_file_ct, RES_Y,iPosY)
					fprintf(g_file_ct, RES_W,138)
					fprintf(g_file_ct, RES_T,48)
					fprintf(g_file_ct, RES_A,0)
					fprintf(g_file_ct, RES_P,0)
					fprintf(g_file_ct, RES_V,1)
					fprintf(g_file_ct, RES_E,1)
					fprintf(g_file_ct, RES_TA,"center")
					fprintf(g_file_ct, RES_I,"resource/control/item_bgwpn")
					fprintf(g_file_ct, RES_SI,1)
					fprintf(g_file_ct, "	}^n")
					
					
					format(sBuffer,31,"%s_img",c_model[g_wpn_count_match[iClass][iRead]])
					
					fprintf(g_file_ct, "	^"%s^"^n	{^n",sBuffer)
					fprintf(g_file_ct, RES_C,"ImagePanel")
					fprintf(g_file_ct, RES_F,sBuffer)
					fprintf(g_file_ct, RES_X,iPosX)
					fprintf(g_file_ct, RES_Y,iPosY)
					fprintf(g_file_ct, RES_W,138)
					fprintf(g_file_ct, RES_T,48)
					fprintf(g_file_ct, RES_A,0)
					fprintf(g_file_ct, RES_P,0)
					fprintf(g_file_ct, RES_V,1)
					fprintf(g_file_ct, RES_E,1)
					fprintf(g_file_ct, RES_TA,"center")
					format(sBuffer,31,"gfx/vgui/%s",c_model[g_wpn_count_match[iClass][iRead]])
					fprintf(g_file_ct, RES_I,sBuffer)
					fprintf(g_file_ct, RES_SI,1)
					fprintf(g_file_ct, "	}^n")
					
					format(sBuffer,31,"%s_team",c_model[g_wpn_count_match[iClass][iRead]])
					
					fprintf(g_file_ct, "	^"%s^"^n	{^n",sBuffer)
					fprintf(g_file_ct, RES_C,"ImagePanel")
					fprintf(g_file_ct, RES_F,sBuffer)
					fprintf(g_file_ct, RES_X,iPosX+106)
					fprintf(g_file_ct, RES_Y,iPosY+38)
					fprintf(g_file_ct, RES_W,26)
					fprintf(g_file_ct, RES_T,7)
					fprintf(g_file_ct, RES_A,0)
					fprintf(g_file_ct, RES_P,0)
					fprintf(g_file_ct, RES_V,1)
					fprintf(g_file_ct, RES_E,1)
					fprintf(g_file_ct, RES_TA,"center")
					format(sBuffer,31,"resource/control/icon/team/%d",c_team[g_wpn_count_match[iClass][iRead]])
					fprintf(g_file_ct, RES_I,sBuffer)
					fprintf(g_file_ct, RES_SI,1)
					fprintf(g_file_ct, "	}^n")
					
					format(sBuffer,31,"%s_name",c_model[g_wpn_count_match[iClass][iRead]])
					
					fprintf(g_file_ct, "	^"%s^"^n	{^n",sBuffer)
					fprintf(g_file_ct, RES_C,"Label")
					fprintf(g_file_ct, RES_F,sBuffer)
					fprintf(g_file_ct, RES_X,iPosX)
					fprintf(g_file_ct, RES_Y,iPosY+46)
					fprintf(g_file_ct, RES_W,138)
					fprintf(g_file_ct, RES_T,16)
					fprintf(g_file_ct, RES_A,0)
					fprintf(g_file_ct, RES_P,0)
					fprintf(g_file_ct, RES_V,1)
					fprintf(g_file_ct, RES_E,1)
					//fprintf(g_file_ct, RES_LABEL,sBuffer)
					fprintf(g_file_ct, RES_LABEL,c_name[g_wpn_count_match[iClass][iRead]])
					fprintf(g_file_ct, RES_TA,"center")
					fprintf(g_file_ct, RES_DT,1)
					fprintf(g_file_ct, RES_BT,0)
					fprintf(g_file_ct, "	}^n")
					
					format(sBuffer,31,"%s_bottom",c_model[g_wpn_count_match[iClass][iRead]])
					
					fprintf(g_file_ct, "	^"%s^"^n	{^n",sBuffer)
					fprintf(g_file_ct, RES_C,"Button")
					fprintf(g_file_ct, RES_F,sBuffer)
					fprintf(g_file_ct, RES_X,iPosX)
					fprintf(g_file_ct, RES_Y,iPosY+1)
					fprintf(g_file_ct, RES_W,138)
					fprintf(g_file_ct, RES_T,63)
					fprintf(g_file_ct, RES_A,0)
					fprintf(g_file_ct, RES_P,2)
					fprintf(g_file_ct, RES_V,1)
					fprintf(g_file_ct, RES_E,1)
					fprintf(g_file_ct, RES_TAB,0)
					fprintf(g_file_ct, RES_LABEL,"")
					format(sBuffer,31,"bte_buy_wpn %s",c_model[g_wpn_count_match[iClass][iRead]])
					fprintf(g_file_ct, RES_CMD,sBuffer)
					fprintf(g_file_ct, "	}^n")
					
					// Then Create Class Weapon Res File
					static sCFile[32];
					new iCFile;
					format(sCFile,31,"classes/weapon_%s.res",c_model[g_wpn_count_match[iClass][iRead]])
					delete_file(sCFile);
					
					iCFile = fopen(sCFile, "a")
					//HEAD
					fprintf(iCFile, "^"%s^"^n{^n	^"pricelabel^"^n	{^n",sFile);
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"pricelabel")
					fprintf(iCFile, RES_X,0)
					fprintf(iCFile, RES_Y,86)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					fprintf(iCFile, RES_LABEL,"#CStrike_PriceLabel")
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"originlabel^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"originlabel")
					fprintf(iCFile, RES_X,0)
					fprintf(iCFile, RES_Y,102)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					fprintf(iCFile, RES_LABEL,"#CStrike_OriginLabel")
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"calibrelabel^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"calibrelabel")
					fprintf(iCFile, RES_X,0)
					fprintf(iCFile, RES_Y,118)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					fprintf(iCFile, RES_LABEL,"#CStrike_CalibreLabel")
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"clipcapacitylabel^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"clipcapacitylabel")
					fprintf(iCFile, RES_X,0)
					fprintf(iCFile, RES_Y,134)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					fprintf(iCFile, RES_LABEL,"#CStrike_ClipCapacityLabel")
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"rateoffirelabel^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"rateoffirelabel")
					fprintf(iCFile, RES_X,0)
					fprintf(iCFile, RES_Y,150)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					fprintf(iCFile, RES_LABEL,"#CStrike_RateOfFireLabel")
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"weightloadedlabel^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"weightloadedlabel")
					fprintf(iCFile, RES_X,0)
					fprintf(iCFile, RES_Y,166)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					fprintf(iCFile, RES_LABEL,"#CStrike_WeightLoadedLabel")
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"projectileweightlabel^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"projectileweightlabel")
					fprintf(iCFile, RES_X,0)
					fprintf(iCFile, RES_Y,182)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					fprintf(iCFile, RES_LABEL,"#CStrike_ProjectileWeightLabel")
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"muzzlevelocitylabel^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"muzzlevelocitylabel")
					fprintf(iCFile, RES_X,0)
					fprintf(iCFile, RES_Y,198)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					fprintf(iCFile, RES_LABEL,"#CStrike_MuzzleVelocityLabel")
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"muzzleenergylabel^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"muzzleenergylabel")
					fprintf(iCFile, RES_X,0)
					fprintf(iCFile, RES_Y,214)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					fprintf(iCFile, RES_LABEL,"#CStrike_MuzzleEnergyLabel")
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"price^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"price")
					fprintf(iCFile, RES_X,140)
					fprintf(iCFile, RES_Y,86)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					format(sBuffer,31,"#Cstrike_%sPrice",c_model[g_wpn_count_match[iClass][iRead]])
					fprintf(iCFile, RES_LABEL,sBuffer)
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"origin^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"origin")
					fprintf(iCFile, RES_X,140)
					fprintf(iCFile, RES_Y,102)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					format(sBuffer,31,"#Cstrike_%sOrigin",c_model[g_wpn_count_match[iClass][iRead]])
					fprintf(iCFile, RES_LABEL,sBuffer)
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"calibre^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"calibre")
					fprintf(iCFile, RES_X,140)
					fprintf(iCFile, RES_Y,118)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					format(sBuffer,31,"#Cstrike_%sCalibre",c_model[g_wpn_count_match[iClass][iRead]])
					fprintf(iCFile, RES_LABEL,sBuffer)
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"clipcapacity^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"clipcapacity")
					fprintf(iCFile, RES_X,140)
					fprintf(iCFile, RES_Y,134)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					format(sBuffer,31,"#Cstrike_%sClipCapacity",c_model[g_wpn_count_match[iClass][iRead]])
					fprintf(iCFile, RES_LABEL,sBuffer)
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"rateoffire^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"rateoffire")
					fprintf(iCFile, RES_X,140)
					fprintf(iCFile, RES_Y,150)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					format(sBuffer,31,"#Cstrike_%sRateOfFire",c_model[g_wpn_count_match[iClass][iRead]])
					fprintf(iCFile, RES_LABEL,sBuffer)
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"weightempty^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"weightempty")
					fprintf(iCFile, RES_X,140)
					fprintf(iCFile, RES_Y,166)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					format(sBuffer,31,"#Cstrike_%sWeightLoaded",c_model[g_wpn_count_match[iClass][iRead]])
					fprintf(iCFile, RES_LABEL,sBuffer)
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"projectileweight^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"projectileweight")
					fprintf(iCFile, RES_X,140)
					fprintf(iCFile, RES_Y,182)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					format(sBuffer,31,"#Cstrike_%sProjectileWeight",c_model[g_wpn_count_match[iClass][iRead]])
					fprintf(iCFile, RES_LABEL,sBuffer)
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"muzzlevelocity^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"muzzlevelocity")
					fprintf(iCFile, RES_X,140)
					fprintf(iCFile, RES_Y,198)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					format(sBuffer,31,"#Cstrike_%sMuzzleVelocity",c_model[g_wpn_count_match[iClass][iRead]])
					fprintf(iCFile, RES_LABEL,sBuffer)
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"muzzleenergy^"^n	{^n")
					fprintf(iCFile, RES_C,"Label")
					fprintf(iCFile, RES_F,"muzzleenergy")
					fprintf(iCFile, RES_X,140)
					fprintf(iCFile, RES_Y,214)
					fprintf(iCFile, RES_W,150)
					fprintf(iCFile, RES_T,24)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					format(sBuffer,31,"#Cstrike_%sMuzzleEnergy",c_model[g_wpn_count_match[iClass][iRead]])
					fprintf(iCFile, RES_LABEL,sBuffer)
					fprintf(iCFile, RES_TA,"west")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					fprintf(iCFile, "	}^n")
					
					fprintf(iCFile, "	^"classimage^"^n	{^n")
					fprintf(iCFile, RES_C,"ImagePanel")
					fprintf(iCFile, RES_F,"classimage")
					fprintf(iCFile, RES_X,20)
					fprintf(iCFile, RES_Y,0)
					fprintf(iCFile, RES_W,260)
					fprintf(iCFile, RES_T,90)
					fprintf(iCFile, RES_A,0)
					fprintf(iCFile, RES_P,0)
					fprintf(iCFile, RES_V,1)
					fprintf(iCFile, RES_E,1)
					fprintf(iCFile, RES_TA,"center")
					fprintf(iCFile, RES_DT,1)
					fprintf(iCFile, RES_BT,0)
					format(sBuffer,31,"gfx/vgui/%s",c_model[g_wpn_count_match[iClass][iRead]])
					fprintf(iCFile, RES_I,sBuffer)
					fprintf(iCFile, RES_SI,1)
					fprintf(iCFile, "	}^n")
					fprintf(iCFile, "}^n")
					fclose(iCFile)
				}
			}
PAGE_END_1:
			// End of page
			fprintf(g_file_ct, "	^"CancelButton-bg^"^n	{^n")
			fprintf(g_file_ct, RES_C,"ImagePanel")
			fprintf(g_file_ct, RES_F,"CancelButton-bg")
			fprintf(g_file_ct, RES_X,474)
			fprintf(g_file_ct, RES_Y,40)
			fprintf(g_file_ct, RES_W,138)
			fprintf(g_file_ct, RES_T,26)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TA,"center")
			fprintf(g_file_ct, RES_I,"resource/control/blank_slot")
			fprintf(g_file_ct, RES_SI,1)
			fprintf(g_file_ct, "	}^n")
			
			fprintf(g_file_ct, "	^"CancelButton-key^"^n	{^n")
			fprintf(g_file_ct, RES_C,"ImagePanel")
			fprintf(g_file_ct, RES_F,"CancelButton-key")
			fprintf(g_file_ct, RES_X,476)
			fprintf(g_file_ct, RES_Y,43)
			fprintf(g_file_ct, RES_W,20)
			fprintf(g_file_ct, RES_T,20)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,0)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TA,"center")
			fprintf(g_file_ct, RES_I,"resource/control/keyboard")
			fprintf(g_file_ct, RES_SI,1)
			fprintf(g_file_ct, "	}^n")
			
			fprintf(g_file_ct, "	^"CancelButton^"^n	{^n")
			fprintf(g_file_ct, RES_C,"MouseOverPanelButton")
			fprintf(g_file_ct, RES_F,"CancelButton")
			fprintf(g_file_ct, RES_X,474)
			fprintf(g_file_ct, RES_Y,40)
			fprintf(g_file_ct, RES_W,138)
			fprintf(g_file_ct, RES_T,26)
			fprintf(g_file_ct, RES_A,0)
			fprintf(g_file_ct, RES_P,2)
			fprintf(g_file_ct, RES_V,1)
			fprintf(g_file_ct, RES_E,1)
			fprintf(g_file_ct, RES_TAB,1)
			fprintf(g_file_ct, RES_LABEL,"#csbte_Cstrike_Cancel")
			fprintf(g_file_ct, RES_TA,"west")
			fprintf(g_file_ct, RES_DT,0)
			fprintf(g_file_ct, RES_BT,0)
			fprintf(g_file_ct, RES_CMD,"vguicancel")
			fprintf(g_file_ct, RES_D,1)

			fprintf(g_file_ct, "	}^n")
			
			fprintf(g_file_ct, "}^n")
			fclose(g_file_ct)
			
			// copy file
			format(sFile,63,"%s_%d.res",sURL,iPageCur)
			new sCopyFile[63]
			new temp[2000]
			new sFName[64]
			copy(sFName,strlen(sFile)-4,sFile)
			
			format(sCopyFile,63,"%s_CT.res",sFName)
			delete_file(sCopyFile)
			new file1 = fopen(sFile, "rt")
			new file2 = fopen(sCopyFile, "at+");
			format(sCopyFile,63,"%s_TER.res",sFName)
			delete_file(sCopyFile)
			new file3 = fopen(sCopyFile, "at+");
			while (fgets(file1, temp, 1999))
			{
				fprintf(file2, temp);
				fprintf(file3, temp);
			}
			fclose(file1), fclose(file2),fclose(file3)

			
		}
	}
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1034\\ f0\\ fs16 \n\\ par }
*/
