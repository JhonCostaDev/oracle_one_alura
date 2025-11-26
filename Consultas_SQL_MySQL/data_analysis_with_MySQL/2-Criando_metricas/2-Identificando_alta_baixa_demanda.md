#  IDENTIFICANDO PERIODOS DE BAIXA E ALTA DEMANDA

Transcrição

Conseguimos construir métricas focadas na pessoa proprietária, permitindo que ela compreenda bem a sua realidade atual na plataforma. Porém, será que podemos fornecer uma visão geral para ela?

Informações como, por exemplo, a região onde os aluguéis ocorrem, impactam nos dados? E a época do ano? Imóveis são alugados com mais frequência em determinados meses?

Apresentar esse quadro geral, em que a pessoa proprietária visualiza como funciona toda a plataforma, pode auxiliar muito na tomada de decisões, como reduzir o valor em uma época do ano, ou aumentar o valor do aluguel quando a demanda estiver alta. Essas informações serão muito relevantes para as pessoas proprietárias, e este será o nosso próximo passo na análise.
## Identificando períodos de baixa e alta demanda

Como podemos usar nossos dados para fazer um cálculo pelo tempo, por exemplo? Temos as informações dos aluguéis com a data de início e a contagem de aluguéis, isto é, quando e a quantidade de aluguéis que ocorreram.

Podemos utilizar funções que já exploramos, como a função de agregação `MIN()`, mas existem outras funções, como as de data, com as quais conseguimos extrair informações de determinada data.

## Realizando uma nova consulta

Para isso, preparamos a seguinte consulta:

```sql
-- código omitido

SELECT
    YEAR(data_inicio) AS ano,
    MONTH(data_inicio) AS mes,
    COUNT(*) AS total_alugueis
FROM
    alugueis
GROUP BY
    ano, mes
ORDER BY
    ano, mes;

```
Primeiramente, temos a informação de data_inicio, que vem da tabela alugueis e exploramos bastante para calcular a taxa de ocupação, mas agora, nosso interesse não é nela como um todo, pois ela contém dia, mês e ano. Queremos extrair partes dessa informação.

Existe uma função chamada` YEAR()`, para a qual passamos uma data e ela extrai o ano. De maneira similar, temos a função` MONTH()`, responsável por fazer a extração do mês dessa data.

Queremos extrair essas duas informações, e conforme dito anteriormente, nosso objetivo é fazer uma contagem. Para isso, usamos a função `COUNT()` logo abaixo. O que queremos contar com essa função? Não parece fazer sentido contar todas as linhas, então precisamos pensar em um agrupamento.

De que maneira a tabela alugueis pode trazer o insight de que há épocas do ano com mais ou menos aluguéis? Através do `GROUP BY` nas novas colunas que criamos, ou seja, `ano e mes`.

Portanto, coletamos todas as hospedagens existentes, focamos em 2022, por exemplo, e contamos todos esses dados. Se tivermos 20 registros, por exemplo, então houve 20 hospedagens em 2022.

Faremos esse agrupamento por ano e por mês. Com isso, conseguiremos construir uma série temporal em formato de tabela e entender se os dados sobem ao longo do ano, ou seja, se há crescimento. Poderíamos fazer uma análise de série temporal com o resultado dessa tabela.



Visualização dos seis primeiros registros da tabela. Para visualizá-la na íntegra, execute a consulta na sua máquina.
```
ano	    mes	total_alugueis
2022	3	363
2022	4	426
2022	5	424
2022	6	417
2022	7	422
2022	8	404
```
A tabela apresentou três colunas: ano, mes e total_alugueis. A ordenação foi por ano e mes. Isso significa que vamos visualizar todos os meses do primeiro ano, depois todos os meses do segundo ano, e assim por diante. Dessa forma, conseguiremos visualizar a passagem do tempo e entender se os aluguéis aumentaram ou diminuíram no decorrer do tempo.

É importante notar que não falamos de dias, ou seja, não recebemos a informação de dias em que determinado imóvel ficou ocupado, mas sim os totais de aluguéis. Por isso temos valores diferentes dos 1000 que recebemos na tabela anterior, referentes a `dias_ocupados`.

Conforme os dados retornados, no mês 3 de 2022, tivemos 363 aluguéis na plataforma. Já em agosto de 2022, tivemos 404 aluguéis, um valor maior. Portanto, em agosto de 2022, tivemos mais aluguéis que em março de 2022. A partir dessa informação, poderemos gerar insights.

Ao rolar para baixo na tabela gerada, conseguiremos acessar os dados até 2024, passando por todos os meses de cada ano. O ano de 2022 começou em março na tabela por ser o primeiro resultado obtido.

Com esses dados, já conseguimos fazer uma análise muito interessante e identificar se é apresentada alguma `sazonalidade` neles. Existem épocas do ano em que os aluguéis acontecem com mais frequência?

Por exemplo: as pessoas alugam mais casas no Natal? No Ano Novo? No final de ano? Ou nas férias escolares de julho? É possível detectar esse tipo de informação a partir dos dados.

