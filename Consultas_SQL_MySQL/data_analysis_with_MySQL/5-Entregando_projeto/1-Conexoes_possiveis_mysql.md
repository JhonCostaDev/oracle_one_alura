# Conhecendo as conexões possíveis com o MySQL

## Avanço do Projeto

Nós, como equipe de pessoas analistas de dados da Insight Places, já avançamos muito neste projeto. Estamos agora na etapa final de entregar métricas e dados para a equipe de negócios e, principalmente, para a pessoa proprietária. Uma questão é que focamos na análise, criamos métricas, geramos esses dados, mas ainda não está claro como essas informações chegarão à pessoa proprietária.
Alternativas de Acesso aos Dados

Para isso, precisamos entender que, dificilmente, quando estamos fazendo uma análise de dados, nossa entrega final será uma consulta SQL. Existe a possibilidade de capacitar a equipe de negócios a executar consultas SQL diretamente no banco de dados, dando-lhes autonomia para responder perguntas de negócios.
Criação de Interface para a Pessoa Proprietária

Entretanto, é importante compreender que podemos disponibilizar esses dados e informações de diversas formas, facilitando sua análise e permitindo focar no negócio, atendendo assim às exigências da pessoa proprietária.

Pensando nisso, quero explorar algumas alternativas com você sobre como esses dados serão trabalhados em produção no mundo real. Criamos views que podem ser facilmente consumidas. Uma das possibilidades é criar para a pessoa proprietária uma interface.

Temos uma equipe de pessoas desenvolvedoras na* Insight Place*, onde podemos ter uma reunião com elas: nós, analistas de dados, as pessoas da área de negócios e as pessoas desenvolvedoras, e chegar a uma solução para a pessoa proprietária.
Dashboard no Power BI e Conexão com Banco de Dados

Como a pessoa proprietária pode acessar essas informações? Fiz uma versão inicial, um MVP (Produto viável mínimo) deste projeto, para entendermos claramente como funciona. Não se preocupe em entender como está esse código, fiz um código em Python para analisarmos, mas não se preocupe em entender como ele funciona.

Não precisamos entender como cada parte funciona detalhadamente, mas sim reconhecer sua existência e compreender que o que desenvolvemos até agora será utilizado dessa forma.

Ao abrir o VS Code, nos deparamos com um código no arquivo app.py que cria uma aplicação web.

    app.py
```python
// código omitido

# Database configuration
db_config = {
    'host': os.getenv('MYSQL_HOST'),
    'user': os.getenv('MYSQL_USER'),
    'password': os.getenv('MYSQL_PASSWORD'),
    'database': os.getenv('MYSQL_DATABASE')
}

// código omitido
```
O ponto importante aqui é que essa aplicação se conectará a um banco de dados. Ou seja, realizará consultas SQL, utilizará senhas, e selecionará o banco de dados chamado Insight Places.
```python
// código omitido

# Query to identify months with highest demand in selected region
if region == 'All' and month == 'All':
    query = """
        SELECT
            mes,
            AVG(total_alugueis) AS media_alugueis
        FROM
            ocupacao_por_regiao_tempo
        GROUP BY
            mes
        ORDER BY
            media_alugueis DESC;
    """
elif region == 'All':

// código omitido
```
O destaque está no fato de que, para que o site funcione adequadamente, ele executa consultas SQL específicas. Há um comando SELECT que escolhe o mês, calcula médias de aluguéis usando a view que criamos anteriormente, a ocupacao_por_regiao_tempo. Essas métricas são utilizadas para fornecer resultados à pessoa proprietária.

Como ficou o resultado final? Agora temos uma página web onde a pessoa proprietária pode explorar os dados da região.

    Endereço acessado pelo instrutor: 127.0.0.1:5000/region=All&month=All

    Na página, encontram-se dois campos disponíveis: um para escolher a região e outro para selecionar o mês, juntamente com um botão denominado "Enviar". Abaixo, há uma tabela com os campos "Mês" e "Média de Aluguéis".
    Mês	Média de Aluguéis
    10	63.4000
    7	62.5000
    6	60.6000
    4	60.2000
    5	60.0000
    12	59.7000
    1	59.3000
    8	57.4000
    2	57.1000
    9	56.8000
    11	55.8000
    3	42.0000

Por exemplo, se pertence à região norte e está interessada nos dados de janeiro, basta clicar em "Enviar" para receber um retorno mostrando que a média dos aluguéis em janeiro na região norte foi de 44.
Mês	Média de Aluguéis
1	44.0000

Com isso, consegue compreender se esse resultado está dentro das métricas desejadas.

