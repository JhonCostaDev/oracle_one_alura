# Análise de Desempenho

Nós somos o time de analistas de dados da Insight Places e atendemos a demanda de auxiliar as pessoas proprietárias dos imóveis alugados em nosso site. Como fazemos isso? Através dos dados.

Já criamos a taxa de ocupação, por exemplo, para entender, dos dias que determinado imóvel esteve disponível, quantos ele ficou ocupado. Essa informação é importante, mas precisamos refiná-la, pois existe a situação em que uma pessoa proprietária pode ter mais de um imóvel.

Será que podemos levar isso em consideração? Além disso, será que podemos tornar essa consulta mais pessoal? Atualmente, nossa consulta informa uma hospedagem_id e outras informações muito relevantes sobre o imóvel, como primeira_data, dias_ocupados, total_dias e taxa_ocupacao.

Seria possível associar isso não à hospedagem, mas sim à pessoa proprietária? Afinal, o foco deste projeto, a pessoa que utilizará nossos insights e consultas será a pessoa proprietária.

Sendo assim, poderíamos deixar isso mais associado a ela e, a partir disso, entender: uma pessoa proprietária na nossa base de dados pode ter mais de um imóvel? Pode alugar mais de uma casa?

Resolveremos essas duas questões com você:

Identificar se existem pessoas proprietárias com mais de um imóvel;
E como transformar a informação da taxa de ocupação, com foco na pessoa proprietária.
Análise de desempenho de proprietário
Criando um novo script
Começaremos criando um novo script. Para isso, no canto superior esquerdo, clicaremos no ícone "SQL +". Nesse novo script, queremos focar na métrica que mencionamos anteriormente.

Primeiramente, vamos explorar se existe essa situação. Para facilitar a exploração das consultas, vamos colar o seguinte código no script e entender por partes como a métrica foi construída:
```sql
USE insightplaces;

SELECT
    p.nome AS proprietario,
    COUNT(DISTINCT h.hospedagem_id) AS total_hospedagens
FROM
    hospedagens h
JOIN
    proprietarios p ON h.proprietario_id = p.proprietario_id
GROUP BY
    p.proprietario_id
ORDER BY
    total_hospedagens DESC;
```

## Analisando o código
O primeiro trecho de código é o USE insightplaces. É importante sempre retomar isso, pois precisamos selecionar o banco de dados que vamos trabalhar no script. Nesse caso, indicamos que é o insightplaces, nosso banco de dados. Dito isso, vamos executar essa consulta.

Não aparecerá nada na tela, mas se clicarmos no segundo ícone do canto superior direito, teremos a indicação no menu "Output" de que foi executado o comando USE insightplaces.

Em seguida, temos a consulta principal, cujo objetivo é entender se temos pessoas proprietárias com mais de um imóvel no banco de dados. Vamos executar o código para visualizar o resultado?

Visualização dos seis primeiros registros da tabela. Para visualizá-la na íntegra, execute a consulta na sua máquina.
```
proprietario	        total_hospedagens
Dra. Kamilly Almeida	2
Fernanda Vieira	        1
Helena Oliveira	        1
Eloah Campos	        1
Eduarda da Mata	        1
Sr. Bruno Carvalho	    1
```
Temos, por exemplo, a informação de que a Dra. Kamilly Almeida possui o total de 2 hospedagens, enquanto o restante tem apenas 1 hospedagem. Como conseguimos esse resultado?

Na consulta, fazemos a seleção (SELECT) da coluna do nome, então usamos p.nome AS proprietario. Em seguida, fazemos uma contagem com a função COUNT() recebendo DISTINCT h.hospedagem_id, isto é, o ID das hospedagens. Chamamos isso de total_hospedagens.

Portanto, usamos uma função de agregação chamada COUNT(). Para utilizá-la, precisamos de um GROUP BY, o qual adicionamos abaixo na consulta, agrupando por pessoa proprietária (p.proprietario_id). Conforme dito anteriormente, nosso objetivo é focar nas pessoas proprietárias.

Sendo assim, pegamos todos os imóveis que tiverem como pessoa proprietária o ID, e agrupamos fazendo essa contagem. Porém, na tabela hospedagens (h) utilizada no bloco FROM, não temos as informações de pessoa proprietária. Para isso, adicionamos o JOIN.

