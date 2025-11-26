# Calculando automaticamente o ID do aluguel

Até agora, incluímos o identificador do aluguel manualmente, sempre que fazemos uma nova hospedagem.

Na última vez que inserimos o aluguel, tivemos que inserir manualmente o número 10011. A cada novo exemplo, temos que adicionar um a mais, pois o identificador do aluguel é uma chave primária da tabela de aluguel. Portanto, não pode ser repetido.

Se tentarmos, por exemplo, incluir este aluguel novamente, com o mesmo número, teremos um erro. Sendo assim, poderíamos implementar uma lógica que verificasse o maior número do identificador do aluguel, somasse 1 e o usasse como código na inclusão de um novo aluguel.

Essa lógica poderia estar dentro da procedure. Assim, não precisaríamos mais passar como parâmetro o identificador do aluguel. No entanto, há um problema, o aluguel_id é uma string.

Se analisarmos a tabela de aluguéis, o identificador do aluguel, passando o código SELECT * FROM alugueis em um novo script, notaremos que sempre teremos números nessa coluna.

No entanto, esses números não são numéricos, são números representados como string. Não podemos aplicar sobre esta coluna a função de agregação MAX(). Podemos até tentar, mas quando aplicamos ela pegará a maior string numérica, que é diferente do maior número.

Sabemos que o número 1.000 é maior do que o número 2, mas a string 1.000 é menor do que a string 2. Isso porque, como é string, ela comparará o primeiro caractere dessa primeira string com o primeiro caractere da segunda string.

Então, precisamos buscar essa coluna, convertê-la para número, encontrar o maior, somar 1 e voltar a transformá-la para string. Afinal, o valor final, o aluguel_id precisa ser string para podermos incluir na tabela. Faremos isso por partes.

Passamos SELECT aluguel_id e para converter esse campo em um número inteiro usamos o CAST(aluguel_id AS UNSIGNED) FROM alugueis.

```sql
SELECT aluguel_id, CAST(aluguel_id AS UNSIGNED) FROM alugueis;

Ao executar essa consulta, temos aparentemente o mesmo retorno. Na coluna aluguel_id temos uma lista de strings, mas em CAST() temos uma lista de números.
```
    aluguel_id	CAST(aluguel_id AS UNSIGNED)
    1	    1
    10	    10
    100	    100
    1000	1000
    10000	10000
    //Dados omitidos	
Tanto que, se pegarmos esse mesmo código e passarmos MAX() envolvendo aluguel_id, seguido de outro MAX(), envolvendo aluguei_id AS UNSIGNED, conforme abaixo:

```sql
SELECT MAX(aluguel_id), MAX(CAST(aluguel_id AS UNSIGNED)) FROM alugueis;
```

Ao executar o código, obtemos valores diferentes.

    MAX(aluguel_id)	MAX(CAST(aluguel_id AS UNSIGNED))
    9999	10011

Em string, o 9999 é a maior string que temos dentro de todos que estão sendo listados. Quando convertemos para número, o maior número é o 10011, que é justamente o último que trabalhamos na inclusão de aluguel.

Então, sabemos que precisamos ter o campo convertido para inteiro e aplicar o MAX(). Sobre esse MAX(), se quisermos encontrar o próximo ID de aluguel, somamos 1 passando + 1 antes de FROM alugueis.

```sql
SELECT MAX(aluguel_id), MAX(CAST(aluguel_id AS UNSIGNED)) + 1 FROM alugueis;
```
Ao executar, o próximo seria o seguinte:

    MAX(CAST(aluguel_id AS UNSIGNED)) + 1
    10012

Mas, esse aluguel_id tem que ser colocado dentro da procedure como string, afinal ele entrará nesse campo. Então precisamos buscar o campo atual e converter de novo.

Para isso, copiamos a linha de código e colamos abaixo. Feito isso, antes de MAX(), envolvemos esse trecho de código com CAST(AS CHAR). Da seguinte forma:

```sql
SELECT CAST(MAX(aluguel_id), MAX(CAST(aluguel_id AS UNSIGNED)) + 1 AS CHAR) FROM alugueis;
```

Ao executar, temos o seguinte retorno.

    CAST(MAX(CAST(aluguel_id AS UNSIGNED)) + 1 AS CHAR)
    10012

## Calculando IDs de aluguel automaticamente
Agora, abrimos a última versão da procedure, copiamos o código e colamos no nosso novo script. Feito isso, na linha 13 e 16 mudamos para novoAluguel_44.

Na linha 17, não usaremos mais o padrão vAluguel VARCHAR(10), pois ele será calculado sozinho dentro da procedure. Então apagamos. Porém, ele precisa ser declarado, então, na linha 20, abaixo de BEGIN, passamos DECLARE vAluguem VARCHAR(10).

```sql
-- Código omitido

USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`. `novoAluguel_44`;
DELIMITER $$
USE `insightplaces` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_44`
(vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE,
vDias INTEGER, vPrecoUnitario DECIMAL(10,2))

BEGIN
    DECLARE vAluguel VARCHAR(10);
    DECLARE vCliente VARCHAR(10);
    
-- Código omitido
```

Feito isso, podemos apagar as linhas comentadas. Antes de usarmos a vAluguel em INSERT INTO, nesse caso será abaixo de WHEN, passamos SELECT CAST(MAX(CAST(aluguel_id AS UNSIGNED)) +1 AS CHAR) INTO vAluguel_FROM alugueis.

