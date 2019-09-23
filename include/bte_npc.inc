//native bte_npc_is_npc(id)
native bte_npc_register_class(name[],model[],health,speed,sex,modelindex,money,skilltime,damage)
native bte_npc_get_class(iEnt)
native bte_npc_set_think(iEnt, think)
native bte_npc_get_think(iEnt)

forward bte_npc_think(iEnt)
forward bte_npc_create(iEnt)
forward bte_npc_dead(iEnt,iAttacker,isRoundEnd)

enum (+=1) {		
	THINK_MOVE = 1,
	THINK_DEATH,
	THINK_SKILL_TANK,
	THINK_SKILL_SPEED
}
new const   ANIM_DEAD=2
new const	ANIM_ATTACK_RUN=14
new const	ANIM_ATTACK_WALK=13

enum (+=1) {		
	ANIM_IDLE = 3,
	ANIM_WALK,
	ANIM_RUN

}
enum (+=1) {		
	MALE = 0,
	FEMALE
}

