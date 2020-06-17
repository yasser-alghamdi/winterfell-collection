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
	set resultspath=%cd%\%COMPUTERNAME%\Web
	title (Winterfell Web)
	set BRHI64=%toolspath%\browsinghistoryview\BrowsingHistoryView64.exe
	set BRHI32=%toolspath%\browsinghistoryview\BrowsingHistoryView32.exe
	set CHRC=%toolspath%\web-browser\ChromeCacheView.exe
	set IECV=%toolspath%\web-browser\IECacheView.exe
	set MZCV=%toolspath%\web-browser\MozillaCacheView.exe


	::BROWSING URLS HISTORY
	echo Enumerating Browsing URLs History .........................!
	echo Enumerating Browsing URLs History ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Browsing
	IF EXIST "%PROGRAMFILES(X86)%" (GOTO x64) ELSE (GOTO x32)
	:x64
	%BRHI64% /HistorySource 1 /VisitTimeFilterType 1 /LoadIE 1 /LoadFirefox 1 /LoadChrome 1 /LoadSafari 0 /scomma %resultspath%\Browsing\URLs-history.csv
	GOTO END
	:x32
	%BRHI32% /HistorySource 1 /VisitTimeFilterType 1 /LoadIE 1 /LoadFirefox 1 /LoadChrome 1 /LoadSafari 0 /scomma %resultspath%\Browsing\URLs-history.csv
	GOTO END
	:END
	echo %date% %time% : Finished enumerating browsing history ^
		>> %resultspath%\Winterfell_Status.log
	
	::CACHE FILES
	echo Enumerating Cache Files .........................!
	echo Enumerating Cache Files ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Browsing\Chrome-Cache
	mkdir %resultspath%\Browsing\IE-Cache
	mkdir %resultspath%\Browsing\Mozilla-Cache
	%CHRC% /scomma %resultspath%\Browsing\chrome-cache.csv
	%CHRC% /copycache " " " " /CopyFilesFolder %resultspath%\Browsing\Chrome-Cache\ /UseWebSiteDirStructure 0"
	%IECV% /scomma %resultspath%\Browsing\ie-cache.csv
	%IECV% /copycache " " " " /CopyFilesFolder %resultspath%\Browsing\IE-Cache\ /UseWebSiteDirStructure 0"
	%MZCV% /scomma %resultspath%\Browsing\mozilla-cache.csv
	%MZCV% /copycache " " " " /CopyFilesFolder %resultspath%\Browsing\Mozilla-Cache\ /UseWebSiteDirStructure 0"
	echo %date% %time% : Finished enumerating cache files ^
		>> %resultspath%\Winterfell_Status.log

	::END OF SCRIPT
	echo %date% %time% : Winterfell-Web Operation is Completed ^
		>> %resultspath%\Winterfell_Status.log
	echo 
	echo Please Enter Any Key to Exit ...





