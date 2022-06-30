# Windows Image Maker v1.0
# Michael Cannard
# 10/12/2021
# Open Source License.


###############
## FUNCTIONS ##
###############

function Save-Defaults
    {
    $ISO    | OUT-File -FilePath $Defiso
    $WinRev | OUT-File -FilePath $Defiso -Append
    $IsoVer | OUT-File -FilePath $Defiso -Append
    }

#################
## ENVIRONMENT ##
#################
$ErrorActionPreference = 'Stop'

$rootPath = $MyInvocation.MyCommand.Path
if (!$rootPath) {$rootPath = $psISE.CurrentFile.Fullpath}
$Root   = Split-Path $rootPath -Parent
$pRoot  = Split-Path $rootPath -Parent
$fName  = Split-Path $rootPath -Leaf
$fName  = $fName.Substring(0, $fName.LastIndexOf('.'))
$Root   = $Root + "\" + $fName
$docISO = $pRoot + "\Documentation.txt"

#Start Transcript
$Trans    = $Root + "\" + $fname + ".log"
try {stop-transcript} catch [System.InvalidOperationException]{}
Start-Transcript -Path $Trans -verbose -force -IncludeInvocationHeader

#Calculate Foldernames and Filenames and create if not existing.
$ISOext   = $Root + "\Win_Files"
$WimFiles = $Root + "\Wim"
$WimFin   = $Root + "\wim\*"
$WimSrce  = $Root + "\Win_Files\sources"
$WimTst   = $Root + "\Win_Files\sources\install.wim"
$WimBoot  = $Root + "\Win_Files\sources\boot.wim"
$WimCP    = $Root + "\Wim\install.wim"
$WimESD   = $Root + "\Wim\install.esd"
$WimCPe   = $Root + "\Wim\install.swm"
$Pics     = $Root + "\MOUNT1\Windows\Web"
$DefIso   = $Root + "\@Defaults.txt"

#Build Folders.
$NewSoeF  = $Root  + "\_NewSOE\"
$CDrive   = $Root  + "\C_Drive"
$Scripts  = $Root  + "\C_Drive\Temp"
$Llogs    = $Root  + "\C_Drive\Temp\Logs"
$Picsloc  = $Root  + "\C_Drive\Windows\Web"
$CRoot    = $Root  + "\C_Root"
$PcDrv    = $Root  + "\C_Root\Drivers"
$Mount1   = $Root  + "\MOUNT1"
$Mount2   = $Root  + "\MOUNT2"
$PeDrv    = $Root  + "\PeDRIVERS"
$WSUS     = $Root  + "\WindowsUpdates"

if (!(Test-Path -Path $NewSoeF)) { New-Item -Path $NewSoeF -ItemType Directory } 
if (!(Test-Path -Path $CDrive))  { New-Item -Path $CDrive  -ItemType Directory } 
if (!(Test-Path -Path $Picsloc)) { New-Item -Path $Picsloc -ItemType Directory } 
if (!(Test-Path -Path $Scripts)) { New-Item -Path $Scripts -ItemType Directory } 
if (!(Test-Path -Path $Llogs))   { New-Item -Path $Llogs   -ItemType Directory } 
if (!(Test-Path -Path $CRoot))   { New-Item -Path $CRoot   -ItemType Directory } 
if (!(Test-Path -Path $PcDrv))   { New-Item -Path $PcDrv   -ItemType Directory } 
if (!(Test-Path -Path $Mount1))  { New-Item -Path $Mount1  -ItemType Directory } 
if (!(Test-Path -Path $Mount2))  { New-Item -Path $Mount2  -ItemType Directory } 
if (!(Test-Path -Path $PeDrv))   { New-Item -Path $PeDrv   -ItemType Directory } 
if (!(Test-Path -Path $WSUS))    { New-Item -Path $WSUS    -ItemType Directory } 



######################
## Get/Set Defaults ##
######################
If (Test-Path -Path $DefIso)
    {
    $ttt             = Get-Content $DefIso
    $ISO             = $ttt[0]
    $Winrev          = $ttt[1]
    [Decimal]$IsoVer = $ttt[2]
    if (!($ISOver)) { [Decimal]$ISOVer = 1.0 } Else { $isover = $isover + .01 }
    }
