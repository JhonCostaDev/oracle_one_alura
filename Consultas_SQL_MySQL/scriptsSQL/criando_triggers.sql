-- REVISÃO NOVO RELATÓRIO
-- Dar desconto de acordo com a quantidade de dias de hospedágens

--Menos de 4 dias - 0% desconto
-- De 4 a 6 dias - 5% desconto
-- 7 a 9 dias  -  10% desconto
-- 10 ou mais dias - 15% desconto

SELECT * FROM reservas;

-- Calcular dias pegando diferença entre datas de entrada e saída

SELECT c.nome as cliente,DATEDIFF(r.data_fim, r.data_inicio) quantidade_dias, preco_total FROM reservas r
JOIN clientes c on r.cliente_id = c.cliente_id;

-- clausula CASE

SELECT c.cliente_id, c.nome as cliente,DATEDIFF(r.data_fim, r.data_inicio) total_dias, preco_total,
CASE 
    WHEN DATEDIFF(r.data_fim, r.data_inicio) BETWEEN 4 AND 6 THEN 5
    WHEN DATEDIFF(r.data_fim, r.data_inicio) BETWEEN 7 AND 9 THEN 10
    WHEN DATEDIFF(r.data_fim, r.data_inicio) >= 10 THEN 15
    ELSE 0
END AS desconto_percentual
FROM reservas r
JOIN clientes c on r.cliente_id = c.cliente_id;

-- Buscando maiores quantidades;
SELECT c.cliente_id, c.nome as cliente,DATEDIFF(r.data_fim, r.data_inicio) total_dias, preco_total,
CASE 
    WHEN DATEDIFF(r.data_fim, r.data_inicio) BETWEEN 4 AND 6 THEN 5
    WHEN DATEDIFF(r.data_fim, r.data_inicio) BETWEEN 7 AND 9 THEN 10
    WHEN DATEDIFF(r.data_fim, r.data_inicio) >= 10 THEN 15
    ELSE 0
END AS desconto_percentual
FROM reservas r
JOIN clientes c on r.cliente_id = c.cliente_id
WHERE DATEDIFF(r.data_fim, r.data_inicio) > 5;

--criando a função
DELIMITER $$
CREATE FUNCTION CalcularDescontoPorDia(aluguelID INTEGER)
RETURNS INTEGER DETERMINISTIC
BEGIN
DECLARE desconto INTEGER;
SELECT   
    CASE 
        WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 4 AND 6 THEN 5
        WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 7 AND 9 THEN 10
        WHEN DATEDIFF(data_fim, data_inicio) >= 10 THEN 15
        ELSE 0
    END INTO desconto
FROM reservas 
WHERE reserva_id = aluguelID;
RETURN desconto;
END$$

DELIMITER ;

-- TESTANDO A FUNCAO
SELECT `CalcularDescontoPorDia`(101)


-- DESAFIO 4.1 calcule a duração média das estadias realizadas pelos clientes

-- Crie uma função chamada CalculaDuracaoMediaEstadias que retorna a duração média de todas as estadias registradas no banco de dados, arredondada para o número inteiro mais próximo.
-- Observação: A função deve calcular a média de dias entre as datas de início e fim de cada aluguel registradas na tabela aluguéis.

--Obtendo a média de dias de hospedagem
SELECT AVG(DATEDIFF(data_fim, data_inicio)) FROM reservas;

-- Criando a função

DELIMITER $$
CREATE FUNCTION CalculaDuracaoMediaEstadias(reservaID INTEGER)
RETURNS INTEGER DETERMINISTIC
BEGIN
DECLARE media INTEGER;

SELECT AVG(DATEDIFF(data_fim, data_inicio)) INTO media FROM reservas
WHERE reserva_id = reservaID;

RETURN media;
END$$

DELIMITER ;

--teste
SELECT `CalculaDuracaoMediaEstadias`(953);

-- funcao chama funcao

DELIMITER $$

CREATE FUNCTION CalcularValorFinalDesconto(reservaID INTEGER)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE valor_total DECIMAL(10,2);
    DECLARE desconto INTEGER;
    DECLARE valor_final DECIMAL(10,2);
    
    SELECT preco_total INTO valor_total 
    FROM reservas
    WHERE reserva_id = reservaID;

    SET desconto = CalcularDescontoPorDia(reservaID);
    SET valor_final = valor_total - (valor_total  * desconto / 100);

    RETURN valor_final;
END$$

DELIMITER ;

-- Testando a funcao

SELECT `CalcularValorFinalDesconto`(1);


-- Review - Nova Tabela - TRIGGERS

--Criando uma nova tabela com o resumo das informações adquiridas com as funções personalizadas criadas.
DROP TABLE IF EXISTS resumo_reservas;
CREATE TABLE resumo_reservas(
    reserva_id VARCHAR(255),
    cliente_id VARCHAR(255),
    valor_total DECIMAL(10,2),
    desconto_aplicado DECIMAL(10,2),
    valor_final DECIMAL(10,2),
    PRIMARY KEY (reserva_id, cliente_id),
    FOREIGN KEY (reserva_id) REFERENCES reservas(reserva_id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);


-- Criando Uma nova Trigger (gatilho)

DELIMITER $$
CREATE TRIGGER atualizarResumoAluguel
AFTER INSERT on reservas
FOR EACH ROW

BEGIN
    DECLARE desconto INTEGER;
    DECLARE valor_final DECIMAL(10,2);

    SET desconto = CalcularDescontoPorDia(NEW.reserva_id);
    SET valor_final = CalcularValorFinalDesconto(NEW.reserva_id);

    INSERT INTO resumo_reservas(reserva_id, cliente_id, valor_total, desconto_aplicado)
END$$

DELIMITER ;

SELECT * from resumo_reservas