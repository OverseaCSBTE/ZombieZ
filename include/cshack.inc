/*
 CS HACK ģ�� 1.0
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
 �����޻غϽ���

 noend : 1 Ϊ�޻غϽ���, 0 Ϊ�ָ�!
*/
native CS_PatchRoundEnd(noend);

/*
 �������غ�

 delay : �ӳ�
 winstatus : �ĸ��Ŷ�ʤ����?
*/
native CS_TerminateRound(Float:delay, winstatus);

/*
 ��ȡ�������

 team : ����
 return : ���ط���
*/
native CS_GetTeamScore(team);

/*
 ���ö������

 team : ����
 score : ����
*/
native CS_SetTeamScore(team, score);

/*
 ���¶������

 team : ����
*/
native CS_UpdateTeamScore(team);

/*
 Ϊ��һ�ȡһ��������

 player : ���
*/
native CS_GetPlayerSpawnSpot(player);

/*
 ���� BOT �� Command ִ��Ƶ��

 value : ֵ
*/
native CS_SetBotCommandInterval(Float:value);

/*
 ���� BOT Full Think ִ��Ƶ��

 value : ֵ
*/
native CS_SetBotFullThinkInterval(Float:value);

/*
 ����ʧ�ܵĶ����õĽ�Ǯ

 value : ֵ
*/
native CS_SetLoseBonus(value);

/*
 ��ȡʧ�ܵĶ����õĽ�Ǯ

 return : ���ؽ�Ǯ
*/
native CS_GetLoseBonus();

/*
 ������һ�غϵĶ����õĽ�Ǯ

 team : ����
 value : ֵ
*/
native CS_SetTeamAccount(team, value);

/*
 ��ȡ��һ�غϵĶ����õĽ�Ǯ

 team : ����
 return : ���ؽ�Ǯ
*/
native CS_GetTeamAccount(team);

/*
 ���ÿ�����������Ǯ

 money : ��Ǯ
*/
native CS_PatchMaxMoney(money);

/*
 ���ÿ���������С��Ǯ

 money : ��Ǯ
*/
native CS_PatchMinMoney(money);

/*
 ����ɱ�н����Ľ�Ǯ

 money : ��Ǯ
*/
native CS_PatchKillMoney(money);

/*
 ����ʵ�嵽��ϣ��

 entity : ʵ��
*/
native CS_AddEntityHash(entity);