# Aplicando o cursor na inclusão de múltiplos aluguéis


No painel à esquerda, onde temos a lista dos componentes do banco de dados, clicaremos em `"Stored Procedures > Refresh All"` para atualizar e buscar pelo script looping_cursor_54 que criamos no vídeo anterior sobre cursor.

Vamos clicar com o botão direito sobre ele e escolher a opção "`Alter Stored Procedure`" para poder visualizar o conteúdo da procedure. Vamos copiar todo esse conteúdo e colar em um bloco de notas para usá-lo como base.

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `looping_cursor` ()
BEGIN
    DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vnome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temp_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;

    OPEN cursor1;
    FETCH cursor1 INTO vnome;

    WHILE fimCursor = 0 DO
        SELECT vnome;
        FETCH cursor1 INTO vnome;
    END WHILE;

    CLOSE cursor1;
END
```
Para criá-la via script, é preciso fazer uma modificação. Vamos apenas modificar o nome da procedure para looping_cursor e clicar em "Apply".

Na janela de revisão do script, vamos copiar o trecho com os delimitadores e colá-lo novamente no bloco de notas.

```sql
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `insightplaces`.`looping_cursor_55`;
;

DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `looping_cursor_55`()
BEGIN
    DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vnome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temp_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;

    OPEN cursor1;

    FETCH cursor1 INTO vnome;
    WHILE fimCursor = 0 DO
        SELECT vnome;
        FETCH cursor1 INTO vnome;
    END WHILE;

    CLOSE cursor1;
END$$

DELIMITER ;
;
```
Podemos clicar em "Cancel", pois não queremos alterar a procedure original.

Além disso, vamos anotar a última procedure que fizemos que incluía um novo aluguel para um cliente. No nosso caso foi a novoAluguel_14, então vamos adicionar um comentário com o nome dela assim como o declaramos.

```sql
-- novoAluguel_44
```
Agora, vamos criar um novo script, onde colaremos todo o código.

Porém, modificaremos o nome da stored procedure para novosAlugueis_15, no plural e com o número da rotina. Devemos modificar o nome da procedure tanto no comando `DROP PROCEDURE` quanto no `CREATE PROCEDURE`.

Essa rotina vai incluir os aluguéis, portanto, devemos passar como parâmetro todas as informações referentes ao aluguel. Primeiro, teremos a `lista de clientes`, que vai ser um VARCHAR de 255.

Depois vamos incluir todos os parâmetros que precisamos e que usamos na novoAluguel_14.

Para fazer isso, vamos acessar o novoAluguel_14 com botão direito do mouse e escolhendo "`Alter Stored Procedure`". Copiaremos todos os parâmetros declarados, exceto vClienteNome, porque já vamos passar a lista com os nomes dos clientes. Então, copiaremos vHospedagem, vDataInicio, vDias e vPrecoUnitario.

Além disso, dentro de `BEGIN`, vamos declarar a variável `vClienteNome`, que será um `VARCHAR de 150`.

Inicialmente, depois que declararmos o cursor, mas antes de abri-lo, vamos executar o código `DROP` e `CREATE` para excluir e criar a tabela temporária. E, claro, vamos passar o conteúdo da lista para dentro da tabela temporária, usando o CALL.

```sql
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `insightplaces`.`novosAlugueis_15`;
;

DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novosAlugueis_15`(lista VARCHAR(255), vHospedagem VARCHAR(10), vDataInicio DATE, vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vClienteNome VARCHAR(150);
    DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vnome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temp_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    DROP TEMPORARY TABLE IF EXISTS temp_nomes;
    CREATE TEMPORARY TABLE temp_nomes (nome VARCHAR(255));
    CALL inclui_usuarios_lista_52(lista);
    OPEN cursor1;
    FETCH cursor1 INTO vnome;
    WHILE fimCursor = 0 DO
        SELECT vnome;
        FETCH cursor1 INTO vnome;
    END WHILE;
    CLOSE cursor1;
END$$

DELIMITER ;
;
```
Em resumo, passamos a lista de clientes e todos os outros parâmetros necessários para definir um aluguel.

