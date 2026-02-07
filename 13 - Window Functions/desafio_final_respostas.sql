-- ============================================
-- MÓDULO 13 - WINDOW FUNCTIONS
-- Respostas do Desafio Final
-- ============================================

-- Desafio Final 1: Ranking Completo de Produtos
-- Para cada produto, mostre:
-- - nome, preco, categoria
-- - ROW_NUMBER, RANK e DENSE_RANK por preço
-- Compare os resultados

SELECT
    p.nome,
    p.preco,
    c.nome AS categoria,
    ROW_NUMBER() OVER (ORDER BY p.preco DESC) AS row_num,
    RANK() OVER (ORDER BY p.preco DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY p.preco DESC) AS dense_rank
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
ORDER BY p.preco DESC;


-- Desafio Final 2: Top 2 Produtos por Categoria
-- Liste os 2 produtos mais caros de cada categoria
-- Use PARTITION BY e ROW_NUMBER

SELECT *
FROM (
    SELECT
        c.nome AS categoria,
        p.nome AS produto,
        p.preco,
        ROW_NUMBER() OVER (
            PARTITION BY p.categoria_id
            ORDER BY p.preco DESC
        ) AS ranking_categoria
    FROM produtos p
    INNER JOIN categorias c ON p.categoria_id = c.categoria_id
) AS ranked
WHERE ranking_categoria <= 2
ORDER BY categoria, ranking_categoria;


-- Desafio Final 3: Análise de Pedidos do Cliente
-- Para cada pedido, mostre:
-- - cliente_id, pedido_id, data_pedido, valor_total
-- - valor do pedido anterior do mesmo cliente
-- - diferença entre pedidos
-- - número do pedido do cliente (1º, 2º, 3º...)

SELECT
    cliente_id,
    pedido_id,
    data_pedido,
    valor_total,
    LAG(valor_total) OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido
    ) AS valor_pedido_anterior,
    valor_total - COALESCE(
        LAG(valor_total) OVER (
            PARTITION BY cliente_id
            ORDER BY data_pedido
        ), 0
    ) AS diferenca,
    ROW_NUMBER() OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido
    ) AS numero_pedido_cliente
FROM pedidos
ORDER BY cliente_id, data_pedido;


-- Desafio Final 4: Variação de Vendas
-- Calcule a variação percentual de vendas diárias
-- Mostre: data, total do dia, total do dia anterior, variação %

WITH vendas_diarias AS (
    SELECT
        data_pedido,
        SUM(valor_total) AS total_dia
    FROM pedidos
    GROUP BY data_pedido
)
SELECT
    data_pedido,
    total_dia,
    LAG(total_dia) OVER (ORDER BY data_pedido) AS total_dia_anterior,
    ROUND(
        100.0 * (total_dia - LAG(total_dia) OVER (ORDER BY data_pedido))
        / NULLIF(LAG(total_dia) OVER (ORDER BY data_pedido), 0),
        2
    ) AS variacao_percentual
FROM vendas_diarias
ORDER BY data_pedido;


-- Desafio Final 5 (Boss Final!): Dashboard de Performance
-- Crie um relatório que mostre para cada produto:
-- - nome, categoria, preco, estoque
-- - Ranking geral por preço
-- - Ranking dentro da categoria
-- - Se é o mais caro da categoria (sim/não)
-- - Diferença de preço para o produto mais caro da mesma categoria

SELECT
    p.nome,
    c.nome AS categoria,
    p.preco,
    p.estoque,
    RANK() OVER (ORDER BY p.preco DESC) AS ranking_geral,
    RANK() OVER (
        PARTITION BY p.categoria_id
        ORDER BY p.preco DESC
    ) AS ranking_categoria,
    CASE
        WHEN RANK() OVER (
            PARTITION BY p.categoria_id
            ORDER BY p.preco DESC
        ) = 1 THEN 'Sim'
        ELSE 'Não'
    END AS mais_caro_categoria,
    FIRST_VALUE(p.preco) OVER (
        PARTITION BY p.categoria_id
        ORDER BY p.preco DESC
    ) - p.preco AS diferenca_para_mais_caro
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
ORDER BY c.nome, p.preco DESC;
