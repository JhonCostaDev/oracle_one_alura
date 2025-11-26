# Provedores de banco de dados e linguagem estruturada
Durante esta formação, em todos os cursos até agora, tivemos contato com o SQL para incluir, alterar, excluir e consultar dados de tabelas do MySQL. No entanto, sabemos que o SQL não é o que chamamos de uma linguagem estruturada.

No SQL padrão ANSI, não é possível criar uma variável, fazer um comando de repetição, como um WHILE ou um FOR, ou tomar comandos de decisão, como um IF. Isso pode ser considerado uma "fraqueza" da linguagem SQL.

Sendo assim, a decisão dos grandes provedores de bancos de dados foi associar aos seus bancos de dados uma linguagem estruturada, como se fosse uma extensão do SQL padrão ANSI.

Com isso podemos usar variáveis dentre os comandos SQL, além de criar estruturas de looping ou de condição.

No entanto, cada provedor de banco de dados seguiu um caminho diferente para implementar essa extensão de linguagem estruturada. Isso é diferente do uso do SQL, que segue uma padronização, que chamamos de padrão ANSI, que todos os provedores adotaram nos bancos de dados.

Portanto, se estamos nos especializando em MySQL, precisamos entender como funciona a linguagem estruturada do MySQL.

## O que é uma Procedure?
Para criar um programa no MySQL, precisamos criar o que chamamos de Procedure, ou, internamente, Stored Procedure.

O comando para criar uma Procedure é o CREATE PROCEDURE seguido do nome desejado para essa Procedure. Depois, entre parênteses, podemos passar parâmetros para essa Procedure, embora isso não seja obrigatório.

Depois, começamos o corpo dessa Procedure com a palavra BEGIN e declaramos uma lista de variáveis que serão utilizadas dentro do programa. Em seguida, entramos nos comandos propriamente ditos da Procedure, inserindo a lógica de execução. Então finalizamos esse corpo com a palavra END. Essa é a estrutura básica para criar uma Stored Procedure.

## Criando uma Procedure
Vamos ao MySQL Workbench, na base de dados Insightplaces, para criar uma primeira Procedure de exemplo.

Na estrutura de tabelas dessa base de dados (na aba "Schemas" à esquerda da interface), podemos conferir o nó chamado "Stored Procedures". É aqui que vamos criar nossos programas, usando a linguagem de programação estendida ao SQL.

Primeiramente, vamos dar um duplo clique na base Insightplaces, deixando-a em negrito, para indicar que ela é a base default da nossa conexão.

Depois, vamos clicar sobre Stored Procedures com o botão direito do mouse e selecionar a opção "Create Stored Procedure". Isso abrirá uma caixa de diálogo para criação de uma nova Stored Procedure.

Nessa caixa, teremos a estrutura básica para criação dessa Procedure, com os comandos CREATE PROCEDURE, BEGIN e END. Chamaremos essa Procedure de 'nao_faz_nada', a título de exemplo.

Conforme seu nome, não teremos comando nenhum dentro dessa Procedure, pois ela não fará nada. Então, ela ficará assim:

Nova Procedure

```SQL
CREATE PROCEDURE 'nao_faz_nada' ()
BEGIN
END
```

Vamos salvá-la clicando no botão "Apply" no canto inferior direito da caixa de diálogo.

Com isso, visualizaremos os comandos que serão executados no script:
```SQL
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `nao_faz_nada`;

DELIMITER $$
USE `insightplaces`$$
CREATE PROCEDURE `nao_faz_nada` ()
BEGIN
END$$

DELIMITER ;
```

Note o comando DELIMITER $$ ao início e o DELIMITER ; ao fim. Na Stored Procedure, o ponto e vírgula funciona como separador de linha que usamos ao criar um programa. No entanto, nativamente, o ponto e vírgula é o separador de linhas de comando em SQL.

Com o primeiro comando, estamos nos conectando à base Insightplaces. Depois, com o segundo comando, estamos apagando a Stored Procedure chamada nao_faz_nada, caso ela já exista. Utilizamos o ponto e vírgula ao final de cada comando.

