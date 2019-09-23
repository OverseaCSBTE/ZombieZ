enum { 
   classname = 0, 
   target, 
   targetname 
}
/* Need to send positive number. Returns result if succeeds,
* -1 if fails. (Like if you send in a negative number.) */
native Float:sqrt_jghg(number);

/* Returns number of ents found starting from start_from_ent at position origin within
radius distance, where classname match. len is length of specified classname.
All matched ents are stored in entlist[]. Specify maximum number of ents to be found
in maxEnts.
*/
native find_ent_sphere(start_from_ent,origin[3],radius,className[],len,entlist[],maxEnts);

/* Return entity ID of owner, returns -1 if fail.  */
native getowner(id);

/* Find an entity ID from start_from_ent id (use 0 to start from
* the beginning, category is either "classname", "target" or
* "targetname", value is the name you are searching for,
* must match against specified owner_index. */
native find_ent_by_owner(start_from_ent,catagory,value[],owner_index);