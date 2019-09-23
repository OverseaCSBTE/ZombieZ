#if defined _translator_included
  #endinput
#endif
#define _translator_included


/* We want this file to be included first */
#assert !defined _amxmod_included
#assert !defined _amxmisc_included
#assert !defined _string_included


/* Must be called by plugins before using _T (generally in plugin_init) */
native load_translations(const file[]);


/* Translation backend, used by _T (since natives can't return arrays). */
native translate(const string[],destid=-1);


/* The magical translation function: _T
*
* destid sets the destination so that the string can be translated to the
* server's (destid=0) or client's (destid=1 to 32) language.
*
* destid MUST be omitted (anyway it will be ignored) with:
*   register_plugin (in plugin name)
*   register_srvcmd, register_clcmd, register_concmd (in command info)
*
* destid CAN be omitted (recommended btw) with:
*   client_print, engclient_print, console_print, server_print, show_hudmessage, client_cmd
*
* destid CANNOT be omitted (it would generate errors) with:
*   format, copy, add (of course _T can't be used as the destination for these functions)
*   equal, equali (_T can be used both for the 1st and the 2nd strings)
*                 (destid MUST be specified even if you use _T twice)
*
* _T cannot be used in other functions (you'll get weird things otherwise, don't even try :P)
*
*/
new TranslationResult[2] = {0, 0}
stock _T(const string[], destid=-1)
{
	TranslationResult[0] = translate(string,destid)
	return TranslationResult
}