Fizemos a declaração da variável vClienteNome, a declaração do fimCursor e a variável vnome. Na verdade, essa variável vnome é a variável vClienteNome, mas vamos mantê-la, porque estamos usando o esqueleto da criação do cursor que fizemos no vídeo anterior.

Declaramos o cursor1, declaramos o fim dele com o HANDLER. Só então apagamos e criamos a tabela temporária para depois passar a lista para dentro dela.

Após a linha do CALL, temos todos os nomes que farão parte do aluguel dentro da tabela. Ao abrir o cursor, o conteúdo da tabela vai para a memória.

Por isso, não tem problema colocar o SELECT antes de criar a tabela, porque é apenas uma declaração. Ele vai executar o SELECT no momento que abrirmos o cursor.

Em outras palavras, a tabela tem que existir somente no momento que abrirmos o cursor. E ela existirá, porque a criamos com CREATE TEMPORARY TABLE.

Depois disso, vamos percorrer o cursor com o WHILE. Nesse momento qual é o conteúdo da variável vnome? É o nome de um cliente.

Por isso, ao invés de fazer um SELECT, devemos fazer SET vClienteNome igual vnome. Ao fazer isso, temos um cliente e também temos todos os dados referentes ao alugue. Além disso, já temos a criação automática do ID do aluguel na rotina novoAluguel_44, portanto, não precisamos mais nos preocupar com o identificador do aluguel.

O que vamos faremos depois do SET? Vamos dar um CALL na novoAluguel_44, passar como parâmetro vClienteNome, vHospedagem, vDataInicio, vDias, vPrecoUnitario. Nesse caso, não precisamos dizer o tipo da variável.

Dessa maneira, vamos percorrer o cursor incluindo um aluguel de forma individual, baseado na lista de nomes que está contida dentro da tabela temp_nomes.

E claro, depois que acabarmos e fecharmos o cursor, vamos dar um DROP para garantir que a tabela temporária foi apagada.

