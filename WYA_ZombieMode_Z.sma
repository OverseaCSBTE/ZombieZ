#include <amxmodx>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <metahook>
#include <cstrike>
#include <engine>
#include <BTE_API>
#define PLUGINNAME	"CSIE ZBZ"
#define VERSION		"1.0"
#define AUTHOR		"chiouderen"

#define skill_count 50
#define max_level 30
#define skill 0
#define weight 1
#define team 2

new is_skill_init = 0;
new z_level[33];
new z_point[33];
new SaveData_Pool[33][skill_count][3];
new SaveData_Get[33][max_level];
new SaveData_Flag[33][skill_count];
/*new perhp;
new moneyper;
new MaxHealth;
new healthup;*/
new const ZBZ_SOUND[][] = 
{
	"player/zombiez_mutation.wav"
}

///进化动作
new g_InDoingEmo[33], g_OldWeapon[33], g_OldKnifeModel[66][256]
//,z_skilling[33]
new const v_model[] = "models/v_emotion.mdl" //
#define RemoveTime 1.5 //动作持续时间

public plugin_init()
{
register_plugin(PLUGINNAME, VERSION, AUTHOR)
RegisterHam(Ham_Spawn, "player", "HAM_PlayerSpawn_Post", 1)
register_event("HLTV","Event_HLTV_New_Round","a","1=0","2=0")
/*perhp = register_cvar("zbz_hpmore", "3000")//生命补液
moneyper = register_cvar("zbz_moneymore", "8000")//金融家
MaxHealth = register_cvar("zbz_maxhealth", "200")//恢复强化获取的最大生命值
healthup = register_cvar("zbz_healthup", "15")//恢复强化每次恢复的血量*/
register_clcmd("get_points", "get_skill")//bind  v
}

public plugin_precache()
{
	new i
	for(i = 0; i < sizeof ZBZ_SOUND; i++) precache_sound(ZBZ_SOUND[i])
	engfunc(EngFunc_PrecacheModel, "models/zombiezwingfx.mdl")
	engfunc(EngFunc_PrecacheModel, v_model)
}

enum
{
	common = 0,
	human,
	zombie
}

enum
{
	moremoney=0,//金融家
	master,//格斗带师
	moreclip,//弹夹扩容
	fastreload,//高速梯安装
	alphareload,//透明换弹
	cheetah,//猎豹
	kangaroo,//袋鼠
	restore,//恢复强化
	frontattack,//正面突击
	tommyrush,//冲锋推进
	moreammo,//备弹补充
	hunt,//狩猎本能
	djump,//二段跳
	bombammo,//爆炸弹头
	geneup,//强化基因
	nogiveup,//坚持不懈
	fireammo,//点燃
	morehp,//生命补液
	easyinfection,//接触感染
	respawn,//复活
	zbarmor,//钢铁铠甲
	feetfast,//脚掌
	hardhead,//钢铁头盔
	easyshoot,//神枪手
	sixthsense,//第六感
	morehero,//狗熊出现
	craze,//狂热
	specialskills,//持之以恒
	falldown,//强制坠落
	adaptability,//适应力
	slowgrenade,//疫苗手雷
	grenadebag,//炸弹背包
	supportboom,//支援轰炸
	headstrike,//致命一击
	hardammo,//破甲弹头
	moregrenade,//连发手雷
	zombiebomb,//爆弹兽颅
	fireball,//火焰球
	Mammoth,//猛犸
	Frozengrenade,//冷冻手雷
	ekuce,//伊卡洛斯
	pydt,//贫铀弹头
	less,//少数精锐
	moneypower,//金钱之力
	weaponup,//武器熟练
	infres,//感染恢复
	zbbombup,//兽庐强化
	longknife,//合金利爪
	lesscd,//技能冷却
	miss//倾斜装甲
}

