# Funções numéricas e condicionais
Arredondando números
Vamos abrir uma nova aba no MySQL Workbench e buscar especificamente nossa consulta que calcula a média das avaliações. Vamos colar essa consulta no script vazio e executá-la.

SELECT AVG(nota) media, tipo
FROM avaliacoes a
JOIN hospedagens h
ON h.hospedagem_id = a.hospedagem_id
GROUP BY tipo;
Copiar código
media	tipo
3.0618	hotel
2.9756	casa
2.9565	apartamento
Como retorno, temos médias compostas por um número inteiro e quatro casas decimais.

No entanto, temos funções na linguagem SQL que nos permitem definir quantas casas decimais queremos apresentar no momento de retornar. Temos funções diferentes que farão esse arredondamento, de acordo com o que desejamos.

A função ROUND() vai arredondar o número de acordo com a quantidade de casas decimais, enquanto a função TRUNCATE() vai truncar o número para um determinado número de casas decimais - mas sem arredondar, vai apenas cortá-lo.

Por exemplo, vamos passar a função TRUNCATE() no SELECT de média de avaliações, onde o primeiro parâmetro será AVG(nota) e o segundo parâmetro será a quantidade de casas decimais. Nesse caso, colocaremos 2.

SELECT TRUNCATE(AVG(nota), 2) media, tipo
FROM avaliacoes a
JOIN hospedagens h
ON h.hospedagem_id = a.hospedagem_id
GROUP BY tipo;
Copiar código
Ao invés de arredondar, o retorno será apenas o 3.06, o 2.97, o 2.95. Em outras palavras, essa função apenas cortou a terceira e quarta casa decimal.

media	tipo
3.06	hotel
2.97	casa
2.95	apartamento
Além do TRUNCATE(), existe outro tipo de função para trabalhar com números e fazer esse arredondamento, que é a função ROUND().

A função ROUND() vai arredondar para um determinado número, ao invés de ignorar os números a partir de certa casa decimal.

Substituiremos TRUNCATE() por ROUND(), mantendo os mesmos parâmetros.

SELECT ROUND(AVG(nota), 2) media, tipo
FROM avaliacoes a
JOIN hospedagens h
ON h.hospedagem_id = a.hospedagem_id
GROUP BY tipo;
Copiar código
media	tipo
3.06	hotel
2.98	casa
2.96	apartamento
Se observarmos os valores originais, notamos que o 3.0618, que é do hotel, foi arredondado para baixo. E os demais, 2.9756 e 2.9565, foram arredondados para cima.

Portanto, temos essas diferenças nas utilizações das funções ao trabalhar com números. Além do ROUND() e TRUNCATE(), temos outras funções ainda que vamos citar em uma atividade para que você possa conhecê-las.

Cada uma deve ser utilizada de acordo com as necessidades. Enquanto uma função serve para lidar números relacionados a valores monetários, outra será usada para cálculos matemáticos e ainda outra para métricas e medidas.

Portanto, precisamos nos atentar a qual tipo de número que vamos utilizar e para qual objetivo. É por isso que temos diversas funções diferentes, às vezes para fazer até a mesma função, como arredondar um valor.

Categorizando avaliações
Além das funções para trabalhar com números, existem as funções condicionais. Elas não se encaixam muito bem em uma determinada categoria, como acontece com a função CASE, que é bem útil para categorizar um grupo de informações.

Vamos agora executar uma consulta, mais uma vez, na nossa tabela de avaliações.

SELECT * FROM avaliacoes;
Copiar código
avaliacao_id	cliente_id	hospedagem_id	nota	comentario
1	1	8450	2	Horrível localização.
10	10	198	2	Horrível atendimento.
100	100	4019	2	Péssima infraestrutura.
1000	1000	5108	3	Maravilhosa serviços.
10000	10000	8802	3	Excelente limpeza.
…	…	…	…	…
A tabela de avaliações possui avaliacao_id, cliente_id, hospedagem_id, nota e também comentario, ou seja, a pessoa pode dar uma nota de 1 a 5 e comentar o que achou da hospedagem.

Internamente, a gestão categorizou as notas da seguinte maneira:

nota 1: ruim;
nota 2: bom;
nota 3: muito bom;
nota 4: ótimo;
nota 5: excelente.
Por isso, nos foi requisitado montar uma consulta que nos retornasse a categorização a partir das notas de cada avaliação.

Podemos fazer isso utilizando o CASE, que é uma função condicional da linguagem SQL, uma vez que queremos categorizar os nossos resultados.

Sabemos que precisamos buscar o ID e a nota da hospedagem, portanto, vamos substituir o asterisco pelos campos hospedagem_id e nota da tabela avaliacoes.

SELECT hospedagem_id, nota FROM avaliacoes;
Copiar código
hospedagem_id	nota
8450	2
198	2
4019	2
5108	3
8802	3
…	…
Foi retornado apenas o ID da hospedagem e a nota dada para aquela hospedagem.

Agora, faremos a categorização desse resultado a partir dessa consulta. Devemos passar diversas condições para o CASE e, de acordo com o resultado, essas notas vão entrar em uma categoria.

Após o SELECT, vamos passar o CASE seguido do campo que será usado para aplicar essa condição, ou seja, campo que será validado. No nosso caso, é o campo de nota.

E aí, para cada uma das condições, vamos informar um WHEN seguido do valor que vamos validar e um THEN seguido da categorização. Nesse caso, quando a nota for 5, ela deve ser categorizada como excelente, por isso, passamos WHEN 5 THEN 'Excelente'.

Faremos o mesmo para as demais notas e explicaremos a estrutura do CASE a seguir:

