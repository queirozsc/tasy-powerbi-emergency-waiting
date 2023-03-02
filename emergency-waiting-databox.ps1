
while ($true) {
    . ./Connect-Oracle.ps1
    . ./Run-OracleQuery.ps1

    . ./Send-DataDBoxMetrics.ps1

    Start-Sleep -Seconds 60
}
