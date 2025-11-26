-- TRUNCAR SAIDA
SELECT tipo, TRUNCATE(AVG(nota),2) MEDIA
FROM avaliacoes a 
JOIN hospedagens h ON h.hospedagem_id = a.hospedagem_id
group by tipo;

-- ROUND ARREDONDAR
SELECT tipo, ROUND(AVG(nota),2) MEDIA
FROM avaliacoes a 
JOIN hospedagens h ON h.hospedagem_id = a.hospedagem_id
group by tipo;

-- CATEGORIZANDO AS NOTAS
SELECT hospedagem_id, nota,
CASE nota
	WHEN 5 THEN 'EXCELENTE'
    WHEN 4 THEN 'ÓTIMO'
    WHEN 3 THEN 'MUITO BOM'
    WHEN 2 THEN 'BOM'
    ELSE 'RUIM'
END AS status_nota
FROM avaliacoes;