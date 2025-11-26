# DECLARANDO VARIÁVEIS 

Conheceremos agora outro recurso que também podemos trazer para dentro das funções que são as variáveis. As variáveis são recursos que podemos utilizar para armazenar informações.

Por exemplo, de um SELECT que fazemos em uma tabela na função e depois reutilizamos esse valor em outros momentos da função. Criaremos uma nova função que será bem útil para as pessoas gestoras da `Insight Places`.

Antes disso, montaremos um SELECT. Queremos buscar uma informação que já calculamos anteriormente, nesse caso a média das avaliações, ou seja, a média das notas dadas pelos clientes. Buscaremos na tabela de avaliações * FROM avaliacoes;.

```sql
SELECT * FROM avaliacoes;
```

Ao executar o código, temos uma tabela com todas as notas. O que queremos é a média geral, então, apagamos o * e passamos no lugar AVG() que é a função de agregação que calcula a média. Nela, passaremos nota.

Se executássemos esse código, teríamos como retorno a média. Porém, vamos também acrescentar o alias MediaNotas depois do AVG().

Feito isso, envolvemos esse trecho com o ROUND(2) para ser arredondado com duas casas decimais. Essa é a estrutura da nossa consulta, o código fica conforme abaixo:

```sql
SELECT ROUND(AVG(NOTA), 2) MediaNotas FROM avaliacoes;
```

Ao executar, temos o retorno abaixo.
```
-	MediaNotas
-	3.00
```
É bem interessante essa consulta de média geral, justamente para as pessoas gestoras ficarem atentas na média das notas dadas pelos clientes. A partir disso, podem estudar o motivo das notas e o que pode ser feito para melhorar.

Como essa é uma consulta que será executada constantemente e é importante, podemos transformá-la em uma função. Isso porque ela pode tanto ser executada pelas pessoas gestoras, como por outras áreas da empresa, porque cada área pode precisar dessa média de notas para um tipo de tomada de decisão diferente.

## Criando a função MediaAvaliacoes( )
Agora, criaremos a função que calculará a média e retornar sempre essa informação. Já sabemos que para criar uma função utilizamos o CREATE FUNCTION. Definimos o nome MediaAvaliacoes().

Ao criar uma função que justamente o nome da função indique o que está sendo feito internamente. Isso é muito importante, afinal, muitas vezes, liberamos para determinados setores da empresa apenas acesso à função e não ao que está dentro, não às tabelas.

Então, ao definir como MediaAvaliacoes(), a pessoa que for executar essa função vai saber que terá essa informação. Na linha abaixo, passamos RETURNS FLOAT, pois a MediaAvaliacoes() é um valor com casas decimais.

Além disso, a função será DETERMINISTIC, pois o valor será sempre constante, ou seja, terá sempre o mesmo retorno para os mesmos valores.

Porém, suponhamos que utilizamos uma função que gera números aleatórios. A função RANGE(), ativa da linguagem SQL no MySQL, gera números aleatórios.

Então, sempre que executássemos, teríamos um número diferente. Nesse caso, não seria determinística, pois o valor seria sempre alterado.

Na linha abaixo, passamos o BEGIN seguido do END. Na linha acima de CREATE FUNCTION, passamos o DELIMITER $$. Adicionamos o $$ após o END e no DELIMITER acrescentamos o ponto e vírgula ;, para informar que queremos voltar ao delimitador padrão.
```sql
SELECT ROUND(AVG(NOTA), 2) MediaNotas FROM avaliacoes;

DELIMITER $$
CREATE FUNCTION MediaAvalicoes()
RETURNS FLOAT DETERMINISTIC
BEGIN

END$$

DELIMITER;
```

Repare que o `DELIMITER` está sublinhado em vermelho e com um "x" no início da linha, mesmo informando o ponto e vírgula. Isso acontece, pois precisamos dar um espaço entre o DELIMITER e o delimitador que estamos passando.

Precisamos nos atentar a isso quando formos criar as funções ou utilizar o DELIMITER. Se passarmos essas informações juntas, sem o espaço, esse erro ocorrerá, pois não consegue identificar o valor que estamos passando como delimitador.

Feito isso, copiamos a consulta na primeira linha de código e colamos na linha abaixo de BEGIN.
```sql
SELECT ROUND(AVG(NOTA), 2) MediaNotas FROM avaliacoes;

DELIMITER $$
CREATE FUNCTION MediaAvalicoes()
RETURNS FLOAT DETERMINISTIC
BEGIN

SELECT ROUND(AVG(NOTA), 2) MediaNotas FROM avaliacoes;

END$$

DELIMITER;
```

Já sabemos que sempre precisamos retornar um valor. Então, como poderíamos retornar um valor se só estamos fazendo o SELECT? Seria interessante se pudéssemos salvar esse valor em algum lugar. Agora que as variáveis entram.

## Declarando variáveis
Abaixo de BEGIN, podemos passar o DECLARE e declarar uma variável que armazenará esse valor. Assim, poderemos utilizar essa variável em outros momentos dentro da função para reutilizar esse valor. Na mesma linha, criamos a variável media FLOAT;.

