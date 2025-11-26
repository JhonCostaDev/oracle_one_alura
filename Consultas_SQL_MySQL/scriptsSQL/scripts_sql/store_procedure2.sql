USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_10`;
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `novoAluguel_10`(
varAluguel VARCHAR(10), varClienteNome VARCHAR(150), varHospedagem VARCHAR(10),
varDataInicio DATE, varDataFinal DATE, varPrecoUnitario DECIMAL(10,2)
)
BEGIN
	-- DECLARAÇÃO DE VARIÁVEIS
    DECLARE varNumClientes INTEGER; 		-- var recebe numero de clientes com nome buscado
	DECLARE varCliente VARCHAR(10); 		-- var clientes.cliente_id
	DECLARE varDias INTEGER DEFAULT 0; 		-- var recebe  num de dias de aluguel da func DATADIFF
    DECLARE varPrecoTotal DECIMAL(10,2); 	-- var recebe o calculo dias_aluguel X preco_diaria
    
    -- TRATANDO EXCESSOES
    DECLARE varMensagem VARCHAR(100); 		-- var que armazena as mensagens de erro
    DECLARE EXIT HANDLER FOR 1452			-- inicio levantamento excessão / cod erro 1452
    BEGIN
		SET varMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT varMensagem ; 				-- exibe a mensagem de erro.
    END;									-- Fim levantamento de excessão.
    
    -- BUSCAR NUM DE CLIENTES COM NOME SEMELHANTE
    SET varNumClientes = (SELECT COUNT(*) FROM clientes WHERE nome = varClienteNome);
    
    CASE 			-- Inicio CASE
    -- Condicional IF que testa se existe mais de um cliente com o mesmo nome
    WHEN varNumClientes = 0 THEN		-- não registra aluguel se o cliente não estiver na base.
        SET varMensagem ='Este cliente não pode ser usado para incluir um novo aluguel porque ele não existe.';
        SELECT varMensagem;				-- exibe a mensagem 
	WHEN varNumClientes = 1 THEN	    -- Cliente único, registra o aluguel
		-- CALCULAR O NÚMERO DE DIAS DE RESERVA
		SET varDias = (SELECT DATEDIFF(varDataFinal, varDataInicio));
		
		-- CALCULAR O VALOR FINAL
		SET varPrecoTotal = varDias * varPrecoUnitario;
		
		-- INSERIR NO BANCO
        -- Usa o select into para receber a saída do select e armazenar na varCliente
		SELECT cliente_id INTO varCliente FROM clientes WHERE nome = varClienteNome;
        
        -- Usa insert into para inserir as informações na tabela de alugueis.
		INSERT INTO reservas VALUES (varAluguel, varCliente, varHospedagem, varDataInicio,varDataFinal, varPrecoTotal);
		SET varMensagem = 'Aluguel incluido na base co sucesso!'; -- atribui msg de sucesso.
		SELECT varMensagem;	
    WHEN varNumClientes > 1 THEN	-- Demais casos
		SET varMensagem ='Este cliente não pode ser usado para incluir um novo aluguel apenas pelo nome';
        SELECT varMensagem;				
	END CASE;
END$$										-- Fim da Procedure
DELIMITER ;


CALL novoAluguel_10('10008','Victorino Vila','8635','2023-03-30','2023-04-04',40);
CALL novoAluguel_10('10008','Júlia Pires','8635','2023-03-30','2023-04-04',40);
CALL novoAluguel_10('10008','Luana Moura','8635','2023-03-30','2023-04-04',40);

SELECT * FROM reservas where reserva_id = '10008';
