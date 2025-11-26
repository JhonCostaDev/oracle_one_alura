# Criando uma view com os principais dados descritivos por região

Já conseguimos resolver o problema de como apresentar os dados de maneira mais simples para as métricas de proprietário que fizemos.

Mas e o quadro geral? Temos essa mesma situação lá. Temos uma consulta elaborada para calcular os dados por região, para criar diversas métricas em relação às regiões do país.

Para isso, podemos aplicar a mesma solução que fizemos anteriormente, que é transformar a consulta elaborada em uma view.

Preparamos o código para utilizarmos e vamos passar por ele para relembrar como funciona, já que é um código que já conhecemos.
```sql
CREATE VIEW view_dados_regiao AS
SELECT
    r.regiao,
    AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS media_preco_aluguel,
    MAX(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS max_preco_dia,
    MIN(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS min_preco_dia,
    AVG(DATEDIFF(a.data_fim, a.data_inicio)) AS media_dias_aluguel
FROM
    alugueis a
JOIN
    hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN
    enderecos e ON h.endereco_id = e.endereco_id
JOIN
    regioes_geograficas r ON r.estado = e.estado
GROUP BY
    r.regiao;
    
```
Estamos colocando o view no início do nome, para identificar que aquele tipo de tabela é uma view. Então, colocamos view_dados_regiao. Aqui é aquela consulta que já trabalhamos.

Então, vamos ter o nome da região, a média de aluguel, o maior aluguel, o menor. É diária aqui que estamos calculando. E a média de dias que as pessoas estão ficando nessa região, os imóveis dessa região. Essa é uma consulta que envolve três joins aqui. Então, está unindo quatro tabelas para trazer essa informação. E fazemos o GROUP BY por região.

Vamos rodar essa consulta, que é a criação de uma view. Agora vamos ter mais uma view no projeto, a view_dados_regiao.

Para utilizar essa view é da mesma maneira que fizemos a de proprietários:
```sql
SELECT * FROM view_dados_regiao
```
```
regiao	    media_preco_aluguel	max_preco_dia	min_preco_dia	media_dias_aluguel
Sudeste	     545.4984193888	    998.000000	    102.000000	    3.8809
Norte	     522.9954669084	    1000.000000	    100.000000	    4.0218
Nordeste     557.3815602837	    1000.000000	    100.000000	    3.9428
Sul	         543.3395204950	    999.000000	    100.000000	    3.9435
Centro-Oeste 552.0123674912	    1000.000000	    100.000000	    3.9293
```

Temos como resultado uma informação com poucas linhas. Ao contrário dos proprietários, que temos uma lista com todos os proprietários. Aqui temos apenas essas cinco linhas com informações relevantes sobre os aluguéis daquelas regiões. Então, conseguimos tornar mais simples o acesso a essas métricas que construímos. Novamente, para facilitar a análise do time de negócios.

Agora, podemos ir para a nossa próxima consulta. Que seria interessante trazer para esse formato de view.

Essa próxima consulta envolve a mistura entre região. Então, os dados por região com a relação com os dados temporais que criamos lá atrás. Então, separar todas essas informações que temos sobre os aluguéis. Só que ao longo do tempo. Em que ano aconteceu, em que mês que aconteceu.

Já temos essa consulta, só queremos transformá-la em uma view.

Para isso, usaremos este código:
```sql
CREATE VIEW ocupacao_por_regiao_tempo AS
SELECT
    r.regiao,
    YEAR(data_inicio) AS ano,
    MONTH(data_inicio) AS mes,
    COUNT(*) AS total_alugueis
FROM
    alugueis a
JOIN
    hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN
    enderecos e ON h.endereco_id = e.endereco_id
JOIN
    regioes_geograficas r ON r.estado = e.estado
GROUP BY
    r.regiao, YEAR(data_inicio), MONTH(data_inicio)
ORDER BY
    r.regiao, ano, mes;
```
Mesmo padrão, CREATE VIEW ocupacao_por_regiao_tempo. Em seguida, temos uma consulta onde pegamos a região, o ano, o mês e fazemos uma contagem dos aluguéis.

Estamos juntando quatro tabelas para gerar essa informação. Temos um group by, tanto por região quanto por ano de início e mês de início. E aí está ordenado por região, ano e mês.

