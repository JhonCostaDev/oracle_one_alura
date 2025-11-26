Uma dessas funções é amplamente utilizada pelos gestores e colaboradores da Insight Places. Trata-se da consulta que faz a máscara do CPF, quando buscamos o nome e o CPF e é retornado já formatado.

Então, copiamos esse consulta no arquivo Funções de string. Criamos uma nova aba e colamos. Agora, a transformaremos em uma função.

Transformando a consulta em função
Faremos isso, justamente por ser uma consulta muito utilizada e, portanto, queremos simplificar o processo. Pressionamos "Enter" algumas vezes. Feito isso, passamos CREATE FUNCTION FormatandoCPF().

Lembrando que é importante nomear a função de forma explicativa.

Abaixo, passamos RETURNS VARCHAR(50). Passamos o varchar, pois vamos concatenar diversas strings. Na linha seguinte, passamos BEGIN e depois END para encerrar a função.

Na linha acima de CREATE FUNCTION passamos o DELIMITER $$. No END acrescentamos $$ e em DELIMITER o ponto e vírgula ;, sem esquecer do espaço.

Após, copiamos a consulta acima, e colamos entre BEGIN e END SS. Apagamos o trecho TRIM(nome) Nome, pois não queremos o nome do cliente e sim que a função formate o CPF.

DELIMITER $$
CREATE FUNCTION FormatandoCPF()
RETURNS VARCHAR(50)
BEGIN

SELECT
    CONCAT(SUBSTRING (cpf, 1, 3), '.', SUBSTRING(cpf, 4, 3), '.', SUBSTRING(cpf, 7, 3), '-', SUBSTRING(cpf, 10, 2)) AS CPF_Mascarado
FROM 
    clientes;

END$$

DELIMITER ;
Copiar código
Após, abaixo de BEGIN, passamos DECLARE NovoCPF para armazenar o CPF formatado seguido do tipo VARCHAR(50). Agora, atribuiremos valor a essa nova variável. Faremos isso de forma diferente.

Anteriormente, utilizamos o SELECT INTO. Agora, usaremos o SET acima de SELECT, para atribuir valores a variáveis. Nele, passamos NovoCPF =. Após o sinal de igual, abrimos parênteses e fechamos abaixo de FROM, em clientes. Abaixo de clientes, passamos RETURN NovoCPF;.

DELIMITER $$
CREATE FUNCTION FormatandoCPF()
RETURNS VARCHAR(50)
BEGIN
DECLARE NovoCPF VARCHAR(50)

SELECT NovoCPF = (
    CONCAT(SUBSTRING (cpf, 1, 3), '.', SUBSTRING(cpf, 4, 3), '.', SUBSTRING(cpf, 7, 3), '-', SUBSTRING(cpf, 10, 2)) AS CPF_Mascarado
FROM 
    clientes);
    
RETURN NovoCPF;

END$$

DELIMITER ;
Copiar código
Assim, temos a estrutura da função. Nesse caso estaríamos buscando por todos os CPFs de uma única vez, o que queremos, na verdade, é um cliente específico. Assim, poderemos formatar no momento de executar a consulta e buscar as informações do cliente.

Subimos clientes para a linha do FROM para ganhar mais espaço na tela. Após, abaixo de FROM, acrescentamos o WHERE cliente_id. Sabemos que na tabela de clientes esse campo identifica cada um deles.

Na mesma linha, adicionamos o sinal de igual = e especificamos que queremos buscar na tabela o cliente onde o CPF ID seja igual a um CPF específico. Então, passamos o número 1. Assim, buscamos o CPF do cliente de ID 1.

Se criarmos a função com essa estrutura, especificando o ID do cliente que queremos filtrar na consulta, quando precisarmos mudar o ID do cliente teremos que alterar a função.

Isso não faz sentido. Seria melhor se utilizássemos a consulta padrão dentro de uma função. Então, não criamos essa função ou então podemos usar outro recurso que são os parâmetros.

Utilizando parâmetros
Os parâmetros são semelhantes a variáveis, no CREATE FUNCTION FormatandoCPF(), podemos passar parâmetros nos parênteses.

