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
	set resultspath=%cd%\%COMPUTERNAME%\Locations
	title (Winterfell Location)

	::MALICIOUS LOCATIONS
	echo Enumerating Malicious Locations .........................!
	echo %DATE% %TIME% : Enumerating Malicious Locations ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\TEMP
	mkdir %resultspath%\ProgramData
	mkdir %resultspath%\Public
	xcopy /S /C /H /Y %systemdrive%\Windows\temp ^
		%resultspath%\TEMP 2>&1
	xcopy /S /C /H /Y %systemdrive%\ProgramData ^
		%resultspath%\ProgramData 2>&1
	xcopy /S /C /H /Y %public% ^
		%resultspath%\Public 2>&1
	for /F %%i in ('dir /b %systemdrive%\Users') do (
		IF EXIST c:\Users\%%i\AppData\Local\Temp (
			mkdir %resultspath%\%%i 2>&1
			mkdir %resultspath%\%%i\Temp 2>&1
			xcopy /S /C /H /Y %systemdrive%\Users\%%i\AppData\Local\Temp ^
				%resultspath%\%%i\Temp 2>&1
		) else (
			echo "folder is not exist"
		)
		IF EXIST %systemdrive%\Users\%%i\AppData\Roaming (
			mkdir %resultspath%\%%i\AppData 2>&1
			xcopy /S /C /H /Y %systemdrive%\Users\%%i\AppData\Roaming ^
				%resultspath%\%%i\AppData 2>&1
		) else (
			echo "folder is not exist"
		)
	)
	echo %DATE% %TIME% : Finished enumerating Malicious Locations ^
		>> %resultspath%\Winterfell_Status.log

	::END OF SCRIPT
	echo %date% %time% : Winterfell-Location Operation is Completed ^
		>> %resultspath%\Winterfell_Status.log
	echo Please Enter Any Key to Exit ...
