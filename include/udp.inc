/* Rcon and Query
 *
 * (c) Copyright 2002, OLO
 *
 * This file is provided as is (no warranties).
 */

#if defined _udp_included
  #endinput
#endif
#define _udp_included

/* Prepares internet address. 
* Function returns id of set address. */
native set_iaddress(const address[],port);

/* Sends message to the given destination. */
native send_udp_msg(iaddress,const format[],{Float,_}:...);

/* Query destination server. */
native query_udp_msg(iaddress,output[],len,const format[],{Float,_}:...);

/* Crypt data with given salt. */
native crypt_data(const data[],const salt[],output[],len);

/* Returns true on UDP init. success. */
native get_udp_status();

/* Challenge the rcon access. */
native challenge_rcon(iaddress,const rconpass[]);

/* Send rcon command. Use after challenge only. */
native send_rcon_cmd(iaddress,const format[],{Float,_}:...);