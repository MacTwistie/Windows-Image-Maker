@echo off
c:
cd \Temp

REM TakeOwnership
echo Main Installs
Regedit.exe /S "DevSettings.reg"

REM Set System Defaults
PowerShell.exe -NoProfile -executionpolicy bypass -Command "& 'c:\temp\DeviceMac.ps1'"

REM Run the installers
echo.
echo Installing Microsft VC Libraries...
echo VC 2005...
start /wait vcredist2005_x86.exe /q
start /wait vcredist2005_x64.exe /q
echo VC 2008...
start /wait vcredist_x64.exe /qb
start /wait vcredist2008_x86.exe /qb
start /wait vcredist2008_x64.exe /qb
echo VC 2010...
start /wait vcredist2010_x86.exe /passive /norestart
start /wait vcredist2010_x64.exe /passive /norestart
echo VC 2012...
start /wait vcredist2012_x86.exe /passive /norestart
start /wait vcredist2012_x64.exe /passive /norestart
echo VC 2013...
start /wait vcredist2013_x86.exe /passive /norestart
start /wait vcredist2013_x64.exe /passive /norestart
echo VC 2015, 2017 And 2019...
start /wait vcredist2015_2017_2019_x86.exe /passive /norestart
start /wait vcredist2015_2017_2019_x64.exe /passive /norestart
echo.
echo.

REM Program Installs
Echo 7-ZIP
Msiexec /i "c:\temp\7z1900-x64.msi" /qb

Echo Fonts
Msiexec /i "c:\temp\ACW_Fontpak_V3.msi" /qb

Echo Notepad++
START /WAIT npp.8.1.5.Installer.x64.exe /S

Echo Java Libraries x86 and x64
START /WAIT jre-8u311-windows-i586.exe /S INSTALLCFG=c:\temp\SilentInstall.cfg /s /L C:\temp\logs\java8301.log
START /WAIT jre-8u311-windows-x64.exe /S INSTALLCFG=c:\temp\SilentInstall.cfg /s /L C:\temp\logs\java8301x64.log

Echo TeamViewer
START /WAIT TeamViewer_Setup.exe /S /norestart

Echo Paint Dot Net
START /WAIT paint.net.4.3.2.install.x64.exe /auto

Echo MediaInfo Right-Click Addon
START /WAIT MediaInfo_GUI_21.09_Windows.exe /S

Echo K-Lite Codec Pack
START /WAIT K-Lite_Codec_Pack_1646_Standard.exe /verysilent

Echo Foobar Music Player
START /WAIT foobar2000_v1.6.7.exe /S

Echo Flash Renamer
START /WAIT FlashRenamer_Setup.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-

Echo Adobe Reader
cd \temp\adobe
setup.exe /sALL

Echo Finished !
ping localhost >> nul

:end
