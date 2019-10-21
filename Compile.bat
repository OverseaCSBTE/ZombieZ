@echo off

:setting
set ZombieZ=BTE_Zombie_ModZ
cls
goto done

:build
"compile.exe" "%ZombieZ%.sma"
copy /y "D:\Code\Github\ZombieZ\compiled\*.amxx" "D:\CSBTE\Counter-Strike SME v7.1\cstrike\addons\amxmodx\plugins\"
del "D:\Code\Github\ZombieZ\compiled\*.amxx"
goto done

:done
echo.
echo	r. Build
echo	e. End
echo.

set /p drive= -Select- 

if '%drive%' == 'r' (
	cls
goto build)

if '%drive%' == 'e' (
goto end)

:end
exit