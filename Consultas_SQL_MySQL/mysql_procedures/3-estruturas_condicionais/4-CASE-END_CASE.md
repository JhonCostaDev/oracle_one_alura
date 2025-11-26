# Tratando o CASE-END CASE

Vamos aprender outra estrutura condicional, o CASE-END CASE.

No vídeo anterior, utilizamos o IF com o qual testamos uma condição. Se ela não é satisfeita, testamos outra condição com o ELSEIF. Se esta também não é satisfeita, podemos testar várias condições, até a condição final, que é o ELSE.

Na condição que criamos na aula anterior, testamos se a pessoa cliente tem mais do que uma linha na tabela de clientes para fazer uma coisa. Caso tiver uma linha só, ela faz outra. E no ELSE que trata qualquer outra situação, ela faz uma terceira coisa.

Nesta aula, vamos entender como substituir essa estrutura por um CASE.

## Utilizando o CASE
Vamos criar um novo script, na qual vamos colar a Procedure que criamos na aula anterior, substituindo a versão pela 9.

```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_9`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_9`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR;
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    IF vNumCliente > 1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
    ELSEIF vNumClient = 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    ELSE
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    END IF
END$$
DELIMITER ;
```
Neste código, temos o trecho abaixo com nosso IF, com o primeiro IF, o ELSEIF e o ELSE, o qual vamos substituir essa estrutura pelo CASE.

```sql
-- Código omitido
    IF vNumCliente > 1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
    ELSEIF vNumClient = 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    ELSE
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    END IF
-- Código omitido
```
## E como funciona o CASE?

Temos a variável vNumCliente, que tem o número de clientes. Acima do bloco IF, vamos colocar CASE e dentro dele, o vNumCliente.

```sql
-- Código omitido
    CASE vNumCliente

    IF vNumCliente > 1 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel pelo nome.';
        SELECT vMensagem;
    ELSEIF vNumClient = 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    ELSE
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    END IF
-- Código omitido
```
Dentro desse bloco, vamos testar as condições. Por exemplo, WHEN 0, THEN, ou seja, se esta variável for igual a 0, vamos escrever a mensagem "Este cliente não pode ser usado para incluir o aluguel porque não existe."

```SQL
-- Código omitido
    CASE vNumCliente
    WHEN 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    
    
-- Código omitido
```
A próxima condição será WHEN 1 THEN. Nela, se vNumCliente for igual a 1, é porque a pessoa cliente é única e podemos usar o SELECT INTO. Portanto, vamos colar as seis linhas de comando do ELSE em seu interior.

```SQL
-- Código omitido
    CASE vNumCliente
    WHEN 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN 1 THEN
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
        
    
-- Código omitido
```
Finalmente, se por acaso nenhuma das condições forem satisfeitas, vamos usar o ELSE, no qual vamos executar a mensagem "Este cliente não pode ser usado para incluir o aluguel porque não existe."

Para terminar o CASE, usamos END CASE na linha seguinte, com ponto e vírgula.

```SQL
-- Código omitido
    CASE vNumCliente
    WHEN 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN 1 THEN
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    ELSE
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    END CASE;
-- Código omitido
```
Após criar esse bloco, podemos apagar o bloco de IF ELSE e ELSEIF, pois não precisamos mais.

O código completou ficou assim, com a mesma lógica.
```sql
USE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_33`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_33`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR;
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE vPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE vNumCliente
    WHEN 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN 1 THEN
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluído na base com sucesso.';
        SELECT vMensagem;
    ELSE
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    END CASE;
END$$
DELIMITER ;
```
Por fim, podemos modificar o número dessa Procedure de 8 para 9.