Else
    {
    $ISO    = 'none'
    $Winrev = 'none'
    [Decimal]$ISOVer = 1.0
    Save-Defaults
    }

#################
## CONFIG MENU ##
#################
$Menu = 'setup'
While ($Menu -ne 'Ready')
    {
    Clear-Host
    Write-Host
    Write-Host "Current Configuration :-"
    Write-Host
    Write-Host "** Windows ISO Image and Version **"
    Write-Host Windows ISO :- $ISO.split("\")[-1]
    Write-Host Windows REV :- $WinRev

    #Device Drivers
    Write-Host
    #Write-Host "** PC Device Driver Folders **"
    $AllPCDrivers = (Get-ChildItem -path $PcDrv -directory).Name
    If ($AllPCDrivers)
        {
        $AllPCDrivers
        }
    Else { 
         Write-Host "No Windows Drivers found - [3] to open the folder."
         }

    Write-Host
    #Write-Host "** WINPE Device Drivers **"
    $AllPeDrivers = (Get-ChildItem -path $PeDrv -directory).Name
    If ($AllPeDrivers)
        {
        $AllPeDrivers
        }
    Else { 
         Write-Host "No PE ENV Drivers Found  - [4] to open the folder"
         }

    #Get Windows Updates - Remind
    Write-Host
    #Write-Host "** Windows Updates **"
    $Updates = (Get-ChildItem -path $wsus).name
    If ($Updates)
        {
        $updateReady = 'yes'
        forEach ($update in $updates)
            {
            $Update.Split("-")[1]
            }
        }
    Else {
         Write-Host "No Windows updates found - [5] to open the folder."
         $updateReady = 'no'
         }


    #Root of C_Drive of completed build
    Write-Host
    Write-Host "** Updated Folders copied to/over C:\ Of Destination Device **"
    $CdriveRoot = (Get-ChildItem -path $cDrive -directory).Name
    $CdriveRoot
    Write-host
    Write-Host "###########################################"
    Write-host "[0] - Continue"                             
    Write-host "[1] - Windows ISO             - $iso"                   
    Write-host "[2] - Reset Windows Edition   - $WinRev" 
    Write-host "[3] - Hardware Drivers"         
    Write-host "[4] - WINPE Drivers"
    Write-host "[5] - Windows Updates"             
    Write-host "[6] - C:\ROOT (Unattend and PPKG Location)"
    Write-host "[7] - Lockscreen & Background Images"       
    Write-host "[8] - Scripted APP Installs" 
    Write-host "[9] - Documentation"                        
    Write-Host
    [string]$Choose = Read-Host -Prompt ":"
    
    if ($Choose -eq "0") { $Menu = 'Ready'}
    if ($Choose -eq "1")
        {
        $ISO    = 'none'
        Add-Type -AssemblyName System.Windows.Forms
        $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        InitialDirectory = [Environment]::GetFolderPath('Desktop') 
        Filter = 'Windows Image (*.iso)|*.iso'
            }
        $null    = $FileBrowser.ShowDialog()
        $ISO     = $filebrowser.FileName
        Save-Defaults
        }
        
    if ($Choose -eq "2")
        {
        $Winrev = 'None'
        Save-Defaults
        }
    if ($Choose -eq "3") { start-process explorer.exe $PcDrv   }
    if ($Choose -eq "4") { start-process explorer.exe $PeDrv   }
    if ($Choose -eq "5") { start-process explorer.exe $Wsus    }
    if ($Choose -eq "6") { start-process explorer.exe $Croot   }
    if ($Choose -eq "7") { start-process explorer.exe $Picsloc }
    if ($Choose -eq "8") { start-process explorer.exe $Scripts }
    if ($Choose -eq "9") { start-process notepad.exe  $docISO  }

    if ((!($iso)) -or ($iso -eq 'none'))
        {
        clear-host
        Write-Host
        Write-Host No Windows ISO Chosen.  Please download from https://www.microsoft.com/en-au/software-download/windows10 or another source then Choose it.
        $Menu = 'setup'
        $Iso =  'None'
        Save-defaults
        Pause
        }
    }


