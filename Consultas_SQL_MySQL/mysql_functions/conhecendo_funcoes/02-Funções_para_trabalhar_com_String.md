# Funções para trabalhar com String

Analisando inconsistências
Vamos abrir uma nova aba para trabalhar com outra tabela em um script vazio.

Desde o início, mencionamos que nossas tabelas estão com dados inconsistentes, ou seja, não padronizados. Isso pode ser comum. Infelizmente, quando trabalhamos com uma base de dados, nem sempre encontramos bases onde os dados estão todos bem organizados.

Vamos executar uma consulta para conferir todos os campos da tabela de clientes e exemplificar melhor quais problemas podemos encontrar.

SELECT * FROM clientes;
Copiar código
cliente_id	nome	cpf	contato
1	João Miguel Sales	65819023730	joão_352@dominiocom
10	Cauã da Mata	16285437955	cauã_723@dominiocom
100	Júlia Pires	19068243551	júlia_388@dominiocom
1000	Srta. Clara Jesus	45781630910	srta_827@dominiocom
10000	Ana Vitória Caldeira	75283146090	ana_322@dominiocom
1001	Luana Moura	25337410635	luana_915@dominiocom
…	…	…	…
Existem inconsistências no campo de nome de cliente. Ao comparar o nome da "Ana Vitória Caldeira" com os demais, observamos que existe um espaço no início do nome da Ana. Isso não vai afetar o resultado em si, mas visualmente não é algo tão interessante.

Além disso, existe outro problema no campo de cpf. Os onze dígitos do número de CPF estão sem nenhum tipo de formatação.

Também temos diversas outras inconsistências que poderiam acontecer, como datas desformatadas e que não seguem o mesmo padrão. Por exemplo, poderia existir um registro onde a data está como dia, mês, ano, mas outro registro onde está como ano, mês, dia.

Isso não vai afetar a informação que precisamos. Porém, o ideal seria que os dados estivessem padronizados para quando fosse preciso utilizá-los para apresentar, montar relatórios e dashboards.

Para isso, no momento de executar as consultas, podemos fazer essa padronização. Além das funções de agregação, temos outros tipos de funções, como as funções de string, que podemos utilizar justamente para trabalhar com cadeias de caracteres.

Vamos conhecer algumas dessas funções ao montar as consultas para trazer informações para a gestão da Insight Places.

Concatenando strings
Vamos montar a primeira consulta que deve nos retornar o nome e o contato de uma pessoa cliente. É uma consulta simples. Basta copiar o SELECT da tabela clientes e substituir o asterisco pelos campos de nome e contato.

SELECT nome, contato FROM clientes;
Copiar código
nome	contato
João Miguel Sales	joão_352@dominio.com
Cauã da Mata	cauã_723@dominio.com
Júlia Pires	júlia_388@dominio.com
…	…
Ao executar, vamos retornar essas duas informações. Mas, podemos deixar esse retorno ainda mais visualmente apresentável. Podemos fazer isso usando uma função que trabalha com string.

Queremos concatenar esses dois campos e retorná-los juntos em um único registro. Para isso, vamos utilizar a função CONCAT().

Com a função CONCAT() é possível fazer a concatenação de dados das strings que passamos como parâmetro.

Entre os parênteses da função, passamos os campos de nome e contato, separando as informações por vírgula.

SELECT CONCAT(nome, contato) FROM clientes;
Copiar código
Além disso, podemos passar para o CONCAT informações que não estão necessariamente dentro da base de dados, como, por exemplo, um texto adicional.

Para exemplificar, vamos acrescentar uma vírgula entre nome e contato, onde acrescentaremos a string O e-mail é: entre aspas simples.

Lembre-se de colocar um espaço no início e no final da string para que o texto fique separado dos outros dados.

SELECT CONCAT(nome, ' O email é: ' , contato) FROM clientes;
Copiar código
CONCAT(nome, ' O email é: ' , contato)
João Miguel Sales O email é: joão_352@dominio.com
Cauã da Mata O email é: cauã_723@dominio.com
Júlia Pires O email é: júlia_388@dominio.com
…
Poderíamos também acrescentar pontuações dentro da string para deixar o retorno ainda melhor formatado.

Removendo espaços desnecessários
Contudo, alguns registros, como o do "João Miguel Sales" e da "Ana Vitória Caldeira", estão com espaço indevidos em seu nome.

Como poderíamos remover esse espaço para deixar o retorno ainda mais interessante?

A função TRIM() remove espaço desnecessários tanto no início quanto no final de uma string.

