	@echo off
	chcp 65001

	echo.
	echo	 ██╗    ██╗██╗███╗   ██╗████████╗███████╗██████╗ ███████╗███████╗██╗     ██╗     
	echo	 ██║    ██║██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗██╔════╝██╔════╝██║     ██║     
	echo	 ██║ █╗ ██║██║██╔██╗ ██║   ██║   █████╗  ██████╔╝█████╗  █████╗  ██║     ██║     
	echo	 ██║███╗██║██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██╔══╝  ██╔══╝  ██║     ██║     
	echo	 ╚███╔███╔╝██║██║ ╚████║   ██║   ███████╗██║  ██║██║     ███████╗███████╗███████╗
	echo	 ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝╚══════╝╚══════╝	
	echo     "+-------------------------------------------------------------------------+
	echo     "| Winterfell is a windows batch script to collect windows forensics       |
	echo     "| data and perform threat hunting for Incident Response Investigation.    |
	echo     "| Created by yAsSeR Al-Ghamdi                                             |
	echo     "+-------------------------------------------------------------------------+
	echo.
	
	REM Get the tools directory path	
	set toolspath=%cd%\Tools
	REM Get the tools directory output
	set resultspath=%cd%\%COMPUTERNAME%\Logs
	title (Winterfell Logs)
	
	::WINDOWS LOG FILES
	echo Enumerating Windows log Files .........................!
	echo %date% %time% : Enumerating Windows Log Files ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Evtlogs
	xcopy /S /C /H /Y %Systemroot%\System32\winevt\Logs\*.evtx ^
		%resultspath%\Evtlogs\ 2>&1
	echo %date% %time% : Finished Enumerating Windows Log Files ^
		>> %resultspath%\Winterfell_Status.log
		
	::POWERSHELL HISTORY
	echo Enumerating Powershell History File .........................!
	echo %date% %time% : Enumerating Powershell History File ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\PSHistory
	for /F %%i in ('dir /b %systemdrive%\Users') do (
		IF EXIST %systemdrive%\Users\%%i\Appdata\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt (
			mkdir %resultspath%\PSHistory\%%i 2>&1
		xcopy /S /C /H /Y %systemdrive%\Users\%%i\Appdata\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt ^
			%resultspath%\PSHistory\%%i\ 2>&1
		) else (
			echo "file is not exist"
		)
	)
	echo %date% %time% : Finished Enumerating Powershell History File ^
		>> %resultspath%\Winterfell_Status.log
	
	::POWERSHELL LOGS FILES
	echo Adjusting Powershell Logs Files Format .........................!
	echo %date% %time% : Adjusting Powershell Logs Files Format ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Evtlogs\Hunting\Powershell
	echo log 1 -------------------------------- ^
		>> %resultspath%\Evtlogs\Hunting\Powershell\powershell.txt 2>&1
	wevtutil qe Microsoft-Windows-Powershell/Operational /count:1000000 /format:text ^
		>> %resultspath%\Evtlogs\Hunting\Powershell\powershell.txt 2>&1
	echo log 2 -------------------------------- ^
		>> %resultspath%\Evtlogs\Hunting\Powershell\powershell.txt 2>&1
	wevtutil qe Microsoft-Windows-Powershell/Admin /count:1000000 /format:text ^
		>> %resultspath%\Evtlogs\Hunting\Powershell\powershell.txt 2>&1
	echo log 3 -------------------------------- ^
		>> %resultspath%\Evtlogs\Hunting\Powershell\powershell.txt 2>&1
	wevtutil qe Microsoft-Windows-Powershell/Admin /count:1000000 /format:text ^
		>> %resultspath%\Evtlogs\Hunting\Powershell\powershell.txt 2>&1
	echo %DATE% %TIME% : Finished Adjusting Powershell Logs Files Format ^
		>> %resultspath%\Winterfell_Status.log
		
	::SCHEDULE TASK LOG FILE
	echo Adjusting Schedule Task Log File Format .........................!
	echo %date% %time% : Adjusting Schedule Task Log File Format ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Evtlogs\Hunting\TaskSchedule
	wevtutil qe Microsoft-Windows-TaskSchedular/Operational /count:1000000 /format:text ^
		> %resultspath%\Evtlogs\Hunting\TaskSchedule\schedule-task.txt 2>&1
	echo %date% %time% : Finished Adjusting scheduled tasks Log File Format ^
		>> %resultspath%\Winterfell_Status.log

	::TERMINAL SERVICES LOG FILES
	echo Adjusting Terminal Services Log Files Format .........................!
	echo %date% %time% : Adjusting Terminal Services Log Files Format ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Evtlogs\Hunting\TerminalServices
	wevtutil qe Microsoft-Windows-TerminalServices-RDPClient/Operational /count:1000000 /format:text ^
		> %resultspath%\Evtlogs\Hunting\TerminalServices\rdp-client.txt 2>&1
	wevtutil qe Microsoft-Windows-TerminalServices-LocalSessionManager/Operational /count:1000000 /format:text ^
		> %resultspath%\Evtlogs\Hunting\TerminalServices\local-session.txt 2>&1
	echo %date% %time% : Finished Adjusting Terminal Services Log Files Format ^
		>> %resultspath%\Winterfell_Status.log

	::SECURITY LOG FILE
	echo Adjusting Security Log File Format .........................!
	echo %date% %time% : Adjusting Security Log File Format ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Evtlogs\Hunting\Security
	wevtutil qe Security /count:1000000 /format:text ^
		> %resultspath%\Evtlogs\Hunting\Security\security.txt 2>&1
	echo %DATE% %TIME% : Finished Adjusting Security Log File Format ^
		>> %resultspath%\Winterfell_Status.log

	::WINDOWS REMOTE LOG FILE
	echo Adjusting Windows Remote Log File Format .........................!
	echo %date% %time% : Adjusting Windows Remote Log File Format ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Evtlogs\Hunting\Remote
	wevtutil qe Microsoft-Windows-WinRM/Operational /count:1000000 /format:text ^
		> %resultspath%\Evtlogs\Hunting\Remote\WinRM.txt 2>&1
	echo %DATE% %TIME% : Finished Adjusting Windows Remote Log File Format ^
		>> %resultspath%\Winterfell_Status.log

	::SMB LOGS FILES
	echo Adjusting Windows Remote Log File Format .........................!
	echo %date% %time% : Adjusting Windows Remote Log File Format ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Evtlogs\Hunting\SMB
	echo log 1 -------------------------------- ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	wevtutil qe Microsoft-Windows-SMBClient/Operational /count:1000000 /format:text ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	echo log 2 -------------------------------- ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	wevtutil qe Microsoft-Windows-SMBServer/Connectivity /count:1000000 /format:text ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	echo log 3 -------------------------------- ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	wevtutil qe Microsoft-Windows-SMBServer/Operational /count:1000000 /format:text ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	echo log 4 -------------------------------- ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	wevtutil qe Microsoft-Windows-SMBServer/Security /count:1000000 /format:text ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	echo log 5 -------------------------------- ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	wevtutil qe Microsoft-Windows-SMBWitnessClient/Admin /count:1000000 /format:text ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	echo log 6 -------------------------------- ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	wevtutil qe Microsoft-Windows-BranchCacheSMB/Operational /count:1000000 /format:text ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	echo log 7 -------------------------------- ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	wevtutil qe Microsoft-Windows-SmbClient/Connectivity /count:1000000 /format:text ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	echo log 8 -------------------------------- ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	wevtutil qe SmbWmiAnalytic /count:1000000 /format:text ^
		>> %resultspath%\Evtlogs\Hunting\SMB\smb.txt 2>&1
	echo %date% %time% : Finished Adjusting SMB Logs Files Format ^
		>> %resultspath%\Winterfell_Status.log
	
	::IIS LOGS Files
	echo Enumerating IIS log Files .........................!
	echo %date% %time% : Enumerating IIS Log Files ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\IISLogs
	IF EXIST "%SystemDrive%\inetpub" (GOTO collection) ELSE (GOTO else)
	:collection
	xcopy /S /C /H /Y %SystemDrive%\inetpub\logs\LogFiles\*.log ^
		%resultspath%\IISLogs\ 2>&1
	GOTO END
	:else
	echo "folder is not exist"
	GOTO END
	:END
	echo %date% %time% : Finished Enumerating IIS Log Files ^
		>> %resultspath%\Winterfell_Status.log		
		 
	::END OF SCRIPT
	echo %date% %time% : Winterfell-Logs Operation is Completed ^
		>> %resultspath%\Winterfell_Status.log 
	echo Please Enter Any Key to Exit ...