#################
## START BUILD ##
#################

#Clean up from previous builds
dism /cleanup-wim
dism /Unmount-Image /MountDir:$Mount1 /discard | Out-Null
dism /Unmount-Image /MountDir:$Mount2 /discard | Out-Null

Remove-Item -force -Recurse $ISOext   -ErrorAction SilentlyContinue -WarningAction Continue
Remove-Item -force -Recurse $Mount1   -ErrorAction SilentlyContinue -WarningAction Continue
Remove-Item -force -Recurse $Mount2   -ErrorAction SilentlyContinue -WarningAction Continue
Remove-Item -force -Recurse $WimFiles -ErrorAction SilentlyContinue -WarningAction Continue

DisMount-DiskImage -ImagePath $ISO

if ((Test-Path -Path $isoext) -or (Test-Path -Path $Mount1) -or (Test-Path -Path $Mount2) -or (Test-Path -Path $WimFiles))   
    {
    Write-Host
    Write-Host
    Write-Host "Folder still exists - Locked files" -ForegroundColor Red
    Write-Host Check $isoext, $Mount1, $Mount2, $WimFiles Are deleted then try again.
    Pause
    Exit
    }

New-Item -Path $ISOext -ItemType Directory
New-Item -Path $Mount1   -ItemType Directory
New-Item -Path $Mount2   -ItemType Directory
New-Item -Path $WimFiles -ItemType Directory

#Mount windows ISO and copy WIM File to $wim
Write-Host "Mounting $ISO and extracting the files to $IsoExt"
$mountResult = Mount-DiskImage -ImagePath $ISO -PassThru
$ISODrive = (($mountResult | Get-Volume).DriveLetter) + ":\"
Robocopy $ISODrive $ISOExt /mir /NP
DisMount-DiskImage -ImagePath $ISO

#Copy AutoUnattend and PPKG to ISO Root (not the install.wim file)
robocopy $CRoot $ISOExt /e /NP

#Check if Windows Source is .wim - or ESD and set the Source File as such.
if (Test-Path -Path $WimTst) { $WimSrc = $Root + "\Win_Files\sources\install.wim" } Else { $WimSrc = $Root + "\Win_Files\sources\install.esd" }

# Copy Wim/esd to WimCP, Make readable and Mount
Set-ItemProperty -Path $WimSrc -Name IsReadOnly -Value $false
$WinVerWIM = (Get-WindowsImage -ImagePath $WimSrc)
[int]$wvEdu = "20"

if ($winrev -ne 'None')
    {
    While (!($wvEdu -lt $WinVerWIM.count))
        {
        For ($wv=0; $wv -le $WinVerWIM.count; $Wv++)
            {
            $WinVerIso = ($WinVerWim[$WV].imagename)

            # Check for matching Version
            If ($WinVerIso -eq $Winrev)
                {
                $wv++
                $WvEdu = $Wv
                Break
                }

            #IF things get this far, there is no matching version. Reset Winrev to none and go to ask for version.
            If ($WinVerIso -eq $Null)
                {
                $Winrev  = 'None'
                Break
                }
            }
        }
    }
Else
    {
    While (!($wvEdu -lt $WinVerWIM.count))
        {
        Clear-host
        Write-Host "Choose Windows Version :-"
        Write-Host

        For ($wv=0; $wv -le $WinVerWIM.count; $Wv++)
                {
                $WinVerIso = ($WinVerWim[$WV].imagename)
                If ($WinVerIso -eq $Null)
                    {
                    Break
                    }
                $Nbr = $wv
                $Nbr++
                Write-Host $Nbr $WinVerIso
                }
        Write-Host
        [int]$verWin1= Read-Host -Prompt "#"
        $ShowVer = $verWin1
        $ShowVer--
        $Winrev  = ($WinVerWim[$ShowVer].imagename)
        $wvEdu   = $verWin1
        }
    }

Save-Defaults