Dessa forma, essa linha pegará o maior valor do aluguel_id, somar um e usar como sendo um novo aluguel.

```sql
-- Código omitido

WHEN vNumCliente = 1 THEN
    SELECT CAST (MAX(CAST(aluguel_id AS UNSIGNED)) + 1 AS CHAR) INTO vAluguel FROM alugueis
    CALL calculaDataFinal_43 (vDataInicio, vDataFinal, vDias);
    SET vPrecoTotal vDias * vPrecoUnitario;
    SELECT cliente_id INTO VCliente FROM clientes WHERE nome = vClienteNome;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
    SET vMensagem 'Aluguel incluido na base com sucesso.';
    SELECT vMensagem;

-- Código omitido
```

Selecionamos o código e executamos. Na lateral esquerda, atualizamos a lista de procedures e encontramos o novoAluguel_44. Para testar, passamos o código abaixo e executamos.
```sql
CALL novoAluguel_44('Livia Fogaça', '8635', '2023-05-15', 5, 45);
```

Lembrando que agora não é mais necessário entrar com o identificador do aluguel.

Ao executar, o aluguel incluído com sucesso. Então passamos SELECT * FROM alugueis WHERE. Agora, não sabemos o número do aluguel. Nesse caso, podemos melhorar nossa rotina.

Na mensagem Aluguel incluido na base com sucesso, podemos incluir - ID. Fora das aspas simples, podemos concatenar passando + vAluguel.

```sql
-- Código omitido

SET vMensagem = 'Aluguel incluido na base com sucesso - ID' + vAluguel;

-- Código omitido
```

Sabemos de antemão que se rodarmos a seleção SELECT MAX(aluguel_id), MAX(CAST(aluguel_id AS UNSIGNED)) FROM alugueis, temos o retorno abaixo.

MAX(aluguel_id)	MAX(CAST(aluguel_id AS UNSIGNED))
9999	10012
Testando a concatenação
Para conferir se a concatenação está funcionando, selecionamos o trecho de código que inicia em USE e termina em DELIMITER para atualizar a procedure.

Depois, abaixo do DELIMITER, passamos DELETE FROM alugueis WHERE aluguel_id = '10012' e executamos.

```SQL
-- Código omitido

DELETE FROM alugueis WHERE aluguel_id = '10012'

-- Código omitido
```
Agora, selecionamos o trecho de código CALL novoAluguel_44('Livia Fogaça', '8635', '2023-05-15', 5, 45); e executamos. Com isso, temos um erro indicando que não foi possível incluir.

Isso aconteceu, pois antes da mensagem Aluguem incluido na base com sucesso, precisamos passar a função CONCAT().

```SQL
-- Código omitido

SET vMensagem = CONCAT('Aluguel incluido na base com sucesso - ID' + vAluguel);

-- Código omitido
```
Ao executar, temos o retorno abaixo:

Aluguel incluido na base com sucesso. - ID 10012

Se quisermos, por exemplo, colocar outro aluguel no dia 29 da Lívia, conforme abaixo:

CALL novoAluguel_44('Livia Fogaça', '8635', '2023-05-29', 5, 45);
Copiar código
Ao executar o ID passa a ser 10013, pois vai incrementando a cada chamada da procedure.

Aluguel incluido na base com sucesso. - ID 10013

Assim, melhoramos a procedure e não precisamos mais entrar com o identificador do aluguel.

## Question - Entendendo a expressão
 Próxima Atividade

Na procedure abaixo criamos uma forma de obter um novo identificador do aluguel:

```SQL
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_44`(vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE,
vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vAluguel VARCHAR(10);
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
        SELECT CAST(MAX(CAST(aluguel_id AS UNSIGNED)) + 1 AS CHAR) INTO vAluguel FROM alugueis;
        CALL calculaDataFinal_43 (vDataInicio, vDataFinal, vDias);
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, 
        vDataFinal, vPrecoTotal);
        SET vMensagem = CONCAT('Aluguel incluido na base com sucesso. - ID ' , vAluguel) ;
        SELECT vMensagem;
    WHEN vNumCliente > 1 THEN
       SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
       SELECT vMensagem;
    END CASE;
END
```

Em sistemas de gerenciamento de banco de dados, como o MySQL, é comum a necessidade de gerar um identificador único (ID) para novas entradas de dados. A expressão SELECT CAST(MAX(CAST(aluguel_id AS UNSIGNED)) + 1 AS CHAR) INTO vAluguel FROM alugueis; demonstra uma maneira de calcular automaticamente o próximo ID para um novo aluguel. Esta expressão é especialmente útil quando não se pode ou não se quer usar o auto_increment.

Diante desse cenário, o que a expressão abaixo  realiza na tabela alugueis? 
```SQL
SELECT CAST(MAX(CAST(aluguel_id AS UNSIGNED)) + 1 AS CHAR) INTO vAluguel FROM alugueis;

```
Selecione uma alternativa

- ( )Converte todos os aluguel_id para texto antes de selecionar o valor máximo e armazenar em vAluguel.


- ( )Converte o maior aluguel_id existente em um número, soma 1, e então converte o resultado de volta para texto, armazenando-o em vAluguel.


- ( )Subtrai 1 do menor aluguel_id encontrado na tabela alugueis e armazena o resultado em vAluguel.


- ( )Insere diretamente um novo registro na tabela alugueis com o próximo aluguel_id.





https://github.com/kirenz/datasets/blob/master/us_counties_2010.csv