# Passagem de Parâmetro por Referência


Para melhorar o código, podemos segmentar a procedure em partes. O trecho que implementamos no vídeo anterior, que faz o cálculo da data final pulando os fins de semana, poderia estar isolado em outra procedure. Assim, a procedure principal chamaria essa outra para calcular a data.

Poderíamos remover o trecho de código que começa em SET vContador e termina em END WHILE do código principal. Assim, reduziríamos a quantidade de linhas, facilitando a manutenção.

Para isso, teríamos que passar para a outra procedure os parâmetros. O parâmetro da data final entrará nessa procedure, portando, de alguma maneira, o resultado tem que voltar para o programa principal. Afinal, se passarmos como parâmetro, mas não recebermos de volta o valor, não terá ajudado em nada.

Podemos fazer isso, pois quando criamos um parâmetro na procedure, podemos passá-lo como valor ou como referência. Quando passamos como valor, passamos um valor para a procedure e o valor é utilizado internamente.

Quando passamos por referência, se passarmos esse parâmetro dessa maneira, ele será alterado na procedure e, quando a procedure terminar, esse valor volta para nós alterado.

Então, basta criarmos uma procedure que calcule a data final, passando a variável vDataFinal como referência para essa procedure e, quando ela voltar para o programa principal, poderemos usá-la. Faremos isso!

# Criando a procedure calculaDataFinal_13

Primeiro, copiamos o trecho de código que começa em SET vContador e termina em END WHILE. Depois, na lateral esquerda, em Schemas, clicamos com o botão direito em "Stored Procedures" e depois em "Create Stored Procedure". Colamos o código e arrumamos a indentação.

```sql
CREATE PROCEDURE `new_procedure` ()
BEGIN

SET vContador = 1;
SET vDataFinal vDataInicio;
WHILE vContador < vDias
DO

        SET vDiaSemana (SELECT DAYOFWEEK(STR_TO_DATE(vDataFinal, `%Y-%m-%d`)));
        IF (vDiaSemana <> 7 AND vDiaSemana <> 1) THEN
            SET vContador vContador + 1;
        END IF;
        SET vDataFinal (SELECT vDataFinal + INTERVAL 1 DAY) ;

END WHILE;
END
```

Agora, precisamos declarar algumas variáveis, pois vDiaSemana e vContador são variáveis declaradas na procedure principal. Então, abaixo de BEGIN, escrevemos DECLARE vContador INTEGER; seguido de DECLARE vDiaSemana INTEGER;.

Na primeira linha, mudamos de new_procedure para calculaDataFinal_43. Porém, vDdataFinal, vDataInicial e vDias virão da procedure principal e precisam voltar para ela. Isso porque precisamos delas na procedure principal para inserir dentro da tabela de aluguéis.

Então, vamos declará-las como parâmetros na primeira linha. Nos parênteses, passamos vDataInício DATE, vDataFinal DATE, vDias INTEGER. Se fizermos isso, alteraremos o valor da vDataFinal, porém, quando voltarmos à procedure principal, ele voltará sem o valor alterado.

Como queremos que esta variável volte para a procedure principal com o valor alterado, colocamos antes de vDataFinal o código INOUT. Ao fazer isso, estamos passando esta variável como referência, enquanto vDataInício e dias, que não serão alteradas no código, passamos como valor.

Não se altera o valor quando voltamos para a procedure principal. Quando passamos por referência, volta para a procedure principal.

O código fica da seguinte forma:

```sql
CREATE PROCEDURE `calculaDataFinal_13` (vDataInicio DATE, INOUT vDataFinal DATE, vDias INTEGER)
BEGIN
DECLARE vContador INTEGER;
DECLARE vDiaSemana INTEGER;
SET vContador = 1;
SET vDataFinal vDataInicio;
WHILE vContador < vDias
DO
        SET vDiaSemana (SELECT DAYOFWEEK(STR_TO_DATE(vDataFinal, `%Y-%m-%d`)));
        IF (vDiaSemana <> 7 AND vDiaSemana <> 1) THEN
            SET vContador = vContador + 1;
        END IF;
        SET vDataFinal (SELECT vDataFinal + INTERVAL 1 DAY);
END WHILE;
END
```

