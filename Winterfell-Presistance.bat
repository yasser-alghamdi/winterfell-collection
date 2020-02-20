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
	set resultspath=%cd%\%COMPUTERNAME%\Presistance
	title (Winterfell Presistance)
	set SERV64=%toolspath%\services\PsService-64.exe
	set SERV32=%toolspath%\services\PsService-32.exe
	set PROC64=%toolspath%\process\pslist-64.exe
	set PROC32=%toolspath%\process\pslist-32.exe
	set AUTO64=%toolspath%\autoruns\autorunsc-64.exe
	set AUTO32=%toolspath%\autoruns\autorunsc-32.exe


	::SCHEDULED TASKS
	echo Enumerating Scheduled Tasks .........................!
	echo %date% %time% : Enumerating Scheduled Tasks ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Tasks
	mkdir %resultspath%\Schtask
	xcopy /S /C /H /Y %systemdrive%\Windows\System32\Tasks ^
		%resultspath%\Tasks\ 2>&1
	xcopy /S /C /H /Y %systemdrive%\Windows\SysWOW64\Tasks ^
		%resultspath%\Tasks\ 2>&1
	schtasks /query > %resultspath%\Schtask\schtasks.txt 2>&1
	echo ============================================================= ^
		>> %resultspath%\Schtask\schtasks.txt
	schtasks /query /V >> %resultspath%\Schtask\schtasks.txt 2>&1
	echo %date% %time% : Finished enumerating scheduled tasks ^
		>> %resultspath%\Winterfell_Status.log
	
	
	::SERVICES
	echo Enumerating Services Information .........................!
	echo %date% %time% : Enumerating Services Information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Services
	sc queryex > %resultspath%\Services\services.txt 2>&1
	sc queryex type= interact ^
		> %resultspath%\Services\services_interact.txt 2>&1
	sc queryex type= driver ^
		> %resultspath%\Services\services_driver.txt 2>&1
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	%SERV64% -accepteula ^
		> %resultspath%\Services\psservice.txt 2>&1
	GOTO END
	:x32
	%SERV32% -accepteula ^
		> %resultspath%\Services\psservice.txt 2>&1
	GOTO END
	:END
	echo %date% %time% : Finished enumerating services ^
		>> %resultspath%\Winterfell_Status.log
	
	::RUNNING PROCESSES
	echo Enumerating Running Processes Information .........................!
	echo %date% %time% : Enumerating Running Processes Information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Processes
	tasklist > %resultspath%\Processes\processes.txt 2>&1
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	%PROC64% -accepteula ^
		> %resultspath%\Processes\pslist.txt 2>&1
	%PROC64% -accepteula -t ^
		> %resultspath%\Processes\pslist-t.txt 2>&1
	GOTO END
	:x32
	%PROC32% -accepteula ^
		> %resultspath%\Processes\pslist.txt 2>&1
	%PROC32% -accepteula -t ^
		> %resultspath%\Processes\pslist-t.txt 2>&1
	GOTO END
	:END
	echo ===========================(shows services hosted in each process)======================= ^
		>> %resultspath%\Processes\processes.txt
	tasklist /svc ^
		> %resultspath%\Processes\processes.txt 2>&1
	echo ===========================(shows loaded modules)======================= ^
		>> %resultspath%\Processes\processes.txt
	tasklist /m ^
		> %resultspath%\Processes\processes.txt 2>&1
	echo %date% %time% : Finished Enumerating Running Processes Information ^
		>> %resultspath%\Winterfell_Status.log
	
	::AUTORUNS INFORMATION
	echo Enumerating Autoruns Information .........................!
	echo %date% %time% : Enumerating Autoruns Information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Autoruns
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	%AUTO64% -a * -h -s -t -x * ^
		> %resultspath%\Autoruns\autoruns.txt
	GOTO END
	:x32
	%AUTO32% -a * -h -s -t -x * ^
		> %resultspath%\Autoruns\autoruns.txt
	GOTO END
	:END
	echo %date% %time% : Finished enumerating autoruns information ^
		>> %resultspath%\Winterfell_Status.log

	::END OF SCRIPT
	echo %date% %time% : Winterfell-Presistance Operation is Completed ^
		>> %resultspath%\Winterfell_Status.log
	echo 
	echo Please Enter Any Key to Exit ...










