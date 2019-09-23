#define BTE_STRING 1
#define BTE_FLOAT 2
#define BTE_INT 3
#define BTE_VECTOR 4
#define BTE_ENTITY 5
#define BTE_BOOL 6
#define BTE_SHORT 7
#define BTE_POINTER 3

#define BTE_IGNORED 1
#define BTE_HANDLED 2
#define BTE_OVERRIDE 3
#define BTE_SUPERCEDE 4

enum
{
	FUNC_FireBullets,
	FUNC_FireBullets3,

	FUNC_DefaultDeploy,
	FUNC_DefaultReload,

	FUNC_RestartRound,
	FUNC_CanHavePlayerItem,

	FUNC_BuyGunAmmo,
};

native BTE_HookFunc(func, any:...);
native BTE_UnHookFunc(handle);
native BTE_CallFunc(func, any:...);
native BTE_SuperCallFunc(func, any:...);
native BTE_GetFuncReturn(type, origin, any:...);
native BTE_SetFuncReturn(type, origin, any:...);
native BTE_GetFuncParam(type, param, any:...);
native BTE_SetFuncParam(type, param, any:...);

enum
{
	EXTRA_szClassName,
	EXTRA_szName,
	EXTRA_szModel,
	EXTRA_szViewModel,
	EXTRA_szWeaponModel,
	EXTRA_szWorldModel,
	EXTRA_flSpread,
	EXTRA_flDistance,
	EXTRA_iPenetration,
	EXTRA_flRangeModifier,
	EXTRA_flDamage,
	EXTRA_flPunchangle,
	EXTRA_flAttackInterval,
	EXTRA_iMaxClip,
	EXTRA_iMaxAmmo,
	EXTRA_flReloadTime,
	EXTRA_iReloadAnim,
	EXTRA_flDeployTime,
	EXTRA_iDeployAnim,
	EXTRA_iDefaultAmmo,
	EXTRA_iZoom,
	EXTRA_iZoom2,
	EXTRA_iMaxSpeed,
	EXTRA_iZoomMaxSpeed,
	EXTRA_usEvent,
	EXTRA_szAnimExtention,
};

native BTE_PrecacheWeaponConfig(filename[]);
native BTE_GivePlayerWeapon(id, classname[]);
native BTE_IsWeaponHasExtra(ent);
native BTE_GetWeaponExtraData(ent, extra, any:...);
native BTE_SetWeaponExtraData(ent, extra, any:...);
native BTE_SetWeaponExtraCustomData(ent, key[], value[]);
native BTE_GetWeaponExtraCustomData(ent, key[], value[], maxsize);

native BTE_GetEntityPointer(ent);
native BTE_GetGameRulesPointer();
native BTE_SetPointerData(pointer, type, offset, any:...);
native BTE_GetPointerData(pointer, type, offset, any:...);
native BTE_GetEntityFromPointer(pointer);

native BTE_SetBotCommandInterval(Float:value);
native BTE_SetBotFullThinkInterval(Float:value);
native BTE_SetBotFrameInterval(Float:value);