new Skill_List[skill_count][3] = 
{
	{moremoney,100,0},
	{master,100,1},
	{moreclip,100,1},
	{fastreload,50,1},
	{alphareload,100,1},
	{cheetah,25,1},
	{kangaroo,25,1},
	{restore,100,0},
	{frontattack,100,1},
	{tommyrush,100,1},
	{moreammo,100,1},
	{hunt,100,0},
	{djump,25,1},
	{bombammo,100,1},
	{geneup,25,2},
	{nogiveup,25,2},
	{fireammo,100,1},
	{morehp,100,0},
	{easyinfection,5,2},
	{respawn,100,2},
	{zbarmor,100,2},
	{feetfast,100,2},
	{hardhead,100,2},
	{easyshoot,100,1},
	{sixthsense,100,1},
	{morehero,25,0},
	{craze,100,0},
	{specialskills,100,1},
	{falldown,100,1},
	{adaptability,100,2},
	{slowgrenade,100,1},
	{grenadebag,100,1},
	{supportboom,100,1},
	{headstrike,100,1},
	{hardammo,100,1},
	{moregrenade,100,1},
	{zombiebomb,50,2},
	{fireball,100,1},
	{Mammoth,25,2},
	{Frozengrenade,100,1},
	{ekuce,25,0},
	{pydt,50,1},
	{less,15,1},
	{moneypower,50,1},
	{weaponup,50,1},
	{infres,100,2},
	{zbbombup,15,2},
	{longknife,25,2},
	{lesscd,50,2},
	{miss,50,2}
}

new Skill_Name[skill_count][] = {
	"金融家",
	"格斗大师",
	"弹夹扩充",
	"高速填装",
	"透明换弹",
	"猎豹",
	"袋鼠",
	"恢复强化",
	"正面突击",
	"冲锋推进",
	"备弹补充",
	"狩猎本能",
	"二段跳",
	"爆炸弹头",
	"强化基因",
	"坚持不懈",
	"点燃",
	"生命补液",
	"接触感染",
	"复活",
	"钢铁铠甲",
	"脚掌",
	"钢铁头盔",
	"神枪手",
	"第六感",
	"英雄出现",
	"狂热",
	"持之以恒",
	"强制坠落",
	"适应力",
	"疫苗手雷",
	"炸弹背包",
	"支援轰炸",
	"致命一击",
	"破甲弹头",
	"连发手雷",
	"爆弹兽颅",
	"火焰球",
	"猛犸",
	"冷冻手雷",
	"伊卡洛斯",
	"贫铀弹头",
	"少数精锐",
	"金钱之力",
	"武器熟练",
	"感染恢复",
	"兽颅强化",
	"合金利爪",
	"技能冷却",
	"倾斜装甲"
}

