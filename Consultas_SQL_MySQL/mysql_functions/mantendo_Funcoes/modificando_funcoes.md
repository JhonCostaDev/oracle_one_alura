# Modificando Funções
Entendemos como o tratamento de erros e a utilização de recursos como cursor e looping funcionam dentro de uma função em SQL. Sabemos que, ao passar um valor inexistente nas tabelas, o retorno é NULL em vez de um erro.

Embora seja preferível receber NULL a um erro, ainda podemos realizar um tratamento para garantir que, mesmo não sendo um erro, sempre haja um valor apresentado ao executar nossa função. É isso que abordaremos a seguir.

Vamos editar uma das nossas funções, atualizar, para fazer esse tratamento deste retorno.

Tratamento do retorno
Para isso, vamos acessar o menu lateral schemas, vamos abaixar a aba inferior de informações (information). Assim, conseguimos visualizar nossas funções na tabela Functions. Temos todas elas, como CalcularDescontoPorDia, FormatandoCPF e também a InfoAluguel.

Functions
CalcularDescontoPorDia
CalcularValorFinalComDesconto
FormatandoCPF
InfoAluguel
MediaAvaliacoes
RetornoConstante
Vamos relembrar o que a InfoAluguel faz. Abrimos uma nova aba, clicando no primeiro ícone no canto superior esquerdo. Digitamos o seguinte comando:

SELECT InfoAluguel(1)
Copiar código
Executamos o comando e obtemos:

#	InfoAluguel(1)
Nome: João Miguel Sales, Valor Diário: R$648,00
A InfoAluguel busca na nossa tabela de Aluguel, o nome e o valor da diária deste cliente. É bem interessante, mas quando passamos realmente um ID que não existe, nenhum erro também vai ser retornado, mas temos como retorno o NULL, ou seja, vazio.

SELECT InfoAluguel(0)
Copiar código
Obtemos como retorno:

#	InfoAluguel(0)
Null
Podemos então fazer um tratamento, para que ao invés de retornar NULL, tenhamos um valor. Então é isso que vamos fazer agora na nossa InfoAluguel.

No menu lateral, em schemas, temos todas as funções, e vamos clicar com o botão direito em cima da função da InfoAluguel.

Será aberta uma janela com diversas opções, dentre elas:

Create Function
Alter Function
Drop Function.
Clicamos na opção "Create Function", e será aberta uma janela com a estrutura básica da criação de uma função.

CREATE FUNCTION `new_function` ()
RETURNS INTEGER
BEGIN

RETURN 1;
END
Copiar código
Temos o Create Function, o nome da função, temos o Returns, que está passando para o padrão Integer, temos o Begin, temos o End, e entre o Begin e o End já temos o Return, porque ele é obrigatório, então ele já vem na estrutura básica das funções aqui no MySQL.

Fechamos clicando no ícone de xis no canto superior direito na aba "new_function - Routrine". Será exibida uma janela em que vamos clicar em "Don't Save", pois não desejamos criar uma nova função.

Também não desejamos excluir, queremos alterar uma função. Para isso, clicamos com o botão direito na tabela InfoAluguel e selecionamos a opção "Alter Function".

Ao selecionarmos, obtemos um CREATE FUNCTION:

CREATE DEFINER=`root`@`localhost` FUNCTION `InfoAluguel`(IdAluguel INT) RETURNS varchar(255) CHARSET utf8mb4
DETERMINISTIC
BEGIN

  DECLARE NomeCliente VARCHAR(100);
  DECLARE PrecoTotal DECIMAL(10,2);
  DECLARE Dias INT;
  DECLARE ValorDiaria DECIMAL(10,2);
  DECLARE Resultado VARCHAR(255);

  SELECT c.nome, a.preco_total, DATEDIFF(data_fim, data_inicio)
  INTO NomeCliente, PrecoTotal, Dias
  FROM alugueis a
  JOIN clientes c
  ON a.cliente_id = c.cliente_id
  WHERE a.aluguel_id = IdAluguel;

  SET ValorDiaria = PrecoTotal / Dias;
  SET Resultado = CONCAT('Nome: ', NomeCliente, ', Valor Diário: R$', FORMAT(ValorDiaria,2));
    
  RETURN Resultado;
END
Copiar código
É claro que ele apresentará outras opções que não foram especificadas na nossa função inicial, como o endereço do usuário e a conexão, mencionando "localhost" como o banco de dados, que está em uma conexão local, além do "charset", que é padrão e refere-se à codificação para textos e strings, utilizando o "utf8mb4".

Portanto, o restante das informações realmente pertence à função. Assim, temos a estrutura familiar que já conhecemos. No entanto, o que podemos fazer para sempre obtermos um retorno em vez de receber NULL? A solução é usar uma declaração IF, então vamos empregar o IF para garantir esse retorno.

Antes do set, inserimos o IF e passamos para ele os Dias. Com o IF, precisamos condicionar: se isso acontecer, ele fará isso; caso contrário, executará outra ação. Se Dias, que é a nossa variável para a diferença entre as datas da nossa tabela de aluguéis, é IS NULL (ou seja, é vazio) ou OR se Dias menor ou igual a zero, o que faremos? Usamos o THEN.

