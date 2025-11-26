# Incluindo clientes em uma tabela temporária

A automação para incluir o identificador do aluguel trouxe um novo desafio para a Insight Place: agora precisamos lidar com a hospedagem de múltiplas pessoas em um mesmo aluguel. Até então, cada aluguel estava vinculado a um único cliente, devido à limitação da tabela de aluguéis na base de dados, que suportava apenas um cliente por ID de aluguel.

### Desafio da Hospedagem Múltipla
No entanto, surgem situações em que é necessário registrar a hospedagem de várias pessoas, como uma família de quatro membros (pai, mãe e dois filhos).

### Estratégia de Inserção
Como não podemos alterar a estrutura da base de dados, a Insight Place decidiu que, nesses casos, como o da família de quatro pessoas, serão inseridas quatro linhas na tabela de aluguéis. Isso implica em ter identificadores de aluguel diferentes, já que são chaves primárias únicas.

Além disso, os nomes dos clientes serão distintos, mas dentro da tabela, utilizaremos os identificadores para referenciar os clientes e não seus nomes. No entanto, os dados sobre o local de hospedagem, as datas de início e término, e o valor a ser pago permanecerão os mesmos e serão repetidos nessas quatro entradas.

Entendemos como registrar vários clientes na tabela de aluguéis. Agora surge a questão: como fornecer essa lista de clientes para a Stored Procedure? Afinal, a Stored Procedure recebe apenas um nome como parâmetro, uma string.

Para resolver esse problema, vamos adotar esta estratégia: a lista de clientes será fornecida como um array, com os nomes separados por vírgulas, e esses nomes serão gravados em uma tabela temporária.

Uma tabela temporária em SQL é do tipo que permanece ativa durante a sessão ou conexão. Ao encerrar essa conexão, a tabela é automaticamente apagada.

A tabela temporária é específica para cada sessão e pessoa usuária. No MySQL Workbench, como estamos sempre conectados e com a sessão aberta, precisaremos apagar e criar a tabela temporária toda vez que quisermos testar o novo procedimento da Insight Place.

No entanto, na prática, quando a aplicação chamar a Stored Procedure para incluir aluguéis, uma nova conexão será estabelecida e uma nova sessão será aberta no banco de dados, o que resultará na exclusão automática da tabela temporária.

Primeiro, vamos entender como inserir informações em uma tabela temporária baseada em uma string com nomes separados por vírgulas. Mostraremos alguns slides com pseudo código e exemplos em MySQL para demonstrar como faremos isso.

No slide, temos a lista de clientes no topo que precisamos inserir na tabela temporária, e à direita está a representação dessa tabela com um campo chamado X.

     LISTA='JOÃO,MARIA,PEDRO,LUIS'


O que precisamos fazer? Primeiramente, associamos a lista atual a uma variável chamada RESTANTE.

     SET RESTANTE = LISTA;

Essa variável `RESTANTE` será gradualmente reduzida à medida que os nomes são inseridos na tabela, removendo esses nomes do string chamado RESTANTE.

Para fazer isso, utilizaremos um loop que continuará removendo os nomes até que não haja mais nomes a serem inseridos. Uma forma de determinar quando o looping deve parar é verificar se ainda há vírgulas no string restante, indicando que ainda há nomes a serem processados.

```sql
SET RESTANTE = LISTA;
WHILE INSTR(RESTANTE,',') > 0 DO
END WHILE;
```

Estamos utilizando a função INSTR. Se o resultado de INSTR aplicado à variável RESTANTE, com a vírgula como parâmetro, for maior que zero, significa que ainda há clientes a serem incluídos na tabela.

```sql
LISTA='JOÃO,MARIA,PEDRO,LUIS' 
RESTANTE = 'JOÃO,MARIA,PEDRO,LUIS' 
INSTR(RESTANTE,',') = 5
```

