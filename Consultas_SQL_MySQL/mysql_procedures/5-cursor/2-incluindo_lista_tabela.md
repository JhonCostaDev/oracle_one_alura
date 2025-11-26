#  Aplicando a inclusão da lista na tabela
Vamos elaborar uma procedure para inserir uma lista de nomes em uma tabela temporária chamada temp_nomes.

## Inserindo uma lista de nomes na tabela temporária
Primeiramente, vamos criar um novo script em MySQL para definir o nome da tabela e seu único campo: nome. No entanto, a tabela será criada somente durante o teste do Stored Procedures.
```sql
-- temp_nomes (nome)
```
Criaremos a procedure utilizando o pseudocódigo apresentado no vídeo anterior. Durante o teste da procedure, a tabela será criada. Para isso, iremos clicar com o botão direito em "Stored Procedure" e selecionar a opção "Create Stored Procedure". O nome da Stored Procedure será inclui_usuarios_lista, e o parâmetro lista será do tipo VARCHAR() com tamanho 255.
```sql
CREATE PROCEDURE `inclui_usuarios_lista`(lista, VARCHAR(255))
BEGIN

END
```

Para iniciar a procedure, precisamos declarar três variáveis. A primeira é NOME, que receberá um nome em cada iteração do loop para ser inserido na tabela temporária. A segunda variável, RESTANTE, será inicializada com a lista completa e terá os nomes removidos a cada passo do loop. Por fim, a variável POS, do tipo inteiro, armazenará a posição da vírgula em cada iteração do loop.

Vamos começar declarando três variáveis.

## Declarando as variáveis
A primeira será denominada nome e terá o tipo VARCHAR() com tamanho máximo de 255 caracteres. A segunda variável será restante, também do tipo VARCHAR() com 255 caracteres. Por fim, a terceira variável será pos, do tipo INTEGER.

```sql
CREATE PROCEDURE `inclui_usuarios_lista`(lista, VARCHAR(255))
BEGIN
    DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE nome INTEGER;

END
```

Agora, precisamos atribuir à variável restante o valor da lista, que foi passada como parâmetro para a Stored Procedure. Isso é feito assim: SET restante = lista;. O próximo passo é iniciar o loop. Primeiro, verificamos se ainda há uma vírgula dentro da variável restante: WHILE INSTR(restante,',') > 0 DO.

Para fazer isso, usamos a função INSTR() na variável restante, passando a vírgula como parâmetro, e verificamos se o resultado é maior que zero. Isso é necessário porque se ainda houver uma vírgula, significa que ainda há nomes a serem retirados da variável restante. Inserimos END WHILE.

```sql
CREATE PROCEDURE `inclui_usuarios_lista`(lista, VARCHAR(255))
BEGIN
    DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE pos INTEGER;
    SET restante = lista;
    WHILE INSTR(restante,',') > 0 DO
    
    END WHILE
END
```

## Buscando a posição da vírgula
Dentro do loop, procuramos pela posição atual da vírgula: SET pos =. Aqui podemos aproveitar o teste que fizemos anteriormente (INSTR(restante,',')).

Em seguida, atribuímos à variável nome o primeiro nome que encontramos, pegando a parte esquerda da variável restante até a primeira vírgula. Para isso, usamos SET nome = LEFT(restante, pos - 1), garantindo que não incluímos a vírgula junto com o nome.

```sql
CREATE PROCEDURE `inclui_usuarios_lista`(lista, VARCHAR(255))
BEGIN
    DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE pos INTEGER;
    SET restante = lista;
    WHILE INSTR(restante,',') > 0 DO
        SET pos = INSTR(restante,',');
        SET nome = LEFT(restante, pos -1);
    END WHILE
END
```

## Inserindo na tabela temporária
Agora, adicionaremos dados à tabela temporária com um comando INSERT INTO. O nome da tabela é temp_nomes, e vamos especificar o campo onde vamos inserir dados usando VALUES(). Neste caso, como só temos um campo, não precisamos mencionar o nome do campo; basta usar VALUES() seguido da variável nome.

