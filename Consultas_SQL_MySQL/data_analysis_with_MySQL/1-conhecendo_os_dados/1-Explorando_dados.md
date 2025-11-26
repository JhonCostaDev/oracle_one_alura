```sql
-- Conhecendo os dados

-- explorando os dados
select * from alugueis LIMIT 10;
select * from avaliacoes LIMIT 10;
select * from clientes LIMIT 10;
select * from enderecos LIMIT 10;
select * from hospedagens LIMIT 10;
select * from proprietarios LIMIT 10;

-- Quantidade de linhas em cada tabela

SELECT
(SELECT COUNT(*) FROM alugueis) AS alugueis,
(SELECT COUNT(*) FROM avaliacoes) AS avaliacoes,
(SELECT COUNT(*) FROM clientes) AS clientes,
(SELECT COUNT(*) FROM enderecos) AS enderecos,
(SELECT COUNT(*) FROM hospedagens) AS hospedagens,
(SELECT COUNT(*) FROM proprietarios) AS proprietarios;
```

Uma subconsulta escalar é uma consulta que é incorporada dentro de outra consulta e retorna um único valor.

No nosso exemplo, cada subconsulta entre parênteses (SELECT COUNT(*) FROM tabela) é uma subconsulta escalar. Aqui está como elas funcionam:

Subconsulta Escalar: A subconsulta (SELECT COUNT(*) FROM tabela) é executada internamente para contar o número total de registros na tabela especificada. Ela retorna apenas um valor, que é o total de registros na tabela.

Incorporação na Consulta Principal: Cada subconsulta escalar é incorporada na cláusula SELECT da consulta principal. Isso significa que, em vez de retornar um conjunto de resultados como uma consulta típica, a consulta principal retorna uma única linha com múltiplas colunas, onde cada coluna contém o resultado de uma subconsulta escalar.

Uso de Aliases: Para tornar o resultado das subconsultas mais legível, elas são alias usando a palavra-chave AS seguida pelo nome do alias desejado (por exemplo, AS total_proprietarios). Isso permite que cada valor retornado pelas subconsultas seja referenciado facilmente na consulta principal.

Em suma, as subconsultas escalares são uma maneira eficaz de incluir resultados agregados ou valores específicos de uma tabela em uma consulta principal, fornecendo uma maneira conveniente de realizar operações de contagem ou agregação em conjunto com outras operações de consulta. No exemplo visto no nosso projeto, elas são usadas para contar o número total de registros em várias tabelas do banco de dados e apresentar esses totais em uma única linha de resultado.

Um exemplo de uma consulta que utiliza subconsultas escalares para contar o número total de registros em várias tabelas do banco de dados. Vou explicar cada parte da consulta:

SELECT
  (SELECT COUNT(*) FROM proprietarios) AS total_proprietarios,
  (SELECT COUNT(*) FROM clientes) AS total_clientes,
  (SELECT COUNT(*) FROM enderecos) AS total_enderecos,
  (SELECT COUNT(*) FROM hospedagens) AS total_hospedagens,
  (SELECT COUNT(*) FROM alugueis) AS total_alugueis,
  (SELECT COUNT(*) FROM avaliacoes) AS total_avaliacoes;
Copiar código
SELECT: É a instrução SQL que indica que você está selecionando dados de uma ou mais tabelas.
(SELECT COUNT(*) FROM proprietarios) AS total_proprietarios: Esta é uma subconsulta escalar que conta o número total de registros na tabela proprietarios e retorna esse valor como total_proprietarios. A palavra-chave AS é usada para atribuir um alias ao resultado da subconsulta.
(SELECT COUNT(*) FROM clientes) AS total_clientes: Semelhante à subconsulta anterior, esta subconsulta conta o número total de registros na tabela clientes e retorna esse valor como total_clientes.
(SELECT COUNT(*) FROM enderecos) AS total_enderecos: Mais uma vez, esta subconsulta conta o número total de registros na tabela enderecos e retorna esse valor como total_enderecos.
(SELECT COUNT(*) FROM hospedagens) AS total_hospedagens: Esta subconsulta conta o número total de registros na tabela hospedagens e retorna esse valor como total_hospedagens.
(SELECT COUNT(*) FROM alugueis) AS total_alugueis: Similar às subconsultas anteriores, esta subconsulta conta o número total de registros na tabela alugueis e retorna esse valor como total_alugueis.
(SELECT COUNT(*) FROM avaliacoes) AS total_avaliacoes: Finalmente, esta subconsulta conta o número total de registros na tabela avaliacoes e retorna esse valor como total_avaliacoes.
No final, a consulta resultará em uma única linha contendo o número total de registros em cada uma das tabelas especificadas.

E isso é importante para nosso aprendizado porque este tipo de consulta pode ser útil para obter uma visão geral do tamanho de cada tabela no banco de dados.