new const Skill_Info[skill_count][3][]=
{
	{"mode/zbz/zombie3z_mutation_id_000","金融家","回合开始后，获得更多$。"},
	{"mode/zbz/zombie3z_mutation_id_001","格斗大师","使用近身武器时，攻击力提升。"},
	{"mode/zbz/zombie3z_mutation_id_002","弹夹扩充","填装时一定概率装填更多的子弹。"},
	{"mode/zbz/zombie3z_mutation_id_003","高速填装","加快武器的装填速度。"},
	{"mode/zbz/zombie3z_mutation_id_004","透明换弹","装弹时身体变透明。"},
	{"mode/zbz/zombie3z_mutation_id_005","猎豹","增加移动速度。追加的移动速度不受重量影响。"},
	{"mode/zbz/zombie3z_mutation_id_006","袋鼠","增加跳跃力。追加跳跃力不受重量影响。"},
	{"mode/zbz/zombie3z_mutation_id_007","恢复强化","提高恢复能力。"},
	{"mode/zbz/zombie3z_mutation_id_008","正面突击","装备突击步枪时，定期增加移动速度和攻击力。"},
	{"mode/zbz/zombie3z_mutation_id_009","冲锋推进","装备冲锋枪时增加移动速度，定期受到追加加速效果。"},
	{"mode/zbz/zombie3z_mutation_id_010","备弹补充","增加武器的备弹。"},	
	{"mode/zbz/zombie3z_mutation_id_011","狩猎本能","定期将周围敌人指定为目标。"},	
	{"mode/zbz/zombie3z_mutation_id_012","二段跳","在空中可以再跳一次。"},
	{"mode/zbz/zombie3z_mutation_id_013","爆炸弹头","攻击几率爆炸"},
	{"mode/zbz/zombie3z_mutation_id_014","强化基因","被感染时进化为母体僵尸。"},
	{"mode/zbz/zombie3z_mutation_id_015","坚持不懈","受到攻击时低概率忽略定身和击退。"},
	{"mode/zbz/zombie3z_mutation_id_016","点燃","狙击枪命中时，使敌人燃烧。"},
	{"mode/zbz/zombie3z_mutation_id_017","生命补液","增加生命值。"},
	{"mode/zbz/zombie3z_mutation_id_018","接触感染","身体触发时触发感染。"},
	{"mode/zbz/zombie3z_mutation_id_019","复活","取得复活能力。"},
	{"mode/zbz/zombie3z_mutation_id_020","钢铁铠甲","提升防御能力。"},
	{"mode/zbz/zombie3z_mutation_id_021","脚掌","蹲下移动时增加移速。"},
	{"mode/zbz/zombie3z_mutation_id_022","钢铁头盔","降低致命打击的伤害。"},
	{"mode/zbz/zombie3z_mutation_id_023","神枪手","大幅提升狙击步枪的命中率。"},
	{"mode/zbz/zombie3z_mutation_id_024","第六感","可以感知母体僵尸的出现，亦能感知到自己即将变为母体僵尸。"},
	{"mode/zbz/zombie3z_mutation_id_025","英雄出现","拥有被选为英雄的资格。"},
	{"mode/zbz/zombie3z_mutation_id_026","狂热","通过战斗与合作变得更强大。"},
	{"mode/zbz/zombie3z_mutation_id_027","持之以恒","激活人类特殊技能。"},
	{"mode/zbz/zombie3z_mutation_id_028","强制坠落","让梯子上的敌人摔落。"},
	{"mode/zbz/zombie3z_mutation_id_029","适应力","随时改变将是种类。"},
	{"mode/zbz/zombie3z_mutation_id_030","疫苗手雷","生成一个装有疫苗的烟雾弹，处于烟雾中的僵尸会受到持续伤害。"},
	{"mode/zbz/zombie3z_mutation_id_031","炸弹背包","一定周期自动生成手雷。"},
	{"mode/zbz/zombie3z_mutation_id_032","支援轰炸","手雷爆炸时低概率进行轰炸。"},
	{"mode/zbz/zombie3z_mutation_id_033","致命一击","低概率触发致命一击。"},
	{"mode/zbz/zombie3z_mutation_id_034","破甲弹头","增加武器的射击威力。"},
	{"mode/zbz/zombie3z_mutation_id_035","连发手雷","使用投掷装备时，自动追加使用次数。"},
	{"mode/zbz/zombie3z_mutation_id_036","爆弹兽颅","受到伤害后产生爆弹兽颅。"},
	{"mode/zbz/zombie3z_mutation_id_037","火焰球","使用狙击枪射击时发射火焰球。"},
	{"mode/zbz/zombie3z_mutation_id_038","猛犸","受到伤害后产生爆弹兽颅。"},
	{"mode/zbz/zombie3z_mutation_id_039","冷冻手雷","生成一个可击退僵尸的冷冻手雷。"},
	{"mode/zbz/zombie3z_mutation_id_040","伊卡洛斯","短时间内可以滑翔。"},
	{"mode/zbz/zombie3z_mutation_id_041","贫铀弹头","增加子弹的穿透效果。"},
	{"mode/zbz/zombie3z_mutation_id_042","少数精锐","人类数量减少时，增加攻击力和移动速度。"},
	{"mode/zbz/zombie3z_mutation_id_043","金钱之力","拥有的$越多，武器的攻击力越高。"},
	{"mode/zbz/zombie3z_mutation_id_044","武器熟练","连续购买同一武器，增加攻击力。"},
	{"mode/zbz/zombie3z_mutation_id_045","感染恢复","感染时恢复周围僵尸的生命值。"},
	{"mode/zbz/zombie3z_mutation_id_046","兽颅强化","强化爆弹兽颅。"},
	{"mode/zbz/zombie3z_mutation_id_047","合金利爪","增加僵尸的攻击距离。"},
	{"mode/zbz/zombie3z_mutation_id_048","技能冷却","减少僵尸技能的冷却时间。"},
	{"mode/zbz/zombie3z_mutation_id_049","倾斜装甲","受到攻击时，一定概率不受伤害。"}

}