Vamos imaginar que estamos percorrendo este trecho de código e o resultado do INSTR aplicado a RESTANTE é 5. Por quê? Porque a primeira vírgula que encontramos está na quinta posição da string restante: JOÃO,. Assim, o valor retornado pelo INSTR para a vírgula é maior que zero e entramos no looping.

```sql
SET RESTANTE = LISTA;

WHILE INSTR(RESTANTE,',') > 0 DO
     SET POS = INSTR(RESTANTE,',');
END WHILE;
```

A próxima etapa é utilizar novamente a função INSTR para armazenar na variável POS (que representa a posição) o valor correspondente à posição da primeira vírgula. Nesse caso é a vírgula após o nome João, onde estamos iniciando o looping, e já temos a posição da primeira vírgula, que é exibida como o número 5 na variável POS:

```sql
LISTA='JOÃO,MARIA,PEDRO,LUIS'
 RESTANTE = 'JOÃO,MARIA,PEDRO,LUIS'
 INSTR(RESTANTE,',') = 5
POS = 5
```

Agora, vamos atribuir o valor do primeiro nome à variável NOME:
```
LISTA='JOÃO,MARIA,PEDRO,LUIS'
RESTANTE = 'JOÃO,MARIA,PEDRO,LUIS'
INSTR(RESTANTE,',') = 5
POS = 5 
NOME = 'JOÃO'
Copiar código
SET RESTANTE = LISTA; 
WHILE INSTR(RESTANTE,',') > 0 DO
     SET POS = INSTR(RESTANTE,','); 
     SET NOME = LEFT(RESTANTE, POS-1);
END WHILE;
```

Estamos utilizando a função LEFT() para isso, que busca a parte esquerda do texto até a posição da vírgula (que é 5 neste caso) menos 1. Por quê? Porque não desejamos incluir a vírgula na tabela temporária. Assim, ao aplicar LEFT(), obtemos a parte do texto da posição 5 menos 1 (ou seja, 4), que é POS menos 1, resultando em "João". Esse nome é armazenado na variável NOME.

Agora que temos "João" na variável NOME, precisamos inseri-lo na tabela temporária usando o comando INSERT.

```sql
 SET RESTANTE = LISTA;
 
 WHILE INSTR(RESTANTE,',') > 0 DO
     SET POS = INSTR(RESTANTE,','); 
     SET NOME = LEFT(RESTANTE, POS-1);
     INSERT INTO TABELA VALUE (NOME);
 END WHILE;
```

Assim, obtemos na tabela temporária:



Antes de prosseguirmos com o looping, precisamos remover esse nome "João" da variável RESTANTE, incluindo a vírgula. Para isso, usamos a função SUBSTRING() para retirar "João" da variável RESTANTE.

```sql
 SET RESTANTE = LISTA; 
 WHILE INSTR(RESTANTE,',') > 0 DO 
        SET POS = INSTR(RESTANTE,','); 
        SET NOME = LEFT(RESTANTE, POS-1);
        INSERT INTO TABELA VALUE (NOME);
        RESTANTE = SUBSTRING(RESTANTE, POS + 1);
  END WHILE;
```

Agora vamos criar um looping para adicionar o nome "Maria". Vamos abordar este segundo looping, para entender como ele vai funcionar.

```sql
LISTA='JOÃO,MARIA,PEDRO,LUIS'
RESTANTE = 'MARIA,PEDRO,LUIS'
INSTR(RESTANTE,',') = 6
POS = 5
NOME = 'JOÃO'
```

Primeiro, vamos testar o INSTR(), que agora está em 6. Se analisarmos em RESTANTE = 'MARIA,PEDRO,LUIS', a próxima vírgula está na posição 6 da variável RESTANTE.

