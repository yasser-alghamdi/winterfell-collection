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
	set resultspath=%cd%\%COMPUTERNAME%\Forensics
	title (Winterfell Forensics)
	set TIML=%toolspath%\timeline\WxTCmd.exe
	set JMLS=%toolspath%\jumplist\JLECmd.exe
	set PREF64=%toolspath%\prefetch\WinPrefetchView-64.exe
	set PREF32=%toolspath%\prefetch\WinPrefetchView-32.exe
	set RCOP64=%toolspath%\rawcopy\RawCopy-64.exe
	set RCOP32=%toolspath%\rawcopy\RawCopy-32.exe
	set CHPR=%toolspath%\amcache\AppCompatCacheParser.exe
	set RECM=%toolspath%\registryexplorer\RECmd.exe
	set SBCM=%toolspath%\shellbags\SBECmd.exe
	set USJR=%toolspath%\usnjrnl\journal.exe
	set JLCM=%toolspath%\recent\JLECmd.exe
	set ALST64=%toolspath%\stream\AlternateStreamView-64.exe
	set ALST32=%toolspath%\stream\AlternateStreamView-32.exe
	set RIFI64=%toolspath%\rifiuti\x64\rifiuti-vista.exe
	set RIFI32=%toolspath%\rifiuti\x86\rifiuti-vista.exe
	set RBCM=%toolspath%\recycle\RBCmd.exe	
	
		
	::USERS TIMELINE
	echo Enumerating Users Timeline .........................!
	echo %date% %time% : Enumerating Users Timeline ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Timeline	
	for /F %%i in ('dir /b %systemdrive%\Users') do (
		IF EXIST %systemdrive%\Users\%%i\AppData\Local\ConnectedDevicesPlatform\L.%%i\ActivitiesCache.db (
			mkdir %resultspath%\Timeline\%%i 2>&1
			%TIML% -f "%systemdrive%\Users\%%i\AppData\Local\ConnectedDevicesPlatform\L.%%i\ActivitiesCache.db"^
				--csv %resultspath%\Timeline\%%i\ 2>&1
		) else (
			echo "file is not exist"
		)
	)
	echo %date% %time% : Finished enumerating users timeline^
		>> %resultspath%\Winterfell_Status.log
	
	::JUMP LIST
	echo Enumerating Jump List .........................!
	echo %date% %time% : Enumerating Jump List ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\JumpList\Windows
	mkdir %resultspath%\JumpList\Users
	mkdir %resultspath%\JumpList\ProgramData
	mkdir %resultspath%\JumpList\PerfLogs
	%JMLS% -d "%systemdrive%\Windows" --html "%resultspath%\JumpList\Windows" -q
	%JMLS% -d "%systemdrive%\Users" --html "%resultspath%\JumpList\Users" -q
	%JMLS% -d "%systemdrive%\ProgramData" --html "%resultspath%\JumpList\ProgramData" -q
	%JMLS% -d "%systemdrive%\PerfLogs" --html "%resultspath%\JumpList\PerfLogs" -q
	echo %date% %time% : Finished enumerating jump list^
		>> %resultspath%\Winterfell_Status.log
	
	::PREFETCH FILES
	echo Enumerating Prefetch Files .........................!
	echo %date% %time% : Enumerating Prefetch Files ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Prefetch
	reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /S ^
		>> %resultspath%\Prefetch\pf-parameters.txt
	xcopy /S /C /H /Y %Systemroot%\prefetch^
		%resultspath%\Prefetch\prefetch\ 2>&1
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	%PREF64% %SystemRoot%\Prefetch\*.pf /sort ~7 /shtml %resultspath%\Prefetch\htmlprefetch.html 2>&1
	GOTO END
	:x32
	%PREF32% %SystemRoot%\Prefetch\*.pf /sort ~7 /shtml %resultspath%\Prefetch\htmlprefetch.html 2>&1
	GOTO END
	:END
	echo %date% %time% : Finished enumerating prefetch files^
		>> %resultspath%\Winterfell_Status.log

	::AMCACHE HIVE
	echo Enumerating Amcache Hive .........................!
	echo %date% %time% : Enumerating Amcache Hive ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Amcache	
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	for /F %%i in ('dir /b %SystemRoot%\AppCompat\Programs') do (
		    %RCOP64% /FileNamePath:"%SystemRoot%\AppCompat\Programs\%%i" ^
				/OutputPath:%resultspath%\Amcache 2>&1
	)
	GOTO END
	:x32
	for /F %%i in ('dir /b %SystemRoot%\AppCompat\Programs') do (
			%RCOP32% /FileNamePath:"%SystemRoot%\AppCompat\Programs\%%i" ^
				/OutputPath:%resultspath%\Amcache 2>&1
	)
	GOTO END
	:END
	%CHPR% --csv %resultspath%\Amcache\AppCompat\ 2>&1
	echo %date% %time% : Finished enumerating amcache hive ^
		>> %resultspath%\Winterfell_Status.log
	
	::SRUDB HIVE
	echo Enumerating SRUDB Hive .........................!
	echo %date% %time% : Enumerating SRUDB Hive ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\SRUDB	
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	for /F %%i in ('dir /b %SystemRoot%\System32\sru') do (
		    %RCOP64% /FileNamePath:"%SystemRoot%\System32\sru\%%i" ^
				/OutputPath:%resultspath%\SRUDB 2>&1
	)
	GOTO END
	:x32
	for /F %%i in ('dir /b %SystemRoot%\System32\sru') do (
			%RCOP32% /FileNamePath:"%SystemRoot%\System32\sru\%%i" ^
				/OutputPath:%resultspath%\SRUDB 2>&1
	)
	GOTO END
	:END
	%RECM% -f %resultspath%\SRUDB\SRUDB.dat --RegEx --sd \w ^
		> %resultspath%\SRUDB\results-data.txt 2>&1
	echo %date% %time% : Finished enumerating srudb hive ^
		>> %resultspath%\Winterfell_Status.log
	
	::SHELLBAGS FILES
	echo Enumerating Shellbags Files .........................!
	echo %date% %time% : Enumerating Shellbags Files ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Shellbags
	%SBCM% -l --csv %resultspath%\Shellbags
	echo %date% %time% : Finished enumerating shellbags files ^
		>> %resultspath%\Winterfell_Status.log
	
	::NTFS USNJRNL FILE
	echo Enumerating NTFS UsnJrnl File .........................!
	echo %date% %time% : Enumerating NTFS UsnJrnl File ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\UsnJrnl
	%USJR% -d %systemdrive% > %resultspath%\UsnJrnl\usnjrnl.txt
	echo %date% %time% : Finished enumerating NTFS usnjrnl file ^
		>> %resultspath%\Winterfell_Status.log
	
	::WMI PERSISTANCE
	echo Enumerating WMI Persistance File .........................!
	echo %date% %time% : Enumerating WMI Persistance File ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\WMI
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	%RCOP64% /FileNamePath:"%systemdrive%\Windows\System32\wbem\Repository\OBJECTS.DATA" ^
		/OutputPath:%resultspath%\WMI\ 2>&1
	GOTO END
	:x32
	%RCOP32% /FileNamePath:"%systemdrive%\Windows\System32\wbem\Repository\OBJECTS.DATA" ^
		/OutputPath:%resultspath%\WMI\ 2>&1
	GOTO END
	:END
	echo %date% %time% : Finished enumerating WMI persistance file ^
		>> %resultspath%\Winterfell_Status.log
		
	::RECENT FILES
	echo Enumerating Recent Files .........................!
	echo %date% %time% : Enumerating Recent Files ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Recent
	for /F %%i in ('dir /b %systemdrive%\Users') do (
		IF EXIST %systemdrive%\Users\%%i\AppData\Roaming\Microsoft\Windows\Recent (
			mkdir %resultspath%\Recent\%%i 2>&1
			xcopy /S /C /H /Y %systemdrive%\Users\%%i\AppData\Roaming\Microsoft\Windows\Recent ^
				%resultspath%\Recent\%%i\ 2>&1
			%JLCM% -d "%userprofile%\AppData\Roaming\Microsoft\Windows\Recent" ^
				--dumpTo %resultspath%\Recent --fd -q > %resultspath%\Recent\recent.txt 2>&1
		) else (
			echo "folder is not exist"
		)
	)
	echo %date% %time% : Finished enumerating recent files ^
		>> %resultspath%\Winterfell_Status.log
	
	::SYSTEM CONFIGURATION
	echo Enumerating System Configuration Files .........................!
	echo %date% %time% : Enumerating System Configuration Files ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\SysConfig
	xcopy /S /C /H /Y %systemdrive%\Windows\System32\config ^
		%resultspath%\SysConfig\ 2>&1
	echo %date% %time% : Finished enumerating system configuration files ^
		>> %resultspath%\Winterfell_Status.log
		
	::ALTERNATIVE STREAM FILES
	echo Enumerating Alternative Stream Files .........................!
	echo %date% %time% : Enumerating Alternative Stream Files ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Stream
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	%ALST64% /FolderPAth "%userprofile%" /ScanSubfolders 1 /SubFolderDept 10 /ShowZeroLengthStreams 1  /scomma %resultspath%\Stream\Streams.csv
	GOTO END
	:x32
	%ALST32% /FolderPAth "%userprofile%" /ScanSubfolders 1 /SubFolderDept 10 /ShowZeroLengthStreams 1  /scomma %resultspath%\Stream\Streams.csv
	GOTO END
	:END
	echo %date% %time% : Finished enumerating alterantive stream files ^
		>> %resultspath%\Winterfell_Status.log
	
	::BMC CACHE
	echo Enumerating BMC Cache Files .........................!
	echo %date% %time% : Enumerating BMC Cache Files ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\BMC
	for /F %%i in ('dir /b %systemdrive%\Users') do (
		IF EXIST "%systemdrive%\Users\%%i\AppData\Local\Microsoft\Terminal Server Client\Cache" (
			mkdir %resultspath%\BMC\%%i 2>&1
			xcopy /S /C /H /Y %systemdrive%\Users\%%i\AppData\Local\Microsoft\Terminal Server Client\Cache ^
				%resultspath%\BMC\%%i\ 2>&1
		) else (
			echo "files are not exist"
		)
	)
	echo %date% %time% : Finished enumerating BMC cache files ^
		>> %resultspath%\Winterfell_Status.log
	
	::RECYCLE BIN FILES
	echo Enumerating Recycle Bin Files .........................!
	echo %date% %time% : Enumerating Recycle Bin Files ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Recycle
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	for /F %%i in ('dir /s /b %systemdrive%\$Recycle.Bin') do (
		%RIFI64% -n --localtime %%i ^
			>> %resultspath%\Recycle\recycle-rifiuti.txt 2>&1
		%RBCM% -f %%i ^
			>> %resultspath%\Recycle\recycle1-RBCmd.txt 2>&1
		)
	GOTO END
	:x32
	for /F %%i in ('dir /s /b %systemdrive%\$Recycle.Bin') do (
		%RIFI32% -n --localtime %%i ^
			>> %resultspath%\Recycle\recycle-rifiuti.txt 2>&1
		%RBCM% -f %%i ^
			>> %resultspath%\Recycle\recycle-RBCmd.txt 2>&1
		)
	GOTO END
	:END
	echo %date% %time% : Finished enumerating recycle bin files^
		>> %resultspath%\Winterfell_Status.log
	
	::USRCLASS HIVE
	echo Enumerating UsrClass Hive .........................!
	echo %date% %time% : Enumerating UsrClass Hive ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\UsrClass	
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	for /F %%i in ('dir /b %systemdrive%\Users') do (
		IF EXIST %systemdrive%\Users\%%i\AppData\Local\Microsoft\Windows\UsrClass.dat (
			mkdir %resultspath%\UsrClass\%%i 2>&1
			%RCOP64% /FileNamePath:"%systemdrive%\Users\%%i\AppData\Local\Microsoft\Windows\UsrClass.dat" ^
				/OutputPath:%resultspath%\UsrClass\%%i\ 2>&1
			%RCOP64% /FileNamePath:"%systemdrive%\Users\%%i\AppData\Local\Microsoft\Windows\UsrClass.dat.LOG1" ^
				/OutputPath:%resultspath%\UsrClass\%%i\ 2>&1
			%RCOP64% /FileNamePath:"%systemdrive%\Users\%%i\AppData\Local\Microsoft\Windows\UsrClass.dat.LOG2" ^
				/OutputPath:%resultspath%\UsrClass\%%i\ 2>&1
			ping localhost -n 15 >NUL
			%RECM% -f %resultspath%\UsrClass\%%i\UsrClass.dat --RegEx --sd \w ^
				> %resultspath%\UsrClass\%%i\results-data.txt 2>&1
		) else (
			echo "file is not exist"
		)
	)
	GOTO END
	:x32
	for /F %%i in ('dir /b %systemdrive%\Users') do (
		IF EXIST %systemdrive%\Users\%%i\AppData\Local\Microsoft\Windows\UsrClass.dat (
			mkdir %resultspath%\UsrClass\%%i 2>&1
			%RCOP32% /FileNamePath:"%systemdrive%\Users\%%i\AppData\Local\Microsoft\Windows\UsrClass.dat" ^
				/OutputPath:%resultspath%\UsrClass\%%i\ 2>&1
			%RCOP32% /FileNamePath:"%systemdrive%\Users\%%i\AppData\Local\Microsoft\Windows\UsrClass.dat.LOG1" ^
				/OutputPath:%resultspath%\UsrClass\%%i\ 2>&1
			%RCOP32% /FileNamePath:"%systemdrive%\Users\%%i\AppData\Local\Microsoft\Windows\UsrClass.dat.LOG2" ^
				/OutputPath:%resultspath%\UsrClass\%%i\ 2>&1
			ping localhost -n 15 >NUL
			%RECM% -f %resultspath%\UsrClass\%%i\UsrClass.dat --RegEx --sd \w ^
				> %resultspath%\UsrClass\%%i\results-data.txt 2>&1
		) else (
			echo "file is not exist"
		)
	)	
	GOTO END
	:END
	echo %date% %time% : Finished enumerating usrclass hive ^
		>> %resultspath%\Winterfell_Status.log
	
	::NTUSER HIVE
	echo Enumerating NTUser Hive .........................!
	echo %date% %time% : Enumerating NTUser Hive ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\NTUser	
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64 
	for /F %%i in ('dir /b %systemdrive%\Users') do (
		IF EXIST %systemdrive%\Users\%%i\NTUSER.DAT (
			mkdir %resultspath%\NTUser\%%i 2>&1
			%RCOP64% /FileNamePath:"%systemdrive%\Users\%%i\NTUSER.DAT" ^
				/OutputPath:%resultspath%\NTUser\%%i\ 2>&1
			%RCOP64% /FileNamePath:"%systemdrive%\Users\%%i\NTUSER.DAT.LOG1" ^
				/OutputPath:%resultspath%\NTUser\%%i\ 2>&1
			%RCOP64% /FileNamePath:"%systemdrive%\Users\%%i\NTUSER.DAT.LOG2" ^
				/OutputPath:%resultspath%\NTUser\%%i\ 2>&1
			ping localhost -n 15 >NUL
			%RECM% -f %resultspath%\NTUser\%%i\NTUSER.DAT --RegEx --sd \w ^
				> %resultspath%\NTUser\%%i\results-data.txt 2>&1
		) else (
			echo "file is not exist"
		)
	)
	GOTO END
	:x32
	for /F %%i in ('dir /b %systemdrive%\Users') do (
		IF EXIST %systemdrive%\Users\%%i\NTUSER.DAT (
			mkdir %resultspath%\NTUser\%%i 2>&1
			%RCOP32% /FileNamePath:"%systemdrive%\Users\%%i\NTUSER.DAT" ^
				/OutputPath:%resultspath%\NTUser\%%i\ 2>&1
			%RCOP32% /FileNamePath:"%systemdrive%\Users\%%i\NTUSER.DAT.LOG1" ^
				/OutputPath:%resultspath%\NTUser\%%i\ 2>&1
			%RCOP32% /FileNamePath:"%systemdrive%\Users\%%i\NTUSER.DAT.LOG2" ^
				/OutputPath:%resultspath%\NTUser\%%i\ 2>&1
			ping localhost -n 15 >NUL
			%RECM% -f %resultspath%\NTUser\%%i\NTUSER.DAT --RegEx --sd \w ^
				> %resultspath%\NTUser\%%i\results-data.txt 2>&1
		) else (
			echo "file is not exist"
		)
	)
	GOTO END
	:END
	echo %date% %time% : Finished enumerating ntuser hive ^
		>> %resultspath%\Winterfell_Status.log

	::END OF SCRIPT
	echo %date% %time% : Winterfell-Forensics Operation is Completed ^
		>> %resultspath%\Winterfell_Status.log
	echo 
	echo Please Enter Any Key to Exit ...	
