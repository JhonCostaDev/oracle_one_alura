Já entendemos como podemos criar nossas próprias funções, além de declarar variáveis e utilizar parâmetros.

Agora, temos uma nova solicitação das pessoas gestoras da Insight Places, que é construir uma consulta que retorna o nome e o valor da diária pago por cada hóspede.

No MySQL, criamos uma nova aba, passamos a consulta SELECT * FROM alugueis; e executamos.

SELECT * FROM alugueis;
Copiar código
Feito isso, temos como retorno os IDs, data_inicio, data_fim e o preco_total. No entanto, não temos a informação de quanto foi o valor da diária. Essa é a informação que as pessoas gestoras querem saber.

Deixaremos esse desafio para você resolver. Se você se interessar, pode pausar esse vídeo e tentar montar essa consulta que retornará o nome e o valor da diária do hóspede. Depois, pode voltar para esse vídeo. Pois agora construiremos essa função.

Caso não queira, pode seguir esse vídeo direto. É opcional, mas é um desafio importante para colocar em prática os conhecimentos que adquirimos até este momento.

Estruturando a função
Começaremos estruturando a nossa função, não montaremos a consulta separada. Começamos passando CREATE FUNCTION InfoAluguel(). Nesse caso, buscaremos um aluguel por vez, não queremos retornar todos. Sendo assim, como parâmetro, passamos IdAluguel INT.

Na linha abaixo, passamos RETURNS e retornar um VARCHAR(255). Em seguida, passamos DETERMINISTIC. Na linha seguinte, passamos BEGIN e no fim do código END.

Na linha acima de CREATE FUNCTION passamos DELIMITER $$, em END acrescentamos o cifrão duplo $$ e no fim do código escrevemos DELIMITER ;.

SELECT * FROM alugueis;