No entanto, sua intenção vai além; ela deseja analisar o comportamento ao longo do ano na região para entender se os números desfavoráveis que observou foram generalizados. Para isso, pode selecionar novamente a região norte e deixar o campo do mês como "todos".
Mês	Média de Aluguéis
7	49.5000
8	48.5000
5	47.5000
6	47.0000
10	46.0000
12	46.0000
1	44.0000
4	43.5000
9	43.0000
11	43.0000
2	41.5000
3	34.6667

A página apresentará uma lista ordenada pela média de aluguéis, permitindo que ela observe, por exemplo, que março teve a menor média de aluguéis na região norte, e assim por diante. Dessa forma, ela pode acessar facilmente esses dados e métricas sem precisar usar SQL ou qualquer outra ferramenta, graças à nossa interface de aplicação.

No entanto, essa solução parece distante para nós, pessoas analistas de dados. Parece ser mais direcionada à equipe de pessoas desenvolvedoras do que a nós. Será que não podemos criar um produto final que seja acessível tanto para a pessoa proprietária quanto para a equipe de negócios? Certamente podemos. Para alcançar isso, precisamos aprimorar nossas habilidades em ferramentas de Business Intelligence (BI) e criar dashboards.

Uma das maneiras de apresentar esses valores, resultados e estudos é por meio de dashboards, e temos soluções como o Looker Studio da Google ou o Power BI da Microsoft. Para isso, será necessário adquirir conhecimento em dashboards e também estabelecer uma conexão com o banco de dados.

Aqui está um dashboard que preparei para analisarmos juntos.

    No dashboard apresentado, notamos um gráfico de barras verticais intitulado "Soma de total_aluguéis por região" e um gráfico de linha à direita com o título "Soma de total_aluguéis por Ano, Trimestre, Mês e Dia". Logo abaixo desses gráficos, encontramos duas tabelas: à esquerda, os campos incluem "região", "média_dias_aluguel", "max_preço_dia", "min_preço_dia" e "média_preço_aluguel"; à direita, os campos são "proprietario", "primeira_data" e "Média de dias_ocupados".

Esse dashboard foi criado com o objetivo principal de mostrar as métricas que desenvolvemos. Embora não seja ideal para apresentar ao cliente, serve perfeitamente para nosso propósito de entender que esses dados são os que construímos. À direita do dashboard, temos os seguintes dados:

    insightplaces ocupacao_por_regiao_tempo
    insightplaces view_dados_regiao
    insightplaces view_metricas_proprietario

No Power BI, estamos realizando uma conexão com o banco de dados MySQL e acessando o banco "Insight Places", juntamente com as views "Ocupação por região e tempo", "Dados por região" e "Métricas do proprietário". Essa conexão com nossas views nos permite criar visualizações para o cliente.

Temos um gráfico de barras que mostra os aluguéis por região, o que facilita a interpretação dos dados para obter ideias valiosas. Ao dar uma analisada rápida, percebemos que a região Nordeste se destaca, enquanto a Sudeste está em último lugar. Embora uma análise mais aprofundada seja necessária, o gráfico já evidencia essa informação de forma clara.

Outro dado importante para incluir em um dashboard, onde é possível criar diversos tipos de gráficos, é a série temporal. Uma análise temporal é mais eficaz quando apresentada em formato de gráfico. Aqui, temos o histórico dos aluguéis ao longo do tempo.

Observamos que os dados estão bastante estáveis, com uma queda em 2024, possivelmente devido à incompletude dos dados neste mês específico. Além disso, fornecemos informações completas por região nas tabelas abaixo, incluindo a média de aluguel, preço máximo, preço mínimo e média de aluguéis.

Essas são as visualizações que desenvolvemos, com uma consulta complexa por trás para calcular esses valores, bem como informações detalhadas para cada proprietário na tabela à direita.

Esta é uma das formas pelas quais podemos apresentar esses resultados à equipe de negócios ou aos proprietários. Podemos criar um dashboard que utilize essas métricas e análises que realizamos para informar os clientes ou a equipe de negócios. É muito gratificante ver como podemos contribuir para as equipes com o próximo passo, entregando valor real e garantindo que suas consultas tenham propósito e relevância.
Conclusão e Próximos Passos

Se você se interessou por esse conteúdo, mesmo que seja na área de Desenvolvimento e esteja um pouco distante de nós, como na criação de dashboards, temos vários cursos disponíveis nesta plataforma para você explorar e aprimorar essa habilidade, que será muito relevante para sua carreira como analista de dados.

No entanto, considerando o momento atual do projeto, precisamos resolver como vamos lidar com isso. Não temos tempo para aprender a usar o Power BI agora, e talvez não faça sentido envolver a equipe de desenvolvedores tão cedo, especialmente se estivermos lidando com um MVP.

Estou pensando em uma solução comum na área de negócios, que é uma das maneiras de agregar valor, especialmente no início de um projeto. Vamos explorar isso juntos em breve.