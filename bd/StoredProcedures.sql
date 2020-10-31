DROP PROCEDURE perf.addContact;
GO

CREATE PROCEDURE perf.addContact
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

DROP PROCEDURE perf.addCupon;
GO

CREATE PROCEDURE perf.addCupon
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


DROP PROCEDURE perf.addFuncService;
GO

CREATE PROCEDURE perf.addFuncService
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

DROP PROCEDURE perf.addMarc;
GO


CREATE PROCEDURE perf.addMarc
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

DROP PROCEDURE perf.addNewFunc;
GO

CREATE PROCEDURE perf.addNewFunc
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

DROP PROCEDURE perf.addProduct;
GO

CREATE PROCEDURE perf.addProduct
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

DROP PROCEDURE perf.addPromotion;
GO

CREATE PROCEDURE perf.addPromotion
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

DROP PROCEDURE perf.addService;
GO


CREATE PROCEDURE perf.addService
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

DROP PROCEDURE perf.buyProduct;
GO

CREATE PROCEDURE perf.buyProduct
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

DROP PROCEDURE perf.changeDefaultContact
GO

CREATE PROCEDURE perf.changeDefaultContact
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

DROP PROCEDURE perf.changeProduct
GO


CREATE PROCEDURE perf.changeProduct
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

DROP PROCEDURE perf.changeRating
GO

CREATE PROCEDURE perf.changeRating
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

DROP PROCEDURE perf.clientAddFavourite
GO

CREATE PROCEDURE perf.clientAddFavourite
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

DROP PROCEDURE perf.clientRemoveFavourite
GO

CREATE PROCEDURE perf.clientRemoveFavourite
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

DROP PROCEDURE perf.clientUsesCupon;
GO

CREATE PROCEDURE perf.clientUsesCupon
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

DROP PROCEDURE perf.getDetailsFromBuy;
GO

CREATE PROCEDURE perf.getDetailsFromBuy
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

DROP PROCEDURE perf.getDetailsFromSell;
GO

CREATE PROCEDURE perf.getDetailsFromSell
    @numero INT
AS
BEGIN
    SELECT clienteemail, pagamento, compra.contribuinte, compra.numero, compra.datacompra
    FROM (((p6g1.perf.compra JOIN p6g1.perf.compra_presencial ON compra.numero=compra_presencial.numero) JOIN p6g1.perf.funcionario ON funcemail=email) JOIN p6g1.perf.utilizador ON funcionario.email=utilizador.email)
    WHERE compra.numero=@numero
END
GO

DROP PROCEDURE perf.getProductFilters;
GO

CREATE PROCEDURE perf.getProductFilters
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

DROP PROCEDURE perf.getProductFiltersFunc;
GO

CREATE PROCEDURE perf.getProductFiltersFunc
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

DROP PROCEDURE perf.Login;
GO


CREATE PROCEDURE perf.Login
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


DROP PROCEDURE perf.newBuy;
GO

CREATE PROCEDURE perf.newBuy
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

DROP PROCEDURE perf.RegisterFunc
GO


CREATE PROCEDURE perf.RegisterFunc
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

DROP PROCEDURE perf.RegisterClient
GO


CREATE PROCEDURE perf.RegisterClient
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


DROP PROCEDURE perf.removeContact
GO

CREATE PROCEDURE perf.removeContact
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

DROP PROCEDURE perf.updateClient;
GO

CREATE PROCEDURE perf.updateClient
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

DROP PROCEDURE perf.updateFunc;
GO

CREATE PROCEDURE perf.updateFunc
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

DROP PROCEDURE perf.updateMarc;
GO


CREATE PROCEDURE perf.updateMarc
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

DROP PROCEDURE perf.verifyPaymentContact
GO

CREATE PROCEDURE perf.verifyPaymentContact
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