No JOIN, temos a tabela proprietarios, onde está armazenado o nome e o ID da pessoa proprietária. A partir disso, juntamos com a tabela hospedagens através da coluna proprietario_id.

Ambas as tabelas possuem a informação de proprietario_id, e queremos uni-las, de modo que essas informações estejam na mesma linha, e fazemos isso através do JOIN.

Por último, temos a cláusula de total_hospedagens, a qual utilizamos para fazer a ordenação da tabela. Novamente, nosso interesse é saber se existe a situação em que a pessoa proprietária tem mais de um imóvel. Ao executar a consulta, descobrimos que sim: a Dra. Kamilly se enquadra nessa situação.

Foi muito importante identificar isso, porque se trata de uma situação que a nossa regra de negócio permite. Sendo assim, pode ser que na base de dados original, haja mais situações em que isso aconteceu, então devemos considerar esse fato ao construir as métricas.

Revisitando a métrica de taxa de ocupação
Vamos retomar a métrica feita anteriormente sobre a taxa de ocupação (taxa_ocupacao), para considerar agora essa nova informação, de que uma pessoa proprietária pode ter mais de um imóvel.

```sql
-- código omitido
  
SELECT 
  hospedagem_id,
  MIN(data_inicio) AS primeira_data,
  SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
  DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias,
  ROUND((SUM(DATEDIFF(data_fim, data_inicio)) / DATEDIFF(MAX(data_fim), MIN(data_inicio))) * 100) AS taxa_ocupacao

-- código omitido
```
Nessa métrica, calculamos a data de início (data_inicio) utilizando a função MIN(); somamos com a função SUM() as diferenças das datas (data_fim e data_inicio) para calcular os dias em que o imóvel ficou ocupado (dias_ocupados); e a partir dessas datas, calculamos a diferença (DATEDIFF()) para descobrir o total de dias que esse imóvel foi disponível (total_dias).

Depois dividimos o total de dias ocupados (dias_ocupados) pelo total de dias disponíveis (total_dias) para calcular a taxa de ocupação (taxa_ocupacao).

Vamos reutilizar essa conta, pois ela também faz sentido nesse novo cenário, mas combinaremos com a nova consulta criada, onde trazemos as informações da pessoa proprietária.

## Criando uma nova consulta
Novamente, vamos colar o código da nova consulta no script que criamos anteriormente. Feito isso, iremos analisar os comandos por partes.

```sql
-- código omitido

SELECT
    p.nome AS Proprietario,
    MIN(primeira_data) AS primeira_data,
    SUM(total_dias) AS total_dias,
    SUM(dias_ocupados) AS dias_ocupados,
    ROUND((SUM(dias_ocupados) / SUM(total_dias)) * 100) AS taxa_ocupacao
FROM(
    SELECT 
        hospedagem_id,
        MIN(data_inicio) AS primeira_data,
        SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
        DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias
    FROM 
        alugueis
    GROUP BY 
        hospedagem_id
    ) tabela_taxa_ocupacao
JOIN
    hospedagens h ON tabela_taxa_ocupacao.hospedagem_id = h.hospedagem_id
JOIN
    proprietarios p ON h.proprietario_id = p.proprietario_id
GROUP BY
    p.proprietario_id
ORDER BY
    total_dias DESC;
```
Trata-se de uma consulta mais elaborada e extensa, pois utilizamos uma subconsulta, de onde vêm as informações da consulta utilizada na aula anterior.

Nesta consulta, pegamos cada imóvel por hospedagem_id; fazemos o cálculo da primeira_data em que ele ficou disponível; das datas em que ele esteve ocupado, fazemos a soma para obter o total de dias ocupados (dias_ocupados); e por fim, pegamos a última data (data_fim) e a primeira data (data_inicio) de aluguel para descobrir quantos dias ele ficou disponível (total_dias).

Fizemos tudo isso utilizando o GROUP BY para realizar a segregação na coluna hospedagem_id. Dessa forma, para cada uma das hospedagens, descobrimos essas três informações: primeira_data, dias_ocupados e total_dias.

Por que isso virou uma subconsulta? Porque agora já temos essas informações necessárias para o nosso cálculo e queremos trazer a informação da pessoa proprietária.

