<#
 .SYNOPSIS
    Run a query on a Oracle database
 .DESCRIPTION
    This script runs a query on Oracle database
    Must be runned after connect to a Oracle server
    The result will be avaiable at $SelectDataTable variable
 .EXAMPLE
    .\Run-OracleQuery.ps1
#>

try {
    ### SQL query command
    $OracleSQLQuery = "SELECT OBTER_LETRA_VERIFACAO_SENHA(PSF.NR_SEQ_FILA_SENHA_ORIGEM) || PSF.CD_SENHA_GERADA ""TURNO""
    , OBTER_DESC_FILA(PSF.NR_SEQ_FILA_SENHA_ORIGEM) ""FILA_TURNO""
    , PSF.DT_GERACAO_SENHA ""EMISION_TURNO""
    , PSF.DT_PRIMEIRA_CHAMADA ""PRIMERA_LLAMADA""
    , PSF.DT_CHAMADA ""ULTIMA_LLAMADA""
    , PSF.QT_CHAMADAS ""CANTIDAD_LLAMADAS""
    , NVL(TRUNC( (SYSDATE - PSF.DT_GERACAO_SENHA) * 1440, 1),0) ""TIEMPO_ESPERA""
    , SYSDATE ""SINCRONIZADO_EN""
FROM PACIENTE_SENHA_FILA PSF
WHERE PSF.DT_GERACAO_SENHA BETWEEN TRUNC(SYSDATE, 'dd') AND FIM_DIA(SYSDATE)
    AND OBTER_LETRA_VERIFACAO_SENHA(PSF.NR_SEQ_FILA_SENHA_ORIGEM) LIKE 'U%'
    AND PSF.DT_VINCULACAO_SENHA IS NULL
    AND PSF.DT_INUTILIZACAO IS NULL"

    ### Create object
    $SelectCommand1 = New-Object System.Data.OracleClient.OracleCommand;
    $SelectCommand1.Connection = $OracleConnection
    $SelectCommand1.CommandText = $OracleSQLQuery
    $SelectCommand1.CommandType = [System.Data.CommandType]::Text

    ### create datatable and load results into datatable ###
    $TriajeDataTable = New-Object System.Data.DataTable
    $TriajeDataTable.Load($SelectCommand1.ExecuteReader())
    $TriajeDataTable
}
catch {
    Write-Error -Message $_.Exception.InnerException.Message -TargetObject $OracleConnection -ErrorAction Stop
}
