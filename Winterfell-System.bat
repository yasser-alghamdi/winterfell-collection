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
	set resultspath=%cd%\%COMPUTERNAME%\System
	title (Winterfell System)	
	set DRIV64=%toolspath%\drive-view\DriverView-64.exe
	set DRIV32=%toolspath%\drive-view\DriverView-32.exe
	set HAND64=%toolspath%\handle\handle-64.exe
	set HAND32=%toolspath%\handle\handle-32.exe
	set DLLS64=%toolspath%\listdll\Listdlls-64.exe
	set DLLS32=%toolspath%\listdll\Listdlls-32.exe


	::USERNAME AND SID INFORMATION
	echo Enumerating username and SID information .........................!
	echo %date% %time% : Enumerating Usernames and SID Information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Userinformation
	echo User: %username%>%resultspath%\Userinformation\userinfo.txt
	echo ================================================================================ ^
		>> %resultspath%\Userinformation\userinfo.txt
	wmic useraccount get name,sid >> %resultspath%\Userinformation\userinfo.txt 2>&1
	echo ================================================================================ ^
		>> %resultspath%\Userinformation\userinfo.txt
	echo %DATE% %TIME% : Finished enumerating usernames-and-SID information ^
		>> %resultspath%\Winterfell_Status.log
	
	::USER/SESSION INFORMATION
	echo Enumerating user/session information .........................!
	echo %date% %time% : Enumerating user/session information ^
		>> %resultspath%\Winterfell_Status.log
	query user > %resultspath%\Userinformation\userinfo.txt 2>&1
	echo %date% %time% : Finished Enumerating User/Session Information ^
		>> %resultspath%\Winterfell_Status.log
	
	::SYSTEM INFORMATION
	echo Enumerating system information .........................!
	echo %date% %time% : Enumerating system information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\System
	echo ===========================(shows computer name)======================= ^
		>> %resultspath%\System\systeminfo.txt
	echo System Information: %COMPUTERNAME% > %resultspath%\System\systeminfo.txt
	echo ===========================(shows date and time)======================= ^
		>> %resultspath%\System\systeminfo.txt
	echo Date and Time: %DATE% %TIME% >> %resultspath%\System\systeminfo.txt
	echo ===========================(shows services hosted in each process)======================= ^
		>> %resultspath%\System\systeminfo.txt
	systeminfo >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows boot configuration management)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic BOOTCONFIG >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows DCOM application management)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic DCOMAPP >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows environment details)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic ENVIRONMENT >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows scheduled jobs)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic JOB >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows service application management)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic service >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows process management)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic process >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows quikc fix engineering)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic QFE >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows automatic running commands management)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic startup >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows active network connection management)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic netuse >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows NT domain management)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic NTDOMAIN >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows system accounts management)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic SYSACCOUNT >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows system drivers managament)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic SYSDRIVER >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows shared resources management)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic SHARE >> %resultspath%\System\systeminfo.txt 2>&1
	echo ===========================(shows installed software and version)======================= ^
		>> %resultspath%\System\systeminfo.txt
	wmic product get name,version >> %resultspath%\System\systeminfo.txt 2>&1
	echo %DATE% %TIME% : Finished enumerating system information ^
		>> %resultspath%\Winterfell_Status.log

	::DOMAIN TRUSTED SIDs
	echo Enumerating domain trusted SIDs .........................!
	echo %date% %time% : Enumerating domain trusted SIDs ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\TrustedSID
	nltest /domain_trusts /all_trusts /v ^
		> %resultspath%\TrustedSID\domain_trusted_SIDs.txt 2>&1
	echo %date% %time% : Finished enumerating domain trusted SIDs ^
		>> %resultspath%\Winterfell_Status.log
	
	::ENVIRONMENT SETTINGS
	echo Enumerating environment variable settings .........................!
	echo %date% %time% : Enumerating Environment Variable Settings ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Environment
	echo Environment Variable Listing for User: %USERNAME% ^
		> %resultspath%\Environment\envvariables.txt
	echo on Computer: %COMPUTERNAME% ^
		>> %resultspath%\Environment\envvariables.txt
	echo Current Date and Time: %DATE% %TIME% ^
		>> %resultspath%\Environment\envvariables.txt
	echo ============================================================= ^
		>> %resultspath%\Environment\envvariables.txt
	set >> %resultspath%\Environment\envvariables.txt
	echo %DATE% %TIME% : Finished Enumerating Environment Variable Settings ^
		>> %resultspath%\Winterfell_Status.log
		
	::DIRECTORY LISTING
	echo Enumerating Recursive Directory Listing .........................!
	echo %date% %time% : Enumerating Recursive Directory Listing ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Dirlisting
	dir %systemdrive%\ /q /s /on > %resultspath%\Dirlisting\dirlisting.txt 2>&1
	echo %date% %time% : Finished Enumerating Windows Logs Files ^
		>> %resultspath%\Winterfell_Status.log
	
	::SEURITY POLICY
	echo Enumerating the Local Security Policy .........................!
	echo %date% %time% : Enumerating the Local Security Policy ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Policies
	secedit /export /cfg %resultspath%\Policies\securitypolicy.txt 2>&1
	echo %date% %time% : Finished Enumerating the Local Security Policy ^
		>> %resultspath%\Winterfell_Status.log
	
	::AUDIT POLICY
	echo Enumerating the audit policy .........................!
	echo %date% %time% : Enumerating the audit policy ^
		>> %resultspath%\Winterfell_Status.log
	auditpol /get /category:* ^
		> %resultspath%\Policies\auditpolicy.txt 2>&1
	echo %date% %time% : Finished enumerating audit policy ^
		>> %resultspath%\Winterfell_Status.log
	
	::GROUP POLICY
	echo Enumerating the group policy .........................!
	echo %date% %time% : Enumerating the group policy ^
		>> %resultspath%\Winterfell_Status.log
	xcopy /S /C /H /Y “%windir%\System32\GroupPolicy” ^
		%resultspath%\Policies\grouppolicy.txt 2>&1
	gpresult /z > %resultspath%\Policies\grouppolicy.txt 2>&1
	echo %date% %time% : Finished enumerating the group policy ^
		>> %resultspath%\Winterfell_Status.log
	
	::SECURITY PRODUCT INFORMATION
	echo Enumerating security products information .........................!
	echo %date% %time% : Enumerating security products information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Secproduct
	echo ===========================(AV product details)======================= ^
		>> %resultspath%\Secproduct\secproinfo.txt
	WMIC /Node:localhost /Namespace:\\root\SecurityCenter  Path AntiVirusProduct ^
		>> %resultspath%\Secproduct\secproinfo.txt 2>&1
	echo ===========================(AV product details)======================= ^
		>> %resultspath%\Secproduct\secproinfo.txt
	WMIC /Node:localhost /Namespace:\\root\SecurityCenter2  Path AntiVirusProduct ^
		>> %resultspath%\Secproduct\secproinfo.txt 2>&1
	echo ===========================(FW product details)======================= ^
		>> %resultspath%\Secproduct\secproinfo.txt
	WMIC /Node:localhost /Namespace:\\root\SecurityCenter  Path FirewallProduct ^
		>> %resultspath%\Secproduct\secproinfo.txt 2>&1
	echo ===========================(FW product details)======================= ^
		>> %resultspath%\Secproduct\secproinfo.txt
	WMIC /Node:localhost /Namespace:\\root\SecurityCenter2  Path FirewallProduct ^
		>> %resultspath%\Secproduct\secproinfo.txt 2>&1
	echo ===========================(AntiSpyware product details)======================= ^
		>> %resultspath%\Secproduct\secproinfo.txt
	WMIC /Node:localhost /Namespace:\\root\SecurityCenter  Path AntiSpywareProduct  Get ^
		>> %resultspath%\Secproduct\secproinfo.txt 2>&1
	echo ===========================(AntiSpyware product details)======================= ^
		>> %resultspath%\Secproduct\secproinfo.txt
	WMIC /Node:localhost /Namespace:\\root\SecurityCenter2  Path AntiSpywareProduct  Get ^
		>> %resultspath%\Secproduct\secproinfo.txt 2>&1
	echo %date% %time% : Finished enumerating security product information ^
		>> %resultspath%\Winterfell_Status.log

	::DRIVERS INFORMATION
	echo Enumerating drivers information .........................!
	echo %date% %time% : Enumerating drivers information ^
		>> %resultspath%\Winterfell_Status.log	
	mkdir %resultspath%\Drivers
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	%DRIV64% /sort ~12 /shtml %resultspath%\Drivers\drivers.html 2>&1
	GOTO END
	:x32
	%DRIV32% /sort ~12 /shtml %resultspath%\Drivers\drivers.html 2>&1
	GOTO END
	:END
	driverquery /FO csv /V ^
		> %resultspath%\Drivers\driversqe.csv
	driverquery /SI ^
		>> %resultspath%\Drivers\driversqe.csv
	echo %date% %time% : Finished enumerating shadow files information ^
		>> %resultspath%\Winterfell_Status.log
	
	::SHADOWS FILES INFORMATION
	echo Enumerating shadow files information .........................!
	echo %date% %time% : Enumerating shadow files information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Shadows
	vssadmin list volumes >> %resultspath%\Shadows\shadowfile.txt 2>&1
	vssadmin list shadowstorage >> %resultspath%\Shadows\shadowfile.txt 2>&1
	vssadmin list shadows >> %resultspath%\Shadows\shadowfile.txt 2>&1
	echo %date% %time% : Finished enumerating shadow files information ^
		>> %resultspath%\Winterfell_Status.log
	
	::HANDLES INFORMATION
	echo Enumerating Handles Information .........................!
	echo %date% %time% : Enumerating Handles Information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Handles
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	%HAND64% -accepteula -s >> %resultspath%\Handles\handles.txt 2>&1
	echo 
	%HAND64% -accepteula -u >> %resultspath%\Handles\handles.txt 2>&1
	GOTO END
	:x32
	%HAND32% -accepteula -s >> %resultspath%\Handles\handles.txt 2>&1
	echo
	%HAND32% -accepteula -u >> %resultspath%\Handles\handles.txt 2>&1
	GOTO END
	:END
	echo %date% %time% : Finished enumerating handles information ^
		>> %resultspath%\Winterfell_Status.log

	::DLLS INFORMATION
	echo Enumerating Dlls information .........................!
	echo %date% %time% : Enumerating Dlls information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Dlls
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	%DLLS64% -accepteula -r -v >> %resultspath%\Dlls\dlls.txt 2>&1
	GOTO END
	:x32
	%DLLS32% -accepteula -r -v >> %resultspath%\Dlls\dlls.txt 2>&1
	GOTO END
	:END
	echo %date% %time% : Finished enumerating Dlls information ^
		>> %resultspath%\Winterfell_Status.log

	::END OF SCRIPT
	echo %date% %time% : Winterfell-System Operation is Completed ^
		>> %resultspath%\Winterfell_Status.log
	echo 
	echo Please Enter Any Key to Exit ...	

	
	
	
	
