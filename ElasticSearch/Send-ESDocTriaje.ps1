### Read ElasticSearch configurations file
$ConfigsFilePath = "$PSScriptRoot\es-configs.json"

If (-Not (Test-Path $ConfigsFilePath)) {
    Write-Error -Message "$PSScriptRoot\es-configs.json not found! Exiting..." -ErrorAction Stop
    Exit 1
}

$ESConfig = Get-Content -Path $ConfigsFilePath | ConvertFrom-Json

### Read credentials
$CredentialsFilePath = "$PSScriptRoot\es-credentials.xml"

If (-Not (Test-Path $CredentialsFilePath)) {
    # Ask for credentials to Oracle database and save hash, if it doesn't exists
    $Credentials = Get-Credential
    $Credentials | Export-Clixml -Path $CredentialsFilePath
}
$CredentialsFile = Import-Clixml -Path $CredentialsFilePath

### Send resumen data
Write-Host "Writing triaje data"

$TurnosTriaje = [System.Collections.ArrayList]::new();

foreach ($Row in $TriajeDataTable.Rows)
{ 
    $turno = @{
        turno = $Row.TURNO;
        #fila_turno = $Row.FILA_TURNO;
        emision_turno = [DateTime] $Row.EMISION_TURNO;
        primera_llamada = [DateTime] $Row.PRIMERA_LLAMADA;
        ultima_llamada = [DateTime] $Row.ULTIMA_LLAMADA;
        cantidad_llamadas = [Int64] $Row.CANTIDAD_LLAMADAS;
        tiempo_espera = [Double] $Row.TIEMPO_ESPERA;
    }
    $null = $TurnosTriaje.Add($turno)
}

$triajeInfo = @{turnos = $TurnosTriaje; timestamp = Get-Date}
$bodyStr = @($triajeInfo) | ConvertTo-Json -Compress | % { [System.Text.RegularExpressions.Regex]::Unescape($_) }

$password = (New-Object PSCredential 0, $CredentialsFile.Password).GetNetworkCredential().Password
[string]$sStringToEncode="$($CredentialsFile.UserName):$($password)"
$sEncodedString=[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($sStringToEncode))

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Basic $($sEncodedString)")

$response = Invoke-RestMethod "https://$($ESConfig.HOST):$($ESConfig.PORT)/emergencia_triaje/_doc" -Method 'POST' -Headers $headers -Body $bodyStr -ContentType "application/json" -SkipCertificateCheck