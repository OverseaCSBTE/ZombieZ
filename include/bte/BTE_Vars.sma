// [BTE GLOBAL VARS]
// #################### Weapon Configs Value ######################
// === !Global ===
new g_szConfigDir[256]
new g_szMapName[64]
new g_szLogName[256],g_hLog=0,g_fwDummyResult
new g_szConfigFile[256]
new Float:g_fPlrMaxspeed[33]
// === Config Value ===
new Float:g_c_fWeaponLastTime,g_c_iKnockBackUseDmg,g_c_iStripDroppedHe,Float:g_c_fFloatDamagePercent
new Float:g_c_fZoomGravityMultiple,Float:g_c_fZoomRateOfFireMultiple
new g_c_iGenerateBuyUI

// === FIX ===
new g_isZomMod3

// ===Base===
new c_slot[MAX_WPN]
new c_type[MAX_WPN]
new c_name[MAX_WPN][64]
new c_model[MAX_WPN][32]
new c_p_sub[MAX_WPN][64]
new c_p_body[MAX_WPN]
new c_w_sub[MAX_WPN][64]
new c_w_body[MAX_WPN]
new c_p_seq[MAX_WPN]
new c_seq[MAX_WPN]
new Float:c_seqframerate[MAX_WPN]
new c_wpnchange[MAX_WPN]
new Float:c_gravity[MAX_WPN]
new c_sound[MAX_WPN]
new c_team[MAX_WPN]
new c_buy[MAX_WPN]
new Float:c_knockback[MAX_WPN]
new Float:c_reload[MAX_WPN]
new Float:c_deploy[MAX_WPN]
new Float:c_damage[MAX_WPN]
new Float:c_speed[MAX_WPN]
new c_zoom[MAX_WPN]
new c_clip[MAX_WPN]
new c_ammo[MAX_WPN]
new c_ammocost[MAX_WPN]
new Float:c_recoil[MAX_WPN]
new c_cost[MAX_WPN]
new Float:c_dmgzb[MAX_WPN]
new Float:c_dmgzs[MAX_WPN]
new Float:c_dmghms[MAX_WPN]
new c_special[MAX_WPN]
new c_model_p[MAX_WPN][64]
new c_model_v[MAX_WPN][64]
new c_model_v2[MAX_WPN][64]
new c_model_w[MAX_WPN][64]
new c_sound1[MAX_WPN][64]
new c_sound2[MAX_WPN][64]
new c_sound1_silen[MAX_WPN][64]
new c_sound2_silen[MAX_WPN][64]
new c_buymod[MAX_WPN]
new c_shake[MAX_WPN]
// -- Knife
new c_sound_miss[MAX_WPN][64],c_sound_hitwall[MAX_WPN][64],c_sound_hit[MAX_WPN][64],c_sound_stab[MAX_WPN][64]
// ===Special Weapon===
// --He Weapons
new c_he_spr[MAX_WPN],c_he_snd[MAX_WPN][64]
// --Knife Weapons
new Float:c_k_speed1[MAX_WPN],Float:c_k_speed2[MAX_WPN]
new Float:c_k_distance1[MAX_WPN],Float:c_k_distance2[MAX_WPN]
new Float:c_k_damage2[MAX_WPN]
new Float:c_k_delay1[MAX_WPN],Float:c_k_delay2[MAX_WPN]
new Float:c_k_angle[MAX_WPN]
new c_k_sequence[MAX_WPN]
// --Double Weapons
new Float:c_d_timechange1[MAX_WPN],Float:c_d_timechange2[MAX_WPN]
new Float:c_d_damage[MAX_WPN]
new Float:c_d_knockback[MAX_WPN]
new Float:c_d_speed[MAX_WPN]
new c_d_zoom[MAX_WPN]
new Float:c_d_recoil[MAX_WPN]
new c_d_clip[MAX_WPN]
new Float:c_d_reload[MAX_WPN]
new Float:c_d_deploy[MAX_WPN]
new c_d_cswpn[MAX_WPN]
new c_d_gravity[MAX_WPN]
// --Launcher Weapons
new c_l_nade[MAX_WPN]
new c_l_costammo[MAX_WPN]
new Float:c_l_timechange1[MAX_WPN],Float:c_l_timechange2[MAX_WPN]
new Float:c_l_timereload[MAX_WPN]
new Float:c_l_knockback[MAX_WPN]
new Float:c_l_radius[MAX_WPN],Float:c_l_damage[MAX_WPN]
new c_l_type[MAX_WPN]
new Float:c_l_gravity[MAX_WPN]
new c_l_lighteffect[MAX_WPN]
new Float:c_l_speed[MAX_WPN]
new Float:c_l_angle[MAX_WPN]
new Float:c_l_forward[MAX_WPN],Float:c_l_right[MAX_WPN],Float:c_l_up[MAX_WPN]
// --Special Shoot Weapons
new Float:c_sp_speed[MAX_WPN]
new c_sp_times[MAX_WPN]
// #################### Player Global Value ######################
// === Base ===
new g_weapon[33][WPN_SLOT+1]
new g_user_clip[33][WPN_SLOT+1],g_user_ammo[33][WPN_SLOT+1]
new g_double[33][2]
new g_silen[33]
new g_buyzone[33]
new g_zoom[33]
new g_attacking[33]
new g_dchanging[33]
new g_shoottimes[33],Float:g_shoottimer[33]
// === Special ===
new Float:g_wpn_m134_timer[33]
new g_wpn_m134_stat[33],Float:g_m134_shelltime[33]
new Float:g_wpn_launcher_timer[33]
new Float:g_wpn_flame_timer[33],g_wpn_flame_isshooting[33],Float:g_wpn_poison_lighttimer[33]
new g_hammer_changing[33],g_hammer_stat[33]
new g_skullaxe_stat[33],Float:g_skullaxe_timer[33],Float:g_dt_level[33],g_dt_stat[33]
new g_infinity_change[33],g_infinity_anim[33],Float:g_infinity_timer[33],g_infinity_shoot[33],Float:g_infinity_shoottimer[33]
new g_musket_stat[33],Float:g_musket_timer[33]
new Float:g_crossbow_timer[33]
new Float:g_skull1_timer[33],g_skull1_anim[33]
new Float:g_cp_timer[33],g_cp_stat[33]
new Float:g_cannon_timer[33]
new Float:g_bl7_timer[33],g_bl7_shoottime[33]
new g_bl5_shoottime[33],g_bl5_lastVictim[33]
new Float:g_bl5_timer[33],g_bl5_anim[33]

