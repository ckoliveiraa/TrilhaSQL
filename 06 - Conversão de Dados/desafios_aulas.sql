-- Aula 29 - Desafio 1: Converter preço para inteiro (sem centavos)
-- Exiba nome, preco original e preco convertido para inteiro
SELECT nome, preco, CAST(ROUND(preco) AS INTEGER) AS preco_arredondado
FROM produtos;
-- Aula 29 - Desafio 2: Converter data_pedido para texto
-- Exiba pedido_id e data_pedido como texto
SELECT pedido_id, data_pedido, CAST(data_pedido AS VARCHAR) AS data_como_texto
FROM pedidos;
-- Aula 30 - Desafio 1: Substituir comentários nulos por "Sem comentarios"
-- Exiba o ID da avaliação, o ID do cliente e o comentário tratado
SELECT avaliacao_id, cliente_id, COALESCE(comentario, 'Sem comentarios') AS comentario
FROM avaliacoes;
-- Aula 30 - Desafio 2: Simular correção de pedido com erro de sistema
-- Exiba o pedido 7 com status "cancelado" e data de entrega realizada ajustada para NULL
SELECT pedido_id, cliente_id, 'cancelado' AS status, NULLIF(data_entrega_realizada, data_entrega_realizada) AS ajuste_data
FROM pedidos
WHERE pedido_id = 7;
