function Invoke-PCommand
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
  [Parameter(mandatory=$true)] [String] $executable,
  [Object[]] $parameters
)


#initialise start-process parameters
$psi = New-Object System.Diagnostics.ProcessStartInfo 
$psi.CreateNoWindow = $true 
$psi.UseShellExecute = $false 
$psi.RedirectStandardOutput = $true 
$psi.RedirectStandardError = $true 
$process = New-Object System.Diagnostics.Process 
$process.StartInfo = $psi 

#clear error array
$error.clear()

Write-Verbose "[Invoke-PCommand] Command to be run $executable $parameters"

$psi.FileName = $executable
$psi.Arguments = $parameters
[void]$process.Start()
$process.WaitForExit()

#if there are powershell errors or errors in start-process
if ( ($process.ExitCode -gt 0) -or ($error.count -gt 0))
{
	#get standard out and errors
	$PSErrors = echo $error | out-string  
	$CMDoutput = echo $process.StandardOutput.ReadToEnd() | Out-String  
	$CMDerror = echo $process.StandardError.ReadToEnd() | out-string 
	$errorcount = echo $error.count
	$errorcode = echo $process.ExitCode

	throw "Error occured running the command:`n$executable`n----------`nWith arguments`n$parameters`n----------`nError code: $errorcode.`n----------`nStandard Out: $CMDoutput`n----------`nStandard Error:$CMDerror`n----------`nPowerShell Error output: $PSErrors"
 }
 else
 {
    $CMDoutput = echo $process.StandardOutput.ReadToEnd() | Out-String
    Write-Verbose "[Invoke-PCommand] Standard Out`n$CMDoutput"
    $CMDerror = echo $process.StandardError.ReadToEnd() | out-string 
    Write-Verbose "[Invoke-PCommand] Standard Error`n$CMDerror"
 }
 

}