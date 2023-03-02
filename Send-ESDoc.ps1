#Install-Module -Name Elastic.Console -AllowPrerelease

### Read credentials
$CredentialsFilePath = "$PSScriptRoot\es-credentials.xml"

If (-Not (Test-Path $CredentialsFilePath)) {
    # Ask for credentials to Oracle database and save hash, if it doesn't exists
    $Credentials = Get-Credential
    $Credentials | Export-Clixml -Path $CredentialsFilePath
}
$CredentialsFile = Import-Clixml -Path $CredentialsFilePath

### Send resumen data
Write-Host "Writing resumen data"

$resumenInfo = @{
    aguardando_triaje = [Int64] $SelectDataTable.AG_TRIAJE;
    aguardando_triaje_minutos = [Double] $SelectDataTable.AG_TRIAJE_MIN;
    en_consulta = [Int64] $SelectDataTable.EN_CONS;
    en_consulta_minutos = [Double] $SelectDataTable.EN_CONS_MIN;
    azul = [Int64] $SelectDataTable.AZUL;
    azul_minutos = [Double] $SelectDataTable.AZUL_MIN;
    verde = [Int64] $SelectDataTable.VERDE;
    verde_minutos = [Double] $SelectDataTable.VERDE_MIN;
    amarillo = [Int64] $SelectDataTable.AMARILLO;
    amarillo_minutos = [Double] $SelectDataTable.AMARILLO_MIN;
    naranja = [Int64] $SelectDataTable.NARANJA;
    naranja_minutos = [Double] $SelectDataTable.NARANJA_MIN;
    rojo = [Int64] $SelectDataTable.ROJO;
    rojo_minutos = [Double] $SelectDataTable.ROJOMIN;
    timestamp = Get-Date
}

$bodyStr = @($resumenInfo) | ConvertTo-Json -Compress

$password = (New-Object PSCredential 0, $CredentialsFile.Password).GetNetworkCredential().Password
[string]$sStringToEncode="$($CredentialsFile.UserName):$($password)"
$sEncodedString=[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($sStringToEncode))

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Basic $($sEncodedString)")

$response = Invoke-RestMethod 'https://localhost:9200/resumen/_doc' -Method 'POST' -Headers $headers -Body $bodyStr -ContentType "application/json" -SkipCertificateCheck