Esses parâmetros são como variáveis que, ao executar a função, precisaremos obrigatoriamente passar um valor para a função. Mas, diferente das variáveis, esse valor será passado por nós no momento de chamar a função.

Podemos dar qualquer nome para esses parâmetros, nesse caso será ClienteID. Em seguida, definimos um tipo de valor INT, o inteiro, pois passaremos apenas o ID dos clientes.

Sempre que formos executar a função, passaremos ID de um cliente que já existe na tabela. Com isso teremos como retorno o CPF formatado. Por fim, passamos o DETERMINISTIC logo após o VARCHAR(50).

DELIMITER $$
CREATE FUNCTION FormatandoCPF (ClienteID INT)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
DECLARE NovoCPF VARCHAR(50);

SET NovoCPF = (
    CONCAT(SUBSTRING (cpf, 1, 3), '.', SUBSTRING(cpf, 4, 3), '.', SUBSTRING(cpf, 7, 3), '-', SUBSTRING(cpf, 10, 2)) AS CPF_Mascarado
FROM clientes
WHERE cliente_id = ClienteID
);

RETURN NovoCPF;
END$$
DELIMITER ;
Copiar código
Selecionamos essa estrutura de código e executamos. Assim, criamos a função. Agora, vamos executá-la. Então, no fim do código, passamos SELECT FormatandoCPF(1) e executamos.

SELECT FormatandoCPF(1)
Copiar código
Assim, temos o retorno abaixo:

-	FormatandoCPF(1)
-	658.190.237-30
Temos o CPF do cliente 1 formatado. Se no fim do código acrescentarmos o alias AS CPF e executar novamente.

SELECT FormatandoCPF(1) AS CPF;
Copiar código
O retorno fica da seguinte forma:

-	CPF
-	658.190.237-30
Como chamamos as funções através do SELECT, poderíamos chamar essa função com a tabela de clientes. Para isso, passamos SELECT TRIM(nome) Nome, cpf FROM clientes;. Selecionamos o código e executamos.

SELECT TRIM(nome) Nome, cpf FROM clientes;
Copiar código
O retorno é o seguinte:

Nome	cpf
João Miguel Sales	65819023730
Cauã da Mata	16285437955
Júlia Pires	19068243551
Srta Clara Jesus	4578 1630910
Ana Vitória Caldeira	75283146090
Luana Moura	25837410635
Temos nome e CPF desformatados. Isso porque estamos trazendo as informações da tabela. Mas, nesse código, podemos apagar o cpf e passar FormatandoCPF(1) AS CPF no lugar. Depois, no fim da linha, passamos WHERE cliente_id =1;.

SELECT TRIM(nome) Nome, FormatandoCPF (1) AS CPF FROM clientes WHERE cliente_id = 1;
Copiar código
Ao executar temos o retorno abaixo:

Nome	CPF
João Miguel Sales	65819023730
Visualizamos o nome e o CPF do cliente formatado. Essa é uma função bastante útil, podemos utilizá-la dentro do SELECT normal para trazer a utilidade de formatar um CPF.

Sempre que formos buscar informações de um cliente, podemos chamar essa função, especificando qual cliente queremos formatar o CPF.

Essas são consultas que já tínhamos anteriormente e que criamos funções para facilitar a execução. No vídeo seguinte, construiremos uma nova consulta solicitada pelas pessoas gestoras da Insight Places.


# Para saber mais: Para saber mais: atribuindo valores
 Próxima Atividade

No MySQL, ao trabalhar com funções (e também procedimentos armazenados), você pode precisar recuperar valores de tabelas do banco de dados e atribuí-los a variáveis. Para isso, o MySQL oferece principalmente duas abordagens: a instrução SELECT INTO e o comando SET em conjunto com uma subconsulta. Ambas as abordagens têm suas aplicações específicas, dependendo do que você está tentando alcançar.

Usando SELECT INTO
A instrução SELECT INTO permite que você selecione valores de uma tabela e os atribua diretamente a variáveis previamente declaradas. É útil quando você quer armazenar o resultado de uma consulta em variáveis para uso posterior dentro da mesma função ou procedimento.