Vamos seguir este processo: retornar zero se a variável Dias for IS NULL ou menor ou igual a zero, retornamos zero. Em seguida, ponto e vírgula; caso contrário (ELSE), o que faremos? Definiremos o valor diário como o preço total dividido por dias e também definiremos a variável resultado. Depois de concluir essas etapas, encerraremos o IF com END IF.

(SQL omitido)

    IF Dias IS NULL OR Dias <= 0 THEN 
        Return 0;
    ELSE
        SET ValorDiaria = PrecoTotal / Dias;
        SET Resultado = CONCAT('Nome: ', NomeCliente, ', Valor Diário: R$', FORMAT(ValorDiaria,2));
END IF

  RETURN Resultado;
END
Copiar código
Para resumir, se Dias for nulo (IS NULL) ou menor ou igual a zero, a ação será simplesmente retornar zero; não chegaremos à parte de definir as variáveis. Se não for nenhum desses casos, ou seja, se não for nulo ou menor que zero, então procederemos com os cálculos: calcularemos o valor da diária, definiremos a variável resultado e encerraremos o bloco IF.

Clicamos em "Apply" no canto inferior direito. Um ponto interessante é que, mesmo clicando em InfoAluguel e selecionando a opção "ALTER FUNCTION", no momento que vamos realmente fazer a alteração, o nosso MySQL exclui a nossa função InfoAluguel.

Na verdade, não alteramos, mas apagamos a função e a criamos novamente. Não temos a possibilidade aqui no MySQL de alterar uma função, como temos em outros SGBDs.

Então, mesmo na opção InfoAluguel, estamos, primeiro, excluindo a nossa função e, em seguida, criando-a novamente. É isso que o MySQL faz quando selecionamos essa opção. Outra opção que poderíamos fazer é excluir a nossa InfoAluguel e criá-la novamente do zero, sem precisar selecionar essa opção pelo assistente.

Clicamos em "Apply" e tudo foi executado corretamente. Na janela seguinte, clicamos em "Finish”, no canto inferior direito. Vamos fechar essa opção no ícone de xis no canto superior direito. Em seguida, executaremos novamente a nossa função InfoAluguel. Ao passarmos o ID 1, obtemos o mesmo resultado de antes.

SELECT InfoAluguel(1)
Copiar código
Como retorno, obtemos:

#	InfoAluguel(1)
Nome: João Miguel Sales, Valor Diário: R$648,00
Porém, se passarmos zero, o resultado será zero.

SELECT InfoAluguel(0)
Copiar código
Obtemos:

#	InfoAluguel(0)
0
Dessa forma, em vez de ser nulo, teremos zero. A função entrou no nosso if, validando essas informações e está nos retornando esse valor. Podemos até passar o valor "-1" e verificar se ele será executado; mesmo assim, ele nos retorna zero.

Uma maneira de tornar o trabalho com funções mais interessantes é não apenas retornar nulo, mas também definir um retorno específico, como um número, por exemplo. Discutimos como funciona a alteração de funções no MySQL. Em vez de modificar diretamente, o processo envolve excluir a função e, em seguida, criá-la novamente com as alterações desejadas.

Conclusão e Próximos Passos
É importante proceder com cautela ao executar essas ações. Imagine que excluímos uma função para fazer alterações, mas esquecemos de recriá-la depois. Isso pode levar a problemas significativos.

Se essa função estiver sendo usada em outros processos, como no caso da nossa tabela ou da função CalcularValorFinalComDesconto, que por sua vez utiliza a função CalcularDescontoPorDias, podemos enfrentar dificuldades.

## Question - Atualizando dados de uma função


Você está atuando como pessoa desenvolvedora de banco de dados para um sistema de gerenciamento de biblioteca online. Foi solicitado que você atualize uma função existente no MySQL, chamada CalculaMultaAtraso, que originalmente calcula a multa por dias de atraso na devolução de um livro. A atualização deve permitir que a função receba um segundo parâmetro representando a taxa de multa por dia de atraso, tornando a função mais flexível para ajustes futuros nas políticas de multa da biblioteca.

Considerando a necessidade de atualizar a função CalculaMultaAtraso para aceitar um segundo parâmetro (taxaMultaPorDia), qual das seguintes ações é corretamente realizada para modificar uma função no MySQL? Escolha uma alternativa.

Alternativa correta
ALTER FUNCTION CalculaMultaAtraso 
MODIFY (diasAtraso INT, taxaMultaPorDia DECIMAL(5,2));

Alternativa correta
DROP FUNCTION IF EXISTS CalculaMultaAtraso; 
CREATE FUNCTION CalculaMultaAtraso(diasAtraso INT, taxaMultaPorDia DECIMAL(5,2)) RETURNS DECIMAL(10,2) BEGIN ... END;

No MySQL, para modificar uma função, você deve primeiro removê-la com DROP FUNCTION e então recriá-la com a nova definição usando CREATE FUNCTION. Esta é a abordagem padrão para "alterar" funções, pois permite a redefinição completa dos parâmetros, do tipo de retorno e da lógica interna.

Alternativa correta
REPLACE FUNCTION CalculaMultaAtraso(diasAtraso INT, taxaMultaPorDia DECIMAL(5,2)) RETURNS DECIMAL(10,2) BEGIN ... END;

Alternativa correta
UPDATE FUNCTION CalculaMultaAtraso 
SET PARAMETER (diasAtraso INT, taxaMultaPorDia DECIMAL(5,2)) 