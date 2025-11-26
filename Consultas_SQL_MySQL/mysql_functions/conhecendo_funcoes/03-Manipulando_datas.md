# Analisando campos do tipo data
Sabemos que existem campos do tipo data em algumas das nossas tabelas. Vamos buscá-los, mais especificamente, na tabela de aluguéis com a seguinte consulta:

```sql
SELECT * FROM alugueis;
```
```
aluguel_id	cliente_id	hospedagem_id	data_inicio	    data_fim	preco_total
1	        1	        8450	            2023-07-15	2023-07-20	3240.00
10	        10	        198	                2022-12-18	2022-12-21	2766.00
100	        100	        4019	            2022-07-26	2022-07-28	452.00
1000	    1000	    5108	            2023-01-25	2023-01-29	3704.00
10000	    1000	    8802	            2023-12-20	2023-12-23	708.00
```
Após executar a seleção de todos os campos da tabela de aluguéis, conferimos que existe a informação de data_inicio e data_fim, ou seja, quando um hóspede entrou e saiu daquele imóvel.

Contudo, também seria interesse e prático se tivéssemos a informação de dias em que essa pessoa ficou hospedada. Vamos extrair essa informação a partir desses dois campos do tipo de data.

## Retornando a data atual
Existem diversas funções que podemos utilizar para trabalhar com datas. Temos uma função que extrai a diferença de dias entre duas datas, mas começaremos apresentando uma função que nos retorna a data atual.

Basta escrever `SELECT` e a `função NOW()`, que significa "**agora**" em português. Inclusive, podemos colocar DATAATUAL como alias e finalizar com um ponto e vírgula.
```sql
SELECT NOW() DATAATUAL;
```
```
DATAATUAL
2024-03-01 08:37:05
```
Ao executar, é retornada a data atual do momento de gravação da aula. Quando você for executar essa consulta, vai aparecer para você a data e hora do momento em que você está executando essa consulta.

A função `NOW()` é bem útil quando precisamos calcular a diferença entre a data atual e uma determinada data. Por exemplo, para calcular a idade de uma pessoa. Bastaria utilizar a data de nascimento da pessoa e a data atual.

## Calculando a diferença entre datas
Mas, não é essa função que precisamos usar agora. Queremos calcular, sim, a diferença entre dias, mas de duas datas que já conhecemos, `data_inicio` e `data_fim`.

O primeiro passo é fazer um SELECT de `data_fim` e `data_inicio` da tabela alugueis. Ao executar essa consulta, serão retornadas essas duas informações.

```sql
SELECT data_fim, data_inicio FROM alugueis;
```
```
data_fim	data_inicio
2023-07-20	2023-07-15
2022-12-21	2022-12-18
2022-07-28	2022-07-26
2023-01-29	2023-01-25
2023-12-23	2023-12-20
```

Qual a função que podemos utilizar para fazer este cálculo de diferença entre dias? É a função ``DATEDIFF`()`.

Devemos passar uma data fim e uma data início para que a função `DATEDIFF`() nos retorne a quantidade de dias entre essas duas datas.

Então, devemos passar no SELECT a função `DATEDIFF`() englobando as datas que serão seus dois parâmetros. Inclusive, podemos passar TotalDias como um alias.

```sql
SELECT DATEDIFF(data_fim, data_inicio) AS TotalDias FROM alugueis;
```
```
TotalDias
5
3
2
4
3
```

Mas, por que colocamos primeiro a data_fim e depois a data_inicio? Porque a função irá fazer uma subtração. Se invertermos os parâmetros, e começamos pela data de início, o resultado vai ficar negativo. Afinal, estaremos subtraindo um valor maior de um valor menor.

## Identificando a clientela
Agora, vamos trazer mais uma informação nessa consulta. Além do total de dias, queremos identificar a pessoa cliente que ficou hospedada essa quantidade de dias nos imóveis.

Para isso, precisamos fazer um JOIN com a tabela de clientes, onde temos os nomes de cada cliente no campo cliente_id.

Após o FROM alugueis, retiramos o ponto e vírgula e escrevemos JOIN clientes. Em seguida, daremos apelidos para ambas as tabelas, alugueis como a e clientes como c.

Já sabemos que os campos em comum que usaremos de base para fazer o JOIN são denominados cliente_id. Com a clásula ON, definiremos que a.cliente_id será igual a c.cliente_id. Não esqueça de finalizar com ponto e vírgula.

Por fim, podemos buscar o nome passando-o em SELECT. Nesse caso, usamos o TRIM(nome) para evitar espaços desnecessários e o alias Nome.

```sql
SELECT TRIM(nome) AS Nome, `DATEDIFF`(data_fim, data_inicio) AS TotalDias
FROM alugueis a
JOIN clientes c
ON a.cliente_id = c.cliente_id;
```
```
Nome	                TotalDias
João Miguel Sales	    5
Cauã da Mata	        3
Júlia Pires	            2
Srta Clara Jesus	    4
Ana Vitória Caldeira	3
```

