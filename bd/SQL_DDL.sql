USE p6g1;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'perf')
BEGIN
EXEC('CREATE SCHEMA perf')
END

-- DROPS
IF OBJECT_ID('p6g1.perf.produto_tem_promocao', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.produto_tem_promocao DROP CONSTRAINT produto_tem_promocao_produtoid_fr;
ALTER TABLE p6g1.perf.produto_tem_promocao DROP CONSTRAINT produto_tem_promocao_promocaoid_fr;
ALTER TABLE p6g1.perf.produto_tem_promocao DROP CONSTRAINT produto_tem_promocao_pk;
DROP TABLE p6g1.perf.produto_tem_promocao;
END
GO

IF OBJECT_ID('p6g1.perf.perfume', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.perfume DROP CONSTRAINT perfume_id_fr;
ALTER TABLE p6g1.perf.perfume DROP CONSTRAINT perfume_pk;
DROP TABLE p6g1.perf.perfume;
END
GO

IF OBJECT_ID('p6g1.perf.cosmetica', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.cosmetica DROP CONSTRAINT cosmetica_id_fr;
ALTER TABLE p6g1.perf.cosmetica DROP CONSTRAINT cosmetica_pk;
DROP TABLE p6g1.perf.cosmetica;
END
GO

IF OBJECT_ID('p6g1.perf.clientefavorita', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.clientefavorita DROP CONSTRAINT clientefavorita_clienteemail_fr;
ALTER TABLE p6g1.perf.clientefavorita DROP CONSTRAINT clientefavorita_produtoid_fr;
ALTER TABLE p6g1.perf.clientefavorita DROP CONSTRAINT clientefavorita_pk;
DROP TABLE p6g1.perf.clientefavorita;
END
GO

IF OBJECT_ID('p6g1.perf.cliente_usa_cupao', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.cliente_usa_cupao DROP CONSTRAINT clienteusacupao_clienteemail_fr;
ALTER TABLE p6g1.perf.cliente_usa_cupao DROP CONSTRAINT clienteusacupao_cupaoid_fr;
ALTER TABLE p6g1.perf.cliente_usa_cupao DROP CONSTRAINT cliente_usa_cupao_pk;
DROP TABLE p6g1.perf.cliente_usa_cupao;
END
GO

IF OBJECT_ID('p6g1.perf.marcacao', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.marcacao DROP CONSTRAINT marcacao_clienteemail_fr;
ALTER TABLE p6g1.perf.marcacao DROP CONSTRAINT marcacao_servicoid_fr;
ALTER TABLE p6g1.perf.marcacao DROP CONSTRAINT marcacao_funcemail_fr;
ALTER TABLE p6g1.perf.marcacao DROP CONSTRAINT marcacao_pk;
DROP TABLE p6g1.perf.marcacao;
END
GO

IF OBJECT_ID('p6g1.perf.compra_online', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.compra_online DROP CONSTRAINT compra_online_numero_fr;
ALTER TABLE p6g1.perf.compra_online DROP CONSTRAINT compra_online_contactoid_fr;
ALTER TABLE p6g1.perf.compra_online DROP CONSTRAINT compra_online_pk;
DROP TABLE p6g1.perf.compra_online;
END
GO

IF OBJECT_ID('p6g1.perf.compra_presencial', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.compra_presencial DROP CONSTRAINT compra_presencial_numero_fr;
ALTER TABLE p6g1.perf.compra_presencial DROP CONSTRAINT compra_presencial_funcemail_fr;
ALTER TABLE p6g1.perf.compra_presencial DROP CONSTRAINT compra_presencial_pk;
DROP TABLE p6g1.perf.compra_presencial;
END
GO

IF OBJECT_ID('p6g1.perf.compra_tem_produto', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.compra_tem_produto DROP CONSTRAINT compra_tem_produto_compranumero_fr;
ALTER TABLE p6g1.perf.compra_tem_produto DROP CONSTRAINT compra_tem_produto_produtoid_fr;
ALTER TABLE p6g1.perf.compra_tem_produto DROP CONSTRAINT compra_tem_produto_pk;
DROP TABLE p6g1.perf.compra_tem_produto;
END
GO

IF OBJECT_ID('p6g1.perf.compra', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.compra DROP CONSTRAINT compra_clienteemail_fr;
ALTER TABLE p6g1.perf.compra DROP CONSTRAINT compra_pk;
DROP TABLE p6g1.perf.compra;
END
GO

IF OBJECT_ID('p6g1.perf.cliente', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.cliente DROP CONSTRAINT cliente_email_fr;
ALTER TABLE p6g1.perf.cliente DROP CONSTRAINT cliente_pk;
DROP TABLE p6g1.perf.cliente;
END
GO

IF OBJECT_ID('p6g1.perf.funcionario_faz_servico', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.funcionario_faz_servico DROP CONSTRAINT func_faz_serv_servicoid_fr;
ALTER TABLE p6g1.perf.funcionario_faz_servico DROP CONSTRAINT func_faz_serv_funcionario_email_fr;
ALTER TABLE p6g1.perf.funcionario_faz_servico DROP CONSTRAINT funcionario_faz_servico_pk;
DROP TABLE p6g1.perf.funcionario_faz_servico;
END
GO

IF OBJECT_ID('p6g1.perf.funcionario', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.funcionario DROP CONSTRAINT funcionario_email_fr;
ALTER TABLE p6g1.perf.funcionario DROP CONSTRAINT funcionario_pk;
DROP TABLE p6g1.perf.funcionario;
END
GO

IF OBJECT_ID('p6g1.perf.utilizador', 'U') IS NOT NULL
ALTER TABLE p6g1.perf.utilizador DROP CONSTRAINT utilizador_contactodefaultid_fr;
GO

IF OBJECT_ID('p6g1.perf.contacto', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.contacto DROP CONSTRAINT contacto_utilizadoremail_fr;
ALTER TABLE p6g1.perf.contacto DROP CONSTRAINT contacto_pk;
DROP TABLE p6g1.perf.contacto;
END
GO

IF OBJECT_ID('p6g1.perf.utilizador', 'U') IS NOT NULL
BEGIN
ALTER TABLE p6g1.perf.utilizador DROP CONSTRAINT utilizador_pk;
DROP TABLE p6g1.perf.utilizador;
END
GO

IF OBJECT_ID('p6g1.perf.servico', 'U') IS NOT NULL
DROP TABLE p6g1.perf.servico;
GO

IF OBJECT_ID('p6g1.perf.cupao', 'U') IS NOT NULL
DROP TABLE p6g1.perf.cupao;
GO

IF OBJECT_ID('p6g1.perf.produto', 'U') IS NOT NULL
DROP TABLE p6g1.perf.produto;
GO

IF OBJECT_ID('p6g1.perf.promocao', 'U') IS NOT NULL
DROP TABLE p6g1.perf.promocao;
GO

-- TABLE CREATION
CREATE TABLE p6g1.perf.promocao
(
    id INT NOT NULL IDENTITY(1,1),
    nome VARCHAR(30) NOT NULL,
    desconto TINYINT CHECK(desconto BETWEEN 0 and 100) NOT NULL,
    datainicio SMALLDATETIME NOT NULL,
    datafim SMALLDATETIME NOT NULL,
    CONSTRAINT promocao_pk PRIMARY KEY (id)
);
GO

CREATE TABLE p6g1.perf.produto_tem_promocao
(
    produtoid INT NOT NULL,
    promocaoid INT NOT NULL,
    CONSTRAINT produto_tem_promocao_pk PRIMARY KEY (produtoid, promocaoid)
);
GO

CREATE TABLE p6g1.perf.produto
(
    id INT NOT NULL IDENTITY(1,1),
    preco FLOAT NOT NULL,
    familiaolfativa VARCHAR(30),
    categoria VARCHAR(30) NOT NULL,
    nome VARCHAR(30) NOT NULL,
    marca VARCHAR(30) NOT NULL,
    linha VARCHAR(30),
    tamanho SMALLINT,
    descricao VARCHAR(280),
    imagem VARCHAR(100) NOT NULL,
    stock SMALLINT NOT NULL,
    destinatario VARCHAR(10),
    deleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT produto_pk PRIMARY KEY  (id)
);
GO

CREATE TABLE p6g1.perf.perfume
(
    id INT NOT NULL,

    CONSTRAINT perfume_pk PRIMARY KEY (id)
);
GO

CREATE TABLE p6g1.perf.cosmetica
(
    id INT NOT NULL,
    tipo VARCHAR(30) NOT NULL,

    CONSTRAINT cosmetica_pk PRIMARY KEY (id)
)
GO

CREATE TABLE p6g1.perf.clientefavorita
(
    clienteemail VARCHAR(255) NOT NULL,
    produtoid INT NOT NULL,

    CONSTRAINT clientefavorita_pk PRIMARY KEY (clienteemail, produtoid)
)
GO

CREATE TABLE p6g1.perf.cupao
(
    id CHAR(10) NOT NULL,
    datainicio SMALLDATETIME NOT NULL,
    datafim SMALLDATETIME NOT NULL,
    pontos_atribuidos INT NOT NULL,
    CONSTRAINT cupao_pk PRIMARY KEY (id)
);
GO

CREATE TABLE p6g1.perf.cliente_usa_cupao
(
    cliente_email VARCHAR(255) NOT NULL,
    cupao_id CHAR(10) NOT NULL,
    CONSTRAINT cliente_usa_cupao_pk PRIMARY KEY (cliente_email, cupao_id)


);
GO

CREATE TABLE p6g1.perf.cliente
(
    email VARCHAR(255) NOT NULL,
    pontos INT NOT NULL,
    newsletter BIT NOT NULL,
    pagamento VARCHAR(10),

    CONSTRAINT cliente_pk PRIMARY KEY (email)
);
GO

CREATE TABLE p6g1.perf.utilizador
(
    email VARCHAR(255) NOT NULL,
    contribuinte CHAR(9) NOT NULL,
    fname VARCHAR(20) NOT NULL,
    lname VARCHAR(20) NOT NULL,
    pw BINARY(64) NOT NULL,
    sexo BIT NOT NULL,
    dataNasc DATE NOT NULL,
    foto VARCHAR(100) NOT NULL,
    contacto_default_id INT,
    deleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT utilizador_pk PRIMARY KEY (email)

);
GO

CREATE TABLE p6g1.perf.funcionario
(
    email VARCHAR(255) NOT NULL,
    administrator TINYINT NOT NULL,
    salario INT NOT NULL,
    CONSTRAINT funcionario_pk PRIMARY KEY (email)

);
GO

CREATE TABLE p6g1.perf.contacto
(
    id INT IDENTITY(1,1) NOT NULL,
    utilizador_email VARCHAR(255) NOT NULL,
    telemovel CHAR(9) NOT NULL,
    visibilidade BIT NOT NULL DEFAULT 1,
    codigo_postal CHAR(8) NOT NULL,
    pais VARCHAR(20) NOT NULL,
    endereco VARCHAR(50) NOT NULL,
    apartamento VARCHAR(50),
    localidade VARCHAR(20) NOT NULL,

    CONSTRAINT contacto_pk PRIMARY KEY (id)

);
GO

CREATE TABLE p6g1.perf.compra_tem_produto
(
    compranumero INT NOT NULL,
    produtoid INT NOT NULL,
    unidades INT NOT NULL,

    CONSTRAINT compra_tem_produto_pk PRIMARY KEY (compranumero, produtoid)
);
GO

CREATE TABLE p6g1.perf.compra
(
    numero INT NOT NULL IDENTITY(1,1),
    contribuinte CHAR(9) NOT NULL,
    datacompra SMALLDATETIME NOT NULL,
    pagamento VARCHAR(10) NOT NULL,
    clienteemail VARCHAR(255) NOT NULL,
    pontosgastos INT,
    pontosacumulados INT,

    CONSTRAINT compra_pk PRIMARY KEY (numero)
);
GO

CREATE TABLE p6g1.perf.servico
(
    id INT IDENTITY(1,1) NOT NULL,
    tipo VARCHAR(40) NOT NULL,
    preco FLOAT NOT NULL,
    deleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT servico_pk PRIMARY KEY (id)
);
GO

CREATE TABLE p6g1.perf.funcionario_faz_servico
(
    funcionario_email VARCHAR(255) NOT NULL,
    servico_id INT NOT NULL,
    duracao_media INT NOT NULL,
    deleted BIT NOT NULL DEFAULT 0,

    CONSTRAINT funcionario_faz_servico_pk PRIMARY KEY (funcionario_email, servico_id)
);
GO

CREATE TABLE p6g1.perf.compra_online
(
    numero INT NOT NULL,
    rating CHAR(1),
    observacao VARCHAR(280),
    rastreamento VARCHAR(20),
    presente BIT NOT NULL,
    contactoid INT NOT NULL,

    CONSTRAINT compra_online_pk PRIMARY KEY (numero)
);
GO

CREATE TABLE p6g1.perf.compra_presencial
(
    numero INT NOT NULL,
    funcemail VARCHAR(255) NOT NULL,

    CONSTRAINT compra_presencial_pk PRIMARY KEY (numero)
);
GO

CREATE TABLE p6g1.perf.marcacao
(
    id INT NOT NULL IDENTITY(1,1),
    cliente_email VARCHAR(255) NOT NULL,
    servico_id INT NOT NULL,
    funcionario_email VARCHAR(255) NOT NULL,
    dataMarc SMALLDATETIME NOT NULL,
    deleted BIT NOT NULL DEFAULT 0,
    

    CONSTRAINT marcacao_pk PRIMARY KEY (id)
);
GO


-- CONSTRAINTS
ALTER TABLE p6g1.perf.produto_tem_promocao ADD CONSTRAINT produto_tem_promocao_produtoid_fr FOREIGN KEY (produtoid) REFERENCES p6g1.perf.produto(id);
ALTER TABLE p6g1.perf.produto_tem_promocao ADD CONSTRAINT produto_tem_promocao_promocaoid_fr FOREIGN KEY (promocaoid) REFERENCES p6g1.perf.promocao(id);

ALTER TABLE p6g1.perf.perfume ADD CONSTRAINT perfume_id_fr FOREIGN KEY (id) REFERENCES p6g1.perf.produto(id);

ALTER TABLE p6g1.perf.cosmetica ADD CONSTRAINT cosmetica_id_fr FOREIGN KEY (id) REFERENCES p6g1.perf.produto(id);

ALTER TABLE p6g1.perf.clientefavorita ADD CONSTRAINT clientefavorita_clienteemail_fr FOREIGN KEY (clienteemail) REFERENCES p6g1.perf.cliente(email);
ALTER TABLE p6g1.perf.clientefavorita ADD CONSTRAINT clientefavorita_produtoid_fr FOREIGN KEY (produtoid) REFERENCES p6g1.perf.produto(id);

ALTER TABLE p6g1.perf.cliente_usa_cupao ADD CONSTRAINT clienteusacupao_clienteemail_fr FOREIGN KEY (cliente_email) REFERENCES p6g1.perf.cliente(email);
ALTER TABLE p6g1.perf.cliente_usa_cupao ADD CONSTRAINT clienteusacupao_cupaoid_fr FOREIGN KEY (cupao_id) REFERENCES p6g1.perf.cupao(id);

ALTER TABLE p6g1.perf.cliente ADD CONSTRAINT cliente_email_fr FOREIGN KEY (email) REFERENCES p6g1.perf.cliente(email);

ALTER TABLE p6g1.perf.utilizador ADD CONSTRAINT utilizador_contactodefaultid_fr FOREIGN KEY (contacto_default_id) REFERENCES p6g1.perf.contacto(id);

ALTER TABLE p6g1.perf.funcionario ADD CONSTRAINT funcionario_email_fr FOREIGN KEY (email) REFERENCES p6g1.perf.utilizador(email);

ALTER TABLE p6g1.perf.compra_tem_produto ADD CONSTRAINT compra_tem_produto_compranumero_fr FOREIGN KEY (compranumero) REFERENCES p6g1.perf.compra(numero);
ALTER TABLE p6g1.perf.compra_tem_produto ADD CONSTRAINT compra_tem_produto_produtoid_fr FOREIGN KEY (produtoid) REFERENCES p6g1.perf.produto(id);

ALTER TABLE p6g1.perf.contacto ADD CONSTRAINT contacto_utilizadoremail_fr FOREIGN KEY (utilizador_email) REFERENCES p6g1.perf.utilizador(email);

ALTER TABLE p6g1.perf.compra ADD CONSTRAINT compra_clienteemail_fr FOREIGN KEY (clienteemail) REFERENCES p6g1.perf.cliente(email);

ALTER TABLE p6g1.perf.funcionario_faz_servico ADD CONSTRAINT func_faz_serv_servicoid_fr FOREIGN KEY (servico_id) REFERENCES p6g1.perf.servico(id);
ALTER TABLE p6g1.perf.funcionario_faz_servico ADD CONSTRAINT func_faz_serv_funcionario_email_fr FOREIGN KEY (funcionario_email) REFERENCES p6g1.perf.funcionario(email);

ALTER TABLE p6g1.perf.compra_online ADD CONSTRAINT compra_online_numero_fr FOREIGN KEY (numero) REFERENCES p6g1.perf.compra(numero);
ALTER TABLE p6g1.perf.compra_online ADD CONSTRAINT compra_online_contactoid_fr FOREIGN KEY (contactoid) REFERENCES p6g1.perf.contacto(id);

ALTER TABLE p6g1.perf.compra_presencial ADD CONSTRAINT compra_presencial_numero_fr FOREIGN KEY (numero) REFERENCES p6g1.perf.compra(numero);
ALTER TABLE p6g1.perf.compra_presencial ADD CONSTRAINT compra_presencial_funcemail_fr FOREIGN KEY (funcemail) REFERENCES p6g1.perf.funcionario(email);

ALTER TABLE p6g1.perf.marcacao ADD CONSTRAINT marcacao_clienteemail_fr FOREIGN KEY (cliente_email) REFERENCES p6g1.perf.cliente(email);
ALTER TABLE p6g1.perf.marcacao ADD CONSTRAINT marcacao_servicoid_fr FOREIGN KEY (servico_id) REFERENCES p6g1.perf.servico(id);
ALTER TABLE p6g1.perf.marcacao ADD CONSTRAINT marcacao_funcemail_fr FOREIGN KEY (funcionario_email) REFERENCES p6g1.perf.funcionario(email);