Dentro do CONCAT(), vamos passar o TRIM e englobar em parênteses apenas o campo nome.

Para melhorar a visualização do retorno, vamos acrescentar um alias NomeContato para o campo concatenado.

SELECT CONCAT(TRIM(nome), ' O email é: ' , contato) NomeContato FROM clientes;
Copiar código
NomeContato
João Miguel Sales O email é: joão_352@dominio.com
Cauã da Mata O email é: cauã_723@dominio.com
Júlia Pires O email é: júlia_388@dominio.com
…
Agora, sim, todos os nomes estão sem nenhum tipo de espaço indevido. Com isso, temos o nome e o e-mail de cada cliente em um único registro de forma bem apresentável.

Padronizando o CPF
Além disso, precisamos resolver o problema de padronização do campo de cpf.

Podemos montar a seguinte consulta para que o número de CPF seja retornado com a pontuação:

SELECT
  CONCAT(SUBSTRING(cpf, 1, 3), '.', SUBSTRING(cpf, 4, 3), '.', SUBSTRING(cpf, 7, 3), '-', SUBSTRING(cpf, 10, 2)) AS CPF_Mascarado
FROM
  clientes;
Copiar código
Estamos fazendo um SELECT para buscar dados da tabela de clientes. Mas, ao selecionar o campo de cpf, estamos usando algumas funções para adaptar o formato do retorno.

Primeiro, usamos a função CONCAT() para concatenar todas as strings. E, dentro desse CONCAT(), passamos uma função chamada SUBSTRING() quatro vezes.

A função SUBSTRING() serve para fazer a extração de uma substring dentro de uma string maior.

Geralmente, um número de CPF possui 11 caracteres e três pontuações, sendo um ponto (.) nas duas primeiras sequências de três caracteres e um traço (-) antes dos dois últimos caracteres.

Por isso, utilizamos quatro funções SUBSTRING(), onde o primeiro parâmetro é o campo de onde queremos extrair a substring, o segundo parâmetro é a posição do caractere de início e o terceiro parâmetro é a quantidade de caracteres a serem extraídos.

Em SUBSTRING(cpf, 1, 3), pedimos para extrair, a partir da primeira posição, três caracteres do CPF. Ou seja, será retornado o 1º, 2º e 3º caractere. Em seguida, concatenamos esse retorno com um ponto.

Em SUBSTRING(cpf, 4, 3), pedimos novamente para extrair, a partir da quarta posição, três caracteres do CPF. Ou seja, será retornado o 4º, 5º e 6º caractere. Depois, fazemos uma concatenação com um ponto.

Em SUBSTRING(cpf, 7, 3), pedimos para extrair, a partir da sétima posição, três caracteres do CPF. Ou seja, será retornado o 7º, 8º e 9º caractere. Dessa vez, fazemos a concatenação com um traço.

Por último, em SUBSTRING(cpf, 10, 2), pedimos para extrair, a partir do décimo caractere, os dois últimos valores.

Fora dos parênteses do CONCAT(), colocamos um alias CPF_Mascarado para o campo concatenado. Podem existir outras formas de fazer essa máscara de CPF, mas optamos por usar o SUBSTRING().

Ao executar, é retornado o CPF mascarado bem formatado:

CPF_Mascarado
658.190.237-30
162.854.379-55
190.682.435-51
457.816.309-10
752.831.460-90
…
Além disso, poderíamos também retornar o nome de cada cliente. Para isso, antes do CONCAT(), adicionamos TRIM(nome) para retornar o nome campo sem espaços desnecessários e o alias Nome.

SELECT
  TRIM(nome) Nome,
  CONCAT(SUBSTRING(cpf, 1, 3), '.', SUBSTRING(cpf, 4, 3), '.', SUBSTRING(cpf, 7, 3), '-', SUBSTRING(cpf, 10, 2)) AS CPF_Mascarado
FROM
  clientes;
Copiar código
Nome	CPF_Mascarado
João Miguel Sales	658.190.237-30
Cauã da Mata	162.854.379-55
Júlia Pires	190.682.435-51
Srta Clara Jesus	457.816.309-10
Ana Vitória Caldeira	752.831.460-90
…	…
Basicamente, estamos fazendo um SELECT para buscar buscando o nome, passando-o para a função TRIM() para remover os espaços. Para criar a máscara no campo cpf, usamos tanto a função CONCAT() para juntar as strings, como também a função SUBSTRING(), que vai buscar pedaços da string dentro de uma string maior. Estamos procurando ambas informações da tabela de clientes.

Próximos passos