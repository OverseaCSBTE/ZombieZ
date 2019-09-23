/*
*
* Multi-threading functions
*
* (c) Copyright 2003, dJeyL
* This file is provided as is (no warranties).
*
*/

#if defined _mthread_included
  #endinput
#endif
#define _mthread_included


/* Threads OS priorities */
#define THREAD_SYSPRIO_LOW 0
#define THREAD_SYSPRIO_NORM 1
#define THREAD_SYSPRIO_HIGH 2


/* Threads queuing types */
#define THREAD_QUEUE_NONE 0
#define THREAD_QUEUE_LOCAL 1
#define THREAD_QUEUE_GLOBAL 2


/* Starts a thread.
*
*  Parameters :
*    funcname  : plugin function to run in the thread
*  Optional parameters :
*    parameter : string parameter to be passed to the thread
*    len       : parameter length (required if using parameter)
*    onkill    : plugin function to be called if thread is killed
*                (it will not be called in the thread but in the main process)
*    sysprio   : OS-level thread priority
*                ! warning !
*                  NORM means "do not change", so in case of a queued thread
*                  it will inherit its priority from the thread which termination
*                  allowed it to run
*    queue     : queuing method
*                 NONE   : run immediately (really create a new thread)
*                 LOCAL  : wait for any local (current plugin's) thread to terminate, then run
*                          (use the same system thread right after)
*                          (if no thread running for the calling plugin, it's created)
*                 GLOBAL : wait for any thread (from any plugin) to terminate, then run
*                          (created if none)
*                          ! warning !
*                            you can not be sure that your thread will be run (for example, if the
*                            only other thread is a big loop constantly running), so you'd better
*                            queue as LOCAL
*    priority  : priority (compared to other AMX threads), min=0, max=255
*    oncancel  : plugin function to be called if the thread is remove from queue without being executed
*                ('onkill' function will not be called) ('oncancel' will be run in the main process)
*
*  Return values :
*    thread id on success
*    0 on error
*/
native thread_run(funcname[],parameter[]="",len=0,onkill[]="",sysprio=THREAD_SYSPRIO_LOW,queue=THREAD_QUEUE_NONE,priority=128,oncancel[]="");

/* Gets own thread id.
*  Return values :
*    thread id on success
*    0 if calling function not running in a thread (server main process)
*/
native thread_id();

/* Kills specified thread.
*  Return values :
*    thread id on success
*    0 on error
*/
native thread_kill(id);

/* Outputs a list of threads to server console. */
native thread_debug();

/* Kills/unqueues all calling plugin's threads.
*  Return value : number of threads killed/unqueued.
*/
native thread_killmine();

/* Kills/unqueues all threads.
*  Use carefully cause it kills/unqueues any plugin's threads.
*  Prefer using thread_killmine.
*  Return value : number of threads killed/unqueued.
*/
native thread_killall();

/* Searches a thread, by function name.
*  Return values :
*    thread id if found
*    0 if not found
*  Note : specify an empty funcname ("") to search all threads
*/
native thread_search(funcname[],index=1);

/* Searches a local (plugin's) thread, by function name.
*  Return values :
*    thread id if found
*    0 if not found
*  Note : specify an empty funcname ("") to search all plugin's threads
*/
native thread_searchmine(funcname[],index=1);

/* Checks a thread id.
*  Return values :
*    tid if thread exists
*    0 if not found
*/
native thread_isvalid(tid);

/* Indicates whether a thread is running a function from current plugin.
*  Return values :
*    tid if true
*    0 if false or invalid tid
*/
native thread_ismine(tid);

/* Indicates whether a thread is running or just queued.
*  Return values :
*    tid if running
*    0 if queued or invalid tid
*/
native thread_isrunning(tid);

/* Gets a thread's function name.
*  Return values :
*    tid if found (output set to function name)
*    0 if not found (output set to empty string)
*/
native thread_getname(tid,output[],len);

/* Counts threads. */
native thread_count();

/* Counts current plugin's threads. */
native thread_countmine();

/* Suspends thread execution.
*  Return values :
*    seconds on success
*    0 if called in an unthreaded function
*/
native thread_sleep(seconds);
