while ($true) {
    . ./Oracle/Connect-Oracle.ps1
    . ./Oracle/Run-OracleQuery.ps1
    . ./PowerBI/Connect-PowerBI.ps1

    . ./PowerBI/Create-PBIPushDataset.ps1
    . ./PowerBI/Send-PBIDataset.ps1

    Start-Sleep -Seconds 60
}

