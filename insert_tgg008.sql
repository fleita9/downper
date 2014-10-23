INSERT INTO TGG008_DOWN
     SELECT *
       FROM (SELECT CASE
                       WHEN FOLIO IS NOT NULL THEN TO_NUMBER (FOLIO)
                       WHEN FOLIO IS NULL THEN TH.ID
                    END
                       FOLIO,
                    TO_NUMBER (A.OLDID) AS CD_ENTIDAD,
                    --(A.OLDID) as CD_ENTIDAD,
                    CAST (REGEXP_REPLACE (N.KEYCODE, '[^0-9]+', '') AS NUMBER)
                       CD_NIVEL1,
                    0 AS CD_NIVEL2,
                    TO_NUMBER (APC.KEYCODE) AS TP_SERVICIO,
                    CASE
                       WHEN PD.DISCRIMINATOR = 'CIE'
                       THEN
                          '2'
                       WHEN PD.DISCRIMINATOR = 'CLABE'
                       THEN
                          '3'
                       WHEN PD.DISCRIMINATOR = 'SUC'
                       THEN
                          '4'
                       WHEN PD.DISCRIMINATOR = 'AMEX'
                       THEN
                          CASE
                             WHEN P.KEYCODE LIKE ('%MSI%') THEN '24' --Meses sin intereses
                             ELSE '0'
                          END
                       WHEN PD.DISCRIMINATOR = 'CIEINTER'
                       THEN
                          '25'
                       WHEN PD.DISCRIMINATOR = 'TDX'
                       THEN
                          CASE
                             WHEN TT.KEYCODE = 'PAGO'
                             THEN
                                CASE
                                   WHEN P.KEYCODE = 'PB' THEN '11'
                                   WHEN P.KEYCODE LIKE ('%SPMSI%') THEN '13' --Skip and Payment
                                   WHEN P.KEYCODE LIKE ('%SPMCI%') THEN '14' --Skip and Payment
                                   WHEN P.KEYCODE LIKE ('%SP%') THEN '12' --Skip and Payment
                                   WHEN P.BANKPROMOTION = 1 THEN '7' --Financiamiento Bancomer
                                   WHEN P.BANKPROMOTION = 2 THEN '8' --Financiamiento Otros Bancos
                                   ELSE '1'
                                END
                             WHEN TT.KEYCODE = 'PGOINT'
                             THEN
                                CASE
                                   WHEN P.KEYCODE = 'PB' THEN '11'
                                   WHEN P.KEYCODE LIKE ('%SPMSI%') THEN '13' --Skip and Payment
                                   WHEN P.KEYCODE LIKE ('%SPMCI%') THEN '14' --Skip and Payment
                                   WHEN P.KEYCODE LIKE ('%SP%') THEN '12' --Skip and Payment
                                   WHEN P.BANKPROMOTION = 1 THEN '7' --Financiamiento Bancomer
                                   WHEN P.BANKPROMOTION = 2 THEN '8' --Financiamiento Otros Bancos
                                   ELSE '1'
                                END
                             WHEN TT.KEYCODE = 'CHKIN'
                             THEN
                                '17'
                             WHEN TT.KEYCODE = 'REAUT'
                             THEN
                                '18'
                             WHEN TT.KEYCODE = 'CHKOUT'
                             THEN
                                '19'
                             WHEN TT.KEYCODE = 'PRESAL'
                             THEN
                                '20'
                             WHEN TT.KEYCODE = 'PSTTIP'
                             THEN
                                '21'
                             WHEN TT.KEYCODE = 'PRETIP'
                             THEN
                                '22'
                          END
                    END
                       TP_PAGO,
                    TH.AUTHORIZATION AS CD_AUTPGO,
                    NVL (SH.REFERENCEID, ' ') AS TX_PARAM1,
                    SH.userfullname AS TX_PARAM2,
                    NVL (SH.orderparam, ' ') AS tx_param3,
                    '                ' AS tx_param4,
                    CASE
                        WHEN A.OLDID = '10800' THEN (SELECT DETAIL1 FROM DBSBGL.TRANSACTIONHISTORYDETAIL THD WHERE THD.ID = TH.TRXHISTORYDETAILID ) --DETALLE QUE SE BAJA PARA EL SAT ENTIDAD 10800
                        WHEN A.OLDID = '21' AND N.KEYCODE='882' THEN  --DETALLE QUE SE BAJA PARA PUEBLA MUNICIPIO 
                            CASE
                                WHEN P.PROMOTION=1 THEN '0'
                                ELSE P.PROMOTION
                            END||'_'||
                            CASE
                                WHEN P.PROMOTION in (1,0) THEN '2'
                                ELSE '1'
                            END||'_'||
                            CASE
                                WHEN SH.REQUESTPARAMS LIKE('%t_origen=0%') THEN '0'
                                ELSE '1'
                            END||'_'||
                            CASE
                                WHEN (select SHORTNAME from DBSBGL.BANK where IDCOUNTRY=100 and IDBANK in(
                                    select BANKIDBANK from DBSBGL.binbank where id in(
                                        select BINBANKID from dbsbgl.paymentdata where id=PD.ID
                                    )
                                )) like ('%BANCOMER%') THEN '01'
                                WHEN (select SHORTNAME from DBSBGL.BANK where IDCOUNTRY=100 and IDBANK in(
                                    select BANKIDBANK from DBSBGL.binbank where id in(
                                        select BINBANKID from dbsbgl.paymentdata where id=PD.ID
                                    )
                                )) like ('%BANAMEX%') THEN '02'
                                WHEN (select SHORTNAME from DBSBGL.BANK where IDCOUNTRY=100 and IDBANK in(
                                    select BANKIDBANK from DBSBGL.binbank where id in(
                                        select BINBANKID from dbsbgl.paymentdata where id=PD.ID
                                    )
                                )) is not null THEN '03'
                                WHEN (select SHORTNAME from DBSBGL.BANK where IDCOUNTRY=100 and IDBANK in(
                                    select BANKIDBANK from DBSBGL.binbank where id in(
                                        select BINBANKID from dbsbgl.paymentdata where id=PD.ID
                                    )
                                )) is null THEN '04'
                            END
                        WHEN A.OLDID in ('10603','10833','10835','10834') THEN --DETALLES QUE SE BAJAN PARA PEMEX
                            upper(
                                   replace(replace(REGEXP_SUBSTR(REQUESTPARAMS, '&(calle_c=)[a-zA-Z0-9. ]*&?'),'calle_c=',''),'&','')||'|' 
                                ||replace(replace(REGEXP_SUBSTR(REQUESTPARAMS, '&(colonia_c=)[a-zA-Z0-9. ]*&?'),'colonia_c=',''),'&','')||'|'
                                ||replace(replace(REGEXP_SUBSTR(REQUESTPARAMS, '&(delegacion_c=)[a-zA-Z0-9. ]*&?'),'delegacion_c=',''),'&','')||'|'
                                ||replace(replace(REGEXP_SUBSTR(REQUESTPARAMS, '&(codigo_p=)[a-zA-Z0-9. ]*&?'),'codigo_p=',''),'&','')||'|'
                                ||replace(replace(REGEXP_SUBSTR(REQUESTPARAMS, '&(ciudad_c=)[a-zA-Z0-9. ]*&?'),'ciudad_c=',''),'&','')||'|'
                                ||replace(replace(REGEXP_SUBSTR(REQUESTPARAMS, '&(estado_c=)[a-zA-Z0-9. ]*&?'),'estado_c=',''),'&','')||'|'
                                ||replace(replace(REGEXP_SUBSTR(REQUESTPARAMS, '&(pais_c=)[a-zA-Z0-9. ]*&?'),'pais_c=',''),'&','')||'|'
                                ||replace(replace(REGEXP_SUBSTR(REQUESTPARAMS, '&(mp_order=)[a-zA-Z0-9. ]*&?'),'mp_order=',''),'&','')
                              )                        
                        ELSE SH.EXTRAPARAMS 
                    END AS tx_param5,
                    TH.AMOUNT AS IM_SERVPGO, --Se revisa que no sea negativo // AMOUNT TIENE EL IMPORTE ORIGINAL
                    CASE
                       WHEN TH.COMMERCECHARGE IS NOT NULL
                       THEN
                          TH.COMMERCECHARGE
                       WHEN TH.COMMERCECHARGE IS NULL
                       THEN
                          TH.USERCHARGE
                    END
                       IM_COMISPGO,     --Depende de quien absorva la comisión
                    (SELECT AMOUNT AS AMOUNTMSG
                       FROM dbsbgl.saledetail SD
                      WHERE SD.saledivisiontypeid = (SELECT ID
                                                       FROM dbsbgl.
                                                             saledivisiontype
                                                      WHERE keycode = 'MSG')
                            AND SD.salehistoryid = SH.ID)
                       IM_MENSPGO,
                    0 AS IM_IMPTO1,
                    TH.IVACHARGE AS IM_IMPTO2,
                    0 AS IM_IMPTO3,
                    CASE
                       WHEN PD.DISCRIMINATOR = 'CIE'
                       THEN
                          '01'
                       WHEN PD.DISCRIMINATOR = 'SUC'
                       THEN
                          '01'
                       WHEN PD.DISCRIMINATOR = 'AMEX'
                       THEN
                          ''
                       WHEN PD.DISCRIMINATOR = 'CLABE'
                       THEN
                          '1'
                       WHEN PD.DISCRIMINATOR = 'TDX'
                       THEN
                          CASE
                             WHEN PD.CCTID = 1 THEN 'V'
                             WHEN PD.CCTID = 2 THEN 'M'
                          END
                    END
                       AS TX_DTOPGO1,
                    CASE
                       WHEN PD.DISCRIMINATOR = 'CIE' THEN PD.NMP
                       ELSE NULL     --Se llenará con el programa de Heriberto
                    END
                       AS TX_DTOPGO2,
                    PD.TAGDD AS TX_DTOPGO3,
                    NULL AS TX_DTOPGO4, --se llenará con programa de Heriberto
                    SH.USERPHONE AS TX_DTOPGO5,                     --Teléfono
                    SH.USEREMAIL AS TX_DTOPGO6,
                    TH.TIMESTAMP AS TM_PAGO,
                    NULL AS TM_DISP, --alter table tgg008_down modify tm_disp timestamp
                    CASE
                       WHEN TH.STATUSID IN (SELECT id
                                              FROM dbsbgl.status
                                             WHERE keycode IN ('INT'))
                       THEN
                          '1'
                       WHEN TH.STATUSID IN (SELECT id
                                              FROM dbsbgl.status
                                             WHERE keycode IN ('REJMP'))
                       THEN
                          '2'
                       WHEN PD.DISCRIMINATOR = 'CLABE' and TH.STATUSID IN (SELECT id
                                              FROM dbsbgl.status
                                             WHERE keycode IN ('EMP'))
                       THEN
                          '1'
                       ELSE
                          (SELECT ST_PAGO
                             FROM dbsbgl.ad_quickcodes
                            WHERE     quickcode = 'STATUS'
                                  AND instance_name = 'CBGGBP001'
                                  AND newcode = TH.STATUSID
                                  AND ROWNUM = 1)
                    END
                       AS ST_PAGO,               --Convertir a ST MULTIPAGOS 1
                    NULL AS TM_CONCIL, --alter table tgg008_down modify tm_concil timestamp
                    CASE
                       WHEN SH.CURRENCYID = 1 THEN '0'                 --Pesos
                       WHEN SH.CURRENCYID = 2 THEN '1'               --Dólares
                    END
                       CD_MONEDA,
                    CASE
                        WHEN PT.KEYCODE ='INTERRED34' THEN NULL
                        ELSE TO_CHAR (TH.ID)
                    END                      
                    NU_PEDIDO,
                    CASE
                       WHEN PT.KEYCODE = 'ECOMMERCE'
                       THEN
                          CASE
                             WHEN TH.SECUREPAYMENT IS NULL
                                  OR TH.SECUREPAYMENT = 1
                             THEN
                                '4'
                             WHEN TH.SECUREPAYMENT = 0
                             THEN
                                '1'
                          END
                       WHEN PT.KEYCODE = 'INTERRED34'
                       THEN
                          CASE
                             WHEN TH.INPUTTYPE = 'C' THEN '5'
                             WHEN TH.INPUTTYPE = 'D' THEN '6'
                             WHEN TH.INPUTTYPE = 'I' THEN '7'
                          END
                       WHEN PT.KEYCODE = 'ALIGNE'
                       THEN
                          CASE
                             WHEN TH.SECUREPAYMENT IS NULL
                                  OR TH.SECUREPAYMENT = 1
                             THEN
                                'B'
                             WHEN TH.SECUREPAYMENT = 0
                             THEN
                                'A'
                          END
                       WHEN PT.KEYCODE = 'CIE'
                       THEN
                          '1'
                    END
                       CD_ORIGEN,
                    CASE
                       WHEN P.PROMOTION = 1 THEN 0
                       ELSE TO_NUMBER (P.PROMOTION)
                    END
                       AS CD_FINANCIAMIENTO,
                    0 AS IM_COMISMGO2,
                    0 AS IM_IMPTO4,
                    'MP2.V1.2.6' AS TX_DTOPGO7, --SEBE, se queda vacío, uso el campo para indicar que viene de MP2
                    0 AS SOBTASA,
                    0 AS IM_IMPTO5,
                    CASE
                       WHEN NVL (TH.USERCHARGE, 0) > 0
                       THEN
                          (  TH.AMOUNT
                           + NVL (TH.USERCHARGE, 0)
                           + NVL (TH.IVACHARGE, 0))
                       ELSE
                          TH.AMOUNT
                    END
                       AS IM_TOTCOBRADO, --Cuando el usuario absorbe la comisión, se suma al importe total cobrado
                    '0' AS ST_COBRO,
                    '0' AS ST_CONTRACARGO,
                    NULL AS NU_PARCIALIDAD,
                       LPAD (A.OLDID, 5, '0')
                    || LPAD (N.KEYCODE, 5, '0')
                    || '00000'
                    || LPAD (APC.KEYCODE, 5, '0')
                    || LPAD (
                          (CASE
                              WHEN FOLIO IS NOT NULL THEN TO_NUMBER (FOLIO)
                              WHEN FOLIO IS NULL THEN TH.ID
                           END),
                          10,
                          '0')
                       AS CD_REFDOMICIL,
                    A.ID AS ACCOUNTID,
                    SH.SALEID AS SALEID,
                    SH.UUID AS PAGOUUID,
                    PD.DISCRIMINATOR,
                    N.ID AS NODEID,
                    PD.ID AS PAYMENTDATAID,
                    TH.TRANSACTIONID,
                    TH.ID AS TRANSACTIONHISTORYID,
                    SH.ID AS SALEHISTORYID,
                    CASE
                       WHEN PD.DISCRIMINATOR = 'CLABE' THEN PD.ACCOUNTCLABE
                       ELSE PD.TAGED
                    END
                       AS TDC_PROD, --Cuando es clabe, lo que se trae es la cuenta CLABE de PaymentData
                    PD.TAGBD TDCYY_PROD,
                    PD.TAGAD TDCMM_PROD,
                    TH.ID AS CID,
                    'R' STD,
                    CASE
                       WHEN TH.STATUSID IN
                               (SELECT id
                                  FROM dbsbgl.status
                                 WHERE keycode IN ('AMP', 'AUTH', 'CNC'))
                       THEN
                          8                  --Los estatus autorizados de la 8
                       ELSE
                          6
                    END
                       TGG,                 --Indica si va a la tabla 6 o la 8
                    INTR.TRANSACTIONCODE AS CD_TRANSACCION,
                    2 AS TP_MENSAJE,
                    (SELECT contract
                       FROM dbsbgl.contract
                      WHERE id = INTR.CONTRACT_ID)
                       AS NU_AFILIACION,
                    NVL (SH.ORDERPARAM, ' ') AS NU_TRANSMISION,
                    NVL (SH.REFERENCEID, ' ') AS NU_REFERENCIA,
                    INTR.TXTPETICION AS TX_PETICION,
                    INTR.AUTORIZATIONCODE AS CD_AUTORIZACION,
                    INTR.STARTTIME AS TM_INICIO,
                    INTR.FINISHTIME AS TM_FIN,
                    INTR.WAITTIME AS TM_ESPERA,
                    INTR.TRANSACTIOTYPE AS TPO_TRANSACCION,
                    INTR.MONTHYEARACCOUNTING AS FH_CONTABILIZATRAN,
                    INTR.QPS AS CD_QPS,
                    INTR.SFLAG AS CD_SFLAG,
                    INTR.TXTRESPONSE AS TX_RESPUESTA,
                    INTR.CRIPTOGRAM AS TX_CRIPTOGRAMA,
                    '3.4' AS TX_VERSION,
                    INTR.LABELTAG AS CD_LABEL,
                    INTR.AIDTAG AS CD_AID,
                    INTR.CONCILIATION AS CD_CONCILIACION
               FROM (SELECT *
                       FROM dbsbgl.transactionhistory
                      WHERE timestamp >
                               TO_TIMESTAMP ('2014/10/01', 'YYYY/MM/DD')
                      --and TIMESTAMP < (current_timestamp - (interval '1' minute))
                    ) th
                    JOIN dbsbgl.salehistory sh
                       ON TH.SALEHISTORYID = sh.id
                    JOIN dbsbgl.node n
                       ON sh.nodeid = n.id
                    JOIN dbsbgl.account a
                       ON n.accountid = a.id
                    JOIN dbsbgl.account_paymentconcept apc
                       ON SH.PAYMENTCONCEPTID = APC.ID
                    JOIN dbsbgl.paymentdata pd
                       ON TH.PAYMENTID = pd.id
                    JOIN DBSBGL.PROMOTIONS P
                       ON th.promotionsid = P.ID
                    JOIN dbsbgl.transactiontype TT
                       ON TH.TRANSACTIONTYPEID = TT.ID
                    JOIN dbsbgl.platform PT
                       ON TH.platformid = PT.ID
                    LEFT JOIN dbsbgl.interredTransaction INTR
                       ON SH.SALEID = INTR.SALE_ID
                          AND TH.AUTHORIZATION = TRIM (INTR.AUTORIZATIONCODE)
              WHERE 1 = 1 AND REGEXP_LIKE (A.oldid, '^[[:digit:]]+$')) DOWN 
      WHERE NOT EXISTS
               (SELECT 1
                  FROM TGG008_DOWN X
                 WHERE X.CID = DOWN.CID)
   ORDER BY tm_pago
