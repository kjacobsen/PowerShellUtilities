function wait-ADReplication 
{
    [cmdletbinding()]
    $StartTime = Get-Date
    $ExpiryTime = $StartTime.AddMinutes($Timeout)

    $Total = (Get-ADReplicationUpToDatenessVectorTable -Target * -Credential $DomainAdminCredentials | Where-Object  -FilterScript {
            $_.partner -ne $null
        }
    ).length


    do 
    {
        $Now = Get-Date
        $NumberReplicated = @((Get-ADReplicationUpToDatenessVectorTable -Target * -Credential $DomainAdminCredentials | Where-Object  -FilterScript {
                    ($_.partner -ne $null) -and ($_.LastReplicationSuccess -gt $StartTime)
                }
        )).length


        if ($NumberReplicated -lt $Total)
        {
            Write-Verbose -Message "$NumberReplicated of $Total have replicated"
            Write-Progress -Activity 'Waiting for AD Replication' -Status Waiting -PercentComplete (100 * $NumberReplicated/$Total) -SecondsRemaining ($ExpiryTime.Subtract($Now).TotalSeconds)
            Start-Sleep -Seconds 5
        }
    }
    while (($ExpiryTime -gt $Now) -and ($NumberReplicated -lt $Total))

    Write-Verbose -Message "$NumberReplicated of $Total have replicated"

    if ($NumberReplicated -lt $Total)
    {
        Write-Error -Message "Not all domain controllers and zones have replicated. $NumberReplicated of $Total have replicated"
    }

    Write-Progress -Activity 'Waiting for AD Replication' -Status Waiting -Completed
}