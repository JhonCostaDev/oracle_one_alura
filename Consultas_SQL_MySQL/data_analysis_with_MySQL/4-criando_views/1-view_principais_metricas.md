# Criando uma view com as principais métricas para cada proprietário

Nosso projeto na empresa Insight Places já avançou bastante. Conseguimos construir métricas pensando nas pessoas proprietárias e também em estratégias mais gerais, como as regionais.

Calculamos todas as informações em relação aos aluguéis de forma regional, por região, e também por tempo.

Respondemos perguntas como: Em que época do ano essas métricas aconteceram? Em que ano isso aconteceu?. Estabelecer essas informações vai ajudar tanto a pessoa proprietária a tomar suas decisões quanto a equipe de negócios a decidir estratégias de com quem conversar e que tipo de argumento trazer.

No entanto, uma preocupação que temos agora é que elaboramos consultas bem complexas.

Algumas estão bem acessíveis, como as que construímos, as procedures. Você pega a procedure, passa a informação, como, por exemplo, o ID da pessoa proprietária, obtém algumas informações sobre ela, ou também para a região, então você passa a região que deseja e terá informações sobre ela.

Mas mesmo assim, nosso script está um pouco complexo, e gostaríamos de encontrar uma maneira de apresentar esses resultados de maneira mais simples para a equipe de negócios.

Eles podem ter essa consulta, esse acesso ao banco de dados, mas não queremos ter que elaborar todo esse script, explicar para eles cada uma das etapas, isso poderia tomar um tempo que eles não têm, eles têm que focar no negócio.

Precisamos transformar a construção que fizemos aqui em algo mais real. Como podemos fazer isso?

Já tivemos uma solução que acessávamos com facilidade, que são as próprias tabelas. As tabelas são bem claras em seu funcionamento.

Elas têm suas colunas, então, por exemplo, a tabela de hospedagem. Temos as informações que se conectam com a pessoa proprietária, que tipo de hospedagem temos, as informações estão bem claras ali, e alguém com conhecimento inicial de SQL consegue consultar essa tabela.

Queremos transformar nossas consultas em uma tabela, e existe esse recurso no SQL. Temos as `views`, a view tem o propósito de criar uma tabela cuja origem vem da consulta. Vamos resolver isso no código?

A primeira parte que queremos abordar com vocês é em relação às pessoas proprietárias, as informações individuais de cada pessoa, onde temos métricas sobre as pessoas proprietárias, queremos construir isso em uma view.

Preparamos o código aqui, que é uma consulta que já desenvolvemos juntos.
```sql
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
```
Temos aquela consulta que já trabalhamos, que usamos o SELECT para pegar o nome da pessoa proprietária, calculamos o total de hospedagens, a primeira data, o total de dias, e a taxa de ocupação, que é a nossa métrica aqui.

Queremos transformar isso de uma maneira que fique acessível, não queremos ter que explicar toda essa consulta, de onde estão vindo esses dados, só queremos que a pessoa entenda as colunas que tem, que vão ser todas essas que aparecem aqui, são seis colunas, e tenha esse resultado de maneira fácil para poder explorar, realizar suas próprias consultas em cima dessa tabela que vamos criar.

A única diferença que você pode notar aqui no nosso script é o início dele, que é justamente o código que vai criar essa view.

`CREATE VIEW view_metricas_proprietario AS`

Com esse código vamos ser capazes de transformar essa consulta em uma tabela, que vai ser uma view. Podemos clicar aqui, usar o Insights Place para definir o banco de dados, e depois a criação da nossa tabela.

Lembrando que esse script aqui tem duas partes, que ele tem uma subconsulta dentro dele, então primeiro ele faz os cálculos para uma hospedagem, e depois ele realiza os cálculos para a pessoa proprietária, que pode ter mais de uma hospedagem.

Como estamos criando algo, assim como quando criávamos as procedures, ele não tem um retorno imediato, então se formos no canto superior direito, podemos ver as consultas que rodaram, e a última consulta que rodou foi a CREATE VIEW. Então, o código rodou corretamente.

### Mas como isso funciona na prática? Como utilizamos essa view?

Para utilizar uma view, é da mesma maneira que você utiliza uma tabela. Então, você pode fazer um:

```sql
SELECT * FROM view_metricas_proprietario;
```

Ao executar essa linha, ele retorna para nós a tabela com as informações.


Então, a pessoa da área de negócios que for trabalhar com o nosso script, ela só precisa saber da existência dessa view, e ela vai ter todas as informações. Ah, mas como é feito o cálculo total de hospedagem? Como é encontrada a primeira data?

Isso o time de pessoas analistas de dados, que somos nós, nos preocupamos em criar. Eles só precisam pensar em insights que eles queiram explorar nessa tabela. Vão poder explorar esses dados de uma maneira muito mais simples, com as métricas que propusemos para eles analisarem.

