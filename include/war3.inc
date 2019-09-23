/* Warcraft 3 functions */

#if defined _war3_included
  #endinput
#endif
#define _war3_included

/* Blocks all messages with a certain index (use block_message(0) to turn it off) */
native block_message(messageid);

/* Blocks all messages with a certain index on a certain player(use block_message(0) to turn it off) */
native block_local_message(playerid, messageid);