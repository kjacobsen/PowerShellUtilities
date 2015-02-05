#http://www.ehloworld.com/878
function Start-GuidedSleep 
{
    [cmdletbinding()]
    param(
        [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Mandatory = $true, HelpMessage = 'No time specified')]
        [int]$s
    )
    for ($i = 1; $i -lt $s; $i++) 
    {
        [int]$TimeLeft = $s-$i
        Write-Progress -Activity "Waiting $s seconds..." -PercentComplete (100/$s*$i) -CurrentOperation "$TimeLeft seconds left ($i elapsed)" -Status 'Please wait'
        Start-Sleep -Seconds 1
    }
    Write-Progress -Completed -Activity $true -Status 'Please wait'
}