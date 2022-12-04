@echo off
title Info PC
:: Acest script ofera informatii despre calculatoru de pe care ruleaza
color b

pushd "%~dp0" 
::Creare Folder
MKDIR %computername%
cls
(
echo.
echo =========================  Operating System  =========================  
echo.
wmic os get caption, buildnumber, installdate, muilanguages, osarchitecture | find /v ""
echo =========================  BIOS Information  =========================  
echo.
wmic bios get manufacturer, name, status, releasedate, version | find /v ""
echo =========================  Motherboard Information  =========================  
echo.
wmic baseboard get Manufacturer, product | find /v ""
echo =========================  Laptop Information  =========================  
echo.
wmic csproduct get identifyingnumber, name, vendor, version | find /v ""
echo =========================  Windows licence  =========================  
echo.
wmic path SoftwareLicensingService get OA3xOriginalProductKey | find /v ""
echo =========================  RAM Information  =========================  
echo.
wmic memorychip get DeviceLocator, PartNumber, capacity, speed | find /v ""
echo =========================  HDD Information  =========================  
echo.
wmic diskdrive get model, FirmwareRevision, deviceid, partitions, size, serialnumber, status | find /v ""
echo =========================  Partition Information  =========================  
echo.
wmic logicaldisk get caption, description, filesystem, providername, volumename  | find /v ""
echo =========================  CPU Information  =========================  
echo.
wmic cpu get name, numberofcores, numberoflogicalprocessors, socketdesignation, status | find /v ""
echo =========================  Video Information  =========================  
echo.
wmic path Win32_VideoController get name, driverdate, driverversion, videomodedescription, maxrefreshrate | find /v ""
echo =========================  Audio Information  =========================  
echo.
wmic sounddev get manufacturer, name, status | find /v ""
echo =========================  Network Information  =========================  
echo.
wmic nicconfig where "MACAddress is not null" get description, dhcpenabled, dhcpserver, dnsserversearchorder, ipaddress, ipsubnet, macaddress | find /v ""
echo =========================  WiFi Information  =========================  

powershell.exe "netsh WLAN show profile name=* | select-string -pattern '(SSID Name)|(key content)'"
echo.
echo =========================  Windows Updates  ========================= 

wmic qfe get Caption,Description,HotFixID,InstalledOn | find /v ""
echo.
echo =========================  Antivirus Information  =========================  

WMIC /Node:localhost /Namespace:\\root\SecurityCenter2 Path AntiVirusProduct Get displayName /Format:List | find /v ""

echo =========================  Domain Information  =========================  
echo.
wmic computersystem get BootupState, DNSHostName, domain, SystemFamily, SystemSKUNumber | find /v ""
echo =========================  User Information  =========================  
echo.
wmic netlogin get badpasswordcount, fullname, name, usertype | find /v ""

echo =========================  Local Account Information  =========================  

powershell.exe "Get-LocalUser | ft Name,Enabled,LastLogon"

echo =========================  Admin Information  =========================  

powershell.exe "Get-LocalGroupMember Administrators | ft Name, PrincipalSource"

echo =========================  Credential Information  =========================  

powershell.exe "start-process "cmdkey" -ArgumentList "/list" -NoNewWindow -Wait"

echo =========================  Program Information  =========================  

reg query HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall /s | findstr InstallLocation | findstr ":\\"
reg query HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ /s | findstr InstallLocation | findstr ":\\"

echo =========================  Startup Information  =========================  
echo.
wmic startup get name, user | find /v ""

echo =========================  Task Information  =========================  

powershell.exe "Get-ScheduledTask | where {$_.TaskPath -notlike '\Microsoft*'} | ft TaskName,TaskPath,State"

echo =========================  Printer Information  =========================  
echo.
wmic printer get caption, capabilitydescriptions, default, drivername, network, portname, sharename, status | find /v ""


)>%computername%\info.txt

pushd "%~dp0"