Sintaxe:
SELECT coluna1, coluna2 INTO variavel1, variavel2 FROM tabela WHERE condição;
Copiar código
Exemplo:
Imagine que você tenha uma tabela chamada clientes e deseje recuperar o nome e o contato de um cliente específico cujo cliente_id seja 1.

DECLARE v_nome VARCHAR(255);
DECLARE v_contato VARCHAR(255);

SELECT nome, contato INTO v_nome, v_contato FROM clientes WHERE cliente_id = 1;
Copiar código
Neste cenário, os valores das colunas nome e contato para o cliente específico são armazenados nas variáveis v_nome e v_contato, respectivamente.

Usando SET com subconsulta
A instrução SET permite atribuir valores a variáveis, e pode ser utilizada com subconsultas para atribuir o resultado de uma consulta a uma variável. Esta abordagem é frequentemente usada quando você deseja atribuir um único valor a uma variável.

Sintaxe:
SET variavel = (SELECT coluna FROM tabela WHERE condição);
Copiar código
Exemplo:
Utilizando o mesmo cenário da tabela clientes, se você quiser recuperar apenas o nome do cliente com cliente_id igual a 1:

DECLARE v_nome VARCHAR(255);

SET v_nome = (SELECT nome FROM clientes WHERE cliente_id = 1);
Copiar código
Neste caso, v_nome é atribuído o valor da coluna nome para o cliente especificado.

Diferenças e quando utilizar cada um
SELECT INTO vs. SET:
SELECT INTO é mais adequado quando você precisa recuperar vários valores de uma consulta e atribuí-los a múltiplas variáveis simultaneamente.
SET com subconsulta é ideal para situações onde você está atribuindo um único valor a uma variável. É uma abordagem mais direta e legível para atribuições simples.
Limitações:
No contexto de funções, o uso do SELECT INTO é limitado, pois funções no MySQL não permitem instruções que retornem um conjunto de resultados diretamente. O SELECT INTO é mais comumente utilizado dentro de procedimentos armazenados.
O SET é versátil e pode ser usado tanto em funções quanto em procedimentos para atribuir valores simples.
Escolher entre SELECT INTO e SET depende do número de valores a serem atribuídos e da complexidade da operação de recuperação de dados. Em muitos casos, a preferência entre um e outro também pode ser uma questão de legibilidade e preferência pessoal do desenvolvedor.






## Question - Em uma equipe dedicada ao desenvolvimento de um aplicativo de finanças pessoais, você foi a pessoa selecionada para ficar encarregada de implementar uma funcionalidade que calcula o balanço mensal do usuário a partir de suas receitas e despesas registradas. A funcionalidade deve ajudar os usuários a entenderem melhor suas finanças, mostrando a diferença líquida entre o que foi ganho e o que foi gasto em um determinado mês. Para isso, você decide criar uma função no MySQL que recebe dois parâmetros: o total de receitas e o total de despesas de um usuário em um mês, e retorna o saldo líquido.

Baseado no cenário acima, qual das seguintes declarações de função no MySQL está corretamente configurada para calcular o balanço mensal do usuário? Escolha a alternativa correta.

Selecione uma alternativa

CREATE FUNCTION CalcBalancoMensal(receitas DECIMAL(10,2), despesas DECIMAL(10,2)) RETURNS DECIMAL(10,2)
BEGIN
RETURN (receitas * despesas);
END;

CREATE FUNCTION CalcBalancoMensal(receitas DECIMAL(10,2), despesas DECIMAL(10,2)) RETURNS DECIMAL(10,2)
BEGIN
DECLARE balanco DECIMAL(10,2);
SET balanco = receitas - despesas;
RETURN balanco;
END;

CREATE FUNCTION CalcBalancoMensal() 
RETURNS DECIMAL(10,2)
BEGIN
RETURN (receitas - despesas);
END;

CREATE FUNCTION CalcBalancoMensal(receitas DECIMAL, despesas DECIMAL) 
RETURNS INT
BEGIN
RETURN receitas + despesas;
END;    