<#
 .SYNOPSIS
    Connect to Oracle server
 .DESCRIPTION
    This script connects to Oracle server, from credentials stored in a file
    Must be runned at beginning of all scripts that manipulates Oracle databases
 .EXAMPLE
    .\Connect-Oracle.ps1
#>

### Read Oracle configurations file
$ConfigsFilePath = "$PSScriptRoot\ora-configs.json"

If (-Not (Test-Path $ConfigsFilePath)) {
    Write-Error -Message "$PSScriptRoot\ora-configs.json not found! Exiting..." -ErrorAction Stop
    Exit 1
}

$OraConfig = Get-Content -Path $ConfigsFilePath | ConvertFrom-Json

### Read credentials
$CredentialsFilePath = "$PSScriptRoot\ora-credentials.xml"

If (-Not (Test-Path $CredentialsFilePath)) {
    # Ask for credentials to Oracle database and save hash, if it doesn't exists
    $Credentials = Get-Credential
    $Credentials | Export-Clixml -Path $CredentialsFilePath
}
$CredentialsFile = Import-Clixml -Path $CredentialsFilePath

### Requires Oracle Instant Client for Windows 64-bit
# https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html

### Try to load assembly, fail otherwise
$Assembly = [System.Reflection.Assembly]::LoadWithPartialName("System.Data.OracleClient")

if ( $Assembly ) {
    Write-Host "System.Data.OracleClient Loaded!"
} else {
    Write-Error -Message "System.Data.OracleClient could not be loaded. Install Oracle Instant Client for Windows 64-bit! Exiting..." -ErrorAction Stop
    Exit 1
}

### Connection string
$password = (New-Object PSCredential 0, $CredentialsFile.Password).GetNetworkCredential().Password
$OracleConnectionString = "SERVER=(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$($OraConfig.HOST))(PORT=$($OraConfig.PORT)))(CONNECT_DATA=(SERVICE_NAME=$($OraConfig.SERVICE_NAME))));uid=$($CredentialsFile.UserName);pwd=$($password);"

### Open up oracle connection to database
$OracleConnection = New-Object System.Data.OracleClient.OracleConnection($OracleConnectionString);
try {
    $OracleConnection.Open()
    $OracleConnection
}
catch {
    Write-Error -Message $_.Exception.InnerException.Message -TargetObject $OracleConnection -ErrorAction Stop
}