Como 6 é maior que zero, entraremos no looping. Então, definimos o valor 6 para a variável POS (comando SET POS = INSTR(RESTANTE,',')). Buscamos o nome (SET NOME = LEFT(RESTANTE, POS-1)), então vamos inserir "Maria" na tabela (INSERT INTO TABELA VALUE (NOME)) e depois removê-lo da variável RESTANTE (RESTANTE = SUBSTRING(RESTANTE, POS + 1)).

```sql
JOÃO
MARIA
LISTA='JOÃO,MARIA,PEDRO,LUIS'
RESTANTE = 'PEDRO,LUIS'
INSTR(RESTANTE,',') = 6
POS = 6
NOME = 'MARIA'
```
Agora, a variável RESTANTE terá apenas "Pedro" e "Luis". Se voltarmos à condição do looping, o looping será executado novamente. Desta vez, vamos adicionar "Pedro" à tabela e agora a variável RESTANTE não tem mais vírgulas, mas tem o nome "Luis".


```sql
LISTA='JOÃO,MARIA,PEDRO,LUIS' 
RESTANTE = 'LUIS'
INSTR(RESTANTE,',') = 0
POS = 6
NOME = 'PEDRO'
```
Tabela:

```
x
JOÃO
MARIA
PEDRO
```

Portanto, ao verificar se há vírgulas na variável RESTANTE, esse valor retornará zero, indicando que precisamos sair do looping.

Ao encerrar o looping, percebemos que ainda há um nome remanescente, o nome "Luis". Então, o que precisamos fazer no final? Precisamos verificar se a variável RESTANTE ainda tem valor e, se sim, inserir esse valor na tabela.

```sql
SET RESTANTE = LISTA;
WHILE INSTR(RESTANTE,',') > 0 DO
        SET POS = INSTR(RESTANTE,',');
        SET NOME = LEFT(RESTANTE, POS-1);
        INSERT INTO TABELA VALUE (NOME);
        RESTANTE = SUBSTRING(RESTANTE, POS + 1);
END WHILE;

IF TRIM(RESTANTE) <> `´ THEN

     INSERT INTO TABELA VALUE (TRIM(RESTANTE));

END IF
```
Tabela:
```
x
JOÃO
MARIA
PEDRO
LUIS
```

Assim, ao final deste código que apresentamos, os nomes originalmente na variável LISTA, separados por vírgulas, estarão na tabela temporária.

## Conclusão e Próximos Passos
Procederemos da seguinte forma: encerraremos o vídeo aqui e, no próximo vídeo, vamos criar uma Stored Procedure para realizar todas as etapas que mostramos neste slide. Em seguida, testaremos para confirmar se conseguimos de fato gravar os nomes de uma string separados por vírgulas em uma tabela.

Até o próximo vídeo!

# question - Lógica de inclusão de múltiplos clientes em aluguéis


Para acomodar a necessidade de registrar aluguéis para múltiplos clientes sem alterar a estrutura da base de dados, a `InsightPlaces` decide inserir múltiplas linhas na tabela de aluguéis, uma para cada cliente, utilizando uma stored procedure. Esta abordagem envolve o uso de uma lista de nomes de clientes fornecida como um ARRAY separado por vírgulas e a inserção desses nomes em uma tabela temporária.

Considerando a abordagem descrita para gerenciar aluguéis de múltiplos clientes na InsightPlaces, qual método é utilizado para processar e inserir os nomes dos clientes na tabela temporária dentro da stored procedure?

Selecione uma alternativa

- ( ) Converter a lista de nomes de clientes em um JSON e realizar a inserção utilizando funções de manipulação de JSON.


- ( ) Empregar expressões regulares para identificar e inserir todos os nomes de uma só vez na tabela temporária.


- ( ) Utilizar um LOOPING para extrair e inserir cada nome da lista, baseando-se na presença de vírgulas como delimitadores.


- ( ) Dividir a lista de clientes usando a função SPLIT_STRING e inserir cada nome diretamente na tabela temporária.


- ( ) Utilizar uma função agregada para contar os nomes na lista e inserir um registro único para todos os clientes.

