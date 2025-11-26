# Respondendo dúvidas de negócio

A ideia nesse projeto é responder questionamentos da área de negócio. Mas, o que isso significa?

Queremos trazer métricas e insights sobre os dados para auxiliar as pessoas proprietárias dos imóveis da Insight Place a tomar suas decisões.

Uma das métricas que pensamos em explorar, baseada na exploração que fizemos nos dados, é `entender a taxa de ocupação`. Isso significa, desde que um imóvel ficou disponível, quantos desses dias ele ficou alugado e quantos ficou vago.

Com essa informação, podemos gerar métricas em relação à taxa de ocupação por região, por época do ano, e isso pode ajudar a pessoa proprietária a tomar suas decisões em relação a preços e outros aspectos.

## Criando os cálculos
Para fazer isso, preparamos uma consulta que faz esse cálculo. Na tabela alugueis, temos as informações de `data_inicio` e `data_fim` do aluguel, assim como `hospedagem_id`, ou seja, o imóvel.

Sendo assim, temos vários aluguéis para o mesmo imóvel. Se pensarmos no imóvel 1, ele foi alugado por uma, dua, três vezes e tem vários registros na tabela de aluguéis.

Uma das informações que queremos é a primeira data. Não temos na tabela a informação de quando o imóvel ficou disponível para aluguel. No entanto, podemos calcular aproximadamente usando a primeira vez que ele foi alugado.

O código que usaremos é o abaixo, vamos entendê-lo por partes.
```sql
SELECT
    hospedagem_id,
    MIN(data_inicio) AS primeira_data,
    SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
    DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias,
    ROUND((SUM(DATEDIFF(data_fim, data_inicio)) / DATEDIFF(MAX(data_fim), MIN(data_inicio))) * 100) AS taxa_ocupacao
FROM
    alugueis
GROUP BY
    hospedagem_id
ORDER BY taxa_ocupacao DESC
;
```

Para descobrirmos essa informação, usaremos a função MIN(). Nesse caso, estamos agrupando os dados pelo ID da hospedagem, então, a casa número 1 foi colocada em aluguel e alugada várias vezes.

Queremos saber quando ela foi alugada pela primeira vez. Usaremos a função MIN(), que a partir de todas as data de início, pegará a menor. Chamamos isso de primeira_data.

Outra informação que queremos é quantos dias essa casa ficou ocupada. Para isso, percorreremos todas as datas que esse imóvel foi alugado, sendo a data_inicio e a data_fim.

A diferença dessas datas serão os dias que o imóvel ficou alugado. Faremos isso para todas as vezes que foi alugado. Para isso, usaremos a função DATEDIFF(), que faz a subtração entre duas datas.

Mas, teremos várias datas, então, vários dias ocupados das várias vezes que foi alugado. Queremos somar todas essas informações. Então, utilizamos mais uma função, que é a SUM().

Assim, pegaremos os dias que o imóvel foi ocupado em todas as vezes que foi alugado e somar. A partir disso, teremos todos os dias em que ficou ocupado.

Calculando a taxa_ocupação
Porém, para calcular uma taxa, precisamos de todos os dias no geral. Para isso, usaremos novamente o DATEDIFF. Queremos a diferença entre a primeira vez que foi alugado. Chamamos isso de primeira_data e conseguimos essa informação por meio do MIN() da data_inicio.

Para sabermos a última vez que uma pessoa saiu do imóvel, usamos a MAX(data_fim), a data mais recente. Repare que combinamos diversas funções para chegar na primeira data, dias ocupados e total de dias.

Com essas informações, conseguimos o valor da taxa. Para calcular uma taxa, pegamos todos os dias que esse imóvel ficou disponível e todos os dias que ele ficou ocupado. Dividimos dias ocupados pelo total de dias, multiplicamos por 100 para termos a porcentagem e usamos a função RPUND(), para termos o número arredondado.

Essas informações estão todas na tabela alugueis, por isso FROM aluguei. Agruparemos pela hospedagem, então usamos GROUP BY hospedagem_id. Por fim, definimos uma ordenação pela taxa de ocupação com ORDER BY taxa_ocupacao DESC.

Agora que entendemos todo o código, selecionamos e executamos a consulta. Feito isso, temos o seguinte retorno abaixo.

hospedagem_id	primeira_data	dias_ocupados	total_dias	taxa_ocupacao
77	2023-07-11	4	4	100
17	2022-03-07	684	731	94
20	2022-03-08	665	731	91
5	2022-03-07	666	733	91
33	2022-03-10	665	729	91
-- Dados omitidos

Assim, temos a coluna taxa_ocupacao. O primeiro imóvel, 77, teve uma taxa de ocupação de 100%. Mas um ponto de atenção é que esse imóvel é recente na nossa base, então ficou poucos dias disponíveis.

A primeira vez, ele foi alugado no dia 11 de setembro de 2023 por quatro dias, esses foram os quatro dias que ficou disponível.

