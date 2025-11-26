# Criando funções no MySQL

No MySQL, clicamos no ícone identificado por uma folha de papel e um símbolo de "+" para criar uma nova aba. O comando básico que utilizamos para criar os objetos que geralmente precisamos no banco de dados é o CREATE. Então, o passamos e especificamos o objeto que queremos criar nessa tabela, seja um banco de dados, uma stored procedure ou uma função.

Nesse caso, criaremos uma FUNCTION chamada retornoConstante(). O nome da função poderia ser qualquer outro, dependendo da sua criatividade ou do que ela fará.

Na linha abaixo, especificaremos outra cláusula da estrutura da função. Passamos RETURNS, pois obrigatoriamente nossas funções precisam retornar algum valor. Após, precisamos especificar qual será o tipo de dados desse retorno que será VARCHAR(50).

Se estamos especificando um VARCHAR(50), significa que vamos retornar um tipo de dado string, ou seja, em formato de texto.

Na linha seguinte, especificamos o corpo da função, onde informamos o comando que essa função executará. Passamos o BEGIN, indicando que estamos abrindo este bloco de código, pulamos algumas linhas e informamos o END, indicando que estamos encerrando o bloco de código.

Quando informamos o comando e criamos esta função, ela ficará na área lateral esquerda, em Schemas, na área de Functions. Sempre que precisarmos desse retorno, podemos simplesmente chamar a função.

Uma das vantagens e o principal ponto de utilizarmos funções é encapsular comandos. Criamos uma função que executa um comando frequentemente e sempre que precisarmos, podemos chamar esta função em qualquer lugar. Podemos reutilizar esta função e ela sempre trará esse resultado, porque internamente tem este comando que busca e monta o relatório. Isso facilita a manutenção.

Se temos um comando executado constantemente em diversos setores de uma empresa, quando temos uma função que executa este comando, temos acesso apenas à execução da função e não ao comando interno a ela. Isso facilita tanto na segurança dos dados que serão acessados, quanto na questão de manutenção, já que este código estará centralizado apenas em um único lugar.

Sabendo disso, voltamos a criação do código. Entre o BEGIN e o END, passamos o comando que queremos executar, nesse caso, a clausula RETUR seguido do queremos retornar, nesse caso o texto Seja bem-vindo(a), entre aspas simples. Após, passamos ; para indicar que encerramos a linha de código.

```sql
CREATE FUNCTION RetornoConstante() 
RETURNS VARCHAR(50)
BEGIN

RETURN 'Seja bem-vindo(a)';

END
```
No `RETURNS` passamos o início da criação da função para indicar o tipo de dado que será retornado. Já em RETURN passamos o valor que queremos retornar.

Suponhamos que estamos cadastrando um novo imóvel. Sempre que uma nova pessoa proprietária for cadastrada, essa função será executada com essa mensagem de boas-vindas.

No entanto, se analisarmos esse código, nas linhas 7 e 9 notamos um "x" vermelho na lateral esquerda, além de um sublinhado vermelho na mensagem de boas-vindas e do END.

Quando estamos trabalhando com função, internamente no bloco de código, passamos os comandos que queremos executar. Temos um RETURN, mas poderíamos passar qualquer outro. Da mesma forma como fazemos fora das funções, como SELECT, UPDATE, DELETE.

Internamente, nas funções, o delimitador é também o ;. Isso é importante, pois precisamos indicar para a função quando o comando é encerrado.

Então, suponhamos que acima de RETURN, temos um SELECT * FROM clientes;. Temos que indicar com o ; onde o comando se encerra. Porém, abaixo, queremos retornar o valor que definimos. Para isso, separamos os dois comandos com um espaço.

Mas, por que o erro no END permanece? Isso acontece, pois queremos indicar que a função foi concluída e assim criá-la. Porém, externamente, no MySQL, o ; também é considerado um delimitador, ou seja, que o bloco de código está encerrado.

Nisso, temos um problema, pois ao executar esse trecho de código e o MySQL encontrar o primeiro ; ele entenderá que ali se encerra o comando de criação da função. Ocasionando, então, em um erro, pois não chegamos realmente ao END, sendo o ponto final da função. Assim a função não é criada.

Mas há uma forma de resolvermos isso, o próprio MySQL traz uma solução própria, que é mudar temporariamente o delimitador externo, ou seja, o delimitador do MySQL.

Podemos passar no início da nossa função a palavra DELIMITER e indicar que o nosso delimitador agora será o $$. Depois, no fim do código, após o END, passamos DELIMITER;, para voltarmos ao delimitador padrão ;.

Se não voltássemos o delimitador para o ;, utilizaríamos o $$ como delimitador padrão no MySQL. Então, após o END também passamos o $$, ficando da seguinte forma:

```sql
DELIMITER $$

CREATE FUNCTION RetornoConstante() 
RETURNS VARCHAR(50)
BEGIN

RETURN 'Seja bem-vindo(a)';

END$$

DELIMITER ;
```


Agora, podemos criar nossa função. Selecionamos o código e clicamos no ícone de raio, localizado acima do campo de código, para executar.

Assim, temos um erro. Embora aparentemente a função esteja correta, não estamos passando a palavra DETERMINISTIC utilizada para otimização do banco de dados e da execução dessas funções.

Quando definimos que uma função é DETERMINISTIC indicamos para a função que o retorno dela sempre será igual. Suponhamos que passamos um valor x para a função e internamente ela executará algo.

Então, se sempre que passarmos esse valor, um cálculo interno será feito e teremos sempre o mesmo retorno. Nesse caso, essa é uma função determinística, pois o valor será sempre esperado.

Isso ajuda na questão da otimização do banco, porque executaremos uma função que sempre retornará o mesmo valor, não importa o parâmetro que passamos para ela.

Mas se essa função sempre mude o valor de retorno conforme o que passamos, chamamos ela de não deterministic. Por padrão, ela é não deterministic. Mas quando criamos uma função e não passamos nada para ela, sabemos que sempre retornará o mesmo valor, então ela é uma função deterministic.

No decorrer, conforme criamos outras funções, vamos entender melhor sobre o deterministica e não deterministica.

Sabendo disso, na linha 5, após o VARCHAR(50), passamos DETERMINISTIC.

```sql
DELIMITER $$

CREATE FUNCTION RetornoConstante() 
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN

RETURN 'Seja bem-vindo(a)';

END$$

DELIMITER ;
```

Feito isso, selecionamos o código e o executamos novamente. Agora, sim, a função foi criada. Para executá-la, copiamos o trecho RetornoConstante() e colamos no fim do código.

No início dessa linha, podemos chamá-la utilizando um SELECT. Poderíamos dar um alias, mas executaremos dessa forma.

```sql
SELECT RetornoConstante()
```
Feito isso, temos o retorno abaixo:

    Seja bem-vindo(a)

Tivemos como retorno o que especificamos entre o BEGIN e o END. Podemos chamar diversas vezes esse SELECT clicando para executar e sempre teremos o mesmo valor.

Assim, descobrimos como criar as funções e como podemos retornar e chamar uma função. Além disso, há outros recursos que podemos utilizar para deixar ainda mais interessante a utilização de funções.