```sql
CREATE PROCEDURE `inclui_usuarios_lista`(lista, VARCHAR(255))
BEGIN
    DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE pos INTEGER;
    SET restante = lista;
    WHILE INSTR(restante,',') > 0 DO
        SET pos = INSTR(restante,',');
        SET nome = LEFT(restante, pos -1);
        INSERT INTO temp_nomes VALUES(nome);
    END WHILE
END
```

Depois, vamos remover o nome que acabamos de inserir da variável restante. Isso vai reduzir a string de controle do loop. Utilizaremos a função SUBSTRING() em restante, pegando os caracteres a partir da posição pos + 1, e assim sairemos do WHILE.

```sql
CREATE PROCEDURE `inclui_usuarios_lista`(lista, VARCHAR(255))
BEGIN
    DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE pos INTEGER;
    SET restante = lista;
    WHILE INSTR(restante,',') > 0 DO
        SET pos = INSTR(restante,',');
        SET nome = LEFT(restante, pos -1);
        INSERT INTO temp_nomes VALUES(nome);
        SET restante = SUBSTRING(restante, pos + 1);
    END WHILE
END
```

Contudo, ao sair do WHILE, ainda teremos um nome para adicionar à tabela tem nomes, pois o último nome não terá uma vírgula. Mesmo que ele saia do loop, precisamos incluir esse último nome na tabela.

Inserindo o último nome
Para fazer isso, vamos adicionar uma verificação IF TRIM() para garantir que restante não esteja vazio. Dentro dessa condição, vamos incluir o último nome na tabela. No lugar de usar VALUES() seguido de nome, vamos inserir diretamente a string restante: TRIM(restante).

```sql
CREATE PROCEDURE `inclui_usuarios_lista`(lista, VARCHAR(255))
BEGIN
    DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE pos INTEGER;
    SET restante = lista;
    WHILE INSTR(restante,',') > 0 DO
        SET pos = INSTR(restante,',');
        SET nome = LEFT(restante, pos -1);
        INSERT INTO temp_nomes VALUES(nome);
        SET restante = SUBSTRING(restante, pos + 1);
    END WHILE
    IF TRIM(restante) <> '' THEN
        INSERT INTO temp_nomes VALUES(TRIM(restante));
    END IF;
END
```


Primeiro, declaramos as variáveis e definimos a variável restante como a lista completa. Em seguida, implementamos um loop para inserir todos os nomes, exceto o último. Por último, inserimos o último nome da lista.

Vamos denominar isso como inclui_usuarios_lista, colocando o identificador do vídeo atual como 52.

```sql
CREATE PROCEDURE `inclui_usuarios_lista_52`(lista, VARCHAR(255))
BEGIN
    DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE pos INTEGER;
    SET restante = lista;
    WHILE INSTR(restante,',') > 0 DO
        SET pos = INSTR(restante,',');
        SET nome = LEFT(restante, pos -1);
        INSERT INTO temp_nomes VALUES(nome);
        SET restante = SUBSTRING(restante, pos + 1);
    END WHILE
    IF TRIM(restante) <> '' THEN
        INSERT INTO temp_nomes VALUES(TRIM(restante));
    END IF;
END
```
Clicamos em "Apply" duas vezes e "Finish".

Agora voltando ao script com --temp_nomes(nome).

O plano é o seguinte: vamos testar a funcionalidade da Stored procedure. Primeiro, vamos remover a tabela temporária; para isso, usaremos o comando DROP TEMPORARY TABLE seguido de temp_nomes e incluiremos IF EXISTS para garantir que a tabela exista antes de excluí-la. Em seguida, vamos recriá-la usando CREATE TEMPORARY TABLES temp_nomes() e definindo um campo chamado "nome" como VARCHAR() de tamanho 255.

```sql
-- tempo_nomes(nome)

DROP TEMPORARY TABLE IF EXISTS tempo_nomes;
CREATE TEMPORARY TABLES temp_nomes(nome VARCHAR(255));
```

