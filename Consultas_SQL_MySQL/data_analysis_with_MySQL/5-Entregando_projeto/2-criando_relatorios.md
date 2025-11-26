#  Criando um relatório para a área de negócios

Analisamos várias formas de entregar nossa análise ao cliente e à equipe de negócios. No entanto, para esta fase inicial do projeto, faz mais sentido apresentar os dados e insights de forma simples. Isso atenderá às necessidades da equipe de negócios e esclarecerá os objetivos do projeto.

Para isso, optamos por criar um relatório que agregará valor tanto para os proprietários quanto para a equipe de negócios. Disponibilizaremos um template para vocês nas atividades, para que possam construir seus próprios relatórios, incluindo a análise realizada e as ideias geradas, para compartilhar nas redes. Estamos ansiosos para ver o trabalho de vocês e o relatório que produzirão!
Relatório de Negócios

No relatório que preparamos, temos o título da empresa "Insight Places", o estudo que estávamos fazendo, que é para proprietários, um sumário e o conteúdo do relatório.

    Relatório de negócios

    Somos os analistas de dados da InsightPlaces e atualmente estamos envolvidos em um projeto para apoiar os proprietários de imóveis do nosso site. Esse suporte será fornecido apresentando uma variedade de dados úteis para que os proprietários possam tomar decisões de negócios informadas, tais como preços e épocas do ano com maior movimento. Para identificar essas informações, utilizaremos uma combinação de recursos, incluindo funções matemáticas, procedures e apresentaremos os resultados por meio de visualizações e tabelas elaboradas, facilitando sua compreensão.

Explicamos exatamente o projeto que estamos trabalhando, qual é a proposta desse projeto, que é entregar valores para o time de negócios e principalmente para as pessoas proprietárias.
Objetivos

    Objetivos

        Apresentar métricas úteis para decisões estratégicas

        Analisar os dados históricos e prover insight valiosos para os proprietários e time de negócios

Deixamos os nossos objetivos bem claros, que são apresentar métricas úteis para as decisões estratégicas e também fazer uma análise sobre esses dados. Criamos diversas métricas, mas precisamos analisar esses dados e entender o que eles estão contando para nós. E é isso que vamos trazer aqui nesse relatório.

Primeiro, abordaremos as análises.
Análises

    Análises

    Tivemos 2 frentes de análises nesse projeto, foco em proprietários de maneira individual, regiões do país e série temporal. Acreditamos que essas duas análises são o coração do projeto.

    I.Regiões do País

    Realizamos o cálculo de diversos valores relevantes para cada região, incluindo a média do preço da diária, o valor máximo, mínimo e médio de dias alugados. Essas informações são cruciais para que equipes de negócios e proprietários possam avaliar se o comportamento da região reflete-se na situação do imóvel do proprietário. Caso não seja o caso, podem ser sugeridas ações a serem tomadas para ajustar estratégias e maximizar o desempenho do imóvel.
    regiao	media_preco_aluguel	max_preco_dia	min_preco_dia	media_dias_aluguel
    Sudeste	545.498149388	998.00000	102.00000	3.8809
    Centro-Oeste	552.0123674912	1000.00000	100.00000	3.9293
    Nordeste	557.381502837	1000.00000	100.00000	3.9428
    Sul	543.3395204950	999.00000	100.00000	3.9435
    Norte	522.9954669084	1000.00000	100.00000	4.0218

A primeira das análises é em relação às regiões do país. Foi algo que exploramos bastante nessa base de dados. Aqui trazemos essas métricas na tabela e o que podemos ler sobre elas. Em relação à média de aluguel, o maior preço, o menor preço, podemos explicar que não observamos muita variação, o que pode gerar situações que não são ideais. Há regiões que poderiam estar com um preço menor, porque são menos procuradas. Ter esse padrão em todo o país não está fazendo sentido.

    II. Comparando os números dos proprietários

    Analisamos também os dados de cada proprietário de maneira isolada, entendendo assim se temos algum comportamento parecido ou muito divergente. Fizemos isso analisando a taxa de ocupação e o total de dias disponíveis. Informações relevantes para entender a performance do proprietário.
    Proprietario	primeira_data	total_dias	dias_ocupados	taxa_ocupacao
    Dra. Kamily Almeida	2022-03-07	1466	1304	89
    Sra. Cecília Gonçalves	2022-03-07	736	648	88
    Alana Oliveira	2022-03-07	736	622	85
    Pedro Miguel Lopes	2022-03-07	736	647	88
    Davi Luiz Carvalho	2022-03-08	736	645	88
    Daniel Farias	2022-03-07	736	661	90
    Sra. Alice Monteiro	2022-03-08	735	611	83
    Srta. Isabelly Nascimento	2022-03-07	734	635	87

A próxima análise que consideramos é a comparação do número de propriedades entre os proprietários. Discutimos os proprietários que se destacam, como a doutora Kamily Almeida, que foi amplamente explorada neste projeto. Ela se destacou por possuir mais de uma propriedade, embora sua taxa de cooperação fosse semelhante à dos demais. Isso sugere que ela poderia explorar mais seu potencial.

