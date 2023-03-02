<#
 .SYNOPSIS
    Connect to Power BI Service
 .DESCRIPTION
   This script connects to Power BI Service, from credentials stored in a file
   Must be run at beginning of all scripts that manipulates Power BI Service
   Requires Power BI Powershell module
   Install-Module -Name MicrosoftPowerBIMgmt -RequiredVersion 1.2.0
 .EXAMPLE
    .\Connect-PowerBI.ps1
#>

$CredentialsFilePath = "$PSScriptRoot\pbi-credentials.xml"

If (-Not (Test-Path $CredentialsFilePath)) {
    # Ask for credentials of Power BI Service and save hash, if it doesn't exists
    $Credentials = Get-Credential
    $Credentials | Export-Clixml -Path $CredentialsFilePath
}

### Read the credentials from file
$CredentialsFile = Import-Clixml -Path $CredentialsFilePath

Connect-PowerBIServiceAccount -Credential $CredentialsFile