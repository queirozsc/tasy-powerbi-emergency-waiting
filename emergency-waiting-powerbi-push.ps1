while ($true) {
    . ./Connect-Oracle.ps1
    . ./Run-OracleQuery.ps1
    . ./Connect-PowerBI.ps1

    . ./Create-PBIPushDataset.ps1
    . ./Send-PBIDataset.ps1

    Start-Sleep -Seconds 60
}

