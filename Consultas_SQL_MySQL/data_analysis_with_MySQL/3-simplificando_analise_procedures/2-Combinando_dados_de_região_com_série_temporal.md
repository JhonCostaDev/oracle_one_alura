# Combinando dados de região com série temporal

Conseguimos realizar a análise por região e por tempo. No entanto, para fazer a análise de cada uma das regiões, teríamos que elaborar uma consulta complexa para incluir essa informação, e mesmo assim a visualização ficaria um pouco fragmentada, ou poderíamos repetir esse código. Assim, faríamos a mesma consulta para cada uma das regiões.

O problema disso é que acabaríamos com um script cheio de consultas repetitivas. Como podemos resolver isso?

Uma das ferramentas que temos no `MySQL` é a `Procedure`, que consiste em pegar a consulta que fizemos e colocá-la dentro de uma função, algo que receba um parâmetro e execute uma operação.

Para começar a fazer isso, preparamos um código, que é a combinação da consulta que fizemos anteriormente, com algumas pequenas modificações. Vamos analisar com atenção cada uma delas.
```sql
DELIMITER //

DROP PROCEDURE IF EXISTS get_dados_por_regiao;

CREATE PROCEDURE get_dados_por_regiao(regiao_nome VARCHAR(255))
BEGIN
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
        r.regiao = regiao_nome
    GROUP BY
        ano, mes
    ORDER BY
        ano, mes;
END//
DELIMITER ;
```

Estamos criando uma Procedure. O primeiro ponto é mudar o Delimiter. Para quem já estudou Procedure, sabe que precisamos indicar que ela encerrou, mas, ao mesmo tempo, cada consulta que fizermos dentro dela, precisamos indicar que ela encerrou também. Fazemos isso através do ponto e vírgula.

E para entender onde terminou a Procedure e onde terminou nossa consulta, usamos um delimitador diferente. Neste caso, estamos usando o //. Então, no início da criação da Procedure, colocamos o DELIMITER //. E, no final, depois dessa consulta, voltamos o DELIMITER com o ponto e vírgula.

Como vamos rodar dentro dessa Procedure? A primeira coisa que queremos verificar é se ela já existe. Se existe, será removida. Então, `DROP PROCEDURE IF EXISTS`. O nome da nossa Procedure é `get_dados_por_região`.

Queremos obter esses dados da série temporal por região. Como faremos isso? Através dessa Procedure. Então, CREATE PROCEDURE get_dados_por_região, onde ela recebe região_nome, que é um VARCHAR de 255. Pegamos essa informação na criação da nossa tabela, onde o nome da nossa região era um VARCHAR de 255.

Demos o nome para a nossa Procedure e agora podemos fazer o BEGIN dela, que nada mais é do que a consulta que já fizemos. Então, extraímos o ano, extraímos o mês e fazemos a contagem. Faremos isso através da tabela de aluguéis, onde faremos 3 JOIN de hospedagem, endereço e regiões geográficas.

A parte que precisaremos modificar aqui do que fizemos antes é o WHERE, porque lá, tínhamos essa variável fixa. Então, a região era sudeste. Aqui, queremos que varie. Então, esse filtro vai acontecer dependendo do parâmetro que a pessoa passar para a nossa Procedure. Então, essa região_nome. O resto é como a consulta se mantém, GROUP BY, ORDER BY, e encerramos a nossa Procedure com END //.




O get_dados_por_regiao é a Procedure que criamos. Mas qual é a vantagem dessa Procedure? Agora, para fazer essa exploração que estávamos fazendo, na nossa parte como pessoas analistas de dados, explorar esses dados, não vamos precisar repetir essa consulta várias vezes. Podemos apenas utilizar essa Procedure.

Para utilizá-la, você vai chamar a função `CALL`, o nome da Procedure e vai passar o parâmetro que criamos lá, que é a região. Então, você coloca a string da região. Então, por exemplo, a região "Sul".

```sql
CALL get_dados_por_regiao("Sul");
```
Pressionamos o Ctrl + Enter. Ele trouxe agora os dados para a região sul. Mas se quisermos fazer uma análise para a região norte, por exemplo? Então, você substitui, chama novamente a função e agora faz para "Norte".

De maneira simples, estamos tendo aquele mesmo resultado, mas ficou muito mais simples para fazer essa exploração desses dados. Então, você apenas passa essa string que você quer e explora a série temporal de total de aluguéis para cada uma das regiões.

É muito importante entender essa vantagem de utilizar essa Procedure nessa situação, que é conseguir fazer uma exploração mais fácil sem poluir o nosso script com várias consultas repetidas.

Então, se quisermos fazer uma pequena modificação, alinhamos com o time de negócios que vamos contar o total de aluguéis de uma maneira diferente. Não precisamos modificar em cada uma das consultas. Vamos na nossa Procedure, vamos atualizá-la, apagar e criar de novo, e está resolvido o nosso problema.

Conseguimos melhorar um pouco como estamos fazendo essa exploração desses nossos dados e acreditamos que podemos fazer esse mesmo processo de criar uma Procedure, uma solução para o restante da nossa exploração.

Não estávamos querendo explorar por cada um dos proprietários? Será que conseguimos utilizar essa Procedure para melhorar como exploramos esses dados? Vamos ver isso em breve.