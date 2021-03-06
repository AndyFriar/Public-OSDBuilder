#   Andy Friar
#   Moxie 365 Ltd
#   https://www.moxie365.com
#
#   OSDBuilder Script
#   Global Win10-DefaultUser.ps1
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

$RegCommands =
'add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f',
'add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t REG_DWORD /d 0 /f',
'add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "PeopleBand" /t REG_DWORD /d 0 /f',
'add "HKCU\Software\Microsoft\Windows Defender" /v "UIFirstRun" /t REG_DWORD /d 0 /f'

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