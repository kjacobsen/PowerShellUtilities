function update-timestamp {
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

.LINK http://ss64.com/ps/syntax-touch.html
Inspiration taken from http://ss64.com/ps/syntax-touch.html

#>
[CMDLetBinding()]
param (
	[Parameter(mandatory=$true, valuefrompipeline=$true)] [string] $Path,
	[switch] $AccessTime,
	[switch] $WriteTime,
	[switch] $CreationTime,
	[switch] $NoCreate,
	[datetime] $Date
)

process {
	#Test if it exists
	if (Test-Path $Path) {
		if ($Path -is [System.IO.FileSystemInfo]) {
			$FileSystemInfoObjects = $Path
		} else {
			$FileSystemInfoObjects = $Path | Resolve-Path -erroraction SilentlyContinue | Get-Item
		}
		foreach ($fsInfo in $FileSystemInfoObjects) {		
				
				if (($Date -eq $null) -or ($Date -eq "")) { $Date = Get-Date }
				
				if ($AccessTime) 	{ $fsInfo.LastAccessTime = $Date 	}
				if ($WriteTime) 	{ $fsInfo.LastWriteTime = $Date 	}
				if ($CreationTime) 	{ $fsInfo.CreationTime = $Date 		}
				
				if (($AccessTime -and $ModificationTime -and $CreationTime) -eq $false) {
					$fsInfo.CreationTime = $Date
					$fsInfo.LastWriteTime = $Date
					$fsInfo.LastAccessTime = $Date
				}	
		}
	} elseif (-not $NoCreate) {
		#make a new file
		Set-Content -Path $Path -Value $null
		$fsInfo = $Path | Resolve-Path -erroraction SilentlyContinue | Get-Item
		if (($Date -ne $null) -and ($Date -ne "")) {
			$fsInfo.CreationTime = $Date
			$fsInfo.LastWriteTime = $Date
			$fsInfo.LastAccessTime = $Date
		}
	}
}

}
