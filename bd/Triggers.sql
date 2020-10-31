DROP TRIGGER perf.useCuponTrigger;
GO

CREATE TRIGGER perf.useCuponTrigger ON perf.[cliente_usa_cupao]
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

DROP TRIGGER perf.createContactTrigger;
GO

CREATE TRIGGER perf.createContactTrigger ON perf.[contacto]
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

DROP TRIGGER perf.changeProductTrigger;
GO

CREATE TRIGGER perf.changeProductTrigger ON perf.[produto]
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

DROP TRIGGER perf.buyProductTrigger;
GO

CREATE TRIGGER perf.buyProductTrigger ON perf.[compra_tem_produto]
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