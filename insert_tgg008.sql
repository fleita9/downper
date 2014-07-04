
insert into TGG008_DOWN
select 
CASE 
WHEN FOLIO is not null then to_number(FOLIO)
WHEN FOLIO is null then TH.ID
END FOLIO ,
to_number(A.OLDID) as CD_ENTIDAD,
cast(regexp_replace(N.KEYCODE, '[^0-9]+', '') as number) CD_NIVEL1,
0 as CD_NIVEL2,
to_number(APC.KEYCODE) as TP_SERVICIO,
    CASE
        WHEN PD.DISCRIMINATOR = 'CIE' THEN '2'
        WHEN PD.DISCRIMINATOR = 'CLABE' THEN '3'
        WHEN PD.DISCRIMINATOR = 'SUC' THEN '4'
        WHEN PD.DISCRIMINATOR = 'AMEX' THEN '0'
        WHEN PD.DISCRIMINATOR = 'CIEINTER' THEN '25'
        WHEN PD.DISCRIMINATOR = 'TDX' THEN
            CASE                                
                 WHEN TT.KEYCODE = 'PAGO' then '1'
                 WHEN TT.KEYCODE = 'PGOINT' then '1'
                 WHEN TT.KEYCODE = 'CHKIN' then '17'
                 WHEN TT.KEYCODE = 'REAUT' then '18'
                 WHEN TT.KEYCODE = 'CHKOUT' then '19'
                 WHEN TT.KEYCODE = 'PRESAL' then '20'
                 WHEN TT.KEYCODE = 'PSTTIP' then '21'
                 WHEN TT.KEYCODE = 'PRETIP' then '22'                 
                WHEN P.KEYCODE = 'PB' THEN '11'
                WHEN P.KEYCODE LIKE('%SPMSI%') THEN '13' --Skip and Payment
                 WHEN P.KEYCODE LIKE('%SPMCI%') THEN '14' --Skip and Payment
                WHEN P.KEYCODE LIKE('%SP%') THEN '12' --Skip and Payment
                WHEN P.BANKPROMOTION = 1 THEN '7' --Financiamiento Bancomer
                WHEN P.BANKPROMOTION = 2 THEN '8' --Financiamiento Otros Bancos
            END              
    END TP_PAGO, 
TH.AUTHORIZATION as CD_AUTPGO,
SH.REFERENCEID as TX_PARAM1,
SH.userfullname as TX_PARAM2,
SH.orderparam as tx_param3,
'                ' as tx_param4,
SH.EXTRAPARAMS as tx_param5,
CASE
    WHEN (TH.AMOUNT - TH.USERCHARGE) <= 0 THEN TH.AMOUNT
    ELSE (TH.AMOUNT - TH.USERCHARGE)
END as IM_SERVPGO,  --Se revisa que no sea negativo
CASE
    WHEN TH.COMMERCECHARGE is not null then TH.COMMERCECHARGE
    WHEN TH.COMMERCECHARGE is       null then TH.USERCHARGE
END   IM_COMISPGO, --Depende de quien absorva la comisión
(select AMOUNT as AMOUNTMSG from dbsbgl.saledetail SD where SD.saledivisiontypeid = (select ID from dbsbgl.saledivisiontype where keycode = 'MSG') and SD.salehistoryid =SH.ID ) IM_MENSPGO,
0 as IM_IMPTO1,
TH.IVACHARGE as IM_IMPTO2,
0 as IM_IMPTO3,
CASE
    WHEN PD.DISCRIMINATOR = 'CIE' THEN '01'
    WHEN PD.DISCRIMINATOR = 'SUC' THEN '01'
    WHEN PD.DISCRIMINATOR = 'AMEX' THEN ''
    WHEN PD.DISCRIMINATOR = 'CLABE' THEN '1'
    WHEN PD.DISCRIMINATOR = 'TDX' THEN
    CASE
        WHEN PD.CCTID = 1 THEN 'V'
        WHEN PD.CCTID = 2 THEN 'M'
    END
END as TX_DTOPGO1, 
CASE
    WHEN PD.DISCRIMINATOR='CIE' THEN PD.CIEREFERENCE
    ELSE NULL   --Se llenará con el programa de Heriberto
END as TX_DTOPGO2, 
PD.TAGDD as TX_DTOPGO3,
null as TX_DTOPGO4, --se llenará con programa de Heriberto
SH.USERPHONE as TX_DTOPGO5, --Teléfono
SH.USEREMAIL as TX_DTOPGO6,
TH.TIMESTAMP as TM_PAGO,
null as TM_DISP, --alter table tgg008_down modify tm_disp timestamp
CASE
    WHEN TH.STATUSID in (select id from dbsbgl.status where keycode in ('INT')) THEN '1'
    WHEN TH.STATUSID in (select id from dbsbgl.status where keycode in ('REJMP')) THEN '2'
    ELSE (select ST_PAGO from dbsbgl.ad_quickcodes where quickcode='STATUS' and instance_name='CBGGBP001' and newcode= TH.STATUSID and rownum=1) 
