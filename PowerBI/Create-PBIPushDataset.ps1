$workspaceId = "b956b2c9-93ba-4fd0-bb23-ea7add951afb" # Urgencias
$datasetName = "Urgencias Push"

### Dataset Schema
$dataSetSchema = @{name = $datasetName;
    defaultMode = "Push";
    tables = @(
        @{ name = "Resumen";
            columns = @(
                @{ name = "AguardandoTriaje"; dataType = "Int64" },
                @{ name = "AguardandoTriajeMinutos"; dataType = "Double" },
                @{ name = "EnConsulta"; dataType = "Int64" },
                @{ name = "EnConsultaMinutos"; dataType = "Double" },
                @{ name = "Azul"; dataType = "Int64" },
                @{ name = "AzulMinutos"; dataType = "Double" },
                @{ name = "Verde"; dataType = "Int64" },
                @{ name = "VerdeMinutos"; dataType = "Double" },
                @{ name = "Amarillo"; dataType = "Int64" },
                @{ name = "AmarilloMinutos"; dataType = "Double" },
                @{ name = "Naranja"; dataType = "Int64" },
                @{ name = "NaranjaMinutos"; dataType = "Double" },
                @{ name = "Rojo"; dataType = "Int64" },
                @{ name = "RojoMinutos"; dataType = "Double" },
                @{ name = "SincronizadoEn"; dataType = "DateTime"  }
            )
        }
    )
}

### Create, if doesn't exist
$dataset = Get-PowerBIDataset -WorkspaceId $workspaceId |? Name -eq $datasetName

if (!$dataset) {
    Write-Host "Creating dataset"
    $bodyStr = $dataSetSchema | ConvertTo-Json -Depth 5
    $result = Invoke-PowerBIRestMethod -method Post -url "groups/$workspaceId/datasets?defaultRetentionPolicy=basicFIFO" -body $bodyStr

    $dataset = $result | ConvertFrom-Json
    Write-Verbose "DataSet created with id: '$($result.id)"
}else{
    Write-Host "Dataset already created"
}

$datasetId = $dataset.Id