    ### Send resumen data
    Write-Host "Writing resumen data"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $resumenInfo = @{
        "$Aguardando_Triaje" = [Int64] $SelectDataTable.AG_TRIAJE ?? 0;
        # $Aguardando_Triaje_Minutos = [Double] $SelectDataTable.AG_TRIAJE_MIN ?? 0;
        # $En_Consulta = [Int64] $SelectDataTable.EN_CONS ?? 0;
        # $En_Consulta_Minutos = [Double] $SelectDataTable.EN_CONS_MIN ?? 0;
        # $Azul = [Int64] $SelectDataTable.AZUL ?? 0;
        # $Azul_Minutos = [Double] $SelectDataTable.AZUL_MIN ?? 0;
        # $Verde = [Int64] $SelectDataTable.VERDE ?? 0;
        # $Verde_Minutos = [Double] $SelectDataTable.VERDE_MIN ?? 0;
        # $Amarillo = [Int64] $SelectDataTable.AMARILLO ?? 0;
        # $Amarillo_Minutos = [Double] $SelectDataTable.AMARILLO_MIN ?? 0;
        # $Naranja = [Int64] $SelectDataTable.NARANJA ?? 0;
        # $Naranja_Minutos = [Double] $SelectDataTable.NARANJA_MIN ?? 0;
        # $Rojo = [Int64] $SelectDataTable.ROJO ?? 0;
        # $Rojo_Minutos = [Double] $SelectDataTable.ROJOMIN ?? 0;
        #SincronizadoEn = $timestamp
        }

    $bodyStr = @{data = @($resumenInfo)} | ConvertTo-Json

    $Headers = @{
        'Authorization' =  "Bearer hjww07zcqvsogawnesz9:"
     }

    Invoke-WebRequest -Method POST -Uri "https://push.databox.com" -Headers $Headers -Body $bodyStr -ContentType "application/json" | Out-Null