new g_sfmg_stat[33]
new g_m32_reload[33]
new Float:g_svdex_timer[33]
new g_svdex_nade[33]
new g_svdex_stat[33]
new g_svdex_ammo[33]
new Float:g_svdex_change_timer[33]
// === Other ===
new g_p_modelent[33]		//store player fake p_ model
// ##################### Other Global Vars ###############
// === Wpn & MyWpn Values ===
new g_mywpn_enable = 0
new g_wpn_count[WPN_SLOT+1]	// 0 = 1+2+3+4
new g_wpn_count_match[WPN_SLOT+1][200]
new g_mywpn_cachenum[WPN_SLOT+1] //store mywpn cache numbers
new g_mywpn_r_cache[MAX_MYWPN_RIFLES][32]
new g_mywpn_p_cache[MAX_MYWPN_PISTOLS][32]
new g_mywpn_k_cache[MAX_MYWPN_KNIFES][32]
new g_mywpn_h_cache[MAX_MYWPN_HES][32]
// === Message & Cvars ===
new g_msgScreenShake,g_msgCurWeapon,g_msgHideWeapon,g_msgAmmoPickup,g_msgWeaponList,g_msgBlinkAcct,g_msgSetFOV
new cvar_botquota, cvar_friendlyfire,g_freezetime
new cvar_freebuy,cvar_freebuyzone,cvar_SniperPrecision,cvar_dropoldwpn
// === Spr/Model Cache ===
new g_cache_blood, g_cache_bloodspray, g_cache_trail, g_cache_smoke, g_cache_explo,g_cache_firecraker_muzzle,g_cache_firecraker_exp
new g_cache_barlog7exp
new g_cache_spr_poison,g_cache_spr_flame
new Float:g_cache_frame_poison,Float:g_cache_frame_flame
new g_cache_m134shell,g_cache_musket_smoke,g_cache_cp_smoke
// === Const Spr/Model/Sound
new sound_buyammo[] = "items/9mmclip1.wav"
new sound_pickupgun[] = "items/gunpickup2.wav"
// === Other Value ===
new g_HeBlock
new g_hamczbots
new Float:g_vNull[3]
new g_fwPrecacheEvent,g_iBlockSetModel
new g_guns_eventids_bitsum
// Block Resource
new g_sBlockResource[MAX_BLOCK][512]
new g_iBlockNums

// Fix Bug
new g_lasthe[33] // fix he damage
new g_modruning
new g_modbuylimit[33][5]
new g_attack[33]

//Improve
new g_save_guns[33][5]
new g_fw_RegisterNamedWeapon
new g_custom_weapon[PRECACHE_MAX][16]
new g_custom_weapon_count

// ======= ORPHEU ========
new OrpheuFunction:handleResetSequenceInfo;
new OrpheuFunction:handleSetAnimation;

// Engine Alloc String
new g_Alloc_CyclerSprite
new Float:g_player_buff[33][BUFF_END]
new g_player_buff_tick[33][BUFF_END][4]
