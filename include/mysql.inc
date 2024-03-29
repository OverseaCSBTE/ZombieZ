/* MySQL functions
*
* by the AMX Mod X Development Team
*  originally developed by OLO
*
* This file is provided as is (no warranties).
*/

#if defined _mysql_included
  #endinput
#endif
#define _mysql_included

#include <dbi>

/* Opens connection. If already such exists then that will be used.
* Function returns sql id to use with other sql natives.
* Host can be plain ip or with port seperated with ':' char. */
stock mysql_connect(host[],user[],pass[],dbname[],error[],maxlength)
{
  return dbi_connect(host, user, pass, dbname, error, maxlength)
}

/* Uses an existing connection (sql) to perform a new query (query) (might close previous query if any). */
native mysql_query(sql,query[]);

/* Prepares next row of current query (sql) for read access ; returns the number of the row, 0 at end. */
native mysql_nextrow(sql);

/* Stores specified column (fieldnum) of current query (sql) in (dest) with (maxlength) characters maximum. */
native mysql_getfield(sql,fieldnum,dest[],maxlength);

/* Clears query (sql) and closes connection (if any other plugin doesn't use it). */
stock mysql_close(sql)
{
  return dbi_close(sql)
}

/* Stores last error of current query/connection (sql) in (dest) with (maxlength) characters maximum. */
stock mysql_error(sql,dest[],maxlength)
{
  return dbi_error(sql, dest, maxlength)
}