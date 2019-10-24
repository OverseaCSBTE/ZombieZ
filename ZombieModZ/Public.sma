public CreateProfile(id)
{
    set_pev(id, pev_health, 1000.0)
	set_pev(id, pev_max_health, 1000.0)
	set_pev(id, pev_armorvalue, 100.0)

	if (get_pcvar_num(Cvar_Jump))
	{
		g_flGravity[id] = 0.8;
		set_pev(id, pev_gravity, 0.8);
	}
}

public LevelUp(id)
{
    
}