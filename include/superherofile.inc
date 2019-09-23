//----------------------------------------------------------------------------------------------
// Abstract Methods that must be implemented by a save superhero include file...
//
// getSaveKey(id, key[32] )
// writeMemoryTable()
// loadXP( id, key[] )
// cleanXP()
//----------------------------------------------------------------------------------------------
new gSHVaultFile[]="shvault.ini"
//----------------------------------------------------------------------------------------------
public getSaveKey(id, key[32] )
{
  new wonid=get_user_wonid(id)
  new temp[32]=""
  
  if (wonid > 0)
    num_to_str(wonid,temp,31)   // by wonid
  else
    get_user_ip(id,temp,31)      // by ip
    
  if ( strlen(temp)>=0 )  
    format(key,31,"shinfo.%s", temp)
  else
    copy(key,31,"shinfo.0")
}
//----------------------------------------------------------------------------------------------
public myFindKey( key[] )
{
  new readLine=0
  new nextLine=0
  new data[32]
  new readKey[32]
  new lengthRead
  
  if (!file_exists(gSHVaultFile) ) return -1 // Nothing to read
  do
  {
    nextLine=read_file(gSHVaultFile, readLine, data,31, lengthRead)
    parse( data, readKey, 31 )
    if ( equali( readKey, key ) ) return readLine
    readLine=nextLine
  }
  while (readLine)
  
  return -1
}
//----------------------------------------------------------------------------------------------
public writeMemoryTable()
{
  if ( !shModActive() ) return
  if ( get_cvar_num("sh_savexp")==0 ) return
  
  // Write Memory Table to File
  for (new x=1; x<gMemoryTableCount; x++)
  {
    if ( strlen(gMemoryTableKeys[x])>0 )
      writeData(x);
      
    // Can even clear the MemoryKey - if a player is disconnected no reason to save again and again...
    copy(gMemoryTableKeys[x], 31, "")
  }
  // No need to keep disconnected players around if this has been flushed...
  gMemoryTableCount=33
}
//----------------------------------------------------------------------------------------------
public writeData(x)
{
  new data[512]

  formatSaveLine(x,data)
  writeDataFile( gMemoryTableKeys[x], data);
}
//----------------------------------------------------------------------------------------------
public formatSaveLine(x, data[])
{
  // Formats Player Information and writes to file:
  new temp[512]

  // Format for output
  // NAME epochtime MM DD YYYY XPPOINTS "PSKILL1" "PSKILL2" ....
  new ftime[32], idx
  get_time("%m %d %Y %H %M",ftime,31)
  format(temp, 511, "^"%s^" %d %s %d", gMemoryTableNames[x], get_systime(), ftime, gMemoryTableXP[x] )
  for ( new p=1; p<=gMemoryTablePowers[x][0] && p < gSuperHeroCount; p++ )
  {
    idx=gMemoryTablePowers[x][p]
    if ( idx>=0 && idx <gSuperHeroCount )
    {
      add(temp, 511, " ^"")
      add(temp, 511, gSuperHeros[ idx ][hero] )
      add(temp, 511, "^"")
    }
  }
  
  copy(data, 511, temp)
}
//----------------------------------------------------------------------------------------------
public writeDataFile( key[], data[] )
{
  // Bypass vault and write file... (This takes longer of course)
  new lineLocation = myFindKey(key)
  new writeDataLine[543] // 511+31+1
  format(writeDataLine, 543, "%s %s", key, data)
    
  if ( lineLocation < 0 ) 
  {
    // Not found!  Write to End of File...
    write_file(gSHVaultFile,writeDataLine);
  }
  else
  {
    // Write over the existing line...
    write_file(gSHVaultFile,writeDataLine,lineLocation)
  }
}
//----------------------------------------------------------------------------------------------
public loadXP( id, key[] )
{
  new data[512]

  get_data(key, data);
  
  if ( strlen(data) > 20 ) 
    parseXP(id, data)
  
  updateMemoryTable(id)
}
//----------------------------------------------------------------------------------------------
public cleanXP()
{
  new SHVaultTemp[256]
  format( SHVaultTemp, 255, "%s.tmp", gSHVaultFile)
  new readLine=0
  new dataLine[543]
  new lengthRead
  new key[32], name[32], epoch[16]

  if ( !shModActive() ) return
  if ( get_cvar_num("sh_savexp")==0 ) return

  // DELETE THE PREVIOUS TEMP FILE...  
  if (!file_exists(gSHVaultFile) ) return  // Nothing to clean
  
  if ( file_exists( SHVaultTemp ) )
  {
    if ( !delete_file(SHVaultTemp) ) return
  }

  // READ THROUGH THE XP FILE LOOKING FOR OLD DATA
  do
  {
    readLine=read_file( gSHVaultFile, readLine, dataLine, 542, lengthRead)
    if ( containi( dataLine, "shinfo") >=0 && lengthRead > 0 && readLine !=0 )
    {
      parse(dataLine, key, 31, name, 31, epoch, 15)      
      if ( str_to_num(epoch) + get_cvar_num("sh_xpsavedays") * 24 * 3600 >= get_systime()  )
      {
        write_file( SHVaultTemp, dataLine )
      }
    }
  }
  while (readLine)
  
  // DELETE THE XP FILE AND COPY OVER THE DATA FROM THE TEMP XP FILE
  readLine=0
  if ( delete_file(gSHVaultFile) && file_exists(SHVaultTemp) )
  {
    // read the temp vault file...
    do
    {
      readLine=read_file(SHVaultTemp, readLine, dataLine, 542, lengthRead)
      if ( readLine !=0 && lengthRead > 0 ) write_file(gSHVaultFile, dataLine)
    } while ( readLine)
  }
}
//----------------------------------------------------------------------------------------------
public get_data(key[], temp[512] )
{
  new lineLocation=myFindKey(key)
  new dataLine[543]
  new lengthRead
  
  copy(temp,511,"")
  if ( lineLocation >= 0 )
  {
    read_file(gSHVaultFile, lineLocation, dataLine, 542, lengthRead)
    if ( lengthRead>strlen(key)+2 )
      copy(temp, 511, dataLine[ strlen(key)+1 ] )
  }
}
//----------------------------------------------------------------------------------------------
public parseXP(id, xpinfo[] )
{
  // NAME epochtime MM DD YYYY XPPOINTS "PSKILL1" "PSKILL2" ....
  new name[32], epoch[16], mm[3], dd[3], yy[5], hh[3], mi[3], xp[20]
  new skills[20][21]
  new heroIndex
  new rc
 
  rc=parse(xpinfo, name, 31, epoch, 15, mm, 2, dd, 2, yy, 4, hh, 2, mi, 2, xp, 19, skills[0], 20, skills[1], 20, skills[2], 20, skills[3], 20, skills[4],20, skills[5], 20, skills[6], 20, skills[7], 20, skills[8], 20, skills[9], 20, skills[10], 20, skills[11], 20, skills[12], 20, skills[13], 20, skills[14], 20, skills[15], 20, skills[16], 20, skills[17], 20, skills[18], 20, skills[19], 20)
  
  // Crash Check Make sure we at least got 8 parseable values
  if ( rc < 8 ) return 
  
  // OK Now set this guy up...
  new powerCount=0
  gPlayerXP[id]=str_to_num(xp)
  gPlayerLevel[id]=getLevel(id)
  setLevel(id, gPlayerLevel[id] )
  
  for ( new x=0; x<gPlayerLevel[id] && x<gNumLevels && x<rc-8; x++ )
  {
    if ( strlen(skills[x])==0 ) break;
    heroIndex=findHero( skills[x] )
    if ( heroIndex>=0 && powerCount<SH_MAXLEVELS && powerCount<get_cvar_num("sh_maxpowers") ) 
    {
      if ( getHeroLevel(heroIndex)<=gPlayerLevel[id] )
      {
        gPlayerPowers[id][0]=++powerCount
        gPlayerPowers[id][powerCount]=heroIndex
        initHero(id, heroIndex)
      }
    }
  }
}
//----------------------------------------------------------------------------------------------