function Wait-ADReplication 
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCredential]
        $Credential,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]
        $Timeout
    )

    $StartTime = Get-Date
    $ExpiryTime = $StartTime.AddMinutes($Timeout)

    $ReplicationPartnerData = Get-ADReplicationPartnerMetadata -Target * -Credential $Credential

    $Total = $ReplicationPartnerData.length
    
    do 
    {
        $Now = Get-Date
        
        $NumberReplicated = @(Get-ADReplicationPartnerMetadata -Target * -Credential $Credential -filter {LastReplicationSuccess -gt $StartTime}).length

        if ($NumberReplicated -lt $Total)
        {
            $Percent = 100 * $NumberReplicated/$Total
            $TimeRemaining = $ExpiryTime.Subtract($Now).TotalSeconds
            Write-Verbose -Message "[$Percent] [$TimeRemaining] $NumberReplicated of $Total have replicated"
            Write-Progress -id 173 -Activity 'Waiting for AD Replication' -Status Waiting -PercentComplete $Percent -SecondsRemaining $TimeRemaining
        }
    }
    while (($ExpiryTime -gt $Now) -and ($NumberReplicated -lt $Total))

    Write-Progress -id 173 -Activity 'Waiting for AD Replication' -Status Waiting -Completed 

    Write-Verbose -Message "$NumberReplicated of $Total have replicated"

    if ($NumberReplicated -lt $Total)
    {
        Throw "Not all domain controllers and zones have replicated. $NumberReplicated of $Total have replicated"
    }
       
}