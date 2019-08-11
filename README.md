# 265
Convert your Plex library video content to HEVC (can be used without Plex)

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
    
    Place script files and xml files into C:\Program Files\Handbrake\

    Add C:\Program Files\Handbrake\ to your system PATH env variable to be able to run from anywhere
    Command Prompt: SET PATH=%PATH%;"C:\Program Files\Handbrake\"
    
    Place the included JSON file into the HandBrake folder (C:\Program Files\Handbrake)

    Extract HandbrakeCLI into the Handbrake folder (C:\Program Files\Handbrake\)
        Downloadable from:      https://handbrake.fr/downloads2.php

    Place the Handle executables into C:\Program Files\Handle\
        Downloadable from:      https://docs.microsoft.com/en-us/sysinternals/downloads/handle

    Place MediaInfoCLI executable into C:\Program Files\MediaInfo_CLI_19.07_Windows_x64\
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

