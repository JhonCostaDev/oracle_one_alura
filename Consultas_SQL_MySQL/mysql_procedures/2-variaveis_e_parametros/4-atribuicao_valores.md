# Atribuição de Valores - Realizando Cálculo de Datas
Vamos criar um novo script e prestem atenção nesta consulta: 

`SELECT DATEDIF()`. Se, nos parênteses, colocarmos uma data inicial `'2023-04-03'` e uma data final `'2023-04-01'`, por exemplo, e chamarmos isso de diferenca_dias, ao executarmos essa consulta, teremos como `resultado o número 2`. Então nossa consulta fica:

```sql
SELECT DATEDIFF ('2023-04-03','2023-04-01') AS diferenca_dias
```
    diferenca_dias
          2


O resultado é 2 porque temos dois dias entre o dia 03/04 e o dia 01/04. Então, essa consulta retorna o número de dias entre as datas. E nós recebemos a seguinte atribuição:

    # Demanda: 
    Quando incluímos um novo aluguel, não queremos colocar a data inicial, a data final e o valor total a ser pago. Nós colocamos apenas a data inicial, a data final e o preço da diária, que é o preço unitário.

Portanto, nossa procedure precisa pegar a data final, saber quantos dias tem em relação à data inicial e multiplicar esse resultado pelo valor da diária. 

## Aplicando a consulta para gerar o valor da estadia
Vamos buscar no script anterior o status atual da nossa `StoredProcedure`. Novamente copiaremos desde o primeiro `USE` até o último `DELIMITER` e passaremos para um novo script.

```sql
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `insightplaces`.`novoAluguel_24`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_24`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoTotal DECIMAL(10,2))
BEGIN
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;
```
Começamos modificando o nome da nossa procedure para novo_aluguel_4, tanto na linha 5 quanto na linha 8. Em seguida, na linha 9, o vPrecoTotal não será mais um parâmetro passado para a procedure. No lugar, passaremos o vPrecoUnitario.



    (vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))



Entretanto, ainda temos que calcular o vPrecoTotal, porque, na hora de incluir na tabela de aluguéis, incluímos o vPrecoTotal, e não o vPrecoUnitario. Então, inicialmente, precisamos calcular o número de dias entre a data inicial e a data final.

Para isso, no `BEGIN` vamos declarar uma variável `vDias`, que terá o número de dias. Ela será do tipo inteiro e vai ter como padrão o valor 0. Além disso, vamos declarar a variável `vPrecoTotal`, porque ela vai ser calculada e vai ser um `DECIMAL(10,2)`, sem `DEFAULT`.

```sql

BEGIN
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vPrecoTotal DECIMAL(10,2);
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;
```

Agora precisamos da `data final` e da `data inicial`, para calcular o número de dias e passa para essa variável. 
Fazemos isso usando `SET vDias`. Por exemplo, se escrevermos `SET vDias = 10`, estaremos atribuindo à variável vDias, que no início vale 0, o valor 10.

Como não podemos atribuir isso de forma constante, vamos atribuir a diferença entre a data final, através do `SELECT` que aprendemos no começo da aula. Portanto, vamos copiar o `SELECT` que fizemos na primeira linha sem o alias e atribuir para o SET vDias.

```sql
SET vDias = SELECT DATEDIFF ('2023-04-03','2023-04-01')
```
Em seguida, adicionaremos o comando SELECT entre parênteses, para poder isolá-lo, e mudaremos os valores dentro dos parênteses do DATADIF () para a `vDataFinal` e, no segundo parâmetro, `vDataInicio`.

```sql
SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
```

Ao executar essa linha, já vamos calcular o número de dias. 

Para calcularmos o preco_total, temos que multiplicar esse resultado pelo preco_unitario. Então, na linha abaixo, escrevemos `SET vPrecoTotal = vDias * preco_unitario`. Com o preco_total calculado, podemos utilizá-lo dentro do comando INSERT.

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
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;
```

Ao selecionarmos os comandos que serão executados, ou seja, desde o primeiro USE até o último DELIMITER, conseguimos executar com sucesso. Agora, ao atualizarmos o `StoredProcedures`, na coluna da esquerda, temos a nossa procedure novo_aluguel_4.

## Analisando o resultado
Vamos retornar ao script que criamos no vídeo anterior e vamos copiar a chamada do novoAluguel_24. Voltando para o nosso script, vamos colar esse código no final

```sql
CALL novoAluguel_4('10003', '1004', '8635', '2023-03-10', '2023-03-12', 250)
```

Agora, para entrarmos com o novo aluguel, precisamos entrar com a data inicial, data final e, ao invés do valor total, passamos o valor da diária. Mudaremos a data de entrada para o dia 13 de saída para o dia 16. O valor da nossa diária será de 40. Além disso, mudaremos o ID do aluguel para 10004 para não termos um erro, já que o ID deve ser único.

```sql
CALL novoAluguel_24('10004', '1004', '8635', '2023-03-13', '2023-03-16', 40)
```
A execução deu certo. Agora vamos executar o 
```sql        
SELECT * FROM alugueis WHERE aluguel_id = '10004' 
```
para recebermos o resultado da consulta.

    aluguel_id	cliente_id	hospedagem_id	data_inicio	data_fim	preco_total
    10004	    1004	    8635	        2023-03-13	    2023-03-16	120.00

Recebemos o novo aluguel e notem que o preco_total foi de 120, considerando os 3 dias entre o dia 13 e 16. Como o valor da diária é 40, 40 vezes 3 é 120, que é o valor total das diárias.

## Question -  Modificando a Procedures de aluguéis
 Próxima Atividade

Analise a procedure abaixo desenvolvida no vídeo anterior:

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_24`(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE,
vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE VPrecoTotal DECIMAL(10,2);
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, 
    vDataFinal, vPrecoTotal);
END
```


## Question
A novoAluguel_4 representa um marco no desenvolvimento de stored procedures para a InsightPlaces, introduzindo uma lógica de cálculo dinâmico que determina o preço total de um aluguel. Essa evolução permite uma gestão mais eficiente e precisa dos aluguéis, ajustando-se automaticamente a variáveis específicas de cada transação. Com base na funcionalidade introduzida por novoAluguel_4, qual elemento é fundamental para calcular o preço total do aluguel? Escolha a alternativa correta.

Selecione uma alternativa

- ( ) A capacidade de atualizar automaticamente os registros da tabela alugueis para cada cliente.


- (X) A introdução de um cálculo baseado na diferença de dias entre vDataInicio e vDataFinal, multiplicado pelo vPrecoUnitario.

    >O procedimento utiliza a função DATEDIFF para determinar o número de dias entre as datas de início e fim do aluguel, e multiplica o resultado pelo preço unitário para calcular o preço total, evidenciando uma aplicação direta de lógica matemática e condicional no processo.

- ( ) O armazenamento de informações de clientes e hospedagens em variáveis locais para uso futuro.


- ( ) A inclusão de parâmetros externos para definir o número máximo de dias permitidos para um aluguel.


- ( ) A validação de datas para garantir que vDataFinal seja posterior a vDataInicio.