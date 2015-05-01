#
# Export the module members - KUDOS to the chocolatey project for this efficent code
#


#get the path of where the module is saved (if module is at c:\myscripts\module.psm1, then c:\myscripts\)
$mypath = (Split-Path -parent $MyInvocation.MyCommand.Definition)

#find all the ps1 files in the subfolder functions
Resolve-Path $mypath\functions\*.ps1 | % { . $_.ProviderPath }

#export as module members the functions we specify
Export-ModuleMember -Function Invoke-PCommand, Backup-File, Add-FileToRar, update-timestamp, Get-GUID,wait-ADReplication, Start-GuidedSleep, New-GeneratedPassword

#
# Define any alias and export them - Kieran Jacobsen
#