Na sequência, demos um nome para a tabela gerada: tabela_taxa_ocupacao. Considerando essa tabela, já aprendemos que, se fizermos o JOIN, conseguimos acessar o nome da pessoa proprietária. Portanto, essa é a primeira informação que queremos apresentar: o p.nome AS Proprietario.

Imagine que temos uma pessoa proprietária com dois imóveis e queremos descobrir a data que ela começou a utilizar a plataforma. Para isso, calculamos o mínimo das duas primeiras datas de cada imóvel, então usamos novamente a função de agregação MIN(). Dessa forma, descobriremos qual é a menor dessas datas, isto é, qual será a primeira_data da pessoa proprietária, não dos imóveis.

Na sequência, usamos a função SUM() para somar essas informações: se a pessoa proprietária tiver dois imóveis, ela somará o total_dias desses dois imóveis; se tiver três imóveis, somará o total de dias desses três imóveis; e assim sucessivamente.

Em relação aos dias_ocupados, a lógica é a mesma: queremos apenas somar, pois já fizemos o cálculo da diferença entre as datas de ocupação. Portanto, se a pessoa tiver três imóveis, somamos esses três.

Tendo as informações de total_dias e dias_ocupados, podemos calcular a taxa de ocupação (taxa_ocupacao). Da mesma maneira, dividimos a soma de dias_ocupados pela soma de total_dias, utilizamos a função ROUND(), e multiplicamos por 100. Assim, teremos a taxa_ocupacao.

A última parte da consulta são os JOIN. Na tabela hospedagens, precisamos chegar no nome da pessoa proprietária. Para isso, fazemos um JOIN entre a tabela temporária da subconsulta (tabela_taxa_ocupacao), que possui um hospedagem_id, e o hospedagem_id da tabela h. Assim, a tabela da subconsulta é associada à tabela real.

Agora que conseguimos chegar em hospedagens, conseguimos chegar em proprietarios. Nesse caso, adicionamos mais um JOIN, onde pegamos pelo proprietario_id e colocamos essa informação na tabela (proprietarios p ON h.proprietario_id = p.proprietario_id).

No GROUP BY, conforme dito anteriormente, tem o foco na pessoa proprietária, então agrupamos as informações por cada uma das pessoas proprietárias (p.proprietario_id) e ordenamos por total_dias no bloco ORDER BY logo abaixo, ao final da consulta.

Após analisar a consulta, vamos executá-la para visualizar o resultado obtido:

Visualização dos seis primeiros registros da tabela. Para visualizá-la na íntegra, execute a consulta na sua máquina.

```
proprietario	primeira_data	total_dias	dias_ocupados	taxa_ocupacao
Dra. Kamilly Almeida	2022-03-07	1466	1304	89
Sra. Cecília Gonçalves	2022-03-07	736	648	88
Alana Oliveira	2022-03-07	736	622	85
Pedro Miguel Lopes	2022-03-07	736	647	88
Davi Luiz Carvalho	2022-03-07	736	645	88
Daniel Farias	2022-03-07	736	661	90
```
A primeira ocorrência é a Dra. Kamilly Almeida, que sabemos ter dois imóveis. Desses dois imóveis, um ficou disponível para aluguel em março de 2022; o total de dias que ele ficou disponível foi 1466, o dobro da segunda ocorrência, indicando que realmente são considerados dois imóveis no cálculo; desses 1466 dias, em 1300 o imóvel esteve ocupado; e a taxa de ocupação ficou em 89%.

## Conclusão
Perceba que transformamos a métrica, de modo que ela fique mais próxima da pessoa proprietária. Como tentamos resolver os problemas dessas pessoas, conseguimos visualizar melhor os dados e o time de negócio pode usar essa tabela para conversar com cada pessoa proprietária.

Também podemos disponibilizar essas quatro informações para a pessoa proprietária tomar as suas ações, entender há quanto tempo está na plataforma, como os imóveis estão performando, e assim por diante.

Além disso, com essa métrica, podemos gerar outras derivadas, como a média de ocupação entre todas as pessoas proprietárias, o primeiro imóvel alugado na nossa plataforma, quantos dias em média os imóveis ficam ocupados na plataforma, entre outras possibilidades.