Write-Host "Exporting Windows Image Index $wvEdu - $Winrev to $WimCP"
if (Test-Path -Path $WimTst)
    {
    Export-WindowsImage -SourceImagePath $WimSrc -SourceIndex $WvEdu -DestinationImagePath $WimCP -DestinationName $Winrev
    }
Else
    {
    dism /export-image /SourceImageFile:$WimSrc /SourceIndex:$WvEdu /DestinationImageFile:$WimCP /Compress:max /CheckIntegrity    
    }

#Delete .wim file ready for replacement
Remove-Item -Path $WimSrc -Force
Get-WindowsImage -ImagePath $WimCP
Write-Host "Image Index $wvEdu Exported as $WimCP"

#Index is now always 1 as only 1 index was exported.
Dism /Cleanup-Wim
Dism /mount-wim /wimfile:$WimCP /Index:1 /MountDir:$mount1
Write-Host "New Image Mounted - $WimCP with Index $wvEdu to $mount1"
Dism /Image:$Mount1 /Get-Packages /Format:Table

#Copy file structure to WIMfile - This is not the ISO Root, but the Install.wim file.
takeown /f $Pics /r /d y
icacls $Pics /grant administrators:F /t
robocopy $CDrive $Mount1 /e /NP

#Install Windows Updates to Windows Image
if($updateReady -eq 'yes')
    { 
    Write-Host "Installing Windows Updates from $WSUS to @Mount 1"
    Add-WindowsPackage -Path $Mount1 -PackagePath $WSUS -IgnoreCheck
    Dism /Image:$Mount1 /Get-Packages /Format:Table
    Write-Host "Installed Windows Updates from $WSUS to @Mount 1" - DIsmount image next
    }

#Update Defaults
#$WinVer = DISM /get-wiminfo /wimfile:$wimsrc
#$WinVer = $WinRev[2]
#$WinVer = $WinRev.split(": ")[-1]
Save-Defaults

#Mount Boot.wim and Install Base Drivers - Usually WIFI and NIC
Write-Host "Installing WINPE Drivers from $PeDrv to $Mount2"
Set-ItemProperty -Path $WimBoot -Name IsReadOnly -Value $false
Dism /mount-wim /wimfile:$WimBoot /Index:1 /MountDir:$mount2
Dism /Image:$Mount2 /Add-Driver /Driver:$PeDrv /Recurse /forceunsigned

#dismount Boot.wim
Write-Host "Dismounting Boot.wim"
Dism /Unmount-Image /MountDir:$Mount2 /Commit
Write-Host "Image $WimBoot Dismounted from $Mount2 and Cleaned"

#Dismount WIM File
Write-host "Dismounting Image from $mount1"
dism /Unmount-Image /MountDir:$Mount1 /Commit
Dism /Cleanup-Wim
Write-Host "Image $WIMCP Dismounted from $Mount1 and Cleaned"

#Convert Wimfile split WIM SWM
Dism /Split-Image /ImageFile:$WimCP /SWMFile:$WimCPe /FileSize:3500
Write-Host "Split WIM File Created at $wimcpe from $WimCP Index 1"
Get-ChildItem -Path $WimFin -Include *.swm | Copy-Item -Destination $WimSrce
Write-host "Converted Image $WimCP to $WimCPe - Creating ISO file next"

#Set ISO File and Log file names.
$WinRev2 = $winrev -replace '\s',''
$NewSoe   = $Root + "\_NewSOE\" + $fName + "-" + $WinRev2 + "-v" + $Isover + ".iso"
$Log2     = $Root + "\_NewSOE\" + $fName + "-" + $WinRev2 + "-v" + $Isover + ".log"

#Create new ISO
Write-Host "Creating new Windows 10 ISO file at $NewSoe"
$niso = $pRoot + "\NewISO.ps1"
. $niso
$IsoEfi = $ISOext + "\efi\microsoft\boot\efisys.bin"
New-ISOFile -source $ISOext -destinationIso $NewSoe -bootFile $IsoEfi -title $fName
Write-host
write-host "Build Complete"
Write-host
Stop-Transcript
Copy-Item $trans $log2