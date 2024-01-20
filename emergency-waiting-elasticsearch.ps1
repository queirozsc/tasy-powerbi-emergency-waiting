
while ($true) {
    . ./Oracle/Connect-Oracle.ps1
    . ./Oracle/Run-OracleQuery.ps1
    . ./Oracle/Run-OracleQueryTriaje.ps1
    . ./Oracle/Run-OracleQueryConsulta.ps1

    . ./ElasticSearch/Send-ESDoc.ps1
    . ./ElasticSearch/Send-ESDocTriaje.ps1
    . ./ElasticSearch/Send-ESDocConsulta.ps1

    Start-Sleep -Seconds 60
}
