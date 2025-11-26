-- contagem temporal de alugues na regiao sudeste
SELECT 
    YEAR(a.data_inicio) as ano,
    MONTH(a.data_inicio) as mes,
    COUNT(*) AS total_alugueis
FROM 
    alugueis a
JOIN 
    hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN 
    enderecos e ON h.endereco_id = e.endereco_id
WHERE 
    e.estado in ('ES','MG','RJ','SP')
GROUP BY
    ano, mes
ORDER BY 
    ano, mes;