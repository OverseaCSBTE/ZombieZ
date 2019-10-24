// Message ID
new gDeathMsg, gMsgScoreAttrib, gMsgStatusIcon, gMsgScoreInfo, gMsgScenario, 
gMsgHostagePos, gMsgFlashBat, gMsgNVGToggle, gMsgTextMsg, gMsgSendAudio, 
gMsgTeamScore, gMsgScreenFade, gMsgClCorpse, gMsgScreenShake, gMsgWeaponList, 
gMsgTeamInfo

// Cvar
new Cvar_HolsterBomb, Cvar_Jump

// Fakemeta
new gFwSpawn, gFwUserInfected, gFwDummyResult

// ZombieZ
new UserLevel[MaxPlayer], UserExp[MaxPlayer],
UserSkills[MaxPlayer][SkillEnum][2]

new SkillList[SkillEnum][2] =
{
	{ MoneyWorm, All },
	{ Boxer, Human },
	{ IncreaseAmmo, Human },
	{ FastReload, Human},
	{ InvisibleReload, Human },
	{ Cheetah, All },
	{ Kangaroo, All },
	{ EnhanceRecovery, All },
	{ FocusAttack, Human },
	{ Booster, Human },
	{ BulletAddition, Human },
	{ HuntingInstinct, All},
	{ DoubleJump, All },
	{ ExplosiveBullets, Human },
	{ ReinforcedGenes, Zombie },
	{ Resist, Zombie },
	{ FireBullets, Human },
	{ IncreaseStamina, All },
	{ ContactInfection, Zombie },
	{ Resurrection, Zombie },
	{ SteelArmor, Zombie},
	{ Flippers, Zombie },
	{ SteelHead, Zombie },
	{ Sharpshooter, Human },
	{ SixthSense, Human },
	{ HeroAppearance, All },
	{ Enthusiasm, All },
	{ Specialist, Human },
	{ ForcedFall, Human },
	{ Adaptability, Zombie },
	{ VaccineGrenade, Human },
	{ BombBackpack, Human },
	{ BombardmentSupport, Human },
	{ CriticalHit, Human },
	{ SteelBullet, Human },
	{ ShotgunGrenade, Human },
	{ BioBomb, Zombie },
	{ Fireball, Human },
	{ Elephant, Zombie },
	{ NitrogenGrenade, Human },
	{ Icarus, All},
	{ ThroughHole, Human },
	{ Elitist, Human },
	{ MoneyPower, Human},
	{ Craftsmanship, Human },
	{ HPRob, Zombie},
	{ BombHardening, Zombie },
	{ ClawStrengthening, Zombie },
	{ SkillEvolution, Zombie },
	{ SteelSkin, Zombie },
	{ Intellectual, All },
	{ Bomber, Zombie },
	{ Revenge, Zombie }
	//{ EndOfSkill, All}
}

// Unknown Yet
new Float:g_spawns[MAX_SPAWNS][3][3], Float:g_spawns_box[MAX_SPAWNS][3]
new g_spawnCount, g_spawnCount_box

// Enviroments
new g_light[2], g_skyname[32], g_fog_density[32], g_fog_color[32]
new g_sky_enable, g_ambience_rain, g_ambience_fog, g_ambience_snow

// Zombie
new ZB_LV1_HEALTH, ZB_LV1_ARMOR
new ZB_LV2_HEALTH, ZB_LV2_ARMOR
new ZB_LV3_HEALTH, ZB_LV3_ARMOR

// Settings
new Float:c_flHostHead[2], Float:c_flHostSpeed[2], Float:c_flHostJump[2]
new Float:RESTORE_HEALTH_TIME, RESTORE_HEALTH_LV1, RESTORE_HEALTH_LV2
new Float:ZOMBIEBOM_DAMAGE
new RESPAWN_TIME_WAIT = 2, ALIVE_TERM = 30, FORCERESPAWN_TIME = 45
new levelupsound

// ImproveAPI
new gmsgSpecial

// Message
new gZombieZ

// Bot
new bot_quota, g_hamczbots

// Need To Sort
new	g_newround, g_endround, g_startcount, g_rount_count

new	g_level[33], g_nvg[33], 
g_restore_health[33], g_respawning[33], g_respawn_count[33], 
g_hero[33], g_human[33], 
g_zombie[33], g_zbselected[33],g_zombie_die[33], g_zombieclass[33], 
g_zombie_health_start[33], g_zombie_armor_start[33], g_zbclass_keep[33], 
g_sidekick[33], g_iTankercount[33]

new Float:g_AliveCheckTime[33], Float:g_ForcerespawnTime

new g_szLogName[128]
new g_player_weaponstrip
