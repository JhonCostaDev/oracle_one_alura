Em vídeo, criamos a primeira tabela para o banco de dados da Insight Places, que foi a tabela proprietários, utilizando o script SQL que nos foi disponibilizado pela empresa.

Assim como criamos essa tabela, a empresa deseja adicionar outras 5 tabelas diferentes que fazem parte da sua estrutura de dados, por isso vou deixar aqui abaixo os códigos de criação das seis tabelas, incluindo a tabela criada em vídeo, para você criá-las no seu ambiente.

USE insight_places;

CREATE TABLE proprietarios (
proprietario_id VARCHAR(255) PRIMARY KEY,
nome VARCHAR(255),
cpf_cnpj VARCHAR(20),
contato VARCHAR(255)
);

CREATE TABLE clientes (
    cliente_id VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    cpf VARCHAR(14),
    contato VARCHAR(255)
);

CREATE TABLE enderecos (
    endereco_id VARCHAR(255) PRIMARY KEY,
    rua VARCHAR(255),
    numero INT,
    bairro VARCHAR(255),
    cidade VARCHAR(255),
    estado VARCHAR(2),
    cep VARCHAR(10)
);

CREATE TABLE hospedagens (
    hospedagem_id VARCHAR(255) PRIMARY KEY,
    tipo VARCHAR(50),
    endereco_id VARCHAR(255),
    proprietario_id VARCHAR(255),
        ativo bool,
    FOREIGN KEY (endereco_id) REFERENCES enderecos(endereco_id),
    FOREIGN KEY (proprietario_id) REFERENCES proprietarios(proprietario_id)
);

CREATE TABLE alugueis (
    aluguel_id VARCHAR(255) PRIMARY KEY,
    cliente_id VARCHAR(255),
    hospedagem_id VARCHAR(255),
    data_inicio DATE,
    data_fim DATE,
    preco_total DECIMAL(10, 2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (hospedagem_id) REFERENCES hospedagens(hospedagem_id)
);

CREATE TABLE avaliacoes (
avaliacao_id VARCHAR(255) PRIMARY KEY,
cliente_id VARCHAR(255),
hospedagem_id VARCHAR(255),
nota INT,
comentario TEXT,
FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
FOREIGN KEY (hospedagem_id) REFERENCES hospedagens(hospedagem_id)
);