Feito isso, na lateral direita da tela, logo abaixo do campo de código, clicamos em `"Apply"`. Assim, temos a calculaDataFinal_43 e a encontramos na lateral esquerda da tela, em Schemas.

### Criando e ajustando a procedure no banco de dados
Copiamos a última versão da procedure, criamos um novo script e colamos. Agora, comentaremos todo o trecho de código que começa em SET vContador e termina em END WHILE, pois não precisaremos mais. Ao fazer isso, mantemos o histórico do que fizemos.

Na linha acima de SET vPrecoTotal, escrevemos CALL calculaDataFinal43 (). Como parâmetro, passamos vDataInicio, vDataFinal, vDias. Depois, próximo do início de código, apagamos as variáveis vContador e vDiaSemana. Como comentamos o código do looping e ele está na sub-rotina, essas declarações não são mais necessárias.

Se quiséssemos, poderiamos pegar outros trechos do programa e criar subrotinas. Nesse caso, fizemos isso apenas para este exemplo, para termos um modelo. Depois, se você quiser, pode melhorar o código dessa procedure.

Agora, no início do código, na linha 2 e 5, mudamos para novoAluguel_43. Selecionamos todo o código e executamos.

```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_13`;
DELIMITER $$
USE `insightplaces` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_13`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE, vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR(10);
    DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL (10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE
    WHEN vNumCliente = 0 THEN
        SET vMensagem 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN vNumCliente > 1 THEN

        CALL calculaDataFinal13 (vDataInicio, vDataFinal, vDias);
        SET vPrecoTotal vDias vPrecoUnitario;
        SELECT cliente_id INTO vCliente FROM clientes WHERE nome vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem `Aluguel incluido na base com sucesso.`;
        SELECT vMensagem;
    WHEN vNumCliente > 1 THEN
        SET vMensagem = `Este cliente não pode ser usado para incluir o aluguel porque não existe.`;
        SELECT vMensagem;
    END CASE;
END$$
DELIMITER ;
```

Assim a procedure é gerada com sucesso. Agora, incluiremos mais um aluguel. No fim do código, escrevemos e executamos.

```sql
CALL novoAluguel_43 ('10011', 'Livia Fogaça', '8635', '2023-04-20,10,40);
```
Feito isso, no retorno temos uma mensagem de erro dizendo que a procedure calculaDataFinal43 não existe. O nome correto é calculaDataFinal_43, então, fazemos essa correção na linha 38 e executamos novamente.

```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`. `novoAluguel_13`;
DELIMITER $$
USE `insightplaces` $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_13`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE, vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR(10);
    DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL (10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente (SELECT COUNT(*) FROM clientes WHERE nome ClienteNome);
    CASE
    WHEN vNumCliente > 1 THEN
        SET vMensagem 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN vNumCliente > 1 THEN

        CALL calculaDataFinal_43 (vDataInicio, vDataFinal, vDias);
        SET vPrecoTotal vDias vPrecoUnitario;
        SELECT cliente_id INTO vCliente FROM clientes WHERE nome= vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET VMensagem `Aluguel incluido na base com sucesso.`;
        SELECT vMensagem;
    WHEN vNumCliente > 1 THEN
        SET vMensagem = `Este cliente não pode ser usado para incluir o aluguel porque não existe.`;
        SELECT vMensagem;
    END CASE;
END$$
DELIMITER ;
```

Assim, é exibida a mensagem dizendo que o aluguel foi incluído na base com sucesso. Para conferir, passamos o código SELECT * FROM alugueis WHERE aluguel_id = '10011' e executamos.