public HAM_PlayerSpawn_Post(id)
{
	if (!is_user_alive(id))
		return;
	set_task(2.0,"level_up",id)
	set_task(4.0,"level_up",id)
	set_task(6.0,"level_up",id)
	set_task(8.0,"level_up",id)
	set_task(10.0,"level_up",id)
	set_task(12.0,"level_up",id)
	set_task(14.0,"level_up",id)
	set_task(16.0,"level_up",id)
	set_task(18.0,"level_up",id)
}

public skill_init()
{
	new id;
	new skill_index;
	for (id = 0; id<32; id++)
	{
		z_level[id] = 21;
		z_point[id] = 21;
		for (skill_index = 0; skill_index<skill_count; skill_index++)
		{
			SaveData_Pool[id][skill_index] = Skill_List[skill_index];
		}
	}
}

public update_skill(id)
{
	new skill_index;
	new set_flag;
	new last = z_level[id]-z_point[id];
	for(skill_index = 0; skill_index < last; skill_index++)
	{
		set_flag = SaveData_Get[id][skill_index];
		SaveData_Flag[id][set_flag] = 1;
	}
}

public level_up(id)
{
	if (z_level[id] >= max_level)
	{
		return;
	}
	z_level[id]+=1;
	z_point[id]+=1;
	MH_DrawTargaImage(id,"mode/zbz/zmode_vkey",1,1,255,255,255,0.50,0.75,0,30,999.0)
	MH_DrawFontText(id,"开始进化",1,0.50,0.80,153,204,51,16,999.0,0.0,0,30)
	client_print(id, print_chat,"剩余点数 %d | 当前等级 %d ", z_point[id],z_level[id]);
}

public DrawTips(id, skill_index)
{
	if(!is_user_alive(id)) 
		return;
	if(!is_user_connected(id)) 
		return;
	if(Skill_List[skill_index][team] == common)
	{
		MH_DrawTargaImage(id,"mode/zbz/zmode_alarm_bg_common",1,1,255,255,255,0.50,0.732,0,35,2.0)
		MH_DrawTargaImage(id,Skill_Info[skill_index][0],1,1,153,204,51,0.50,0.70,0,36,2.0)
		MH_DrawFontText(id,Skill_Info[skill_index][1],1,0.50,0.760,153,204,51,15,2.0,0.2,0,31)
		MH_DrawFontText(id,Skill_Info[skill_index][2],1,0.50,0.785,153,204,51,17,2.0,0.2,0,32)
	}
	else if(Skill_List[skill_index][team] == human)
	{
		MH_DrawTargaImage(id,"mode/zbz/zmode_alarm_bg_human",1,1,255,255,255,0.50,0.732,0,35,2.0)
		MH_DrawTargaImage(id,Skill_Info[skill_index][0],1,1,137,207,240,0.50,0.70,0,36,2.0)

		MH_DrawFontText(id,Skill_Info[skill_index][1],1,0.50,0.760,137,207,240,15,2.0,0.2,0,31)
		MH_DrawFontText(id,Skill_Info[skill_index][2],1,0.50,0.785,137,207,240,17,2.0,0.2,0,32)
	}
	else if(Skill_List[skill_index][team] == zombie)
	{
		MH_DrawTargaImage(id,"mode/zbz/zmode_alarm_bg_zombie",1,1,255,255,255,0.50,0.732,0,35,2.0)
		MH_DrawTargaImage(id,Skill_Info[skill_index][0],1,1,255,99,71,0.50,0.70,0,36,2.0)
		MH_DrawFontText(id,Skill_Info[skill_index][1],1,0.50,0.760,255,99,71,15,2.0,0.2,0,31)
		MH_DrawFontText(id,Skill_Info[skill_index][2],1,0.50,0.785,255,99,71,17,2.0,0.2,0,32)
	}
	MH_DrawTargaImage(id,"mode/zbz/zmode_alarm_bg_left",1,1,255,255,255,0.374,0.732,0,33,2.0)
	MH_DrawTargaImage(id,"mode/zbz/zmode_alarm_bg_right",1,1,255,255,255,0.627,0.732,0,34,2.0)
}

