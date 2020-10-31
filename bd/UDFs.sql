DROP FUNCTION perf.clientBuyHistory;
GO

CREATE FUNCTION perf.clientBuyHistory (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT datacompra as [Data], SUM(unidades * preco) as Total, compranumero
                    FROM ((p6g1.perf.compra_tem_produto JOIN p6g1.perf.compra ON compra_tem_produto.compranumero=compra.numero) JOIN p6g1.perf.produto ON produtoid=id)
                    WHERE (clienteemail=@email)
                    GROUP BY datacompra, clienteemail, compranumero
                    ORDER BY datacompra DESC OFFSET 0 ROWS)
GO 


DROP FUNCTION perf.clientContacts;
GO

CREATE FUNCTION perf.clientContacts (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT id, telemovel, codigo_postal, pais, endereco, apartamento, localidade
                    FROM p6g1.perf.contacto
                    WHERE utilizador_email=@email AND visibilidade = 1
                    ORDER BY id ASC OFFSET 0 ROWS)             
GO

DROP FUNCTION perf.clientDefaultContact;
GO

CREATE FUNCTION perf.clientDefaultContact (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT contacto_default_id as id
                    FROM (p6g1.perf.utilizador JOIN p6g1.perf.contacto ON contacto_default_id=id)
                    WHERE email=@email AND visibilidade = 1)
                    
GO


DROP FUNCTION perf.clientFavourites
GO

CREATE FUNCTION perf.clientFavourites (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT id, preco, familiaolfativa, categoria, nome, marca, linha, tamanho, descricao, imagem, stock, destinatario
                    FROM (p6g1.perf.clientefavorita JOIN p6g1.perf.produto ON produtoid=id)
                    WHERE clienteemail=@email AND deleted = 0)
                    
GO

DROP FUNCTION perf.clientFutureMarc;
GO

CREATE FUNCTION perf.clientFutureMarc (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT dataMarc, tipo, preco, fname AS NomeFuncionario
                    FROM ((p6g1.perf.marcacao JOIN p6g1.perf.servico ON servico_id=servico.id) JOIN p6g1.perf.utilizador ON funcionario_email = email)
                    WHERE (cliente_email=@email AND DATEDIFF(mi, GETDATE(), dataMarc) > 0) 
                    ORDER BY dataMarc ASC OFFSET 0 ROWS)              
GO

DROP FUNCTION perf.getClientInfo;
GO


CREATE FUNCTION perf.getClientInfo (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT p6g1.perf.utilizador.*, p6g1.perf.cliente.email AS clientEmail, p6g1.perf.cliente.pontos, p6g1.perf.cliente.newsletter, p6g1.perf.cliente.pagamento
					FROM p6g1.perf.utilizador 
					JOIN p6g1.perf.cliente 
					ON p6g1.perf.utilizador.email = p6g1.perf.cliente.email
                    WHERE @email = utilizador.email) 
GO     

DROP FUNCTION perf.clientServicesHistory;
GO

CREATE FUNCTION perf.clientServicesHistory (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT dataMarc, tipo, servico.preco
                    FROM (p6g1.perf.marcacao JOIN p6g1.perf.servico ON servico_id=servico.id)
                    WHERE (cliente_email=@email AND DATEDIFF(mi, GETDATE(), dataMarc) < 0) 
                    ORDER BY dataMarc ASC OFFSET 0 ROWS)             
GO

DROP FUNCTION perf.funcFutureMarc;
GO

CREATE FUNCTION perf.funcFutureMarc (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT cliente_email,dataMarc, tipo, preco, fname, lname, marcacao.id
                    FROM ((p6g1.perf.marcacao JOIN p6g1.perf.servico ON servico_id=servico.id) JOIN p6g1.perf.utilizador ON cliente_email = email)
                    WHERE (funcionario_email=@email AND DATEDIFF(mi, GETDATE(), dataMarc) > 0) 
                    ORDER BY dataMarc ASC OFFSET 0 ROWS)             
GO

DROP FUNCTION perf.getFuncInfo;
GO

CREATE FUNCTION perf.getFuncInfo (@emailFunc VARCHAR(255)) RETURNS Table 
AS
    RETURN (SELECT p6g1.perf.utilizador.*, p6g1.perf.funcionario.salario, p6g1.perf.funcionario.administrator
                    FROM p6g1.perf.utilizador
                    JOIN p6g1.perf.funcionario ON utilizador.email = funcionario.email
                    WHERE utilizador.email = @emailFunc) 
GO         
       

DROP FUNCTION perf.funcSellHistory;
GO

