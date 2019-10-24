public CreateProfile(id)
{
    set_pev(id, pev_health, 1000.0)
	set_pev(id, pev_max_health, 1000.0)
	set_pev(id, pev_armorvalue, 100.0)
    set_pev(id, pev_gravity, 0.8)

    //LevelUp(id)
}

public LevelUp(id)
{
    //if (UserLevel[id] >= MaxLevel)
        //return

    //UserLevel[id] += 1
    //UserExp[id] += 1

	engfunc(EngFunc_MessageBegin, MSG_ONE, gZombieZ, {0.0, 0.0, 0.0}, id)
	//engfunc(EngFunc_MessageBegin, MSG_ONE, gZombieZ)
    write_byte(1)
    write_string("Evolve")
}