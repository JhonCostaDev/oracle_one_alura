-- Active: 1761826560580@@137.131.202.142@3306@insightplaces2
SELECT 
CASE 
    WHEN e.estado IN ('AM','AC','AP','PA','RO','RR','TO') THEN 'Norte'
    WHEN e.estado in ('AL','BA','CE','MA','PB','PE','PI','RN','SE') THEN 'Nordeste'
    WHEN e.estado in ('ES','MG','RJ','SP') THEN 'Sudeste'
    WHEN e.estado in ('PR','RS','SC') THEN 'Sul'
    WHEN e.estado in ('DF','GO','MT','MS') THEN 'Centro-Oeste'
    ELSE 'Nâo Identificado'
END AS regiao,
ROUND(AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)),2) AS media_diaria
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN enderecos e ON h.endereco_id = e.endereco_id
GROUP BY regiao
ORDER BY media_diaria DESC;

-- ==

SELECT 
-- YEAR(data_inicio) as ano,
MONTH(data_inicio) AS mes,
CASE 
    WHEN e.estado IN ('AM','AC','AP','PA','RO','RR','TO') THEN 'Norte'
    WHEN e.estado in ('AL','BA','CE','MA','PB','PE','PI','RN','SE') THEN 'Nordeste'
    WHEN e.estado in ('ES','MG','RJ','SP') THEN 'Sudeste'
    WHEN e.estado in ('PR','RS','SC') THEN 'Sul'
    WHEN e.estado in ('DF','GO','MT','MS') THEN 'Centro-Oeste'
    ELSE 'Nâo Identificado'
END AS regiao,
ROUND(AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)),2) AS media_diaria
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN enderecos e ON h.endereco_id = e.endereco_id
GROUP BY regiao,  mes
ORDER BY  media_diaria DESC;
