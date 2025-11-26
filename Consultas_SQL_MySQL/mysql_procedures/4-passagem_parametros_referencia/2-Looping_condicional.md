# Aplicando o Looping condicional


A empresa Insight Places propôs algo que, inicialmente, não entendemos. Mas, como profissionais de TI temos o propósito de implementar o que é solicitado pelo cliente.

O setor de marketing resolveu fazer uma promoção um pouco estranha. Quando uma pessoa hóspede fizer uma reserva, os dias referentes aos fins de semana, ou seja, sábado e domingo, serão gratuitos.

Sem a promoção, uma pessoa que chega para se hospedar em uma quarta-feira, ficaria então quarta, quinta, sexta, sábado e domingo.

Já, com a promoção, ficaria hospedada até terça-feira, porque sábados e domingos não vão contar como diárias. Isso significa que a pessoa ficará sete dias no apartamento, mas pagará apenas por cinco. Nosso objetivo é fazer isso funcionar.

Se aplicarmos a função INTERVAL para calcular a data final baseada no número de dias não funcionará. Isso porque a INTERVAL pega dias corridos, não testa se é um final de semana ou não. Ela não possui nenhum parâmetro para pular esses dias.

Sendo assim, não poderemos fazer isso. Então, qual alternativa temos? Teremos que fazer um looping. Para isso, teremos um contador que começará com o valor inicial que pode ser 1.

Nisso, faremos o looping, incrementando cada rodada do looping até chegar ao número de diárias. Porém, cada data que formos incrementando dentro do looping, testaremos se é sábado ou domingo. Se for, não incrementamos o contador, como se pulássemos esses dias.

Já, se for diferente de sábado ou domingo, incrementamos o contador e vamos somando a data, até o contador chegar ao número de diárias. Assim, conseguimos saber a data final pulando os sábados e domingos.

E como obtemos o dia da semana baseado em uma data? Vamos descobrir! Começamos criando um novo script. Nele, passamos SELECT DAYOFWEEK(). Como parâmetro, precisamos de uma data do tipo date. Porém, nossas datas dentro de uma SQL, sempre colocamos como string, 2023-01-01, em aspas simples.

