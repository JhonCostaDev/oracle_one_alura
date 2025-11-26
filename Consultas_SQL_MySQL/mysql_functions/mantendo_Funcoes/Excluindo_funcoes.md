# Excluíndo funções
Riscos e Consequências da Remoção Incorreta de Funções
Excluir uma função de maneira inadequada, especialmente se for amplamente utilizada por pessoas colaboradoras ou por outros recursos como procedimentos, visualizações (views) ou qualquer elemento que a utilize, pode causar uma série de falhas e problemas no banco de dados.

Além disso, modificar a lógica interna de uma função de forma incorreta, resultando em erros ou em uma função que não retorna nada (como quando retorna nulo mesmo com um valor fornecido), pode gerar complicações adicionais.

Isso ocorre porque, ao fazer isso e ter outros procedimentos que utilizam essa função, teremos problemas se excluirmos a função que está sendo utilizada em outros locais. Consequentemente, a inexistência dessa função vai gerar problemas, pois ela não será encontrada ao ser chamada.

Portanto, precisamos ter muito cuidado ao realizar a manutenção em funções. É importante validar se a modificação é correta ou se realmente precisamos excluir aquela função, verificando se ela não está sendo utilizada em nenhum local do nosso banco de dados, por nenhuma outra função ou procedimento.

Quando trabalhamos com banco de dados, temos a parte do back-end, front-end e as linguagens de programação que vão utilizar consultas e até funções para buscar dados na nossa base de dados. Precisamos ter esses cuidados para prevenir possíveis erros, falhas e problemas.

Exclusão e Impacto da Função CalcularValorFinalComDesconto
Vamos supor que agora excluiremos a função CalcularValorFinalComDesconto. Para fazer isso, executaremos o comando de exclusão da função, que é DROP FUNCTION IF EXISTS CalcularValorFinalComDesconto;.

DROP FUNCTION IF EXISTS CalcularValorFinalComDesconto;
Copiar código
Depois de excluída, ao tentarmos usar essa função em um select, receberemos um erro indicando que a função não está mais disponível.

SELECT CalcularValorFinalComDesconto(0);
Copiar código
Executamos o comando select e obtemos:

ErrorCode: 1305. FUNCTION insightplaces CalcularValorFinalComDesconto does not exist

Sabemos que a função é chamada dentro da trigger. Então, vamos inserir um novo valor na tabela alugueis. Na aba "SQL File", inserimos o seguinte comando:

INSERT INTO alugueis (alugel_id, cliente_id, hospedagem_id, data_inicio, data_fim, preco_total)
VALUES (10002, 35, 20, '2024-01-09', '2024-01-12', 2000.00);
Copiar código
Estamos inserindo em alugueis um novo alugel_id, cliente_id, hospedagem_id, data_inicio, data_fim, preco_total. Selecionamos o comando e executamos para inserir essas informações. Ao analisarmos no retorno, conseguimos inserir sem nenhum erro.

Clicamos na aba "Criando a trigger AtualizarResumo".

Ao validar a nossa tabela resumo_aluguel executando SELECT * FROM resumo_aluguel;, temos a inserção dos valores:

aluguel_id	cliente_id	valortotal	descontoplicado	valorfinal
10001	42	3000.00	10.00	2700.00
10002	35	2000.00	0.00	NULL
NULL	NULL	NULL	NULL	NULL
No entanto, observamos que o desconto aplicado e o valor final não foram inseridos. Isso ocorre porque a função que calcula estes valores foi excluída. Portanto, precisamos ter muito cuidado, pois ao remover essa função, podemos acabar perdendo muitas informações que são importantes.

Pode não ser um valor tão importante, dado que validamos que as informações do aluguel e cliente foram inseridas. Mas para a tomada de decisão, qualquer valor de desconto final ou aplicado pode fazer a diferença. Isso para tomar ações e identificar mudanças que podem ter ocorrido na questão dos clientes ou valor final que a empresa está apurando.

Clicamos na aba "Função CalcularValorFinalComDesconto".

