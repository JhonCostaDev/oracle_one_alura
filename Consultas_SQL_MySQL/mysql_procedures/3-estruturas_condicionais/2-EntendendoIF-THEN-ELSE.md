# Entendendo o IF-THEN-ELSE


Observemos esta situação: vamos incluir um novo aluguel usando a Procedure versão 6. Para isso, vamos criar um novo script, colar esse comando na linha 2 e realizar modificações:

* Incluiremos o aluguel `10007` no lugar do `10006`;
* Vamos usar a pessoa cliente `Júlia Pires`, em vez de `Luana Moura`;
* Vamos alterar as datas para `30 de março` e `4 de abril`.
```sql
CALL novoAluguel_31('10007','Júlia Pires','8635','2023-03-30','2023-04-04',40);
```
Ao fazer isso, encontramos um erro no retorno, o código 1172.

    Error Code: 1172 Result consisted of more than one row

A inclusão deste aluguel resultou em erro porque a pessoa cliente Júlia Pires tem mais de um registro na tabela de clientes. Se executarmos a consulta abaixo na linha 4 com a Júlia Pires, vamos observar que existem duas Júlias Pires na base de dados.

```sql
SELECT * FROM clientes WHERE nome 'Júlia Pires';
```
Aba de Resultado:

    cliente_id	nome	    cpf	            contato
    100	        Júlia Pires	190.682.435-51	júlia_388@dominio.com
    8820	    Julia Pires	647.058.392-00	julia_919@dominio.com

São duas `clientes diferentes`, mas que possuem o `mesmo nome`. Podemos notar que o CPF é diferente.

Só podemos incluir uma pessoa cliente que tenha uma identificação única. Contudo, se olharmos o código da Procedure que fizemos no vídeo anterior, associamos o nome da pessoa cliente utilizando o comando `SELECT INTO` à variável, por volta da linha 23.

O `SELECT` com `INTO` só `funciona quando este SELECT retornar apenas uma linha`. Se ele retornar mais de uma, ocorre o `erro` número `1172`.

## Utilizando IF, THEN e ELSE

Vamos tratar este erro. Primeiro, vamos testar se o nome da pessoa cliente tem mais do que um elemento. Se sim, vamos mostrar uma mensagem dizendo: "`Não podemos incluir esta pessoa cliente pelo nome`". Caso contrário, podemos incluir o aluguel.

Logo, vamos fazer um `IF`. Vamos testar o número de clientes e se este for maior do que 1, não faremos nada, apenas exibiremos a mensagem. Se for igual a 1, incluiremos a pessoa cliente.

Vamos copiar todo o código da Procedure na guia do vídeo anterior e colá-lo na linha 6. Este código está disponível abaixo.
```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_6`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_6`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR;
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
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

Primeiro, vamos declarar uma nova variável para receber o número de clientes que possuem o nome usado como parâmetro para incluir o aluguel. Entre as linhas que declaram o vDias e o VPrecoTotal, vamos adicionar DECLARE vNumCliente. Essa variável de número de clientes vai ser do tipo INTEGER.

```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_7`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_7`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR;
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
-- Código omitido
```
Feito isso, antes de efetuar a inclusão do aluguel, vamos buscar o número de clientes que possui aquele nome. Para isso, criaremos quatro linhas vazias abaixo do END que temos por volta da linha 23.

Na primeira linha vazia, vamos colocar SET vNumCliente = e, entre parênteses, executar um SELECT COUNT (*) FROM clientes WHERE nome = , usando a variável vClienteNome.

```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_7`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_7`
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
    
    
    