```sql
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `insightplaces`.`novosAlugueis_55`;
;

DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novosAlugueis_55`(lista VARCHAR(255), vHospedagem VARCHAR(10), vDataInicio DATE, vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vClienteNome VARCHAR(150);
    DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vnome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temp_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    DROP TEMPORARY TABLE IF EXISTS temp_nomes;
    CREATE TEMPORARY TABLE temp_nomes (nome VARCHAR(255));
    CALL inclui_usuarios_lista_52(lista);
    OPEN cursor1;
    FETCH cursor1 INTO vnome;
    WHILE fimCursor = 0 DO
        SET vClienteNome = vnome;
        CALL novoAluguel_44 (vClienteNome, vHospedagem, vDataInicio, vDias, vPrecoUnitario);
        FETCH cursor1 INTO vnome;
    END WHILE;
    CLOSE cursor1;
    DROP TEMPORARY TABLE IF EXISTS temp_nomes;
END$$

DELIMITER ;
;
```
Ao selecionar e executar esse script completo, não deu nenhum erro. Vamos atualizar as stored procedures e conferir se foi criado os novosAlugueis_55.

Para testar, vamos pegar o script onde chamamos a rotina novoAluguel_44(), usando as informações da Lívia Fogaça, na hospedagem 8636, a partir do dia 29 de maio, por 5 dias e uma diária de 45 reais.

CALL novoAluguel_44('Lívia Fogaça', '8635', '2023-05-29', 5, 45);
Copiar código
Vamos copiar a rotina para o script atual e modificá-la.

Primeiro, vamos chamar a rotina novosAlugueis_55(). Esse aluguel agora vai ser em 2023-06-03, por 7 dias e a diária continua 45.

Só que agora não vamos ter um cliente. Na verdade, será uma lista de clientes. Nesse caso, colocaremos quatro clientes: Gabriel Carvalho, Erick Oliveira, Catarina Correia e Lorena Jesus.

Lembra que fizemos a lógica de buscar uma string dos nomes separados por vírgula e jogar na tabela? É importante que a vírgula fique colada tanto no nome da esquerda quanto no nome da direita. Senão, a nossa lógica não vai funcionar.
```sql
CALL novosAlugueis_55('Gabriel Carvalho,Erick Oliveira,Catarina Correia,Lorena Jesus', '8635', '2023-06-03', 7, 45);
```
Retomando, chamamos novosAlugueis_55, passamos quatro clientes, o identificador da hospedagem, a data inicial, o número de diárias e o preço da diária.

Após executar, os aluguéis foram incluídos na base com sucesso com ID 10014, 10015, 10016 e 10017. Tivemos quatro saídas de vMensagem, pois foram quatro clientes.

Por fim, vamos conferir os dados da tabela alugueis somente onde aluguel_id seja igual a um dos quatro aluguéis que foram incluídos automaticamente nessa rotina.

```sql
SELECT * FROM alugueis WHERE aluguel_id IN ('10017', '10016', '10015', '10014');
```
    aluguel_id	  cliente_id	hospedagem_id	data_inicio	data_fim	preco_total
    10014	        1024	       8635	        2023-06-03	2023-06-13	315.00
    10015	        1026	       8635	        2023-06-03	2023-06-13	315.00
    10016	        1031	       8635	        2023-06-03	2023-06-13	315.00
    10017	        1032	       8635	        2023-06-03	2023-06-13	315.00
    NULL	        NULL	       NULL	        NULL	        NULL	 NULL
Após executar, conferimos que os IDs dos aluguéis foram incrementados de forma automática e os IDs desses clientes foram inseridos corretamente. E todos os outros dados são iguais. Ou seja, tratamos os múltiplos aluguéis conforme a Insight Places nos orientou.

Essa procedure de novosAlugueis_55 é a final, pois resolve o problema da Insight Places que discutimos no primeiro vídeo desse curso.

# QUESTION - Entendendo a Procedure
 Próxima Atividade

Observe e analise a versão final da procedure de gerenciamento de aluguéis:

CREATE DEFINER=`root`@`localhost` PROCEDURE `novosAlugueis_55`(lista VARCHAR(255),
vHospedagem VARCHAR(10), vDataInicio DATE,
vDias INTEGER, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vClienteNome VARCHAR(150);
    DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vnome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temp_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
    DROP TEMPORARY TABLE IF EXISTS temp_nomes;
    CREATE TEMPORARY TABLE temp_nomes (nome VARCHAR(255));
    CALL inclui_usuarios_lista_52(lista);
    OPEN cursor1;
    FETCH cursor1 INTO vnome;
    WHILE fimCursor = 0 DO
        SET vClienteNome = vnome;
        CALL novoAluguel_44 (vClienteNome, vHospedagem, vDataInicio, vDias, vPrecoUnitario);
        FETCH cursor1 INTO vnome;
    END WHILE;
    CLOSE cursor1;
    DROP TEMPORARY TABLE IF EXISTS temp_nomes;
END
Copiar código
Considerando a interpretação desses dados, qual é a sequência correta de operações realizada pela procedure novosAlugueis_55 para incluir múltiplos aluguéis a partir de uma lista de nomes?

Selecione uma alternativa

A procedure converte a lista de nomes em um array JSON para processamento direto na inserção dos aluguéis.


A procedure ignora a lista fornecida e insere um conjunto padrão de aluguéis na base de dados.


Realiza um loop direto na lista de nomes sem uso de tabelas temporárias ou cursores, inserindo aluguéis de forma massiva.


Exclui todos os registros existentes na base de dados antes de processar a lista de nomes para inclusão de novos aluguéis.


Cria uma tabela temporária, insere os nomes da lista nela, e usa um cursor para processar cada nome individualmente, chamando outra procedure para cada inclusão.