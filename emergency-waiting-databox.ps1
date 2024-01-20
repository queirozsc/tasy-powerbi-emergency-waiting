
while ($true) {
    . ./Oracle/Connect-Oracle.ps1
    . ./Oracle/Run-OracleQuery.ps1

    . ./Databox/Send-DataDBoxMetrics.ps1

    Start-Sleep -Seconds 60
}