SELECT hospedagem_id, nota,
CASE nota
        WHEN 5 THEN 'Excelente'
        WHEN 4 THEN 'Ótimo'
        WHEN 3 THEN 'Muito Bom'
        WHEN 2 THEN 'Bom'
        ELSE 'Ruim'
END AS StatusNota
FROM avaliacoes;
Copiar código
Além de buscar hospedagem_id e nota, fazemos o CASE de nota para passar as condições. Assim, sempre que a nota for 5, ela será excelente.

Se não for, ela vai entrar na próxima condição, que é a condição onde vamos validar se ela é igual a 4. Ela é igual a 4? Sim, então é uma ótima nota.

Contudo, se ela não for igual a 4, ela vai passar para o próximo WHEN. Se a nota for igual a 3, ela é muito boa. Se não for, ela vai passar para a 2, que ainda é uma nota boa.

Se não for nenhuma dessas notas, ela é ruim. Como só vai sobrar a nota número 1, ela vai entrar na condição ELSE.

Por últimos, fechamos o CASE com a cláusula END e também definimos o alias StatusNota.

hospedagem_id	nota	StatusNota
8450	2	Bom
198	2	Bom
4019	2	Bom
5108	3	Muito bom
8802	3	Muito bom
…	…	…
Ao executar, teremos a categorização das nossas notas no terceiro campo. Os valores serão as cinco categorias que criamos: excelente, ótimo, muito bom, bom e ruim.

Com isso, criamos uma consulta que traz a categorização feita internamente pelas pessoas que gerenciam a Insight Place.

## Para saber mais


Para saber mais: outras funções numéricas
 Próxima Atividade

No MySQL, além de ROUND() e TRUNCATE(), existem várias funções numéricas importantes que facilitam a manipulação e análise de dados numéricos. A seguir, você encontra algumas das funções numéricas mais cruciais com as suas aplicações de uso:

1 - ABS()

Descrição: Retorna o valor absoluto de um número.
Uso: Útil para remover o sinal de números, transformando valores negativos em positivos. Ideal em cálculos matemáticos onde a distância ou magnitude é importante, independentemente da direção.
SELECT ABS(-123);
Copiar código
2 - CEILING() / CEIL()

Descrição: Arredonda um número para cima, para o menor inteiro maior ou igual ao número.
Uso: Usado quando é necessário arredondar valores para cima em cálculos financeiros, estoque, ou sempre que o arredondamento para baixo não é uma opção.
SELECT CEILING(123.45);
Copiar código
3 - FLOOR()

Descrição: Arredonda um número para baixo, para o maior inteiro menor ou igual ao número.
Uso: Sua utilização possui sentido oposto ao do CEILING(). É útil em situações onde o arredondamento deve ser sempre para baixo.
SELECT FLOOR(123.45);
Copiar código
4 - MOD()

Descrição: Retorna o resto da divisão de um número por outro.
Uso: Essencial em algoritmos que necessitam verificar a divisibilidade, calcular ciclos ou em qualquer contexto onde o resto de uma divisão é necessário.
SELECT MOD(10, 3);
Copiar código
5 - POW() / POWER()

Descrição: Retorna o valor de um número elevado a uma potência especificada.
Uso: Importante para cálculos matemáticos, financeiros e científicos que envolvem exponenciação.
SELECT POW(2, 3);
Copiar código
6 - SQRT()

Descrição: Retorna a raiz quadrada de um número positivo.
Uso: Usado em uma variedade de cálculos científicos e de engenharia, bem como em finanças para determinar a volatilidade dos preços.
SELECT SQRT(16);
Copiar código
7 - RAND()

Descrição: Gera um número aleatório entre 0 e 1.
Uso: Útil para simulações, seleções aleatórias, testes e onde a aleatoriedade é necessária.
SELECT RAND();
Copiar código
8 - SIGN()

Descrição: Retorna o sinal de um número (-1 para negativos, 0 para zero, 1 para positivos).
Uso: Pode ser usado para determinar rapidamente a natureza positiva, negativa ou neutra de valores numéricos em análises financeiras ou matemáticas.
SELECT SIGN(-123);
Copiar código
Cada uma dessas funções numéricas desempenha um papel essencial em diferentes cenários de manipulação de dados, permitindo realizar cálculos complexos, transformações de dados e análises com eficiência e precisão no MySQL. A escolha da função depende do requisito específico do problema que você está tentando resolver.

## Funções

As funções nativas do SQL no MySQL podem ser categorizadas em diferentes grupos, dependendo do tipo de operação que realizam:

Funções de Agregação: Como SUM(), AVG(), COUNT(), MAX(), e MIN(), utilizadas para realizar cálculos em conjuntos de valores e retornar um único valor resumido.
Funções de String: Como CONCAT(), LENGTH(), SUBSTRING(), e UPPER(), que permitem manipular e analisar dados textuais.
Funções Numéricas: incluem ABS(), ROUND(), CEIL(), FLOOR(), e RAND(), entre outras, usadas para realizar operações matemáticas e cálculos.
Funções de Data e Hora: Como NOW(), CURDATE(), DATEDIFF(), e DATE_ADD(), essenciais para manipular e calcular datas e horários.
Funções Condicionais: Como CASE, COALESCE(), que permitem a execução de lógica condicional dentro de consultas SQL.
Funções de Conversão: Como CAST() e CONVERT(), usadas para converter dados de um tipo para outro.
Cada categoria de função oferece ferramentas específicas para lidar com diferentes tipos de dados e requisitos de análise, tornando essencial para desenvolvedores, analistas de dados e administradores de banco de dados conhecer e entender como e quando usar cada tipo de função. O domínio sobre essas funções amplia significativamente as possibilidades de manipulação de dados, permitindo a criação de consultas mais complexas e poderosas, relatórios detalhados e análises profundas diretamente no banco de dados. Práticas que otimizam os processos de tomada de decisão baseados em dados.