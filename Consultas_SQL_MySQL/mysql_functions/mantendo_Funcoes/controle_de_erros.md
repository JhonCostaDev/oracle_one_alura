Quando começamos a estudar funções, não abordamos cursores, loops while ou tratamento de erros, porque esses recursos não foram concebidos para serem utilizados junto com funções. As funções são projetadas para serem simples, como as funções nativas da linguagem SQL.

Por exemplo, a função de agregação sum recebe um valor, realiza a soma e retorna um valor único. Da mesma forma, a função que criamos pode receber um parâmetro, executar uma ação e retornar um único valor. Esse é o propósito das funções.

Distinção entre Funções e procedures
Internamente, as funções e as procedures no MySQL são tratadas de formas diferentes. As procedures têm realmente o objetivo de ser mais robustas, já as funções são realmente bem mais simples. Recebem um valor ou não, executam algo e retornam para quem as executou.

Dentro dos procedimentos armazenados, podemos lidar com erros, utilizar cursores, e empregar loopings, entre outras funcionalidades. É possível, em alguns casos, aplicar loopings ou cursores dentro de funções, mas isso não é sua finalidade principal, já que as funções são concebidas para serem simples.

Determinismo nas Funções
DELIMITER $$ 
CREATE FUNCTION CalcularValorFinalComDesconto(AluguelID INT)
RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
  DECLARE ValorTotal DECIMAL(10,2);
  DECLARE Desconto INT;
  DECLARE ValorFinal DECIMAL(10,2);

  SELECT preco_total INTO ValorTotal FROM alugueis WHERE aluguel_id = AluguelID;

  SET Desconto = CalcularDescontoPorDias(AluguelID);

  SET ValorFinal = ValorTotal - (ValorTotal * Desconto / 100);

  RETURN ValorFinal;
END$$

DELIMITER ;

SELECT CalcularValorFinalComDesconto;

SELECT * FROM alugueis;
Copiar código
Por exemplo, ao definirmos que uma função é determinística, estamos estabelecendo que, para um conjunto específico de parâmetros, ela sempre produzirá o mesmo resultado.

Se optarmos por trabalhar com funções que executam inserções (insert), embora essa não seja a melhor abordagem, pode haver situações em que trabalhar com inserção, atualização e exclusão nem seja viável. Sabemos que podemos realizar inserções ao incorporá-las dentro de uma função, especialmente devido ao tratamento de erros que isso possibilita. Isso tornaria a função mais robusta, se fosse factível.

Assim, acabaríamos por ter a mesma funcionalidade ao lidar com procedures e funções. Não seria necessário manter dois tipos distintos de procedimentos, pois um único tipo nos atenderia, permitindo realizar todas as operações tanto em funções quanto em procedures.

Mas voltando para a questão da inserção. Quando realizamos inserts em uma tabela, sempre temos que validar a questão da chave primária, temos que validar a chave estrangeira também.

Poderíamos, neste caso, fazer o insert dentro da nossa função, mas se não temos como fazer o tratamento de erros, não temos como fazer a mesma coisa que acontece dentro de procedimentos armazenados, que é, por exemplo, tratar prováveis erros que podem acontecer ao trabalhar com chave primária e chave estrangeira.

Em suma, a função busca simplicidade enquanto a procedure busca robustez. Se necessita de mais robustez, opte por procedimentos armazenados, pois foram criados com esse propósito. Para algo mais simples, as funções são adequadas. Entretanto, é possível combinar ambos.

Podemos incorporar funções em procedimentos armazenados, como fizemos com a Treasure, ou em Views (Visões) e outros recursos, conforme necessário.

Dentro das funções, o que ocorre se inserirmos um ID que não existe em nossas tabelas, como na situação da tabela de aluguéis? Isso acontece na tabela de aluguel porque estamos fornecendo a ela o nosso aluguel ID como parâmetro.

