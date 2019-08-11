<#   
.SYNOPSIS   
         
     This script is designed to check and convert video files based on a custom setting file from HandBrake.


.DESCRIPTION

    Converts any video file type defined $IncludedFileTypes variable, including those contained in subfolders using the HandBrakeCLI executable.

    It excludes any filenames with strings defined in the $ExcludedFiles variable, typically just 265 and HEVC.

    It will change the filename from containing '264' and replace it with '265', including the containing folders too.

    If the filename does not contain '265' then '.265' is appended. This also prevents it from being reprocessed if the script is ever rerun.

    Files are double checked using MediaInfo CLI before converting to see if they are in fact HEVC already.

    To reduce Plex scan times you can select which library the current scan resides in. This prevents Plex picking up the converted file as a new 
    episode/movie which can occur if Plex removes the original file (because it's been moved) from the library and then identifies the new file.
    This can be skipped by specifying the -SkipPlexScan parameter (Example: 265.ps1 -SkipPexScan)


.DEFAULT INSTALLATION:
    
    Place script files and xml files into C:\Temp\265\

    Add C:\Temp\265\ to your system PATH env variable to be able to run from anywhere
    Command Prompt: SET PATH=%PATH%;"C:\Temp\265\"
    
    Place the included JSON file into the installation folder (C:\Temp\265\)

    Place the HandbrakeCLI executable into C:\Temp\265\
        Downloadable from:      https://handbrake.fr/downloads2.php

    Place the Handle executables into C:\Temp\265\
        Downloadable from:      https://docs.microsoft.com/en-us/sysinternals/downloads/handle

    Place MediaInfoCLI executable into C:\Temp\265\
        Downloadable from:      https://mediaarea.net/en/MediaInfo/Download/Windows

    Plex installed into default location: C:\Program Files (x86)\Plex\Plex Media Server\
        Downloadable from:      https://www.plex.tv/media-server-downloads/


.REQUIREMENTS

    Place this script file and associated configuration file (xml file) in a folder included in your SYSTEM PATH environment variable. 
    To display the current paths, run the following from a PowerShell prompt: $Env:path

    HandBrakeCLI must be installed and the location defined in the $HandBrakeCLIInstallPath variable, under User Settings section.
        Download from: https://handbrake.fr/downloads.php

    MediaInfoCLI must be installed and the location defined in the $MediaInfoCLIInstallPath variable, under User Settings section.
        Download from: https://mediaarea.net/en/MediaInfo/Download/Windows

    Handle must be installed and the location defined in the $HandleCLIInstallPath variable, under User Settings section.
        Download from: https://docs.microsoft.com/en-us/sysinternals/downloads/handle

    Plex must be installed and the location of the Plex Media Scanner executable defined in the $PlexMediaScannerInstallPath variable, under User Settings section.
        Downloadable from:      https://www.plex.tv/media-server-downloads/

    The configuration xml file for this script must be stored in the same location as the this script file.

    The configuration xml filename must be scriptfilename.xml (If this script is called 265.ps1 then the xml file must be 265.ps1.xml).

    The HandBrake process refers to a JSON file containing the conversion configuration settings. This must exist and be configured 
    in the $HandBrakePresetFile variable, under User Settings section. You can create your own HandBrake JSON file with your own settings, just update 
    the variable.

    The HandBrake Preset Name must be defined in the $HandBrakePresetName variable, under User Settings section.


.HOW TO USE

    Once the requirements have been met the script is simple to operate.

    1. Open PowerShell on your Windows 10 computer (option c will also work on lower versions of Windows).
            a. Shift + Right-click the folder you want to convert, Open PowerShell window here
            b. Windows key + X, select Windows PowerShell
            c. Windows key+R, type powershell.exe
    
    2. If you're not already, navigate to the folder you wish to convert.

    3. Type 265.ps1 and press enter.

    4. Select the Plex library associated with the folder you are converting and press OK.

    5. Sit back and wait for Borat.


    There are also some parameters you can set on the process as desribed below.



.PARAMETER ShowWindows
    This parameter is used to show the command windows launched during processing however they will be launched minimised. The default keeps all windows hidden.

    To show the windows, add the following: -ShowWindows


.PARAMETER Refresh
    This parameter is used to set how often HandBrakeCLI reports it progress. The default is 60 seconds. Setting this value will override it.

    To set the refresh rate to 30 seconds, add the following: -Refresh 30


.PARAMETER SkipPlexScan
    This parameter is used to skip the Plex Media Scanner section. This is useful if processing files outside of the Plex libraries.
    Use cases could include a post-download task.

    To skip the Plex Media Scan, add the following: -SkipPlexScan





.CHANGE LOG
############################################## 
#Script Title: HEVC Video Converter
#Script File Name: 265.ps1  
#Author: Adam Callaghan 
#Date Created: 25/7/2019  
############################################## 

V1.00 | First release
V1.01 | Added parameter/switch to run in quiet mode by not showing command windows for HandBrake, Plex and MediaInfo.
V1.02 | Changed file actions to use -LiteralPath where possible to fix problem with files/folders with square brackets []
        Added a counter into the loop of how many files are in the queue and a count down of how many are left.
        Added functon (CheckJSON) to check the HandBrake preset file for a known problematic string.
        Fixed issue with creating the new folder if square brakets [] are used in the file/folder name.
        Updated screen outputs to consistent and aligned format.
        Replaced quiet mode by setting it as the default and created new switch for ShowWindows, allowing the user to show processing windows. 
        Changed default refresh interval to 60 seconds.
        Fixed issue of not being able to count single file in the list.
        Fixed issue of existing file in processing folder by recreating the folder structure instead of moving all files into one folder.
        User switch added to skip the Plex Scan.
        Fixed error with MediaInfo format check where it was reading the wrong variable and always returning false and converting even if HEVC.
V1.03 | Amended text file paths prior to starting the HandBrake conversion.
        Added Handle as a required program.
        Added a function to check the locked status of any file and use Handle to lookup the locking process.
        Updated the HandBrake conversion process to check for the process ID it spawned and not the HandBrake executable. This allows multiple instances
        of the script to be run without getting stuck.
        Added start time to the start of the file processing loop.
        Added screen output referencing the Transcript file instead of just sending the output to null. Sending it to screen normally is too basic.
        Slight amendment to wording at the start of each file loop, now reads "Starting file" instead of "Starting process for file".
        Slight amendment to main file list, using : instead of -
V1.04 | Updated install location to use C:\Temp\265\




.FUTURE DEVELOPMENT

    Move the user settings out to the xml configuration file so that future updates to the script won't overwrite user settings

    Display the reduction of file size in percentage

    If the source folder is now empty, remove it. Try to think of circumstances where this might be a bad idea.

    Add a help section/readme into the file

    Add a disk space check process to warn and pause on low disk space

    Add a parameter to limit number of files to process

    Add a rename function/parameter if the file is already in HEVC format, that way reprocessing the library wont need to check the mediainfo formats.
    Need to be careful due to Plex processing sequence and adding the files back in as a new item (hence the whoel reason Plex Scan is part of the loop)

    Add timings into the script to show how long things are taking. Can also add in an average time checker and ETA for the whole process.

    User option or input parameter to specify to move or delete the source files.

    Input parameter to send the output to another folder. Useful for converting recent content not yet added to the Plex library

    Input parameter to receive the input folder to be processed. Useful for automating a post process from another application.

    Add a function to read the HB log file and increase the frequency near the end based on remaining time left. This will allow setting a higher refresh value but not
    be waiting around for the next refresh to check if HB has finished or not.  Or could this actually be better done by checking the process handle more frequently
    inside that loop?  For instance, update the screen with log info as per user settings but check the process thread more frequently any way.

    Add user option to delete log once completed?

#>


# Capture input parameters
    param(

[switch]  $ShowWindows=$false,
[int]     $Refresh,
[switch]  $SkipPlexScan=$false

)

# Show Windows
if ($ShowWindows -eq $true) {$RunMode = "Minimized"}
if ($ShowWindows -eq $false)  {$RunMode = "Hidden"}

# Refresh Interval
if ($Refresh -eq '') {$HandBrakeProgressUpdateInterval = '60'}
if ($Refresh -ne '') {$HandBrakeProgressUpdateInterval = $Refresh}





############### User Settings ###############

$InstallPath =                 'C:\Temp\265\'                                                          # Base location for conversion files
$IncludedFileTypes =           @('*.mkv', '*.mp4', '*.avi', '*.m4v', '*.mpg', '*.mpeg', '*.ts')        # Set file types to include for conversion
$ExcludedFiles =               @('*265*','*HEVC*')                                                     # Set string values for files to exclude from conversion
$HandBrakePresetName =         'H.265 MKV Match Frame'                                                 # Set name of the HandBrake preset name
$HandBrakePresetFile =         $InstallPath+'H.265 MKV Match Frame.json'                               # Set the location of the HandBrake preset json file
$HandBrakeCLIInstallPath =     $InstallPath+'handbrakecli.exe'                                         # Location of HandBrakeCLI
$MediaInfoCLIInstallPath =     $InstallPath+'MediaInfo.exe'                                            # Location of MediaInfoCLI
$HandleCLIInstallPath =        $InstallPath+'Handle.exe'                                               # Location of Handle
$PlexMediaScannerInstallPath = 'C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Scanner.exe'  # Location of Plex Media Scanner

############### Check if HandBrakeCLI is already running a conversion ###############

Write-Host "Checking if HandbrakeCLI is already running...     " -ForegroundColor Cyan -NoNewline

$CheckHBCLIRunning = Get-Process -Name HandBrakeCLI -ErrorAction SilentlyContinue

if ($CheckHBCLIRunning -eq $null)
{Write-Host "HandbrakeCLI is not running" -ForegroundColor Green}

if ($CheckHBCLIRunning -ne $null)
{
Write-Host "HandBrakeCLI is already running, do you wish to run another conversion? [y/n]" -ForegroundColor Red
$UserResponse = Read-Host 
while ($UserResponse -ne "y")
{
    if ($UserResponse -eq 'n') {exit}
    if ($UserResponse -eq 'y') {continue}
    Write-Host "HandBrakeCLI is already running, do you wish to run another conversion? [y/n]" -ForegroundColor Red

    $UserResponse = Read-Host
}
}
###############################################


############### Setup ###############

# Get the current date and time
$Date = Get-Date
$DateFormatted = $Date.ToString("yyyyMMdd-hhmmss")

# Send output to file in current folder
$ErrorActionPreference = "SilentlyContinue" # Supress errors in case Transcript is not running
$265LogOutput = '265-Output-'+$DateFormatted+'.log'

Stop-Transcript | out-null
Write-Host "Starting new log file...                           " -ForegroundColor Cyan -NoNewline
Start-Transcript -path $265LogOutput -Append | Out-Null
Write-Host "$265LogOutput" -ForegroundColor Green

# Drop the priority of Powershell (and subsequent tasks) Below Normal
Write-Host "Setting processor priorty to Below Normal...       " -ForegroundColor Cyan -NoNewline

$process = Get-Process -Id $pid # Get process ID
$process.PriorityClass = 'BelowNormal' # Set priority to below normal
$process = Get-Process -Id $pid # Get process ID again

if ($process.PriorityClass -eq 'BelowNormal')
{Write-Host "Processor priorty set to Below Normal" -ForegroundColor Green }

if ($process.PriorityClass -ne 'BelowNormal')
{Write-Host "Could not change priorty, continuing anyway" -ForegroundColor Yellow }


# Stop on any errors
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction']='Stop'

# Connect to XML configuration file
$ScriptName = Split-Path $PSCommandPath -Leaf

$XMLFile = $PSCommandPath + '.xml'
# $XMLFile = 'C:\Program Files\HandBrake\265.ps1.xml' # Used to manually run the script in PowerShell ISE




############################## Functions ##############################

function FileCleanUp
{
############### Clean up processed files ###############
# Moving processed files
$FileDrive = (Get-Item -LiteralPath $File).PSDrive.Name+':' # Get the drive letter of the file
$ProcessedFolder = $FileDrive+'\Processed' # Set the value of drive letter\Processed
$SourcePathSplit = (split-path $File).Split(':')
$SourcePathSplit = $SourcePathSplit[1]
$SourceProcessedPath = $ProcessedFolder+$SourcePathSplit
$SourceProcessedPathCheck = Test-Path $SourceProcessedPath

Write-Host "Moving source file to $ProcessedFolder ...             " -ForegroundColor Cyan -NoNewline
if ($SourceProcessedPathCheck -eq $true) # If the Processed folder exists, do the following
{
Move-Item -LiteralPath $File -Destination $SourceProcessedPath # Move the file
Write-Host "File moved`n" -ForegroundColor Green
}
elseif ($SourceProcessedPathCheck -eq $false) # If the Processed folder does not exist, do the following
{
Write-Host "Target folder does not exist and will be created" -ForegroundColor Yellow
New-Item -Path $SourceProcessedPath -ItemType Directory | Out-Null
Write-Host "Target folder created, moving file...              " -ForegroundColor Cyan -NoNewline

Move-Item -LiteralPath $File -Destination $SourceProcessedPath # Move the file
Write-Host "File moved`n" -ForegroundColor Green
}
}


############### Check the JSON Preset for a line of code that's currently a known bug ###############
function CheckJSON
{
$HandBrakeJSONString = "PictureRotate"

Write-Host "Checking HandBrake preset for $HandBrakeJSONString ...    " -ForegroundColor Cyan -NoNewline

$HandBrakeJSONCheck = (Get-Content -LiteralPath $HandBrakePresetFile | Select-String -Pattern $HandBrakeJSONString -SimpleMatch)
$HandBrakeJSONCheck = $HandBrakeJSONCheck | %{$_ -match $HandBrakeJSONString}

if ($HandBrakeJSONCheck -eq $true) 
{
Write-Host "`nHandBrake preset file contains line $HandBrakeJSONCheck which will cause the conversion to fail, exiting..." -ForegroundColor Red 
Stop-Transcript
exit
}
if ($HandBrakeJSONCheck -ne $true) 
{
Write-Host "Not found" -ForegroundColor Green 
}
}



############### Check if the specified file is locked by a process ###############
Function Get-FileLockedStatus {
param(
[Parameter(Mandatory=$true)]
[string]  $FileToCheck
)

$oFile = New-Object System.IO.FileInfo $FileToCheck
$FileLockCheck =  try {
    $oStream = $oFile.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
    if ($oStream) {$oStream.Close()}
    
    # file is not locked by a process.
    Write-Host "File is not locked" -ForegroundColor Green
    
  return $false
  } 
  catch {
    # file is locked by a process.
        Write-Host "File is locked" -ForegroundColor Red
  $true
  }

if ($FileLockCheck -eq $true){
Write-Host "Finding programs locking the file...               " -ForegroundColor Cyan -NoNewline
$HandleLogOutput = 'Handle-Output-'+$LoopStartDateFormatted+'.log'
$HandleArgs = '-u "'+$FileToCheck+'" -nobanner'
$HandleCheck = (Start-Process -FilePath $HandleCLIInstallPath -ArgumentList $HandleArgs -WindowStyle $RunMode -Wait -PassThru -RedirectStandardOutput $HandleLogOutput)
$HandleResult = Get-Content $HandleLogOutput
#Remove-Item -LiteralPath $HandleLogOutput -Force

if ($HandleResult -contains 'No matching handles found.'){
Write-host "File is no longer locked" -ForegroundColor Gray
}

if ($HandleResult -notcontains 'No matching handles found.')
    {$Handles = $HandleResult | Where {$_ -ne ""} | Select-Object -Property @{ N = "Process"; E = { ($_ -split '(?<!:)\s+')[0] } },
												       @{ N = "PID";     E = { (($_ -split '(?<!:)\s+')[1] -replace 'pid:\s*') } },
												       @{ N = "Type";    E = { ($_ -split '(?<!:)\s+')[2] -replace 'type:\s*' } },
												       @{ N = "User";    E = { ($_ -split '(?<!:)\s+')[3] } }

$ProcessCount = @($FileList).Count
#if ($Handles.Count -eq $null){$ProcessCount = 1}
#if ($Handles.Count -ne $null){$ProcessCount = $Handles.Count}

Write-host "Number of locking processes: $ProcessCount"  -ForegroundColor Red 

$ProcessIndexNumber = 0

foreach ($Handle in $Handles){
$ProcessIndexNumber++
$HandlePID = $Handle.PID
$HandlePID = $HandlePID.PadLeft(6,' ')
$HandleName = $Handle.Process
$LockingProcess = Get-Process -id $HandlePID | Select-Object Path
$LockingProcess = $LockingProcess.Path

Write-host "$ProcessIndexNumber | PID:$HandlePID | $LockingProcess"  -ForegroundColor Gray 

}
}
return $true
}
}


###############################################


############### Test Locations of executables ###############

# Check HandBrakeCLI install path

$HandBrakeCLIPathCheck = Test-Path -LiteralPath $HandBrakeCLIInstallPath -PathType Leaf

Write-Host "Checking if HandBrakeCLI is installed...           " -ForegroundColor Cyan -NoNewline

if ($HandBrakeCLIPathCheck -contains $true)
{
Write-Host "HandBrakeCLI is installed" -ForegroundColor Green 
}

if ($HandBrakeCLIPathCheck -contains $false)
{
Write-Host "`nHandBrakeCLI is not installed in the user defined location $HandBrakeCLIInstallPath, exiting..." -ForegroundColor Red 
Stop-Transcript
exit
}


# Check MediaInfoCLI install path

$MediaInfoCLIPathCheck = Test-Path -LiteralPath $MediaInfoCLIInstallPath -PathType Leaf

Write-Host "Checking if MediaInfoCLI is installed...           " -ForegroundColor Cyan -NoNewline

if ($MediaInfoCLIPathCheck -contains $true)
{
Write-Host "MediaInfoCLI is installed" -ForegroundColor Green 
}

if ($MediaInfoCLIPathCheck -contains $false)
{
Write-Host "`nMediaInfoCLI is not installed in the user defined location $MediaInfoCLIInstallPath, exiting..." -ForegroundColor Red 
Stop-Transcript
exit
}


# Check Plex Media Scanner install path

$PlexMediaScannerPathCheck = Test-Path -LiteralPath $PlexMediaScannerInstallPath -PathType Leaf

Write-Host "Checking if Plex Media Scanner is installed...     " -ForegroundColor Cyan -NoNewline

if ($PlexMediaScannerPathCheck -contains $true)
{Write-Host "Plex Media Scanner is installed" -ForegroundColor Green}

if ($PlexMediaScannerPathCheck -contains $false)
{
Write-Host "`nPlex Media Scanner is not installed in the user defined location $PlexMediaScannerInstallPath, exiting..." -ForegroundColor Red 
Stop-Transcript
exit
}


# Check Handle install path

$HandlePathCheck = Test-Path -LiteralPath $HandleCLIInstallPath -PathType Leaf

Write-Host "Checking if Handle is installed...                 " -ForegroundColor Cyan -NoNewline

if ($HandlePathCheck -contains $true)
{Write-Host "Handle is installed" -ForegroundColor Green}

if ($HandlePathCheck -contains $false)
{
Write-Host "`nHandle is not installed in the user defined location $HandleCLIInstallPath, exiting..." -ForegroundColor Red 
Stop-Transcript
exit
}
###############################################


############## Check the JSON Preset for known bug ##############

CheckJSON


############## Plex Library Picker ################
if ($SkipPlexScan -eq $true)
{
Write-Host "Skipping Plex Library request...                     " -ForegroundColor Cyan
}
if ($SkipPlexScan -eq $false)
{
Write-Host "Requesting Plex Library for Media Scan...          " -ForegroundColor Cyan -NoNewline

$PlexLog = 'PlexLibraries.txt'

$PlexLibraryList = (Start-Process -FilePath $PlexMediaScannerInstallPath -ArgumentList '--list' -WindowStyle $RunMode -Wait -PassThru -RedirectStandardOutput $PlexLog)

Add-Content -Path $PlexLog -Value '  0: ALL PLEX LIBRARIES' # Manually add an extra line into the logfile for scanning all libraries

$PlexLibraries = Get-Content $PlexLog | Sort # Read the log file
$PlexPicker = @($PlexLibraries | Out-GridView -Title '############### Plex Library Picker ###############' -PassThru) # Display a picker using the log contents as the options

$PlexLibrary = $PlexPicker.split(":") # Split the user returned result using the : character
[string]$PlexLibraryNumber = $PlexLibrary[0] # Get the content of the line before the : character which should just have a library number
$PlexLibraryName = $PlexLibrary[1] # Get the content of the line after the : character which should just have the library name

$PlexLibraryNumber = $PlexLibraryNumber.Trim() # Trim off any blank spaces from the number
$PlexLibraryName = $PlexLibraryName.Trim() # Trim off any blank spaces from the Name

[int]$PlexLibraryNumber = [convert]::ToInt32($PlexLibraryNumber, 10) # Convert it to an integer instead of a string

if ($PlexLibraryNumber -eq '0')
{
$PlexLibraryOut = ''
Write-Host "Library set to: All Libraries" -ForegroundColor Green
}
if ($PlexLibraryNumber -ne '0')
{
$PlexLibraryOut = '--section ' + $PlexLibraryNumber
Write-Host "Library set to: $PlexLibraryName" -ForegroundColor Green
}

Remove-Item -LiteralPath $PlexLog -Force
}

###############################################


############### Establish file list ###############

# Get the full path of all video files in the current and sub-folders
Write-Host "Building list of files for conversion..." -ForegroundColor Cyan 
$FileList = Get-ChildItem -Recurse -Include $IncludedFileTypes -Exclude $ExcludedFiles | % { $_.FullName }

if ($FileList -eq $null) 
{
Write-Host "`nNo files found for conversion`n" -ForegroundColor Red
Stop-Transcript
exit
}

# List all files for conversion
$FileIndexNumber = 0
Foreach ($File in $FileList)
{
$FileIndexNumber++
Write-Host "$FileIndexNumber`: $File " -ForegroundColor Gray 
}
Write-Host ""
###############################################



############### Processing loop for each file ###############
$FileIndexNumber = 0

:FileProcessingLoop Foreach ($File in $FileList)
{
$FileIndexNumber++
$FileCount = @($FileList).Count

$LoopStartDate = Get-Date
$LoopStartDateFormatted = $LoopStartDate.ToString("yyyyMMdd-hhmmss")
$LoopStartTimeFormatted = Get-Date -UFormat %R

Write-Host "$LoopStartTimeFormatted | Starting file $FileIndexNumber of $FileCount`: $File" -ForegroundColor Black -BackgroundColor Cyan
############### Check if processing is paused in the config file ###############

# Get current pause status
Write-Host "Checking if processing has been paused...          " -ForegroundColor Cyan -NoNewline

[xml]$xml = ((Get-Content $XMLFile)) # Read xml file
$CurrentPauseStatus = $xml.root.conversionpaused # Get value of conversionpaused 

while ($CurrentPauseStatus -eq 'y') # If paused, do the following
{ 
Write-Host "Processing is paused" -ForegroundColor Red
Write-Host "Waiting 60 seconds...                              " -ForegroundColor Cyan -NoNewline
Start-Sleep -Seconds 60 # Wait 60 seconds and try again

[xml]$xml = ((Get-Content $XMLFile)) # Read xml file
$CurrentPauseStatus = $xml.root.conversionpaused # Get value of conversionpaused 

}

if ($CurrentPauseStatus -eq 'n')
{Write-Host "Processing is not paused" -ForegroundColor Green}


############### Check if video file is already in HEVC format ###############
$MILogOutput = 'MI-Output-'+$LoopStartDateFormatted+'.log'
$MediaInfoArg = '--inform="Video;%Format%" "'+$File+'"'

Write-Host "Checking if source is already HEVC format...       " -ForegroundColor Cyan -NoNewline


# Run MediaInfo and get the Format field, log result to a file and read it back. Delete log file afterwards.
$MediaInfoCheck = (Start-Process -FilePath $MediaInfoCLIInstallPath -ArgumentList $MediaInfoArg -Wait -WindowStyle $RunMode -PassThru -RedirectStandardOutput $MILogOutput)

if ($MediaInfoCheck.ExitCode -eq 0)
    {
    $MILog = Get-Content $MILogOutput -Tail 1
    $MILogcontainsWord = $MILog | %{$_ -match "HEVC"}

    if ($MILogcontainsWord -eq $false)
        {
        Remove-Item -LiteralPath $MILogOutput -Force # Remove MediaInfo log file, no longer needed
        Write-Host "Source file is $MILog, continuing with conversion" -ForegroundColor Green
        }

    if ($MILogcontainsWord -eq $true)
        {
        Remove-Item -LiteralPath $MILogOutput -Force # Remove MediaInfo log file, no longer needed
        Write-Host "Source video file is HEVC, skipping to the next file" -ForegroundColor Yellow
        continue FileProcessingLoop 

        }
    }

if ($MediaInfoCheck.ExitCode -ne 0)
{
Write-Host "Failed to read MediaInfo for $File, exiting..." -ForegroundColor Red
Stop-Transcript
exit
}




############### Process output filename ###############


# Check filename and path for string 264 and set the output filename to replace it with 265
$wordtofind = '264'
$wordtoreplace = '265'
$containsword = $File | %{$_ -match $wordtofind} # Looking for string


if ($containsWord -contains $true) # If string is found, replace it
{
$FileOut = [IO.Path]::ChangeExtension($File,'mkv') # Set the output file extention type to MKV
$FileOut = ($FileOut) | ForEach-Object {$_ -replace $wordtofind, $wordtoreplace} # Replace the string in the whole path. This script only caters for file and containing folder strgin name replacement.

# If the containing folder also included the 264 string, replace and create new destination folder using 265
$FileOutPath = Split-Path $FileOut # Get just the folder path of the new output file, IE drop the filename

$FileOutPathExists = Test-Path -LiteralPath $FileOutPath # Test if the new folder path already exist
Write-Host "Checking if destination folder already exists...   " -ForegroundColor Cyan -NoNewline

if ($FileOutPathExists -contains $true) # If the new destination folder does exist, do the following
{
Write-Host "Destination folder already exists" -ForegroundColor Yellow
}
elseif ($FileOutPathExists -contains $false) # If the new destination folder does not exist, do the following
{

$FileOutPathParent = Split-Path -Parent $FileOutPath # Get the parent folder path of the new destination folder
$FileOutPathFolder = Split-Path -Leaf $FileOutPath # Get the name of the of the new destination folder

Write-Host "Destination folder does not exist" -ForegroundColor Green
Write-Host "Creating new destination folder...                 " -ForegroundColor Cyan -NoNewline

New-Item -Path $FileOutPathParent -Name $FileOutPathFolder -ItemType Directory | Out-Null # Make the new destination folder

Write-Host "Destination folder created" -ForegroundColor Green
}
}



# If string is not found then set the output filename to match the input filename
elseif ($containsWord -contains $false) 
{
$wordtofind = '.mkv'
$wordtoreplace = '.x265.mkv'

$FileOut = [IO.Path]::ChangeExtension($File,'mkv') # Set the output file extention type to MKV
$FileOut = ($FileOut) | ForEach-Object {$_ -replace $wordtofind, $wordtoreplace} # Replace the string in the whole path. This script only caters for file and containing folder strgin name replacement.
}



# Check if the output file already exists (likely because of a previous failed conversion)
Write-Host "Checking if output file already exists...          " -ForegroundColor Cyan -NoNewline
$CheckExistingFileOut = Test-Path -LiteralPath $FileOut -PathType Leaf # Tests if the file already exists


if ($CheckExistingFileOut -eq $true) # If file exists, do the following
{
Write-Host "Output file already exists`n" -ForegroundColor Yellow
Write-Host "Comparing video durations to determine whether to overwrite..." -ForegroundColor Cyan

########### Get the duration of the source file ###########
$MILogOutput = 'MI-Output-'+$LoopStartDateFormatted+'.log'
$MediaInfoArg = '--inform="Video;%Duration%" "'+$File+'"'

# Run MediaInfo and get the Duration field, log result to a file and read it back. Delete log file afterwards.
$MediaInfoCheck = (Start-Process -FilePath $MediaInfoCLIInstallPath -ArgumentList $MediaInfoArg -Wait -WindowStyle $RunMode -PassThru -RedirectStandardOutput $MILogOutput)
$MIFileDuration = Get-Content $MILogOutput -Tail 1
$MIFileDuration = $MIFileDuration.trim()
$MIFileDuration = $MIFileDuration.split(".")
$MIFileDuration = $MIFileDuration[0]
[int]$MIFileDurationNumber = [convert]::ToInt32($MIFileDuration, 10) # Convert it to an integer instead of a string

Write-Host "  Source file duration: $MIFileDurationNumber" -ForegroundColor Gray


Remove-Item -LiteralPath $MILogOutput


########### Get the duration of the output file ###########
$MILogOutput = 'MI-Output-'+$LoopStartDateFormatted+'.log'
$MediaInfoArg = '--inform="Video;%Duration%" "'+$FileOut+'"'

# Run MediaInfo and get the Duration field, log result to a file and read it back. Delete log file afterwards.
$MediaInfoCheck = (Start-Process -FilePath $MediaInfoCLIInstallPath -ArgumentList $MediaInfoArg -Wait -WindowStyle $RunMode -PassThru -RedirectStandardOutput $MILogOutput)
$MIFileOutDuration = Get-Content $MILogOutput -Tail 1
$MIFileOutDuration = $MIFileOutDuration.trim()
$MIFileOutDuration = $MIFileOutDuration.split(".")
$MIFileOutDuration = $MIFileOutDuration[0]
if ($MIFileOutDuration -eq '') {$MIFileOutDuration = 0}

[int]$MIFileOutDurationNumber = [convert]::ToInt32($MIFileOutDuration, 10) # Convert it to an integer instead of a string

Write-Host "Existing file duration: $MIFileOutDurationNumber`n" -ForegroundColor Gray

Remove-Item -LiteralPath $MILogOutput




########### Compare the two durations ###########
if ($MIFileDurationNumber -eq  $MIFileOutDurationNumber) 
    {
        Write-Host "Existing file has the same duration as the source file and does not need to be reprocessed`n" -ForegroundColor Green

        FileCleanUp

        continue FileProcessingLoop
    }

if ($MIFileDurationNumber-ge $MIFileOutDurationNumber) 
    {
        Write-Host "Existing file has a smaller duration than the source file and will be deleted`n" -ForegroundColor Yellow
    }
}

#####################################################################################

if ($CheckExistingFileOut -eq $false) # If file does not exist, do the following (continue)
{
Write-Host "Output file does not already exist" -ForegroundColor Green 

}


Write-Host "Paths for this conversion..." -ForegroundColor Cyan 
Write-Host " Original Source: $File" -ForegroundColor Gray 
Write-Host "Converted Output: $FileOut `n" -ForegroundColor Gray 


###############################################




############### HandBrake Conversion ###############

# Start HandBrake conversion
Write-Host "Starting conversion, updates every $HandBrakeProgressUpdateInterval seconds..." -ForegroundColor Cyan -NoNewline

# Set HandBrake execution variables
$HBLogError = 'HB-Error-'+$LoopStartDateFormatted+'.log'
$HBLogOutput = 'HB-Output-'+$LoopStartDateFormatted+'.log'
$HandBrakeArg = '-i "'+$File+'" -o "'+$FileOut+'" --preset-import-file "'+$HandBrakePresetFile+'" -Z "'+$HandBrakePresetName+'" --all-audio -E copy'

#Run the conversion and log to a single file. The logs get overwritten each loop thereby only keeping the last failed conversion log files.
$HandBrakeConversion = (Start-Process -FilePath $HandBrakeCLIInstallPath -ArgumentList $HandBrakeArg -WindowStyle $RunMode -PassThru -RedirectStandardOutput $HBLogOutput -RedirectStandardError $HBLogError)

# Cache the process to capture the Exit Code
$HandBrakeHandle = $HandBrakeConversion.Handle # Cache HandBrakeConversion.Handle for ExitCode 
$HandBrakePID = $HandBrakeConversion.Id

# Tail the output log file of HandBrakeCLI and print onscreen
do {
$HBLogTail = Get-Content $HBLogOutput -Tail 1
Write-Host "$HBLogTail" -ForegroundColor Gray
Start-Sleep -Seconds $HandBrakeProgressUpdateInterval
$CheckHBCLIRunning = Get-Process -Id $HandBrakePID -ErrorAction SilentlyContinue
}
until ($CheckHBCLIRunning -eq $null)


# Check if HandBrakeCLI completed successfully or not
if ($HandBrakeConversion.ExitCode -eq 0) # If conversion is successful, do the following
{
$HBLogTail = Get-Content $HBLogOutput -Tail 1
Write-Host "$HBLogTail`n" -ForegroundColor Gray
Write-Host "Conversion completed successfully" -ForegroundColor Green
Remove-Item -LiteralPath $HBLogOutput -Force
Remove-Item -LiteralPath $HBLogError -Force
}
elseif ($HandBrakeConversion.ExitCode -ne 0) # If conversion is successful, do the following
{
Write-Host "Conversion failed with exit code: " $HandBrakeConversion.ExitCode -ForegroundColor Red
Stop-Transcript
exit
}



###############################################




# Skip Plex Scan
if ($SkipPlexScan -eq $true){}
if ($SkipPlexScan -eq $false)
{
############### Scan Media Scan ###############
# Trigger a Plex Media Scan on all libraries
$PlexArgs = '--scan '+$PlexLibraryOut+''


Write-Host "Starting Plex Media Scanner...                     " -ForegroundColor Cyan -NoNewline
$PlexScan = (Start-Process -FilePath $PlexMediaScannerInstallPath -ArgumentList $PlexArgs -WindowStyle $RunMode -Wait -PassThru)

if ($PlexScan.ExitCode -eq 0) # If scan is successful, do the following
{
Write-Host "$PlexLibraryName scanned" -ForegroundColor Green
}
elseif ($PlexScan.ExitCode -ne 0) # If scan fails, do the following
{
Write-Host "Plex Media Scan failed with exit code " +$PlexScan.ExitCode -ForegroundColor Red
Stop-Transcript
exit
}
###############################################
}

############## Source File Lock Status Check  ################
Write-Host "Checking if source file is locked...               " -ForegroundColor Cyan -NoNewline

$FileLocked = Get-FileLockedStatus -FileToCheck $File


############## Source File Clean Up  ################

while ($FileLocked -eq $true){
Write-Host "Waiting 60 seconds to try again...               " -ForegroundColor Cyan
Start-Sleep -Seconds 60
Write-Host "Checking if source file is locked...               " -ForegroundColor Cyan -NoNewline
$FileLocked = Get-FileLockedStatus -FileToCheck $File
}
if ($FileLocked -eq $false){

FileCleanUp

}



$LoopEndDate = Get-Date




}

###########################################################
############## End of the processing loop  ################
###########################################################

Write-Host "Closing down log file...                           " -ForegroundColor Cyan -NoNewline
Write-Host "$265LogOutput" -ForegroundColor Green
Stop-Transcript | Out-Null



$CompleteImage = @"
                                                                                                    
                                       ,,▄▄▄▄▄█▄▄▄▄,                                                
                                   ▄▄██████████████████▄                                            
                                ▄▄███████████████████████▄▄                                         
                             ,█████████████████████████████▄,                                       
                           ╓██████████████████████████████████▄                                     
                          ▐█████████████████████████████████████                                    
                          ██████████▀`    ▀▀▀▀▀▀▀` ▀▀▀█████████████                                   
                          ▐████████                   ╙█████████▌                                   
                            ███████                    ▐████████                                    
                            "██████                    ▐██████▀                                     
                              ████▌  ▄▄              ,▄▄█████▌                                      
                              █▀██▌ █▀▀████▄    ▄▄████▀▀████▌▀▌                                     
                              ▀   ▌  ▀█▐█▌▀▀    ██,██▄█▀  █  ▐`                                      
                               █  T    ,,▄^     █ , ^^'   Γ  ▌                                      
                                ▌            ⌐  █▄        ` ▐                                        
                                ▀▄         ╒    ▐▌▐      ▐ ,▀                                       
                                  ▀▌   ▄▄▄▄██▄▄▄█████▄▄, ██                                         
                                   █ ,██████████████████ █▌                                         
                                    ▌ ▄-`▀█▄,▀▀▀▀▄▐██▐▀,██                                           
                                    ▀▄     ▀▀⌐w⌐▄A▀▌ ` █▐█                                           
                                     █▄      `▀▀▀▀   ╓█▄█▌                                           
          ▄▀▀▄                       █ ▀▄\          ██▄███▄                          ▄▀▀█           
          ▌   █                     ,██  ▀∞▌▄▄,,▄█████▀▀▐██▄▄                       █    ▌          
          █    ▌                 ,▄██████▄, `▀▀▀▀▀▀▀  ,▄██████▀▄                   ▐    █            
           █   ▐              ▄▄▀  ██████████▄     ▄██████████▄ █¥▄                ▌   █`            
       ▄═PN▐▌,, █          ▄▄▀▀▌   ██████████████▀▀███████████▌ ▐   ▀R▄,          █,,⌐4▀ⁿⁿ▀▄        
      ▄-        ▐█  ,▄▄F▀▀ ▀        █████████     ▄███████████▌        ╙▌▀▀▀▄▄▄  █▌      ,  ▌,      
    ▄-   "- ""*∞▀▐▀`      ▀         ▀██████████   ▄████████████           ▄     `▀█▐∞ⁿ"`  `       █     
   ▄▀   ,,      █▐       ▀           ██████████  █████████████  ▐         ▌      ▌█      ,▄  '▀█    
   ▌         "ⁿ▄█j      █,           ▐█████████  ████████████▌  █         ▄^     ▌▀▄▀`-        ▐     
   █∞ "══∞¬▄, /█ ▌       -▀▀▄         ████████    ███████████   ▌      ▄▀▀       ▐ ▐═ ,⌐═══²" "█    
   █▄        █▌ ▀          Æ`   ]     ▐███████     █████████▌  ╨        ¥         ▀ ▐▀        ▄█     
    ▀█▄,"▄▄▄▄* ▌         ▄"     ▐      ██████▌      ▐███████             `▄        ▐ ▀+███Ç,▄██      
    ▐███▄▄▄▄▄▄██        █        ▌      █████        ███████          ,    █       ▄█▄▄▄▄▄▄████     
    █████∞P▀ ,█ ▌  ▄     ▌       ▐⌐     ▐████        ▐█████▌           '  █`   ▄- ▐ █  ▀▀═▀████      
    ▀▀▀▀     ▀  '  '"    ▀`       ▀      ▀▀▀▀         ▀▀▀▀▀               ▀   `"  "  ▀     ▀▀▀▀       
                                                                                                    
▐███████ ███████ ███████ ██▀██   ███████    ███████ ██  ▐██ ███████ ███████ ███████ ███████-███████ 
▐██  ▐██ ██  ▐██ ██  ▐██ ██ ▐█▌  ██  ▐██    ▀██▄▐██ ██  ▐██ ██▌  ██ ██▌  ██ ██▌  ██ ███  ██ ███  ██ 
▐███████ ███▄███ ██▄▄    ██  ██      ▐██     ▐██▄   ██  ▐██ ██▌     ██▌     ███▄▄     ███     ███   
 ▀▀▀▀███ █████▀  ██▀▀    ██  ██▌     ▐██       ██▄  ██  ▐██ ██▌     ██▌     ██▀▀▀      ███     ███  
▐██  ███ ██ ██▄  ██  ▐██ ███████     ▐██    ██ ▐██▄ ██  ▐██ ██▌ ▐██ ██▌  ██ ██▌  ██ ██▌ ███ ██▌ ███ 
▐███████ ██  ██▄ ███████ ██▀▀▐██     ▐██    ███████ ███████ ███████ ███████ ███████ ███████ ███████ 
                                                                                                    
"@

$CompleteMessage = @"

  All files converted, don't forget to delete the old files from the \Processed folder on each of
              your storage drives, plus any empty folders left behind in your library


"@
Write-Host "$CompleteImage" -BackgroundColor Green -ForegroundColor Black
Write-Host "$CompleteMessage" -ForegroundColor Green
Write-Host "" -ForegroundColor White