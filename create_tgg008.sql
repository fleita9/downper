DROP TABLE BGGBP001.TGG008_DOWN CASCADE CONSTRAINTS;

CREATE TABLE BGGBP001.TGG008_DOWN
(
  FOLIO                 NUMBER,
  CD_ENTIDAD            NUMBER,
  CD_NIVEL1             NUMBER,
  CD_NIVEL2             NUMBER,
  TP_SERVICIO           NUMBER,
  TP_PAGO               VARCHAR2(2 BYTE),
  CD_AUTPGO             VARCHAR2(255 BYTE),
  TX_PARAM1             VARCHAR2(255 BYTE)      NOT NULL,
  TX_PARAM2             VARCHAR2(255 BYTE),
  TX_PARAM3             VARCHAR2(255 BYTE),
  TX_PARAM4             CHAR(16 BYTE),
  TX_PARAM5             VARCHAR2(1011 BYTE),
  IM_SERVPGO            NUMBER,
  IM_COMISPGO           NUMBER(19,2),
  IM_MENSPGO            NUMBER,
  IM_IMPTO1             NUMBER,
  IM_IMPTO2             NUMBER(19,4),
  IM_IMPTO3             NUMBER,
  TX_DTOPGO1            VARCHAR2(2 BYTE),
  TX_DTOPGO2            VARCHAR2(50 BYTE),
  TX_DTOPGO3            VARCHAR2(255 BYTE),
  TX_DTOPGO4            CHAR(45 BYTE),
  TX_DTOPGO5            VARCHAR2(15 BYTE),
  TX_DTOPGO6            VARCHAR2(255 BYTE),
  TM_PAGO               TIMESTAMP(6)            NOT NULL,
  TM_DISP               TIMESTAMP(6),
  ST_PAGO               VARCHAR2(50 BYTE),
  TM_CONCIL             TIMESTAMP(6),
  CD_MONEDA             VARCHAR2(2 BYTE),
  NU_PEDIDO             VARCHAR2(40 BYTE),
  CD_ORIGEN             VARCHAR2(2 BYTE),
  CD_FINANCIAMIENTO     NUMBER,
  IM_COMISMGO2          NUMBER,
  IM_IMPTO4             NUMBER,
  TX_DTOPGO7            CHAR(3 BYTE),
  SOBTASA               NUMBER,
  IM_IMPTO5             NUMBER,
  IM_TOTCOBRADO         NUMBER(19,2)            NOT NULL,
  ST_COBRO              CHAR(1 BYTE),
  ST_CONTRACARGO        CHAR(1 BYTE),
  NU_PARCIALIDAD        CHAR(1 BYTE),
  CD_REFDOMICIL         VARCHAR2(105 BYTE),
  ACCOUNTID             NUMBER(10)              NOT NULL,
  SALEID                NUMBER(11)              NOT NULL,
  PAGOUUID              VARCHAR2(255 BYTE),
  DISCRIMINATOR         VARCHAR2(10 BYTE),
  NODEID                NUMBER(11)              NOT NULL,
  PAYMENTDATAID         NUMBER(11),
  TRANSACTIONID         NUMBER(11)              NOT NULL,
  TRANSACTIONHISTORYID  NUMBER(11)              NOT NULL,
  SALEHISTORYID         NUMBER(10)              NOT NULL,
  TDC_PROD              VARCHAR2(255 BYTE),
  TDCYY_PROD            VARCHAR2(255 BYTE),
  TDCMM_PROD            VARCHAR2(255 BYTE),
  CID                   NUMBER(11)              NOT NULL,
  STD                   CHAR(1 BYTE),
  TGG                   NUMBER
)
TABLESPACE USERS
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


CREATE INDEX BGGBP001.CIDPREPRO_IDX ON BGGBP001.TGG008_DOWN
(CID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


DROP SYNONYM DBSBGL.TGG008_DOWN;

CREATE SYNONYM DBSBGL.TGG008_DOWN FOR BGGBP001.TGG008_DOWN;


GRANT DELETE, INSERT, SELECT, UPDATE ON BGGBP001.TGG008_DOWN TO DBSBGL;



alter table tgg008_down add  CD_TRANSACCION varchar2(30);
alter table tgg008_down add  TP_MESSAGE number(4);
alter table tgg008_down add  NU_AFILIACION varchar2(7);
alter table tgg008_down add  NU_TRANSMISION varchar2(50);
alter table tgg008_down add  NU_REFERENCIA varchar2(30);
alter table tgg008_down add  TX_PETICION varchar2(4000);
alter table tgg008_down add  CD_AUTORIZACION varchar2(6);
alter table tgg008_down add  TM_INICIO timestamp;
alter table tgg008_down add  TM_FIN timestamp;
alter table tgg008_down add  TM_ESPERA timestamp;
alter table tgg008_down add  TP_TRANSACCION varchar2(3);
alter table tgg008_down add  FH_CONTABILIZATRAN varchar2(4);
alter table tgg008_down add  CD_QPS varchar2(2);
alter table tgg008_down add  CD_SFLAG varchar2(2);
alter table tgg008_down add  TX_RESPUESTA varchar2(4000);
alter table tgg008_down add  TX_CRIPTOGRAMA varchar2(16);
alter table tgg008_down add  TX_VERSION varchar2(10);
alter table tgg008_down add  CD_LABEL varchar2(40);
alter table tgg008_down add  CD_AID varchar2(30);
alter table tgg008_down add  CD_CONCILIACION number(4);
