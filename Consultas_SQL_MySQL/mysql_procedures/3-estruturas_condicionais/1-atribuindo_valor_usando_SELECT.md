# Atribuindo valor usando SELECT

Vimos em aulas anteriores que, quando queremos atribuir uma função do __MySQL__ a uma variável, fazemos isso da maneira abaixo, localizada na linha 21 do nosso script.

Nela, executamos a função, passando os parâmetros, e seu resultado será atribuído à variável vDias.
```sql
SET vDias- (SELECT DATEDIFF (vDataFinal, voataInicio));
```
No entanto, muitas vezes, precisamos atribuir à variável o resultado de uma consulta em outra tabela.

## Buscando o Código pelo Nome

Vamos trabalhar essa questão em um exemplo, criando uma nova guia de script e executando a consulta abaixo na linha 2, na qual vamos verificar a pessoa cliente cujo nome seja Luana Moura.

```sql
SELECT * FROM clientes WHERE nome = 'Luana Moura';
```
O resultado pode ser visto abaixo da área de scripts.


    cliente_id	nome	    cpf	            contato
    1001	    Luana Moura	258.374.106-35	luana_915@dominio.com

Note que Luana Moura tem como ID o valor 1001. Portanto, vamos modificar o script para, ao registrar um aluguel, entrarmos com o nome em vez do código da pessoa cliente. Assim, na Procedure, vamos procurar o código na tabela pelo nome e incluí-lo na tabela de aluguéis.

Para isso, vamos voltar à guia do script do último vídeo, na qual vamos copiar os dados referentes à última Procedure que criamos, presentes desde a linha 5 até a 28.
```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_5`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_5`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
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
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluído na base com sucesso.';
    SELECT vMensagem;
END$$
DELIMITER ;
```

Voltando à guia do script atual, vamos pular uma linha e colar esse conteúdo abaixo do anterior, modificando o nome da Procedure para novoAluguel_31 em todo o script.

O parâmetro, originalmente, é passado como sendo o código da pessoa cliente na variável vCliente. Vamos alterar seu nome para vClienteNome na linha 9, alterando o VARCHAR para 150, pois nomes de clientes não têm apenas 10 caracteres.
```sql
SELECT * FROM clientes WHERE nome = 'Luana Moura';
```

```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_6`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_6`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
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
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluído na base com sucesso.';
    SELECT vMensagem;
END$$
DELIMITER ;
```

Contudo, ainda precisamos da variável vCliente, que possui o código, pois é por meio dela que vamos inserir o dado na tabela. Portanto, acima de `DECLARE` vDias, vamos criar um `DECLARE vCliente`, que será um `VARCHAR`.

Além disso, antes de executar a inclusão, na linha 24, vamos criar uma linha vazia na qual precisamos atribuir o código da pessoa cliente à variável vCliente acessando a tabela de clientes. Para isso, vamos copiar a consulta da linha 2, 

    SELECT * FROM clientes WHERE nome = 'Luana Moura', 
    
e colá-la na linha recém-criada.

Precisamos alterar essa linha. No lugar do asterisco, precisamos atribuir o cliente_id. E no lugar de 'Luana Moura', será o vClienteNome.
```sql
SELECT * FROM clientes WHERE nome = 'Luana Moura';
```

```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_6`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_6`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR(10);
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
    SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluído na base com sucesso.';
    SELECT vMensagem;
END$$
DELIMITER ;
```

Vamos executar essa consulta para o nome que foi passado como parâmetro dentro da Procedure. E estamos buscando o campo cliente_id.

Como podemos atribuir esse cliente_id à variável vCliente? Após executar esta consulta, o resultado que vai aparecer em cliente_id é atribuído à variável vCliente. A partir disso, a variável é usada na próxima linha para fazer o INSERT na tabela de aluguéis.

Vamos ver se isso vai funcionar. Vamos executar todo o bloco de comandos que colamos para criar essa nova Procedure, acessar o explorador à esquerda para realizar um "Refresh All" no elemento "Stored Procedures" e verificar a nova Procedure, novoAluguel_6, dentro de sua lista.

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
        tiposDados

Vamos copiar o comando de chamada da Procedure abaixo, localizado no final da guia de script do vídeo anterior.

```sql
CALL novoAluguel_25('10005','1004','8635','2023-03-17','2023-03-25',40);
```

Vamos voltar à guia de script atual e colar essa chamada abaixo do último comando, pulando uma linha entre eles. Porém, agora vamos executar a 31, portanto, vamos modificar esse nome.

Além disso, em vez de passar o código `1004` da pessoa cliente, vamos passar, por exemplo, o nome Luana Moura, também entre aspas simples. Também mudaremos o primeiro parâmetro, referente ao ID, de 10005 para 10006, continuando a sequência numérica.

Também precisamos alterar as datas, que passarão a contemplar do dia 26 ao 30.


```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_6`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_6`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR(10);
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
    SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome; #Essa linha precisa ser ajustada
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, 
    vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluido na base com sucesso.';
    SELECT vMensagem;
END$$
DELIMITER;

CALL novoAluguel_31('10006','Luana Moura','8635','2023-03-26','2023-03-30',40);
```

A nossa chamada está pronta. Agora, estamos passando o nome, permitindo que ele ache o código internamente.

Após executar a linha da chamada, teremos o aluguel incluído com sucesso. Se acessarmos a linha seguinte e fizermos um SELECT * FROM alugueis WHERE aluguel_id = '10006', veremos como resultado que entramos na Procedure com o nome da pessoa cliente e gravamos o seu id na tabela de aluguéis.

```sql
CALL novoAluguel_6('10006','Luana Moura','8635','2023-03-26','2023-03-30',40);

SELECT * FROM alugueis WHERE aluguel_id = '10006'
```
    aluguel_id	cliente_id	hospedagem_id	data_inicio	data_fim	preco_total
    10006	    1001	    8635	        2023-03-26	2023-03-30	160.00



## Question - Utilizando SELECT INTO para vinculação de dados

```sql

CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_6`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE,
vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR(10);
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
    SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, 
    vDataFinal, vPrecoTotal);
    SET vMensagem = 'Aluguel incluido na base com sucesso.';
    SELECT vMensagem;
END
```

A stored procedure novoAluguel_6 demonstra uma prática avançada de manipulação de dados dentro do MySQL, utilizando a instrução SELECT INTO. Esse método permite uma integração direta e eficiente de dados de diferentes tabelas, otimizando o processo de inserção de novos aluguéis ao automatizar a busca e atribuição de identificadores específicos de clientes. Considerando a implementação do `SELECT INTO` na procedure, qual é sua funcionalidade principal?

- ( ) Calcular automaticamente o total de dias de aluguel e armazenar o resultado na variável vDias.


- ( ) Gerar uma mensagem de erro personalizada em caso de falha na busca do cliente_id.


- ( ) Atualizar o valor de vPrecoUnitario com base no cliente_id encontrado.


- ( ) Inserir diretamente os dados de aluguel na tabela alugueis sem o uso de variáveis intermediárias.


- (X) Atribuir o cliente_id correspondente ao nome do cliente à variável vCliente, facilitando a inserção relacionada.
>A principal funcionalidade do `SELECT INTO` utilizada na procedure é buscar e atribuir o cliente_id correspondente ao vClienteNome fornecido, direcionando esse valor para a variável vCliente, o que é crucial para a inserção correta dos dados de aluguel.