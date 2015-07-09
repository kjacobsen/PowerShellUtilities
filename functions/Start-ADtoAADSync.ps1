#requires -Version 2
function Start-ADtoAADSync 
{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SyncServer,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCredential]
        $Credential
    )

    try
    {
        Write-Verbose -Message 'Forcing AD to AAD Sync'
        $PSSession = New-PSSession -ComputerName $SyncServer -Credential $Credential
        $SyncScript = {Add-PSSnapin -Name Coexistence-Configuration}
        Invoke-Command -Session $PSSession -ScriptBlock $SyncScript
        $null = Import-PSSession -Session $PSSession -CommandName Start-OnlineCoexistenceSync -AllowClobber
        Start-OnlineCoexistenceSync
        Write-Verbose -Message 'Check the sync server to determine if syncronization is complete'
        Remove-PSSession $PSSession
    }
    catch
    {
        Throw "Error attempting to perform forced directory sync between AD and AAD, $_"
    }
}
