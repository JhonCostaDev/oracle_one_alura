# Criando uma nova Tabela


Não vamos inserir essas informações na nossa tabela de aluguéis, mas criar uma nova tabela com um resumo do aluguel da pessoa cliente. Nela, teremos a porcentagem de desconto que a pessoa cliente recebeu, o valor final e o valor sem o desconto.

Isso é interessante tanto para a área financeira da empresa quanto para as pessoas proprietárias dos imóveis. Afinal, esse desconto aplicado é algo que precisa ser validado pela gestão da empresa e alinhado com as pessoas proprietárias.

Além disso, diversos outros pontos podem ser avaliados com essas informações, como a questão do aumento da quantidade de clientes que se hospedaram por mais dias nesses imóveis a partir da nova política de descontos.

Vamos criar essa tabela em uma nova aba. Começaremos pela sua estrutura base:

```sql
CREATE TABLE resumo_aluguel (
    aluguel_id VARCHAR(255),
    cliente_id VARCHAR(255),
    valor_total DECIMAL(10,2),
    desconto_aplicado DECIMAL(10,2),
    valor_final DECIMAL(10,2),
     PRIMARY KEY (aluguel_id, cliente_id);
    FOREIGN KEY (aluguel_id) REFERENCES alugueis(aluguel_id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);
```

Criamos uma tabela chamada resumo_aluguel, onde teremos os seguintes campos: aluguel_id, que será um varchar de 255; cliente_id, que também será um varchar de 255; valor_total, que é um decimal de 10,2; descontoaplicado, também um decimal de 10,2; valor_final, um decimal de 10,2. Essas são todas as informações de que precisamos.

Estamos fazendo o relacionamento entre a tabela de aluguéis e a tabela de clientes, com o `PRIMARY KEY`, o `FOREIGN KEY` e o `REFERENCES`, para inserir nessa nova tabela tanto a identificação do aluguel como da pessoa cliente.

Executamos o código e, com isso, criamos a nossa tabela. Mas como vamos pegar as informações calculadas pelas nossas duas funções e inserir nessa tabela? Vamos ter que fazer isso manualmente, calculando tudo novamente? Sim, é uma opção. Mas podemos utilizar outro recurso para fazer isso de forma automática: os `triggers` (gatilhos).

## TRIGGERS

Os triggers são um recurso da linguagem SQL que, ao serem criados, são acionados sempre que algo acontecer em uma tabela, o qual associamos a essa trigger.

Por exemplo: sempre que um novo aluguel for inserido na nossa tabela de aluguéis, esse trigger pode ser acionado para executar uma consulta ou outro procedimento internamente e de forma automática, como inserir valores nas nossas outras tabelas (nesse caso, na nossa tabela de resumo_aluguel).

O trigger tanto pode inserir como atualizar ou mesmo excluir dados, e ainda pode ser executado a partir desses três tipos de consultas (atualização, exclusão ou inserção).

Então, a seguir, vamos criar um trigger que será acionado sempre que um novo aluguel for inserido, justamente para calcular o valortotal, o descontoaplicado e o valorfinal, além de inserir essas três informações na nossa tabela de resumo_aluguel.

## Question Desenvolvendo funções MySQL para gerenciamento eficiente de tarefas
 Próxima Atividade

Imagine que você está desenvolvendo um aplicativo de gerenciamento de tarefas para uma equipe de desenvolvimento de software. A equipe precisa de uma funcionalidade de checklist para acompanhar o progresso das tarefas diárias. Você decide usar o MySQL como banco de dados e percebe que seria útil criar uma função personalizada para automatizar a verificação de tarefas concluídas. Além disso, você quer usar funções nativas do MySQL para otimizar consultas relacionadas ao checklist.

Qual das seguintes opções melhor descreve a combinação de uma função nativa do MySQL e uma função personalizada que você poderia criar para gerenciar o checklist de tarefas de forma eficiente? Escolha a alternativa correta.

Selecione uma alternativa

Usar a função nativa COUNT() para contar o número de tarefas concluídas e criar uma função verificarTarefa(idTarefa) que retorna TRUE se uma tarefa específica estiver concluída.


Usar a função nativa SUM() para somar o tempo estimado de todas as tarefas e criar uma função adicionarTarefa(descricao, tempoEstimado) para inserir novas tarefas.


Criar uma função atualizarStatusTarefa(idTarefa, status) para mudar o status de uma tarefa e usar a função nativa NOW() para registrar o momento da atualização.


Criar uma função listarTarefas() que retorna todas as tarefas e usar a função nativa DATE() para filtrar tarefas por data.