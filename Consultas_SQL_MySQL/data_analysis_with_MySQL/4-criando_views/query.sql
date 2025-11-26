-- November 23, 2025
-- Criando Views
 SELECT 
        hospedagem_id,
        MIN(data_inicio) AS primeira_data,
        SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
        DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
    FROM 
        alugueis
    GROUP BY 
        hospedagem_id

-- primeira view
CREATE VIEW view_metricas_proprietario AS
SELECT
    p.nome AS Proprietario,
    COUNT(DISTINCT h.hospedagem_id) AS total_hospedagens,
    MIN(primeira_data) AS primeira_data,
    SUM(total_dias) AS total_dias,
    SUM(dias_ocupados) AS dias_ocupados,
    ROUND((SUM(dias_ocupados) / SUM(total_dias)) * 100) AS taxa_ocupacao
FROM(
    SELECT 
        hospedagem_id,
        MIN(data_inicio) AS primeira_data,
        SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
        DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
    FROM 
        alugueis
    GROUP BY 
        hospedagem_id
    ) tabela_taxa_ocupacao
JOIN
    hospedagens h ON tabela_taxa_ocupacao.hospedagem_id = h.hospedagem_id
JOIN
    proprietarios p ON h.proprietario_id = p.proprietario_id
GROUP BY
    p.proprietario_id;CREATE VIEW view_metricas_proprietario AS
SELECT
    p.nome AS Proprietario,
    COUNT(DISTINCT h.hospedagem_id) AS total_hospedagens,
    MIN(primeira_data) AS primeira_data,
    SUM(total_dias) AS total_dias,
    SUM(dias_ocupados) AS dias_ocupados,
    ROUND((SUM(dias_ocupados) / SUM(total_dias)) * 100) AS taxa_ocupacao
FROM(
    SELECT 
        hospedagem_id,
        MIN(data_inicio) AS primeira_data,
        SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
        DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
    FROM 
        alugueis
    GROUP BY 
        hospedagem_id
    ) tabela_taxa_ocupacao
JOIN
    hospedagens h ON tabela_taxa_ocupacao.hospedagem_id = h.hospedagem_id
JOIN
    proprietarios p ON h.proprietario_id = p.proprietario_id
GROUP BY
    p.proprietario_id;

-- select na view
SELECT * from view_metricas_proprietario; 


--
SELECT * FROM hospedagens LIMIT 1;
SELECT 
    hospedagem_id,
    AVG(preco_total / DATEDIFF(data_fim, data_inicio)) AS media_preco_aluguel,
    MAX (preco_total / DATEDIFF(data_fim, data_inicio)) AS max_preco_dia,
    MIN(preco_total / DATEDIFF(data_fim, data_inicio)) AS min_preco_dia,
    AVG(DATEDIFF(data_fim, data_inicio)) AS media_dias_aluguel
FROM alugueis
GROUP BY hospedagem_id;


SELECT *,
CASE 
    WHEN estado IN ('AL','BA','CE','MA','PB','PE','PI','RN','SE') THEN 'Nordeste'
    WHEN estado IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte'
    WHEN estado IN ('DF','GO','MT','MS') THEN 'Centro-oeste'
    WHEN estado IN ('ES','MG','RJ','SP') THEN 'Sudeste'
    WHEN estado IN ('PR','SC','RS') THEN 'Sul'
    ELSE 'NULL'
END AS regiao
FROM enderecos;