-- Código omitido
```
Ao executar essa linha, vamos buscar o número de clientes que possuem aquele nome. Esse valor, obtido através do `COUNT (*)`, vai ser apropriado à variável vNumCliente.

Com isso, vamos fazer um teste na linha seguinte: `IF vNumCliente > 1 THEN`.

A partir disso, pressionaremos "Enter" e, dentro desse IF, vamos criar uma mensagem com `SET vMensagem = e SELECT` vMensagem e linhas diferentes.

Após o `SET vMensagem = `, vamos escrever: "`Este cliente não pode ser usado para incluir o aluguel pelo nome.`" entre aspas simples.

Caso o número de clientes não seja maior que 1, vamos usar o `ELSE`. Este termina com um `END IF`, portanto, vamos pressionar "Enter" e adicioná-lo na linha seguinte.

```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_7`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_7`
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
    IF vNumCliente > 1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
    ELSE
    END IF
    
    
-- Código omitido
```
Entre o `END` e o `END IF`, vamos criar uma nova linha vazia e mover para ela o processo de inclusão do aluguel — ou seja, todo o código abaixo do `END IF` até antes do `END$$`.

Vamos indentar o conteúdo movido e remover as linhas vazias para manter a rotina organizada. Se não identificarmos nosso código, podemos nos perder.

Por fim, vamos finalizar o processo de criação da nova Procedure mudando o seu número de novoAluguel_6 para novoAluguel_7 em todo o código. Isso evita a criação de uma Procedure em cima da outra.

```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_32`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_32`
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
    IF vNumCliente > 1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
    ELSE
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    END IF
END$$
DELIMITER ;
```
Finalizamos a inclusão da pessoa cliente. Declaramos a variável vNumCliente, buscamos o número de clientes que existem com determinado nome, e fizemos um teste: se o número de cliente for maior que 1, temos mais de uma pessoa cliente e o SELECT INTO não vai funcionar, portanto, escreveremos a mensagem e não conseguiremos incluir a pessoa cliente. Caso contrário, realizamos o processo normal.

Em seguida, vamos executar a Procedure 7, selecionando todo o seu conteúdo e clicando no botão "Execute". Após criá-la, vamos acessar a aba lateral esquerda, realizar um "Refresh" no "Stored Procedures" e verificar que ela está presente em seu interior.

    Stored Procedures
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
    tiposDados
Após isso, vamos tentar incluir o aluguel para a Júlia Pires, copiando a Procedure da linha 2, colando-a abaixo do restante do código e modificando seu número para 7.

```sql
CALL novoAluguel_32('10007','Júlia Pires','8635','2023-03-30','2023-04-04',40);
```
Ao incluir essa pessoa cliente, notaremos que a Procedure vai retornar sem erro, e na área de resultados, vamos ter a mensagem "Este cliente não pode ser usado para incluir o aluguel pelo nome".

## Question - O Impacto do controle de fluxo

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_7`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE,
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
    IF vNumCliente > 1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
    ELSE
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, 
        vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluido na base com sucesso.';
        SELECT vMensagem;
    END IF;
END
```

    As stored procedures representam uma ferramenta poderosa para o gerenciamento avançado de dados, permitindo uma ampla gama de funcionalidades, desde a manipulação simples de dados até a implementação de lógicas complexas de controle. Nesse contexto, estruturas de controle específicas desempenham um papel crucial na definição de comportamentos dinâmicos dentro das procedures, adaptando-se a diferentes cenários operacionais. Com base na evolução das práticas de gerenciamento de dados, qual seria a contribuição de uma estrutura de controle específica para a eficácia das operações de banco de dados?

- (X) Adaptar a execução de tarefas com base em condições pré-estabelecidas.
>Estruturas de controle específicas permitem a adaptação flexível do fluxo de operações, ajustando-se automaticamente a diferentes condições e cenários, melhorando assim a eficiência e a eficácia das stored procedures.


- ( ) Reduzir o consumo de recursos do servidor durante operações complexas.


- ( ) Facilitar a identificação e correção de erros em tempo de execução.


- ( ) Aumentar a velocidade de processamento de transações de dados.


- ( ) Melhorar a precisão na manipulação de grandes volumes de dados.