Vamos fazer a criação dessa view. Dessa vez, não vamos clicar lá para confirmar se a view foi criada. Vamos ver rodando uma consulta. Se não der erro é porque a view foi criada.

SELECT * from ocupacao_por_regiao_tempo;

Ele retornou mais linhas. Porque agora, para cada mês de cada ano, vamos ter uma linha para cada região. Então, são muitas linhas que estamos criando, ao contrário da última view que criamos. Mas aqui temos a vantagem de que podemos fazer essa análise por série temporal. Então, sabemos o ano que aconteceu, o mês que aconteceu.

Pode parecer que estamos apenas obtendo o mesmo resultado. Então, tivemos aquelas consultas que traziam uma tabela, ficou mais simples para ler, como essa informação funciona, porque é só o nome da view. Mas que análise eles vão poder fazer aí? Como eles podem construir essa análise, o tipo de negócios, ou nós mesmos, quando formos apresentar para eles?

Agora essa view funciona como uma tabela. Então, da mesma maneira que fizemos consultas, podemos aplicar consultas nessas views. Vamos dar um exemplo para você. Queremos, por exemplo, a seleção aqui de um período específico. Então, aqui está mostrando o centro-oeste, o ano, o mês. Mas nesse momento queremos fazer um estudo de uma parte específica. Então, queremos todas as colunas. Mantemos a ocupacao_por_regiao_tempo.

E é aqui que podemos elaborar mais a nossa consulta. Então, por exemplo, podemos aplicar um filtro.

SELECT * from ocupacao_por_regiao_tempo;

SELECT * from ocupacao_por_regiao_tempo
WHERE regiao='Sudeste' AND ano = 2023;

Podemos executar a consulta acima. E assim obtivemos os dados para o sudeste de 2023. Então, temos 12 linhas aqui. Uma para cada mês do ano de 2023. E o total de aluguéis. Então, não precisamos nos preocupar como é feito o cálculo de aluguéis ou como relacionar esses aluguéis com a região do país. Tudo isso está oculto lá dentro da VIEW. É uma consulta que elaboramos lá atrás.

Aqui só nos preocupamos com o problema de negócio que queremos analisar. Então, queremos analisar uma região específica em um ano específico por conta de um estudo que fizer sentido para a nossa análise. E conseguimos focar mais no negócio do que como as tabelas estão funcionando lá por trás. Essa é uma das vantagens de criar essa VIEW. E acho que pode ajudar muito nós, nos nossos próximos passos e o time de negócios a acessar essas métricas que construímos.
Próximo passo

Estamos felizes com o avanço que fizemos. Com essas três views. Mas ainda não está 100% claro para nós como esses dados vão chegar no time de negócios e principalmente esse projeto é pensado nos proprietários. Como esses dados vão chegar lá nos proprietários? Como essas métricas vão poder ser analisadas, acompanhadas por eles? E é isso que queremos explorar com você na próxima aula!

# Question - Views SQL para métricas de negócio

### Leve em consideração que você é um(a) analista de dados trabalhando para o `Buscante`, um e-commerce especializado em livros. Recentemente, a equipe de negócios expressou a necessidade de ter acesso rápido a métricas chave sobre as vendas de livros por editora, incluindo o número total de vendas, a média de preços de venda e a editora com o maior número de vendas. Para atender a essa demanda, você decide criar uma view que consolide essas informações de forma eficiente, permitindo que a equipe de negócios acesse os dados necessários sem realizar consultas complexas repetidamente.

Com base na necessidade descrita, qual das seguintes opções de código SQL representa a melhor maneira de criar a view desejada?

```sql
CREATE VIEW view_vendas_editora AS
SELECT editora, SUM(quantidade) AS total_vendas, AVG(preco_venda) AS media_preco
FROM vendas
GROUP BY editora;
```

```sql
CREATE VIEW view_vendas_editora AS
SELECT 
    editora, 
    SUM(quantidade) AS total_vendas, 
    AVG(preco_venda) AS media_preco,
    MAX(quantidade) AS max_vendas_por_pedido
FROM vendas
GROUP BY editora;
```

```sql
CREATE VIEW view_resumo_vendas_editora AS
SELECT 
    editora, 
    SUM(quantidade) AS total_vendas, 
    AVG(preco_venda) AS media_preco,
    (SELECT editora FROM vendas GROUP BY editora ORDER BY SUM(quantidade) DESC LIMIT 1) AS editora_mais_vendida
FROM vendas
GROUP BY editora;
```

