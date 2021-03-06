function Add-FileToRar
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
  [Parameter(mandatory=$true)] [String] $Zipfile,
  [Parameter(mandatory=$true)] [String] $file,
  [String] $rarparams = '-dh -ep3'
)

begin {
	if ((Get-Command rar.exe -ErrorAction silentlycontinue) -eq $null) 
	{
		throw "Could not find rar.exe"
	}
}

Process {
	Write-Verbose "Adding $file to $Zipfile"
	$rarexp = "Rar.exe a $rarparams $Zipfile $file"
	Write-Verbose $rarexp
	# rar.exe returns the following errors
	#     Code   Description   
	# 
	#      0     Successful operation.
	#      1     Non fatal error(s) occurred.
	#      2     A fatal error occurred.
	#      3     Invalid checksum. Data is damaged.
	#      4     Attempt to modify an archive locked by 'k' command.
	#      5     Write error.
	#      6     File open error.
	#      7     Wrong command line option.
	#      8     Not enough memory.
	#      9     File create error
	#     10     No files matching the specified mask and options were found.
	#     11     Wrong password.
	#    255     User stopped the process.

	$rarcmd = Invoke-Expression $rarexp

	switch ($LASTEXITCODE)
	{
	0 {
			Write-Verbose "Winrar Completed Successfully (User Exit). Output from winrar: $rarcmd" 
		}
	1 {
			throw "Winrar WARNING: Non fatal error(s) occurred. Output from winrar: $rarcmd" 
		}
	2 {
			throw "Winrar FATAL ERROR: A fatal error occurred. Output from winrar: $rarcmd" 
		}
	3 {
			throw "Winrar CRC ERROR: A CRC error occurred when unpacking. Invalid Checksup. Data is damaged. Output from winrar: $rarcmd" 
		}
	4 {
			throw "Winrar LOCKED ARCHIVE: Attempt to modify an archive previously locked by the 'k' command. Output from winrar: $rarcmd" 
		}
	5 {
			throw "Winrar WRITE ERROR: Write to disk error. Output from winrar: $rarcmd" 
		}
	6 {
			throw "Winrar OPEN ERROR: Open file error. Output from winrar: $rarcmd" 
		}
	7 {
			throw "Winrar USER ERROR: Command line option error. Output from winrar: $rarcmd" 
		}
	8 {
			throw "Winrar MEMORY ERROR: Not enough memory for operation. Output from winrar: $rarcmd" 
		}
	9 {
			throw "Winrar CREATE ERROR: Create file error. Confirm the name of the zip file specified is valid. Output from winrar: $rarcmd" 
		}
	10 {
			throw "Winrar NO FILES: No files matching the specified mask or options were found. This could be because files could not be found so check the file names. If using U parameter for rar.exe, there might be no files specified to be updated in rar archive. Output from winrar: $rarcmd" 
		}
	11 {
			throw "Winrar WRONG PASSWORD: Incorrect Password specified. Output from winrar: $rarcmd" 
		}
	255 {
			throw "Winrar USER BREAK: User stopped the process. Output from winrar: $rarcmd" 
		}
	default {
			throw "Winrar Unknown error condition. Output from winrar: $rarcmd" 
		}
	}
	if ($Error)
	{
		throw "Winrar completely unhandled exception occured. The error was: $error. Output from winrar: $rarcmd" 
	}
}

End {

}


}