```sql
SE `insightplaces`;
DROP procedure IF EXISTS `insightplaces`.`novoAluguel_9`;
DELIMITER $$
USE `insightplaces`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_9`
(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio  DATE, vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
-- Código omitido
```

Vamos criar a Procedure 9, selecionando todo o bloco de comandos e executando. Após ver que ela foi criada com sucesso, vamos realizar um "Refresh" na "Stored Procedures" da aba lateral e verificar que a Procedure 9 apareceu.

    # Stored Procedures
    alo_mundo
    dataHora
    listaClientes
    novoAluguel_1
    novoAluguel_2
    novoAluguel_3
    novoAluguel_4
    novoAluguel_5
    novoAluguel_6
    novoAluguel_7
    novoAluguel_8
    novoAluguel_9
    tiposDados
Vamos buscar no script do vídeo anterior a chamada abaixo.
```sql
CALL novoAluguel_33('10007','Victorino Vila','8635','2023-03-30','2023-04-04',40);
```
Vamos colá-la na aba atual, abaixo do comando que acabamos de executar, e modificar seu número para 34.
```sql
CALL novoAluguel_34('10007','Victorino Vila','8635','2023-03-30','2023-04-04',40);
```
Após executar essa chamada para o cliente Victorino Villa, que não existe, veremos a mensagem "Esse cliente não pode ser usado para incluir o aluguel porque não existe.", assim como esperado.

Agora vamos duplicar esse comando, incluindo esse mesmo aluguel para a pessoa cliente Júlia Pires e ver o que vai acontecer.

```sql
CALL novoAluguel_34('10007','Júlia Pires','8635','2023-03-30','2023-04-04',40);
```
Como resposta, veremos a mensagem "Essa pessoa cliente não pode ser usada para incluir o aluguel porque não existe."

Vamos duplicar novamente e criar com a Luana Moura.
```sql
CALL novoAluguel_34('10007','Luana Moura','8635','2023-03-30','2023-04-04',40);
```

Como resposta, teremos a mensagem "Aluguel incluído na base com sucesso."

Vimos nas três últimos aulas o `IF`. O `IF` com `ELSEIF` e o `CASE`.


## Question - Convertendo IF-THEN-ELSE-IF em CASE-END CASE


Analise a stores procedure de gerenciamento de aluguéis abaixo:

```sql
CREATE DEFINER=`root`@`localhost` PROCEDURE `novoAluguel_9`(vAluguel VARCHAR(10), vClienteNome VARCHAR(150), vHospedagem VARCHAR(10), vDataInicio DATE,
vDataFinal DATE, vPrecoUnitario DECIMAL(10,2))
BEGIN
    DECLARE vCliente VARCHAR(10);
    DECLARE vDias INTEGER DEFAULT 0;
    DECLARE vNumCliente INTEGER;
    DECLARE VPrecoTotal DECIMAL(10,2);
    DECLARE vMensagem VARCHAR(100);
    DECLARE EXIT HANDLER FOR 1452
    BEGIN
        SET vMensagem = 'Problema de chave estrangeira associado a alguma entidade da base.';
        SELECT vMensagem;
    END;
    SET vNumCliente = (SELECT COUNT(*) FROM clientes WHERE nome = vClienteNome);
    CASE vNumCliente
    WHEN 0 THEN
        SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
        SELECT vMensagem;
    WHEN 1 THEN
        SET vDias = (SELECT DATEDIFF (vDataFinal, vDataInicio));
        SET vPrecoTotal = vDias * vPrecoUnitario;
        SELECT cliente_id INTO vCliente FROM clientes WHERE nome = vClienteNome;
        INSERT INTO alugueis VALUES (vAluguel, vCliente, vHospedagem, vDataInicio, 
        vDataFinal, vPrecoTotal);
        SET vMensagem = 'Aluguel incluido na base com sucesso.';
        SELECT vMensagem;
    ELSE
       SET vMensagem = 'Este cliente não pode ser usado para incluir o aluguel porque não existe.';
       SELECT vMensagem;
    END CASE;
END
```
Nela substituímos o IF-THEN-ELSE-IF para um CASE-END CASE.

Porém, suponha que temos a seguinte stored procedure que usa IF-THEN-ELSEIF:

```sql
CREATE PROCEDURE ClassificarPedido(vCategoria INT)
BEGIN
    DECLARE vClassificacao VARCHAR(20);
    
    IF vCategoria = 1 THEN
        SET vClassificacao = 'Alimentos';
    ELSEIF vCategoria = 2 THEN
        SET vClassificacao = 'Eletrônicos';
    ELSEIF vCategoria = 3 THEN
        SET vClassificacao = 'Vestuário';
    ELSE
        SET vClassificacao = 'Outros';
    END IF;
    
    SELECT vClassificacao;
END
```
Considerando a necessidade de reescrever a stored procedure ClassificarPedido utilizando a estrutura CASE <VARIAVEL> para realizar a mesma classificação de categorias, qual das seguintes reescrituras é correta?

Selecione uma alternativa

```sql
CASE vCategoria
    WHEN 1, 2, 3 THEN SET vClassificacao = 'Específicos';
    ELSE SET vClassificacao = 'Outros';
END CASE;
```
```sql
CASE vCategoria
    WHEN 1 THEN SET vClassificacao = 'Alimentos';
    WHEN 2 THEN SET vClassificacao = 'Eletrônicos';
    WHEN 3 THEN SET vClassificacao = 'Vestuário';
    ELSE SET vClassificacao = 'Outros';
END CASE;
```
>Esta opção traduz perfeitamente a lógica do IF-THEN-ELSEIF para a estrutura CASE <VARIAVEL>, mantendo a mesma funcionalidade.
```sql
CASE vCategoria
    WHEN 1 THEN SET vClassificacao = 'Alimentos';
    WHEN 2 THEN SET vClassificacao = 'Eletrônicos';
    WHEN 3 THEN SET vClassificacao = 'Vestuário';
END CASE;
```
```sql
CASE vCategoria
    WHEN 'Alimentos' THEN SET vClassificacao = 1;
    WHEN 'Eletrônicos' THEN SET vClassificacao = 2;
    WHEN 'Vestuário' THEN SET vClassificacao = 3;
    ELSE SET vClassificacao = 'Outros';
END CASE;
```
```sql
CASE vCategoria
    WHEN 4 THEN SET vClassificacao = 'Outros';
    ELSE SET vClassificacao = 'Específicos';
END CASE;
```