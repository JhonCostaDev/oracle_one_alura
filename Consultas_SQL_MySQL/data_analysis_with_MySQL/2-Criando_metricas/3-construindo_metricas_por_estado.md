# Construindo métricas por estado
Conseguimos realizar a análise temporal e criar a taxa de ocupação, mas uma variável que consideramos muito importante para analisar neste projeto é a questão do país. Por que isso seria um problema?

A questão é que estamos em um país muito grande, onde podemos ter aluguéis muito distintos, com preços e comportamentos diferentes ao longo do tempo. Por exemplo: uma região do país tende a ter mais aluguéis em março, enquanto outra tende a ter mais reservas de aluguéis em maio.

Precisamos trazer a questão da região para a nossa análise, pois ela pode ser muito importante e um insight perdido caso esse fator não seja considerado.

## Construindo métricas por estado

Primeiramente, precisamos decidir o que queremos analisar. Sabemos que queremos analisar a região do país, mas a ideia é verificar a quantidade de dias que as pessoas ficam? Ou a taxa de ocupação, métrica criada anteriormente? Nossa sugestão é analisar uma nova informação: `quanto é cobrado por dia`, ou seja, o` valor da diária de cada um desses locais`.

## Criando uma nova consulta

Para fazer isso, construiremos a seguinte consulta:

```SQL
-- código omitido

SELECT
    a.hospedagem_id,
    a.preco_total,
    DATEDIFF(a.data_fim, a.data_inicio) AS dias_aluguel,
    a.preco_total / DATEDIFF(a.data_fim, a.data_inicio) AS preco_dia
FROM
    alugueis a
ORDER BY
    preco_dia DESC;
;
```
Nessa consulta, selecionamos primeiro o hospedagem_id da tabela alugueis (a.hospedagem_id). Depois selecionamos o preco_total, da mesma tabela.

A próxima informação dá uma dica de como vamos descobrir o valor da diária: realizamos o cálculo de dias_aluguel. Para isso, usamos a função `DATEDIFF()`, que já exploramos bastante até o momento, pegamos a data_fim e a data_inicio, e obtemos a quantidade de dias que a pessoa ficou hospedada.

Se temos a `data_fim`, a` data_inicio` e o `preco_total`, podemos chegar na informação da diária, isto é, quanto é cobrado por dia no aluguel do imóvel.

    Observação: É muito importante analisar o cálculo com o time de negócio para entender como ele é feito, mas podem existir algumas taxas, como taxas de serviço, por exemplo, entre outras coisas que impactam no preço do imóvel, o que poderia variar o valor da diária que tentamos identificar.

    Para o nosso propósito, não há problema se esses valores forem inclusos, pois podemos dividi-los pelos dias, mas a depender da sua análise e do contexto do seu projeto, é importante alinhar com o time de negócios.

Uma vez obtidos os valores de dias_aluguel e preco_total, dividimos um pelo outro e chegamos ao valor da diária (preco_dia). Para isso, repetimos o cálculo do DATEDIFF() e dividimos por a.preco_total.

Tudo isso está na tabela alugueis (a), então não precisaremos fazer o `JOIN` com nenhuma outra tabela. Além disso, queremos ordenar por preço, para identificar o maior preço que temos e o menor preço que vamos ter. Sendo assim, o ORDER BY foi feito por `preco_dia`.

### Executando a consulta

Vamos analisar o resultado após a execução da consulta:
```
hospedagem_id	preco_total	dias_aluguel	preco_dia
58	            5000.00	    5	            1000.000000
12	            4000.00	    4	            1000.000000
39	            2000.00	    2	            1000.000000
20	            2000.00	    2	            1000.000000
25	            3000.00	    3	            1000.000000
```
Na tabela gerada, temos o ID da hospedagem (hospedagem_id), o preço total (preco_total), a quantidade de dias alugados (dias_aluguel), e o preço por dia (preco_dia). Observe que os primeiros imóveis exibidos na lista possuem o valor de 1.000 reais a diária.

Porém, nosso objetivo não era exatamente esse. Trouxemos a métrica do preço por dia, mas queremos entender se esse preço por dia se repete, isto é, se ele é igual para todo o país, ou se varia conforme a região. Portanto, precisamos trazer essa informação de localização para a consulta.

## Refatorando a consulta

Encontramos a informação de localização na tabela enderecos, então será necessário combinar essa nova consulta com alguns JOIN. Vamos colar o código no script e analisar passo a passo:
```SQL
-- código omitido

SELECT
    e.estado,
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
GROUP BY
    e.estado; 
```

Na primeira parte da consulta, trazemos a informação do estado. Na tabela enderecos, encontramos essa informação de qual estado está determinado imóvel, então selecionamos e.estado.

Logo abaixo, utilizamos o cálculo da diária realizado anteriormente, para trazer algumas métricas interessantes para cada estado. Para isso, usamos a função `AVG()`, que significa average. Dessa forma, teremos a média de valor de diária para o estado (media_preco_aluguel).

