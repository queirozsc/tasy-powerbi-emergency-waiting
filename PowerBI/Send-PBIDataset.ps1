    ### Send resumen data
    Write-Host "Writing resumen data"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $resumenInfo = @{
        AguardandoTriaje = [Int64] $SelectDataTable.AG_TRIAJE;
        AguardandoTriajeMinutos = [Double] $SelectDataTable.AG_TRIAJE_MIN;
        EnConsulta = [Int64] $SelectDataTable.EN_CONS;
        EnConsultaMinutos = [Double] $SelectDataTable.EN_CONS_MIN;
        Azul = [Int64] $SelectDataTable.AZUL;
        AzulMinutos = [Double] $SelectDataTable.AZUL_MIN;
        Verde = [Int64] $SelectDataTable.VERDE;
        VerdeMinutos = [Double] $SelectDataTable.VERDE_MIN;
        Amarillo = [Int64] $SelectDataTable.AMARILLO;
        AmarilloMinutos = [Double] $SelectDataTable.AMARILLO_MIN;
        Naranja = [Int64] $SelectDataTable.NARANJA;
        NaranjaMinutos = [Double] $SelectDataTable.NARANJA_MIN;
        Rojo = [Int64] $SelectDataTable.ROJO;
        RojoMinutos = [Double] $SelectDataTable.ROJOMIN;
        SincronizadoEn = $timestamp
        }

    $bodyStr = @{rows = @($resumenInfo)} | ConvertTo-Json

    Invoke-PowerBIRestMethod -method Post -url "groups/$workspaceId/datasets/$datasetId/tables/Resumen/rows" -body $bodyStr | Out-Null