--Como eu não criei a tabela regiões no banco de dados, tive que adaptar a criação da view para obter o mesmo resultado, utilizando uma sub-consulta que cria a coluna região na tabela endereços.
--
SELECT
    regioes_geograficas.regiao,
    AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS media_preco_aluguel,
    MAX(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS max_preco_dia,
    MIN(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS min_preco_dia,
    AVG(DATEDIFF(a.data_fim, a.data_inicio)) AS media_dias_aluguel
FROM
    (
        SELECT *,
            CASE 
                WHEN estado IN ('AL','BA','CE','MA','PB','PE','PI','RN','SE') THEN 'Nordeste'
                WHEN estado IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte'
                WHEN estado IN ('DF','GO','MT','MS') THEN 'Centro-oeste'
                WHEN estado IN ('ES','MG','RJ','SP') THEN 'Sudeste'
                WHEN estado IN ('PR','SC','RS') THEN 'Sul'
                ELSE 'NULL'
        END AS regiao
FROM enderecos
    ) AS regioes_geograficas
JOIN
    hospedagens h ON regioes_geograficas.endereco_id = h.endereco_id
JOIN
    alugueis a ON h.hospedagem_id = a.hospedagem_id
GROUP BY
    regioes_geograficas.regiao;
---- November 23, 2025
-- Criando Views
 SELECT 
        hospedagem_id,
        MIN(data_inicio) AS primeira_data,
        SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
        DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
    FROM 
        alugueis
    GROUP BY 
        hospedagem_id

-- primeira view
CREATE VIEW view_metricas_proprietario AS
SELECT
    p.nome AS Proprietario,
    COUNT(DISTINCT h.hospedagem_id) AS total_hospedagens,
    MIN(primeira_data) AS primeira_data,
    SUM(total_dias) AS total_dias,
    SUM(dias_ocupados) AS dias_ocupados,
    ROUND((SUM(dias_ocupados) / SUM(total_dias)) * 100) AS taxa_ocupacao
FROM(
    SELECT 
        hospedagem_id,
        MIN(data_inicio) AS primeira_data,
        SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
        DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
    FROM 
        alugueis
    GROUP BY 
        hospedagem_id
    ) tabela_taxa_ocupacao
JOIN
    hospedagens h ON tabela_taxa_ocupacao.hospedagem_id = h.hospedagem_id
JOIN
    proprietarios p ON h.proprietario_id = p.proprietario_id
GROUP BY
    p.proprietario_id;CREATE VIEW view_metricas_proprietario AS
SELECT
    p.nome AS Proprietario,
    COUNT(DISTINCT h.hospedagem_id) AS total_hospedagens,
    MIN(primeira_data) AS primeira_data,
    SUM(total_dias) AS total_dias,
    SUM(dias_ocupados) AS dias_ocupados,
    ROUND((SUM(dias_ocupados) / SUM(total_dias)) * 100) AS taxa_ocupacao
FROM(
    SELECT 
        hospedagem_id,
        MIN(data_inicio) AS primeira_data,
        SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
        DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
    FROM 
        alugueis
    GROUP BY 
        hospedagem_id
    ) tabela_taxa_ocupacao
JOIN
    hospedagens h ON tabela_taxa_ocupacao.hospedagem_id = h.hospedagem_id
JOIN
    proprietarios p ON h.proprietario_id = p.proprietario_id
GROUP BY
    p.proprietario_id;

-- select na view
SELECT * from view_metricas_proprietario; 


--
SELECT * FROM hospedagens LIMIT 1;
SELECT 
    hospedagem_id,
    AVG(preco_total / DATEDIFF(data_fim, data_inicio)) AS media_preco_aluguel,
    MAX (preco_total / DATEDIFF(data_fim, data_inicio)) AS max_preco_dia,
    MIN(preco_total / DATEDIFF(data_fim, data_inicio)) AS min_preco_dia,
    AVG(DATEDIFF(data_fim, data_inicio)) AS media_dias_aluguel
FROM alugueis
GROUP BY hospedagem_id;


SELECT *,
CASE 
    WHEN estado IN ('AL','BA','CE','MA','PB','PE','PI','RN','SE') THEN 'Nordeste'
    WHEN estado IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte'
    WHEN estado IN ('DF','GO','MT','MS') THEN 'Centro-oeste'
    WHEN estado IN ('ES','MG','RJ','SP') THEN 'Sudeste'
    WHEN estado IN ('PR','SC','RS') THEN 'Sul'
    ELSE 'NULL'
END AS regiao
FROM enderecos;


--Como eu não criei a tabela regiões no banco de dados, tive que adaptar a criação da view para obter o mesmo resultado, utilizando uma sub-consulta que cria a coluna região na tabela endereços.
--
SELECT
    regioes_geograficas.regiao,
    AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS media_preco_aluguel,
    MAX(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS max_preco_dia,
    MIN(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS min_preco_dia,
    AVG(DATEDIFF(a.data_fim, a.data_inicio)) AS media_dias_aluguel
FROM
    (
        SELECT *,
            CASE 
                WHEN estado IN ('AL','BA','CE','MA','PB','PE','PI','RN','SE') THEN 'Nordeste'
                WHEN estado IN ('AC','AM','AP','PA','RO','RR','TO') THEN 'Norte'
                WHEN estado IN ('DF','GO','MT','MS') THEN 'Centro-oeste'
                WHEN estado IN ('ES','MG','RJ','SP') THEN 'Sudeste'
                WHEN estado IN ('PR','SC','RS') THEN 'Sul'
                ELSE 'NULL'
        END AS regiao
FROM enderecos
    ) AS regioes_geograficas
JOIN
    hospedagens h ON regioes_geograficas.endereco_id = h.endereco_id
JOIN
    alugueis a ON h.hospedagem_id = a.hospedagem_id
GROUP BY
    regioes_geograficas.regiao;
--