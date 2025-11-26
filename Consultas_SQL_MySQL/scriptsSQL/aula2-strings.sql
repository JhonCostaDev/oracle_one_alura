select * from clientes;

-- ESPECIFICANDO COLUNAS
select nome, contato from clientes;

-- ALTERANDO A SAIDA COM CONCAT
SELECT CONCAT(nome, ' O email é: ',contato) from clientes;

-- TRIM: REMOVE ESPAÇOS NA STRING
SELECT CONCAT(TRIM(nome), ' O email é: ',contato) from clientes;

-- SUBSTRING - REMOÇÃO DE PARTE DE UMA STRING
SELECT cpf from clientes;

SELECT 
	CONCAT(SUBSTRING(cpf, 1, 3), '.', SUBSTRING(cpf, 4, 3), '.', SUBSTRING(cpf, 7, 3), '-', SUBSTRING(cpf, 10, 2)) 
AS CPF_Mascarado
FROM
	clientes;

SET @testecpf = '00512365428';
select @testecpf;

SELECT 
	CONCAT(SUBSTRING(@testecpf, 1, 3), '.', SUBSTRING(@testecpf, 4, 3), '.', SUBSTRING(@testecpf, 7, 3), '-', SUBSTRING(@testecpf, 10, 2)) 
AS CPF_Mascarado;

--
