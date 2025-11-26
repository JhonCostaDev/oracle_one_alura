# Funções de Agregação

### Renomeando e fechando abas no mysql workbench
Para renomear uma aba no mysql workbench, devemos clicar no botão com ícone de disquete, localizado na barra de ferramentas da aba, para salvar o script. Assim, salvamos em um local do nosso ambiente e renomeamos o primeiro script para AULA 1.

Além disso, fechamos as outras abas que estavam abertas. Para isso, com a aba selecionada, basta clicar no botão "X" para fechá-la. Mas, tenha cuidado! Se você não tiver salvo o script, você irá perder todos os comandos da aba fechada.

## Analisando as tabelas de aluguel e avaliações
Agora, vamos copiar esse comando SELECT * FROM reservas e abrir uma nova aba. Na barra de ferramentas principal do programa, vamos clicar no botão de "Create new SQL" para abrir um novo script, onde vamos colar e executar o comando copiado anteriormente. Para executar, basta clicar no ícone de raio.

```sql
SELECT * FROM reservas;
```
```bash
aluguel_id	cliente_id  hospedagem_id	data_inicio	data_fim	preco_total
1	        1	       8450	        2023-07-15      2023-07-20	3240.00
10	        10	       198	        2022-12-18      2022-12-21	2766.00
100	        100	       4019	        2022-07-26      2022-07-28	452.00
1000	        1000	       5108	        2023-01-25      2023-01-29	3704.00
10000	        1000	       8802	        2023-12-20      2023-12-23	708.00
```
Assim, teremos todas as informações de aluguéis, incluindo o preço total. Mas, além de aluguéis, temos outra tabela que traz uma informação bem interessante.

Na próxima linha, vamos buscar por:

```sql
SELECT * FROM avaliacoes;
```
        avaliacao_id	cliente_id	hospedagem_id	nota	comentario
        1	1	8450	2	Horrível localização.
        10	10	198	2	Horrível atendimento.
        100	100	4019	2	Péssima infraestrutura.
        1000	1000	5108	3	Maravilhosa serviços.
        10000	10000	8802	3	Excelente limpeza.

Ao selecionar apenas essa linha e a executar, notamos que também existe um campo de nota na tabela de avaliações. Portanto, é bem interessante buscar, por exemplo, qual é a média geral das notas que a clientela dá para as hospedagens do nosso catálogo.

Vamos montar agora essas consultas que vão trazer essas informações tão relevantes.

## Calculando a média das notas de avaliações
A primeira consulta que montaremos irá nos retornar a média das notas das avaliações.

Vamos montar a consultar do zero a partir da consulta SELECT * FROM avaliacoes. Porém, ao invés de selecionar todos os campos, queremos apenas a nota. Por isso, substituímos o asterisco pelo campo nota.

```sql
SELECT nota FROM avaliacoes;
```
        # nota
        2
        2
        2
        3
        3

Mas, na realidade, não é exatamente esse valor que queremos. Queremos a média dessas notas.

A função de agregação usada para calcular a média de um campo é a `AVG().`

Depois de SELECT, englobamos nota entre os parênteses de AVG. Assim, o retorno será a média do campo nota.

```sql
SELECT AVG(nota) FROM avaliacoes;
```

        AVG(nota)
        2.9989

Após executar, temos como retorno a média geral de todas as notas, que é 2.9989.

## Agrupando a média pelo tipo de hospedagem
Porém, existe uma ligação da tabela de avaliações com outras duas tabelas: cliente e hospedagem. Para ter uma informação mais relevante, seria interessante categorizar esse retorno, ou seja, agrupar a média pelo tipo de hospedagem.

Primeiro, vamos validar a tabela de hospedagem com a seguinte consulta:

```sql
SELECT * FROM hospedagens;
```

        hospedagem_id	tipo	endereco_id	proprietario_id	ativo
        1	casa	1	1	0
        10	apartamento	10	10	0
        100	hotel	100	100	0
        1000	casa	1000	1000	1
        10000	casa	10000	10000	    
…	…	…	…	…
Existem três tipos nessa tabela: casa, apartamento e hotel.

Para categorizar por esses tipos, podemos usar outro recurso da linguagem SQL no MySQL, que é o JOIN.

Com a função JOIN conseguimos juntar informações que estão em duas ou mais tabelas.

A partir da consulta onde calculamos a média do campo nota, vamos adicionar um alias (apelido) para a tabela de avaliações. Para isso, após FROM avaliacoes, acrescentamos a letra a.

