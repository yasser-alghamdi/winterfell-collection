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
	
	REM  ==========================================(WINTERFELL SCRIPTS)====================================================================================
	title Winterfell (Windows Forensics Data Collection and Threat Hunting)
    
	pushd %~dp0
	unzip.exe tools.zip
	start Winterfell-System.bat
	start Winterfell-Forensics.bat
	start Winterfell-Network.bat
	start Winterfell-Registry.bat
	start Winterfell-Presistance.bat
	start Winterfell-Malware.bat
	start Winterfell-Web.bat
	start Winterfell-Logs.bat
	start Winterfell-Location.bat
	popd
	
	