```sql
CREATE VIEW view_vendas_editora AS
SELECT editora, SUM(quantidade) AS total_vendas, AVG(preco_venda) AS media_preco,
RANK() OVER (ORDER BY SUM(quantidade) DESC) AS ranking_vendas
FROM vendas
GROUP BY editora;
```

```sql
CREATE VIEW view_vendas_editora AS
SELECT editora, COUNT(*) AS total_vendas, AVG(preco_venda) AS media_preco
FROM vendas
GROUP BY editora;
```

## Desafio
 visualizações dos dados que construímos:

    Uma view resumindo ou descrevendo a performance das hospedagens de cada proprietário;

    Uma view resumindo ou descrevendo a performance das hospedagens de cada região.

## A performance das hospedagens de cada proprietário

Esta parte do código cria uma view chamada view_metricas_proprietario que apresenta métricas resumidas da performance das hospedagens para cada proprietário. Ela conta o número total de hospedagens, a primeira data de hospedagem registrada, o total de dias que as hospedagens estiveram disponíveis, o total de dias ocupados e a taxa de ocupação.

A subconsulta dentro da view calcula as métricas de ocupação para cada hospedagem.

Depois, são feitos joins com as tabelas hospedagens e proprietarios para obter informações adicionais sobre as hospedagens e proprietários. Por fim, os resultados são agrupados por proprietário.

USE insightplaces;

CREATE VIEW view_metricas_proprietario AS
SELECT
    p.nome AS Proprietario,
    COUNT(DISTINCT h.hospedagem_id) AS total_hospedagens,
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
    p.proprietario_id;

Agora para ter acesso a estes dados basta uma consulta que seleciona todos os dados da view view_metricas_proprietario.

SELECT * from view_metricas_proprietario;

A performance das hospedagens de cada região.

Este trecho cria uma view chamada view_dados_regiao, que apresenta métricas resumidas da performance das hospedagens para cada região.

Ele calcula a média, máximo e mínimo do preço do aluguel por dia, bem como a média de dias de aluguel por região.

As informações são obtidas através de joins com as tabelas alugueis, hospedagens, enderecos e regioes_geograficas.

Os resultados são agrupados por região.

CREATE VIEW view_dados_regiao AS
SELECT
    r.regiao,
    AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS media_preco_aluguel,
    MAX(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS max_preco_dia,
    MIN(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS min_preco_dia,
    AVG(DATEDIFF(a.data_fim, a.data_inicio)) AS media_dias_aluguel
FROM
    alugueis a
JOIN
    hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN
    enderecos e ON h.endereco_id = e.endereco_id
JOIN 
    regioes_geograficas r ON r.estado = e.estado
GROUP BY
    r.regiao;
    

Da mesma maneira agora, para acessar os dados da região basta uma consulta que seleciona todos os dados da view view_dados_regiao.

SELECT * FROM view_dados_regiao;

Na última etapa é criada a view ocupacao_por_regiao_tempo, que apresenta a ocupação por região ao longo do tempo.

Ela conta o número total de aluguéis para cada região, agrupados por ano e mês.

As informações são obtidas através de joins com as tabelas alugueis, hospedagens, enderecos e regioes_geograficas.

Os resultados são ordenados por região, ano e mês.

CREATE VIEW ocupacao_por_regiao_tempo AS
SELECT
    r.regiao,
    YEAR(data_inicio) AS ano,
    MONTH(data_inicio) AS mes,
    COUNT(*) AS total_alugueis
FROM
    alugueis a
JOIN
    hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN
    enderecos e ON h.endereco_id = e.endereco_id
JOIN
    regioes_geograficas r ON r.estado = e.estado
GROUP BY
    r.regiao, YEAR(data_inicio), MONTH(data_inicio)
ORDER BY
    r.regiao, ano, mes;

Esta consulta seleciona os dados da view ocupacao_por_regiao_tempo para a região 'Sudeste' no ano de 2023 para visualização. Sem a complexidade da consulta que faz os cálculos desses valores.

SELECT * from ocupacao_por_regiao_tempo
WHERE regiao='Sudeste' AND ano = 2023;