Essa consulta resultou no nome e o total de dias que cada uma dessas pessoas ficaram hospedadas em algum imóvel da Insight Place.

## Agrupando total de dias por tipo de hospedagem
Ainda podemos montar outros tipos de consultas interessantes em cima da diferença entre os dias de hospedagem.

Ao invés de trazer o total de dias por cada cliente, poderíamos trazer o total de dias por tipo de hospedagem com base na relação entre aluguéis e hospedagem que exploramos anteriormente.

Para fazer isso, utilizaremos a função` JOIN()` para unir essas tabelas e identificar onde as pessoas clientes mais ficam hospedadas.

Na consulta anterior, vamos apagar as linhas de `JOIN` e `ON` para retirar as menções de cliente, porque queremos colocar dados de hospedagem. No lugar, vamos colocar um JOIN hospedagem com alias h.

Também vamos informar os campos em comum, ambos chamados hospedagem_id. Basta digitar ON a.hospedagem_id será igual a h.hospedagem_id.

E quais são as informações que vamos retornar? No lugar de retornar TRIM(nome) no SELECT, queremos retornar a informação de tipo.

Ao final da consulta, também vamos agrupar o resultado por tipo utilizando a cláusula GROUP BY.

```sql
SELECT tipo, `DATEDIFF`(data_fim, data_inicio) AS TotalDias
FROM alugueis a
JOIN hospedagens h
ON a.hospedagem_id = h.hospedagem_id
GROUP BY tipo;
```

Contudo, se executamos a consulta dessa forma, o resultado não será apresentado.
```
Error Code: 1055. Expression #2 of SELECT list is not in GROUP BY clause and contains nonaggregated column
```
Tivemos um erro de retorno, porque não temos nenhuma função de agregação, afinal não estamos agregando os valores. A única função que utilizamos é uma função de data.

Por isso, precisamos ter uma função de agregação nessa consulta. Antes da função `DATEDIFF`(), vamos passar a função SUM() para somar a quantidade de dias e agrupar essa somatória pelo tipo.

```sql
SELECT tipo, SUM(`DATEDIFF`(data_fim, data_inicio)) AS TotalDias
FROM alugueis a
JOIN hospedagens h
ON a.hospedagem_id = h.hospedagem_id
GROUP BY tipo;
```
```
tipo	    TotalDias
hotel	    13698
casa	    13143
apartamento	12924
```
Agora, sim, temos o total de dias que todos os hóspedes ficam hospedados para cada tipo de imóvel. Dessa maneira, descobrimos que o imóvel mais procurado ainda é o hotel.

## Para saber mais
As funções nativas da linguagem SQL no MySQL oferecem um conjunto poderoso de ferramentas para realizar uma ampla gama de operações de manipulação de dados, desde transformações simples até cálculos complexos e análises de dados. Essas funções abrangem diversas categorias, incluindo manipulação de strings, operações numéricas, tratamento de datas e horas, além de funções de agregação. A seguir, você pode explorar os exemplos de algumas dessas funções, juntamente com o destaque de suas vantagens.

Exemplos de funções nativas e suas vantagens
Funções de String

CONCAT():

Exemplo: SELECT CONCAT('Hello', ', ', 'World!');
Vantagem: Facilita a junção de duas ou mais strings, útil para construir saídas de texto dinâmicas.
UPPER() e LOWER():

Exemplo: SELECT UPPER('hello'), LOWER('WORLD');
Vantagem: Permite a padronização da capitalização de strings, essencial para comparações insensíveis à caixa.
Funções de Data e Hora

NOW():

Exemplo: SELECT NOW();
Vantagem: Fornece o momento atual, essencial para registrar timestamps de eventos.
`DATEDIFF`():

Exemplo: SELECT `DATEDIFF`('2024-12-31', '2024-01-01');
Vantagem: Calcula a diferença entre duas datas, importante para cálculos de períodos.
Funções de Agregação

COUNT():

Exemplo: SELECT COUNT(*) FROM users;

Vantagem: Conta o número de linhas em uma tabela, vital para análises quantitativas.

SUM():

Exemplo: SELECT SUM(salary) FROM employees;
Vantagem: Calcula a soma total de uma coluna numérica, fundamental para relatórios financeiros.
Vantagens gerais das funções nativas
Eficiência: O desempenho das operações é otimizado pelo SGBD através das funções nativas, garantindo rapidez e eficiência.
Simplicidade: As consultas complexas são simplificadas, tornando o código mais legível e fácil de manter.
Portabilidade: O uso de funções padrão SQL melhora a compatibilidade e a portabilidade entre diferentes sistemas de gerenciamento de banco de dados.
Flexibilidade: Oferecem soluções flexíveis para uma ampla gama de necessidades de manipulação de dados, desde tarefas simples até análises complexas.
Dominar as funções nativas do SQL no MySQL permite aos desenvolvedores e analistas de dados explorar plenamente o potencial de seus dados, realizando operações complexas de forma mais intuitiva e eficiente.