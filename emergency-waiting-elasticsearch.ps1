
while ($true) {
    . ./Connect-Oracle.ps1
    . ./Run-OracleQuery.ps1
    . ./Run-OracleQueryTriaje.ps1
    . ./Run-OracleQueryConsulta.ps1

    . ./Send-ESDoc.ps1
    . ./Send-ESDocTriaje.ps1
    . ./Send-ESDocConsulta.ps1

    Start-Sleep -Seconds 60
}