Então, precisamos primeiro converter esse string para a data. Então, usaremos a função STR_TO_DATE('2023-01-01','%Y-%m-%d)'.

```sql
SELECT DAYOFWEEK(STR_TO_DATE('2023-01-01','%Y-%m-%d))
```
Essa consulta nos dirá qual é o dia da semana do dia 1º de janeiro de 2023. Se executarmos, temos como retorno o número 1 que se refere ao domingo. Dia 2 é segunda-feira e assim por diante.

Então, no nosso looping, se o dia da semana for 1 ou 7, ou seja, domingo ou sábado, não incrementaremos o contador. Se for diferente de 1 e 7, incrementamos.

## Implementando o loop
Implementaremos esse looping dentro da nossa Stored Procedure. Para isso, copiamos o código da última Stored Procedure que criamos e colamos no novo script.

Na linha e que calculamos vDataFinal, comentamos passando -- no início da linha, pois não calcularemos a data final através do INTERVAL.

Precisamos criar duas novas variáveis, a que fará o papel do contador e a que fará o papel do dia da semana. Então, próximo à linha 13, criamos o DECLARE vContador INTEGER; e o DECLARE vDiaSemana INTEGER;.

```sql
-- Código omitido

BEGIN
    DECLARE vCliente VARCHAR(10);
    DECLARE vContador INTEGER;
    DECLARE vDiaSemana INTEGER;
    DECLARE vDataFinal DATE;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL (10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    
-- Código omitido
```

Abaixo de `WHEN`, inicializaremos o contador passando SET vContador = 1;. Também inicializaremos a data final, que também será incrementada dentro do looping, porém, no início do looping é igual à data inicial.

Sendo assim, passamos SET vDataFinal = vDataInicio. Então, antes de começar o looping, inicializamos o contador e colocamos que a data final é igual à data início.

```sql
-- Código omitido

SET vContador = 1;
SET vDataFinal = vDataInicio

-- Código omitido
```

Agora, faremos o looping dentro do MySQL. Passamos `WHILE <CONDICAO>`, na linha abaixo, DO, seguido de END WHILE. E qual será a condição? Vamos executar o looping até quando o contador for menor que o número de dias, então '< vDias'.

No looping, primeiro testaremos o dia da semana. Então, abaixo de DO, passamos 
```sql
SET vDiaSemana = (SELECT DAYOFWEEK(SRT_TO_DATE(vDataFinal, ''%Y-%m-%d))).
```

Na linha seguinte, faremos um `IF (vDiaSemana <> 7 AND vDiaSemana <> 1)` THEN. Então, se diferir de sábado ou domingo, incrementaremos o contador. Na linha abaixo, passamos SET vContador = vContador + 1; seguido de END IF.

Depois, independente se incrementamos ou não o contador, pegaremos a data final e somar 1, pois estamos em looping. Portanto, abaixo de END IF passamos SET vDataFinal = SEECT vDataFinal + INTERVAL 1 DAY.

```sql
-- Código omitido

SET vContador = 1;
SET vDataFinal vDataInicio;
WHILE vContador < vDias
DO
    SET vDiaSemana (SELECT DAYOFWEEK(STR_TO_DATE(vDataFinal, '%Y-%m-%d')));
    IF (vDiaSemana <> 7 AND vDiaSemana <> 1) THEN
        SET vContador = vContador + 1;
    END IF;
    SET vDataFinal = SEECT vDataFinal + INTERVAL 1 DAY
END WHILE;

-- Código omitido
```

Então, os comandos para calcular a data final, considerando a lógica que passamos, é todo esse trecho de código. Agora, vamos conferir se vai funcionar.

Antes de rodar, na linha 5 e 8, mudamos a rotina para novoAluguel_12. Feito isso, selecionamos todo o código e executamos. Se nos Schemas, clicarmos com o botão direito em "Stored Procedures" e depois em "Refresh All", visualizamos a procedure 12.

Agora, faremos um teste. Passamos a chamada 
```sql
CALL novoAluguel_42('10010','Gabriela Pires', '8635', '2023-04-12',5,40);.
```

Feito isso, abrimos o calendário do computador em abril de 2023. Dia 12 é uma quarta-feira, então até o dia 18 são 5 diárias. A data final do aluguel tem que ser `2023-04-18`.

Agora, selecionamos a linha de código e executamos. Feito isso, temos como retorno a mensagem "Aluguel incluído na base com sucesso. Passamos então o SELECT * FROM aluguei WHERE aluguel_id = '10010';.

```sql
SELECT * FROM alugueis WHERE aluguel_id = '10010';
```
Assim, temos o seguinte retorno:


    aluguel_id	cliente_id	hospedagem_id	data_inicio	    data_fim	preco_total
    10010	    1006	    8635	        2023-04-12	    2023-04-18	200.00
    Null	    Null	    Null	        Null	        Null	    Null

Deu certo, dia 18 de abril de 2023 e a pessoa pagou apenas 200 unidades monetárias, que é o 40 x 5. Ela estava pagando por cinco diárias, entrou no dia 12 e sairá somente no dia 18, pois sábado e domingo não contam. Assim, implementamos o pedido.

## Question - Dias pares e ímpares

Analise a procedure desenvolvida:

```SQL
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_12`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE,
vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR(10);
    DECLARE vContador INTEGER;
    DECLARE vDiaSemana INTEGER;
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

Um trecho específico foi responsável por calcular a data final de um aluguel, considerando apenas os dias úteis da semana (excluindo sábados e domingos).

```sql
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
```

Agora, enfrentamos um novo desafio: ajustar esse cálculo para considerar apenas dias pares do mês como dias válidos de hospedagem. Isso requer uma reavaliação da lógica atual, substituindo a verificação dos dias da semana pela verificação se o dia do mês é par.

Como você reescreveria o trecho da stored procedure para que apenas os dias pares do mês contenham dias válidos de hospedagem, porém, mantenha o restante da lógica intacta? Escolha a alternativa correta.

```sql
Alternativa incorreta
SET vContador = 1;
SET vDataFinal = vDataInicio;
WHILE vContador < vDias DO
    IF DAYOFWEEK(vDataFinal) MOD 2 = 0 THEN
        SET vContador = vContador + 1;
    END IF;
    SET vDataFinal = vDataFinal + INTERVAL 1 DAY;
END WHILE;

```
```sql
SET vContador = 1;
SET vDataFinal = vDataInicio;
WHILE vContador < vDias DO
    SET vDataFinal = vDataFinal + INTERVAL 1 DAY;
    IF DAY(vDataFinal) % 2 = 0 THEN
        SET vContador = vContador + 1;
    END IF;
END WHILE;

```
```sql
SET vContador = 1;
SET vDataFinal = vDataInicio;
WHILE vContador < vDias DO
    SET vDataFinal = vDataFinal + INTERVAL 2 DAY;
    SET vContador = vContador + 1;
END WHILE;

```
```sql
SET vContador = 0;
SET vDataFinal = vDataInicio;
WHILE vContador <= vDias DO
    SET vDataFinal = vDataFinal + INTERVAL 1 DAY;
    IF MOD(DAY(vDataFinal), 2) = 1 THEN
        SET vContador = vContador + 1;
    END IF;
END WHILE;

```
```sql
SET vContador = 1;
SET vDataFinal = vDataInicio;
WHILE vContador < vDias DO
    SET vDiaMes = DAY(vDataFinal);
    IF MOD(vDiaMes, 2) = 0 THEN
        SET vContador = vContador + 1;
    END IF;
    SET vDataFinal = vDataFinal + INTERVAL 1 DAY;
END WHILE;

```
>Esta opção substitui adequadamente a verificação dos dias da semana pela verificação se o dia do mês é par, utilizando MOD(vDiaMes, 2) = 0 para identificar dias pares.