Para resolver isso, vamos recriar a nossa função CalcularValorFinalComDesconto. Após a recriação, podemos chamar a função novamente e ela retornará o resultado esperado.

SELECT CalcularValorFinalComDesconto(1);
Copiar código
Obtemos:

#	CalcularValorFinalComDesconto(1)
3078.00
Com os estudos realizados, conseguimos entregar à Insight Places diversas funções que fornecem informações importantes, como a quantidade de dias que as pessoas clientes ficaram hospedadas, o valor da diária, o valor total utilizando as nossas funções de agregação, a quantidade de registros que temos nas nossas tabelas, entre outras.

Além disso, conseguimos formatar as nossas strings, como remover espaço nos nomes das pessoas clientes e formatar os CPFs. Foram diversas consultas e funções que construímos e que vamos passar para as pessoas gestoras da Insight Places.

Conclusão: Aprendizado e Aplicação das Funções SQL
Com este curso, conseguimos conhecer e aprender sobre as funções nativas da linguagem SQL, como as funções de agregação, as funções para trabalhar com strings, as funções para trabalhar com datas, entre outras. Também entendemos como criar as nossas funções para encapsular aqueles comandos que são muito importantes e que são executados com muita frequência.

## Para saber mais: cuidados e impactos ao excluir uma função
 Próxima Atividade

Excluir funções que são chamadas dentro de outros procedimentos armazenados no banco de dados pode ter consequências significativas e afetar a integridade e o funcionamento do seu sistema. A seguir, explore alguns dos principais impactos e cuidados que devem ser considerados:

Impactos da exclusão de funções
Erros de execução: Procedimentos armazenados que chamam a função excluída falharão ao serem executados, resultando em erros. Isso pode afetar as operações críticas do sistema que dependem desses procedimentos.
Integridade dos dados: Se o procedimento armazenado realizar operações de inserção, atualização ou deleção de dados baseadas nos resultados da função excluída, a integridade dos dados pode ser comprometida.
Dependências encadeadas: A exclusão de uma função pode afetar não apenas os procedimentos que a chamam diretamente, mas também outros objetos do banco de dados que dependem desses procedimentos, criando um efeito cascata de falhas.
Perda de lógica de negócios: Funções muitas vezes encapsulam lógicas de negócios importantes. Sua exclusão pode resultar na perda dessas lógicas, exigindo uma reanálise e reimplementação que podem ser custosas e demoradas.
Cuidados ao excluir funções
Revisão de dependências: Antes de excluir uma função, revise todas as suas dependências. A maioria dos SGBDs fornece ferramentas ou consultas que podem ajudar a identificar objetos dependentes, como procedimentos armazenados, gatilhos ou outras funções.
Testes rigorosos: Realize testes rigorosos em um ambiente de desenvolvimento ou teste para garantir que a exclusão da função não afetará adversamente outras partes do sistema.
Comunicação e documentação: Comunique a equipe sobre as mudanças e atualize a documentação do sistema para refletir a exclusão da função e as alterações nos procedimentos armazenados relacionados.
Alternativas à exclusão: Em vez de excluir a função imediatamente, considere descontinuá-la gradualmente. Isso pode incluir a marcação da função como obsoleta, retornando valores padrão ou nulos, ou redirecionando chamadas para uma nova função.
Backup e versionamento: Certifique-se de ter backups recentes do banco de dados e considere o uso de controle de versão para objetos do banco de dados. Isso permite restaurar a função ou revisar sua lógica, se necessário.
Atualização de procedimentos armazenados: Atualize, reescreva ou remova quaisquer procedimentos armazenados que dependam da função que você planeja excluir. Garanta que essas mudanças sejam testadas antes de serem aplicadas em produção.
A exclusão de funções no banco de dados, especialmente aquelas usadas por procedimentos armazenados, deve ser abordada com cautela e planejamento. Avaliar o impacto, revisar dependências e tomar precauções adequadas pode ajudar a evitar erros de runtime, comprometimento da integridade dos dados e perda de funcionalidades críticas.