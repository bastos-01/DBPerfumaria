DROP INDEX idx_produto on p6g1.perf.produto;
GO

CREATE INDEX idx_produto
ON p6g1.perf.produto (preco, marca, nome, categoria);
GO