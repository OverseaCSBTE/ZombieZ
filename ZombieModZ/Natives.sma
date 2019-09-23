public plugin_natives()
{
	register_native("Neko_Debug", "Native_NekoDebug", 1);
}

public Native_NekoDebug(id, msg[])
{
	message_begin(MSG_ONE, gmsgSpecial, _, id)
	write_string("NekoDebug")
	write_string(msg)
	message_end()
}