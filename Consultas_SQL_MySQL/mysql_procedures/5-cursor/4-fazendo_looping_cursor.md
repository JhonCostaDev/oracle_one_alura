# Fazendo o looping com o cursor



## Criando o primeiro CURSOR
Primeiro, vamos clicar em "Stored Procedures" no painel de navegação à esquerda para criar uma nova stored procedure que chamaremos de looping_cursor_54, que é o número do vídeo.

Não vamos passar nenhum parâmetro, pois esse CURSOR vai percorrer a tabela temp_nomes.

```sql
CREATE PROCEDURE `looping_cursor` ()
BEGIN
END
```
Em BEGIN, vamos declarar a variável que vai controlar o fim do CURSOR quando o loop acabar. Ou seja, quando dermos um FETCH e não existir mais linha no CURSOR. Nesse caso, chamaremos essa variável de fimCursor que será um INTEGER DEFAULT 0.

Em seguida, vamos declarar uma variável chamada vnome, pois vai receber o nome que estamos lendo no momento que damos o FETCH. Ela será um VARCHAR de 255.

Agora, vamos declarar o CURSOR que chamaremos de cursor1. Na mesma linha, digitamos CURSOR FOR e a consulta SELECT nome FROM temp_nomes. Assim, carregamos o conteúdo da tabela dentro do CURSOR.

Também devemos criar a exceção para que a variável fimCursor mude seu valor de 0 para 1 quando chegarmos no fim do CURSOR. Para isso, declaramos CONTINUE HANDLER FOR NOT FOUND SET fimCursor igual à 1.

```sql
CREATE PROCEDURE `looping_cursor` ()
BEGIN
    DECLARE fimCursor INTEGER DEFAULT 0;
    DECLARE vnome VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT nome FROM temp_nomes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimCursor = 1;
END
```

Agora, vamos abrir o CURSOR com OPEN cursor1.

Ao abrir o CURSOR, é preciso primeiro posicionar o ponteiro interno na primeira posição. Para isso, basta fazer o primeiro FETCH de cursor1 na variável vnome.

Aí, sim, criaremos um loop usando WHILE/DO, para que, enquanto o fimCursor for igual a 0, aconteça algo.

Durante esse WHILE, o que vamos fazer? Daremos um SELECT vnome para visualizar o conteúdo da variável. Em seguida, daremos o próximo FETCH.

Quando fimCursor1 for 1, significa que chegamos no fim do CURSOR e saímos do loop. Será o fim do enquanto, ou seja, END WHILE.

No final, após o END WHILE, quando terminarmos de percorrer o CURSOR, vamos dar um CLOSE cursor1.
```sql
CREATE PROCEDURE `looping_cursor` ()
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

Essa será a procedure para percorrer o CURSOR do início ao fim.

Podemos clicar no botão "Apply" no canto inferior direito. E, depois de revisar o script, clicar em "Apply" novamente e finalizar apertando em "Finish".

## Executando a procedure
Vamos criar uma nova área de script para reutilizar quatro comandos que executamos em vídeos anteriores para apagar a tabela temp_nomes, depois criá-la de forma temporária, executar a procedure para colocar strings de nomes para dentro da temp_nomes e, por fim, dar um SELECT na tabela para mostrar o conteúdo.

Contudo, colocaremos outros nomes, por exemplo:
    
    João, Pedro, Maria, Lúcia, Joana e Beatriz.

Feito isso, vamos rodar a looping_cursor.

```sql
DROP TEMPORARY TABLE IF EXISTS temp_nomes;
CREATE TEMPORARY TABLE temp_nomes (nome VARCHAR(255));
CALL inclui_usuarios_lista_52('João, Pedro, Maria, Lucia, Joana, Beatriz');
SELECT * FROM temp_nomes;
CALL looping_cursor_54();
```

Vamos executar passo a passo: primeiro apagamos a tabela, criamos a tabela novamente, executamos a rotina para colocar esses nomes dentro da tabela temporária.

Agora, a tabela tem esses 5 nomes:

    #  nome
    João
    Pedro
    Maria
    Lucia
    Joana
    Beatriz

Por fim, vamos percorrer nome a nome e mostrar isso na saída. Foram exibidos seis resultados de vnome, cada um contendo um nome.


## Question - Ampliando a capacidade de processamento de cursores.

Foi implementada a seguinte procedure demonstrando o uso de cursores para percorrer a tabela temp_nomes.

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `looping_cursor_54`()
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
Em procedimentos armazenados, cursores oferecem uma maneira eficiente de iterar sobre conjuntos de resultados de consultas SQL, permitindo o processamento de dados linha por linha. Considerando a necessidade de enriquecer o conjunto de dados processados por um cursor, passando de uma simples coluna nome para incluir também a coluna email.

Dada a stored procedure `looping_cursor`, como ela deveria ser modificada para selecionar e processar tanto nome quanto email da tabela temp_nomes?

#### Selecione uma alternativa

    ( ) Manter a seleção como está e adicionar uma segunda instrução SELECT dentro do loop para buscar email baseado em nome.


    ( ) Utilizar funções agregadas para combinar nome e email em uma única coluna e processá-los como uma string única.


    ( ) Criar um novo cursor exclusivamente para email e processar os dois cursores em paralelo.


    ( ) Modificar o cursor para SELECT nome FROM temp_nomes e usar duas variáveis para armazenar nome e email separadamente.


    (X) Alterar a declaração do cursor para SELECT nome, email FROM temp_nomes e ajustar o FETCH para duas variáveis, vnome e vemail.
>Esta abordagem captura eficientemente ambos os campos em uma única iteração, otimizando o processamento dos dados.