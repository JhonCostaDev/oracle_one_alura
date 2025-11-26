# Trabalhando com Excessões no MySQL Store Procedure
Ao realiza a seguinte consulta em uma nova query .sql:

```sql
SELECT * FROM clientes WHERE client_id = '10001';
```
O que ocorrerá ao executar essa consulta? Clicamos no ícone de raio na parte superior para executar.

    cliente_id	nome	cpf	    contato
    NULL	    NULL	NULL	NULL

Todos os campos estão vazios, indicando que o cliente 100001 não está na base de dados de clientes.

>Erro de Chave Estrangeira ao Inserir Aluguel

Agora, suponhamos que queiramos adicionar um novo aluguel. Vamos inserir o aluguel 10005, mas ao invés de usar o cliente 1004, usaremos o cliente 10001, que não existe na base de dados. 

Definiremos as datas do aluguel de 17 a 25 e a taxa diária será mantida em 40.

```sql
CALL novoAluguel_4('10005','10001','8635','2023-03-17','2023-03-25',40);
```
Ao executar essa ação, receberemos uma mensagem de erro com o código `1452`. Embora o texto esteja em inglês, ao passarmos o cursor sobre ele, veremos que indica um problema de chave estrangeira relacionado aos clientes. Isso acontece porque o cliente em questão não existe na base de dados.

O que queremos é que, ao executar a nossa procedure (procedimento), não recebamos esse erro. Em vez disso, desejamos que seja exibido um alerta ou uma mensagem, sem que ocorra um erro dentro do banco de dados. Como fazemos isso?

## Criando e Modificando a Procedure
Voltamos ao script anterior e copiamos a procedure que criamos no vídeo passado, começando pelo primeiro USE até o DELIMITER.

```sql
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `insightplaces`.`novoAluguel_4`;

DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_4`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);

    SET vDias = (SELECT DATEDIFF(vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;

    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;
```

Vamos então colar e modificar o ID da procedure para 5.

```sql
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `insightplaces`.`novoAluguel_5`;

DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_5`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);

    SET vDias = (SELECT DATEDIFF(vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;
```

## Tratando Erros com Chave Estrangeira na Procedure
Para lidar com esse erro e prevenir sua ocorrência, podemos adotar o seguinte procedimento: 
* primeiro, declararemos dentro do BEGIN uma variável denominada `varMensagem`, que será um `VARCHAR()` de `100` caracteres. Após essa declaração, utilizaremos o comando `DECLARE EXIT HANDLER` e especificaremos o número do erro, que é `1452`. Após o DECLARE, não será necessário inserir ponto e vírgula, em vez disso, utilizaremos `BEGIN` e `END`. O ponto e vírgula virá apenas após o END.

```sql
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `insightplaces`.`novoAluguel_5`;

DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_5`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
     DECLARE vMensagem VARCHAR(100);
     DECLARE EXIT HANDLER FOR 1452
     BEGIN
     END;
    SET vDias = (SELECT DATEDIFF(vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;
```
Dentro do BEGIN, inicializaremos a variável mensagem com o valor "`Problema de chave estrangeira associado a alguma entidade da base`" devido ao erro que estamos tratando, o erro 1452. Essa mensagem será exibida utilizando SELECT vMensagem.

Caso tudo ocorra como esperado, ao final, também inicializaremos e exibiremos a mensagem. No entanto, desta vez, a mensagem será iniciada com o valor "`Aluguel incluído na base com sucesso`".

```sql
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `insightplaces`.`novoAluguel_5`;

DELIMITER $$

USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_5`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
     DECLARE vMensagem VARCHAR(100);
     DECLARE EXIT HANDLER FOR 1452
     BEGIN
         SET vMensagem = "Problema de chave estrangeira associado a alguma entidade da base.";
         SELECT vMensagem;
     END;
    SET vDias = (SELECT DATEDIFF(vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = "Aluguel incluído na base com sucesso.";
        SELECT vMensagem;
END$$
DELIMITER ;
```

Resumindo o que foi feito: inicializamos a variável vMensagem e configuramos um DECLARE EXIT HANDLER para o erro 1452. Se esse erro ocorrer durante a execução da procedure, exibiremos a mensagem de erro correspondente. Por outro lado, se a procedure for concluída sem erros, exibiremos a mensagem de sucesso.

## Executando a Procedure Modificada
Agora, executaremos o código a partir do primeiro USE até o DELIMITER e atualizaremos a página. Dessa forma, teremos do lado esquerdo dentro de "Stored Procedures": novoAluguel_5.

Ao chamar a nossa procedure e alterar o ID para 5, ao executar a procedure, podemos confirmar que nenhum erro ocorreu.

```sql
CALL novoAluguel_5('10005','10001','8635','2023-03-17','2023-03-25',40);
```

Ela foi concluída com sucesso e a mensagem "Problema de chave estrangeira" foi exibida.


    Problema de chave estrangeira associado a alg...
Se agora colocarmos um cliente que exista, como o 1004, por exemplo, e executarmos, veremos a mensagem 
        
        "Aluguel incluído na base com sucesso".

```sql
CALL novoAluguel_25('10005','1004','8635','2023-03-17','2023-03-25',40);
```
Obtemos:

    vMensagem
    Aluguel incluído na base com sucesso.

### Conclusão
Portanto, conseguimos tratar erros e evitar que a procedure tenha algum tipo de erro interno que faça com que ela seja abortada. Agora, ela será sempre executada e exibirá uma mensagem quando houver um problema de chave estrangeira.

## Question - Entendendo o tratamento de erros


Analise a procedure desenvolvida:
```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_25`(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE,
vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE VPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, 
    vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluido na base com sucesso.';
    SELECT vMensagem;
END
```
A procedure novoAluguel_25 introduziu um avanço significativo na gestão de aluguéis ao implementar um tratamento de exceções. Este mecanismo de tratamento de exceções garante que, em caso de falhas durante a inserção de dados devido a restrições de chave estrangeira, uma mensagem de erro clara seja gerada, melhorando a robustez e a usabilidade da aplicação. Com base na abordagem adotada por novoAluguel_25, qual é a principal funcionalidade do tratamento de exceções incorporado?

Selecione uma alternativa

Incrementar automaticamente o valor do vPrecoUnitario em caso de erros de inserção.


Executar cálculos adicionais para ajustar o vPrecoTotal em resposta a erros de validação de dados.


Automatizar o reenvio de transações falhas após a detecção de erros de chave estrangeira.


Capturar e informar erros relacionados a problemas de chave estrangeira durante a inserção de dados.


Retornar detalhes específicos do cliente em caso de falhas na conexão com o banco de dados.