Essa análise está intimamente relacionada ao vídeo anterior, onde abordamos o produto entregue e como ele chega às mãos dos proprietários.
Métricas

    Métrica

    Foram desenvolvidas 3 views que podem ser utilizadas para análise. A grande vantagem de utilizar essa views é que temos métricas prontas, não havendo a necessidade de criar as métricas manualmente.

    view_metricas_proprietario

    view_dados_regiao

    ocupacao_por_regiao_tempo

    Exemplo de uso:

    SELECT    mes,    AVG(total_alugueis) AS media_alugueis
    FROM    ocupacao_por_regiao_tempo
    WHERE     regiao = 'Sudeste'
    GROUP BY    mes
    ORDER BY    media_alugueis DESC;

    mes	media_alugueis
    10	46.5000
    12	43.5000
    6	43.0000
    4	42.5000
    7	41.5000
    5	41.0000
    1	40.0000
    2	37.0000
    8	35.5000
    11	32.5000
    9	31.0000
    3	27.0000

Como entrega final do projeto, propomos a criação de três visualizações que apresentam métricas importantes para os proprietários analisarem. Explicaremos o funcionamento dessas visualizações e como elas podem ser úteis.

Aqui tem um exemplo de uso, de como utilizar essa informação. Apresentamos esse resultado. E aqui explicamos que essa métrica pode ser o próximo passo nesse projeto, utilizar essas três views.
Conclusão: Recapitulação dos Resultados e Sugestões para o Próximo Passo

    Conclusão

    Com base nas análises realizadas para apoiar os proprietários de imóveis no site da InsightPlaces, podemos concluir que há uma abordagem abrangente para fornecer insights valiosos. Ao analisar individualmente os proprietários, podemos identificar comportamentos semelhantes ou divergentes em termos de taxa de ocupação e total de dias disponíveis, fornecendo informações cruciais para entender a performance de cada proprietário.

    Além disso, ao examinar as regiões do país, foram calculados diversos valores importantes, como média de preço da diária, valor máximo, mínimo e média de dias alugados. Esses dados permitem que o time de negócios e os próprios proprietários avaliem se o comportamento de uma determinada região se reflete na situação de seus imóveis e, caso contrário, tomem medidas adequadas.

    As métricas desenvolvidas, através das views disponíveis, oferecem uma vantagem significativa, eliminando a necessidade de criar métricas manualmente e facilitando a análise de dados. Com uma consulta simples, como exemplificado, é possível obter informações valiosas sobre a ocupação por região ao longo do tempo.

    Portanto, o conjunto de análises e métricas apresentadas neste projeto visa atender aos objetivos de apresentar métricas úteis para decisões estratégicas e fornecer insights valiosos para os proprietários e o time de negócios. Essas informações são essenciais para que os proprietários possam tomar decisões informadas e maximizar o desempenho de seus imóveis no site da InsightPlaces.

Trazemos uma conclusão do projeto, que está recapitulando essa parte do porquê que estamos resolvendo esse problema, quem que é o nosso público-alvo, a análise que fizemos, as métricas que desenvolvemos, e fazemos essa sugestão de próximo passo do projeto.

É assim que funciona um relatório de negócios, que é a maneira que vamos encontrar de apresentar valor de fato com o nosso projeto. O nosso projeto não pode parar nas consultas SQL.

O próximo passo dele é o que vai agregar valor. Vamos incentivar o time de negócios a gerar insights, provocando-os a identificar proprietários específicos e sugerir estratégias para diferentes regiões do país, visando aumentar os lucros para as pessoas proprietárias. Também vamos orientá-las sobre como utilizar as métricas e visualizações que desenvolvemos.

Essa abordagem será a conclusão do projeto e a entrega de valor.
Conclusão do vídeo

O relatório inicial que criamos é simples, mas desejamos desafiá-los. Ao longo do projeto, vocês tiveram insights, análises e pensaram em métricas relacionadas aos dados; queremos que tragam tudo isso para este relatório.

É a forma como você vai apresentar o que construiu, explicando o processo, incluindo uma seção de relatório técnico que descreve como chegou aos resultados, quais técnicas de SQL utilizou, como criou uma visualização, e quais foram os critérios considerados importantes.

Essa prática é uma oportunidade de explicar suas ações, algo importante no mercado de trabalho, onde precisará apresentar relatórios técnicos para seus colegas de equipe, permitindo que entendam o funcionamento de suas consultas e a lógica por trás delas.

Estou muito feliz, conseguimos atender essa demanda. Agora, vamos falar com o time de negócios, para essas informações chegarem na pessoa proprietária, e chegarem no próprio time de negócios, para tomarem suas decisões. Conseguimos atender essa demanda. Até mais!

## Desafio: expandindo a análise e desenvolvendo soluções


Parabéns pelo seu trabalho até agora! Agora é hora de ir além e fornecer insights ainda mais valiosos para nossa equipe de negócios e proprietários. Gostaríamos que você:

    Crie novas views e procedures para agregar dados de maneiras diferentes.
    Analise tendências temporais e preveja padrões futuros.
    Você pode também incluir gráficos, tabelas e dashboards no relatório.
    Dica de ouro: Use suas habilidades para entender bem os dados, ou seja, reveja os vídeos, dê uma passada no fórum, refaça os exercícios e mãos à obra!

[relatorio](Relatorio%20Estudo%20Proprietarios%20-%20InsightPalces.docx)