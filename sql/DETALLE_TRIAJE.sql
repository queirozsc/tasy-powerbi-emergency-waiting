SELECT OBTER_LETRA_VERIFACAO_SENHA(PSF.NR_SEQ_FILA_SENHA_ORIGEM) || PSF.CD_SENHA_GERADA TURNO
    , OBTER_DESC_FILA(PSF.NR_SEQ_FILA_SENHA_ORIGEM) FILA_TURNO
    , PSF.DT_GERACAO_SENHA EMISION_TURNO
    , PSF.DT_PRIMEIRA_CHAMADA PRIMERA_LLAMADA
    , PSF.DT_CHAMADA ULTIMA_LLAMADA
    , PSF.QT_CHAMADAS CANTIDAD_LLAMADAS
    , NVL(TRUNC( (SYSDATE - PSF.DT_GERACAO_SENHA) * 1440, 1),0) TIEMPO_ESPERA
    , SYSDATE SINCRONIZADO_EN
FROM PACIENTE_SENHA_FILA PSF
WHERE PSF.DT_GERACAO_SENHA BETWEEN TRUNC(SYSDATE, 'dd') AND FIM_DIA(SYSDATE)
    AND OBTER_LETRA_VERIFACAO_SENHA(PSF.NR_SEQ_FILA_SENHA_ORIGEM) LIKE 'U%'
    AND PSF.DT_VINCULACAO_SENHA IS NULL
    AND PSF.DT_INUTILIZACAO IS NULL