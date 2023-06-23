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
    $OracleSQLQuery = "SELECT AP.NR_ATENDIMENTO ""ATENCION""
    , PF.NM_PESSOA_FISICA ""PACIENTE""
    , NVL(NVL(OBTER_DESC_TRIAGEM(AP.NR_SEQ_TRIAGEM), OBTER_TRIAGEM_ATENDIMENTO(AP.NR_ATENDIMENTO)),OBTER_DESC_SEM_TRIAGEM(AP.NR_SEQ_TRIAGEM)) ""CLASIFICACION""
    , OBTER_NOME_MEDICO(AP.CD_MEDICO_RESP,'N') ""MEDICO""
    , OBTER_DESC_LOCAL_PA(AP.NR_SEQ_LOCAL_PA) ""LOCAL""
    , TPA.DT_FIM_TRIAGEM ""FIN_TRIAJE""
    , AP.DT_ATEND_MEDICO ""INICIO_CONSULTA""
    , TRUNC((AP.DT_ATEND_MEDICO - TPA.DT_FIM_TRIAGEM) * 1440, 1) ""ESPERA_MEDICO""
    , NVL(TRUNC( (SYSDATE - AP.DT_ATEND_MEDICO) * 1440, 1),0) ""TIEMPO_CONSULTA""
FROM TRIAGEM_PRONTO_ATEND TPA
    INNER JOIN ATENDIMENTO_PACIENTE AP ON AP.NR_ATENDIMENTO = TPA.NR_ATENDIMENTO
    INNER JOIN ATEND_PACIENTE_UNIDADE APU ON APU.NR_ATENDIMENTO = AP.NR_ATENDIMENTO
    INNER JOIN PESSOA_FISICA PF ON PF.CD_PESSOA_FISICA = AP.CD_PESSOA_FISICA
    INNER JOIN SETOR_ATENDIMENTO SA ON SA.CD_SETOR_ATENDIMENTO = APU.CD_SETOR_ATENDIMENTO
    LEFT JOIN ATEND_CATEGORIA_CONVENIO ACC ON ACC.NR_ATENDIMENTO = AP.NR_ATENDIMENTO
WHERE TPA.DT_INICIO_TRIAGEM BETWEEN TRUNC(SYSDATE, 'dd') AND FIM_DIA(SYSDATE)
    AND APU.NR_SEQ_INTERNO = OBTER_ATEPACU_PACIENTE(AP.NR_ATENDIMENTO,'A')
    AND AP.IE_TIPO_ATENDIMENTO = 3
    AND AP.CD_PESSOA_FISICA NOT IN (SELECT PC.CD_PESSOA_FISICA FROM PESSOA_CLASSIF PC WHERE PC.NR_SEQ_CLASSIF = 3) -- PACIENTES PRUEBA
    AND TPA.IE_STATUS_PACIENTE <> 'P'
    AND NOT AP.DT_ATEND_MEDICO IS NULL
    AND AP.DT_FIM_CONSULTA IS NULL"

    ### Create object
    $SelectCommand1 = New-Object System.Data.OracleClient.OracleCommand;
    $SelectCommand1.Connection = $OracleConnection
    $SelectCommand1.CommandText = $OracleSQLQuery
    $SelectCommand1.CommandType = [System.Data.CommandType]::Text

    ### create datatable and load results into datatable ###
    $ConsultaDataTable = New-Object System.Data.DataTable
    $ConsultaDataTable.Load($SelectCommand1.ExecuteReader())
    $ConsultaDataTable
}
catch {
    Write-Error -Message $_.Exception.InnerException.Message -TargetObject $OracleConnection -ErrorAction Stop
}