Podemos colocar um asterisco nessa métrica, porque pode ser que esse imóvel tenha ficado mais tempo disponível na base de dados, mas estamos contando a partir da primeira vez que ele foi alugado. Fazemos isso para as pessoas interpretarem essa métrica da maneira correta.

Mas, estamos mais interessados das outras métricas. O 100% da taxa_ocupacao é um outlier na análise, temos que conferir quem tem volume de dados.

Temos diversas hospedagens que ficaram 730 dias disponíveis e tiveram por volta de 600 dias ocupados. Assim, temos uma taxa de ocupação de 89% a 94% para esses imóveis. Essa informação é muito interessante, porque conseguimos entender se esses imóveis estão sendo alugados ou não.

Reordedando os dados
Também podemos fazer uma ordenação diferente para outra análise. Na última linha de código, mudamos de DESC para ASC e rodamos a consulta.

SELECT
    hospedagem_id,
    MIN(data_inicio) AS primeira_data,
    SUM(DATEDIFF(data_fim, data_inicio)) AS dias_ocupados,
    DATEDIFF(MAX(data_fim), MIN(data_inicio)) AS total_dias,
    ROUND((SUM(DATEDIFF(data_fim, data_inicio)) / DATEDIFF(MAX(data_fim), MIN(data_inicio))) * 100) AS taxa_ocupacao
FROM
    alugueis
GROUP BY
    hospedagem_id
ORDER BY taxa_ocupacao ASC
;
Copiar código
Como retorno, temos a tabela abaixo.

hospedagem_id	primeira_data	dias_ocupados	total_dias	taxa_ocupacao
76	2022-04-07	11	463	2
74	2022-04-11	20	486	4
75	2022-04-11	21	458	5
73	2022-04-11	32	485	7
72	2022-04-12	46	557	8
--Dados omitidos				
Repare que temos outros imóveis que não estão sendo ocupados. Essa é uma informação que ajudará a pessoa proprietária a analisar. Por exemplo, o imóvel 76, está com apenas 2% de taxa de ocupação.

Nisso, podemos comparar com imóveis da mesma região, para entender se esse é um dado somente referente ao imóvel ou se está relacionado a região. Nesse caso, o imóvel ficou disponível 463 dias, mas só teve 11 dias ocupados.

Essa informação de taxa de ocupação é muito interessante. Até para a área de negócio da empresa tomar a decisão com quem conversará. Talvez dar atenção para quem está tendo uma taxa de ocupação mais baixa, para pensar em soluções e promover vantagens para os clientes que estão conseguindo alugar bem seu imóvel.

Muito interessante essa métrica que conseguimos construir juntos. Para isso, combinamos funções matemáticas e outras, do próprio MySQL.

Usamos o DATEDIFF() para calcular a diferença entre as datas, o MIN() para pegar o menor valor, SUM() para somar, ROUND() para arredondar.

Fizemos uma multiplicação por 100, que embora não seja uma função, foi uma técnica que utilizamos para apresentar o resultado. É muito importante combinar funções para conseguir chegar nesses resultados.

A taxa de ocupação será a primeira métrica que trabalharemos. Agora podemos explorar as outras tabelas e informações, para poder combiná-las.

Temos a taxa de ocupação, sozinha já ajuda bastante em uma análise, mas e, por exemplo, a localização ou época do ano? Será que isso está influenciando na taxa de ocupação?

Para explorar isso, precisaremos pegar outras informações de outras tabelas. É isso que faremos a seguir. Até lá!

## qUESTION

Cálculo da taxa de ocupação dos imóveis utilizando MySQL
 Próxima Atividade

João está participando de um curso de análise de dados usando MySQL e chegou a parte do curso onde o foco é responder a perguntas de negócios utilizando dados de aluguel de imóveis. Uma das análises propostas envolve calcular a taxa de ocupação dos imóveis para entender melhor o desempenho dos proprietários.

Qual dos seguintes comandos SQL é necessário para calcular a taxa de ocupação?

Selecione uma alternativa

Utilizar GROUP BY hospedagem_id na tabela alugueis apenas, calcular a soma de DATEDIFF(data_fim, data_inicio) para dias ocupados, a diferença entre a data de início mais antiga e a data de fim mais recente para obter o total de dias, e então calcular a taxa de ocupação como a razão entre os dias ocupados e o total de dias, multiplicado por 100.


Realizar um JOIN entre hospedagens e alugueis para detalhar cada aluguel, mas calcular a taxa de ocupação usando a diferença entre a data máxima e mínima de data_inicio agrupada por hospedagem_id.


Utilizar JOIN para combinar as tabelas hospedagens e alugueis, seguido de GROUP BY hospedagem_id e aplicar a função AVG() para calcular a média de dias ocupados por hospedagem.


Executar um SELECT simples na tabela alugueis, aplicando GROUP BY hospedagem_id e usar DATEDIFF(data_fim, data_inicio) para calcular os dias ocupados, sem a necessidade de combinar tabelas.