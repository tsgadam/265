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

