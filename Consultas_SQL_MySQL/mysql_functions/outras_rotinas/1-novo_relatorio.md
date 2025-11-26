# Criando um novo relatório
Já conhecemos algumas formas diferentes de trabalhar com funções, criando funções mais simples, funções com variáveis e até funções em que passamos parâmetros. Mas não vamos parar por aqui.

Recebemos uma nova demanda da gestão da Insight Places. Eles querem que montemos uma consulta bem específica, pois, a partir de agora, o foco da empresa é atrair novos clientes para a base de dados e também fidelizar os clientes que já possuem.

Para isso, resolveram criar uma nova política de desconto. Esse desconto será disponibilizado para aqueles clientes que passarem mais de 4 dias hospedados em algum imóvel.

Vamos, então, criar uma nova consulta baseada nas informações passadas para nós acerca dessa nova política:

Se o cliente passar de 4 a 6 dias, ele tem direito a 5% de desconto.
Se o cliente passar de 7 a 9 dias, ele tem direito a 10% de desconto.
Se o cliente passar 10 dias ou mais, ele tem direito a 15% de desconto.
Se o cliente passar menos de 4 dias, ele não terá nenhum tipo de desconto.
Abriremos uma nova aba do MySQL para traduzir essas informações em consulta.

## Categorizando clientes por desconto
Como temos uma questão de categorização nessas informações, podemos utilizar o CASE para validar as informações. Mas antes de chegarmos no CASE, precisamos buscar alguns dados.

Os dados de dias e valores estão na nossa tabela de alugueis. Então, vamos montar um SELECT na tabela de aluguéis e executar:
```sql
SELECT * FROM alugueis;
```
Temos como resultado os IDs de aluguel, cliente e hospedagem, e a data de início, data de fim e o preço total.
```
aluguel_id	cliente_id	hospedagem_id	data_inicio	data_fim	preco_total
1	1	8469	2022-07-15	2022-07-20	3240.00
10	10	198	2022-12-18	2022-12-21	2766.00
100	100	4919	2022-07-26	2022-07-28	452.00
1000	1000	5188	2022-01-25	2022-01-29	3784.00
10000	10000	8802	2023-12-20	2023-12-23	708.00
```
Em cima disso, vou montar a consulta que categoriza os clientes em dias de hospedagem.

Quais são as informações que queremos puxar da nossa tabela de aluguéis? Primeiro vamos buscar o cliente_id, porque queremos identificar a qual cliente o aluguel pertence, pois o desconto será para o cliente.

Queremos também a data_inicio e a data_fim. Mas, além disso, seria muito interessante calcular a diferença de dias entre essas duas datas, porque é justamente essa a informação que precisamos, já que o desconto será aplicado conforme a quantidade de dias que o cliente passou hospedado.

Para calcular essa informação, vamos usar a função DATEDIFF(), passando para ela a data_inicio e a data_fim. Vamos nomear esse cálculo como TotalDias.

Nossa seleção ficará assim:

```sql
SELECT
    cliente_id,
    data_inicio,
    data_fim,
    DATEDIFF(data_fim, data_inicio) AS TotalDias
FROM alugueis
```
Se executarmos essa consulta, teremos justamente o ID do cliente, a data de início da hospedagem, a data de fim e a diferença de dias entre as datas de início e fim de hospedagem de cada cliente:

```
cliente_id	data_inicio	data_fim	TotalDias
1	        2022-07-15	2022-07-20	    5
10	        2022-12-18	2022-12-21	    3
100	        2022-07-26	2022-07-28	    2
1000	    2023-01-25	2023-01-29	    4
10000	    2023-12-20	2023-12-23	    3
```

Mas isso ainda não é tudo o que precisamos. Com base no 
total de dias, agora precisamos validar essa informação, ou seja, aplicar os descontos.

Vamos, então, continuar nossa consulta, adicionando uma vírgula após TotalDias para passar o CASE WHEN.

Aqui passaremos justamente o DATEDIFF() que criamos no SELECT. Depois, adicionamos o BETWEEN, uma função para trabalhar com diferença entre números.

Primeiro, queremos saber se esse cálculo resulta num número entre 4 e 6, então podemos passar o BETWEEN 4 AND 6. Então, passamos o THEN ("então") para aplicar os 5% de desconto. Isso resulta em: WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 4 AND 6 THEN 5.

Usaremos essa mesma estrutura para os outros tipos de desconto e, no final, adicionamos um ELSE igual a zero. Ou seja, se não for nenhum dos valores acima (qualquer número maior que 4), o desconto será de 0%.

Por fim, fechamos o CASE com a cláusula END e nomeamos toda essa estrutura como DescontoPercentual.

