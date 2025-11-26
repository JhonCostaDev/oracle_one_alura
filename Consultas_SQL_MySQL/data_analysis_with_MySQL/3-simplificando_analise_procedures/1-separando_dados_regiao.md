# Separando dados por região.

No nosso projeto da `Insight Places`, conseguimos separar os nossos dados por região e por época do ano. Será que conseguimos combinar essas informações?

Seria muito importante ver o impacto. Calculamos a taxa de ocupação, mas e a taxa de ocupação por região? E se calculamos essas métricas de média de preço por região, será que conseguimos ver isso através do tempo? Combinar essas métricas pode trazer resultados muito importantes para nós. Vamos começar a explorar isso?

Preparamos um código que faz essa junção entre a região e a questão do tempo. Vamos explorá-lo.

```sql
USE insightplaces;
SELECT
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
    regioes_geograficas r ON e.estado = r.estado
WHERE
    r.regiao = "Sudeste"
GROUP BY
    ano, mes
ORDER BY
    ano, mes;
```
```sql
-- Minha versão sem criar tabela região
SELECT 
    YEAR(a.data_inicio) as ano,
    MONTH(a.data_inicio) as mes,
    COUNT(*) AS total_alugueis
FROM 
    alugueis a
JOIN 
    hospedagens h ON a.hospedagem_id = h.hospedagem_id
JOIN 
    enderecos e ON h.endereco_id = e.endereco_id
WHERE 
    e.estado in ('ES','MG','RJ','SP')
GROUP BY
    ano, mes
ORDER BY 
    ano, mes;

```
Esse script começa com o USE insightplaces, sempre lembrando, para selecionar o nosso banco de dados que vamos trabalhar nesse script. Agora, vamos explorar a nossa consulta.

Primeira etapa é a etapa do SELECT. Quais informações queremos utilizar nessa análise de tempo? Então, são ano e mês. Queremos fazer uma análise da série temporal. E a informação de destaque para nós é o total de aluguéis que vai acontecer em cada uma dessas épocas.

Essas informações ainda vêm da tabela de aluguéis. E, para agregar mais informação, vamos fazer alguns JOIN. O primeiro deles é associar o aluguel a um imóvel, a uma hospedagem. Vamos associar essa hospedagem a um endereço, através do JOIN. E, por fim, as regiões geográficas, para trazer aquela informação uma camada acima do estado.

Como vamos trazer essa variação? Fizemos aquela análise do tempo para todas as regiões do país. E agora, se quisermos focar em uma região de um país e entender se a série temporal de uma região específica do país é diferente das outras?

Podemos aplicar, por exemplo, um filtro. Então, utilizar o WHERE e focar em apenas uma região. Na região sudeste, por exemplo. Então, o WHERE é r.região = "Sudeste". Vamos fazer um GROUP BY de ano e mês e ordenar por ano e mês também. Temos interesse naquela análise de série temporal.

Ao executar o script, ele retornou para nós aquela tabela no mesmo formato que já exploramos. Começa em 2022 e vai passando os meses. Observe as primeiras linhas da tabela abaixo:
ano	mes	total_alugueis
```
2022	3	35
2022	4	44
2022	5	37
2022	6	39
2022	7	34
2022	8	33
2022	9	32
2022	10	49
2022	11	29
```
Podemos notar que a quantidade de aluguéis diminuiu bastante, porque estamos focando em apenas uma região. Alcançamos o nosso propósito. E, agora, conseguimos fazer essa análise para cada uma das regiões através do tempo.

Existem algumas maneiras de fazer isso. Poderíamos quebrar essa análise para criar uma nova coluna por região, mas queremos da maneira mais simples possível. Poderíamos copiar essa consulta e mudar para outra região, e assim por diante.

Isso geraria um script repetitivo. Toda vez que formos checar uma região, considerar essas informações de uma região, vamos gerar essa consulta grande e mudar apenas a região.

    Será que tem alguma maneira de simplificar isso para não poluir tanto o nosso script?

Caso tenhamos alguma mudança nesse código que precisamos fazer, precisamos encontrar um modo de não precisar modificar o script toda vez que acontecer isso. Existe alguma maneira de simplificar esse processo?

No MySQL, temos a questão das procedures, que podem resolver esse problema para nós, e vamos explorá-las em breve.

## Question - Simplificando consultas no universo Pet


Imagine que você é um(a) analista de dados trabalhando para o `Gatito Petshop`, uma loja especializada em produtos e serviços para pets. Recentemente, o Gatito Petshop decidiu expandir seus serviços de hospedagem para pets e agora quer analisar os dados de aluguel desses espaços para entender melhor as tendências de ocupação e otimizar seus serviços. Para isso, você precisa criar uma procedure que simplifique a análise dos dados de aluguel por região, ano e por mês, permitindo uma consulta rápida e eficiente.

Considerando a necessidade de analisar os dados de aluguel de hospedagem para pets por região, ano e mês, qual das seguintes procedures você criaria para atender a essa demanda, garantindo uma manutenção fácil e uma consulta eficiente?
Selecione uma alternativa

```sql

    DELIMITER //
    CREATE PROCEDURE analisar_alugueis_por_regiao_mes(regiao_nome VARCHAR(255))
    BEGIN
      SELECT
        YEAR(data_inicio) AS ano,
        MONTH(data_inicio) AS mes,
        COUNT(*) AS total_alugueis
      FROM alugueis
      JOIN hospedagens ON alugueis.hospedagem_id = hospedagens.hospedagem_id
      JOIN enderecos ON hospedagens.endereco_id = enderecos.endereco_id
      WHERE enderecos.regiao = regiao_nome
      GROUP BY ano, mes
      ORDER BY ano, mes;
    END//
    DELIMITER ;
```

```sql
    DELIMITER //
    CREATE PROCEDURE detalhes_alugueis()
    BEGIN
      SELECT * FROM alugueis;
    END//
    DELIMITER ;
```

```sql
    DELIMITER //
    CREATE PROCEDURE analisar_alugueis_petshop()
    BEGIN
      SELECT COUNT(*) AS total_alugueis
      FROM alugueis;
    END//
    DELIMITER ;
```

```sql
    DELIMITER //
    CREATE PROCEDURE total_alugueis_por_ano()
    BEGIN
      SELECT
        YEAR(data_inicio) AS ano,
        COUNT(*) AS total_alugueis
      FROM alugueis
      GROUP BY ano
      ORDER BY ano;
    END//
    DELIMITER ;
```

```sql
    DELIMITER //
    CREATE PROCEDURE analisar_alugueis_por_regiao_mes(regiao_nome VARCHAR(255))
    BEGIN
      SELECT
        MONTH(data_inicio) AS mes,
        COUNT(*) AS total_alugueis
      FROM alugueis
      JOIN hospedagens ON alugueis.hospedagem_id = hospedagens.hospedagem_id
      JOIN enderecos ON hospedagens.endereco_id = enderecos.endereco_id
      WHERE enderecos.regiao = regiao_nome
      GROUP BY mes
      ORDER BY mes;
    END//
    DELIMITER ;
```