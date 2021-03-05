#   Andy Friar
#   Moxie 365 Ltd
#   https://www.moxie365.com
#
#   OSDBuilder Script
#   Set-FileExplorer.ps1
#   Version 1
#
#   Adds Custom Code to manipulate default user
#
#   Based on the exceptional work of David Segura
#   http://osdbuilder.osdeploy.com
#
#======================================================================================
#   Load Registry Hives
#======================================================================================
$RegDefault = "$MountDirectory\Windows\System32\Config\Default"
if (Test-Path $RegDefault) {
    Write-Host "Loading $RegDefault" -ForegroundColor DarkGray
    Start-Process reg -ArgumentList "load HKLM\MountDefault $RegDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
}
$RegDefaultUser = "$MountDirectory\Users\Default\ntuser.dat"
if (Test-Path $RegDefaultUser) {
    Write-Host "Loading $RegDefaultUser" -ForegroundColor DarkGray
    Start-Process reg -ArgumentList "load HKLM\MountDefaultUser $RegDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
}
$RegSoftware = "$MountDirectory\Windows\System32\Config\Software"
if (Test-Path $RegSoftware) {
    Write-Host "Loading $RegSoftware" -ForegroundColor DarkGray
    Start-Process reg -ArgumentList "load HKLM\MountSoftware $RegSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
}
$RegSystem = "$MountDirectory\Windows\System32\Config\System"
if (Test-Path $RegSystem) {
    Write-Host "Loading $RegSystem" -ForegroundColor DarkGray
    Start-Process reg -ArgumentList "load HKLM\MountSystem $RegSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
}

#======================================================================================
#   Registry Commands
#======================================================================================
#
# Cortana
# Remove Video in This PC
# Remove Music in This PC
# Launch to This PC
# No Network in Explorer
# Show Drive Letters First
# Remove 3D Objects


$RegCommands =
'add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f',
'add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" /v ThisPCPolicy /t REG_SZ /d Hide /f',
'add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" /v ThisPCPolicy /t REG_SZ /d Hide /f',
'add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" /v ThisPCPolicy /t REG_SZ /d Hide /f',
'add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" /v ThisPCPolicy /t REG_SZ /d Hide /f',
'add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f',
'add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /v {F02C1A0D-BE21-4350-88B0-7367FC96EF3C} /t REG_DWORD /d 1 /f',
'add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v ShowDriveLettersFirst /t REG_DWORD /d 4 /f',
'delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f',
'delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f'


#======================================================================================
#   Process Registry Commands
#======================================================================================
foreach ($Command in $RegCommands) {
    if ($Command -like "*HKCU*") {
        $Command = $Command -replace "HKCU","HKLM\MountDefaultUser"
        Write-Host "reg $Command" -ForegroundColor DarkGray
        Start-Process reg -ArgumentList $Command -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
    } elseif ($Command -like "*HKLM\Software*") {
        $Command = $Command -replace "HKLM\\Software","HKLM\MountSoftware"
        Write-Host "reg $Command" -ForegroundColor DarkGray
        Start-Process reg -ArgumentList $Command -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
    } elseif ($Command -like "*HKLM\System*") {
        $Command = $Command -replace "HKLM\\System","HKLM\MountSystem"
        Write-Host "reg $Command" -ForegroundColor DarkGray
        Start-Process reg -ArgumentList $Command -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
    }
}

#======================================================================================
#   Unload Registry Hives
#======================================================================================
Start-Process reg -ArgumentList "unload HKLM\MountDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
Start-Process reg -ArgumentList "unload HKLM\MountDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
Start-Process reg -ArgumentList "unload HKLM\MountSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
Start-Process reg -ArgumentList "unload HKLM\MountSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue

#======================================================================================
#   Testing
#======================================================================================
#   [void](Read-Host 'Press Enter to continue')