(
echo echo off

echo color 0a

echo title Import Excel

echo powershell.exe "powershell -Command {(gc info.txt) -replace  'unreachable', '  Unreachable' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "powershell -Command {(gc infoexcel.txt) -replace  'Program Files', 'Program Files   ' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "powershell -Command {(gc infoexcel.txt) -replace  ' 0.0', '  0.0' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "powershell -Command {(gc infoexcel.txt) -replace  ' 00-', '  00-' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "powershell -Command {(gc infoexcel.txt) -replace  ' FF-', '  FF-' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "powershell -Command {(gc infoexcel.txt) -replace  'True ', 'True  ' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "powershell -Command {(gc infoexcel.txt) -replace  ' USB  ', '  USB  ' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "powershell -Command {(gc infoexcel.txt) -replace  ' HIDClass  ', '  HIDClass  ' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "powershell -Command {(gc infoexcel.txt) -replace  'Biometric', '  Biometric' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "powershell -Command {(gc infoexcel.txt) -replace  ' Camera  ', '  Camera  ' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "powershell -Command {(gc infoexcel.txt) -replace  'LastLogon', '  LastLogon' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "powershell -Command {(gc infoexcel.txt) -replace  'False ', 'False  ' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "powershell -Command {(gc infoexcel.txt) -replace  '  ', ';' | Out-File -encoding ASCII infoexcel.txt}"

echo powershell.exe "$oXL = New-Object -comobject Excel.Application; $oXL.Visible = $true; $oXL.DisplayAlerts = $False; $file = (Get-Item .).FullName + '\infoexcel.txt'; $oXL.workbooks.OpenText($file,437,1,1,1,$True,$False,$True,$False,$False,$False)"

echo exit
) > .\%computername%\exportexcel.bat


(
echo echo off

echo color 0a

echo title Import Excel

echo powershell.exe -executionpolicy unrestricted -command .\exportexcel.ps1

echo exit

) > .\%computername%\exportsimple.bat

::Exporta profilele de wifi
netsh wlan export profile key=clear folder="%computername%"

cls

:: Export ARP Table
powershell.exe "Get-NetNeighbor -AddressFamily IPv4 | ft IPAddress,LinkLayerAddress,State" > %computername%\ARP.txt


::Export Routing Table
powershell.exe "Get-NetRoute -AddressFamily IPv4 | ft DestinationPrefix,NextHop,RouteMetric" > %computername%\Routing.txt
route print >> %computername%\Routing.txt

::Creaza lista de fisiere pt user
tree /f /a c:\users\%username% > %computername%\files.txt
tree /f /a c:\users\%username%.desktop >> %computername%\files.txt
powershell.exe "Get-ChildItem  'C:\Program Files', 'C:\Program Files (x86)' | where {$_.name -notlike 'windows*'} | ft Parent,Name,LastWriteTime" >> %computername%\files.txt
powershell.exe "Get-ChildItem 'C:\Users' -Force  | ft Parent,Name,LastWriteTime"  >> %computername%\files.txt
powershell.exe "$Drives = Get-PSDrive -PSProvider 'FileSystem' ; foreach($Drive in $drives) {  Get-ChildItem -Path $Drive.Root -ErrorAction SilentlyContinue -Force | ft Parent,Name,LastWriteTime}" >> %computername%\files.txt


::Creare lista de taskuri pornite
tasklist /SVC > %computername%\tasks.txt

::Info USB
powershell.exe "get-itemproperty -path HKLM:\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\* |select friendlyname" > %computername%\USB.txt
powershell.exe "gwmi Win32_USBControllerDevice | foreach-object {[wmi]($_.Dependent)} |select description, pnpclass" >> %computername%\USB.txt

::Creare Lista de drivere
pnputil /enum-drivers > %computername%\drivers.txt
pnputil /enum-devices >> %computername%\drivers.txt

::Lista porturi deschise
netstat -ano | findstr /i listen > %computername%\Ports.txt

::Configurare firewall
netsh firewall show config > %computername%\Firewall.txt

::Host File
type C:\WINDOWS\System32\drivers\etc\hosts | findstr /v "^#" > %computername%\hosts.txt

::DNS Cache
ipconfig /displaydns | findstr "Record" | findstr "Name Host" > %computername%\DNS.txt

:: Volume information
powershell.exe "get-volume" > %computername%\volume.txt

:: Language information
powershell.exe "Get-WinUserLanguageList" > %computername%\language.txt

:: Battery information
powercfg -batteryreport -output %computername%\battery.html

:: Work Accounts
dsregcmd /status > %computername%\workAcc.txt

:: Fisiere pt export excel
powershell.exe -executionpolicy unrestricted -command .\infox.ps1

copy exportexcel.ps1 .\%computername%\exportexcel.ps1

timeout /t 1

:: Creare Arhiva
powershell Compress-Archive .\%computername%  c:\users\public\downloads\%computername%.zip

timeout /t 1

:: Upload NextCloud
#powershell.exe -executionpolicy unrestricted -command .\nextcloud.ps1

exit
