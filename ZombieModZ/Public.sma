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
    
}

public AddLevel(id)
{
    UserUnusedLevel[id]++
    client_print(id, print_chat, "Client: %d have %d level", id, UserUnusedLevel[id])
    client_print(id, print_chat, "Added %d 1 Level", id)
}

public DecLevel(id)
{
    UserUnusedLevel[id]--
}