diskpart /s a:\extend-disk.txt
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh firewall set portopening protocol = TCP port = 3389 name = "Remote Desktop Protocol" mode = ENABLE
net start w32time
certutil -addstore -f "TrustedPublisher" a:oracle-cert.cer
e:\VBoxWindowsAdditions-amd64.exe /S
rem powershell.exe -noprofile -command "mkdir -f c:\inst;$webClient = new-object System.Net.WebClient; $webClient.DownloadFile('https://opscode-omnibus-packages.s3.amazonaws.com/windows/2008r2/x86_64/chef-client-11.6.0.hotfix.1-1.windows.msi', 'c:\inst\chef-client-latest.msi');msiexec /qb /i c:\inst\chef-client-latest.msi"
powershell.exe -noprofile -command "mkdir -f c:\inst;$webClient = new-object System.Net.WebClient; $webClient.DownloadFile('https://opscode-omnibus-packages.s3.amazonaws.com/windows/2008r2/x86_64/chef-client-11.6.0.hotfix.1-1.windows.msi', 'c:\inst\chef-client-latest.msi');msiexec /qb /i c:\inst\chef-client-latest.msi"
rem powershell.exe -noprofile -command "mkdir -f c:\inst;$webClient = new-object System.Net.WebClient; $webClient.DownloadFile('https://www.opscode.com/chef/install.msi', 'c:\inst\chef-client-latest.msi');msiexec /qb /i c:\inst\chef-client-latest.msi"
mkdir c:\inst
echo Base VM Creation Log > c:\inst\vmcreate.log
echo This VM was created at >> c:\inst\vmcreate.log
date /t >> c:\inst\vmcreate.log
time /t >> c:\inst\vmcreate.log 
type c:\inst\vmcreate.log
ECHO y| SECEDIT.EXE /CONFIGURE /CFG a:\secpol.inf /DB c:\inst\dummy.sdb /LOG c:\inst\security-policy.log
type c:\inst\security-policy.log
wmic USERACCOUNT WHERE "Name='vagrant'" set PasswordExpires=FALSE > c:\inst\userpass.log
wmic USERACCOUNT WHERE "Name='administrator'" set PasswordExpires=FALSE >> c:\inst\userpass.log
type c:\inst\userpass.log
cd c:\windows\system32\sysprep
# rem start cmd /c "sleep 10 & sysprep /generalize /oobe /shutdown /unattend:a:\sysprep.xml"
copy a:\begin-update-and-sysprep.cmd "%USERPROFILE%\Start Menu\Programs\Startup"
schtasks /create /f /sc once /st 00:00:00 /tn "updatesysprep" /RU "SYSTEM" /rl HIGHEST /tr "cmd /c waitfor nosignal /t 10 & cscript.exe a:\install-updates-and-sysprep.vbs >> c:\inst\update-sysprep.log"
rem schtasks /create /f /sc once /st 00:00:00 /tn "sysprep" /RU "SYSTEM" /rl HIGHEST /tr "cmd /c waitfor sysprep /t 10 & c:\windows\system32\sysprep\sysprep.exe /generalize /oobe /shutdown /unattend:a:\sysprep.xml"
schtasks /run /tn "updatesysprep"