Com a variável declarada, podemos utilizá-la no escopo da função. Usaremos essa variável para armazenar a informação que estamos buscando com SELECT na nossa tabela de avaliações.

Para isso, primeiro movemos para a linha de baixo o código FROM avaliacoes. Depois, na linha abaixo de SELECT, passamos o INTO media para inserir na variável média.

Feito isso, na linha acima de END$$, passamos RETURN media;, que é do tipo FLOAT e receberá esse valor.

```sql
SELECT ROUND(AVG(NOTA), 2) MediaNotas FROM avaliacoes;

DELIMITER $$
CREATE FUNCTION MediaAvalicoes()
RETURNS FLOAT DETERMINISTIC
BEGIN
DECLARE media FLOAT;

SELECT ROUND (AVG (nota), 2) MediaNotas 
INTO media
FROM avaliacoes;

RETURN media;
END$$

DELIMITER ;
```

Com a função e variável criadas, selecionamos todo o código e executamos. A função foi criada corretamente, agora podemos chamá-la. Então, no fim do código, passamos SELECT MediaAvaliações(); e executamos.

```sql
SELECT MediaAvaliações();
```
Feito isso temos o retorno abaixo:
```
-	MediaAvaliacoes()
-	3.00
```

Assim, temos o mesmo resultado da consulta anterior, só que de forma mais simples. Isso porque encapsulamos a consulta dentro de uma função. Além disso, utilizamos variáveis para armazenar este valor e reutilizá-lo dentro da função.

Esse é um recurso bem interessante justamente por isso. Imagine que temos setores que precisam dessa informação, mas ao invés de dar o acesso direto à tabela para as pessoas colaboradoras executarem esta consulta, liberamos acesso apenas a esta função. Assim, não terão acesso a dados sensíveis.

## Para saber mais: trabalhando com variáveis


No MySQL, as variáveis podem ser declaradas e utilizadas dentro de funções (e também procedimentos) de diferentes maneiras, cada uma com suas características específicas. As formas principais incluem o uso de variáveis locais dentro do bloco da função e o uso de variáveis de sessão (ou variáveis globais). A seguir, vamos explorar cada uma delas, destacando suas diferenças e situações em que podem ser utilizadas.

### Variáveis locais
`Declaração`: Variáveis locais são declaradas dentro de funções (ou procedimentos) usando a palavra-chave `DECLARE`. Elas só existem durante a execução da função e são destruídas ao final dela.

Sintaxe:
```sql
DECLARE nome_da_variavel TIPO_DE_DADO;
```

`Inicialização`: É possível inicializar uma variável local no momento da declaração:

Sintaxe:
```sql
DECLARE nome_da_variavel TIPO_DE_DADO DEFAULT valor_inicial;
```
`Uso`: Variáveis locais são utilizadas para armazenar resultados intermediários, manipular dados dentro da função e controlar a lógica de execução.

#### Vantagens:
Escopo limitado à função, protegendo o dado de ser acessado ou modificado fora dela.
Maior clareza e controle sobre o uso de dados temporários e estados intermediários na lógica da função.
Quando Usar: Utilize variáveis locais quando precisar de armazenamento temporário ou controle de fluxo dentro de uma função, e os dados não precisam persistir após a execução da função.

### Variáveis de sessão
`Declaração`: Variáveis de sessão são definidas e acessadas utilizando o prefixo `@`. Não requerem uma declaração explícita com DECLARE e existem durante toda a sessão do cliente.

#### Inicialização e Uso:
```sql
SET @nome_da_variavel = valor;
-- ou
SELECT @nome_da_variavel := valor;
```

`Vantagens`:
* Persistem durante toda a sessão do cliente, permitindo o compartilhamento de valores entre diferentes funções e comandos SQL executados na mesma sessão.
* Não requerem declaração explícita, facilitando a atribuição e modificação de valores.

`Quando usar`: Variáveis de sessão são úteis quando você precisa manter informações entre chamadas de funções ou procedimentos, ou quando os dados precisam ser acessados por várias partes da aplicação durante a mesma sessão de conexão ao banco de dados.

## Diferenças principais
* `Escopo`: Variáveis locais têm escopo limitado à função, enquanto variáveis de sessão têm escopo que dura toda a sessão do cliente.
* `Declaração`: Variáveis locais precisam ser explicitamente declaradas usando DECLARE, enquanto variáveis de sessão são definidas diretamente com SET ou em uma atribuição com SELECT.

* `Persistência`: Variáveis locais são destruídas ao final da execução da função; variáveis de sessão persistem durante a sessão.

Ao decidir qual tipo de variável usar dentro de funções no MySQL, considere o escopo necessário, a persistência dos dados e a clareza do código. Variáveis locais são preferidas para dados e lógicas temporárias que não precisam ser compartilhados, enquanto variáveis de sessão são úteis para manter estados ou informações entre várias operações durante uma sessão.