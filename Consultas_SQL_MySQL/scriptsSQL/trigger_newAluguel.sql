DELIMITER $$
CREATE TRIGGER atualizaResumoReserva
AFTER INSERT ON reservas
FOR EACH ROW

BEGIN
	DECLARE desconto INTEGER;
    DECLARE valorFinal DECIMAL(10,2);
    
    SET desconto = CalcularDescontoPorDia(NEW.reserva_id);
    SET valorFinal = CalcularValorFinalDesconto(NEW.reserva_id);
    
    INSERT INTO 
    resumo_reservas(reserva_id, cliente_id, valor_total, desconto_aplicado, valor_final)
    VALUES(NEW.reserva_id, NEW.cliente_id, NEW.preco_total, desconto, valorFinal);
    

END$$
DELIMITER 


select nome, count(cliente_id) quantidade from clientes
group by nome;
-- verificando existencia do cliente retornando o id
select cliente_id from clientes where nome = 'Marina Nunes';

-- verificando o id da hospedagem mais utilizada
select hospedagem_id, count(hospedagem_id) alugada from reservas group by hospedagem_id 
order by alugada desc;  -- 4598

call novoAluguel_14('Marina Nunes', '4598', '2025-11-11', 5, 89.9);

select * from resumo_reservas;