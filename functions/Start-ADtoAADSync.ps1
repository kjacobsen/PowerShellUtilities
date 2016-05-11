#requires -Version 2

function Start-ADtoAADSync 
{
    [cmdletbinding()]
    Param (
        # Name of commputer running AAD Connect
        [Parameter(Mandatory = $true)]
        [String]
        $ComputerName,
        
        # Use SSL?
        [Parameter(Mandatory = $false)]
        [Switch]
        $UseSSL,
        
        # Administrator credential to establish ps session
        [Parameter(Mandatory = $false)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message 'Forcing AD to AAD Sync'
    
    $SessionParameters = @{
        ComputerName = $ComputerName
    }

    if ($PSBoundParameters.ContainsKey('Credential'))
    {
        $SessionParameters.Add('Credential', $Credential)
    }
    
    if ($PSBoundParameters.ContainsKey('UseSSL'))
    {
        $SessionParameters.Add('UseSSL', $true)
    }

    try
    {
        $PSSession = New-PSSession @SessionParameters
        $null = Import-PSSession -Session $PSSession -CommandName Start-ADSyncSyncCycle -AllowClobber       
        Start-ADSyncSyncCycle
        Remove-PSSession $PSSession
    }
    catch
    {
        Throw "Error attempting to perform forced directory sync between AD and AAD, $_"
    }
    
    Write-Verbose -Message 'Check the sync server to determine if syncronization is complete'
}
