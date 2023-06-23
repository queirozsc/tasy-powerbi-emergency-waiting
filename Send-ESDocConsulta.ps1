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
Write-Host "Writing en consulta data"

$pacientesConsulta = [System.Collections.ArrayList]::new();

foreach ($Row in $ConsultaDataTable.Rows)
{ 
    $paciente = @{
        atencion = $Row.ATENCION;
        paciente = $Row.PACIENTE;
        clasificacion = $Row.CLASIFICACION;
        medico = $Row.MEDICO;
        #local = $Row.LOCAL; -- Generating error of special characters
        fin_triaje = [DateTime] $Row.FIN_TRIAJE;
        inicio_consulta = [DateTime] $Row.INICIO_CONSULTA;
        espera_medico = [Double] $Row.ESPERA_MEDICO;
        tiempo_consulta = [Double] $Row.TIEMPO_CONSULTA;
    }
    $null = $pacientesConsulta.Add($paciente)
}

$consultaInfo = @{pacientes = $pacientesConsulta; timestamp = Get-Date}
$bodyStr = @($consultaInfo) | ConvertTo-Json -Compress | % { [System.Text.RegularExpressions.Regex]::Unescape($_) }

$password = (New-Object PSCredential 0, $CredentialsFile.Password).GetNetworkCredential().Password
[string]$sStringToEncode="$($CredentialsFile.UserName):$($password)"
$sEncodedString=[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($sStringToEncode))

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", "Basic $($sEncodedString)")

$response = Invoke-RestMethod "https://$($ESConfig.HOST):$($ESConfig.PORT)/emergencia_consulta/_doc" -Method 'POST' -Headers $headers -Body $bodyStr -ContentType "application/json" -SkipCertificateCheck