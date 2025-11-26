# Utilizando parâmetros em Store Procedures no MySQL

Continuando a melhoria da procedure feita anteriormente onde declaramos as variáveis, usando os valores default (padrão) e, em seguida, executamos um comando de INSERT. Agora, na procedure que criamos, os valores do identificador do aluguel, do cliente, da hospedagem e assim por diante, estão fixos na declaração da variável.

```sql
BEGIN
    DECLARE vAluguel VARCHAR(10) DEFAULT '10001';
    DECLARE vCliente VARCHAR(10) DEFAULT '1002';
    DECLARE vHospedagem VARCHAR(10) DEFAULT '8635';
    DECLARE vDataInicio DATE DEFAULT '2023-03-01';
    DECLARE vDataFinal DATE DEFAULT '2023-03-05';
    DECLARE vPrecoTotal DECIMAL(10,2) DEFAULT 550.23;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END
```
Portanto, se quisermos incluir um `novo aluguel`, precisaremos editar a procedure, alterar esses valores dentro dela, salvar a procedure e executá-la. Não há condição para isso funcionar corretamente. No entanto, podemos passar parâmetros para dentro da procedure.

Então, a maneira correta é `criar uma procedure onde passamos parâmetros e, ao chamá-la, passamos esses parâmetros`. 

Quem serão esses parâmetros? Serão os dados referentes ao aluguel. Portanto, vamos modificar a nossa procedure agora para aceitar parâmetros.

## Alterando a procedure para aceitar parâmetros
Vamos copiar a procedure anterior do script, desde o 

USE \`insightplaces\`; da linha 19, que aparece primeiro, antes do um DROP, até o comando `DELIMITER`; do final, na linha 34. Após copiarmos, criaremos um novo script, onde vamos colar esse código. Em seguida, na linha 2 e na linha 5, mudaremos o nome para `novoAluguel_3`.

```sql
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `insightplaces`.`novoAluguel_3`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_3`()
BEGIN
    DECLARE vAluguel VARCHAR(10) DEFAULT '10001';
    DECLARE vCliente VARCHAR(10) DEFAULT '1002';
    DECLARE vHospedagem VARCHAR(10) DEFAULT '8635';
    DECLARE vDataInicio DATE DEFAULT '2023-03-01';
    DECLARE vDataFinal DATE DEFAULT '2023-03-05';
    DECLARE vPrecoTotal DECIMAL(10,2) DEFAULT 550.23;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;
```
Vamos começar a trabalhar com essa procedure. O que estamos dizendo é que não vamos inicializar essas variáveis nesse novo script, e sim passá-las como parâmetro. Para isso, a declaração da variável, ou seja, o seu nome e o seu tipo, estará dentro dos parênteses de `novoAluguel_3`(). Então, vamos dizer que essa procedure está apta a receber parâmetros quando ela for chamada. Vamos fazer essa edição.


```sql
CREATE DEFINER=`root`@`localhost` 
PROCEDURE `novoAluguel_3`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoTotal DECIMAL(10,2))
```


Então, com um "Enter", passamos os parênteses para a linha de baixo e adicionamos a declaração de todas as variáveis como no BEGIN, lembrando apenas de remover o DEFAULT. Com isso, temos a declaração dos parâmetros. E, claro, se já definimos a variável dentro dos parâmetros, não precisamos ter o DECLARE dentro do BEGIN, então podemos apagá-lo.

Nossa rotina ficou assim: declaramos ela, colocamos a passagem de parâmetros e temos o seu conteúdo, que é apenas um INSERT, usando os parâmetros passados no início da procedure:

```sql
USE `insightplaces`;
DROP PROCEDURE IF EXISTS `insightplaces`.`novoAluguel_3`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_3`
(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE, vDataFinal DATE, vPrecoTotal DECIMAL(10,2))
BEGIN
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
END$$
DELIMITER ;
```

Vamos executar esse script e recebemos que o retorno foi executado com sucesso. Se atualizarmos o `"StoredPorcedures"`, na coluna da direita, aparece o novoAluguel_3.

## Incluindo novos alugueis
Vamos, agora, inserir o aluguel `10002`, porque incluímos o `10001` no vídeo anterior. Para fazer isso, codamos CALL novoAluguel_3() e, dentro dos parênteses, colocamos agora os parâmetros. Usaremos os dados da procedure anterior como referência.

Observação: O instrutor copia os dados e deixa comentado apenas para facilitar a inclusão do aluguel 10002. Vocês não precisam copiar os dados se não quiserem.
```sql
-- 1002

CALL novoAluguel_23('10002', '1003', '8635', '2023-03-06', '2023-03-10', 600)
```
O ID do aluguel é o `10002`. Colocamos outro cliente, o 1003, a hospedagem será no mesmo local, mas a data será a partir do dia 6, já que o hóspede 10001 vai deixar o apartamento no dia 5. E o novo hóspede fica hospedado até 2023-03-10. E o valor ficou 600 unidades monetárias.

Após executarmos esse código, escreveremos 
```sql
SELECT * FROM alugueis WHERE aluguel_id = '10002';
```
Vamos executar esse código e teremos o aluguel incluído.

Portanto, se tivermos que incluir um novo aluguel, não precisamos editar a procedure e modificar a inicialização das variáveis. Basta executarmos de novo a procedure, passando um novo ID e os demais dados por parâmetros, como a acabamos de fazer. Façamos um novo exemplo.

```sql
CALL novoAluguel_23('10003', '1004', '8635', '2023-03-10', '2023-03-12', 250)
```
Ao executarmos essa nova procedure, não temos nenhum problema. Em seguida, basta executarmos:

```sql
SELECT * FROM alugueis WHERE aluguel_id IN ('10002', 10003);
```

    aluguel_id	cliente_id	hospedagem_id	data_inicio	data_fim	preco_total
    10002	    1003	    8635	        2023-03-06	2023-03-10	600.00
    10003	    1004	    8635	        2023-03-10	2023-03-12	250.00
Ao rodarmos esse código, recebemos os dois aluguéis incluídos usando a procedure. 


## Question -  Avançando na personalização de Stored Procedures
 Próxima Atividade

Analise a procedure desenvolvida:

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_23`(vAluguel VARCHAR(10), vCliente VARCHAR(10), vHospedagem VARCHAR(10), vDataInicio DATE,
vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE VPrecoTotal DECIMAL(10,2);
    SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
    SET vPrecoTotal = vDias * vPrecoUnitario;
    INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, 
    vDataFinal, vPrecoTotal);
END
```

A introdução de parâmetros nas stored procedures representa um salto significativo na personalização e flexibilidade do gerenciamento de dados. Considerando a estrutura e funcionalidade da novoAluguel_23, qual aspecto destaca sua evolução em relação às versões anteriores?

Selecione uma alternativa

Utiliza variáveis locais para armazenar temporariamente os dados antes da inserção.


Permite a personalização dos dados inseridos através de parâmetros externos.


Executa múltiplas inserções simultaneamente para aumentar a eficiência.


Integra funcionalidades avançadas de seleção e filtragem de dados.


Automatiza o processo de atualização de registros existentes na tabela alugueis.