## Chamando função em uma função
 
Para criar a nova função, usaremos o CREATE FUNCTION e a chamaremos de `CalcularValorFinalComDesconto`().

Vamos criar a estrutura base da nossa função, começando pelo retorno. Nosso RETURN vai ser um DECIMAL de 10,2, ou seja, 10 caracteres com duas casas decimais, e ela vai ser determinística, o que resulta em: RETURNS DECIMAL(10,2) DETERMINISTIC.

Vamos abrir o corpo da função com BEGIN e fechar aqui com o END. E, claro, vamos passar a cláusula DELIMITER no início e no fim.
```sql
DELIMITER $$

CREATE FUNCTION CalcularValorFinalComDesconto()
RETURNS DECIMAL(10,2) DETERMINISTIC

BEGIN

END$$

DELIMITER ;
```
Com essa base pronta, podemos criar a nossa função.

Para isso, vamos precisar pegar o valor de desconto que vem da nossa função calcularDescontoPorDias e aplicar no valor total. Esse valor total está armazenado, na nossa tabela de alugueis, no campo preco_total, então não precisamos fazer nenhum cálculo - apenas selecionar esse campo com um SELECT.

Como vamos precisar desse valor para reutilizar em nossa função, vamos armazená-lo em uma variável. Para isso usamos o DECLARE e a nomeamos como ValorTotal, com o tipo DECIMAL(10,2).

Em seguida, vamos pegar o campo preco_total que estamos buscando na nossa tabela de aluguéis e inserir em ValorTotal, com a cláusula INTO, resultando em: SELECT preco_total INTO ValorTotal FROM alugueis.

Porém, queremos realizar esse SELECT de um aluguel específico, não aleatório ou de todos. Então, vamos aplicar um filtro usando a cláusula WHERE e definir: aluguel_id precisa ser igual ao parâmetro que vamos criar nessa função.

O nome desse parâmetro vai ser AluguelID, do tipo INT. Isso resulta em CREATE FUNCTION CalcularValorFinalComDesconto(AluguelID).

Vamos buscar o preco_total na nossa tabela de alugueis onde o aluguel_id for igual ao AluguelID que estamos passando como parâmetro da nossa função: SELECT preco_total INTO ValorTotal FROM alugueis WHERE aluguel_id = AluguelID.

Agora precisamos buscar o nosso valor de desconto, ou seja, qual a porcentagem de desconto que essa pessoa cliente vai receber? Para isso, vamos chamar a nossa função CalcularDescontoPorDias(), que criamos anteriormente.

Assim como passamos o AluguelID no filtro da nossa consulta SELECT, vamos passar esse mesmo AluguelID para a função CalcularDescontoPorDias().

E por que fazemos isso? Pois essa função também espera o parâmetro AluguelID, conforme declaramos no vídeo anterior, para calcular o desconto de cada caso.

E se estamos calculando esse valor, também precisamos armazená-lo em algum lugar. Vamos declarar uma nova variável para isso, que chamaremos de Desconto, do tipo INT. Por que tipo inteiro? Porque essa função retorna apenas o único número - 5, 10, 15 ou 0.

Agora, com a nossa cláusula SET, vamos configurar o valor retornado de CalculaDescontoPorDias será armazenado em Desconto, resultando em: SET Desconto = CalcularDescontoPorDias(AluguelID).

Já temos as variáveis ValorTotal e Desconto. Agora, vamos aplicar o Desconto ao ValorTotal, calculando valor final.

Para isso, vamos criar uma nova variável chamada ValorFinal, de tipo DECIMAL(10,2).

Por fim, vamos atribuir a esta variável ValorFinal o resultado de valor total menos o desconto, usando a cláusula SET.

Esse valor será calculado da seguinte forma: vamos pegar o ValorTotal e subtrair do resultado da expressão ValorTotal multiplicado por Desconto dividido por 100. Isso resulta em ValorTotal - (ValorTotal * Desconto / 100).

O cálculo entre parênteses será executado primeiro, multiplicando o valor e dividindo por 100, resultando no valor exato do desconto em reais, não mais em porcentagem. Esse valor será subtraído do valor total. O resultado disso será armazenado em ValorFinal.

Então, no final, podemos fazer um RETURN ValorFinal. Nossa função ficará assim:
```sql
DELIMITER $$

CREATE FUNCTION CalcularValorFinalComDesconto()
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
```

Ao executar o código acima, a função é criada. Agora podemos chamá-la, passando o ID de aluguel igual a 1, para testar:
```
SELECT CalcularValorFinalComDesconto(1);
```

Temos como retorno o valor final, com desconto, do aluguel de ID 1, que foi igual a R$ 3072:

Resultado da consulta
```
CalcularValorFinalComDesconto()
3072.00
```
Podemos inclusive consultar todos os dados da tabela alugueis para verificar o valor inicial do aluguel de ID 1, e saberemos que era de R$ 3.240.