```sql
SELECT * FROM alugueis WHERE aluguel_id = '10011'
```
Assim, temos o retorno abaixo:


    aluguel_id	cliente_id	hospedagem_id	data_inicio	data_fim	preco_total
    10011	    1015	    8635	        2023-04-12	2023-05-03	400.00
    Null	    Null	    Null	        Null	    Null	    Null
A pessoa hóspede entrou no dia 20 de abril e saiu no dia 03 de maio, sendo dez dias no total, incluindo sábado e domingo. O valor monetário foi de 400.


## Question - Criando a Procedure de inclusão de cliente


Analise uma procedure isolada apenas para o cálculo da data final realizada em aula:

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `calculaDataFinal_43`(vDataInicio DATE, INOUT vDataFinal DATE, vDias INTEGER)
BEGIN
DECLARE vContador INTEGER;
DECLARE vDiaSemana INTEGER;
SET vContador = 1;
SET vDataFinal = vDataInicio;
WHILE vContador < vDias
DO
       SET vDiaSemana = (SELECT DAYOFWEEK(STR_TO_DATE(vDataFinal,'%Y-%m-%d')));
       IF (vDiaSemana <> 7 AND vDiaSemana <> 1) THEN
           SET vContador = vContador + 1;
       END IF;
       SET vDataFinal = (SELECT vDataFinal + INTERVAL 1 DAY) ;
END WHILE;       
END
Copiar código
Depois, incluímos a chamada desta procedure na procedure principal da inclusão de alugueis:

CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_43`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE,
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
        -- SET vDataFinal = (SELECT vDataInicio + INTERVAL vDias DAY) ;
        -- SET vContador = 1;
        -- SET vDataFinal = vDataInicio;
        -- WHILE vContador < vDias
        -- DO
        --    SET vDiaSemana = (SELECT DAYOFWEEK(STR_TO_DATE(vDataFinal,'%Y-%m-%d')));
        --    IF (vDiaSemana <> 7 AND vDiaSemana <> 1) THEN
        --        SET vContador = vContador + 1;
        --    END IF;
        --    SET vDataFinal = (SELECT vDataFinal + INTERVAL 1 DAY) ;
        -- END WHILE;
        
        CALL calculaDataFinal_43 (vDataInicio, vDataFinal, vDias);
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

Para aprimorar a modularidade e reusabilidade do código na gestão de aluguéis, identificou-se uma oportunidade de isolar a lógica de cálculo do preço total e a inserção de dados na tabela de aluguéis em uma stored procedure separada, denominada inclusao_cliente_43. Este trecho de código desempenha um papel crucial no registro de novos aluguéis e precisa ser reorganizado para melhor manutenção e clareza.

Como você criaria a stored procedure inclusao_cliente_13 para encapsular o cálculo do preço total e a inserção na tabela de aluguéis, e qual seria a forma correta de chamá-la na procedure principal novoAluguel_13?


- ( ) Criar inclusao_cliente_13 com parâmetros vAluguel, vClienteNome, vHospedagem, vDataInicio, vDataFinal, vDias, vPrecoUnitario e chamar usando CALL inclusao_cliente_43(vAluguel, vClienteNome, vHospedagem, vDataInicio, vDataFinal, vDias, vPrecoUnitario);.



- ( ) Criar inclusao_cliente_13 sem parâmetros e chamar dentro de novoAluguel_43 usando CALL inclusao_cliente_43();.



- ( ) Criar inclusao_cliente_13 apenas com o parâmetro vPrecoUnitario e chamar dentro de novoAluguel_43 com CALL inclusao_cliente_43(vPrecoUnitario);.



- ( ) Criar inclusao_cliente_13 e incluir lógica não relacionada ao cálculo de preço ou inserção de aluguéis, chamando-a sem parâmetros.



- ( ) Criar inclusao_cliente_13 apenas com o parâmetro vDias para calcular vPrecoTotal e chamar dentro de novoAluguel_13 usando CALL inclusao_cliente_13(vDias);.