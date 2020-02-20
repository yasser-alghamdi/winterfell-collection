	@echo off

	echo.
	echo     "$$\      $$\ $$$$$$\ $$\   $$\ $$$$$$$$\ $$$$$$$$\ $$$$$$$\  $$$$$$$$\ $$$$$$$$\ $$\       $$\
	echo     "$$ | $\  $$ |\_$$  _|$$$\  $$ |\__$$  __|$$  _____|$$  __$$\ $$  _____|$$  _____|$$ |      $$ |
	echo     "$$ |$$$\ $$ |  $$ |  $$$$\ $$ |   $$ |   $$ |      $$ |  $$ |$$ |      $$ |      $$ |      $$ |
	echo     "$$ $$ $$\$$ |  $$ |  $$ $$\$$ |   $$ |   $$$$$\    $$$$$$$  |$$$$$\    $$$$$\    $$ |      $$ |
	echo     "$$$$  _$$$$ |  $$ |  $$ \$$$$ |   $$ |   $$  __|   $$  __$$< $$  __|   $$  __|   $$ |      $$ |
	echo     "$$$  / \$$$ |  $$ |  $$ |\$$$ |   $$ |   $$ |      $$ |  $$ |$$ |      $$ |      $$ |      $$ |
	echo     "$$  /   \$$ |$$$$$$\ $$ | \$$ |   $$ |   $$$$$$$$\ $$ |  $$ |$$ |      $$$$$$$$\ $$$$$$$$\ $$$$$$$$\
	echo     "\__/     \__|\______|\__|  \__|   \__|   \________|\__|  \__|\__|      \________|\________|\________|
	echo     "+-------------------------------------------------------------------------+
	echo     "| Winterfell is a windows batch script to collect windows forensics       |
	echo     "| data and perform threat hunting for Incident Response Investigation.    |
	echo     "| Created by yAsSeR Al-Ghamdi                                             |
	echo     "+-------------------------------------------------------------------------+
	echo.
	
	REM Get the tools directory path	
	set toolspath=%cd%\Tools
	REM Get the tools directory output
	set resultspath=%cd%\%COMPUTERNAME%\Registry
	title (Winterfell Registry)	


	::REGISTRY INFORMATION
	echo Enumerating Registry information .........................!
	echo %DATE% %TIME% : Enumerating Registry Information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Registry
	reg export HKEY_CLASSES_ROOT ^
		%resultspath%\Registry\reginfo-HKEY_CLASSES_ROOT.txt /y 2>&1
	reg export HKEY_CURRENT_USER ^
		%resultspath%\Registry\reginfo-HKEY_CURRENT_USER.txt /y 2>&1
	reg export HKEY_LOCAL_MACHINE ^
		%resultspath%\Registry\reginfo-HKEY_LOCAL_MACHINE.txt /y 2>&1
	reg export HKEY_USERS ^
		%resultspath%\Registry\reginfo-HKEY_USERS.txt /y 2>&1
	reg export HKEY_CURRENT_CONFIG ^
		%resultspath%\Registry\reginfo-HKEY_CURRENT_CONFIG.txt /y 2>&1
	reg export HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ ^
		%resultspath%\Registry\reginfo-HKEY_USER_Explorer.txt /y 2>&1
	reg export HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\ ^
		%resultspath%\Registry\reginfo-HKEY_LOCAL_CurrentVersion.txt /y 2>&1
	reg export HKEY_CLASSES_ROOT\exefile\shell\open\command ^
		%resultspath%\Registry\reginfo-HKEY_ROOT_Command.txt /y 2>&1
	reg export "HKLM\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\IMAGE FILE EXECUTION OPTIONS" ^
		%resultspath%\Registry\execution_regchk.txt /y 2>&1
	echo %DATE% %TIME% : Finished Enumerating Registry Information ^
		>> %resultspath%\Winterfell_Status.log
	
	::SUSPICIOUS REGISTRY KEY VALUES INFORMATION
	echo Enumerating suspicious registry key values information .........................!
	echo %DATE% %TIME% : Enumerating suspicious registry key values information ^
		>> %resultspath%\Winterfell_Status.log
	echo ===========================(presistance check)======================= ^
		>> %resultspath%\Registry\presistancechk.txt
	reg query HKCU\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUN ^
		>> %resultspath%\Registry\presistancechk.txt 2>&1
	reg query HKCU\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\RUNONCE ^
		>> %resultspath%\Registry\presistancechk.txt 2>&1
	echo ===========================(disabling firewall check)======================= ^
		>> %resultspath%\Registry\disfwchk.txt
	reg query HKLM\SYSTEM\CONTROLSET001\SERVICES\SHAREDACCESS\PARAMETERS\FIREWALLPOLICY\STANDARDPROFILE /v EnableFirewall ^
		| find "0x0" >> %resultspath%\Registry\disfwchk.txt 2>&1
	reg query HKLM\SYSTEM\CONTROLSET001\SERVICES\SHAREDACCESS\PARAMETERS\FIREWALLPOLICY\DOMAINPROFILE /v EnableFirewall ^
		| find "0x0" >> %resultspath%\Registry\disfwchk.txt 2>&1
	reg query HKLM\SYSTEM\CONTROLSET001\SERVICES\SHAREDACCESS\PARAMETERS\FIREWALLPOLICY\PUBLICPROFILE /v EnableFirewall ^
		| find "0x0" >> %resultspath%\Registry\disfwchk.txt 2>&1
	reg query HKLM\SYSTEM\CONTROLSET001\SERVICES\SHAREDACCESS\PARAMETERS\FIREWALLPOLICY\STANDARDPROFILE /v DISABLENOTIFICATIONS ^
		| find "0x1" >> %resultspath%\Registry\disfwchk.txt 2>&1
	reg query HKLM\SYSTEM\CONTROLSET001\SERVICES\SHAREDACCESS\PARAMETERS\FIREWALLPOLICY\DOMAINPROFILE /v DISABLENOTIFICATIONS ^
		| find "0x1" >> %resultspath%\Registry\disfwchk.txt 2>&1
	reg query HKLM\SYSTEM\CONTROLSET001\SERVICES\SHAREDACCESS\PARAMETERS\FIREWALLPOLICY\PUBLICPROFILE /v DISABLENOTIFICATIONS ^
		| find "0x1" >> %resultspath%\Registry\disfwchk.txt 2>&1
	reg query HKLM\SYSTEM\CONTROLSET001\SERVICES\SHAREDACCESS\PARAMETERS\FIREWALLPOLICY\STANDARDPROFILE /v DONOTALLOWEXCEPTIONS ^
		| find "0x0" >> %resultspath%\Registry\disfwchk.txt 2>&1
	echo ===========================(disabling security center notification)====================================== ^
		>> %resultspath%\Registry\disseccenterchk.txt
	reg query "HKLM\SOFTWARE\MICROSOFT\SECURITY CENTER" /v ANTIVIRUSOVERRIDE ^
		| find "0x1" >> %resultspath%\Registry\disseccenterchk.txt 2>&1
	reg query "HKLM\SOFTWARE\MICROSOFT\SECURITY CENTER" /v ANTIVIRUSDISABLENOTIFY ^
		| find "0x1" >> %resultspath%\Registry\disseccenterchk.txt 2>&1
	reg query "HKLM\SOFTWARE\MICROSOFT\SECURITY CENTER" /v FIREWALLDISABLENOTIFY ^
		| find "0x1" >> %resultspath%\Registry\disseccenterchk.txt 2>&1
	reg query "HKLM\SOFTWARE\MICROSOFT\SECURITY CENTER" /v FIREWALLOVERRIDE ^
		| find "0x1" >> %resultspath%\Registry\disseccenterchk.txt 2>&1
	reg query "HKLM\SOFTWARE\MICROSOFT\SECURITY CENTER" /v UPDATESDISABLENOTIFY ^
		| find "0x1" >> %resultspath%\Registry\disseccenterchk.txt 2>&1
	reg query "HKLM\SOFTWARE\MICROSOFT\SECURITY CENTER\SVC" /v ANTIVIRUSOVERRIDE ^
		| find "0x1" >> %resultspath%\Registry\disseccenterchk.txt 2>&1
	reg query "HKLM\SOFTWARE\MICROSOFT\SECURITY CENTER\SVC" /v ANTIVIRUSDISABLENOTIFY ^
		| find "0x1" >> %resultspath%\Registry\disseccenterchk.txt 2>&1
	reg query "HKLM\SOFTWARE\MICROSOFT\SECURITY CENTER\SVC" /v FIREWALLDISABLENOTIFY ^
		| find "0x1" >> %resultspath%\Registry\disseccenterchk.txt 2>&1
	reg query "HKLM\SOFTWARE\MICROSOFT\SECURITY CENTER\SVC" /v FIREWALLOVERRIDE ^
		| find "0x1" >> %resultspath%\Registry\disseccenterchk.txt 2>&1
	reg query "HKLM\SOFTWARE\MICROSOFT\SECURITY CENTER\SVC" /v UPDATESDISABLENOTIFY ^
		| find "0x1" >> %resultspath%\Registry\disseccenterchk.txt 2>&1
	echo ===========================(disabling UAC/LUA)======================= ^
		>> %resultspath%\Registry\uacdisablelua.txt
	reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system /v EnableLUA ^
		| find "0x0" >> %resultspath%\Registry\uacdisablelua.txt 2>&1
	echo ===========================(enabling LSA settings)======================= ^
		>> %resultspath%\Registry\lsaenable.txt
	reg query HKLM\SYSTEM\CURRENTCONTROLSET\CONTROL\SECURITYPROVIDERS\WDIGEST /v UseLogonCredential ^
		| find "0x1" >> %resultspath%\Registry\lsaenable.txt 2>&1
	echo ===========================(disabling proxy)======================= ^
		>> %resultspath%\Registry\disproxy.txt
	reg query "HKCU\SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\INTERNET SETTINGS" /v PROXYENABLE ^
		| find "0x0" >> %resultspath%\Registry\disproxy.txt 2>&1
	echo ===========================(modifying RDP)======================= ^
		>> %resultspath%\Registry\rdpmod.txt
	reg query "HKLM\SYSTEM\CONTROLSET001\CONTROL\TERMINAL SERVER" /v TSUSERENABLED ^
		| find "0x1" >> %resultspath%\Registry\rdpmod.txt 2>&1
	reg query "HKLM\SYSTEM\CONTROLSET001\CONTROL\TERMINAL SERVER" /v AllowRemoteRPC ^
		| find "0x1" >> %resultspath%\Registry\rdpmod.txt 2>&1
	reg query "HKLM\SYSTEM\CONTROLSET001\CONTROL\TERMINAL SERVER" /v fDenyTSConnection ^
		| find "0x0" >> %resultspath%\Registry\rdpmod.txt 2>&1
	reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v WinStationsDisabled ^
		| find "0x0" >> %resultspath%\Registry\rdpmod.txt 2>&1
	reg query "HKCU\SOFTWARE\MICROSOFT\TERMINAL SERVER CLIENT\SERVERS" /v DEFAULT 
		| find "0x0" >> %resultspath%\Registry\rdpmod.txt 2>&1
	echo ===========================(modifying file/console tracing settings)======================= ^
		>> %resultspath%\Registry\tracemod.txt
	reg query HKLM\SOFTWARE\MICROSOFT\TRACING\RASAPI32 /v ENABLEFILETRACING ^ 
		| find "0x0" >> %resultspath%\Registry\tracemod.txt
	reg query HKLM\SOFTWARE\MICROSOFT\TRACING\RASAPI32 /v ENABLECONSOLETRACING ^
		| find "0x0" >> %resultspath%\Registry\tracemod.txt	
	echo %DATE% %TIME% : Finished enumerating suspicious registry key values information ^
		>> %resultspath%\Winterfell_Status.log	
	
	::END OF SCRIPT
	echo %date% %time% : Winterfell-Registry Operation is Completed ^
		>> %resultspath%\Winterfell_Status.log
	echo 
	echo Please Enter Any Key to Exit ...

