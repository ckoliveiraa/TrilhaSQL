-- ============================================
-- MÓDULO 14 - CTEs & OTIMIZAÇÃO
-- Respostas do Desafio Final
-- ============================================

-- Desafio Final 1: CTE com Análise Completa
-- Crie uma CTE que calcule para cada cliente:
-- - Total de pedidos
-- - Valor total gasto
-- - Ticket médio
-- Depois use essa CTE para mostrar apenas os top 10 clientes

WITH analise_clientes AS (
    SELECT
        c.cliente_id,
        c.nome,
        COUNT(p.pedido_id) AS total_pedidos,
        COALESCE(SUM(p.valor_total), 0) AS valor_total_gasto,
        COALESCE(ROUND(AVG(p.valor_total), 2), 0) AS ticket_medio
    FROM clientes c
    LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
    GROUP BY c.cliente_id, c.nome
)
SELECT *
FROM analise_clientes
ORDER BY valor_total_gasto DESC
LIMIT 10;


-- Desafio Final 2: CTE Recursiva de Datas
-- Gere todas as datas do último mês
-- Use essa lista para fazer um relatório de vendas diárias
-- (inclusive dias sem vendas, mostrando 0)

WITH RECURSIVE datas_mes AS (
    -- Data inicial: primeiro dia do mês passado
    SELECT DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')::DATE AS data

    UNION ALL

    -- Gerar próximas datas até o último dia do mês
    SELECT (data + INTERVAL '1 day')::DATE
    FROM datas_mes
    WHERE data < (DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 day')::DATE
),
vendas_diarias AS (
    SELECT
        data_pedido::DATE AS data,
        COUNT(*) AS qtd_pedidos,
        SUM(valor_total) AS total_vendas
    FROM pedidos
    WHERE data_pedido >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
      AND data_pedido < DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY data_pedido::DATE
)
SELECT
    d.data,
    COALESCE(v.qtd_pedidos, 0) AS qtd_pedidos,
    COALESCE(v.total_vendas, 0) AS total_vendas
FROM datas_mes d
LEFT JOIN vendas_diarias v ON d.data = v.data
ORDER BY d.data;


-- Desafio Final 3: Análise de Performance
-- Use EXPLAIN ANALYZE em diferentes versões da mesma query:
-- a) Query com subquery no WHERE
-- b) Mesma query com JOIN
-- c) Mesma query com CTE
-- Compare os planos de execução

-- a) Query com subquery no WHERE
EXPLAIN ANALYZE
SELECT *
FROM produtos
WHERE categoria_id IN (
    SELECT categoria_id
    FROM categorias
    WHERE nome LIKE 'Eletr%'
);

-- b) Mesma query com JOIN
EXPLAIN ANALYZE
SELECT p.*
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
WHERE c.nome LIKE 'Eletr%';

-- c) Mesma query com CTE
EXPLAIN ANALYZE
WITH categorias_filtradas AS (
    SELECT categoria_id
    FROM categorias
    WHERE nome LIKE 'Eletr%'
)
SELECT p.*
FROM produtos p
WHERE p.categoria_id IN (SELECT categoria_id FROM categorias_filtradas);


-- Desafio Final 4 (Boss Final!): Dashboard Executivo
-- Crie um relatório completo usando CTEs que mostre:
-- - Resumo de vendas do mês atual
-- - Comparação com mês anterior (usando LAG)
-- - Top 5 produtos mais vendidos
-- - Top 5 clientes que mais compraram
-- - Taxa de crescimento

WITH
-- Vendas por mês
vendas_mensais AS (
    SELECT
        DATE_TRUNC('month', data_pedido) AS mes,
        COUNT(*) AS qtd_pedidos,
        SUM(valor_total) AS total_vendas
    FROM pedidos
    GROUP BY DATE_TRUNC('month', data_pedido)
),

-- Vendas com comparação ao mês anterior
vendas_com_comparacao AS (
    SELECT
        mes,
        qtd_pedidos,
        total_vendas,
        LAG(total_vendas) OVER (ORDER BY mes) AS vendas_mes_anterior,
        ROUND(
            100.0 * (total_vendas - LAG(total_vendas) OVER (ORDER BY mes))
            / NULLIF(LAG(total_vendas) OVER (ORDER BY mes), 0),
            2
        ) AS taxa_crescimento
    FROM vendas_mensais
),

-- Top 5 produtos mais vendidos (geral)
top_produtos AS (
    SELECT
        p.nome AS produto,
        SUM(ip.quantidade) AS qtd_vendida,
        SUM(ip.quantidade * ip.preco_unitario) AS valor_total
    FROM itens_pedido ip
    INNER JOIN produtos p ON ip.produto_id = p.produto_id
    GROUP BY p.produto_id, p.nome
    ORDER BY qtd_vendida DESC
    LIMIT 5
),

-- Top 5 clientes que mais compraram
top_clientes AS (
    SELECT
        c.nome AS cliente,
        COUNT(p.pedido_id) AS qtd_pedidos,
        SUM(p.valor_total) AS valor_total
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
    GROUP BY c.cliente_id, c.nome
    ORDER BY valor_total DESC
    LIMIT 5
)

-- Relatório Final
SELECT '=== RESUMO DE VENDAS MENSAL ===' AS secao, NULL AS item, NULL AS valor1, NULL AS valor2

UNION ALL

SELECT
    TO_CHAR(mes, 'MM/YYYY') AS secao,
    qtd_pedidos::TEXT AS item,
    total_vendas::TEXT AS valor1,
    COALESCE(taxa_crescimento::TEXT, '-') AS valor2
FROM vendas_com_comparacao
ORDER BY secao DESC
LIMIT 3;

-- Top 5 Produtos (separado para melhor visualização)
SELECT
    'Top Produtos' AS tipo,
    produto,
    qtd_vendida,
    valor_total
FROM top_produtos;

-- Top 5 Clientes (separado para melhor visualização)
SELECT
    'Top Clientes' AS tipo,
    cliente,
    qtd_pedidos,
    valor_total
FROM top_clientes;


-- Versão alternativa mais organizada do Dashboard:
WITH
vendas_mes_atual AS (
    SELECT
        COUNT(*) AS qtd_pedidos,
        SUM(valor_total) AS total_vendas,
        ROUND(AVG(valor_total), 2) AS ticket_medio
    FROM pedidos
    WHERE DATE_TRUNC('month', data_pedido) = DATE_TRUNC('month', CURRENT_DATE)
),
vendas_mes_anterior AS (
    SELECT
        COUNT(*) AS qtd_pedidos,
        SUM(valor_total) AS total_vendas
    FROM pedidos
    WHERE DATE_TRUNC('month', data_pedido) = DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
)
SELECT
    'Mês Atual' AS periodo,
    a.qtd_pedidos,
    a.total_vendas,
    a.ticket_medio,
    ROUND(
        100.0 * (a.total_vendas - b.total_vendas) / NULLIF(b.total_vendas, 0),
        2
    ) AS crescimento_percentual
FROM vendas_mes_atual a
CROSS JOIN vendas_mes_anterior b;
