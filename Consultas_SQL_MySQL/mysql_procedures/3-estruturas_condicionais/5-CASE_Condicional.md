# Implementando o CASE CONDICIONAL

O CASE que montamos no vídeo anterior iguala valores. Primeiro, buscamos se a variável vNumCliente é igual a zero, porque quando fazemos WHEN 0 para uma variável, testamos se ela é igual a zero.

Já se ela é igual a 1, ela faz outra coisa. Além disso, temos o nosso ELSE, que se aplica quando o valor da variável não é 0 nem 1, ou seja, quando é maior que 1. Não podemos ter um valor negativo, porque o COUNT nunca vai dar um número negativo.

Ao invés de colocar o CASE igualando uma variável, podemos colocar uma condição de teste diretamente com o CASE condicional. Vamos fazer isso agora.

## Utilizando o CASE Condicional
Levando em consideração o que estamos fazendo com todos as aulas, vamos criar um script novo, colando o conteúdo do script de criação do Procedure anterior e alterando o novoAluguel_9 para criar a Procedure 10.

```sql
SE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_10`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_10`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR;
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE vNumCliente
    WHEN 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN 1 THEN
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    ELSE
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    END CASE;
END$$
DELIMITER ;
```
Como modificamos esse CASE para um CASE condicional?

Primeiro, na hora que declaramos o CASE, não colocaremos nenhuma variável do lado. Vamos retirar o vNumCliente, mantendo o CASE.

Passaremos a variável removida para dentro do WHEN e colocaremos a condição, adicionando = 0. Dessa forma, quando vNumClientes for igual a 0, fazemos alguma coisa.

Vamos modificar a linha WHEN 1 THEN para WHEN vNumCliente = 1 WHEN, na qual vamos fazer uma segunda coisa. Por fim, podemos substituir o ELSE por um novo teste com WHEN vNumCliente e THEN, só que vamos verificar se essa variável é maior que 1.

```sql
-- Código omitido
    CASE
    WHEN vNumCliente = 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN vNumCliente = 1 THEN
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    WHEN vNumCliente > 1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    END CASE;
END$$
DELIMITER ;
```
A nossa rotina pode ser vista acima. Se a variável é igual a zero, fazemos uma coisa, se é igual a 1, fazemos outra, e se é maior que 1, fazemos uma terceira coisa.

Nela, retiramos a variável do CASE, e por isso, tivemos que adicionar dentro do WHEN uma condição que dê verdadeiro ou falso.

Não precisamos adicionar necessariamente uma só condição. Poderíamos também usar uma expressão lógica complexa adicionando `AND` a cada etapa.

Essa rotina vai fazer o mesmo que a anterior, mas de outra maneira. Nas três últimas aulas, fizemos três formas diferentes de implementar a mesma lógica: uma usando o if, outra usando else if, outra usando o CASE, igualando uma variável, e agora usando o CASE condicional.

Mesmo assim, vamos testar. Vamos salvar e executar a nova Procedure. Ao realizar um "Refresh" em "Stored Procedures" pela aba lateral, veremos o número 10.

    # Stored Procedures
    alo_mundo
    dataHora
    listaClientes
    novoAluguel_1
    novoAluguel_2
    novoAluguel_3
    novoAluguel_4
    novoAluguel_5
    novoAluguel_6
    novoAluguel_7
    novoAluguel_8
    novoAluguel_9
    novoAluguel_10
    tiposDados

Vamos buscar esses registros, copiando do script anterior as três linhas de CALL onde chamávamos o aluguel pelo nome de uma pessoa que não existe na base, pelo nome de outra que tem mais do que uma ocorrência na base e de outra que só tem uma ocorrência na base.

Ao colar esse conteúdo abaixo da Procedure recém-executada, vamos substituir os números 34 por 35 nas três linhas.

```sql
CALL novoAluguel_10('10007','Victorino Vila','8635','2023-03-30','2023-04-04',40);
CALL novoAluguel_10('10007','Júlia Pires','8635','2023-03-30','2023-04-04',40);
CALL novoAluguel_10('10007','Luana Moura','8635','2023-03-30','2023-04-04',40);
```