Com a tabela que geramos e a métrica de taxa de ocupação, pensando em cada pessoa proprietária, podemos derivar muitas outras. Incentivamos você a pensar quais métricas seriam relevantes para o nosso negócio e para as pessoas proprietárias, e elaborar um pouco mais a métrica que temos atualmente.

No próximo passo, iremos considerar outras informações. Neste vídeo, focamos na pessoa proprietária, mas e as informações de quando os aluguéis acontecem, tanto em relação à época do ano, quanto em relação à região do país? Isso será muito relevantes para a nossa análise. Até mais!


## Question Analisando a performance de proprietários com MySQL


Imagine que você é um(a) analista de dados na Insight Places, uma plataforma que conecta proprietários de imóveis a potenciais inquilinos. Sua missão é fornecer insights valiosos para os proprietários, ajudando-os a otimizar suas estratégias de aluguel. Após implementar métricas básicas como taxa de ocupação e total de hospedagens, você percebe a necessidade de aprofundar sua análise para fornecer recomendações mais precisas. Você decide então criar uma métrica que combine a taxa de ocupação com o preço médio diário dos alugueis, permitindo identificar oportunidades de ajuste nos preços.

Como você criaria uma consulta SQL para calcular a taxa de ocupação combinada com o preço médio diário de aluguel para cada proprietário, utilizando as tabelas proprietarios, hospedagens, alugueis e enderecos?

```sql
    SELECT
        p.nome AS proprietario,
        ROUND(AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)), 2) AS preco_medio_diario,
        ROUND((SUM(DATEDIFF(a.data_fim, a.data_inicio)) / (DATEDIFF(MAX(a.data_fim), MIN(a.data_inicio)) * COUNT(DISTINCT h.hospedagem_id))) * 100, 2) AS taxa_ocupacao
    FROM
        proprietarios p
    JOIN
        hospedagens h ON p.proprietario_id = h.proprietario_id
    JOIN
        alugueis a ON h.hospedagem_id = a.hospedagem_id
    GROUP BY
        p.proprietario_id;
```
```sql
    SELECT
        p.nome AS proprietario,
        ROUND(AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)), 2) AS preco_medio_diario,
        ROUND((SUM(DATEDIFF(a.data_fim, a.data_inicio)) / COUNT(a.aluguel_id)) * 100) AS taxa_ocupacao
    FROM
        proprietarios p
    JOIN
        hospedagens h ON p.proprietario_id = h.proprietario_id
    JOIN
        alugueis a ON h.hospedagem_id = a.hospedagem_id
    GROUP BY
        p.proprietario_id;
```
```sql
    SELECT
        p.nome AS proprietario,
        ROUND(AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)), 2) AS preco_medio_diario,
        ROUND((SUM(DATEDIFF(a.data_fim, a.data_inicio)) / 365) * 100, 2) AS taxa_ocupacao
    FROM
        proprietarios p
    JOIN
        hospedagens h ON p.proprietario_id = h.proprietario_id
    JOIN
        alugueis a ON h.hospedagem_id = a.hospedagem_id
    GROUP BY
        p.proprietario_id;
```
```sql
    SELECT
        p.nome AS proprietario,
        ROUND(AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)), 2) AS preco_medio_diario,
        ROUND((SUM(DATEDIFF(a.data_fim, a.data_inicio)) / SUM(DATEDIFF(MAX(a.data_fim), MIN(a.data_inicio)))) * 100, 2) AS taxa_ocupacao
    FROM
        proprietarios p
    JOIN
        hospedagens h ON p.proprietario_id = h.proprietario_id
    JOIN
        alugueis a ON h.hospedagem_id = a.hospedagem_id
    GROUP BY
        p.proprietario_id;
```
```sql
    SELECT
        p.nome AS proprietario,
        SUM(a.preco_total) / COUNT(a.aluguel_id) AS preco_medio_diario,
        (COUNT(a.aluguel_id) / COUNT(DISTINCT h.hospedagem_id)) * 100 AS taxa_ocupacao
    FROM
        proprietarios p
    JOIN
        hospedagens h ON p.proprietario_id = h.proprietario_id
    JOIN
        alugueis a ON h.hospedagem_id = a.hospedagem_id
    GROUP BY
        p.proprietario_id;
