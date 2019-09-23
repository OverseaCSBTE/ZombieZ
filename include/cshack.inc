/*
 CS HACK 模块 1.0
*/

#if defined _cshack_included
  #endinput
#endif
#define _cshack_included

#if AMXX_VERSION_NUM >= 175
 #pragma reqlib cshack
 #if !defined AMXMODX_NOAUTOLOAD
  #pragma loadlib cshack
 #endif
#else
 #pragma library cshack
#endif

#include <cshack_const.inc>

/*
 设置无回合结束

 noend : 1 为无回合结束, 0 为恢复!
*/
native CS_PatchRoundEnd(noend);

/*
 结束本回合

 delay : 延迟
 winstatus : 哪个团队胜利了?
*/
native CS_TerminateRound(Float:delay, winstatus);

/*
 获取队伍分数

 team : 队伍
 return : 返回分数
*/
native CS_GetTeamScore(team);

/*
 设置队伍分数

 team : 队伍
 score : 分数
*/
native CS_SetTeamScore(team, score);

/*
 更新队伍分数

 team : 队伍
*/
native CS_UpdateTeamScore(team);

/*
 为玩家获取一个出生点

 player : 玩家
*/
native CS_GetPlayerSpawnSpot(player);

/*
 设置 BOT 的 Command 执行频率

 value : 值
*/
native CS_SetBotCommandInterval(Float:value);

/*
 设置 BOT Full Think 执行频率

 value : 值
*/
native CS_SetBotFullThinkInterval(Float:value);

/*
 设置失败的队伍获得的金钱

 value : 值
*/
native CS_SetLoseBonus(value);

/*
 获取失败的队伍获得的金钱

 return : 返回金钱
*/
native CS_GetLoseBonus();

/*
 设置下一回合的队伍获得的金钱

 team : 队伍
 value : 值
*/
native CS_SetTeamAccount(team, value);

/*
 获取下一回合的队伍获得的金钱

 team : 队伍
 return : 返回金钱
*/
native CS_GetTeamAccount(team);

/*
 设置可允许的最大金钱

 money : 金钱
*/
native CS_PatchMaxMoney(money);

/*
 设置可允许的最小金钱

 money : 金钱
*/
native CS_PatchMinMoney(money);

/*
 设置杀敌奖励的金钱

 money : 金钱
*/
native CS_PatchKillMoney(money);

/*
 添加实体到哈希表

 entity : 实体
*/
native CS_AddEntityHash(entity);