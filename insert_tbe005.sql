INSERT INTO tbe005_down
   SELECT *
     FROM (  SELECT cd_entidad,
                    cd_nivel1,
                    cd_nivel2,
                    tp_servicio,
                    TO_CHAR (tm_pago, 'YYYY-MM-DD') FECHA,
                    cd_moneda,
                    'R' as STD
               FROM tgg008_down
           GROUP BY cd_entidad,
                    cd_nivel1,
                    cd_nivel2,
                    tp_servicio,
                    TO_CHAR (tm_pago, 'YYYY-MM-DD'),
                    cd_moneda) X
    WHERE NOT EXISTS
             (SELECT 1
                FROM tbe005_down Y
                where X.cd_entidad = Y.cd_entidad
                and X.cd_nivel1 = Y.cd_nivel1
                and X.cd_nivel2 = Y.cd_nivel2
                and X.tp_servicio = Y.tp_servicio
                and X.FECHA = Y.FECHA
                and X.cd_moneda = Y.cd_moneda
                )
