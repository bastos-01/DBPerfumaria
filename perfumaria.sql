USE [p6g1]
GO
/****** Object:  User [p6g1]    Script Date: 12/06/2020 19:58:40 ******/
CREATE USER [p6g1] FOR LOGIN [p6g1] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [p6g1]
GO
/****** Object:  Schema [perf]    Script Date: 12/06/2020 19:58:40 ******/
CREATE SCHEMA [perf]
GO
/****** Object:  UserDefinedFunction [perf].[getAllFuncs]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[getAllFuncs] ( @emailFunc VARCHAR(255)) returns @table table (email VARCHAR(255) NOT NULL, contribuinte CHAR(9) NOT NULL, fname VARCHAR(20) NOT NULL,
                                                                                lname VARCHAR(20) NOT NULL, sexo BIT NOT NULL, dataNasc DATE NOT NULL,
                                                                                foto VARCHAR(100) NOT NULL, contacto_default_id INT,  
                                                                                administrator TINYINT NOT NULL, salario INT NOT NULL, deleted BIT NOT NULL DEFAULT 0)                                            
AS
BEGIN 
            DECLARE @email AS VARCHAR(255), @contribuinte AS CHAR(9), @fname AS VARCHAR(20),
                    @lname AS VARCHAR(20), @sexo AS BIT, @dataNasc AS DATE,
                    @foto AS VARCHAR(100), @contacto_default_id AS INT, @deleted AS BIT, 
                    @administrator AS TINYINT, @salario AS INT;
            IF EXISTS(SELECT email FROM p6g1.perf.funcionario WHERE email=@emailFunc AND administrator=2)
                INSERT @table SELECT utilizador.email, contribuinte, fname, lname, sexo, dataNasc, foto, contacto_default_id, administrator, salario, deleted
                            FROM p6g1.perf.utilizador JOIN p6g1.perf.funcionario ON utilizador.email=funcionario.email
            RETURN;
        END;
GO
/****** Object:  UserDefinedFunction [perf].[getAllProducts]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[getAllProducts] () RETURNS @table TABLE (preco INT NOT NULL, familiaolfativa VARCHAR(30), categoria VARCHAR(30) NOT NULL,
                                                            nome VARCHAR(30) NOT NULL, marca VARCHAR(30) NOT NULL, linha VARCHAR(30),
                                                            tamanho SMALLINT, descricao VARCHAR(280), imagem VARCHAR(100) NOT NULL,
                                                            stock SMALLINT NOT NULL, destinatario VARCHAR(10))
                                                        
    AS
        BEGIN 
            DECLARE @preco AS INT, @familiaolfativa AS VARCHAR(30), @categoria AS VARCHAR(30),@nome AS VARCHAR(30), @marca AS VARCHAR(30),
            @linha AS VARCHAR(30), @tamanho AS SMALLINT, @descricao AS VARCHAR(280), @imagem AS VARCHAR(100),
            @stock AS SMALLINT, @destinatario AS VARCHAR(10);
            
            INSERT @table SELECT preco, familiaolfativa, categoria, nome, marca, linha, tamanho, descricao, imagem, stock, destinatario
                            FROM p6g1.perf.produto
            RETURN;
        END;
GO
/****** Object:  Table [perf].[produto]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[produto](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[preco] [float] NOT NULL,
	[familiaolfativa] [varchar](30) NULL,
	[categoria] [varchar](30) NOT NULL,
	[nome] [varchar](30) NOT NULL,
	[marca] [varchar](30) NOT NULL,
	[linha] [varchar](30) NULL,
	[tamanho] [smallint] NULL,
	[descricao] [varchar](280) NULL,
	[imagem] [varchar](100) NOT NULL,
	[stock] [smallint] NOT NULL,
	[destinatario] [varchar](10) NULL,
	[deleted] [bit] NOT NULL,
 CONSTRAINT [produto_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [perf].[compra_tem_produto]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[compra_tem_produto](
	[compranumero] [int] NOT NULL,
	[produtoid] [int] NOT NULL,
	[unidades] [int] NOT NULL,
 CONSTRAINT [compra_tem_produto_pk] PRIMARY KEY CLUSTERED 
(
	[compranumero] ASC,
	[produtoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [perf].[compra]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[compra](
	[numero] [int] IDENTITY(1,1) NOT NULL,
	[contribuinte] [char](9) NOT NULL,
	[datacompra] [smalldatetime] NOT NULL,
	[pagamento] [varchar](10) NOT NULL,
	[clienteemail] [varchar](255) NOT NULL,
	[pontosgastos] [int] NULL,
	[pontosacumulados] [int] NULL,
 CONSTRAINT [compra_pk] PRIMARY KEY CLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [perf].[clientBuyHistory]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[clientBuyHistory] (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT datacompra as [Data], SUM(unidades * preco) as Total, compranumero
                    FROM ((p6g1.perf.compra_tem_produto JOIN p6g1.perf.compra ON compra_tem_produto.compranumero=compra.numero) JOIN p6g1.perf.produto ON produtoid=id)
                    WHERE (clienteemail=@email)
                    GROUP BY datacompra, clienteemail, compranumero
                    ORDER BY datacompra DESC OFFSET 0 ROWS)
GO
/****** Object:  Table [perf].[contacto]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[contacto](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[utilizador_email] [varchar](255) NOT NULL,
	[telemovel] [char](9) NOT NULL,
	[visibilidade] [bit] NOT NULL,
	[codigo_postal] [char](8) NOT NULL,
	[pais] [varchar](20) NOT NULL,
	[endereco] [varchar](50) NOT NULL,
	[apartamento] [varchar](50) NULL,
	[localidade] [varchar](20) NOT NULL,
 CONSTRAINT [contacto_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [perf].[clientContacts]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[clientContacts] (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT id, telemovel, codigo_postal, pais, endereco, apartamento, localidade
                    FROM p6g1.perf.contacto
                    WHERE utilizador_email=@email AND visibilidade = 1
                    ORDER BY id ASC OFFSET 0 ROWS)             
GO
/****** Object:  Table [perf].[utilizador]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[utilizador](
	[email] [varchar](255) NOT NULL,
	[contribuinte] [char](9) NOT NULL,
	[fname] [varchar](20) NOT NULL,
	[lname] [varchar](20) NOT NULL,
	[pw] [binary](64) NOT NULL,
	[sexo] [bit] NOT NULL,
	[dataNasc] [date] NOT NULL,
	[foto] [varchar](100) NOT NULL,
	[contacto_default_id] [int] NULL,
	[deleted] [bit] NOT NULL,
 CONSTRAINT [utilizador_pk] PRIMARY KEY CLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [perf].[clientDefaultContact]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[clientDefaultContact] (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT contacto_default_id as id
                    FROM (p6g1.perf.utilizador JOIN p6g1.perf.contacto ON contacto_default_id=id)
                    WHERE email=@email AND visibilidade = 1)
                    
GO
/****** Object:  Table [perf].[clientefavorita]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[clientefavorita](
	[clienteemail] [varchar](255) NOT NULL,
	[produtoid] [int] NOT NULL,
 CONSTRAINT [clientefavorita_pk] PRIMARY KEY CLUSTERED 
(
	[clienteemail] ASC,
	[produtoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [perf].[clientFavourites]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[clientFavourites] (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT id, preco, familiaolfativa, categoria, nome, marca, linha, tamanho, descricao, imagem, stock, destinatario
                    FROM (p6g1.perf.clientefavorita JOIN p6g1.perf.produto ON produtoid=id)
                    WHERE clienteemail=@email AND deleted = 0)
                    
GO
/****** Object:  Table [perf].[servico]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[servico](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipo] [varchar](40) NOT NULL,
	[preco] [float] NOT NULL,
	[deleted] [bit] NOT NULL,
 CONSTRAINT [servico_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [perf].[marcacao]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[marcacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cliente_email] [varchar](255) NOT NULL,
	[servico_id] [int] NOT NULL,
	[funcionario_email] [varchar](255) NOT NULL,
	[dataMarc] [smalldatetime] NOT NULL,
	[deleted] [bit] NOT NULL,
 CONSTRAINT [marcacao_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [perf].[clientFutureMarc]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[clientFutureMarc] (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT dataMarc, tipo, preco, fname AS NomeFuncionario
                    FROM ((p6g1.perf.marcacao JOIN p6g1.perf.servico ON servico_id=servico.id) JOIN p6g1.perf.utilizador ON funcionario_email = email)
                    WHERE (cliente_email=@email AND DATEDIFF(mi, GETDATE(), dataMarc) > 0) 
                    ORDER BY dataMarc ASC OFFSET 0 ROWS)              
GO
/****** Object:  Table [perf].[cliente]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[cliente](
	[email] [varchar](255) NOT NULL,
	[pontos] [int] NOT NULL,
	[newsletter] [bit] NOT NULL,
	[pagamento] [varchar](10) NULL,
 CONSTRAINT [cliente_pk] PRIMARY KEY CLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [perf].[getClientInfo]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [perf].[getClientInfo] (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT p6g1.perf.utilizador.*, p6g1.perf.cliente.email AS clientEmail, p6g1.perf.cliente.pontos, p6g1.perf.cliente.newsletter, p6g1.perf.cliente.pagamento
					FROM p6g1.perf.utilizador 
					JOIN p6g1.perf.cliente 
					ON p6g1.perf.utilizador.email = p6g1.perf.cliente.email
                    WHERE @email = utilizador.email) 
GO
/****** Object:  UserDefinedFunction [perf].[clientServicesHistory]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[clientServicesHistory] (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT dataMarc, tipo, servico.preco
                    FROM (p6g1.perf.marcacao JOIN p6g1.perf.servico ON servico_id=servico.id)
                    WHERE (cliente_email=@email AND DATEDIFF(mi, GETDATE(), dataMarc) < 0) 
                    ORDER BY dataMarc ASC OFFSET 0 ROWS)             
GO
/****** Object:  UserDefinedFunction [perf].[funcFutureMarc]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[funcFutureMarc] (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT cliente_email,dataMarc, tipo, preco, fname, lname, marcacao.id
                    FROM ((p6g1.perf.marcacao JOIN p6g1.perf.servico ON servico_id=servico.id) JOIN p6g1.perf.utilizador ON cliente_email = email)
                    WHERE (funcionario_email=@email AND DATEDIFF(mi, GETDATE(), dataMarc) > 0) 
                    ORDER BY dataMarc ASC OFFSET 0 ROWS)             
GO
/****** Object:  Table [perf].[funcionario]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[funcionario](
	[email] [varchar](255) NOT NULL,
	[administrator] [tinyint] NOT NULL,
	[salario] [int] NOT NULL,
 CONSTRAINT [funcionario_pk] PRIMARY KEY CLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [perf].[getFuncInfo]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[getFuncInfo] (@emailFunc VARCHAR(255)) RETURNS Table 
AS
    RETURN (SELECT p6g1.perf.utilizador.*, p6g1.perf.funcionario.salario, p6g1.perf.funcionario.administrator
                    FROM p6g1.perf.utilizador
                    JOIN p6g1.perf.funcionario ON utilizador.email = funcionario.email
                    WHERE utilizador.email = @emailFunc) 
GO
/****** Object:  Table [perf].[compra_presencial]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[compra_presencial](
	[numero] [int] NOT NULL,
	[funcemail] [varchar](255) NOT NULL,
 CONSTRAINT [compra_presencial_pk] PRIMARY KEY CLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [perf].[funcSellHistory]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[funcSellHistory] (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT datacompra, clienteemail, SUM(unidades * preco) as total, compranumero
                    FROM (((p6g1.perf.compra_tem_produto JOIN p6g1.perf.compra ON compranumero=numero)JOIN p6g1.perf.produto ON produtoid=id) 
                    JOIN p6g1.perf.compra_presencial ON compra_presencial.numero=compra.numero)
                    WHERE (funcemail=@email)
                    GROUP BY datacompra, clienteemail, compranumero
                    ORDER BY datacompra DESC OFFSET 0 ROWS)
GO
/****** Object:  UserDefinedFunction [perf].[funcServicesHistory]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[funcServicesHistory] (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT dataMarc, tipo, cliente_email
                    FROM (p6g1.perf.marcacao JOIN p6g1.perf.servico ON servico_id=servico.id)
                    WHERE (funcionario_email=@email AND DATEDIFF(mi, GETDATE(), dataMarc) < 0) 
                    ORDER BY dataMarc ASC OFFSET 0 ROWS)             
GO
/****** Object:  UserDefinedFunction [perf].[getAllServices]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[getAllServices] () RETURNS Table 
AS
    RETURN (SELECT id, tipo, preco
                    FROM p6g1.perf.servico)
                    
GO
/****** Object:  Table [perf].[cupao]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[cupao](
	[id] [char](10) NOT NULL,
	[datainicio] [smalldatetime] NOT NULL,
	[datafim] [smalldatetime] NOT NULL,
	[pontos_atribuidos] [int] NOT NULL,
 CONSTRAINT [cupao_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [perf].[cliente_usa_cupao]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[cliente_usa_cupao](
	[cliente_email] [varchar](255) NOT NULL,
	[cupao_id] [char](10) NOT NULL,
 CONSTRAINT [cliente_usa_cupao_pk] PRIMARY KEY CLUSTERED 
(
	[cliente_email] ASC,
	[cupao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [perf].[getClientCupon]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[getClientCupon] (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT id, datainicio, datafim, pontos_atribuidos
                    FROM (p6g1.perf.cliente_usa_cupao JOIN p6g1.perf.cupao ON cupao_id=id)
                    WHERE cliente_email=@email
                    ORDER BY datainicio DESC OFFSET 0 ROWS)
                    
GO
/****** Object:  UserDefinedFunction [perf].[getCupons]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[getCupons] () RETURNS TABLE 
AS
    RETURN (SELECT id, datainicio, datafim, pontos_atribuidos
                    FROM p6g1.perf.cupao)
                    
GO
/****** Object:  Table [perf].[funcionario_faz_servico]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[funcionario_faz_servico](
	[funcionario_email] [varchar](255) NOT NULL,
	[servico_id] [int] NOT NULL,
	[duracao_media] [int] NOT NULL,
	[deleted] [bit] NOT NULL,
 CONSTRAINT [funcionario_faz_servico_pk] PRIMARY KEY CLUSTERED 
(
	[funcionario_email] ASC,
	[servico_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [perf].[getFuncService]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[getFuncService] (@servico_id INT) RETURNS Table 
AS
    RETURN (SELECT fname, lname, funcionario_email
                    FROM p6g1.perf.funcionario_faz_servico JOIN p6g1.perf.utilizador ON email = funcionario_email
                    WHERE funcionario_faz_servico.deleted = 0 AND servico_id = @servico_id AND utilizador.deleted = 0) 
GO
/****** Object:  UserDefinedFunction [perf].[getProductsFromBuy]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[getProductsFromBuy] (@numero INT) RETURNS Table 
AS
    RETURN (SELECT id, preco, familiaolfativa, categoria, nome, marca, linha, tamanho, descricao, imagem, stock, destinatario, deleted, unidades
                    FROM p6g1.perf.compra_tem_produto JOIN p6g1.perf.produto ON produtoid=id
                    WHERE compranumero = @numero) 
GO
/****** Object:  Table [perf].[promocao]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[promocao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [varchar](30) NOT NULL,
	[desconto] [tinyint] NOT NULL,
	[datainicio] [smalldatetime] NOT NULL,
	[datafim] [smalldatetime] NOT NULL,
 CONSTRAINT [promocao_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [perf].[getPromocoes]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[getPromocoes] () RETURNS TABLE 
AS
    RETURN (SELECT id, nome, desconto, datainicio, datafim
                    FROM p6g1.perf.promocao)
                    
GO
/****** Object:  UserDefinedFunction [perf].[getServiceFuncs]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[getServiceFuncs] (@id INT) RETURNS Table 
AS
    RETURN (SELECT fname, lname, email, funcionario_faz_servico.deleted
                    FROM p6g1.perf.utilizador JOIN p6g1.perf.funcionario_faz_servico ON email=funcionario_email
                    WHERE servico_id=@id) 
GO
/****** Object:  UserDefinedFunction [perf].[getServicesType]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [perf].[getServicesType] () RETURNS Table 
AS
    RETURN (SELECT id, tipo, preco
                    FROM p6g1.perf.servico
                    WHERE deleted = 0) 
GO
/****** Object:  Table [perf].[compra_online]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[compra_online](
	[numero] [int] NOT NULL,
	[rating] [char](1) NULL,
	[observacao] [varchar](280) NULL,
	[rastreamento] [varchar](20) NULL,
	[presente] [bit] NOT NULL,
	[contactoid] [int] NOT NULL,
 CONSTRAINT [compra_online_pk] PRIMARY KEY CLUSTERED 
(
	[numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [perf].[cosmetica]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[cosmetica](
	[id] [int] NOT NULL,
	[tipo] [varchar](30) NOT NULL,
 CONSTRAINT [cosmetica_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [perf].[perfume]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[perfume](
	[id] [int] NOT NULL,
 CONSTRAINT [perfume_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [perf].[produto_tem_promocao]    Script Date: 12/06/2020 19:58:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perf].[produto_tem_promocao](
	[produtoid] [int] NOT NULL,
	[promocaoid] [int] NOT NULL,
 CONSTRAINT [produto_tem_promocao_pk] PRIMARY KEY CLUSTERED 
(
	[produtoid] ASC,
	[promocaoid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'afonsomelooo@outlook.com', 0, 1, N'MB Way')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'alexandraneves@gmail.com', 100, 0, N'Visa')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'alexandrelima25@hotmail.com', 100, 1, N'Visa')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'aliceamaral1@hotmail.com', 0, 1, N'MB Way')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'anagonçalves1985@gmail.com', 250, 0, N'MB Way')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'andralves@gmail.com', 50, 0, N'Paypal')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'anitinhasousa@live.pt', 0, 1, N'MasterCard')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'antonio_ze@gmail.com', 100, 0, N'Visa')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'beazinha@hotmail.com', 50, 0, N'MasterCard')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'carlosa24@outmail.com', 0, 1, N'Paypal')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'carolinasilva09@hotmail.com', 100, 1, N'Visa')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'joseferreira@hotmail.pt', 50, 0, N'MasterCard')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'paulomatos31@gmail.com', 0, 1, N'Visa')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'pedrofernandes230@gmail.com', 0, 0, N'Paypal')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'pipamoreira@gmail.com', 150, 1, N'MB Way')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'sarapereiraa5@gmail.pt', 200, 1, N'Paypal')
INSERT [perf].[cliente] ([email], [pontos], [newsletter], [pagamento]) VALUES (N'sofiabarbosa@live.pt', 0, 0, N'MB Way')
INSERT [perf].[cliente_usa_cupao] ([cliente_email], [cupao_id]) VALUES (N'alexandraneves@gmail.com', N'1U37L2GRMQ')
INSERT [perf].[cliente_usa_cupao] ([cliente_email], [cupao_id]) VALUES (N'alexandrelima25@hotmail.com', N'1U37L2GRMQ')
INSERT [perf].[cliente_usa_cupao] ([cliente_email], [cupao_id]) VALUES (N'anagonçalves1985@gmail.com', N'JCZTW2BT7D')
INSERT [perf].[cliente_usa_cupao] ([cliente_email], [cupao_id]) VALUES (N'anagonçalves1985@gmail.com', N'YD60RJR24P')
INSERT [perf].[cliente_usa_cupao] ([cliente_email], [cupao_id]) VALUES (N'andralves@gmail.com', N'JCZTW2BT7D')
INSERT [perf].[cliente_usa_cupao] ([cliente_email], [cupao_id]) VALUES (N'antonio_ze@gmail.com', N'1U37L2GRMQ')
INSERT [perf].[cliente_usa_cupao] ([cliente_email], [cupao_id]) VALUES (N'beazinha@hotmail.com', N'JCZTW2BT7D')
INSERT [perf].[cliente_usa_cupao] ([cliente_email], [cupao_id]) VALUES (N'carolinasilva09@hotmail.com', N'1U37L2GRMQ')
INSERT [perf].[cliente_usa_cupao] ([cliente_email], [cupao_id]) VALUES (N'joseferreira@hotmail.pt', N'JCZTW2BT7D')
INSERT [perf].[cliente_usa_cupao] ([cliente_email], [cupao_id]) VALUES (N'pipamoreira@gmail.com', N'1U37L2GRMQ')
INSERT [perf].[cliente_usa_cupao] ([cliente_email], [cupao_id]) VALUES (N'pipamoreira@gmail.com', N'JCZTW2BT7D')
INSERT [perf].[cliente_usa_cupao] ([cliente_email], [cupao_id]) VALUES (N'sarapereiraa5@gmail.pt', N'YD60RJR24P')
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'afonsomelooo@outlook.com', 5)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'afonsomelooo@outlook.com', 13)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'alexandraneves@gmail.com', 5)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'alexandrelima25@hotmail.com', 15)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'aliceamaral1@hotmail.com', 12)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'anagonçalves1985@gmail.com', 6)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'anagonçalves1985@gmail.com', 7)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'andralves@gmail.com', 14)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'anitinhasousa@live.pt', 3)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'beazinha@hotmail.com', 4)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'beazinha@hotmail.com', 16)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'beazinha@hotmail.com', 20)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'carlosa24@outmail.com', 6)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'carlosa24@outmail.com', 18)
INSERT [perf].[clientefavorita] ([clienteemail], [produtoid]) VALUES (N'paulomatos31@gmail.com', 4)
SET IDENTITY_INSERT [perf].[compra] ON 

INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (1, N'397543100', CAST(N'2020-03-24T06:31:00' AS SmallDateTime), N'Paypal', N'pedrofernandes230@gmail.com', 0, 5)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (2, N'258759872', CAST(N'2020-03-24T10:31:00' AS SmallDateTime), N'MB Way', N'anagonçalves1985@gmail.com', 0, 0)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (3, N'457253189', CAST(N'2020-03-25T06:31:00' AS SmallDateTime), N'MasterCard', N'joseferreira@hotmail.pt', 0, 0)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (4, N'302167890', CAST(N'2020-03-25T22:31:00' AS SmallDateTime), N'Visa', N'antonio_ze@gmail.com', 0, 0)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (5, N'592165320', CAST(N'2020-03-26T06:31:00' AS SmallDateTime), N'Visa', N'carolinasilva09@hotmail.com', 0, 0)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (6, N'592165320', CAST(N'2020-03-27T06:31:00' AS SmallDateTime), N'Visa', N'carolinasilva09@hotmail.com', 0, 0)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (7, N'592165320', CAST(N'2020-03-28T06:31:00' AS SmallDateTime), N'Visa', N'carolinasilva09@hotmail.com', 0, 10)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (8, N'457253189', CAST(N'2020-03-28T06:32:00' AS SmallDateTime), N'MasterCard', N'joseferreira@hotmail.pt', 50, 0)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (9, N'476638927', CAST(N'2020-03-28T06:32:00' AS SmallDateTime), N'MasterCard', N'anitinhasousa@live.pt', 0, 0)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (10, N'476638927', CAST(N'2020-03-28T06:33:00' AS SmallDateTime), N'MasterCard', N'anitinhasousa@live.pt', 0, 0)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (11, N'258759872', CAST(N'2020-03-30T06:31:00' AS SmallDateTime), N'MB Way', N'anagonçalves1985@gmail.com', 0, 30)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (12, N'258759872', CAST(N'2020-04-01T06:31:00' AS SmallDateTime), N'MB Way', N'anagonçalves1985@gmail.com', 0, 0)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (13, N'258759872', CAST(N'2020-04-01T07:31:00' AS SmallDateTime), N'MB Way', N'anagonçalves1985@gmail.com', 0, 40)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (14, N'397543100', CAST(N'2020-04-01T07:41:00' AS SmallDateTime), N'Paypal', N'pedrofernandes230@gmail.com', 20, 0)
INSERT [perf].[compra] ([numero], [contribuinte], [datacompra], [pagamento], [clienteemail], [pontosgastos], [pontosacumulados]) VALUES (15, N'602941753', CAST(N'2020-04-01T07:51:00' AS SmallDateTime), N'Paypal', N'andralves@gmail.com', 100, 0)
SET IDENTITY_INSERT [perf].[compra] OFF
INSERT [perf].[compra_online] ([numero], [rating], [observacao], [rastreamento], [presente], [contactoid]) VALUES (2, N'4', NULL, N'hWvk5n2S5YBwS08wHRO9', 1, 1)
INSERT [perf].[compra_online] ([numero], [rating], [observacao], [rastreamento], [presente], [contactoid]) VALUES (3, NULL, NULL, NULL, 0, 4)
INSERT [perf].[compra_online] ([numero], [rating], [observacao], [rastreamento], [presente], [contactoid]) VALUES (6, N'3', NULL, N'8cfd8bwW2hR4cAxxkDTC', 0, 12)
INSERT [perf].[compra_online] ([numero], [rating], [observacao], [rastreamento], [presente], [contactoid]) VALUES (7, N'5', N'Muito bom produto!', NULL, 0, 3)
INSERT [perf].[compra_online] ([numero], [rating], [observacao], [rastreamento], [presente], [contactoid]) VALUES (8, N'4', N'Poderia ter sido mais rapido a ser entregue', NULL, 0, 7)
INSERT [perf].[compra_online] ([numero], [rating], [observacao], [rastreamento], [presente], [contactoid]) VALUES (10, NULL, NULL, NULL, 1, 20)
INSERT [perf].[compra_online] ([numero], [rating], [observacao], [rastreamento], [presente], [contactoid]) VALUES (11, NULL, NULL, NULL, 0, 11)
INSERT [perf].[compra_online] ([numero], [rating], [observacao], [rastreamento], [presente], [contactoid]) VALUES (14, N'5', N'Bom produto e rápida entrega', N'pbFcSarhTbZqz5wTk7mk', 1, 1)
INSERT [perf].[compra_online] ([numero], [rating], [observacao], [rastreamento], [presente], [contactoid]) VALUES (15, NULL, NULL, NULL, 0, 2)
INSERT [perf].[compra_presencial] ([numero], [funcemail]) VALUES (1, N'Criscosta@outlook.com')
INSERT [perf].[compra_presencial] ([numero], [funcemail]) VALUES (4, N'franciscopereira@gmail.com')
INSERT [perf].[compra_presencial] ([numero], [funcemail]) VALUES (5, N'Criscosta@outlook.com')
INSERT [perf].[compra_presencial] ([numero], [funcemail]) VALUES (9, N'Criscosta@outlook.com')
INSERT [perf].[compra_presencial] ([numero], [funcemail]) VALUES (12, N'franciscopereira@gmail.com')
INSERT [perf].[compra_presencial] ([numero], [funcemail]) VALUES (13, N'adrialmeida08@live.pt')
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (1, 13, 2)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (2, 2, 1)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (2, 3, 1)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (2, 7, 1)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (3, 6, 2)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (4, 8, 1)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (4, 10, 3)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (4, 14, 2)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (4, 20, 1)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (5, 1, 2)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (6, 8, 2)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (7, 3, 3)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (8, 23, 1)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (9, 11, 2)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (10, 23, 3)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (11, 21, 4)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (12, 15, 2)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (13, 13, 1)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (14, 1, 2)
INSERT [perf].[compra_tem_produto] ([compranumero], [produtoid], [unidades]) VALUES (15, 3, 3)
SET IDENTITY_INSERT [perf].[contacto] ON 

INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (1, N'pipamoreira@gmail.com', N'914363252', 0, N'3780-548', N'Portugal', N'Rua das Palmeiras', NULL, N'Tamengos')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (2, N'franciscopereira@gmail.com', N'924763965', 1, N'3810-082', N'Portugal', N'Avenida 5 de Outubro', N'Nº9', N'Aveiro')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (3, N'pedrofernandes230@gmail.com', N'914274915', 1, N'4750-765', N'Portugal', N'Rua do Rego', N'Nº5', N'Ucha')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (4, N'beazinha@hotmail.com', N'964829602', 1, N'4705-475', N'Portugal', N'Rua dos Azinhais', N'Nº6', N'Esporões')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (5, N'beatrizsantos_01@outlook.com', N'935502152', 0, N'4715-475', N'Portugal', N'Rua do Souto', N'Nº5, 2º Esquerdo', N'Pedralva')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (6, N'adrialmeida08@live.pt', N'914628560', 0, N'2650-476', N'Portugal', N'Rua Olival de Cambra', N'Nº2, 3º Esquerdo', N'Amadora')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (7, N'Criscosta@outlook.com', N'963926453', 0, N'4420-133', N'Portugal', N'Rua Doutor Lopes Cardoso', N'Nº 3', N'Gondomar')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (8, N'carlosa24@outmail.com', N'921547935', 1, N'4635-265', N'Portugal', N'Rua de Lenteiros', N'Nº 5, 3º Direito', N'Santo Isidoro MCN')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (9, N'anagonçalves1985@gmail.com', N'918426539', 1, N'4455-110', N'Portugal', N'Travessa Francisco dos Santos', N'Nº 3', N'Lavra')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (10, N'aliceamaral1@hotmail.com', N'963159731', 1, N'4580-294', N'Portugal', N'Rua dos Agreões', N'Nº 7', N'Paredes')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (11, N'andralves@gmail.com', N'936267422', 1, N'4575-366', N'Portugal', N'Rua de Penidelo', NULL, N'Pinheiro PNF')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (12, N'paulomatos31@gmail.com', N'926375015', 1, N'2240-512', N'Portugal', N'Travessa da Capela', N'Nº3, 5º Direito', N'Paio Mendes')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (13, N'sarapereiraa5@gmail.pt', N'963216832', 0, N'2810-168', N'Portugal', N'Rua Doutor António Elvas', N'BMP 1, 3º Esquerdo', N'Almada')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (14, N'sofiabarbosa@live.pt', N'915392054', 0, N'2855-727', N'Portugal', N'Praça José Queluz', NULL, N'Corroios')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (15, N'antonio_ze@gmail.com', N'964667921', 0, N'2855-713', N'Portugal', N'Rua Mário Castrim', N'Nº 5', N'Corroios')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (16, N'carolinasilva09@hotmail.com', N'962468333', 0, N'4925-345', N'Portugal', N'Rua de Lamelas', N'Nº 7', N'Cardielos')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (17, N'andralves@gmail.com', N'925488312', 0, N'5460-335', N'Portugal', N'Rua Doutor João Chaves', N'Nº 4', N'Boticas')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (18, N'alexandrelima25@hotmail.com', N'915424675', 0, N'5110-012', N'Portugal', N'Rua do Bairro Novo', NULL, N'Aldeias AMM')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (19, N'anitinhasousa@live.pt', N'963215352', 1, N'3750-864', N'Portugal', N'Travessa do Amaínho', N'Nº 2', N'Borralha')
INSERT [perf].[contacto] ([id], [utilizador_email], [telemovel], [visibilidade], [codigo_postal], [pais], [endereco], [apartamento], [localidade]) VALUES (20, N'pipamoreira@gmail.com', N'924583100', 1, N'3750-492', N'Portugal', N'Travessa dos Agueiros', NULL, N'Fermentelos')
SET IDENTITY_INSERT [perf].[contacto] OFF
INSERT [perf].[cosmetica] ([id], [tipo]) VALUES (23, N'Rosto')
INSERT [perf].[cosmetica] ([id], [tipo]) VALUES (24, N'Corpo')
INSERT [perf].[cosmetica] ([id], [tipo]) VALUES (25, N'Mãos e Pés')
INSERT [perf].[cupao] ([id], [datainicio], [datafim], [pontos_atribuidos]) VALUES (N'1U37L2GRMQ', CAST(N'2020-01-24T06:31:00' AS SmallDateTime), CAST(N'2022-08-24T06:31:00' AS SmallDateTime), 100)
INSERT [perf].[cupao] ([id], [datainicio], [datafim], [pontos_atribuidos]) VALUES (N'5VMGOKER2V', CAST(N'2020-10-24T02:31:00' AS SmallDateTime), CAST(N'2020-11-24T06:31:00' AS SmallDateTime), 50)
INSERT [perf].[cupao] ([id], [datainicio], [datafim], [pontos_atribuidos]) VALUES (N'ASTRGDEW32', CAST(N'2019-07-24T06:31:00' AS SmallDateTime), CAST(N'2020-08-24T06:31:00' AS SmallDateTime), 50)
INSERT [perf].[cupao] ([id], [datainicio], [datafim], [pontos_atribuidos]) VALUES (N'C69RTAUFQJ', CAST(N'2020-07-24T00:31:00' AS SmallDateTime), CAST(N'2020-08-30T06:31:00' AS SmallDateTime), 150)
INSERT [perf].[cupao] ([id], [datainicio], [datafim], [pontos_atribuidos]) VALUES (N'FIMVERAO20', CAST(N'2020-09-24T06:31:00' AS SmallDateTime), CAST(N'2020-10-24T06:31:00' AS SmallDateTime), 150)
INSERT [perf].[cupao] ([id], [datainicio], [datafim], [pontos_atribuidos]) VALUES (N'FU37L2GRMQ', CAST(N'2021-07-24T06:31:00' AS SmallDateTime), CAST(N'2022-08-24T06:31:00' AS SmallDateTime), 400)
INSERT [perf].[cupao] ([id], [datainicio], [datafim], [pontos_atribuidos]) VALUES (N'INICIOVERA', CAST(N'2020-07-24T06:31:00' AS SmallDateTime), CAST(N'2020-08-24T06:31:00' AS SmallDateTime), 50)
INSERT [perf].[cupao] ([id], [datainicio], [datafim], [pontos_atribuidos]) VALUES (N'JCZTW2BT7D', CAST(N'2020-02-24T06:31:00' AS SmallDateTime), CAST(N'2025-08-24T06:31:00' AS SmallDateTime), 50)
INSERT [perf].[cupao] ([id], [datainicio], [datafim], [pontos_atribuidos]) VALUES (N'JCZTWIBT7D', CAST(N'2023-07-24T10:31:00' AS SmallDateTime), CAST(N'2025-08-24T06:31:00' AS SmallDateTime), 300)
INSERT [perf].[cupao] ([id], [datainicio], [datafim], [pontos_atribuidos]) VALUES (N'WIHKFJ8VVH', CAST(N'2020-12-24T06:31:00' AS SmallDateTime), CAST(N'2021-01-24T06:31:00' AS SmallDateTime), 2000)
INSERT [perf].[cupao] ([id], [datainicio], [datafim], [pontos_atribuidos]) VALUES (N'YD60RJR24P', CAST(N'2020-03-24T06:31:00' AS SmallDateTime), CAST(N'2022-08-24T06:31:00' AS SmallDateTime), 200)
INSERT [perf].[funcionario] ([email], [administrator], [salario]) VALUES (N'adrialmeida08@live.pt', 1, 850)
INSERT [perf].[funcionario] ([email], [administrator], [salario]) VALUES (N'beatrizsantos_01@outlook.com', 2, 1200)
INSERT [perf].[funcionario] ([email], [administrator], [salario]) VALUES (N'Criscosta@outlook.com', 0, 750)
INSERT [perf].[funcionario] ([email], [administrator], [salario]) VALUES (N'franciscopereira@gmail.com', 0, 700)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'adrialmeida08@live.pt', 14, 40, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'adrialmeida08@live.pt', 16, 5, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'adrialmeida08@live.pt', 17, 25, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'adrialmeida08@live.pt', 18, 60, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'adrialmeida08@live.pt', 19, 120, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 1, 60, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 2, 20, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 3, 15, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 4, 8, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 5, 20, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 6, 15, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 7, 30, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 8, 15, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 9, 40, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 10, 25, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 11, 5, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 12, 15, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 13, 25, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 14, 30, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 15, 15, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 16, 5, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 17, 25, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 18, 45, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', 19, 120, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'Criscosta@outlook.com', 1, 80, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'Criscosta@outlook.com', 2, 30, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'Criscosta@outlook.com', 3, 30, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'Criscosta@outlook.com', 5, 35, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'Criscosta@outlook.com', 6, 20, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'Criscosta@outlook.com', 10, 25, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'Criscosta@outlook.com', 12, 20, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'Criscosta@outlook.com', 13, 30, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'Criscosta@outlook.com', 15, 20, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'Criscosta@outlook.com', 18, 55, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'Criscosta@outlook.com', 19, 120, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'franciscopereira@gmail.com', 1, 90, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'franciscopereira@gmail.com', 3, 25, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'franciscopereira@gmail.com', 4, 10, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'franciscopereira@gmail.com', 7, 55, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'franciscopereira@gmail.com', 8, 15, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'franciscopereira@gmail.com', 9, 75, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'franciscopereira@gmail.com', 11, 5, 0)
INSERT [perf].[funcionario_faz_servico] ([funcionario_email], [servico_id], [duracao_media], [deleted]) VALUES (N'franciscopereira@gmail.com', 19, 120, 0)
SET IDENTITY_INSERT [perf].[marcacao] ON 

INSERT [perf].[marcacao] ([id], [cliente_email], [servico_id], [funcionario_email], [dataMarc], [deleted]) VALUES (1, N'joseferreira@hotmail.pt', 1, N'franciscopereira@gmail.com', CAST(N'2020-05-15T16:30:00' AS SmallDateTime), 0)
INSERT [perf].[marcacao] ([id], [cliente_email], [servico_id], [funcionario_email], [dataMarc], [deleted]) VALUES (2, N'antonio_ze@gmail.com', 12, N'Criscosta@outlook.com', CAST(N'2020-06-14T09:30:00' AS SmallDateTime), 0)
INSERT [perf].[marcacao] ([id], [cliente_email], [servico_id], [funcionario_email], [dataMarc], [deleted]) VALUES (3, N'aliceamaral1@hotmail.com', 16, N'Criscosta@outlook.com', CAST(N'2020-05-11T19:00:00' AS SmallDateTime), 0)
INSERT [perf].[marcacao] ([id], [cliente_email], [servico_id], [funcionario_email], [dataMarc], [deleted]) VALUES (4, N'paulomatos31@gmail.com', 3, N'adrialmeida08@live.pt', CAST(N'2020-06-03T15:00:00' AS SmallDateTime), 0)
INSERT [perf].[marcacao] ([id], [cliente_email], [servico_id], [funcionario_email], [dataMarc], [deleted]) VALUES (5, N'alexandrelima25@hotmail.com', 9, N'franciscopereira@gmail.com', CAST(N'2020-07-02T11:30:00' AS SmallDateTime), 0)
INSERT [perf].[marcacao] ([id], [cliente_email], [servico_id], [funcionario_email], [dataMarc], [deleted]) VALUES (6, N'joseferreira@hotmail.pt', 4, N'Criscosta@outlook.com', CAST(N'2020-05-17T17:30:00' AS SmallDateTime), 0)
INSERT [perf].[marcacao] ([id], [cliente_email], [servico_id], [funcionario_email], [dataMarc], [deleted]) VALUES (7, N'alexandrelima25@hotmail.com', 19, N'franciscopereira@gmail.com', CAST(N'2020-05-23T14:15:00' AS SmallDateTime), 0)
SET IDENTITY_INSERT [perf].[marcacao] OFF
INSERT [perf].[perfume] ([id]) VALUES (1)
INSERT [perf].[perfume] ([id]) VALUES (2)
INSERT [perf].[perfume] ([id]) VALUES (3)
INSERT [perf].[perfume] ([id]) VALUES (4)
INSERT [perf].[perfume] ([id]) VALUES (5)
INSERT [perf].[perfume] ([id]) VALUES (6)
INSERT [perf].[perfume] ([id]) VALUES (7)
INSERT [perf].[perfume] ([id]) VALUES (8)
INSERT [perf].[perfume] ([id]) VALUES (9)
INSERT [perf].[perfume] ([id]) VALUES (10)
INSERT [perf].[perfume] ([id]) VALUES (11)
INSERT [perf].[perfume] ([id]) VALUES (12)
INSERT [perf].[perfume] ([id]) VALUES (13)
INSERT [perf].[perfume] ([id]) VALUES (14)
INSERT [perf].[perfume] ([id]) VALUES (15)
INSERT [perf].[perfume] ([id]) VALUES (16)
INSERT [perf].[perfume] ([id]) VALUES (17)
INSERT [perf].[perfume] ([id]) VALUES (18)
INSERT [perf].[perfume] ([id]) VALUES (19)
INSERT [perf].[perfume] ([id]) VALUES (20)
INSERT [perf].[perfume] ([id]) VALUES (21)
INSERT [perf].[perfume] ([id]) VALUES (22)
SET IDENTITY_INSERT [perf].[produto] ON 

INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (1, 75.25, N'Cítrico Masculino', N'Eau de Toilette', N'Wanted', N'AZZARO', N'Azzaro Wanted', 100, N'Azzaro Wanted é um tributo a uma nova forma de masculinidade livre e resplandecente. Uma eau de toilette amadeirada, cítrica e condimentada com um rasto cativante e elegante.', N'https://www.perfumesecompanhia.pt/fotos/produtos/3351500002696.jpg', 5, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (2, 71.3, N'Amadeirado Masculino', N'Eau de Toilette', N'Wanted', N'AZZARO', N'Azzaro Wanted', 100, N'Azzaro Wanted é um tributo a uma nova forma de masculinidade livre e resplandecente. Uma eau de toilette amadeirada, cítrica e condimentada com um rasto cativante e elegante.', N'https://www.perfumesecompanhia.pt/fotos/produtos/3351500002696.jpg', 3, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (3, 81.65, N'Amadeirado Masculino', N'Eau de Toilette', N'Pour Homme', N'AZZARO', N'Azzaro Pour Homme', 100, N'Azzaro Pour Homme é um perfume de sedução em estado puro, talhado pela elegância e pelo requinte italiano.', N'https://www.perfumesecompanhia.pt/fotos/produtos/3351500980543_1.jpg', 5, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (4, 27.2, NULL, N'Deo Spray', N'Pour Homme', N'AZZARO', N'Azzaro Pour Homme', 150, N'Num gesto só, este spray oferece uma proteção eficaz de longa duração e uma sensação de frescura, durante todo o dia. ', N'https://www.perfumesecompanhia.pt/fotos/produtos/3351500002771_1.jpg', 4, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (5, 77.3, N'Floral Feminino', N'Eau de Parfum', N'212 Vip Rosé', N'CAROLINA HERRERA', NULL, 50, N'Atrevida, sofisticada, sempre pronta para a acção de noite & dia, o NOVO 212 VIP ROSÉ Eau de Parfum introduz uma ainda maior sedução ao universo! ', N'https://www.perfumesecompanhia.pt/fotos/produtos/8411061777176.jpg', 10, N'Mulher', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (6, 75.25, NULL, N'Eau de Toilette', N'Under The Pole', N'AZZARO', N'Azzaro Chrome', 100, N'A assinatura emblemática de Chrome —um acorde cítrico e amadeirado, ao qual se acrescenta um grande coração aquático, que inspira frescura e força — é reinterpretada numa fórmula original 100% sem álcool, substituído pela água. ', N'https://www.perfumesecompanhia.pt/fotos/produtos/3351500009756_1.jpg', 3, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (7, 78.71, N'Oriental Masculino', N'Eau de Toilette', N'The Scent', N'HUGO BOSS', N'The Scent', 50, N'Uma fragrância irresistível e inesquecível como o sabor da sedução. Notas exclusivas de gengibre, Maninka e couro que se revelam ao longo do tempo, seduzindo os sentidos.', N'https://www.perfumesecompanhia.pt/fotos/produtos/0737052972268.jpg', 3, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (8, 104.95, N'Oriental Masculino', N'Eau de Toilette', N'The Scent', N'HUGO BOSS', N'The Scent', 100, N'Uma fragrância irresistível e inesquecível como o sabor da sedução. Notas exclusivas de gengibre, Maninka e couro que se revelam ao longo do tempo, seduzindo os sentidos.', N'https://www.perfumesecompanhia.pt/fotos/produtos/0737052972268.jpg', 4, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (9, 140.65, N'Oriental Masculino', N'Eau de Toilette', N'The Scent', N'HUGO BOSS', N'The Scent', 200, N'Uma fragrância irresistível e inesquecível como o sabor da sedução. Notas exclusivas de gengibre, Maninka e couro que se revelam ao longo do tempo, seduzindo os sentidos.', N'https://www.perfumesecompanhia.pt/fotos/produtos/0737052972268.jpg', 5, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (10, 27.3, N'Oriental Masculino', N'Deo Stick', N'The Scent', N'HUGO BOSS', N'The Scent', 75, N'Uma fragrância irresistível e inesquecível como o sabor da sedução. Notas exclusivas de gengibre, Maninka e couro que se revelam ao longo do tempo, seduzindo os sentidos.', N'https://www.perfumesecompanhia.pt/fotos/produtos/0737052993546_1.jpg', 6, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (11, 27.3, N'Oriental Masculino', N'Deo Spray', N'The Scent', N'HUGO BOSS', N'The Scent', 150, N'Uma fragrância irresistível e inesquecível como o sabor da sedução. Notas exclusivas de gengibre, Maninka e couro que se revelam ao longo do tempo, seduzindo os sentidos.', N'https://www.perfumesecompanhia.pt/fotos/produtos/0737052992785_1.jpg', 7, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (12, 72.5, NULL, N'Eau de Toilette', N'Bad Boy', N'CAROLINA HERRERA', N'Bad Boy', 50, NULL, N'https://www.perfumesecompanhia.pt/fotos/produtos/8411061926093_1.jpg', 2, N'Mulher', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (13, 47.5, NULL, N'Body Cream', N'Light Blue', N'DOLCE&GABBANA', N'Light Blue', 200, NULL, N'https://www.perfumesecompanhia.pt/fotos/produtos/3423473020219_1.jpg', 5, N'Mulher', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (14, 77.9, NULL, N'Coffret', N'The Scent', N'HUGO BOSS', N'The Scent', NULL, NULL, N'https://www.perfumesecompanhia.pt/fotos/produtos/3614229279337_1.jpg', 5, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (15, 22.28, NULL, N'Eau de Toilette', N'Tommy', N'TOMMY HILFIGER', N'Tommy', 30, NULL, N'https://www.perfumesecompanhia.pt/fotos/produtos/0022548055373.jpg', 2, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (16, 39.95, NULL, N'Eau de Toilette', N'Tommy', N'TOMMY HILFIGER', N'Tommy', 50, NULL, N'https://www.perfumesecompanhia.pt/fotos/produtos/0022548055373.jpg', 3, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (17, 50.2, NULL, N'Eau de Toilette', N'Tommy', N'TOMMY HILFIGER', N'Tommy', 100, NULL, N'https://www.perfumesecompanhia.pt/fotos/produtos/0022548055373.jpg', 4, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (18, 24, NULL, N'Anti-Perspirant Deodorant ', N'Tommy', N'TOMMY HILFIGER', N'Tommy', 75, NULL, N'https://www.perfumesecompanhia.pt/fotos/produtos/0022548024355_1.jpg', 2, N'Homem', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (19, 29.7, NULL, N'Eau de Toilette', N'Tommy Girl', N'TOMMY HILFIGER', NULL, 30, NULL, N'https://www.perfumesecompanhia.pt/fotos/produtos/0022548055380.jpg', 5, N'Mulher', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (20, 39.95, NULL, N'Eau de Toilette', N'Tommy Girl', N'TOMMY HILFIGER', NULL, 50, NULL, N'https://www.perfumesecompanhia.pt/fotos/produtos/0022548055380.jpg', 6, N'Mulher', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (21, 47.45, NULL, N'Eau de Cologne', N'Baby', N'TOUS', NULL, 100, N'Ninguém é mais espontâneo que os pequenos da casa. Eles e o seu mundo contagiam-nos de alegria e entusiasmo, delicadeza e ternura. Fazem-nos recordar nas memórias mais profundas, a criança que todos temos dentro de nós.', N'https://www.perfumesecompanhia.pt/fotos/produtos/8436038831125.jpg', 4, N'Criança', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (22, 43, N'Floral Feminino', N'Eau de Senteur', N'Bébé', N'JACADI', NULL, 100, N'Perfume sem alcool para bébé (a partir dos 3 meses). Unisexo', N'https://www.perfumesecompanhia.pt/fotos/produtos/7613107400012_1.jpg', 5, N'Criança', 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (23, 38.65, NULL, N'Desmaquilhante Olhos', N'Bi-Facil', N'LANCÔME', NULL, 125, NULL, N'https://www.perfumesecompanhia.pt/fotos/produtos/3147758030334.jpg', 6, NULL, 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (24, 22, NULL, N'Tónico de Banho', N'Corpo', N'CLARINS', NULL, 200, N'Para transformar cada cm² da sua pele e a tornar mais lisa e bela - mais tonificada, mais fina e maravilhosamente nutrida. ', N'https://www.perfumesecompanhia.pt/fotos/produtos/3380810667103.jpg', 1, NULL, 0)
INSERT [perf].[produto] ([id], [preco], [familiaolfativa], [categoria], [nome], [marca], [linha], [tamanho], [descricao], [imagem], [stock], [destinatario], [deleted]) VALUES (25, 32.95, NULL, N'Cuidados de Pés', N'Bálsamo de Pés', N'GAMILA SECRET', NULL, 100, NULL, N'https://www.perfumesecompanhia.pt/fotos/produtos/8717625545688_1.jpg', 3, NULL, 0)
SET IDENTITY_INSERT [perf].[produto] OFF
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (1, 1)
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (2, 1)
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (3, 1)
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (4, 1)
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (5, 5)
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (6, 1)
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (7, 4)
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (8, 4)
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (9, 4)
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (10, 4)
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (11, 4)
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (12, 5)
INSERT [perf].[produto_tem_promocao] ([produtoid], [promocaoid]) VALUES (14, 4)
SET IDENTITY_INSERT [perf].[promocao] ON 

INSERT [perf].[promocao] ([id], [nome], [desconto], [datainicio], [datafim]) VALUES (1, N'Azzaro', 5, CAST(N'2020-03-24T06:31:00' AS SmallDateTime), CAST(N'2020-07-24T06:31:00' AS SmallDateTime))
INSERT [perf].[promocao] ([id], [nome], [desconto], [datainicio], [datafim]) VALUES (2, N'Natal', 15, CAST(N'2020-12-20T06:31:00' AS SmallDateTime), CAST(N'2020-12-25T06:31:00' AS SmallDateTime))
INSERT [perf].[promocao] ([id], [nome], [desconto], [datainicio], [datafim]) VALUES (3, N'Black Weekend', 25, CAST(N'2020-11-27T00:00:00' AS SmallDateTime), CAST(N'2020-11-29T06:31:00' AS SmallDateTime))
INSERT [perf].[promocao] ([id], [nome], [desconto], [datainicio], [datafim]) VALUES (4, N'Hugo Boss', 7, CAST(N'2020-02-22T00:00:00' AS SmallDateTime), CAST(N'2020-11-29T06:31:00' AS SmallDateTime))
INSERT [perf].[promocao] ([id], [nome], [desconto], [datainicio], [datafim]) VALUES (5, N'Carolina Herrera', 10, CAST(N'2020-03-27T00:00:00' AS SmallDateTime), CAST(N'2020-11-29T06:31:00' AS SmallDateTime))
INSERT [perf].[promocao] ([id], [nome], [desconto], [datainicio], [datafim]) VALUES (6, N'Tommy Hilfiger', 10, CAST(N'2020-04-27T00:00:00' AS SmallDateTime), CAST(N'2020-11-29T06:31:00' AS SmallDateTime))
INSERT [perf].[promocao] ([id], [nome], [desconto], [datainicio], [datafim]) VALUES (7, N'Dia da Mãe', 12, CAST(N'2021-05-01T00:00:00' AS SmallDateTime), CAST(N'2021-05-04T00:00:00' AS SmallDateTime))
INSERT [perf].[promocao] ([id], [nome], [desconto], [datainicio], [datafim]) VALUES (8, N'Dia dos Namorados', 14, CAST(N'2021-02-10T00:00:00' AS SmallDateTime), CAST(N'2021-02-15T00:00:00' AS SmallDateTime))
INSERT [perf].[promocao] ([id], [nome], [desconto], [datainicio], [datafim]) VALUES (9, N'Dia do Pai', 9, CAST(N'2021-03-17T00:00:00' AS SmallDateTime), CAST(N'2021-03-20T00:00:00' AS SmallDateTime))
INSERT [perf].[promocao] ([id], [nome], [desconto], [datainicio], [datafim]) VALUES (10, N'Páscoa', 11, CAST(N'2021-04-10T00:00:00' AS SmallDateTime), CAST(N'2021-04-13T00:00:00' AS SmallDateTime))
SET IDENTITY_INSERT [perf].[promocao] OFF
SET IDENTITY_INSERT [perf].[servico] ON 

INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (1, N'Depilação', 45.5, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (2, N'Sobrancelhas', 7.5, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (3, N'Axilas', 12.8, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (4, N'Máscara de Rosto', 9.5, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (5, N'Manicure', 15, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (6, N'Pedicure', 10, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (7, N'Fotodepilação', 85, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (8, N'Massagem Costas', 35.7, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (9, N'Pressoterapia', 24.5, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (10, N'Tratamento anti-celulite', 47, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (11, N'Lifting Pestanas', 14.99, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (12, N'Maquilhagem', 17.9, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (13, N'Verniz gel', 13, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (14, N'Gel', 19.99, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (15, N'Acrílico', 25.15, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (16, N'Massagem Rosto', 23, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (17, N'Drenagem Linfática', 67.9, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (18, N'Peeling Corporal', 20.15, 0)
INSERT [perf].[servico] ([id], [tipo], [preco], [deleted]) VALUES (19, N'Limpeza de pele', 71, 0)
SET IDENTITY_INSERT [perf].[servico] OFF
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'adrialmeida08@live.pt', N'573975939', N'Adriana', N'Almeida', 0x28A114617C5A45EC8B8C2FCD2949B2EF20192A81971A287FFF305DED2136712685F61F5035268AA09AB83A052486CE423D96E1C9B3719E821972146248D51A40, 0, CAST(N'1999-02-08' AS Date), N'https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'afonsomelooo@outlook.com', N'821358756', N'Afonso', N'Melo', 0x36FBCF55BA4F767462DCFDC0BAF56B039B03C35A351B763CDACDF0F4D15099840C8B9A35D51F7E912B3C455C3FD535200380BF8FEB5F72EF744A737BF3A6B9DF, 1, CAST(N'1989-09-15' AS Date), N'https://images.pexels.com/photos/374044/pexels-photo-374044.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'alexandraneves@gmail.com', N'178495829', N'Alexandra', N'Neves', 0x948F64889513C22964F535980F36D02ABA15F634B9D833FA08FB4F30EBD92D8243A61A9C9ED38652AB762172953F0DC3FECBF0C928BD0B7E23418A2B04EC2459, 0, CAST(N'2004-10-06' AS Date), N'https://images.pexels.com/photos/1065084/pexels-photo-1065084.jpeg?auto=compress&cs=tinysrgb&dpr=3&h', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'alexandrelima25@hotmail.com', N'219589974', N'Alexandre', N'Lima', 0xA6682B8524EB8FCD8D80D77ABBCD9D41705C3240807E8101FAE180D0A3189B01D35EF82B25981EF960AF56208701A5CEDFF465714C272D32156F5ECAAF96ED2B, 1, CAST(N'1965-12-25' AS Date), N'https://images.pexels.com/photos/834863/pexels-photo-834863.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'aliceamaral1@hotmail.com', N'287352385', N'Alice', N'Amaral', 0xCC51D964705A4D2699C29F445A01FFFA5005E3F4CFC2C4191E9C637FE495BAEB02F327E2EC95CF21C9D4924025B5CAB81CA564FB1F59EB8E2AFBCED66B43B836, 0, CAST(N'2000-05-01' AS Date), N'https://images.pexels.com/photos/712513/pexels-photo-712513.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'anagonçalves1985@gmail.com', N'258759872', N'Ana', N'Gonçalves', 0x3786F5394BE41A6951B638BEDE2BD93921B6304DC7725BC020EDC49803D761D7FAFAAF3B14F0BE643FA0C55C803828B61CE244694E3329B9747D1DBC579A0670, 0, CAST(N'1985-01-20' AS Date), N'https://images.pexels.com/photos/1587009/pexels-photo-1587009.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'andralves@gmail.com', N'602941753', N'André', N'Alves', 0x88E883801CA63D6CD2E776BD14EB75E6FBCA42E36DFCF48E85350FE200ACAA390AE43243D51415693B3251B36847EEE22668C9FEAABD07D10F63C22174D3AD84, 1, CAST(N'2002-02-02' AS Date), N'https://images.pexels.com/photos/1384219/pexels-photo-1384219.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'anitinhasousa@live.pt', N'476638927', N'Anita', N'Sousa', 0xF6CEC653F88AD9BF302C843B1CDDC81A21C773193F44C534741AE062E33162747FFEAEC7B9B1A065B1DC14ABAF5330B08BD59254C89CF02FBD8182A59EB80730, 0, CAST(N'1998-03-14' AS Date), N'https://images.pexels.com/photos/709802/pexels-photo-709802.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'antonio_ze@gmail.com', N'302167890', N'Antonio', N'Silva', 0x0B92F3CF358326E141317A158AC3F15E4EE4801C0571A9ACCE9CF889F5070859CD585442D36F6C3F905F426CE323CB31638F5B721609C3DD39D4BC6C70BDB6B4, 1, CAST(N'1960-11-04' AS Date), N'https://images.pexels.com/photos/1138903/pexels-photo-1138903.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'beatrizsantos_01@outlook.com', N'998232166', N'Beatriz', N'Santos', 0xA2B0D96600E6971E6B5A71FE54DFDB87C739D5B2103CA9FBA2C79D770CDDEDDFD618F6C9B183387D2269E3FF0A295EBDF996D52E90F082E25834B9177DEF5DA7, 0, CAST(N'2002-01-23' AS Date), N'https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'beazinha@hotmail.com', N'455129988', N'Beatriz', N'Ferreira', 0xFF5714D6278E1762FA061EC9133C93824D4318F5412E9A3780E99D8B41AF22BFAA79C01046C816606321F4E27FAFD3CE3D5C0F7BC38D4E4C75964068450FAEDA, 0, CAST(N'2000-05-05' AS Date), N'https://images.pexels.com/photos/1858175/pexels-photo-1858175.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'carlosa24@outmail.com', N'125873530', N'Carlos', N'Amorim', 0xA219DF07454758716755284A1B9907273A2D7A184C70F34F53A810D33294282C64483CC426BBBD352D92FA4136740DB013555050A0FF81BF042B4A5B549FC121, 1, CAST(N'1972-06-24' AS Date), N'https://images.pexels.com/photos/1300402/pexels-photo-1300402.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'carolinasilva09@hotmail.com', N'592165320', N'Carolina', N'Silva', 0x17E2E5475D7A1748489ED91D435D6F72DCDF54DF12FDEEF4E5BD926BE87E047B91B6801A873ED7FE87FEDF18975D0D5CDF1E937B5051A547C8BA7B477BCD4A19, 0, CAST(N'1995-09-14' AS Date), N'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'Criscosta@outlook.com', N'129885782', N'Cristiana', N'Costa', 0x3295C9F0129ACCCB23DFBDB9388E9B71893E827EC97D1D5F1D5A154FEA0B2690747858EAE3E337AD1C252C27FB080F89312BDD8108E99F57782514B6FC8FE667, 0, CAST(N'1970-10-16' AS Date), N'https://images.pexels.com/photos/247322/pexels-photo-247322.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'franciscopereira@gmail.com', N'287567665', N'Francisco', N'Pereira', 0x542EC6266772048413184B7AB5B6CAE473D3539D92536438BC75A622FF40382CBFE499E8DB78C96C68679D9BEC7754F4F90F3A316416D089A161A2914C38FE1E, 1, CAST(N'1987-05-08' AS Date), N'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'joseferreira@hotmail.pt', N'457253189', N'José', N'Ferreira', 0x29A3F973A03E983C896CFA89619648C9C42508121E76822CDE65046628EC02723C5B7E474E41BC9653D29226FE0DB7F34288C4E72B6A0232A2852FD58F341835, 1, CAST(N'1994-02-03' AS Date), N'https://images.pexels.com/photos/736716/pexels-photo-736716.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'paulomatos31@gmail.com', N'593967351', N'Paulo', N'Matos', 0x43298CD84A76EB6FCE18912447472AFE74C9F60147B7EA9531336995434C70D202555B52EF9EFB44DAE817610C5DD27B07506D176025051559E6107A829B0FEE, 1, CAST(N'1979-05-31' AS Date), N'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'pedrofernandes230@gmail.com', N'397543100', N'Pedro', N'Fernandes', 0x23DE474AF78812F6581059DF34208DB119FBE8F29F19FBFB81C2749FE3E9A05E5C6E190527C7510300196C0685C81289FFA42826DDB29B2484D669913AEC70DD, 1, CAST(N'1998-12-06' AS Date), N'https://images.pexels.com/photos/594610/pexels-photo-594610.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'pipamoreira@gmail.com', N'445976504', N'Filipa', N'Moreira', 0x3A15E839F6CB9244F150DD9AAAC98BDBE983BB66523C4B6B4E00813012A019481AE554FBE800B93EA014C0633F715AC34F64E610719EE8E3BB5E48E17EA9FEE8, 0, CAST(N'1990-07-07' AS Date), N'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'sarapereiraa5@gmail.pt', N'123222985', N'Sara', N'Pereira', 0x4EBD51D68D856227851A41E3B3A10B74744822A986026A8C11BFC1F044B66A5369224C3CC98BBCBB343FC7F3524F7383DE6B1E679209214794DCB70770C1C810, 0, CAST(N'2005-12-22' AS Date), N'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg', NULL, 0)
INSERT [perf].[utilizador] ([email], [contribuinte], [fname], [lname], [pw], [sexo], [dataNasc], [foto], [contacto_default_id], [deleted]) VALUES (N'sofiabarbosa@live.pt', N'943212111', N'Sofia', N'Barbosa', 0xA9A96334B77DA932D4FC9951326F29F5AF5FBE746D9D73A9136F19E69A2849A29C6AFFD95760E298803F75B57F4CE3502354D4BB65842369B0BC644C224D7F29, 0, CAST(N'1999-05-12' AS Date), N'https://images.pexels.com/photos/1036622/pexels-photo-1036622.jpeg', NULL, 0)
ALTER TABLE [perf].[contacto] ADD  DEFAULT ((1)) FOR [visibilidade]
GO
ALTER TABLE [perf].[funcionario_faz_servico] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [perf].[marcacao] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [perf].[produto] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [perf].[servico] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [perf].[utilizador] ADD  DEFAULT ((0)) FOR [deleted]
GO
ALTER TABLE [perf].[cliente]  WITH CHECK ADD  CONSTRAINT [cliente_email_fr] FOREIGN KEY([email])
REFERENCES [perf].[cliente] ([email])
GO
ALTER TABLE [perf].[cliente] CHECK CONSTRAINT [cliente_email_fr]
GO
ALTER TABLE [perf].[cliente_usa_cupao]  WITH CHECK ADD  CONSTRAINT [clienteusacupao_clienteemail_fr] FOREIGN KEY([cliente_email])
REFERENCES [perf].[cliente] ([email])
GO
ALTER TABLE [perf].[cliente_usa_cupao] CHECK CONSTRAINT [clienteusacupao_clienteemail_fr]
GO
ALTER TABLE [perf].[cliente_usa_cupao]  WITH CHECK ADD  CONSTRAINT [clienteusacupao_cupaoid_fr] FOREIGN KEY([cupao_id])
REFERENCES [perf].[cupao] ([id])
GO
ALTER TABLE [perf].[cliente_usa_cupao] CHECK CONSTRAINT [clienteusacupao_cupaoid_fr]
GO
ALTER TABLE [perf].[clientefavorita]  WITH CHECK ADD  CONSTRAINT [clientefavorita_clienteemail_fr] FOREIGN KEY([clienteemail])
REFERENCES [perf].[cliente] ([email])
GO
ALTER TABLE [perf].[clientefavorita] CHECK CONSTRAINT [clientefavorita_clienteemail_fr]
GO
ALTER TABLE [perf].[clientefavorita]  WITH CHECK ADD  CONSTRAINT [clientefavorita_produtoid_fr] FOREIGN KEY([produtoid])
REFERENCES [perf].[produto] ([id])
GO
ALTER TABLE [perf].[clientefavorita] CHECK CONSTRAINT [clientefavorita_produtoid_fr]
GO
ALTER TABLE [perf].[compra]  WITH CHECK ADD  CONSTRAINT [compra_clienteemail_fr] FOREIGN KEY([clienteemail])
REFERENCES [perf].[cliente] ([email])
GO
ALTER TABLE [perf].[compra] CHECK CONSTRAINT [compra_clienteemail_fr]
GO
ALTER TABLE [perf].[compra_online]  WITH CHECK ADD  CONSTRAINT [compra_online_contactoid_fr] FOREIGN KEY([contactoid])
REFERENCES [perf].[contacto] ([id])
GO
ALTER TABLE [perf].[compra_online] CHECK CONSTRAINT [compra_online_contactoid_fr]
GO
ALTER TABLE [perf].[compra_online]  WITH CHECK ADD  CONSTRAINT [compra_online_numero_fr] FOREIGN KEY([numero])
REFERENCES [perf].[compra] ([numero])
GO
ALTER TABLE [perf].[compra_online] CHECK CONSTRAINT [compra_online_numero_fr]
GO
ALTER TABLE [perf].[compra_presencial]  WITH CHECK ADD  CONSTRAINT [compra_presencial_funcemail_fr] FOREIGN KEY([funcemail])
REFERENCES [perf].[funcionario] ([email])
GO
ALTER TABLE [perf].[compra_presencial] CHECK CONSTRAINT [compra_presencial_funcemail_fr]
GO
ALTER TABLE [perf].[compra_presencial]  WITH CHECK ADD  CONSTRAINT [compra_presencial_numero_fr] FOREIGN KEY([numero])
REFERENCES [perf].[compra] ([numero])
GO
ALTER TABLE [perf].[compra_presencial] CHECK CONSTRAINT [compra_presencial_numero_fr]
GO
ALTER TABLE [perf].[compra_tem_produto]  WITH CHECK ADD  CONSTRAINT [compra_tem_produto_compranumero_fr] FOREIGN KEY([compranumero])
REFERENCES [perf].[compra] ([numero])
GO
ALTER TABLE [perf].[compra_tem_produto] CHECK CONSTRAINT [compra_tem_produto_compranumero_fr]
GO
ALTER TABLE [perf].[compra_tem_produto]  WITH CHECK ADD  CONSTRAINT [compra_tem_produto_produtoid_fr] FOREIGN KEY([produtoid])
REFERENCES [perf].[produto] ([id])
GO
ALTER TABLE [perf].[compra_tem_produto] CHECK CONSTRAINT [compra_tem_produto_produtoid_fr]
GO
ALTER TABLE [perf].[contacto]  WITH CHECK ADD  CONSTRAINT [contacto_utilizadoremail_fr] FOREIGN KEY([utilizador_email])
REFERENCES [perf].[utilizador] ([email])
GO
ALTER TABLE [perf].[contacto] CHECK CONSTRAINT [contacto_utilizadoremail_fr]
GO
ALTER TABLE [perf].[cosmetica]  WITH CHECK ADD  CONSTRAINT [cosmetica_id_fr] FOREIGN KEY([id])
REFERENCES [perf].[produto] ([id])
GO
ALTER TABLE [perf].[cosmetica] CHECK CONSTRAINT [cosmetica_id_fr]
GO
ALTER TABLE [perf].[funcionario]  WITH CHECK ADD  CONSTRAINT [funcionario_email_fr] FOREIGN KEY([email])
REFERENCES [perf].[utilizador] ([email])
GO
ALTER TABLE [perf].[funcionario] CHECK CONSTRAINT [funcionario_email_fr]
GO
ALTER TABLE [perf].[funcionario_faz_servico]  WITH CHECK ADD  CONSTRAINT [func_faz_serv_funcionario_email_fr] FOREIGN KEY([funcionario_email])
REFERENCES [perf].[funcionario] ([email])
GO
ALTER TABLE [perf].[funcionario_faz_servico] CHECK CONSTRAINT [func_faz_serv_funcionario_email_fr]
GO
ALTER TABLE [perf].[funcionario_faz_servico]  WITH CHECK ADD  CONSTRAINT [func_faz_serv_servicoid_fr] FOREIGN KEY([servico_id])
REFERENCES [perf].[servico] ([id])
GO
ALTER TABLE [perf].[funcionario_faz_servico] CHECK CONSTRAINT [func_faz_serv_servicoid_fr]
GO
ALTER TABLE [perf].[marcacao]  WITH CHECK ADD  CONSTRAINT [marcacao_clienteemail_fr] FOREIGN KEY([cliente_email])
REFERENCES [perf].[cliente] ([email])
GO
ALTER TABLE [perf].[marcacao] CHECK CONSTRAINT [marcacao_clienteemail_fr]
GO
ALTER TABLE [perf].[marcacao]  WITH CHECK ADD  CONSTRAINT [marcacao_funcemail_fr] FOREIGN KEY([funcionario_email])
REFERENCES [perf].[funcionario] ([email])
GO
ALTER TABLE [perf].[marcacao] CHECK CONSTRAINT [marcacao_funcemail_fr]
GO
ALTER TABLE [perf].[marcacao]  WITH CHECK ADD  CONSTRAINT [marcacao_servicoid_fr] FOREIGN KEY([servico_id])
REFERENCES [perf].[servico] ([id])
GO
ALTER TABLE [perf].[marcacao] CHECK CONSTRAINT [marcacao_servicoid_fr]
GO
ALTER TABLE [perf].[perfume]  WITH CHECK ADD  CONSTRAINT [perfume_id_fr] FOREIGN KEY([id])
REFERENCES [perf].[produto] ([id])
GO
ALTER TABLE [perf].[perfume] CHECK CONSTRAINT [perfume_id_fr]
GO
ALTER TABLE [perf].[produto_tem_promocao]  WITH CHECK ADD  CONSTRAINT [produto_tem_promocao_produtoid_fr] FOREIGN KEY([produtoid])
REFERENCES [perf].[produto] ([id])
GO
ALTER TABLE [perf].[produto_tem_promocao] CHECK CONSTRAINT [produto_tem_promocao_produtoid_fr]
GO
ALTER TABLE [perf].[produto_tem_promocao]  WITH CHECK ADD  CONSTRAINT [produto_tem_promocao_promocaoid_fr] FOREIGN KEY([promocaoid])
REFERENCES [perf].[promocao] ([id])
GO
ALTER TABLE [perf].[produto_tem_promocao] CHECK CONSTRAINT [produto_tem_promocao_promocaoid_fr]
GO
ALTER TABLE [perf].[utilizador]  WITH CHECK ADD  CONSTRAINT [utilizador_contactodefaultid_fr] FOREIGN KEY([contacto_default_id])
REFERENCES [perf].[contacto] ([id])
GO
ALTER TABLE [perf].[utilizador] CHECK CONSTRAINT [utilizador_contactodefaultid_fr]
GO
ALTER TABLE [perf].[promocao]  WITH CHECK ADD CHECK  (([desconto]>=(0) AND [desconto]<=(100)))
GO
/****** Object:  StoredProcedure [perf].[addContact]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[addContact]
    @utilizador_email VARCHAR(255),
    @telemovel CHAR(9),
    @codigo_postal CHAR(8),
    @pais VARCHAR(20),
    @endereco VARCHAR(50),
    @apartamento VARCHAR(10) = NULL,
    @localidade VARCHAR(20),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        INSERT INTO p6g1.perf.contacto
        (utilizador_email, telemovel, codigo_postal, pais, endereco, apartamento, localidade)
        VALUES(@utilizador_email, @telemovel, @codigo_postal, @pais, @endereco, @apartamento, @localidade) 
        SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage='Erro'
    END CATCH
END
GO
/****** Object:  StoredProcedure [perf].[addCupon]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[addCupon]
    @id CHAR(10),
    @datainicio SMALLDATETIME,
    @datafim SMALLDATETIME,
    @pontos_atribuidos INT,
    @emailFunc VARCHAR(255),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS(SELECT email FROM p6g1.perf.funcionario WHERE email=@emailFunc AND administrator=2)
            BEGIN
                IF EXISTS(SELECT id FROM p6g1.perf.cupao WHERE id=@id)
                    SET @responseMessage = 'Id do cupão já existe'
                ELSE
                BEGIN
                    INSERT INTO p6g1.perf.cupao
                    (id, datainicio, datafim, pontos_atribuidos)
                    VALUES(@id, @datainicio, @datafim, @pontos_atribuidos) 
                    SET @responseMessage='Success'
                END
            END
        ELSE
            SET @responseMessage='Permition denied'
    END TRY
    BEGIN CATCH
        SET @responseMessage='Failed'
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[addFuncService]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[addFuncService]
    @funcionario_email VARCHAR(255),
    @servico_id INT,
    @duracao_media INT,
    @emailFunc VARCHAR(255),
    @deleted BIT,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON  
    BEGIN TRY
        IF EXISTS(SELECT email FROM p6g1.perf.funcionario WHERE email=@emailFunc AND administrator=2)
            BEGIN
                INSERT INTO p6g1.perf.funcionario_faz_servico
                (funcionario_email, servico_id, duracao_media, deleted)
                VALUES(@funcionario_email, @servico_id, @duracao_media, @deleted) 
                SET @responseMessage='Success'
            END
        ELSE
            SET @responseMessage='Permition denied'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[addMarc]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [perf].[addMarc]
    @cliente_email VARCHAR(255),
    @servico_id INT,
    @funcionario_email VARCHAR(255),
    @dataMarc SMALLDATETIME,
    @responseMessage VARCHAR(250) = 'Erro! Tente noutra hora.' OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY	
		DECLARE @duracao INT
		SELECT @duracao = duracao_media FROM p6g1.perf.funcionario_faz_servico WHERE funcionario_email=@funcionario_email AND deleted = 0 AND  servico_id = @servico_id
			IF (@duracao IS NOT NULL AND @dataMarc > GETDATE()) 
			BEGIN
				IF (EXISTS(SELECT 1 FROM p6g1.perf.marcacao WHERE (dataMarc BETWEEN @dataMarc AND DATEADD(mi, @duracao, @dataMarc)) AND funcionario_email=@funcionario_email AND deleted=0) 
                OR EXISTS(SELECT 1 FROM p6g1.perf.marcacao WHERE dataMarc BETWEEN @dataMarc AND DATEADD(mi, @duracao, @dataMarc) AND cliente_email=@cliente_email AND deleted=0))
                SET @responseMessage = 'Hora não disponível!'
                ELSE
                BEGIN
				INSERT INTO p6g1.perf.marcacao
				(cliente_email, servico_id, funcionario_email, dataMarc)
				VALUES(@cliente_email, @servico_id, @funcionario_email, @dataMarc)

				SET @responseMessage='Marcação efetuado com sucesso!'
				END
			END
    END TRY
    BEGIN CATCH
        SET @responseMessage='Failure'
    END CATCH
	

END
GO
/****** Object:  StoredProcedure [perf].[addNewFunc]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[addNewFunc]
    @email VARCHAR(255),
    @contribuinte CHAR(9),
    @fname VARCHAR(20),
    @lname VARCHAR(20),
    @pw VARCHAR(25),
    @sexo BIT,
    @dataNasc DATETIME,
    @foto VARCHAR(100),
    @contacto_default_id INT = NULL,
    @administrator TINYINT,
    @salario INT,
    @emailFunc VARCHAR(255),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    BEGIN TRANSACTION
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS(SELECT email FROM p6g1.perf.funcionario WHERE email=@emailFunc AND administrator=2)
            BEGIN
                INSERT INTO p6g1.perf.utilizador
                (email, contribuinte, fname, lname, pw, sexo, dataNasc, foto, contacto_default_id)
                VALUES(@email, @contribuinte, @fname, @lname, HASHBYTES('SHA2_512', @pw), @sexo, @dataNasc, @foto, @contacto_default_id) 

                INSERT INTO p6g1.perf.funcionario
                (email, administrator, salario)
                VALUES(@email, @administrator, @salario) 

                SET @responseMessage='Success'
            END
        ELSE
            SET @responseMessage='Permition denied'
        COMMIT TRANSACTION    
    END TRY
    BEGIN CATCH
        SET @responseMessage='Failed'
        ROLLBACK
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[addProduct]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[addProduct]
    @preco FLOAT,
    @familiaolfativa VARCHAR(30) = NULL,
    @categoria VARCHAR(30),
    @nome VARCHAR(30),
    @marca VARCHAR(30),
    @linha VARCHAR(30),
    @tamanho SMALLINT = NULL,
    @descricao VARCHAR(280) = NULL,
    @imagem VARCHAR(100),
    @stock SMALLINT,
    @destinatario VARCHAR(10) = NULL,
    @emailFunc VARCHAR(255),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS(SELECT email FROM p6g1.perf.funcionario WHERE email=@emailFunc AND administrator>0)
            BEGIN
                INSERT INTO p6g1.perf.produto
                (preco, familiaolfativa, categoria, nome, marca, linha, tamanho, descricao, imagem, stock, destinatario)
                VALUES(@preco, @familiaolfativa, @categoria, @nome, @marca, @linha, @tamanho, @descricao, @imagem, @stock, @destinatario) 
                SET @responseMessage='Success'
            END
        ELSE
            SET @responseMessage='Permition denied'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH
END
GO
/****** Object:  StoredProcedure [perf].[addPromotion]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[addPromotion]
    @nome VARCHAR(30),
    @desconto TINYINT,
    @datainicio SMALLDATETIME,
    @datafim SMALLDATETIME,
    @emailFunc VARCHAR(255),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS(SELECT email FROM p6g1.perf.funcionario WHERE email=@emailFunc AND administrator=2)
            BEGIN
                INSERT INTO p6g1.perf.promocao
                (nome, desconto, datainicio, datafim)
                VALUES(@nome, @desconto, @datainicio, @datafim) 
                SET @responseMessage='Success'
            END
        ELSE
            SET @responseMessage='Permition denied'
    END TRY
    BEGIN CATCH
        SET @responseMessage='Failed'
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[addService]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [perf].[addService]
    @tipo  VARCHAR(40),
    @preco FLOAT,
    @emailFunc VARCHAR(255),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS(SELECT email FROM p6g1.perf.funcionario WHERE email=@emailFunc AND administrator=2)
            BEGIN
                INSERT INTO p6g1.perf.servico
                (tipo, preco)
                VALUES(@tipo, @preco) 
                SET @responseMessage='Success'
            END
        ELSE
            SET @responseMessage='Permition denied'
    END TRY
    BEGIN CATCH
        SET @responseMessage='Failed' 
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[buyProduct]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[buyProduct]
    @compranumero INT,
    @produtoid INT,
    @unidades INT,
    @responseMessage VARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        INSERT INTO p6g1.perf.compra_tem_produto
        (compranumero, produtoid, unidades)
        VALUES(@compranumero, @produtoid, @unidades) 
        SET @responseMessage='Success'
    END TRY
    BEGIN CATCH
        SET @responseMessage='Failure' 
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[changeDefaultContact]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[changeDefaultContact]
    @id INT,
    @email VARCHAR(255),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS(SELECT 1 FROM p6g1.perf.contacto WHERE id=@id)
            BEGIN
            IF EXISTS (SELECT 1 FROM p6g1.perf.utilizador WHERE email=@email AND contacto_default_id IS NOT NULL)
                IF EXISTS (SELECT 1 FROM p6g1.perf.utilizador WHERE email=@email AND contacto_default_id = @id)
                BEGIN
                    UPDATE p6g1.perf.utilizador
                    SET contacto_default_id= NULL
                    WHERE email=@email
                    SET @responseMessage='Successo!'
                END
                ELSE
                SET @responseMessage='Não é possível adicionar um contacto default antes de remover o atual.'
            ELSE
            BEGIN
                UPDATE p6g1.perf.utilizador
                SET contacto_default_id = @id
                WHERE email=@email
                SET @responseMessage='Successo!'
                END
            END
        ELSE
            SET @responseMessage='Permition denied'

    END TRY
    BEGIN CATCH
        SET @responseMessage='ERRO' 
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[changeProduct]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [perf].[changeProduct]
    @id INT,
    @preco FLOAT = 0,
    @familiaolfativa VARCHAR(30) = NULL,
    @categoria VARCHAR(30) = NULL,
    @nome VARCHAR(30)  = NULL,
    @marca VARCHAR(30)  = NULL,
    @linha VARCHAR(30)  = NULL,
    @tamanho SMALLINT = 0,
    @descricao VARCHAR(280) = NULL,
    @imagem VARCHAR(100)  = NULL,
    @stock SMALLINT = 0,
    @destinatario VARCHAR(10) = NULL,
	@deleted BIT = 0,
    @emailFunc VARCHAR(255)
AS
BEGIN
    BEGIN TRANSACTION
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS(SELECT email FROM p6g1.perf.funcionario WHERE email=@emailFunc AND administrator>0)
            BEGIN
                IF @preco <> 0
                BEGIN
                    UPDATE p6g1.perf.produto
                    SET preco = @preco
                    WHERE id = @id
                END

                IF @familiaolfativa IS NOT NULL
                BEGIN
                    UPDATE p6g1.perf.produto
                    SET familiaolfativa = @familiaolfativa
                    WHERE id = @id
                END

                IF @categoria IS NOT NULL
                BEGIN
                    UPDATE p6g1.perf.produto
                    SET categoria = @categoria
                    WHERE id = @id
                END

                IF @nome IS NOT NULL
                BEGIN
                    UPDATE p6g1.perf.produto
                    SET nome = @nome
                    WHERE id = @id
                END

                IF @marca IS NOT NULL
                BEGIN
                    UPDATE p6g1.perf.produto
                    SET marca = @marca
                    WHERE id = @id
                END

                IF @linha IS NOT NULL
                BEGIN
                    UPDATE p6g1.perf.produto
                    SET linha = @linha
                    WHERE id = @id
                END
                
                IF @tamanho <> 0
                BEGIN
                    UPDATE p6g1.perf.produto
                    SET tamanho = @tamanho
                    WHERE id = @id
                END

                IF @descricao IS NOT NULL
                BEGIN
                    UPDATE p6g1.perf.produto
                    SET descricao = @descricao
                    WHERE id = @id
                END

                IF @imagem IS NOT NULL
                BEGIN
                    UPDATE p6g1.perf.produto
                    SET imagem = @imagem
                    WHERE id = @id
                END

                IF @stock <> 0
                BEGIN
                    UPDATE p6g1.perf.produto
                    SET stock = @stock
                    WHERE id = @id
                END

                IF @destinatario IS NOT NULL
                BEGIN
                    UPDATE p6g1.perf.produto
                    SET destinatario = @destinatario
                    WHERE id = @id
                END
                
                UPDATE p6g1.perf.produto
                SET deleted = @deleted
                WHERE id = @id
            END
            COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
    ROLLBACK
    END CATCH
            
END
GO
/****** Object:  StoredProcedure [perf].[changeRating]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[changeRating]
    @clienteemail VARCHAR(255),
    @compranum INT,
    @rating CHAR(1),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS(SELECT 1 FROM (p6g1.perf.compra_online JOIN p6g1.perf.compra ON compra.numero=compra_online.numero) WHERE compra_online.numero=@compranum AND clienteemail=@clienteemail)
            BEGIN
                UPDATE p6g1.perf.compra_online
                SET rating = @rating
                WHERE numero=@compranum
                SET @responseMessage='Successo'
            END
        ELSE
            SET @responseMessage='Sem permissões!'
    END TRY
    BEGIN CATCH
        SET @responseMessage='Erro' 
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[clientAddFavourite]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[clientAddFavourite]
    @clienteemail VARCHAR(255),
    @produtoid INT,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        IF NOT EXISTS(SELECT produtoid FROM p6g1.perf.clientefavorita WHERE clienteemail=@clienteemail AND produtoid=@produtoid)
            BEGIN
                INSERT INTO p6g1.perf.clientefavorita
                (clienteemail, produtoid)
                VALUES(@clienteemail, @produtoid) 
                SET @responseMessage='Successo'
            END
        ELSE
            SET @responseMessage='Já existe!'
    END TRY
    BEGIN CATCH
        SET @responseMessage='Erro' 
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[clientRemoveFavourite]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[clientRemoveFavourite]
    @clienteemail VARCHAR(255),
    @produtoid INT,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS(SELECT produtoid FROM p6g1.perf.clientefavorita WHERE clienteemail=@clienteemail AND produtoid=@produtoid)
            BEGIN
                DELETE FROM p6g1.perf.clientefavorita
                WHERE clienteemail=@clienteemail AND produtoid=@produtoid
                SET @responseMessage='Successo'
            END
        ELSE
            SET @responseMessage='Produto não faz parte dos favoritos do utilizador!'
    END TRY
    BEGIN CATCH
        SET @responseMessage='Erro' 
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[clientUsesCupon]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[clientUsesCupon]
    @cliente_email VARCHAR(255),
    @cupao_id CHAR(10),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS(SELECT email FROM p6g1.perf.cliente WHERE email=@cliente_email) AND EXISTS(SELECT id, datainicio, datafim FROM p6g1.perf.cupao WHERE (id=@cupao_id) AND (GETDATE() BETWEEN datainicio AND datafim))
            BEGIN
                INSERT INTO p6g1.perf.cliente_usa_cupao
                (cliente_email, cupao_id)
                VALUES(@cliente_email, @cupao_id) 
                SET @responseMessage='Success'
            END
        ELSE
            SET @responseMessage='Failed'
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE()
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[getDetailsFromBuy]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[getDetailsFromBuy]
    @numero INT
AS
BEGIN
        SET NOCOUNT ON
            IF EXISTS(SELECT numero FROM p6g1.perf.compra_online WHERE numero=@numero)
                BEGIN
                    SELECT pagamento, contribuinte, rating, rastreamento, presente, observacao, telemovel, codigo_postal, endereco, pontosgastos, pontosacumulados, compra.numero, compra.datacompra
                    FROM ((p6g1.perf.compra JOIN p6g1.perf.compra_online ON compra.numero=compra_online.numero) JOIN p6g1.perf.contacto ON contactoid=id)
                    WHERE compra.numero=@numero
                END
            ELSE IF EXISTS(SELECT numero FROM p6g1.perf.compra_presencial WHERE numero=@numero)
                BEGIN
                    SELECT pagamento, compra.contribuinte, fname, compra.numero, compra.datacompra
                    FROM (((p6g1.perf.compra JOIN p6g1.perf.compra_presencial ON compra.numero=compra_presencial.numero) JOIN p6g1.perf.funcionario ON funcemail=email) JOIN p6g1.perf.utilizador ON funcionario.email=utilizador.email)
                    WHERE compra.numero=@numero
                END
END
GO
/****** Object:  StoredProcedure [perf].[getDetailsFromSell]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[getDetailsFromSell]
    @numero INT
AS
BEGIN
    SELECT clienteemail, pagamento, compra.contribuinte, compra.numero, compra.datacompra
    FROM (((p6g1.perf.compra JOIN p6g1.perf.compra_presencial ON compra.numero=compra_presencial.numero) JOIN p6g1.perf.funcionario ON funcemail=email) JOIN p6g1.perf.utilizador ON funcionario.email=utilizador.email)
    WHERE compra.numero=@numero
END
GO
/****** Object:  StoredProcedure [perf].[getProductFilters]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[getProductFilters]
    @deleted BIT = NULL,
    @nome VARCHAR(30) = NULL,
    @marca VARCHAR(30) = NULL,
    @categoria VARCHAR(30) = NULL,
    @destinatario VARCHAR(10) = NULL,
    @orderby VARCHAR(50) = NULL,
    @ordem VARCHAR(30) = NULL
AS
BEGIN
        SET NOCOUNT ON
        IF (@ordem = 'Ascendente')
        BEGIN
            SELECT id, preco, familiaolfativa, categoria, nome, marca, linha, tamanho, descricao, imagem, stock, destinatario, deleted
            FROM p6g1.perf.produto
            WHERE stock > 0 AND
                  deleted = 0 AND
                  nome LIKE ('%'+ISNULL(@nome, nome)+'%') AND
                  marca = ISNULL(@marca,marca) AND
                  categoria = ISNULL(@categoria,categoria) 
            ORDER BY CASE WHEN @orderby='Nome' THEN nome END,
                     CASE WHEN @orderby='Marca' THEN marca END,
                     CASE WHEN @orderby='Categoria' THEN categoria END,
                     CASE WHEN @orderby='Preço' THEN preco END
        END

        ELSE IF (@ordem = 'Descendente')
        BEGIN
            SELECT id, preco, familiaolfativa, categoria, nome, marca, linha, tamanho, descricao, imagem, stock, destinatario, deleted
            FROM p6g1.perf.produto
            WHERE stock > 0 AND
                  deleted = 0 AND
                  nome LIKE ('%'+ISNULL(@nome, nome)+'%') AND
                  marca = ISNULL(@marca,marca) AND
                  categoria = ISNULL(@categoria,categoria)
            ORDER BY CASE WHEN @orderby='Nome' THEN nome END DESC,
                     CASE WHEN @orderby='Marca' THEN marca END DESC,
                     CASE WHEN @orderby='Categoria' THEN categoria END DESC,
                     CASE WHEN @orderby='Preço' THEN preco END DESC
        END
            
END
GO
/****** Object:  StoredProcedure [perf].[getProductFiltersFunc]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[getProductFiltersFunc]
    @deleted BIT = NULL,
    @nome VARCHAR(30) = NULL,
    @marca VARCHAR(30) = NULL,
    @categoria VARCHAR(30) = NULL,
    @destinatario VARCHAR(10) = NULL,
    @orderby VARCHAR(50) = NULL,
    @ordem VARCHAR(30) = NULL
AS
BEGIN
        SET NOCOUNT ON
        IF (@ordem = 'Ascendente')
        BEGIN
            SELECT id, preco, familiaolfativa, categoria, nome, marca, linha, tamanho, descricao, imagem, stock, destinatario, deleted
            FROM p6g1.perf.produto
            WHERE
                  nome LIKE ('%'+ISNULL(@nome, nome)+'%') AND
                  marca = ISNULL(@marca,marca) AND
                  categoria = ISNULL(@categoria,categoria) 
            ORDER BY CASE WHEN @orderby='Nome' THEN nome END,
                     CASE WHEN @orderby='Marca' THEN marca END,
                     CASE WHEN @orderby='Categoria' THEN categoria END,
                     CASE WHEN @orderby='Preço' THEN preco END
        END

        ELSE IF (@ordem = 'Descendente')
        BEGIN
            SELECT id, preco, familiaolfativa, categoria, nome, marca, linha, tamanho, descricao, imagem, stock, destinatario, deleted
            FROM p6g1.perf.produto
            WHERE
                  nome LIKE ('%'+ISNULL(@nome, nome)+'%') AND
                  marca = ISNULL(@marca,marca) AND
                  categoria = ISNULL(@categoria,categoria)
            ORDER BY CASE WHEN @orderby='Nome' THEN nome END DESC,
                     CASE WHEN @orderby='Marca' THEN marca END DESC,
                     CASE WHEN @orderby='Categoria' THEN categoria END DESC,
                     CASE WHEN @orderby='Preço' THEN preco END DESC
        END
            
END
GO
/****** Object:  StoredProcedure [perf].[Login]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [perf].[Login]
    @email VARCHAR(255),
    @password VARCHAR(25),
    @responseMessage VARCHAR(250)='' OUTPUT,
    @type BIT=0 OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    IF EXISTS (SELECT TOP 1 email FROM p6g1.perf.utilizador WHERE email = @email)
    BEGIN
        SET @email=(SELECT email FROM p6g1.perf.utilizador
        WHERE email=@email AND pw=HASHBYTES('SHA2_512', @password))

        IF(@email IS NULL)
        BEGIN
            SET @type=0
            SET @responseMessage='Incorrect password'
        END
        ELSE 
        BEGIN
           SET @responseMessage='User successfully logged in'
           IF EXISTS (SELECT TOP 1 email FROM p6g1.perf.funcionario WHERE email = @email)
            SET @type = 1
           ELSE
            SET @type = 0
        END
    END
    ELSE
        BEGIN
		    SET @type=0
		    SET @responseMessage='Invalid login'
        END

END
GO
/****** Object:  StoredProcedure [perf].[newBuy]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[newBuy]
    @contribuinte CHAR(9),
    @pagamento VARCHAR(10),
    @clienteemail VARCHAR(255),
    @contacto INT,
    @presente BIT,
    @pontosgastos INT = NULL,
    @pontosacumulados INT = NULL,
    @compra INT OUTPUT,
    @responseMessage VARCHAR(250) OUTPUT
AS
BEGIN
    BEGIN TRANSACTION
    SET NOCOUNT ON
    BEGIN TRY
        INSERT INTO p6g1.perf.compra
        (contribuinte, datacompra, pagamento, clienteemail, pontosgastos, pontosacumulados)
        VALUES(@contribuinte, GETDATE(), @pagamento, @clienteemail, @pontosgastos, @pontosacumulados)

        SELECT @compra = numero FROM p6g1.perf.compra WHERE numero = @@Identity

        INSERT INTO p6g1.perf.compra_online
        (numero, presente, contactoid)
        VALUES(@compra, @presente, @contacto)
        
        SET @responseMessage='Success'
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        SET @responseMessage='Failure'
        ROLLBACK
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[RegisterClient]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [perf].[RegisterClient]
    @email VARCHAR(255),
    @password VARCHAR(25),
    @contribuinte CHAR(9),
    @fname VARCHAR(20),
    @lname VARCHAR(20),
    @sexo BIT,
    @dataNasc DATE,
    @foto VARCHAR(100),
    @pontos INT = 0,
    @newsletter BIT,
    @pagamento VARCHAR(10) = null,
    @responseMessage VARCHAR(250) OUTPUT
AS
BEGIN
    BEGIN TRANSACTION
    SET NOCOUNT ON
    BEGIN TRY

        INSERT INTO p6g1.perf.utilizador
        (email, contribuinte, fname, lname, pw, sexo, dataNasc, foto)
    VALUES(@email, @contribuinte, @fname, @lname, HASHBYTES('SHA2_512', @password), @sexo, @dataNasc, @foto)

    INSERT INTO p6g1.perf.cliente
        (email, pontos, newsletter, pagamento)
    VALUES(@email, @pontos, @newsletter, @pagamento)

    SET @responseMessage='Success'
    COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
        ROLLBACK
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[RegisterFunc]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [perf].[RegisterFunc]
    @email VARCHAR(255),
    @password VARCHAR(25),
    @contribuinte CHAR(9),
    @fname VARCHAR(20),
    @lname VARCHAR(20),
    @sexo BIT,
    @dataNasc DATE,
    @foto VARCHAR(100),
    @salario INT,
    @administrator TINYINT,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    BEGIN TRANSACTION
    SET NOCOUNT ON

    BEGIN TRY

        INSERT INTO p6g1.perf.utilizador
        (email, contribuinte, fname, lname, pw, sexo, dataNasc, foto)
    VALUES(@email, @contribuinte, @fname, @lname, HASHBYTES('SHA2_512', @password), @sexo, @dataNasc, @foto)

    INSERT INTO p6g1.perf.funcionario
        (email, administrator, salario)
    VALUES(@email, @administrator, @salario)

    SET @responseMessage='Success'
    COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
        ROLLBACK
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[removeContact]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[removeContact]
    @id INT,
    @email VARCHAR(255),
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        IF EXISTS(SELECT 1 FROM p6g1.perf.contacto WHERE utilizador_email=@email AND id=@id)
            BEGIN
            IF EXISTS (SELECT 1 FROM p6g1.perf.utilizador WHERE email=@email AND contacto_default_id = @id)
                SET @responseMessage='Não é possível remover o contacto default.'
            ELSE
            BEGIN
                UPDATE p6g1.perf.contacto
                SET visibilidade=0
                WHERE id=@id
                SET @responseMessage='Success'
                END
            END
        ELSE
            SET @responseMessage='Permition denied'
    END TRY
    BEGIN CATCH
        SET @responseMessage='ERRO' 
    END CATCH

END
GO
/****** Object:  StoredProcedure [perf].[updateClient]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[updateClient]
	@email VARCHAR(255), 
    @password VARCHAR(25) = NULL,
    @fname VARCHAR(20) = NULL,
    @lname VARCHAR(20) = NULL,
	@newsletter BIT = NULL,
	@pagamento VARCHAR(10) = NULL,
    @responseMsg nvarchar(250) output
AS
BEGIN
	BEGIN TRANSACTION
	SET NOCOUNT ON
	BEGIN TRY

		IF @fname IS NOT NULL
		BEGIN
			UPDATE p6g1.perf.utilizador
			SET fname = @fname
			WHERE email = @email
		END

		IF @lname IS NOT NULL
		BEGIN
			UPDATE p6g1.perf.utilizador
			SET lname = @lname
			WHERE  email = @email
		END

		IF @password IS NOT NULL
		BEGIN
			UPDATE p6g1.perf.utilizador
			SET pw = hashbytes('SHA2_512', @password)
			WHERE  email = @email
		END

		IF @newsletter IS NOT NULL
		BEGIN
			UPDATE p6g1.perf.cliente
			SET newsletter = @newsletter
			WHERE  email = @email
		END

		IF @pagamento IS NOT NULL
		BEGIN
			UPDATE p6g1.perf.cliente
			SET pagamento = @pagamento
			WHERE  email = @email
		END

		SET @responseMsg='Success'
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET @responseMsg='Erro'
		ROLLBACK
	END CATCH
END
GO
/****** Object:  StoredProcedure [perf].[updateFunc]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[updateFunc]
	@email VARCHAR(255), 
    @admin TINYINT = null,
    @salario INT = null,
    @pw VARCHAR(25) = null,
    @emailOP VARCHAR(255)=null,
    @responseMsg nvarchar(250) output
AS
BEGIN
    BEGIN TRANSACTION
	SET NOCOUNT ON

	BEGIN TRY
        IF @admin IS NOT NULL
		BEGIN
            IF EXISTS (SELECT administrator FROM p6g1.perf.funcionario WHERE email = @email AND administrator = 2)
            BEGIN
                UPDATE p6g1.perf.funcionario
                SET administrator = @admin
                WHERE  email = @emailOP
				SET @responseMsg='Success'
            END
            ELSE
                RAISERROR ('Insuficient Permissions.', 14, 1);
		END

        IF @salario IS NOT NULL
		BEGIN
            IF EXISTS (SELECT administrator FROM p6g1.perf.funcionario WHERE email = @email AND administrator = 2)
            BEGIN
                UPDATE p6g1.perf.funcionario
                SET salario = @salario
                WHERE  email = @emailOP
				SET @responseMsg='Success'
            END
            ELSE
                RAISERROR ('Insuficient Permissions.', 14, 1);
		END

        IF @pw IS NOT NULL
            BEGIN
                UPDATE p6g1.perf.utilizador
                SET pw = hashbytes('SHA2_512', @pw)
                WHERE  email = @email
                SET @responseMsg='Success'
            END
    COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET @responseMsg='Failed'
        ROLLBACK
	END CATCH
END
GO
/****** Object:  StoredProcedure [perf].[updateMarc]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [perf].[updateMarc]
	@cliente_email VARCHAR(255),
    @idMarc INT,
    @funcionario_email VARCHAR(255),
    @dataMarc DATETIME = null,
	@responseMessage NVARCHAR(250) = 'Erro! Tente noutra hora.' OUTPUT
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON
			IF EXISTS (SELECT email=@funcionario_email from p6g1.perf.funcionario)
			BEGIN
				
				IF (@dataMarc IS NOT NULL)
				BEGIN
					BEGIN TRY
						DECLARE @duracao INT
						SELECT @duracao=duracao_media FROM p6g1.perf.funcionario_faz_servico join p6g1.perf.marcacao on funcionario_faz_servico.servico_id=marcacao.servico_id
								WHERE marcacao.funcionario_email=@funcionario_email  
										AND marcacao.deleted = 0 
										AND marcacao.id=@idMarc
										AND funcionario_faz_servico.funcionario_email=@funcionario_email
							IF (@duracao IS NOT NULL AND @dataMarc > GETDATE()) 
							BEGIN
		 						IF (EXISTS(SELECT 1 FROM p6g1.perf.marcacao WHERE (dataMarc BETWEEN @dataMarc AND DATEADD(mi, @duracao, @dataMarc)) AND @funcionario_email=funcionario_email) OR EXISTS(SELECT 1 FROM p6g1.perf.marcacao WHERE dataMarc BETWEEN @dataMarc AND DATEADD(mi, @duracao, dataMarc) AND cliente_email=@cliente_email))
									SET @responseMessage = 'Hora não disponível!'
								ELSE
								BEGIN
									UPDATE p6g1.perf.marcacao
									SET dataMarc=@dataMarc
									WHERE id=@idMarc
									SET @responseMessage='Marcação efetuado com sucesso!'
								END
							END
					END TRY
					BEGIN CATCH
						SET @responseMessage='Failure'
					END CATCH
				END

				
			END
	END TRY
	BEGIN CATCH
		SET @responseMessage='Failed'
	END CATCH 
END
GO
/****** Object:  StoredProcedure [perf].[verifyPaymentContact]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perf].[verifyPaymentContact]
    @utilizador_email VARCHAR(255),
    @contacto INT OUTPUT,
    @pagamento VARCHAR(10) OUTPUT,
    @result BIT = 0 OUTPUT
AS
BEGIN
    SET NOCOUNT ON
        IF EXISTS(SELECT contacto_default_id, pagamento FROM p6g1.perf.utilizador JOIN p6g1.perf.cliente ON utilizador.email = cliente.email WHERE utilizador.email = @utilizador_email) 
		BEGIN
		SELECT @contacto = contacto_default_id, @pagamento = pagamento FROM p6g1.perf.utilizador JOIN p6g1.perf.cliente ON utilizador.email = cliente.email WHERE utilizador.email = @utilizador_email
        SET @result = 1
		END
        ELSE
        SET @result = 0
		
END
GO
/****** Object:  Trigger [perf].[useCuponTrigger]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [perf].[useCuponTrigger] ON [perf].[cliente_usa_cupao]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @cupao as CHAR(10);
    DECLARE @email as VARCHAR(255);
    DECLARE @pontos as INT;
    SELECT @cupao = cupao_id, @email = cliente_email FROM inserted;
    SELECT @pontos = pontos_atribuidos FROM p6g1.perf.cupao WHERE id = @cupao;
    BEGIN TRY
        UPDATE perf.cliente
        SET pontos += @pontos
        WHERE email = @email
    END TRY
    BEGIN CATCH
        raiserror ('Não foi possível atribuir os pontos', 16, 1);
		ROLLBACK TRAN
    END CATCH

END
GO
ALTER TABLE [perf].[cliente_usa_cupao] ENABLE TRIGGER [useCuponTrigger]
GO
/****** Object:  Trigger [perf].[buyProductTrigger]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [perf].[buyProductTrigger] ON [perf].[compra_tem_produto]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @unidades AS INT;
    DECLARE @produtoid AS INT;
    DECLARE @stock as INT;
    SELECT @unidades = unidades, @produtoid = produtoid FROM inserted;
    SELECT @stock = stock FROM p6g1.perf.produto WHERE id = @produtoid;
    IF (@stock - @unidades < 0)
    BEGIN
        RAISERROR('Encomenda não processada. Stock insuficente.', 16, 1);
        ROLLBACK TRAN;
    END
	IF (@stock - @unidades = 0)
	BEGIN
    BEGIN TRY
		UPDATE p6g1.perf.produto
		SET stock = 0, deleted = 1
		WHERE  id = @produtoid
    END TRY
    BEGIN CATCH
        raiserror ('Não foi possível atribuir os pontos', 16, 1);
        ROLLBACK TRAN
    END CATCH
	END
END
GO
ALTER TABLE [perf].[compra_tem_produto] ENABLE TRIGGER [buyProductTrigger]
GO
/****** Object:  Trigger [perf].[createContactTrigger]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [perf].[createContactTrigger] ON [perf].[contacto]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @id AS INT;
    DECLARE @email AS VARCHAR(255); 
    SELECT @id = id, @email = utilizador_email FROM inserted;
    IF EXISTS(SELECT 1 FROM p6g1.perf.utilizador WHERE email=@email AND contacto_default_id IS NULL)
    BEGIN
    BEGIN TRY
		UPDATE p6g1.perf.utilizador
		SET  contacto_default_id = @id
		WHERE  email = @email
    END TRY
    BEGIN CATCH
        raiserror ('Não foi possível colocar o contacto como default', 16, 1);
        ROLLBACK TRAN
    END CATCH
	END
END
GO
ALTER TABLE [perf].[contacto] ENABLE TRIGGER [createContactTrigger]
GO
/****** Object:  Trigger [perf].[changeProductTrigger]    Script Date: 12/06/2020 19:58:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [perf].[changeProductTrigger] ON [perf].[produto]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @stock as INT;
	DECLARE @produtoid as INT;
    SELECT @stock = stock, @produtoid = id FROM inserted;
    IF (@stock < 0)
    BEGIN
        RAISERROR('Stock inválido.', 16, 1);
        ROLLBACK TRAN;
    END
	IF (@stock= 0)
	BEGIN
    BEGIN TRY
		UPDATE p6g1.perf.produto
		SET deleted = 1
		WHERE  id = @produtoid
    END TRY
    BEGIN CATCH
        raiserror ('Não foi possível mudar o produto.', 16, 1);
        ROLLBACK TRAN
    END CATCH
	END
END
GO
ALTER TABLE [perf].[produto] ENABLE TRIGGER [changeProductTrigger]
GO