No entanto, ao escrever a Stored Procedure, mudamos o delimitador para $$, porque o $$ usado aqui serve apenas para delimitar o comando da criação da Stored Procedure. Assim, os pontos e vírgulas que usarmos dentro da criação da Stored Procedure não serão confundidos com os pontos e vírgulas utilizados para separar comandos SQL no script.

Talvez isso fique um pouco confuso no momento, mas quando realmente escrevermos comandos dentro da Stored Procedure, voltaremos a este tema para entendermos melhor a questão dos delimitadores.

Se clicarmos em "Apply" novamente, todos esses comandos serão executados no MySQL. Vamos fazer isso. Não devemos ter nenhum problema até aqui.

Agora podemos fechar esta caixa de diálogo e, na aba à esquerda da tela, poderemos conferir na aba de "Stored Procedures" a nova Stored Procedure que criamos, chamada nao_faz_nada. É assim que criamos Stored Procedures dentro do MySQL!

Mas, claro, criamos uma Stored Procedure que não faz nada ainda. Então, no próximo vídeo, vamos criar a nossa primeira Stored Procedure real, com funções a executar.


## QUESTION - Ampliando as capacidades do SQL com Procedures
 

Na busca por soluções que transcendem as limitações inerentes à linguagem SQL, especialmente em contextos onde a manipulação avançada de dados se faz necessária, a implementação de stored procedures no MySQL surge como uma ferramenta poderosa. Estas permitem a incorporação de lógica estruturada — como laços de repetição e condicionais — diretamente no banco de dados, ampliando significativamente sua funcionalidade.

Considerando a importância de stored procedures para o desenvolvimento de aplicações robustas e eficientes, qual comando é fundamental para iniciar a criação de uma stored procedure no MySQL? Escolha a alternativa correta.

Selecione uma alternativa

    a) UPDATE nome_da_tabela SET coluna = valor WHERE condição;


    b) INSERT INTO nome_da_tabela (colunas) VALUES (valores);


    c) CREATE DATABASE nome_da_database;


    d) CREATE PROCEDURE nome_da_procedure ();


    e) DELETE FROM nome_da_tabela WHERE condição;


## Considerações iniciais
Antes de criar a Stored Procedure, vamos considerar alguns detalhes sobre as SPs:

* O nome da SP deve conter apenas letras, números, o símbolo do dólar ($) e o underscore ( _ ).
* O nome não pode ultrapassar 64 caracteres.
* O nome deve ser único no banco de dados.
* O nome da SP é sensível a letras maiúsculas e minúsculas. Portanto, se você criar uma Stored Procedure com uma letra maiúscula e se referir a ela usando somente letras minúsculas, por exemplo, o MySQL não vai entender. Isso é o que chamamos de case sensitive.

Sabendo disso tudo, podemos criar a nossa primeira Stored Procedure, que vai imprimir a frase "Alô, Mundo"!

## Criando a SP
No MySQL Workbench, vamos clicar com o botão direito do mouse sobre Stored Procedures na aba à esquerda da tela e selecionar o comando "Create Stored Procedure".

Na caixa de diálogo, vamos criar a nossa Stored Procedure. Ela se chamará alo_mundo.

Entre o BEGIN e o END, o corpo da "função", vamos inserir o nosso comando, que será SELECT 'Alô, Mundo !!!';. Os comandos inseridos na Stored Procedure deve sempre terminar com ponto e vírgula.

Nova SP
```sql
CREATE PROCEDURE `alo_mundo` ()
BEGIN
    SELECT 'Alô, Mundo !!!';
END
```

Quando clicamos no botão "Apply" no canto inferior direito da janela, notamos que o DELIMITER inicial está com o $$ para que o ponto e vírgula do comando SELECT de dentro da SP não seja interpretado pelo MySQL como uma linha de SQL.

```sql
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `alo_mundo`;

DELIMITER $$
CREATE PROCEDURE `alo_mundo` ()
BEGIN
    SELECT 'Alô, Mundo !!!';
END$$

DELIMITER ;
```

Ao mudar o DELIMITER para $$, o MySQL vai entender que tudo o que está entre CREATE PROCEDURE e END trata-se de um único comando de SQL, porque termina em $$ após o END também.

Portanto, por conta do $$, pontos e vírgulas que colocarmos dentro da criação da SP não serão confundidos pelo MySQL como novos comandos de SQL!