```sql
SELECT
    cliente_id,
    data_inicio,
    data_fim,
    DATEDIFF(data_fim, data_inicio) AS TotalDias,
    CASE
        WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 4 AND 6 THEN 5
        WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 7 AND 9 THEN 10
        WHEN DATEDIFF(data_fim, data_inicio) >= 10 THEN 15
        ELSE 0
    END AS DescontoPercentual
FROM alugueis;
```
Vamos selecionar e executar essa consulta. Receberemos o seguinte retorno:
```
cliente_id	data_inicio	data_fim	TotalDias	DescontoPercentual
1	2022-07-15	2022-07-20	5	5
10	2022-12-18	2022-12-21	3	0
100	2022-07-26	2022-07-28	2	0
1000	2023-01-25	2023-01-29	4	5
10000	2023-12-20	2023-12-23	3	0
...	...	...	...	...
1008	2023-12-18	2023-12-25	7	10
```
`Entre 4 e 6 dias de hospedagem, o cliente teve 5%. Abaixo de 4, zero desconto. Entre 7 e 10 dias, 10%`.

Já conseguimos calcular exatamente a quantidade de desconto que os clientes vão receber. Podemos até aplicar um filtro WHERE ao final da consulta para puxar aluguéis específicos que queremos verificar, um por vez, usando o aluguel_id. Por exemplo, vamos puxar o aluguel de ID igual a 1:

```SQL
-- código omitido
WHERE aluguel_id = 1;
```

Sabemos que o cliente de ID número 1 ficou 5 dias hospedado, então está eleito a um desconto de 5%:

>Resultado da consulta
```
cliente_id	data_inicio	data_fim	TotalDias	DescontoPercentual
1	2022-07-15	2022-07-20	5	5
```
Função para calcular desconto de clientes específicos
Agora vamos transformar a consulta que criamos em uma função. Para isso, vamos usar o CREATE FUNCTION e dar um nome para essa função, que pode ser `CalcularDescontoPorDias`.

Vamos retornar (RETURN) um número inteiro (INT) e definir um DETERMINISTIC. Depois fazemos um BEGIN e um END, além de adicionar o DELIMITER $$ antes da criação da função, para não esquecer, e também ao final, e adicionar $$ no END para delimitar o corpo da função.

```SQL
DELIMITER $$

CREATE FUNCTION CalcularDescontoPorDias()
RETURNS INT DETERMINISTIC
BEGIN

END$$

DELIMITER ;
```

Vamos colocar toda a nossa consulta anterior entre o BEGIN e o END.

O primeiro passo para transformar essa consulta em função será transformar o ID do aluguel em WHERE num parâmetro a ser recebido pela função.

Esse parâmetro pode ser chamado AluguelID e será um número inteiro (INT), resultando em CREATE FUNCTION CalcularDescontoPorDias(AluguelID INT).

Também precisamos passar esse parâmetro no lugar do 1 em WHERE, resultando em WHERE aluguel_id = AluguelID.

Agora precisamos armazenar esse desconto calculado em uma variável, pois precisamos desse valor salvo em algum lugar. Vamos declarar a variável Desconto usando a cláusula DECLARE, cujo tipo será INT, resultando em DECLARE Desconto INT.

Em seguida, após o END, vamos passar o INTO Desconto. Ou seja, vamos inserir tudo o que está dentro do CASE na variável Desconto

Também vamos remover do SELECT os campos que selecionamos da tabela alugueis e o cálculo de dias. Afinal, uma função retorna um único valor por vez. Nesse caso, esse valor será o desconto percentual do aluguel específico que passarmos na chamada da nossa função.

Por fim, após o WHERE, precisamos informar o que queremos retornar, que será o Desconto. Nossa função ficará assim:

```SQL
DELIMITER $$
CREATE FUNCTION CalcularDescontoPorDias(AluguelID INT)
RETURNS INT DETERMINISTIC

BEGIN
DECLARE Desconto INT;
SELECT
        CASE
                WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 4 AND 6 THEN 5
                WHEN DATEDIFF(data_fim, data_inicio) BETWEEN 7 AND 9 THEN 10
                WHEN DATEDIFF(data_fim, data_inicio) >= 10 THEN 15
                ELSE 0
        END
        INTO Desconto
FROM alugueis
WHERE aluguel_id = AluguelID;
RETURN Desconto;
END$$

DELIMITER ;
```

Em suma, criamos uma função com o método CREATE FUNCTION, para a qual passamos o AluguelID, solicitando-o como parâmetro. Retornamos um número inteiro e DETERMINISTIC, então abrimos o corpo da função com o BEGIN e fechamos com o END.

Dentro dessa função, declaramos uma variável para armazenar o desconto, fizemos um SELECT calculando os dias de hospedagem do cliente e atribuindo descontos a depender do resultado. Inserimos esse resultado na variável Desconto.

Depois fizemos um filtro no campo aluguel_id para receber apenas o valor recebido na função como AluguelID, parâmetro que passamos ao chamar a nossa função. Então retornamos Desconto para exibir apenas o valor de desconto do aluguel em questão.

Vamos executar essa função e depois chamá-la, passando o ID 1 de aluguel:
```SQL
SELECT CalcularDescontoPorDias(1);
```

Ao executar esse comando, temos justamente o retorno que tivemos ao executar a nossa consulta: o cliente do aluguel 1 está eleito a 5% de desconto.

### Resultado da consulta
```
cliente_id	data_inicio	data_fim	TotalDias	DescontoPercentual
1	2022-07-15	2022-07-20	5	5
```

Já montamos a nossa consulta, já conseguimos montar também a nossa função, mas agora precisamos aplicar esse desconto no total do valor que o cliente pagou.