END as ST_PAGO, --Convertir a ST MULTIPAGOS 1
null as TM_CONCIL, --alter table tgg008_down modify tm_concil timestamp 
CASE 
WHEN SH.CURRENCYID = 1 THEN '0' --Pesos
WHEN SH.CURRENCYID = 2 THEN '1' --Dólares
END CD_MONEDA,
to_char(TH.ID) NU_PEDIDO, 
CASE
WHEN  PT.KEYCODE='ECOMMERCE' THEN
    CASE
        WHEN TH.SECUREPAYMENT is null or TH.SECUREPAYMENT = 1 THEN '4'
        WHEN TH.SECUREPAYMENT = 0 THEN '1'
    END
WHEN PT.KEYCODE='INTERRED34' THEN
    CASE
        WHEN TH.INPUTTYPE='C' THEN '5'
        WHEN TH.INPUTTYPE='D' THEN '6'
        WHEN TH.INPUTTYPE='I' THEN '7' 
    END
WHEN PT.KEYCODE='ALIGNE' THEN
    CASE
        WHEN TH.SECUREPAYMENT is null or TH.SECUREPAYMENT = 1 THEN 'B'
        WHEN TH.SECUREPAYMENT = 0 THEN 'A'
    END
WHEN PT.KEYCODE ='CIE' THEN '1'
END  CD_ORIGEN,
CASE
    WHEN P.PROMOTION = 1 THEN 0
    ELSE TO_NUMBER(P.PROMOTION)
END as CD_FINANCIAMIENTO, 
0 as IM_COMISMGO2, 
0 as IM_IMPTO4, 
'MP2' as TX_DTOPGO7, --SEBE, se queda vacío, uso el campo para indicar que viene de MP2
0 as SOBTASA, 
0 as IM_IMPTO5, 
TH.AMOUNT as IM_TOTCOBRADO, 
'0' as ST_COBRO, 
'0' as ST_CONTRACARGO,
null as NU_PARCIALIDAD,
LPAD(A.OLDID,5,'0')||LPAD(N.KEYCODE,5,'0')||'00000'||LPAD(APC.KEYCODE,5,'0')||LPAD((CASE 
WHEN FOLIO is not null then to_number(FOLIO)
WHEN FOLIO is null then TH.ID
END),10,'0')  as CD_REFDOMICIL,
A.ID as ACCOUNTID, 
SH.SALEID as SALEID, 
SH.UUID as PAGOUUID,
PD.DISCRIMINATOR,
N.ID as NODEID, 
PD.ID as PAYMENTDATAID,
TH.TRANSACTIONID,
TH.ID as TRANSACTIONHISTORYID,
SH.ID as SALEHISTORYID,
CASE
    WHEN PD.DISCRIMINATOR='CLABE' THEN PD.ACCOUNTCLABE 
    ELSE PD.TAGED
END  as TDC_PROD, --Cuando es clabe, lo que se trae es la cuenta CLABE de PaymentData
PD.TAGBD TDCYY_PROD,
PD.TAGAD TDCMM_PROD,
TH.ID as CID,
'R' STD,
CASE
    WHEN TH.STATUSID IN (select id from dbsbgl.status where keycode in ('AMP', 'AUTH')) THEN 8 --Los estatus autorizados de la 8
    ELSE 6
END TGG --Indica si va a la tabla 6 o la 8
from 
(
select * from dbsbgl.transactionhistory 
where id > 8611200 -- le pondré el ID que tenga al momento de la liberación
) th
join dbsbgl.salehistory sh
on TH.SALEHISTORYID = sh.id
join dbsbgl.node n
on sh.nodeid = n.id
join dbsbgl.account a
on n.accountid = a.id
join dbsbgl.account_paymentconcept apc
on SH.PAYMENTCONCEPTID = APC.ID
join dbsbgl.paymentdata pd
on TH.PAYMENTID = pd.id
join DBSBGL.PROMOTIONS P
on th.promotionsid = P.ID
join dbsbgl.transactiontype TT
on TH.TRANSACTIONTYPEID = TT.ID
join dbsbgl.platform PT
on TH.platformid = PT.ID
WHERE not exists (select 1 from TGG008_DOWN X WHERE X.CID = TH.ID)