Isso pode chegar também no time das pessoas proprietárias, para elas trabalharem com essas informações, mas elas não vão ter acesso ao banco de dados, elas vão ter uma maneira diferente que vamos explorar na próxima aula.

Estamos muito satisfeitos que fizemos isso para as pessoas proprietárias, mas agora queríamos repetir esse processo para as outras informações que construímos.

Resolvemos esse problema através das views. Então, relembrando, a view preenche uma tabela, mas que ela é preenchida por uma consulta. Isso tem o custo de processamento. Ele roda essa query para construir essa tabela.

Não é como os dados que estão armazenados. Então, diferente dos dados armazenados, que eles são apresentados para nós, aqui rola um processamento para apresentar esses dados para nós. Então, cada um vai ter seu propósito. Tem vezes que é melhor você salvar esses dados em um formato de tabela e tem vezes que vai fazer sentido criar uma view, que é o nosso caso.

Estamos ansiosos para resolver isso para as próximas métricas. Continuaremos no próximo vídeo!

## Para saber mais: Views e Procedures no MySQL

Agora vamos retomar um pouco sobre `Views` e `Stored Procedures` no MySQL, com exemplos, suas finalidades, além dos pontos positivos e negativos de cada um:
Views:

### O que são Views?

Views são consultas SQL armazenadas que são tratadas como tabelas virtuais. Elas consistem em uma consulta pré-definida que é armazenada no banco de dados. Essa consulta pode ser referenciada e utilizada como se fosse uma tabela real.

### Quando usar Views?

* **Simplificar consultas complexas**: Se você tem consultas complexas que são frequentemente usadas, uma view pode simplificar o acesso a esses dados.
* **Segurança**: Views podem ser usadas para limitar o acesso aos dados, exibindo apenas as colunas ou linhas necessárias para determinados usuários.
* **Reutilização de consultas**: Views podem ser utilizadas para reutilizar consultas comuns em diferentes partes de uma aplicação.

### Propósito:

    * Facilitar o acesso a dados complexos.
    * Fornecer uma camada de abstração para a segurança.
    * Promover a reutilização de consultas.

### Exemplo:

> Suponha que temos uma tabela chamada pedidos com colunas id, cliente_id, data, valor, e queremos uma view que mostre apenas os pedidos realizados no último mês.

```sql
CREATE VIEW pedidos_ultimo_mes AS
SELECT * FROM pedidos
WHERE data >= CURDATE() - INTERVAL 1 MONTH;
```
## Pontos Positivos:

   * Simplifica consultas complexas.
   * Oferece uma camada de segurança.
   * Promove a reutilização de consultas.

### Pontos Negativos:

    * Pode afetar o desempenho, especialmente se a consulta subjacente for complexa.
    * Limitações em relação a atualizações (dependendo da complexidade da view).

## Stored Procedures:

### O que são Stored Procedures?

Stored Procedures são conjuntos de instruções SQL que são armazenadas no banco de dados e podem ser chamadas e executadas repetidamente.

### Quando usar Stored Procedures?

    * `Lógica de Negócios`: Para armazenar e isolar a lógica de negócios no banco de dados, tornando-a reutilizável e fácil de manter.
    * `Melhor desempenho`: Stored Procedures podem oferecer melhor desempenho em comparação com consultas comuns enviadas do aplicativo para o banco de dados.
    * `Transações`: Para executar várias operações como parte de uma transação.

### Propósito:

    * Armazenar e isolar a lógica de negócios no banco de dados.
    * Promover a reutilização de código.
    * Melhorar o desempenho.

### Exemplo:

Vamos criar um stored procedure simples que retorna o número total de pedidos para um cliente específico.

```sql
DELIMITER $$
CREATE PROCEDURE total_pedidos_cliente (IN cliente_id INT, OUT total_pedidos INT)
BEGIN
    SELECT COUNT(*) INTO total_pedidos
    FROM pedidos
    WHERE cliente_id = cliente_id;
END $$
DELIMITER ;
```
### Pontos Positivos:

    * Promove a separação em partes e reutilização de código.
    * Pode aumentar o desempenho.
    * Melhora a segurança, já que os usuários podem ser concedidos apenas acesso aos stored procedures, em vez de tabelas diretamente.

### Pontos Negativos:

    * Menos flexível do que consultas comuns em alguns casos.
    * Pode tornar o processo de depuração mais difícil.
    * Requer conhecimento adicional de uma linguagem de programação (como SQL/PLSQL).

Em resumo, tanto Views quanto Stored Procedures são ferramentas poderosas no MySQL para melhorar a eficiência, a segurança e a modularidade do banco de dados. A escolha entre eles depende das necessidades específicas do seu projeto e das características de desempenho desejadas.