-- =================================================================
-- MODULO 06 - CONVERSAO DE DADOS - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 29 - CAST - Convertendo Tipos de Dados
-- =================================================================

-- Aula 29 - Desafio 1: Converter preco para inteiro (sem centavos)
-- Exiba nome, preco original e preco convertido para inteiro
SELECT
    nome,
    preco,
    CAST(preco AS INTEGER) AS preco_inteiro,
    CAST(ROUND(preco) AS INTEGER) AS preco_arredondado
FROM produtos;


-- Aula 29 - Desafio 2: Converter data_pedido para texto
-- Exiba pedido_id e data_pedido como texto
SELECT
    pedido_id,
    data_pedido,
    CAST(data_pedido AS VARCHAR) AS data_como_texto
FROM pedidos;


-- =================================================================
-- AULA 30 - COALESCE - Tratando Valores Nulos
-- =================================================================

-- Aula 30 - Desafio 2: Substituir comentários nulos por "Sem comentarios"
-- Exiba o ID da avaliação, o ID do cliente e o comentário tratado
SELECT 
    avaliacao_id,
    cliente_id,
    COALESCE(comentario, 'Sem comentarios') AS comentario
FROM avaliacoes;


-- Aula 30 - Desafio 4: Simular correção de pedido com erro de sistema
-- Exiba o pedido 7 com status "cancelado" e data de entrega realizada ajustada para NULL

SELECT
    pedido_id,
    cliente_id,
    status,
    'cancelado' AS novo_status,
    data_entrega_realizada,
    NULLIF(data_entrega_realizada, data_entrega_realizada) AS ajuste_data
FROM pedidos
WHERE pedido_id = 7;


