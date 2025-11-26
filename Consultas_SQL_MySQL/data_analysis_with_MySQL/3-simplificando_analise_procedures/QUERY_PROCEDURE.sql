DELIMITER //

DROP PROCEDURE IF EXISTS
    get_dados_regiao;

CREATE PROCEDURE get_dados_regiao (regiao_nome VARCHAR(255))

BEGIN
    SELECT 
        YEAR(data_inicio) AS ano,
        MONTH(data_inicio) AS mes,
        COUNT(*) AS total_alugueis
    FROM alugueis a
    JOIN 
        hospedagens h ON a.hospedagem_id = h.hospedagem_id
    JOIN 
        enderecos e ON h.endereco_id = e.endereco_id
    WHERE 
        e.estado IN (
            CASE UPPER(TRIM(regiao_nome))
                WHEN 'SUDESTE' THEN ('ES','MG','RJ','SP')
                WHEN 'SUL'         THEN ('PR','SC','RS')
                WHEN 'NORDESTE'    THEN ('AL','BA','CE','MA','PB','PE','PI','RN','SE')
                WHEN 'NORTE'       THEN ('AC','AM','AP','PA','RO','RR','TO')
                WHEN 'CENTRO-OESTE' THEN ('DF','GO','MT','MS')
                ELSE (e.estado)
            END
        )
    GROUP BY
        ano, mes
    ORDER BY 
        ano, mes;
END//
DELIMITER ;