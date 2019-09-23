#if defined _improve_included
  #endinput
#endif
#define _improve_included

enum _:MVPFLAG
{
	MVPFLAG_KILLACE = 1,
	MVPFLAG_ASSISTACE,
	MVPFLAG_INFECTACE,
	MVPFLAG_C4DEFUSE,
	MVPFLAG_C4PLANT
}

native GAME_DrawMenu(id, a[], type = 0);
native GAME_SendData(id, type, data);
native GAME_ShowDamage(id, i1, i2);
native GAME_FillScreenColor(id, r, g, b, a);
native GAME_SetTexture(id, szWpn[], szTexGroup[]);
native GAME_EndBoard(iWinTeam, iType, iMVP = 0, iMVPFlag = 0);
native GAME_SetAssist(type, id1, id2, Float:amount);
native GAME_SendAlarm(id, alarmid, bCustom = 0, sz[] = "");
native GAME_Deathmsg(killer, victim, headshot, szWpn[]);
native GAME_SendMode(iMod, iWpnLimit);
native GAME_ShowKillData(iType, iTarget, iVictim, iData[13], sWpn[]);
native GAME_DrawFollowIcon(iIndex, iFormat, szImage[], Float:vecOrigin[3], iDisplay, iShowDist, iChannal, iColor[3])
// iFormat 0 = spr(read from hud.txt) / 1 = tga(find texture in cstrike/szImage)

native GAME_DrawZGSkill(id, szIcon[], iSlot, iType, iTime);