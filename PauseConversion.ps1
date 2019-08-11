<#

.SYNOPSIS   
         
     This script amends the pause status of the 265 HandBrake convertion script.

.DESCRIPTION

    When the pause status is set to 'y' it will hold the Handbrake Conversion script after the current conversion is processed.

    When the pause status is set to 'n' the HandBrake Conversion script will run uninterupted.


############### IMPORTANT ################

If the Handbrake Conversion script file name is changed, the $XMLFile variable will need to be updated. 



############### REQUIREMENTS ##############

This script must be placed in the same folder as the Handbrake Conversion script.


#>

############### Get the folder path of this script ###############
$ScriptName = Split-Path $PSCommandPath -Leaf
$XMLFile = $PSScriptRoot+'\265.ps1.xml'

[xml]$xml = ((Get-Content $XMLFile))

$CurrentPauseStatus = $xml.root.conversionpaused


$UserResponse = $null 

Write-Host "Do you want to pause after the next conversion? [y/n]" -ForegroundColor Red
$UserResponse = Read-Host 



while (($UserResponse -ne 'y') -or ($UserResponse -ne 'n'))
{
    if ($UserResponse -eq 'y') 
         {
         $xml.root.conversionpaused = "y"
         Write-Host "Setting paused status to Yes...`n" -ForegroundColor Cyan
         break
         }
    if ($UserResponse -eq 'n')
     {
     $xml.root.conversionpaused = "n"
     Write-Host "Setting paused status to No...`n" -ForegroundColor Cyan
     break
  }

    Write-Host "Do you want to pause after the next conversion? [y/n]`n" -ForegroundColor Red 
    $UserResponse = Read-Host 
}




Write-Host "Saving configuration file $XMLFile...`n" -ForegroundColor Cyan
$xml.Save($XMLFile)

[xml]$xml = ((Get-Content $XMLFile))
$CurrentPauseStatus = $xml.root.conversionpaused

if (($CurrentPauseStatus -eq $UserResponse) -and ($UserResponse -eq 'n'))
{Write-Host "Conversion processed unpaused, processing will continue`n" -ForegroundColor Green}

if (($CurrentPauseStatus -eq $UserResponse) -and ($UserResponse -eq 'y'))
{Write-Host "WARNING: Conversion processed paused, processing will wait until unpaused`n" -ForegroundColor Yellow}



if ($CurrentPauseStatus -ne $UserResponse)
{Write-Host "GREAT SUCCESS`n" -ForegroundColor Red}