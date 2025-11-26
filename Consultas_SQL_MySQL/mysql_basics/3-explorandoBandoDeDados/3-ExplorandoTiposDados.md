# Conhecendo os tipos de dados
NoMySQL Workbench, se passarmos o mouse sobre o nome de uma tabela, na coluna "Navegador", à esquerda, aparece alguns botões à direita do nome: um "i", uma chave de ferramenta e uma tabela. Se clicarmos no "i", abrimos uma aba chamada "insight_places.nomeDaTabela", onde aparecem as informações sobre o nome da tabela que selecionamos. Por exemplo, vamos na tabela "alugueis".



Abrimos a aba "insight_places.alugueis". Na parte superior da aba com essas informações, temos outras abas: "Info", "Columns", "Indexes", "Triggers", "Foreign Keys", "Partitions", "Grants" e "DDL". Ou seja, todas as informações dessa tabela. Clicaremos na opção "Columns" (Colunas) para analisar os tipos de dados de cada coluna.

      Column	Type	(…)
      aluguel_id	varchar(255)	(…)
      cliente_id	varchar(255)	(…)
      hospedagem_id	varchar(255)	(…)
      data_inicio	date	(…)
      data_fim	date	(…)
      preco_total	decimal(10,2)	(…)

Nessa aba temos acesso ao nome de cada coluna e ao seu tipo de dado. Na coluna aluguel_id, temos o tipo varchar, assim como nas colunas cliente_id e hospedagem_id. O tipo de dado varchar, que é do tipo texto, armazena caracteres de comprimento variável, ou seja, nome, endereço e mais informações que não têm um tamanho determinado.

Conseguimos definir um valor máximo de caracteres que ele pode armazenar, por exemplo, usamos 255, mas o benefício dele é que ele não ocupa esse espaço máximo que determinamos na memória no banco de dados. Ele vai utilizar apenas o que for armazenado naquele registro em questão. Por isso que ele tem esse comprimento variável, e é bastante utilizado nos SGBDs, em geral, e no MySQL também.

Alguns dos benefícios de usar varchar são a economia de espaço, porque, como mencionado, ele só vai realmente precisar do espaço que aqueles caracteres preenchidos, e o desempenho, porque por ele economizar esse espaço. Por ele não precisar armazenar um espaço que não está sendo usado, ele consegue fazer o banco de dados desempenhar melhor.

Na coluna data_inicio e data_fim, temos o tipo date. O tipo date é usado para quando queremos armazenar informações de data sem precisão de hora, apenas o dia. Ele é eficiente para quando queremos armazenar dados para apenas ver o intervalo de dias, como reservas, ou apenas para trazer informações de um dia específico. Ele é interessante porque usa pouco espaço para armazenamento, e conseguimos fazer a identificação por dia dos dados que estão na nossa tabela.

Temos também a última coluna da tabela de aluguéis, que é a de preco_total, que tem o tipo decimal, ou seja, é um tipo de valor numérico. Entre parênteses, temos dois números: (10,2). Isso significa que o primeiro número da frente do valor pode ter até 10 dígitos, e depois da vírgula, deixamos ter até dois dígitos, que seriam os centavos.

Nesse caso, como se trata de um valor em reais, podemos delimitar que só se tem duas casas depois da vírgula, porque são centavos. Antes da vírgula, trazemos até 10 casas decimais, que são valores que podem ir até 1 milhão de reais, por exemplo.

Claro que nenhuma reserva vai ter esse valor, mas determinamos um limite máximo. Por isso, esse tipo decimal é bastante utilizado quando se trata de valores financeiros, que conseguimos determinar quantas casas vamos utilizar no número decimal.

Analisando os dados das outras tabelas
Agora, vamos analisar também a tabela de avaliações. Passando o mouse sobre o nome da tabela e clicando no "i", abriremos as informações dessa tabela em uma nova aba. Clicaremos novamente na "sub-aba" de colunas ("Columns") na parte superior da aba. As três primeiras colunas dessa tabela também são do tipo varchar. A quarta coluna, que é a coluna nota, temos uma coluna de int.

      Column	Type	(…)
      avaliacao_id	varchar(255)	(…)
      cliente_id	varchar(255)	(…)
      hospedagem_id	varchar(255)	(…)
      nota	int	(…)
      comentario	text	(…)

O tipo int é um tipo numérico que, na verdade, é a abreviação de interger (inteiro). Ele armazena números inteiros. É ótimo para armazenar dados que precisam ser contados em um grande intervalo numérico, porque ele tem um limite bem grande. Apesar de ser um tipo de dado que exige algum espaço, não exige um espaço tão grande que atrapalhe o desempenho.

É um tipo bem utilizado nas chaves primárias, por exemplo, ou para contar algum tipo de registro que tem na nossa tabela. Nesse caso, nessa tabela ele está sendo usado na coluna nota para dar uma avaliação para os imóveis registrados.

Por fim, temos a coluna comentario, que é do tipo text, ou seja, texto. Ela é uma coluna do tipo string. O tipo text armazena textos de tamanhos variados, que não têm um limite de caracteres. É exatamente o que precisamos nessa coluna, porque, como é um comentário de alguma pessoa, e não sabemos o que a pessoa vai escrever, não tem um limite de máximo ou mínimo de linhas. É apenas um texto, ou seja, string.

Agora vamos conferir os tipos da tabela "clientes", seguindo os mesmos passos de antes e abrindo a aba "Columns". Nesse caso, todas as colunas da tabela de clientes do tipo varchar. Como mencionado anteriormente, varchar é um tipo de dado bastante usado, por essa flexibilidade no tamanho do comprimento dos registros e de armazenamento.

Na tabela "endereços", temos a maioria das colunas também do tipo varchar e uma do tipo int, que é a coluna numero, representando o número da casa. Analisando a tabela "hospedagens", temos a maioria das colunas também em varchar, mas a última coluna, a ativo, é do tipo tinyint (tiny int).

O tinyint é usado para armazenar dados binários, ou seja, que é uma coisa ou outra. Usamos para preencher 0 e 1. Representa informações como "ligado" e "desligado" ou, nesse caso, "ativo" e "inativo". Poderia representar também algo como "pendente" e "processando", se fosse o caso de pedidos.

Ele é como se fosse "sim" ou "não", para preenchermos uma informação ou outra. Ele não ocupa praticamente quase nada de armazenamento e é bem simples entender o que quer dizer nessa coluna, porque, no caso, é a coluna de ativo. Então, se a coluna estiver com o número 1, quer dizer que esse imóvel está ativo, e se estiver com o número 0, quer dizer que está inativo.

Assim, ao invés de colocarmos uma coluna de texto, que teríamos que preencher "sim" ou "não", só colocamos essa coluna do tipo tinyint e preenchemos com 0 ou 1, e já saberemos identificar esses dados. É uma ótima escolha para esse tipo de informação, que tem duas opções.

Agora vamos para a tabela de proprietários, que é a última. Ela também tem todas as colunas do tipo varchar, que é o tipo texto.

Após entendermos o tipo de dado de cada coluna, estamos prontos para começar a explorar esses dados, trazendo consultas com resultados interessantes para a empresa. Podemos mostrar informações que serão muito relevantes para ela tomar decisões e ter estratégias de marketing e estratégias com a plataforma.