Agora, vamos testar a procedure inclui_usuarios_lista_52. Para isso, usaremos CALL inclui_usuarios_lista_52 e passaremos alguns nomes como parâmetros, como "Luana Moura", "Enrico Correia", "Paulo Vieira" e "Marina Nunes".

```
-- tempo_nomes(nome)

DROP TEMPORARY TABLE IF EXISTS tempo_nomes;
CREATE TEMPORARY TABLES temp_nomes(nome VARCHAR(255));
CALL inclui_usuarios_lista_52('Luana Moura,Enrico Correia,Paulo Vieira,Marina Nunes');
```

### Estamos fornecendo uma lista de clientes.

As aspas devem estar presentes apenas no início e no final da string, já que nosso parâmetro requer uma única string com os nomes separados por vírgula.

Portanto, é importante abrir aspas simples no início e fechá-las no final da string. Após isso, ao executar a Procedure, faremos um SELECT * FROM temp_nomes para verificar se todos os dados foram corretamente inseridos na tabela.

```sql
-- tempo_nomes(nome)

DROP TEMPORARY TABLE IF EXISTS tempo_nomes;
CREATE TEMPORARY TABLES temp_nomes(nome VARCHAR(255));
CALL inclui_usuarios_lista_52('Luana Moura,Enrico Correia,Paulo Vieira,Marina Nunes');
SELECT * FROM temp_nomes
```

Vamos entender passo a passo: primeiro, tentamos excluir a tabela (que não existe, portanto nenhum dado é excluído), em seguida, criamos a tabela temporária e executamos a Procedure. Sem erros até agora. Agora, ao verificar o conteúdo da tabela, observamos que os quatro nomes estão corretamente separados por vírgula.

    # nome
    Luana Moura
    Enrico Correia
    Paulo Vieira
    Marina Nunes
Concluímos com sucesso nosso objetivo.

## Conclusão e Próximos Passos
Agora, você pode estar se perguntando: qual é o propósito por trás disso? Como essa técnica será útil para resolver o problema mencionado no início do vídeo anterior sobre a inclusão de vários aluguéis na Insight Place? Como planejamos solucionar essa questão? Bem, a razão pela qual criamos essa tabela é crucial e se tornará evidente em breve.

No entanto, para compreender por que a utilizaremos, é necessário introduzir um conceito novo que talvez seja desconhecido para muitos de vocês no MySQL: o cursor.

O cursor é uma ferramenta essencial, especialmente dentro de Procedures.

## Question - Criamos esta nova procedure durante a aula:

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `inclui_usuarios_lista_52`(lista VARCHAR(255))
BEGIN
    DECLARE nome VARCHAR(255);
    DECLARE restante VARCHAR(255);
    DECLARE pos INTEGER;
    SET restante = lista;
    WHILE INSTR(restante,',') > 0 DO
        SET pos = INSTR(restante,',');
        SET nome = LEFT(restante, pos - 1);
        INSERT INTO temp_nomes VALUES (nome);
        SET restante = SUBSTRING(restante, pos + 1);
    END WHILE;
    IF TRIM(restante) <> '' THEN
       INSERT INTO temp_nomes VALUES (TRIM(restante));
    END IF;
END
```

Na stored procedure inclui_usuarios_lista_52, o que acontece se o trecho final que verifica e insere o último nome da lista for removido?

```sql
IF TRIM(restante) <> '' THEN
       INSERT INTO temp_nomes VALUES (TRIM(restante));
    END IF;
```

Selecione uma alternativa

- ( ) A procedure automaticamente adicionará uma vírgula ao final da lista para garantir que todos os nomes sejam inseridos.


- ( ) A procedure se tornará mais eficiente ao evitar verificações desnecessárias e inserções.


- ( ) Todos os nomes, incluindo o último nome após a última vírgula, serão inseridos na tabela temp_nomes.


- (X) O último nome na lista não será inserido na tabela temp_nomes se não houver uma vírgula após ele.


- ( ) A procedure falhará ao tentar processar qualquer lista de nomes fornecida.