SELECT CalcularValorFinalComDesconto(1);
Copiar código
Assim, ao passarmos o número 1 para a nossa função calcular valor final com desconto, ela retornará um valor, pois encontrou uma referência desse ID na tabela de aluguéis.

#	CalcularValorFinalComDesconto(1)
3078.00
Contudo, e se não encontrar? Por exemplo, ao passarmos zero, obteremos apenas NULL, ou seja, nenhum resultado.

SELECT CalcularValorFinalComDesconto(0);
Copiar código
#	CalcularValorFinalComDesconto(1)
Null
Nesse caso, se não há erro, não há nada a ser tratado.

No entanto, podemos tornar esse retorno mais significativo. Em vez de obter NULL, podemos especificar um valor de retorno particular. É por isso que, muitas vezes, mesmo que a função não tenha originalmente a finalidade de realizar certos procedimentos, ainda conseguimos utilizá-la para isso.

## Para saber mais: tratamento de erros em funções no MySQL
 

No MySQL, a capacidade de tratar explicitamente erros dentro de funções criadas pelo usuário é limitada em comparação com procedimentos armazenados. Isso se deve principalmente à maneira como as funções são projetadas e utilizadas no MySQL, além de algumas restrições arquitetônicas.

Design e uso de funções
Funções no MySQL são destinadas a ser objetos que retornam um único valor e são frequentemente usadas em contextos onde expressões são permitidas, como parte de uma consulta SELECT, na lista de argumentos de outras funções ou em cláusulas WHERE, por exemplo. Isso implica algumas características específicas:

Determinismo: Funções precisam ser determinísticas (ou ao menos, quando marcadas como tal), significando que devem retornar o mesmo resultado sempre que são chamadas com um conjunto específico de parâmetros de entrada, dentro do mesmo estado do banco de dados.
Performance: Para garantir a performance, especialmente em consultas que processam muitas linhas, o tratamento de erros, que poderia exigir operações adicionais como rollback ou manipulação de exceções, é evitado dentro de funções.
Simplicidade: Funções são concebidas para operações que podem ser expressas como cálculos ou transformações de dados simples e diretos. A inclusão de lógica complexa de tratamento de erros poderia contradizer essa intenção, aumentando a complexidade e potencialmente afetando a performance.
Restrições arquitetônicas
O motor do MySQL trata funções e procedimentos de maneira diferente, especialmente em termos de execução e integração com o mecanismo de transações. Enquanto procedimentos armazenados suportam uma ampla gama de operações SQL, incluindo transações e manipulação de erros, funções são mais restritas:

Transações: Funções são executadas dentro do contexto de uma transação existente e não podem controlar transações (ou seja, não podem iniciar, comitar ou reverter transações). Isso limita a sua capacidade de tratar erros, pois o tratamento efetivo de erros frequentemente requer controle transacional.
Fluxo de Controle: O MySQL não permite comandos que alteram o fluxo de controle (como LEAVE, REPEAT, WHILE) ou tratamento de erros (como DECLARE ... HANDLER) dentro de funções, restringindo ainda mais a capacidade de lidar com exceções.
Práticas recomendadas
Dada a limitação no tratamento de erros dentro de funções no MySQL, é recomendado:

Validar dados de entrada: Sempre que possível, validar os dados de entrada antes de passá-los para uma função para minimizar a possibilidade de erros.
Uso de procedimentos: Para lógicas complexas que requerem tratamento de erros robustos, considere usar procedimentos armazenados em vez de funções.
Funções de wrapper: Em alguns casos, pode-se criar "funções de wrapper" para procedimentos armazenados que lidam com o tratamento de erros, embora isso possa não ser ideal ou sempre prático.
A abordagem do MySQL em relação ao tratamento de erros em funções reflete um compromisso entre simplicidade, performance e a filosofia de design de funções como objetos de banco de dados que devem ser rápidos, leves e seguros.

