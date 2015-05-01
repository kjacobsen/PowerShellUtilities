function New-GeneratedPassword
{ 
    [CMDLetBinding()]
    Param
    (
        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $Length = 12,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Int]
        $MinNumberOfNonAlphanumericCharacters = 0,

        [Parameter(Mandatory = $false)]
        [Switch]
        $PasswordAsSecureString
    )

    $null = [Reflection.Assembly]::LoadWithPartialName('System.Web') 
    
    $PasswordPlain = ([System.Web.Security.Membership]::GeneratePassword($Length,$numberOfNonAlphanumericCharacters))

    if ($PasswordAsSecureString)
    { ConvertTo-SecureString  -String $PasswordPlain -AsPlainText -Force }
    else
    { $PasswordPlain }
}