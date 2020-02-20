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
	set resultspath=%cd%\%COMPUTERNAME%\Network
	title (Winterfell Network)

	
	::NETWORK INFORMATION
	echo Enumerating network information .........................!
	echo %DATE% %TIME% : Enumerating network information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Network
	echo ===========================(shows active connection summary)======================= ^
		>> %resultspath%\Network\netinfo.txt
	ipconfig /all >> %resultspath%\Network\netinfo.txt 2>&1
	ipconfig /displaydns >> %resultspath%\Network\netinfo.txt 2>&1
	echo ===========================(shows active connection summary)======================= ^
		>> %resultspath%\Network\netinfo.txt
	netstat -ano >> %resultspath%\Network\netinfo.txt 2>&1
	netstat -anobv >> %resultspath%\Network\netinfo.txt 2>&1
	echo ===========================(shows routing tables)======================= ^
		>> %resultspath%\Network\netinfo.txt
	route print >> %resultspath%\Network\netinfo.txt 2>&1
	echo ===========================(shows arp cache)======================= ^
		>> %resultspath%\Network\netinfo.txt
	arp -a >> %resultspath%\Network\netinfo.txt 2>&1                                                                                                                                                                          
	echo %DATE% %TIME% : Finished Enumerating network Information ^
		>> %resultspath%\Winterfell_Status.log

	::SHARING INFORMATION
	echo Enumerating sharing information .........................!
	echo %DATE% %TIME% : Enumerating sharing information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\Sharing
	echo ===========================(shows list of shared resources)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	net view /all > %resultspath%\Sharing\shareinfo.txt 2>&1
	echo ===========================(shows list of user accounts)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	net user >> %resultspath%\Sharing\shareinfo.txt 2>&1
	echo ===========================(shows administrator account details)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	net user administrator /domain >> %resultspath%\Sharing\shareinfo.txt  2>&1
	echo ===========================(shows shared resources details)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	net share >> %resultspath%\Sharing\shareinfo.txt 2>&1
	echo ===========================(shows groupnames on server)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	net group /domain >> %resultspath%\Sharing\shareinfo.txt 2>&1
	echo ===========================(shows current sessions details)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	net session /list >> %resultspath%\Sharing\shareinfo.txt 2>&1
	echo ===========================(shows shared files details)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	openfiles >> %resultspath%\Sharing\shareinfo.txt >nul 2>&1
	echo ===========================(shows server statistics details)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	net statistics server >> %resultspath%\Sharing\shareinfo.txt >nul 2>&1
	echo ===========================(shows workstation statistics details)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	net statistics workstation >> %resultspath%\Sharing\shareinfo.txt 2>&1
	echo ===========================(shows account settings)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	net accounts >> %resultspath%\Sharing\shareinfo.txt 2>&1
	echo ===========================(shows local groups details)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	net localgroup >> %resultspath%\Sharing\shareinfo.txt 2>&1
	echo ===========================(shows administrators groups details)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	net localgroup administrators >> %resultspath%\Sharing\shareinfo.txt 2>&1
	echo ===========================(shows Remote Desktop Users groups details)======================= ^
		>> %resultspath%\Sharing\shareinfo.txt
	net localgroup "Remote Desktop Users" ^
		>> %resultspath%\Sharing\shareinfo.txt 2>&1                                                                                                                                                                                                                                      
	echo %DATE% %TIME% : Finished enumerating sharing information >> %resultspath%\Winterfell_Status.log
	

	::FIREWALL CONFIGURATION
	echo Enumerating network configuration information .........................!
	echo %DATE% %TIME% : Enumerating network configuration information ^
		>> %resultspath%\Winterfell_Status.log
	mkdir %resultspath%\FWconfig
	echo ===========================(shows firewall settings)======================= ^
		>> %resultspath%\FWconfig\fwconfig.txt
	netsh advfirewall firewall show rule name=all verbose ^
		> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh advfirewall show global ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh advfirewall show allprofiles ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh firewall show allowedprogram ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh advfirewall show currentprofile ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh firewall show service ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh firewall show portopening ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh firewall show opmode ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh firewall show notifications ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh firewall show multicastbroadcastresponse ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh firewall show logging ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh firewall show icmpsetting ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh firewall show state ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh firewall show config ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh firewall show config verbose=enable ^
		>> %resultspath%\FWconfig\fwconfig.txt
	echo ===========================(shows interface settings)======================= ^
		>> %resultspath%\FWconfig\fwconfig.txt
	netsh interface portproxy show all ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh interface show interface ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh interface dump ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	echo ===========================(shows bridge settings)======================= ^
		>> %resultspath%\FWconfig\fwconfig.txt
	netsh bridge show adapter ^
		>> %resultspath%\FWconfig\fwconfig.txt  2>&1
	netsh bridge dump ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	echo ===========================(shows winsock settings)======================= ^
		>> %resultspath%\FWconfig\fwconfig.txt
	netsh winsock show catalog ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	netsh winsock show autotuning ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	echo ===========================(shows mbn settings)======================= ^
		>> %resultspath%\FWconfig\fwconfig.txt
	netsh mbn show interface ^
		>> %resultspath%\FWconfig\fwconfig.txt 2>&1
	echo %date% %time% : Finished enumerating network configuration information ^
		>> %resultspath%\Winterfell_Status.log

	::END OF SCRIPT
	echo %date% %time% : Winterfell-Network Operation is Completed ^
		>> %resultspath%\Winterfell_Status.log
	echo Please Enter Any Key to Exit ...










