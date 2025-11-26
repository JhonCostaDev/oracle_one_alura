 # Primeira visão dos dados
 Vamos fazer um **SELECT** simples nessas tabelas, só para explorar e ver do que se trata esses dados da Insight Places.

Se formos na lateral esquerda, em esquemas, e clicar ao lado do nome insight_places, teremos a opção de analisar as tabelas. Clicamos ali ao lado de Tables, e teremos todas as tabelas que estão nesse banco de dados.

Vamos dar um SELECT na primeira tabela, que é a tabela de aluguéis nessa tabela para entender quais são as informações que estão contidas nela, como que vamos poder trabalhar com ela mais para frente.

Vamos na nossa aba de consulta, na parte central, e vamos escrever o seguinte código:
```sql
SELECT * FROM alugueis;
```
Vamos executar, e logo abaixo, o MySQL traz para nós todos os dados da tabela. Então, claro que não precisamos analisar linha por linha, mas é importante que entendamos quais são os dados a que teremos acesso nessa tabela de aluguel.

    aluguel_id	cliente_id	hospedagem_id	data_inicio	data_fim	preco_total
        1	          1	          8450	    2023-07-15	2023-07-20	3240.00
Temos aqui o ID da tabela de aluguel, que vai identificar cada registro dessa tabela, e tem também duas outras colunas de ID, que são a de cliente_id e de hospedagem_id, que são uma chave estrangeira dessas tabelas de cliente e hospedagem.

Ou seja, essa tabela de aluguel se liga pela coluna de ID com a tabela de cliente e com a tabela de hospedagem. Então, é interessante termos essa informação para quando formos criar nossas consultas, e sabermos como podemos relacionar registros dessa tabela com outras tabelas.

Além disso, temos colunas para data de início, data de fim e preço total. Então, essa tabela de aluguéis armazena os registros de reservas feitos na plataforma. Quando a pessoa reservou, a data que ela vai começar a usar aquela hospedagem, a data que ela vai sair daquela hospedagem e o valor que ela pagou. É interessante entendermos isso.

Vamos fazer agora o SELECT na nossa segunda tabela.
```sql
SELECT * avaliacoes;
```

Vamos executar. E logo abaixo, temos acesso às colunas.

  avaliacao_id	cliente_id	hospedagem_id	nota	comentario
      1	              1	        8450	      2	  Agradável atendimento.

Temos a coluna avaliacao_id, para marcar cada registro dessa tabela como único. Temos também colunas de cliente_id e de hospedagem_id, para identificar a qual o cliente e a qual a hospedagem esses registros estão ligados.

Temos também uma coluna de nota, que é a nota que o cliente vai dar por cada hospedagem, e comentário. Então, o cliente vai deixar também na plataforma um comentário, falando um pouco de como foi a experiência dele naquela hospedagem, e temos aqui essa nota.

Então, quando precisamos saber de qual hospedagem se trata esse comentário e essa nota, vamos, através do ID de hospedagem, que é uma chave estrangeira também nessa tabela, ter acesso na tabela de hospedagem aos detalhes.

Vamos olhar a tabela de clientes agora

``` sql
SELECT * clientes;
```
    cliente_id	nome	            cpf	                  contato
      1	     João Miguel Sales	658.190.237-30	joão_352@dominio.com

Essa tabela é básica, com o nome dos clientes, o CPF e o contato, que no caso é o e-mail de cada cliente. A tabela começa com a coluna de cliente_id, para conseguirmos identificar cada cliente como único pelo ID, e também poder ligar outras tabelas, como vimos já que essa coluna de cliente_id está presente na tabela de aluguéis, na tabela de avaliações. Assim, podemos identificar cada cliente que fez um comentário, uma nota, fez uma reserva, enfim, tudo documentado.

Agora, a nossa quarta tabela é a tabela de endereços. Inclusive, foi a tabela em que inserimos os dados no vídeo anterior. E agora vamos analisar esses dados.

```sql
SELECT * enderecos;
```
    endereco_id	rua	n           numero	bairro	cidade	estado	cep
        1	      Lagoa de Teixeira	72	Tirol	     Moraes	SP	87362-365
..	..	..	..	..	..	...

A tabela começa com o endereco_id depois tem a rua, o número, o bairro, cidade, estado, CEP. Então, aqui temos todos os endereços das nossas hospedagens, dos imóveis disponíveis para alocação.

Vamos dar uma olhada, então, na tabela de hospedagens.

SELECT * hospedagens;
Copiar código
hospedagem_id	tipo	endereco_id	proprietario_id	ativo
1	casa	1	1	0
Nesta tabela temos a coluna de hospedagem_id, o tipo. Então, se é uma casa, se é um apartamento, se é um hotel. O endereco_id, que é uma chave estrangeira dessa tabela de endereço que acabamos de analisar.

Então, aqui conseguimos entender, por exemplo, essa hospedagem de ID 1, que é uma casa, qual que é o endereço dela. Então, o endereco_id dela é 1, aí vamos na tabela de endereços, o ID que for 1, temos acesso ao endereço dessa hospedagem.

Tem também uma chave estrangeira da tabela de proprietários, que é o proprietario_id. Assim conseguimos também, pelo ID, saber qual é o proprietário e as informações do proprietário de cada uma dessas hospedagens.

Temos também, nessa tabela de hospedagens, uma coluna de ativo. Isso quer dizer se a hospedagem está ativa no site, na plataforma naquele momento ou não. Então, tem pessoas, empresas que cadastram as hospedagens na plataforma da Insight Places, mas, por um motivo ou outro, elas precisam bloquear um tempo dessa hospedagem estar disponível para reserva, e ela fica inativa.

Então, é uma informação interessante também de termos acesso para saber quais hospedagens estão disponíveis no momento, na plataforma, e quais não estão, e entender um pouco mais do motivo.

Depois dessa tabela de hospedagens, vamos para a nossa última tabela, que é a de proprietários.

SELECT * proprietarios;
Copiar código
proprietario_id	nome	cpf_cnpj	contato
1	Luna Fernandes	408.153.796-84	luna_537@dominio.com
Começamos também com uma coluna de ID, que é proprietario_id, seguida pro uma coluna com o nome de cada proprietário, depois tem cpf_cnpj, ou seja, pode ser um proprietário tanto pessoa física quanto pessoa jurídica, porque nessa plataforma da Insight Places tem pessoas que têm casas ou algum imóvel que querem cadastrar para deixar disponível para alocação, mas também tem hotéis, tem empresas que também cadastram as suas hospedagens nessa plataforma.

Então, pode tanto ser uma pessoa física quanto uma pessoa jurídica que cadastra imóveis na Insight Places. Em seguida, temos também o contato, que é um e-mail de cada uma dessas pessoas, desses proprietários.

Conclusão
Agora que já entendemos um pouco como estão localizadas as informações em cada tabela, entendemos um pouco do negócio, um pouco de cada dado, para podermos fazer futuras análises que tenham sentido e que tragam informações relevantes para a Insight Places.

Outra coisa importante para conseguirmos trabalhar com esses dados é entender cada tipo de cada dado dessas colunas. Quais dados são dados de valor numérico, quais dados são de tipo texto, etc.

Porque, dependendo do tipo de cada dado, vamos ter uma maneira diferente de trabalhar nas consultas com eles. Então, é super importante analisarmos isso também.
