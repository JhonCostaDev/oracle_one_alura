USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_11`;
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `novoAluguel_11`( -- parametros da procedure
varAluguel VARCHAR(10), varClienteNome VARCHAR(150), varHospedagem VARCHAR(10),
varDataInicio DATE, varDias INTEGER, varPrecoUnitario DECIMAL(10,2)
)
BEGIN
	-- DECLARAÇÃO DE VARIÁVEIS
    DECLARE varNumClientes INTEGER; 		-- var recebe numero de clientes com nome buscado
	DECLARE varCliente VARCHAR(10); 		-- var clientes.cliente_id
	DECLARE varDataFinal DATE; 		-- var recebe a data final atraves ...
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
		-- CALCULA A DATA DE SAÍDA - DATA FINAL
		SET varDataFinal = (SELECT varDataInicio + INTERVAL varDias DAY);
        
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

CALL novoAluguel_11('10009', 'Rafael Peixoto', '3437', '2025-11-01', 3, 65);


select * from reservas order by reserva_id desc limit 10;

SELECT * FROM reservas where reserva_id >= '9999' order by cast(reserva_id as unsigned) desc;
-- Como a coluna reserva_id tem o tipo varchar, para ordenação correta este comando é necessário...
SELECT * FROM reservas ORDER BY CAST(TRIM(reserva_id) AS UNSIGNED) DESC LIMIT 50;

select * from reservas where reserva_id < '10000' limit 100;

select '10008' < '9999' as isBigger;