Vamos clicar em "Apply > Finish" para finalizar a criação da SP. Mas, e agora, como a executamos?

### Executando a SP
Vamos clicar no botão para abrir um novo script SQL no canto esquerdo da barra de ferramentas do Workbench, na parte superior da tela.

Na nova aba que se abrir no centro da tela, vamos digitar o seguinte:

Novo script SQL
```sql
CALL alo_mundo;
```

O comando CALL literalmente chama a Stored Procedure a partir de seu nome, que inserimos logo em seguida, seguido de ponto e vírgula, porque estamos dentro da área de edição de um comando SQL.

Vamos selecionar esse comando que digitamos, como selecionamos um texto, e executar, clicando no botão "Execute the selected portion of the script..." localizado na barra de ações na parte superior da área de edição do comando (terceiro botão da esquerda para a direita).

Com isso, teremos um retorno na aba "Result Grid" (resultados), na parte inferior da área de edição, que imprimiu a frase desejada:

        Alô, Mundo !!!

Ou seja, o comando *SELECT* com uma constante exibe o conteúdo da frase - no caso, "Alô, Mundo !!!".

Podemos usar outros tipos de comandos SQL dentro da Stored Procedure. A seguir, criaremos uma SP útil especificamente para os nossos objetivos com a Insight Places.

Procedure para exibir a lista de clientes
Vamos criar outra Stored Procedure, seguindo o mesmo caminho de antes: clicamos em "Stored Procedures" com botão direito do mouse e selecionamos "Create Procedure".

Essa nova Procedure será chamada listaClientes. Em seu corpo, vamos inserir o comando **SELECT * FROM clientes**.

O nome clientes refere-se à tabela de clientes da base de dados da Insight Places, que podemos verificar na estrutura de tabelas na aba esquerda da tela. Ela contém o cadastro dos hóspedes, ou seja, das pessoas que fecharam hospedagens pela nossa empresa.

Ou seja, com esse comando, nós selecionamos todos os dados da tabela clientes para exibir a nossa lista de clientes na tela.

Nova SP

```sql
CREATE PROCEDURE `listaClientes` ()
BEGIN
    SELECT * FROM clientes;
END
```
Vamos clicar em "Apply", gerando todo o corpo da criação da nossa Procedure:

```sql
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `listaClientes`;

DELIMITER $$
CREATE PROCEDURE `listaClientes` ()
BEGIN
    SELECT * FROM clientes;
END$$

DELIMITER ;
```
Clicamos em "Apply" novamente, depois em "Finish".

Vamos de novo no nosso script, na área de edição no centro do Workbench. Agora, para chamar nossa nova SP e executá-la, vamos digitar o seguinte:
```sql
Script SQL

CALL listaClientes;
```

Selecionamos essa linha e clicamos para executar. Com isso, teremos como resultado a lista de clientes:

    Result Grid (resultados parcialmente transcritos; para conferir todos os registros, execute o código na sua máquina)

    cliente_id	nome	cpf	contato
    1	        João Miguel Sales	658.190.237-30	joão_352@dominio.com
    10	        Cauã da Mata	162.854.379-55	cauã_723@dominio.com
    100	        Júlia Pires	190.682.435-51	júlia_388@dominio.com
    1000	Srta. Clara Jesus	457.816.309-10	srta._827@dominio.com
    10000	    Ana Vitória Caldeira	752.831.460-90	ana_322@dominio.com
    1001	    Luana Moura	258.374.106-35	luana_915@dominio.com
    1002	    Enrico Correia	798.240.516-94	enrico_443@dominio.com
    1003	    Paulo Vieira	285.097.413-79	paulo_562@dominio.com
...	...	...	...


Note, que interessante! Podemos construir Stored Procedures que listam clientes, aluguéis, endereços e todas as pessoas da tabela de hospedagem.

O mais legal disso é: quem vai executar essa Stored Procedure não precisa saber comandos de SQL para realizar as listagens que desejar, porque dentro da Stored Procedure já temos o SQL previamente programado, e basta chamá-la para tal. Esse é o propósito fundamental da Stored Procedure!

Claro que aqui estamos executando um único comando de SQL, mas é óbvio que uma Stored Procedure pode ter muitos comandos de SQL.