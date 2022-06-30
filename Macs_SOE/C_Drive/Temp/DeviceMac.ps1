# ***************************************************************************************************************************
set-executionpolicy Bypass
$progressPreference = 'silentlyContinue'
$ErrorActionPreference = 'silentlyContinue'

#Set HKLM or HKCR Registry Keys
Write-Output "> Setting defaults via Registry Keys..."
$Keys = @(
('HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore','AutoDownload','2','Dword'),
('HKLM:\Software\Policies\Microsoft\Windows\Explorer','DisableSearchBoxSuggestions','1','Dword'),
('HKLM:\Software\Policies\Microsoft\Windows\EdgeUI','DisableMFUTracking ','1','Dword'),
('HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications','ToastEnabled ','0','Dword'),
('HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection','AllowTelemetry ','0','Dword'),
('HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent','DisableWindowsConsumerFeatures ','1','Dword'),
('HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent','DisableSoftLanding','1','Dword'),
('HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search','AllowCortana','0','Dword'),
('HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search','DisableWebSearch ','1','Dword'),
('HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search','ConnectedSearchUseWeb','0','Dword'),
('HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet','SpynetReporting','0','Dword'),
('HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet','SubmitSamplesConsent ','2','Dword'),
('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection','AllowTelemetry','0','Dword'),
('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System','EnableFirstLogonAnimation ','0','Dword'),
('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced','LaunchTo','1','Dword'),
('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer','SmartScreenEnabled','Off')
)


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

	
#Remove useless Applications
Write-Output "> Removing pre-installed windows 10 apps..."
    $apps = @(
        "*Microsoft.GetHelp*"
        "*Microsoft.Getstarted*"
        "*Microsoft.WindowsFeedbackHub*"
        "*Microsoft.BingNews*"
        "*Microsoft.BingFinance*"
        "*Microsoft.BingSports*"
        "*Microsoft.BingWeather*"
        "*Microsoft.BingTranslator*"
        "*Microsoft.MicrosoftOfficeHub*"
        "*Microsoft.Office.OneNote*"
        "*Microsoft.MicrosoftStickyNotes*"
        "*Microsoft.SkypeApp*"
        "*Microsoft.OneConnect*"
        "*Microsoft.Messaging*"
        "*Microsoft.ZuneMusic*"
        "*Microsoft.ZuneVideo*"
        "*Microsoft.MixedReality.Portal*"
        "*Microsoft.3DBuilder*"
        "*Microsoft.Microsoft3DViewer*"
        "*Microsoft.Print3D*"
        "*Microsoft.549981C3F5F10*"   #Cortana app
        "*Microsoft.Asphalt8Airborne*"
        "*king.com.BubbleWitch3Saga*"
        "*king.com.CandyCrushSodaSaga*"
        "*king.com.CandyCrushSaga*"
        "*Microsoft.YourPhone*"        
		)

foreach ($app in $apps)
	{
    Write-Output "Attempting to remove $app"
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage
	}