DELIMITER $$
CREATE FUNCTION InfoAluguel(IdAluguel INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN

END$$

DELIMITER ;
Copiar código
Agora, precisamos montar a consulta. Abaixo de BEGIN, escrevemos SELECT *. Como queremos o nome do cliente, na linha abaixo passamos FROM alugueis a, abaixo JOIN clientes c e ON a.cliente_id = c.cliente_id.


SELECT * FROM alugueis;

DELIMITER $$
CREATE FUNCTION InfoAluguel(IdAluguel INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN

SELECT * 
FROM alugueis a
JOIN clientes c
ON a.cliente_id = c.cliente_id

END$$

DELIMITER ;
Copiar código
Mas não queremos todas essas informações. Então, após o SELECT, passamos c.nome seguido de a.preco_total, pois é através dele que obteremos as informações do valor da diária.

O que precisamos não são as datas, mas sim a diferença de dias. Para isso, podemos usar uma função que calcula justamente isso, a DATEDIFF(data_fim, data_inicio). Colocamos essa função na linha de SELECT.

Assim, estamos buscando nome, valor total, data fim e a data início, ou seja, a diferença entre dias dessas duas informações. Após ON, aplicamos o filtro WHERE seguido de a.aluguel_id = IdAluguel. Pressionamos "Enter" duas vezes para dar espaço.

Precisamos armazenar essas informações em variáveis. Então, abaixo de BEGIN vamos declarar três variáveis.

Passamos DECLARE NomeCliente VARCHAR(100). Na linha abaixo DECLARE PrecoTotal DECIMAL(10,2), assim terá 10 caracteres e após a vírgula duas casa decimais. Em seguida, passamos DECLARE Dias INT. Abaixo de SELECT, passamos INTO NomeCliente, PrecoTotal, Dias.

SELECT * FROM alugueis;

DELIMITER $$
CREATE FUNCTION InfoAluguel(IdAluguel INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN

DECLARE NomeCliente VARCHAR(100);
DECLARE PrecoTotal DECIMAL(10,2);
DECLARE Dias INT;

SELECT * c.nome, a.preco_total, DATEDIFF(data_fim, data_inicio)
INTO NomeCliente, PrecoTotal, Dias
FROM alugueis a
JOIN clientes c
ON a.cliente_id = c.cliente_id

END$$

DELIMITER ;
Copiar código
Calculando o valor da diária
Agora, usaremos essas variáveis para calcular justamente o valor da diária. Para isso, pegaremos o preço total e dividiremos pela quantidade de dias calculados pelo DATEDIFF() e armazenado em Dias.

Abaixo de WHERE, passamos PrecoTotal / Dias. Mas, precisamos armazenar isso em uma nova variável. Então, teremos que declarar essa nova variável. Para isso, abaixo de DECLARE Dias, passamos DECLARE ValorDiaria DECIMAL(10,2).

Feito isso, antes de PrecoTotal / Dias, passamos o ValorDiaria seguido do sinal de igual. Além disso, precisamos identificar que queremos setar um valor nessa variável. Então, no início da linha, passamos SET.

SELECT * FROM alugueis;

DELIMITER $$
CREATE FUNCTION InfoAluguel(IdAluguel INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN

DECLARE NomeCliente VARCHAR(100);
DECLARE PrecoTotal DECIMAL(10,2);
DECLARE Dias INT;
DECLARE ValorDiaria DECIMAL(10,2);

SELECT * c.nome, a.preco_total, DATEDIFF(data_fim, data_inicio)
INTO NomeCliente, PrecoTotal, Dias
FROM alugueis a
JOIN clientes c
ON a.cliente_id = c.cliente_id
WHERE a.aluguel_id = IdAluguel

SET ValorDiaria = PrecoTotal / Dias;

END$$

DELIMITER ;
Copiar código
Queremos retornar essa informação de forma organizada, então, vamos declarar uma nova variável. Já temos a variável NomeCliente, PrecoTotal, Dias e ValorDiaria. Estamos buscando na tabela de aluguel e de clientes o nome do cliente, preço total e a diferença entre dias. Isso, pois dividindo o preço total por dias, teremos o valor da diária.

Mas como podemos retornar essas duas informações, tanto o nome como o valor da diária? Lembrando que só retornamos um VARCHAR, não retornamos tipos diferentes ou dois retornos diferentes.

Usando a função CONCAT()
Nesse caso, podemos utilizar a função CONCAT(). Vamos concatenar o valor da diária com o nome do cliente. Na linha abaido de SET, passamos CONCAT('Nome: ', NomeCliente, 'Valor Diário: R$', FORMAT()).

Se retornarmos esse valor de diária, ele estará com diversas casas decimais. Com o FORMAT() ele formatará o valor. Então, podemos passar o ValorDiaria. Depois, dizemos que queremos retornar apenas duas casas decimais, então adicionamos vírgula seguido do número 2.

Precisamos pegar essa grande string que montamos e atribuir ela a uma variável também. Isso porque também vamos utilizá-la para retornar essa informação.

Próximo à linha 12, passamos DECLARE Resultado VARCHAR(255). Após, faremos algo semelhante com o que fizemos para setar o valor da diária. Antes de CONCAT(), passamos SET Resultado seguido do sinal de igual =.

Abaixo de SET Resultado, passamos RETURN Resultado; para retornar o resultado.

SELECT * FROM alugueis;

DELIMITER $$
CREATE FUNCTION InfoAluguel(IdAluguel INT)
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN

DECLARE NomeCliente VARCHAR(100);
DECLARE PrecoTotal DECIMAL(10,2);
DECLARE Dias INT;
DECLARE ValorDiaria DECIMAL(10,2);
DECLARE Resultado VARCHAR(255);

SELECT * c.nome, a.preco_total, DATEDIFF(data_fim, data_inicio)
INTO NomeCliente, PrecoTotal, Dias
FROM alugueis a
JOIN clientes c
ON a.cliente_id = c.cliente_id
WHERE a.aluguel_id = IdAluguel

SET ValorDiaria = PrecoTotal / Dias;

SET Resultado = CONCAT('Nome: ', NomeCliente, ', Valor Diário: R$', FORMAT(ValorDiaria,2));

RETURN Resultado;

END$$

DELIMITER ;
Copiar código
Feito isso, selecionamos todo o código e executamos para criar a função. Em seguida, no fim do código, passamos SELECT InfoAluguel(1) e executamos.

SELECT InfoAluguel(1)
Copiar código
Assim, temos o seguinte retorno:

-	InfoAluguem(1)
-	Nome: João Miguel Sales, Valor Diário: R$648,00
O valor da diária que o João Miguel pagou foi R$648, deu certo. Além disso, podemos validar essa informação passando SELECT * FROM alugueis; e executar.

SELECT * FROM alugueis;
Copiar código
Assim, temos como retorno uma tabela extensa. Podemos pegar o preco_total da primeira linha, que é 3240.00 e dividir pela diferença de dias. Assim, conseguimos saber se o valor realmente corresponde.

Mas, nesse caso sabemos que o cálculo foi feito da forma correta. Temos como resultado exatamente o nome e o valor da diária dos hóspedes. Essa é uma consulta bem interessante, pois temos informações mais específicas.

Essas são apenas algumas das utilidades de criar nossa própria função. Na próxima aula entenderemos como podemos chamar essas funções, até mesmo a outros procedimentos armazenados.