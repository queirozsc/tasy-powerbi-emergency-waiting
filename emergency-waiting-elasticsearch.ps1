
while ($true) {
    . ./Connect-Oracle.ps1
    . ./Run-OracleQuery.ps1

    . ./Send-ESDoc.ps1

    Start-Sleep -Seconds 60
}