public get_skill(id)
{
	if(!is_user_alive(id))
		return;
	if(!is_user_connected(id))
		return;
	if (!z_point[id])
		return;
	new last = z_level[id] - z_point[id];
	new weight_sum;
	new index;
	new EVENT_ENTITY;
	EVENT_ENTITY = engfunc(EngFunc_PrecacheEvent, 1, "events/enttouch.sc");
	for(index=0;index<skill_count-last;index++)
	{
		if(SaveData_Pool[id][index][weight]<=0)
		{
			SaveData_Pool[id][index][weight] = 1;
		}
		weight_sum += SaveData_Pool[id][index][weight];
	}
	new select = random_num(1,weight_sum);
	client_print(id, print_chat,"随机数：%d ", select);
	for(index=0;select>0&&index<skill_count-last;index++)
	{
		select -= SaveData_Pool[id][index][weight];
	}	
	SaveData_Get[id][last] = SaveData_Pool[id][index][skill];
	client_print(id, print_chat,"获得技能 %d :%s ", SaveData_Get[id][last], Skill_Name[SaveData_Get[id][last]]);
	DrawTips(id,SaveData_Get[id][last]);
	z_point[id]--;
	update_skill(id);
	Set_Emotion_Start(id);
	new Float:vecOrigin[3];
	pev(id,pev_origin,vecOrigin);
	emit_sound(id, CHAN_WEAPON, ZBZ_SOUND[0], VOL_NORM, ATTN_NORM, 0, 95+random_num(0,20));
	//engfunc(EngFunc_PlaybackEvent, FEV_HOSTONLY, id, EVENT_ENTITY, 0.0, vecOrigin, {0.0,0.0,0.0}, 0.0, 0, 131, 5, 0, 1);
	client_print(id, print_chat,"剩余点数：%d ", z_point[id]);
	if (index<(skill_count-1-last))
	{
		new skill_index;
		for (skill_index = index; skill_index<(skill_count - 1 - last); skill_index++)
		{
			SaveData_Pool[id][skill_index] = SaveData_Pool[id][skill_index + 1];
		}
	}
	if(!z_point[id])
	{
		MH_DrawTargaImage(id,"",1,1,255,255,255,0.50,0.75,0,30,999.0)
		MH_DrawFontText(id,"",1,0.50,0.80,153,204,51,16,999.0,0.0,0,30)
	}
	last = z_level[id] - z_point[id];
	for(index = 0;index < last;index++)
	{
		if(bte_get_user_zombie(id)==1)
		{
			if(Skill_List[SaveData_Get[id][index]][team] == human)
			{
				MH_DrawFontText(id,Skill_Name[SaveData_Get[id][index]],0,0.94,0.745-0.02*index,88,87,86,14,999.0,0.0,0,40+index)//灰色
			}
			else
			{
				MH_DrawFontText(id,Skill_Name[SaveData_Get[id][index]],0,0.94,0.745-0.02*index,153,204,51,14,999.0,0.0,0,40+index)//绿色
			}

		}
		else
		{
			if(Skill_List[SaveData_Get[id][index]][team] == zombie)
			{
				MH_DrawFontText(id,Skill_Name[SaveData_Get[id][index]],0,0.94,0.745-0.02*index,88,87,86,14,999.0,0.0,0,40+index)//灰色
			}
			else
			{
				MH_DrawFontText(id,Skill_Name[SaveData_Get[id][index]],0,0.94,0.745-0.02*index,153,204,51,14,999.0,0.0,0,40+index)//绿色
			}
		}
	}
	new get_skill_num[64];
	format(get_skill_num, 63, "目前已获得进化能力：%d  个", last);
	MH_DrawFontText(id,get_skill_num,1,0.925,0.765,153,204,51,12,999.0,0.0,0,34)//765
	MH_DrawFontText(id,"状态确认[L]键",1,0.925,0.785,153,204,51,12,999.0,0.0,0,35)//785
}

