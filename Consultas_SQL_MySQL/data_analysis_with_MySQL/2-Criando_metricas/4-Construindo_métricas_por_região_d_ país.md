# Construindo métricas por região do país
Inserindo uma nova tabela no banco de dados

Para adicionar uma nova tabela, seguiremos o procedimento de clicar em "File > Open SQL Script…" para abrir um script SQL, o qual já deixamos preparado para você fazer o download e carregar.

    8-regioes_geograficas.sql:

USE insightplaces;
-- Exclui a tabela se ela já existir
DROP TABLE IF EXISTS regioes_geograficas;

-- Cria a tabela regioes_geograficas
CREATE TABLE regioes_geograficas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    estado CHAR(2), -- Ajustado para usar a sigla do estado
    regiao VARCHAR(50)
);

-- Inserindo dados na tabela com as siglas dos estados
INSERT INTO regioes_geograficas (estado, regiao) VALUES
('SP', 'Sudeste'),
('RJ', 'Sudeste'),
('MG', 'Sudeste'),
('ES', 'Sudeste'),
('PR', 'Sul'),
('SC', 'Sul'),
('RS', 'Sul'),
('BA', 'Nordeste'),
('PE', 'Nordeste'),
('CE', 'Nordeste'),
('MA', 'Nordeste'),
('PB', 'Nordeste'),
('AM', 'Norte'),
('PA', 'Norte'),
('RO', 'Norte'),
('AC', 'Norte'),
('GO', 'Centro-Oeste'),
('MT', 'Centro-Oeste'),
('MS', 'Centro-Oeste'),
('DF', 'Centro-Oeste');

O script que devemos abrir é o 8-regioes_geograficas.sql, e ele cria justamente a associação de cada estado com as regiões do país, então temos "Sudeste", "Sul", "Nordeste", "Norte" e "Centro-Oeste".

Após executar todo o script, teremos uma nova tabela. Podemos clicar no primeiro ícone do canto superior direito para visualizá-la em "insightplaces > Tables". Na lista, teremos a tabela regioes_geograficas. Com essa informação, conseguimos associar os estados às regiões.
Criando uma nova consulta

Feito isso, podemos retornar ao script original, onde temos a formação por estado, e tornar a consulta mais macro, para realizar outros tipos de análise e tomar decisões diferentes.

Nesse caso, basta acrescentar um novo JOIN à consulta anterior:

-- código omitido

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

Abaixo do JOIN com a tabela enderecos, fizemos um novo JOIN com a tabela que acabamos de criar, isto é, regioes_geograficas. Em seguida, demos o apelido r para ela, e após o ON, definimos r.estado igual a e.estado. Assim, associamos as linhas pelo estado.

As informações novas da tabela regioes_geograficas são adicionadas no GROUP BY, onde passamos r.regiao. Feito isso, onde chamamos e.estado na consulta anterior, substituímos por r.regiao.
Executando a nova consulta

Agora que temos as informações mais macro, vamos executar a consulta para conferir se funciona conforme esperado. Após a execução, é retornada a seguinte tabela:
regiao	media_preco_aluguel	max_preco_dia	min_preco_dia	media_dias_aluguel
Sudeste	545.4984193888	998.000000	102.000000	3.8809
Centro-Oeste	552.0123674912	1000.000000	100.000000	3.9293
Nordeste	557.3815602837	1000.000000	100.000000	3.9428
Sul	543.3395204950	999.000000	100.000000	3.9435
Norte	522.9954669084	1000.000000	100.000000	4.0218

Observe que conseguimos a informação não por cada um dos estados, mas por regiões: temos a média de preço de aluguel (media_preco_aluguel), o máximo diário (max_preco_dia), o mínimo (min_preco_dia), e a média de dias alugados (media_dias_aluguel).

Com esses dados, levando em consideração que temos uma cópia da base de dados da Insight Places, podemos ter resultados um pouco diferentes ao rodar em produção.

Porém, a partir desse resultado, conseguimos fazer uma análise e entender como está o comportamento com essa amostra de dados. Há estados que alugam mais? Regiões do país onde as pessoas ficam mais dias hospedadas? A diária do aluguel é cobrada por um valor maior em determinados locais?

Trazer essa variável de região para a nossa análise é muito importante, assim como foi trazer a variável do tempo. Dessa forma, a análise fica muito mais rica.

Com isso em mãos, podemos fornecer para o time de negócios ou para a própria pessoa proprietária tomar as decisões. Transformamos os dados em informações novas para fazer diferentes análises.
Conclusão

Perceba que repetimos alguns processos com muita frequência, como o cálculo da diferença das datas, o relatório para cada uma das regiões ou para cada época do ano, e assim por diante.

Será que conseguimos melhorar esse script, para trazer uma mecânica que facilite a exploração dos dados? Resolveremos esse problema na próxima aula!