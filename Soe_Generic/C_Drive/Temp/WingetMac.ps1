# ***************************************************************************************************************************
# Default Settings
$progressPreference = 'silentlyContinue'

New-Item -Path "HKLM:\Software\Policies" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Microsoft" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\" -Force | Out-Null
New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null


$Keys = @(
('HKCU:\Software\Policies\Microsoft\Windows\Explorer','DisableSearchBoxSuggestions','1','Dword'),
('HKCU:\Software\Policies\Microsoft\Windows\EdgeUI','DisableMFUTracking ','1','Dword'),
('HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications','ToastEnabled ','0','Dword'),
('HKCU:\Software\Microsoft\Windows\Windows Error Reporting','Disabled ','1','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\AppHost\EnableWebContentEvaluation','Smart Screen ','0','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager','SilentInstalledAppsEnabled ','0','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced','ShowCortanaButton','0','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced','ShowTaskViewButton','0','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People','PeopleBand','0','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced','HideFileExt','0','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced','LaunchTo','1','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced','ShowSecondsInSystemClock ','1','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel','{20D04FE0-3AEA-1069-A2D8-08002B30309D}','0','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds','ShellFeedsTaskbarViewMode','2','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Search','SearchboxTaskbarMode','1','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Search','DeviceHistoryEnabled ','0','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Search','HistoryViewEnabled ','0','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Search','BingSearchEnabled ','0','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\Search','CortanaConsent ','0','Dword'),
('HKCU:\Software\Microsoft\Windows\CurrentVersion\PenWorkspace','PenWorkspaceButtonDesiredVisibility','0','Dword')
)

Write-Output "> Setting defaults via Registry Keys..."
foreach($key in $Keys)
    {
    #Create Top level path if it does not already exist.
    if (!(Test-Path $key[0])) 
		{
		New-Item -Path $key[0] -ItemType RegistryKey -Force -ERRORACTION SILENTLYCONTINUE
		}
    #If subkey exists then update, otherwise create new with type specified.
    $TestKey1 = (Get-ItemProperty $key[0]).PSObject.Properties.Name -contains $key[1]
		if ($TestKey1 -eq 'True')
			{
            Set-ItemProperty -Path $Key[0] -Name $key[1] -Value $key[2] -Force -ERRORACTION SILENTLYCONTINUE
            }
        Else
            {
            New-ItemProperty -Path $key[0] -Name $key[1] -Value $key[2] -PropertyType $Key[3] -Force -ERRORACTION SILENTLYCONTINUE
            }
    }


#Install Windows Update and Drivers

# If the PowerShell Modules Folder is non-existing, it will be created.
if ($false -eq (Test-Path $env:SystemRoot\System32\WindowsPowerShell\v1.0\Modules)) 
	{
    New-Item -ItemType Directory -Path $env:SystemRoot\System32\WindowsPowerShell\v1.0\Modules1 -Force
	}

# Import the PowerShell Module
$ScriptPath = Get-Location
Import-Module $ScriptPath\PSWindowsUpdate -Force

# Specify the path usage of Windows Update registry keys
$Path = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows'

# If the necessary keys are non-existing, they will be created
if ($false -eq (Test-Path $Path\WindowsUpdate)) 
	{
    New-Item -Path $Path -Name WindowsUpdate
    New-ItemProperty $Path\WindowsUpdate -Name DisableDualScan -PropertyType DWord -Value '0'
    New-ItemProperty $Path\WindowsUpdate -Name WUServer -PropertyType DWord -Value $null
    New-ItemProperty $Path\WindowsUpdate -Name WUStatusServer -PropertyType DWord -Value $null
	}
else 
	{
    # If the value of the keys are incorrect, they will be modified
    try {
        Set-ItemProperty $Path\WindowsUpdate -Name DisableDualScan -value "0" -ErrorAction SilentlyContinue
        Set-ItemProperty $Path\WindowsUpdate -Name WUServer -Value $null -ErrorAction SilentlyContinue
        Set-ItemProperty $Path\WindowsUpdate -Name WUStatusServer -Value $null -ErrorAction SilentlyContinue
		}
    catch 
		{
        Write-Output 'Skipped modifying registry keys'
		}
}

# Add ServiceID for Windows Update
Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -Confirm:$false

# Pause and give the service time to update
Start-Sleep 30

# Scan against Microsoft, accepting all drivers
Get-WUInstall -MicrosoftUpdate -AcceptAll

# Scaning against Microsoft for all Driver types, and accepting all
Get-WUInstall -MicrosoftUpdate Driver -AcceptAll

# Scanning against Microsoft for all Software Updates, and installing all, ignoring a reboot
Get-WUInstall -MicrosoftUpdate Software -AcceptAll -IgnoreReboot



#Install WINGET and update Apps - Requires Internet to get updates
Write-Output "> Install WINGET and Auto-Updating all current programs..."
Add-AppxPackage -Path c:\temp\Microsoft.VCLibs.140.00.UWPDesktop_14.0.30035.0_x64__8wekyb3d8bbwe.Appx
Add-AppxPackage -Path c:\temp\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Add-AppxPackage -Path c:\temp\Microsoft.VCLibs.140.00_14.0.30035.0_x64__8wekyb3d8bbwe.Appx
Add-AppxPackage -Path c:\temp\Microsoft.HEVCVideoExtension_1.0.42091.0_x64__8wekyb3d8bbwe.Appx

winget upgrade --all --accept-source-agreements --accept-package-agreements
Winget install microsoft.powershell
Winget install discord.discord
Winget install valve.steam
Winget install calibre.calibre
Winget install Lexikos.AutoHotkey
Winget install DelugeTeam.Deluge
Winget install Malwarebytes.Malwarebytes