Em seguida, vamos usar o JOIN para juntá-la com a tabela hospedagens que terá o alias h.

Além disso, precisamos ter um campo em comum entre as duas tabelas. Já sabemos que esse campo existe e se chama hospedagem_id em ambas as tabelas.

Então, digitaremos a cláusula ON e informamos que h.hospedagem_id deve ser igual a a.hospedagem_id. Lembre-se que devemos usar o alias para identificar a tabela a qual aquele campo pertence antes do campo.

```sql
SELECT AVG(nota)
FROM avaliacoes a
JOIN hospedagens h
ON h.hospedagem_id = a.hospedagem_id;
```
Nessa consulta, estamos buscando a média das notas na tabela de avaliações. Porém, também estamos juntando essa tabela com a tabela de hospedagem, retornando informações onde o hospedagem_id de hospedagem seja igual ao hospedagem_id de avaliações.

Em SELECT, após a média das notas, também vamos informar o campo tipo. Afinal, queremos justamente que essa categorização seja feita por este campo.

E, claro, vamos acrescentar ao final o GROUP BY para agregar esses valores por um determinado campo. Nesse caso, vamos agrupar o retorno da consulta pelo tipo.

Por fim, vamos dar um alias media para o campo AVG(nota) para melhorar a leitura da tabela.
```sql
SELECT AVG(nota) media, tipo
FROM avaliacoes a
JOIN hospedagens h
ON h.hospedagem_id = a.hospedagem_id
GROUP BY tipo;
```
        media	tipo
        3.0618	hotel
        2.9756	casa
        2.9565	apartamento
Agora temos a média pelo tipo de hospedagem. Temos uma média de avaliação de 3.0618 para hotel, 2.9756 para casa e 2.9565 para apartamento.

É uma informação bem relevante, por isso, vamos deixar essa consulta guardada.

## Calculando soma, maior e menor valor de aluguel
Agora, vamos pegar como base o SELECT de aluguéis para realizar outra consulta e trazer outras informações. Queremos identificar qual foi a soma total, o maior valor pago e também o menor valor.

Primeiro, vamos usar a função de agregação SUM(), que faz a soma, informando o campo preco_total. Depois, acrescentamos o FROM e a tabela alugueis sem acento.

E aí, podemos continuar acrescentando outras funções de agregação. Após SUM(preco_total), colocamos uma vírgula e passamos MAX(preco_total) para calcular o maior valor e MIN(preco_total) que é o menor valor.

Para melhorar a visualização, podemos adicionar aliases para cada campo, respectivamente, como ValorTotal, MaiorValor e MenorValor.
```sql
SELECT SUM(preco_total) ValorTotal, MAX(preco_total) MaiorValor, MIN(preco_total) MenorValor FROM alugueis;
```
    ValorTotal	MaiorValor	MenorValor
    22074692.00	7000.00	102.00
Como retorno, temos a soma total dos valores, além do maior e menor valor desse campo.

É possível deixar essa consulta ainda mais interessante. Que tal fazermos algo que fizemos na nossa consulta anterior, quando buscamos a média das avaliações por tipo?

Na tabela de aluguéis, também temos o campo de hospedagem_id. Então, podemos copiar o trecho do JOIN ao GROUP BY que utilizamos para buscar a média de avaliações e colar ao final da nova consulta.

Em FROM alugueis, vamos retirar o ponto e vírgula e acrescentar o alias a. Como o campo também se chama hospedagem_id em abas a tabela, podemos manter a mesma cláusula ON.

Por último, vamos acrescentar o campo tipo no SELECT.

```sql
SELECT tipo, SUM(preco_total) ValorTotal, MAX(preco_total) MaiorValor, MIN(preco_total) MenorValor
FROM alugueis a
JOIN hospedagens h
ON h.hospedagem_id = a.hospedagem_id
GROUP BY tipo;
```
tipo	ValorTotal	MaiorValor	MenorValor
hotel	7570312.00	7000.00	106.00
casa	7304341.00	7000.00	102.00
apartamento	7200039.00	6986.00	110.00
Ao executar, temos o valor total, o maior valor e o menor valor categorizados por tipo.

Podemos notar até que o valor total para hotel, casa e apartamento não varia muito. É uma informação bem interessante, principalmente para a gestão identificar qual é o tipo de hospedagem que é mais rentável e procurado pela clientela.