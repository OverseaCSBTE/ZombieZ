#if defined _improve_included
  #endinput
#endif
#define _improve_included

// All of these native doing is in BTE.dll and BTE_Weapon2.amxx.

enum _:MVPFLAG
{
	MVPFLAG_KILLACE = 1,
	MVPFLAG_ASSISTACE,
	MVPFLAG_INFECTACE,
	MVPFLAG_C4DEFUSE,
	MVPFLAG_C4PLANT
}

// Draw Menu (Zombie Selection)
// use '#' to classify characters. / ex ) tank_zombi#speed_zombi# ..
// use '!' to limit characters. / ex ) ..#!pc_zombi# → pc_zombi is unable to select in selection.
// type is 0 or 1. 1 is Weapon Selection, 0 is Zombie Selection.
native GAME_DrawMenu(id, a[], type = 0);


// Send Data (Various function)
// Type 0 - Chaser state. if data is bigger than 100, it consider as statement option. (able to dash, full of gauge...)
// else it means the gauge of chaser. (0 - 100)
// Type 1 - Extra Health (Hero Zombies)
// Type 2 - Max Extra Health (Hero Zombies, to display hp bar in newhud.)
// Type 3 - JanusMode. 1 is on, 0 is off.
// Type 4 - Buff hit effect. if data is bigger than 1, It shows hit effects.
native GAME_SendData(id, type, data);

// Show Damage (Only in buff class (class.ini, Tran..?))
// i1 is Last damage, i2 is total damage.
native GAME_ShowDamage(id, i1, i2);

// Unusual Fuction. I disabled it.
native GAME_SetTexture(id, szWpn[], szTexGroup[]);

// End Board (round data board)
// iWinTeam - 1 is CT, 2 is T.
// Type - 1 : Team Death Match, 2 - Zombie Mode, 3 - Death Match, 4 - Zombie Ext..?
// iMvp - Custom MVP (like bomb planter, defuser)
// iMVPFlag - Check the upper data
native GAME_EndBoard(iWinTeam, iType, iMVP = 0, iMVPFlag = 0);

// Set Assist Statement (For killlog, Alarm function)
// type - 0 : damage assist. (when hit enemy)
// type - 1 : Zombie grenade explosion.
// type - 2 : Zombie grenade pass. (Pass Zombie). - But disabled a moment.
// id1 - index (attacker, attacker, owner)
// id2 - target (victim, victim, receiver)
// amount - (damage amount, available time to assist, available time to assist)
native GAME_SetAssist(type, id1, id2, Float:amount);

// Set Alarm State
// id - index want to show alarm.
// alarmid - alarm id to display (if alarm is not custom)
// sz - Custom Alarm's name (alarm data is read from 'cstrike/alarms.ini') only valid when bCustom is true(1).
native GAME_SendAlarm(id, alarmid, bCustom = 0, sz[] = "");

// Show KillData (Show Detail Kill information)
// iType - 0 : Killer
// iType - 1 : Victim (Killer → Victim Data)
// iType - 2 : Victim (Victim → Killer Data)
// iTarget - The user want to display kill data.
// iVictim - The target to show interaction. (required to display nickname)
// iData - 0 : Distance / 1~5 : Damage[Hitgroup] / 6~10 : Shot[Hitgroup] / 11~12 : Health,Armor state of enemy
// sWpn - the weapon victim used to kill.
native GAME_ShowKillData(iType, iTarget, iVictim, iData[13], sWpn[]);

// Zombie Send Score Effect (Zombie Revival)
// iIndex - player want to display effect
// iType - SkillPoint icon type
// 0 : Heal (Heal Zombie)
// 1 : Smoke (Psycho Zombie)
// 2 : Shock (Deimos)
// 3 : Folling (Banshee)
// 4 : Stamping (Stamper)
// 5 : Zombie Grenade (Pass Zombie)
// iValue - SkillPoint want to display.
// iScore - Score point. add value to iIndex's score, and display score effect after skillpoint display.
native GAME_SendScore(iIndex, iType, iValue, iScore);

// Head Sprite Effect
// iIndex - player want to draw headsprite
// szSprite - sprite model name. can input model format.
// scale - sprite's scale (of course not valid in model)
// framerate - Sprite → Frame per value * 0.1 (ex:5.0 →  add 1 frame per 0.5s). Only Valid in iPlay = 1.
// Model - set Animation Framerate value * 0.1. just think pev_framerate at model animation.
// iLife - Sprite's life. (second), pEnt->die = (Currenttime) + iLife + 1.0f;
// iLength - Height of iIndex. / ex ) iLentgh = 50 → sprite always upper 50.0 than player's origin.z
// iPlay - I.Sprite - 1 : Animation loop, 2 : frame proportionally increase pEnt->die.
// iLocal - player only can see effect (Everyone can see effect if iLocal is 0)
native GAME_HeadSprite(iIndex, szSprite[], Float:scale, Float:framerate, iLife, iLength, iPlay, iLocal = 0);

// Send Sound (Emit Sound)
// Just think emit_sound. but it doesn't require precache.
// If iPlayer is not 0, only iPlayer can heard sound.
native GAME_PlaySound(index, Float:vecOrigin[3], iChan, szSound[], Float:fVolume, Float:fAttenuation, iFlag, iPitch, iPlayer = 0);

// Send Player Health
// Function for heal zombie.
native GAME_PlayerHealth(index, iHealth, iMaxHealth)

// Unusual Fuction. Will update later.
native GAME_DrawZGSkill(id, szIcon[], iSlot, iType, iTime);

// Send Zombies to update keeplist to BTE.dll
// example : tank_zombi#speed_zombi#
// if zombie has '!' on the first of name, the zombie is banned(can be shown, but unable to select)
native GAME_DrawKeepMenu(id, a[]);

// Display Sprite on Screen.
// id = player to show image
// szSprite = Sprite name (ex : sprites/640hud1)
// vecScreen = Position the sprite draws, unusual when iAttachment is not 0.
// fSize = width, height
// iAttachment = viewmodel attachment.
// fFadeTime = fadein, fadeout
// fDisplayTime = Display Time.
// iType = 1 - Loop, 2 - Force stop when frame is on maxframe
// iChan = Channel, if value is 0, channel is set to the blank channel. (1 - 254)
native GAME_DrawScreenSprite(id, szSprite[], Float:vecScreen[2] = {0.0, 0.0}, Float:fSize[2] = {0.0, 0.0}, iAttachment = 0, Float:fFadeTime[2] = {0.0, 0.0}, Float:fDisplayTime = 0.0, iType = 0, iChan = 0);