Por fim, como estamos incluindo de novo o aluguel 1007, vamos escrever acima dessas linhas um DELETE FROM alugueis WHERE aluguel_id = 1007 e executá-lo para apagar o aluguel anterior com este número.

```sql
DELETE FROM alugueis WHERE aluguel_id = 1007;
```

Após o `DELETE`, vamos executar nossas chamadas. Primeiro, tentaremos incluir uma pessoa cliente que não existe na base, rodando a primeira chamada e veremos a mensagem "Esse cliente não pode ser usado para incluir o aluguel." Em seguida, vamos tentar incluir um que tem mais de uma ocorrência na tabela de clientes, rodando a segunda chamada, o que retornará a mesma mensagem.

Por fim, vamos incluir uma pessoa cliente que só tem uma ocorrência, rodando a terceira e última chamada. Isso retornará a mensagem "Aluguel incluído na base com sucesso."

Fizemos 3 rotinas que fazem a mesma coisa com códigos diferentes. Quando estivermos trabalhando com `Procedures em MySQL`, temos essas 3 estruturas de condições para escolher e adaptar conforme o que for melhor para a lógica a ser implementada.

## QUESTION - Convertendo o IF-THEN-ELSE-IF no CASE CONDICIONAL


Evoluímos ainda mais a procedure da InsightPlace implementando, como substituição ao IF-THEN-ELSE-IF, o CASE CONDICIONAL.

```SQL
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_10`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE,
vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR(10);
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE VPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE 
    WHEN vNumCliente = 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN vNumCliente = 1 THEN
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, 
        vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluido na base com sucesso.';
        SELECT vMensagem;
    WHEN vNumCliente > 1 THEN
       SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
       SELECT vMensagem;
    END CASE;
END
```
Sobre esta conversão, analise a procedure abaixo:
```SQL
CREATE PROCEDURE ChecarStatusCliente(vClienteNome VARCHAR(150))
BEGIN
    DECLARE vStatusCliente VARCHAR(20);
    DECLARE vNumPedidos INTEGER;
    SET vNumPedidos = (SELECT COUNT(*) FROM pedidos WHERE clienteNome = vClienteNome);
    
    IF vNumPedidos > 5 THEN
        SET vStatusCliente = 'VIP';
    ELSEIF vNumPedidos BETWEEN 2 AND 5 THEN
        SET vStatusCliente = 'Regular';
    ELSE
        SET vStatusCliente = 'Novato';
    END IF;
    
    SELECT vStatusCliente;
END
```
Neste cenário, como você reescreveria a stored procedure ChecarStatusCliente utilizando a estrutura CASE-END CASE para alcançar a mesma funcionalidade da versão original que usa IF-THEN-ELSEIF?

Selecione uma alternativa
```SQL
CASE vNumPedidos
    WHEN 'VIP' THEN SET vStatusCliente > 5;
    WHEN 'Regular' THEN SET vStatusCliente BETWEEN 2 AND 5;
    ELSE SET vStatusCliente = 'Novato';
END CASE;
```
```SQL
CASE 
    WHEN vNumPedidos > 5 THEN SET vStatusCliente = 'VIP';
    WHEN vNumPedidos >= 2 AND vNumPedidos <= 5 THEN SET vStatusCliente = 'Regular';
    ELSE SET vStatusCliente = 'Novato';
END CASE;
```
>Esta versão corretamente aplica a sintaxe do CASE para condições específicas, utilizando a estrutura CASE de maneira apropriada para avaliar condições e atribuir valores com base nelas.
```SQL
CASE 
    WHEN vNumPedidos = 0 THEN SET vStatusCliente = 'Novato';
    ELSE SET vStatusCliente = 'Regular';
END CASE;
```
```SQL
CASE 
    WHEN vNumPedidos <= 5 THEN SET vStatusCliente = 'Regular';
    WHEN vNumPedidos < 2 THEN SET vStatusCliente = 'Novato';
    ELSE SET vStatusCliente = 'VIP';
END CASE;
```
```SQL
CASE vNumPedidos
    WHEN > 5 THEN SET vStatusCliente = 'VIP';
    WHEN BETWEEN 2 AND 5 THEN SET vStatusCliente = 'Regular';
    ELSE SET vStatusCliente = 'Novato';
END CASE;
```