#define NULL 0
#define TRUE 1
#define FALSE 0

#define MAX_WEAPONS 32
#define MAX_WEAPON_SLOTS 5
#define MAX_ITEM_TYPES 6
#define MAX_ITEMS 4

#define HIDEHUD_WEAPONS (1<<0)
#define HIDEHUD_FLASHLIGHT (1<<1)
#define HIDEHUD_ALL (1<<2)
#define HIDEHUD_HEALTH (1<<3)
#define HIDEHUD_TIMER (1<<4)
#define HIDEHUD_MONEY (1<<5)
#define HIDEHUD_CROSSHAIR (1<<6)

#define MAX_AMMO_TYPES 32
#define MAX_AMMO_SLOTS 32

#define HUD_PRINTNOTIFY 1
#define HUD_PRINTCONSOLE 2
#define HUD_PRINTTALK 3
#define HUD_PRINTCENTER 4
#define HUD_PRINTRADIO 5

#define SCOREATTRIB_DEAD (1<<0)
#define SCOREATTRIB_BOMB (1<<1)
#define SCOREATTRIB_VIP (1<<2)

#define STATUSICON_HIDE 0
#define STATUSICON_SHOW 1
#define STATUSICON_FLASH 2

#define TEAM_UNASSIGNED 0
#define TEAM_TERRORIST 1
#define TEAM_CT 2
#define TEAM_SPECTATOR 3

#define CLASS_UNASSIGNED 0
#define CLASS_URBAN 1
#define CLASS_TERROR 2
#define CLASS_LEET 3
#define CLASS_ARCTIC 4
#define CLASS_GSG9 5
#define CLASS_GIGN 6
#define CLASS_SAS 7
#define CLASS_GUERILLA 8
#define CLASS_VIP 9
#define CLASS_MILITIA 10
#define CLASS_SPETSNAZ 11

#define MENU_KEY_1 (1<<0)
#define MENU_KEY_2 (1<<1)
#define MENU_KEY_3 (1<<2)
#define MENU_KEY_4 (1<<3)
#define MENU_KEY_5 (1<<4)
#define MENU_KEY_6 (1<<5)
#define MENU_KEY_7 (1<<6)
#define MENU_KEY_8 (1<<7)
#define MENU_KEY_9 (1<<8)
#define MENU_KEY_0 (1<<9)

#define MENU_TEAM 2
#define MENU_MAPBRIEFING 4
#define MENU_CLASS_T 26
#define MENU_CLASS_CT 27
#define MENU_BUY 28
#define MENU_BUY_PISTOL 29
#define MENU_BUY_SHOTGUN 30
#define MENU_BUY_RIFLE 31
#define MENU_BUY_SUBMACHINEGUN 32
#define MENU_BUY_MACHINEGUN 33
#define MENU_BUY_ITEM 34

#define IUSER3_CANSHOOT (1<<0)
#define IUSER3_FREEZETIMEOVER (1<<1)
#define IUSER3_INBOMBZONE (1<<2)
#define IUSER3_HOLDINGSHIELD (1<<3)

#define ITEMSTATE_HASNIGHTVISION (1<<0)
#define ITEMSTATE_HASDEFUSER (1<<1)

#define SIGNAL_BUY (1<<0)
#define SIGNAL_BOMB (1<<1)
#define SIGNAL_RESCUE (1<<2)
#define SIGNAL_ESCAPE (1<<3)
#define SIGNAL_VIPSAFETY (1<<4)

stock const MAXBPAMMO[] = { -1, 52, -1, 90, 1, 32, 1, 100, 90, 1, 120, 100, 100, 90, 90, 90, 100, 120, 30, 120, 200, 32, 90, 120, 90, 2, 35, 90, 90, -1, 100 }

stock const MAXCLIP[] = { -1, 13, -1, 10, -1, 7, -1, 30, 30, -1, 30, 20, 25, 30, 35, 25, 12, 20, 10, 30, 100, 8, 30, 30, 20, -1, 7, 30, 30, -1, 50 }

stock const BUYAMMO[] = { -1, 13, -1, 30, -1, 8, -1, 12, 30, -1, 30, 50, 12, 30, 30, 30, 12, 30, 10, 30, 30, 8, 30, 30, 30, -1, 7, 30, 30, -1, 50 }

stock const AMMOID[] = { -1, 9, -1, 2, 12, 5, 14, 6, 4, 13, 10, 7, 6, 4, 4, 4, 6, 10, 1, 10, 3, 5, 4, 10, 2, 11, 8, 4, 2, -1, 7 }

stock const AMMOTYPE[][] = { "", "357sig", "", "762nato", "", "buckshot", "", "45acp", "556nato", "", "9mm", "57mm", "45acp",
			"556nato", "556nato", "556nato", "45acp", "9mm", "338magnum", "9mm", "556natobox", "buckshot",
			"556nato", "9mm", "762nato", "", "50ae", "556nato", "762nato", "", "57mm" }

stock const AMMOCOST[] = { -1, 50, -1, 80, -1, 65, -1, 25, 60, -1, 20, 50, 25, 60, 60, 60, 25, 20, 125, 20, 60, 65, 60, 20, 80, -1, 40, 60, 80, -1, 50 }

stock const WEAPONENTNAMES[][] = { "", "weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "weapon_c4", "weapon_mac10",
			"weapon_aug", "weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550",
			"weapon_galil", "weapon_famas", "weapon_usp", "weapon_glock18", "weapon_awp", "weapon_mp5navy", "weapon_m249",
			"weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552",
			"weapon_ak47", "weapon_knife", "weapon_p90" }

stock const WEAPONNAMES[][32] = { "", "P228 Compact", "", "Schmidt Scout", "", "XM1014 M4", "", "Ingram MAC-10", "Steyr AUG A1",
			"", "Dual Elite Berettas", "FiveseveN", "UMP 45", "SG-550 Auto-Sniper", "IMI Galil", "Famas",
			"USP .45 ACP Tactical", "Glock 18C", "AWP Magnum Sniper", "MP5 Navy", "M249 Para Machinegun",
			"M3 Super 90", "M4A1 Carbine", "Schmidt TMP", "G3SG1 Auto-Sniper", "", "Desert Eagle .50 AE",
			"SG-552 Commando", "AK-47 Kalashnikov", "", "ES P90" }

stock const WEAPONSLOT[] = { -1, 1, -1, 0, 3, 0, 4, 0, 0, 3, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 3, 1, 0, 0, 2, 0 }

stock const WEAPONPOSITION[] = { -1, 3, -1, 9, 1, 12, 3, 13, 14, 3, 5, 6, 15, 16, 18, 4, 2, 2, 7, 4, 5, 6, 11, 3, 2, 1, 10, 1, 1, 8 }

stock const WEAPONFLAGS[] = { 0, 0, 0, 0, 24, 0, 24, 0, 0, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 0, 0 }