public Event_HLTV_New_Round()
{
	if(!is_skill_init)
	{
		skill_init();
		is_skill_init = 1;
	}
}

public Set_Emotion_Start(id)
{
	g_InDoingEmo[id] = 1
	//Set_Entity_Invisible(id, 1)
	
	Do_Set_Emotion(id)
}

public Do_Set_Emotion(id)
{

	// Set Hand Emotion
	g_InDoingEmo[id] = 1
	g_OldWeapon[id] = get_user_weapon(id)
	fm_give_item(id, "weapon_knife")
	engclient_cmd(id, "weapon_knife")
	
	pev(id, pev_viewmodel2, g_OldKnifeModel[id], 127)
	set_pev(id, pev_viewmodel2, v_model)
	Set_Weapon_Anim(id,0)

	static KnifeEnt; KnifeEnt = fm_get_user_weapon_entity(id, CSW_KNIFE)
	if(pev_valid(KnifeEnt)) set_pdata_float(KnifeEnt, 48, 1.5, 4)

	set_task(RemoveTime, "Reset_Emotion", id)//延迟
	Reset_Emotion(id)
	Reset_Emotion(id)
	Reset_Emotion(id)
	Reset_Emotion(id)
	Reset_Emotion(id)
	//if(g_InDoingEmo[id])
	//Reset_Emotion(id)


}

public Reset_Emotion(id)
{

	if(!is_user_connected(id))
		return
	if(!g_InDoingEmo[id])
		return
	RemoveEntity(id)


}

public RemoveEntity(id)
{
	Set_Entity_Invisible(id, 0)

	//if(get_user_weapon(id) == CSW_KNIFE)
	set_pev(id, pev_viewmodel2, g_OldKnifeModel[id])//获取上一把武器
	static MyOldWeapon; MyOldWeapon = g_OldWeapon[id]
	static Classname[64]; get_weaponname(MyOldWeapon, Classname, sizeof(Classname))
	engclient_cmd(id, Classname)	//切换到上一把武器
	g_InDoingEmo[id] = 0
	set_task(0.1,"Reset_Emotion",id)
}
stock Set_Weapon_Anim(id, Anim)
{
	if(!is_user_alive(id))
		return
		
	set_pev(id, pev_weaponanim, Anim)

	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, _, id)
	write_byte(Anim)
	write_byte(pev(id, pev_body))
	message_end()
}
stock Set_Entity_Invisible(ent, Invisible = 1)
{
	if(!pev_valid(ent))
		return
		
	set_pev(ent, pev_effects, Invisible == 0 ? pev(ent, pev_effects) & ~EF_NODRAW : pev(ent, pev_effects) | EF_NODRAW)
}
public fw_CmdStart(id, uc_handle, seed)
{
	if(!is_user_alive(id))
		return

	static CurButton; CurButton = get_uc(uc_handle, UC_Buttons)
	
	if((CurButton & IN_ATTACK) || (CurButton & IN_ATTACK2))
	{
		Reset_Emotion(id)
		return
	}
	
	static Float:Velocity[3], Float:Vector
	pev(id, pev_velocity, Velocity); Vector = vector_length(Velocity)
	
	if(Vector != 0.0)
	{
		Reset_Emotion(id)
		return
	}
	
}
public fw_AddToFullPack_Post(es_handle, e , ent, host, hostflags, player, pSet)
{
	if(!is_user_alive(host) && !pev_valid(ent))
		return FMRES_IGNORED
			
	set_es(es_handle, ES_Effects, get_es(es_handle, ES_Effects) | EF_NODRAW)
	return FMRES_IGNORED
}