## Refatorando a consulta

Uma variação dessa tabela que podemos construir para entender melhor a sazonalidade, seria remover a variável ano e deixar somente a variável mes. Com isso em mente, preparamos a consulta abaixo:

```sql
-- código omitido

SELECT
    MONTH(data_inicio) AS mes,
    COUNT(*) AS total_alugueis
FROM
    alugueis
GROUP BY
    mes
ORDER BY
    total_alugueis DESC;
```

Note que removemos a variável ano, mas mantivemos a variável mes, assim como a função `COUNT()`. Além disso, agora o GROUP BY é feito apenas por mes e o `ORDER BY `por total_alugueis.

Como retorno da consulta, temos a seguinte tabela:

```
mes	total_alugueis
10	875
7	867
3	860
5	849
4	845
6	844
```
Nesse caso, seria importante verificar se há uma representação igual para cada mês, pois em 2022, por exemplo, começamos em março. Recomendamos analisar isso, mas imaginamos que, por padrão, haja mais ou menos 12 meses para cada ano, então a conta que fizemos está equilibrada.

Quais insights podemos obter dessa consulta? Dessa vez, ordenamos por `total_alugueis`, então não é uma série temporal, ou seja, não analisamos através do tempo, mas conseguimos verificar que, de todos os anos acumulados, o mês 10 (outubro) foi quando tivemos mais aluguéis.

A época de final de ano, para a qual chamamos atenção anteriormente, não está tão alta nas posições: os meses 12 (dezembro) e 1 (janeiro) estão nas posições 7 e 8, respectivamente.

No topo da tabela, temos outros meses, como 10 (outubro), 7 (julho), e o próprio mês 3 (março), que mencionamos anteriormente, representando os maiores números de aluguéis.
Conclusão

Dessa forma, conseguimos entender as informações e as pessoas da área de negócios poderão conversar com as pessoas proprietárias para guiar as decisões delas, apresentando os seguintes tipos de dados:

        Setembro é o mês com menos aluguéis. Que tal reduzir os valores para testar se é possível aumentar as vendas neste período?

É muito importante montar estratégias em cima de dados. A segunda visualização é quase a mesma informação que a primeira, mas com certas variações, a partir das quais conseguimos tomar decisões diferentes.



## Question - Estratégias de preço baseadas em dados


Você é um(a) analista de dados na `Insight Places`, uma plataforma que conecta proprietários de imóveis a potenciais inquilinos. Recentemente, a equipe identificou a necessidade de fornecer aos proprietários insights mais detalhados sobre o desempenho de seus alugueis, incluindo a identificação de períodos de alta e baixa demanda para ajustar os preços de forma estratégica.

Utilizando as consultas SQL aprendidas, você foi encarregado(a) de desenvolver uma métrica que permita aos proprietários entender melhor como os preços dos alugueis variam ao longo do ano em diferentes regiões do país.

    Como você criaria uma consulta SQL para ajudar os proprietários a identificar a média de preço por dia de aluguel em cada região do país, permitindo-lhes ajustar seus preços de acordo com a demanda sazonal?

ALTERNATIVA A
```sql
    SELECT r.regiao, AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS media_preco_dia
    FROM alugueis a
    JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
    JOIN enderecos e ON h.endereco_id = e.endereco_id
    JOIN regioes_geograficas r ON r.estado = e.estado
    GROUP BY r.regiao;
```
Esta consulta é correta porque combina as tabelas necessárias para calcular a média de preço por dia de aluguel em cada região, agrupando os resultados por região, o que permite aos proprietários ajustar seus preços com base na demanda regional.


ALTERNATIVA B
```SQL
SELECT r.regiao, MAX(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS max_preco_dia
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN enderecos e ON h.endereco_id = e.endereco_id
JOIN regioes_geograficas r ON r.estado = e.estado
GROUP BY r.regiao;
```

ALTERNATIVA C
```SQL
SELECT MONTH(a.data_inicio) AS mes, AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS media_preco_dia
FROM alugueis a
GROUP BY mes;
```

Esta consulta calcula a média de preço por dia de aluguel por mês, mas não considera as diferenças regionais, o que é crucial para os proprietários que desejam ajustar os preços com base na demanda regional.
Alternativa incorreta


ALTERNATIVA D
```SQL
SELECT e.estado, AVG(a.preco_total) AS media_preco
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN enderecos e ON h.endereco_id = e.endereco_id
GROUP BY e.estado;
```
Embora esta consulta forneça uma média de preço total por estado, ela não calcula a média de preço por dia de aluguel nem agrupa os resultados por região, o que é essencial para análises de demanda sazonal.


ALTERNATIVA E
```SQL
SELECT r.regiao, COUNT(*) AS total_alugueis
FROM alugueis a
JOIN hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN enderecos e ON h.endereco_id = e.endereco_id
JOIN regioes_geograficas r ON r.estado = e.estado
GROUP BY r.regiao;
```
Esta consulta apenas conta o número total de aluguéis por região, sem fornecer informações sobre a média de preço por dia, o que é necessário para análises de ajuste de preço.