    ### Clear data?
    if ($reset){
        Write-Host "Clearing table rows"
        @("Resumen") |% {
            $tableName = $_
            Invoke-PowerBIRestMethod -method Delete -url "groups/$workspaceId/datasets/$datasetId/tables/$tableName/rows"
        }
    }