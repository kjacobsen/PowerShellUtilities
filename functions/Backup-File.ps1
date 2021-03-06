function Backup-File
{
<#
.SYNOPSIS

.DESCRIPTION

.PARAMETER 

.INPUTS

.EXAMPLE

.EXAMPLE

.OUTPUTS

.NOTES
NAME: 
AUTHOR: 
LASTEDIT: 
KEYWORDS:

#>
[CMDLetBinding()]
param
(
  [Parameter(mandatory=$true, valuefrompipeline=$true)] [string] $file,
  [Switch] $DailyArchives,
  [string] $BackupFolderName = "backup"
)

Process 
{
	$filename = Split-Path $file -Leaf
	$foldername = Split-Path $file
		
	$timestampedfile = $filename + "." + (get-date).tostring("yyyyMMddHHmmss") 
	
	$BackupLocation = Join-Path $foldername $BackupFolderName
	
	if ($DailyArchives)
 	{
 		$date = (get-date).tostring("yyyyMMdd")
 		$BackupLocation = Join-Path $BackupLocation $date
 	}
	
	
	$backupfilename = Join-Path $BackupLocation $timestampedfile

	Write-Verbose "copying $file to $backupfilename"

	try {
		move $file $backupfilename -erroraction stop
	} catch {
		throw $_
	}

}


}