Em seguida, usamos a função MAX(), então além da média, coletamos o maior valor de diária para o estado (max_preco_dia). Da mesma forma, usamos a função MIN() para trazer o menor valor (min_preco_dia).

Feito isso, usamos novamente a função AVG() ao final do SELECT, mas agora para realizar o cálculo de dias que as pessoas ficam hospedadas nos imóveis (media_dias_aluguel).

São quatro informações muito interessantes que conseguiremos trazer para cada um dos estados. A partir delas, será possível gerar muitos insights, como:

        Entender se a diária cobrada pela pessoa proprietária está na média da região;
        Se ela está próxima da mínima ou da máxima;
        Se as pessoas ficam hospedadas no imóvel a mesma quantidade de dias que, em média, ficam no estado.

Assim, as pessoas proprietárias poderão comparar suas próprias situações com as de outras pessoas proprietárias da mesma região, então é uma métrica muito importante a ser considerada.

Para chegar ao resultado, foi necessário realizar dois JOIN, pois fizemos o cálculo pela tabela alugueis (a), onde está representado cada aluguel que aconteceu. Porém, queremos trazer o endereço, que está associado à hospedagem.

Portanto, coletamos as informações da tabela alugueis, e avaliamos para qual imóvel o aluguel foi feito. Para isso, fazemos JOIN com a tabela hospedagens (h), olhando para hospedagem_id. Uma vez que chegamos na tabela hospedagens, podemos ir para a tabela enderecos (e).

Na tabela enderecos, o imóvel é associado a um dos endereços para informar a qual ele pertence. Sendo assim, fizemos o JOIN com o endereco_id das tabelas hospedagens e enderecos.

No próximo passo, queremos fazer o agrupamento por estado, então no bloco GROUP BY, pegamos a coluna estado da tabela e, a qual apresentamos no bloco SELECT.

Ao executar a consulta, é gerada a seguinte tabela:
```
estado	media_preco_aluguel	max_preco_dia	min_preco_dia	media_dias_aluguel
SP	    533.9347826087	    992.000000	    104.000000	        3.7255
RO	    522.6129032258	    1000.000000	    101.000000	        3.7273
CE	    576.0303030303	    998.000000	    104.000000	        3.5372
MA	    550.3632567850	    996.000000	    101.000000	        3.9248
PR	    547.5215605749	    998.000000	    101.000000	        3.9055
```
Como retorno, a consulta trouxe todas as informações que planejamos: temos, por exemplo, o estado de São Paulo com uma média de preços de aluguel de R$ 533,00. O máximo é R$ 992,00, o mínimo é R$ 104,00, e as pessoas ficam em média quase 4 dias em cada hospedagem.
Conclusão

Como podemos agregar ainda mais essa informação? Se pensamos no estado anteriormente, também podemos ir para outra camada no Brasil, considerando as regiões na análise.

Como podemos dividir as mesmas informações de antes para cada região do país? Para isso, precisaremos criar uma nova tabela de dados e associar aos estados. Faremos isso na sequência!


## Question - Identificando tendências de aluguel com MySQL

Imagine que você é um(a) analista de dados na Insight Places, uma empresa que fornece insights valiosos para proprietários de imóveis alugados. Recentemente, você foi encarregado(a) de identificar padrões de demanda ao longo do ano para ajudar os proprietários a ajustar seus preços de acordo com a sazonalidade.

Para isso, você decide utilizar os dados de aluguel disponíveis, analisando a quantidade de alugueis por mês e identificando os períodos de alta e baixa demanda.

Como você pode modificar a consulta SQL existente para incluir uma análise que mostre a média de dias que cada imóvel fica alugado por mês, ajudando assim a identificar períodos de maior e menor demanda?
Selecione uma alternativa

```sql
    SELECT
        MONTH(data_inicio) AS mes,
        SUM(preco_total) AS receita_mensal
    FROM
        alugueis
    GROUP BY
        mes
    ORDER BY
        mes;
```

```sql
    SELECT
        e.estado,
        AVG(a.preco_total / DATEDIFF(a.data_fim, a.data_inicio)) AS media_preco_aluguel
    FROM
        alugueis a
    JOIN
        hospedagens h ON a.hospedagem_id = h.hospedagem_id
    JOIN
        enderecos e ON h.endereco_id = e.endereco_id
    GROUP BY
        e.estado;
```
```sql
    SELECT
        MONTH(data_inicio) AS mes,
        AVG(DATEDIFF(data_fim, data_inicio)) AS media_dias_alugados
    FROM
        alugueis
    GROUP BY
        mes
    ORDER BY
        mes;
```
```sql
    SELECT
        YEAR(data_inicio) AS ano,
        COUNT(*) AS total_alugueis
    FROM
        alugueis
    GROUP BY
        ano
    ORDER BY
        ano;
```
```sql
    SELECT
        MONTH(data_inicio) AS mes,
        MAX(DATEDIFF(data_fim, data_inicio)) AS max_dias_alugados
    FROM
        alugueis
    GROUP BY
        mes
    ORDER BY
        mes;
```