CREATE FUNCTION perf.funcSellHistory (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT datacompra, clienteemail, SUM(unidades * preco) as total, compranumero
                    FROM (((p6g1.perf.compra_tem_produto JOIN p6g1.perf.compra ON compranumero=numero)JOIN p6g1.perf.produto ON produtoid=id) 
                    JOIN p6g1.perf.compra_presencial ON compra_presencial.numero=compra.numero)
                    WHERE (funcemail=@email)
                    GROUP BY datacompra, clienteemail, compranumero
                    ORDER BY datacompra DESC OFFSET 0 ROWS)
GO

DROP FUNCTION perf.funcServicesHistory;
GO

CREATE FUNCTION perf.funcServicesHistory (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT dataMarc, tipo, cliente_email
                    FROM (p6g1.perf.marcacao JOIN p6g1.perf.servico ON servico_id=servico.id)
                    WHERE (funcionario_email=@email AND DATEDIFF(mi, GETDATE(), dataMarc) < 0) 
                    ORDER BY dataMarc ASC OFFSET 0 ROWS)             
GO

DROP FUNCTION perf.getAllFuncs;
GO

CREATE FUNCTION perf.getAllFuncs ( @emailFunc VARCHAR(255)) returns @table table (email VARCHAR(255) NOT NULL, contribuinte CHAR(9) NOT NULL, fname VARCHAR(20) NOT NULL,
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


DROP FUNCTION perf.getAllProducts;
GO

CREATE FUNCTION perf.getAllProducts () RETURNS @table TABLE (preco INT NOT NULL, familiaolfativa VARCHAR(30), categoria VARCHAR(30) NOT NULL,
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


DROP FUNCTION perf.getAllServices;
GO

CREATE FUNCTION perf.getAllServices () RETURNS Table 
AS
    RETURN (SELECT id, tipo, preco
                    FROM p6g1.perf.servico)
                    
GO

DROP FUNCTION perf.getClientCupon;
GO

CREATE FUNCTION perf.getClientCupon (@email VARCHAR(255)) RETURNS TABLE 
AS
    RETURN (SELECT id, datainicio, datafim, pontos_atribuidos
                    FROM (p6g1.perf.cliente_usa_cupao JOIN p6g1.perf.cupao ON cupao_id=id)
                    WHERE cliente_email=@email
                    ORDER BY datainicio DESC OFFSET 0 ROWS)
                    
GO


DROP FUNCTION perf.getCupons;
GO

CREATE FUNCTION perf.getCupons () RETURNS TABLE 
AS
    RETURN (SELECT id, datainicio, datafim, pontos_atribuidos
                    FROM p6g1.perf.cupao)
                    
GO


DROP FUNCTION perf.getFuncService;
GO

CREATE FUNCTION perf.getFuncService (@servico_id INT) RETURNS Table 
AS
    RETURN (SELECT fname, lname, funcionario_email
                    FROM p6g1.perf.funcionario_faz_servico JOIN p6g1.perf.utilizador ON email = funcionario_email
                    WHERE funcionario_faz_servico.deleted = 0 AND servico_id = @servico_id AND utilizador.deleted = 0) 
GO

DROP FUNCTION perf.getProductsFromBuy;
GO

CREATE FUNCTION perf.getProductsFromBuy (@numero INT) RETURNS Table 
AS
    RETURN (SELECT id, preco, familiaolfativa, categoria, nome, marca, linha, tamanho, descricao, imagem, stock, destinatario, deleted, unidades
                    FROM p6g1.perf.compra_tem_produto JOIN p6g1.perf.produto ON produtoid=id
                    WHERE compranumero = @numero) 
GO

DROP FUNCTION perf.getPromocoes;
GO

CREATE FUNCTION perf.getPromocoes () RETURNS TABLE 
AS
    RETURN (SELECT id, nome, desconto, datainicio, datafim
                    FROM p6g1.perf.promocao)
                    
GO

DROP FUNCTION perf.getServiceFuncs;
GO

CREATE FUNCTION perf.getServiceFuncs (@id INT) RETURNS Table 
AS
    RETURN (SELECT fname, lname, email, funcionario_faz_servico.deleted
                    FROM p6g1.perf.utilizador JOIN p6g1.perf.funcionario_faz_servico ON email=funcionario_email
                    WHERE servico_id=@id) 
GO

DROP FUNCTION perf.getServicesType;
GO

CREATE FUNCTION perf.getServicesType () RETURNS Table 
AS
    RETURN (SELECT id, tipo, preco
                    FROM p6g1.perf.servico
                    WHERE deleted = 0) 
GO