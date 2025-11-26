SELECT `CalcularOcupacaoMedia`();


SELECT cpf from clientes LIMIT 5;

SELECT `MaskCPF`(1);

SET @goiaba = '09096066835';

SELECT 
 CONCAT(
                SUBSTRING(@goiaba, 1, 3), '.',
                SUBSTRING(@goiaba, 4, 3), '.',
                SUBSTRING(@goiaba, 7, 3), '-',
                SUBSTRING(@goiaba, 10, 2)
                ) AS CPF_mask

SELECT `FormatCPF`(@goiaba);


-- Determinar o valor da diaria de cada aluguel

SELECT * from reservas LIMIT 10;
SELECT * from clientes LIMIT 10;

SET @dataInicio = '2025-10-28';
SET @dataFim = NOW();

SELECT DATEDIFF(NOW(), STR_TO_DATE(start_date, '%Y-%m-%d')) AS days_difference
FROM your_table;


SELECT DATEDIFF(@dataFim, STR_TO_DATE(@dataInicio, '%Y-%m-%d'));

SELECT c.nome,
DATEDIFF(STR_TO_DATE(r.data_fim,'%Y-%m-%d'), STR_TO_DATE(r.data_inicio, '%Y-%m-%d')) AS diarias,
TRUNCATE(r.preco_total / DATEDIFF(STR_TO_DATE(r.data_fim,'%Y-%m-%d'), STR_TO_DATE(r.data_inicio, '%Y-%m-%d')),2) AS valor_diaria
FROM reservas r
JOIN clientes c ON r.cliente_id = c.cliente_id;

-- receba como parâmetro um tipo de hospedagem (por exemplo, 'Casa', 'Apartamento', 'Hotel') e retorne o total de hospedagens disponíveis desse tipo. 

SELECT * from hospedagens LIMIT 10;
SET @tipo = 'apartamento';
SELECT tipo, COUNT(*) FROM hospedagens
GROUP BY tipo;

SELECT COUNT(*) FROM hospedagens
WHERE tipo = 'hotel';

SELECT COUNT(DISTINCT(tipo)) FROM hospedagens;


SELECT `countHostType`(@tipo);