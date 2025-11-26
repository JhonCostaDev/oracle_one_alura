![capa](https://miro.medium.com/v2/resize:fit:1100/format:webp/0*d-CzEGzEdcIc_Kre.png)

# Calculando intervalo entre datas passando o número de dias através de parâmetro de uma Procedure

Vamos treinar SQL aplicado ao `MySQL` e também descobrir como podemos usar as `SQLs` na construção de `procedures`. Utilizando a procedure já trabalhada no mod anterior, faremos uma pequena modificação em nossa procedura que nos ajudará a compreender novos conceitos.

Atualmente, inserimos a data inicial e a data final da hospedagem. Internamente, calculamos o número de dias e, com esse número de dias, aplicamos ao valor da diária para encontrar o valor total. Também sabemos que precisamos da data inicial e final para inserir na tabela de aluguéis.

![screenShot procesure 10](../../../assets/call_procedure_10.png)

## Modificando a procedure
Foi solicitado que fizéssemos uma modificação. É complicado para a pessoa usuária inserir a data inicial e final da hospedagem. Em vez disso, ela passará como parâmetro da procedure a data inicial e o número de dias.

Para isso, criamos um novo script onde escreveremos: 
```sql
SELECT '2023-01-01' + INTERVAL 5 DAY;
```
e executamos a consulta.

Com isso, temos o retorno abaixo:

    '2023-01-01' + INTERVAL 5 DAY
     2023-01-06
Ou seja, `5 dias após o dia 01 de janeiro de 2023`. Portanto, através desta consulta, vamos obter a data final.

Agora, vamos alterar o parâmetro de data final que temos atualmente na procedure para o número de dias. Internamente calcularemos a data final baseado nesse número de dias, que será passado como parâmetro, usando esta consulta.

Buscaremos a última procedure que trabalhamos através do script do vídeo anterior, então o copiamos e colamos.

Feito isso, alteraremos a passagem de parâmetro. Onde temos a vDataFinal DATE, próximo à linha 10, mudamos para vDias INTEGER. Isso porque agora será parâmetro.
```sql
-- Código omitido

vDias INTEGER vPrecoUnitario decimal(10,2))

-- Código omitido
```
Depois, mudamos de `DECLARE vDias INTEGER DEFALT 0`; para `DECLARE vDataFinal DATE 0`;.

```sql
-- Código omitido

DECLARE vDataFinal DATE 0;

-- Código omitido
```

O que fizemos foi trocar o parâmetro vDataFinal para variável e o vDias, que era variável e virou parâmetro.

Buscaremos onde calculamos vDias, porque agora é o inverso. Não vamos mais calcular vDias, porque é fornecida para o procedimento. O que calcularemos é a data final.

Na linha SET vDias, adicionamos um comentário incluindo -- no início da linha. Na linha abaixo, calcularemos a data final então passamos SET vDataFinal = SELECT vDataInicio + INTERNAL vDias DAY.

Lembrando que o nome da variável é case sensitive. O v precisa estar em letra minuscula, assim como foi declarado anteriormente.
```sql
SET vDataFinal = SELECT vDataInicio + INTERNAL vDias DAY
```
Substituímos a linha onde calculávamos vDias, agora, calculamos a data final através dessa seleção. Feito isso, nas linhas 5 e 8 mudamos os valores de 10 para 11.

```sql
-- Código omitido

USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_11`;
DELIMITER $$
USE insightplaces $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_11`

-- Código omitido
```
Depois, selecionamos todo o código e executamos. A criação da procedure é feita com sucesso. Se na lateral esquerda, clicarmos em "Stored Procedures" e depois em "Refresh All", visualizamos a procedure 11.

## Testando a nova consulta
Agora, faremos um teste. Escreveremos: 
```sql
CALL novoAluguel_41('10008', 'Rafael Peixoto', '3635', '2023-04-05,5,40);. 
```
Dessa forma, entramos com o ID do aluguel, nome da pessoa cliente, ID da hospedagem, data inicial, número de dias e o valor da diária. Vamos conferir se vai funcionar.
```sql
CALL novoAluguel_41('10008', 'Rafael Peixoto', '3635', '2023-04-05,5,40);
```
Ao executar, visualizamos a mensagem de retorno "Aluguel incluído na base com sucesso". Então, passamos: 
```sql
SELECT * FROM alugueis WHERE aluguel_id = '10008'.
```
Ao executar a consulta, temos o retorno abaixo:

    aluguel_id	cliente_id	hospedagem_id	data_inicio	data_fim	preco_total
    10008	    101	        8635	        2023-04-05	2023-04-10	200.00
    Null	    Null	    Null	        Null	    Null	    Null
Temos o cliente com o identificador, data inicial, a data final calculada e o preço total, que é o número de dias vezes a diária.


## Question - Ajustando a lógica de cálculo de datas em Stored Procedures

Analise a procedure desenvolvida:

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_41`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE,
vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR(10);
    DECLARE vDataFinal DATE;
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
        -- SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vDataFinal = (SELECT vDataInicio + INTERVAL vDias DAY) ;
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

Na evolução da stored procedure novoAluguel_11 para o gerenciamento de aluguéis, uma alteração significativa foi feita na maneira de calcular a data final do aluguel. Originalmente, a data final era calculada a partir da diferença de dias entre as datas inicial e final. Agora, a abordagem foi invertida: dado o número de dias de aluguel e a data de início, a data final é calculada. Essa mudança reflete uma adaptação aos requisitos do negócio, facilitando o processo de inclusão de novos aluguéis com base em parâmetros fornecidos.

Considerando a substituição da operação original SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio)); pela nova lógica SET vDataFinal = (SELECT vDataInicio + INTERVAL vDias DAY);, qual das seguintes afirmações melhor explica o impacto dessa mudança na stored procedure?

Selecione uma alternativa

- (X) A nova lógica simplifica a entrada de dados, requerendo apenas a duração em dias ao invés de calcular a data final.
>A substituição permite que o usuário forneça diretamente a duração do aluguel em dias e a data de início, facilitando o cálculo da data final sem necessitar de uma data final predefinida

- ( ) A nova abordagem implica que a duração do aluguel não pode mais ser ajustada após a inserção inicial.


- ( ) A alteração requer que a data de início seja conhecida com antecedência, limitando a capacidade de fazer reservas de última hora.


- ( ) Essa modificação elimina a necessidade de armazenar a data final como um parâmetro, reduzindo a flexibilidade da procedure.


- ( ) A mudança aumenta a complexidade do cálculo, exigindo funções adicionais para determinar a data final.