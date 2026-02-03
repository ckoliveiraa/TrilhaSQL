-- =================================================================
-- MODULO 14 - CTEs & OTIMIZACAO - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 63 - CTE (Common Table Expression)
-- =================================================================

-- Aula 63 - Desafio 1: Criar CTE com produtos mais vendidos e depois filtrar top 10
-- A CTE deve calcular o total vendido de cada produto

WITH produtos_vendidos AS (
    SELECT
        produto_id,
        SUM(quantidade) AS total_vendido
    FROM itens_pedido
    GROUP BY produto_id
)
SELECT
    p.nome,
    p.marca,
    p.preco,
    pv.total_vendido
FROM produtos p
INNER JOIN produtos_vendidos pv ON p.produto_id = pv.produto_id
ORDER BY pv.total_vendido DESC
LIMIT 10;


-- Aula 63 - Desafio 2: Criar CTE com resumo de clientes e calcular medias
-- Mostre clientes que gastaram acima da media geral

WITH resumo_clientes AS (
    SELECT
        cliente_id,
        COUNT(*) AS qtd_pedidos,
        SUM(valor_total) AS total_gasto
    FROM pedidos
    GROUP BY cliente_id
),
media_geral AS (
    SELECT AVG(total_gasto) AS media
    FROM resumo_clientes
)
SELECT
    c.nome,
    c.email,
    c.cidade,
    rc.qtd_pedidos,
    rc.total_gasto,
    mg.media AS media_geral,
    rc.total_gasto - mg.media AS diferenca_media
FROM clientes c
INNER JOIN resumo_clientes rc ON c.cliente_id = rc.cliente_id
CROSS JOIN media_geral mg
WHERE rc.total_gasto > mg.media
ORDER BY rc.total_gasto DESC;


-- =================================================================
-- AULA 64 - CTE Recursiva - Hierarquias
-- =================================================================

-- Aula 64 - Desafio 1: Criar hierarquia de categorias (se houver subcategorias)
-- Use CTE recursiva para mostrar categorias e suas subcategorias
-- Nota: O modelo atual nao possui subcategorias, entao faremos uma simulacao
-- mostrando como seria se a tabela categorias tivesse uma coluna categoria_pai_id

-- Simulacao de hierarquia de categorias (caso houvesse categoria_pai_id)
/*
WITH RECURSIVE hierarquia_categorias AS (
    -- Caso base: categorias raiz (sem pai)
    SELECT
        categoria_id,
        nome,
        NULL::INT AS categoria_pai_id,
        1 AS nivel,
        nome AS caminho
    FROM categorias
    WHERE categoria_id IN (SELECT MIN(categoria_id) FROM categorias) -- Simula raiz

    UNION ALL

    -- Caso recursivo: subcategorias
    SELECT
        c.categoria_id,
        c.nome,
        hc.categoria_id AS categoria_pai_id,
        hc.nivel + 1,
        hc.caminho || ' > ' || c.nome
    FROM categorias c
    INNER JOIN hierarquia_categorias hc ON c.categoria_id > hc.categoria_id
    WHERE hc.nivel < 3
)
SELECT * FROM hierarquia_categorias
ORDER BY caminho;
*/

-- Versao alternativa: Listar todas as categorias com seus produtos (hierarquia simples)
WITH categorias_produtos AS (
    SELECT
        cat.categoria_id,
        cat.nome AS categoria,
        cat.descricao,
        COUNT(p.produto_id) AS qtd_produtos,
        COALESCE(SUM(p.preco * p.estoque), 0) AS valor_estoque
    FROM categorias cat
    LEFT JOIN produtos p ON cat.categoria_id = p.categoria_id AND p.ativo = true
    WHERE cat.ativo = true
    GROUP BY cat.categoria_id, cat.nome, cat.descricao
)
SELECT
    categoria,
    descricao,
    qtd_produtos,
    valor_estoque
FROM categorias_produtos
ORDER BY qtd_produtos DESC;


-- Aula 64 - Desafio 2: Gerar sequencia de numeros de 1 a 100
-- Use CTE recursiva

WITH RECURSIVE numeros AS (
    -- Caso base: comeca com 1
    SELECT 1 AS n

    UNION ALL

    -- Caso recursivo: soma 1 ao anterior ate 100
    SELECT n + 1
    FROM numeros
    WHERE n < 100
)
SELECT n FROM numeros;


-- =================================================================
-- AULA 65 - Dicas de Performance e Otimizacao
-- =================================================================

-- Aula 65 - Desafio 1: Comparar tempo de execucao de queries com e sem indice
-- Use EXPLAIN ANALYZE antes e depois de criar um indice

-- Passo 1: Analisar query SEM indice
EXPLAIN ANALYZE
SELECT * FROM produtos WHERE marca = 'Samsung';

-- Passo 2: Criar indice na coluna marca
CREATE INDEX idx_produtos_marca ON produtos(marca);

-- Passo 3: Analisar query COM indice
EXPLAIN ANALYZE
SELECT * FROM produtos WHERE marca = 'Samsung';

-- Passo 4: (Opcional) Remover o indice apos teste
-- DROP INDEX idx_produtos_marca;


-- Aula 65 - Desafio 2: Otimizar uma query complexa usando EXPLAIN
-- Analise o plano de execucao e sugira melhorias

-- Query original (pode ser lenta)
EXPLAIN ANALYZE
SELECT
    c.nome AS cliente,
    p.data_pedido,
    SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
INNER JOIN itens_pedido ip ON p.pedido_id = ip.pedido_id
WHERE p.data_pedido >= '2024-01-01'
GROUP BY c.nome, p.data_pedido
ORDER BY total_pedido DESC;

-- Sugestoes de otimizacao:
-- 1. Criar indice na coluna data_pedido
CREATE INDEX idx_pedidos_data ON pedidos(data_pedido);

-- 2. Criar indice composto para JOINs frequentes
CREATE INDEX idx_itens_pedido_pedido_id ON itens_pedido(pedido_id);

-- 3. Executar novamente e comparar
EXPLAIN ANALYZE
SELECT
    c.nome AS cliente,
    p.data_pedido,
    SUM(ip.quantidade * ip.preco_unitario) AS total_pedido
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
INNER JOIN itens_pedido ip ON p.pedido_id = ip.pedido_id
WHERE p.data_pedido >= '2024-01-01'
GROUP BY c.nome, p.data_pedido
ORDER BY total_pedido DESC;


-- =================================================================
-- DESAFIOS FINAIS DO MODULO 14
-- =================================================================

-- Desafio Final 1: CTE com Analise Completa
-- Crie uma CTE que calcule para cada cliente:
-- - Total de pedidos
-- - Valor total gasto
-- - Ticket medio
-- Depois use essa CTE para mostrar apenas os top 10 clientes

WITH analise_clientes AS (
    SELECT
        cliente_id,
        COUNT(*) AS total_pedidos,
        SUM(valor_total) AS valor_total_gasto,
        ROUND(AVG(valor_total), 2) AS ticket_medio
    FROM pedidos
    GROUP BY cliente_id
)
SELECT
    c.nome,
    c.email,
    c.cidade,
    c.estado,
    ac.total_pedidos,
    ac.valor_total_gasto,
    ac.ticket_medio
FROM clientes c
INNER JOIN analise_clientes ac ON c.cliente_id = ac.cliente_id
ORDER BY ac.valor_total_gasto DESC
LIMIT 10;


-- Desafio Final 2: CTE Recursiva de Datas
-- Gere todas as datas do ultimo mes
-- Use essa lista para fazer um relatorio de vendas diarias
-- (inclusive dias sem vendas, mostrando 0)

WITH RECURSIVE datas_mes AS (
    -- Primeiro dia do mes atual
    SELECT DATE_TRUNC('month', CURRENT_DATE)::DATE AS data

    UNION ALL

    -- Proximo dia ate o ultimo dia do mes
    SELECT (data + INTERVAL '1 day')::DATE
    FROM datas_mes
    WHERE data < (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month' - INTERVAL '1 day')::DATE
),
vendas_diarias AS (
    SELECT
        data_pedido,
        COUNT(*) AS qtd_pedidos,
        SUM(valor_total) AS total_vendas
    FROM pedidos
    WHERE data_pedido >= DATE_TRUNC('month', CURRENT_DATE)
      AND data_pedido < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'
    GROUP BY data_pedido
)
SELECT
    dm.data,
    TO_CHAR(dm.data, 'Day') AS dia_semana,
    COALESCE(vd.qtd_pedidos, 0) AS qtd_pedidos,
    COALESCE(vd.total_vendas, 0) AS total_vendas
FROM datas_mes dm
LEFT JOIN vendas_diarias vd ON dm.data = vd.data_pedido
ORDER BY dm.data;


-- Desafio Final 3: Analise de Performance
-- Use EXPLAIN ANALYZE em diferentes versoes da mesma query:

-- a) Query com subquery no WHERE
EXPLAIN ANALYZE
SELECT *
FROM clientes c
WHERE cliente_id IN (
    SELECT cliente_id
    FROM pedidos
    WHERE valor_total > 1000
);

-- b) Mesma query com JOIN
EXPLAIN ANALYZE
SELECT DISTINCT c.*
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.valor_total > 1000;

-- c) Mesma query com CTE
EXPLAIN ANALYZE
WITH clientes_vip AS (
    SELECT DISTINCT cliente_id
    FROM pedidos
    WHERE valor_total > 1000
)
SELECT c.*
FROM clientes c
INNER JOIN clientes_vip cv ON c.cliente_id = cv.cliente_id;

-- d) Versao com EXISTS (geralmente mais eficiente)
EXPLAIN ANALYZE
SELECT *
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM pedidos p
    WHERE p.cliente_id = c.cliente_id
      AND p.valor_total > 1000
);


-- Desafio Final 4 (Boss Final!): Dashboard Executivo
-- Crie um relatorio completo usando CTEs que mostre:
-- - Resumo de vendas do mes atual
-- - Comparacao com mes anterior (usando LAG)
-- - Top 5 produtos mais vendidos
-- - Top 5 clientes que mais compraram
-- - Taxa de crescimento

WITH
-- Vendas por mes
vendas_mensais AS (
    SELECT
        DATE_TRUNC('month', data_pedido)::DATE AS mes,
        COUNT(*) AS qtd_pedidos,
        SUM(valor_total) AS total_vendas,
        ROUND(AVG(valor_total), 2) AS ticket_medio
    FROM pedidos
    WHERE data_pedido >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '2 months'
    GROUP BY DATE_TRUNC('month', data_pedido)
),

-- Comparacao com mes anterior
comparacao_mensal AS (
    SELECT
        mes,
        qtd_pedidos,
        total_vendas,
        ticket_medio,
        LAG(total_vendas) OVER (ORDER BY mes) AS vendas_mes_anterior,
        CASE
            WHEN LAG(total_vendas) OVER (ORDER BY mes) > 0
            THEN ROUND(((total_vendas - LAG(total_vendas) OVER (ORDER BY mes)) /
                 LAG(total_vendas) OVER (ORDER BY mes)) * 100, 2)
            ELSE NULL
        END AS taxa_crescimento_percentual
    FROM vendas_mensais
),

-- Top 5 produtos mais vendidos
top_produtos AS (
    SELECT
        p.nome AS produto,
        p.marca,
        SUM(ip.quantidade) AS qtd_vendida,
        SUM(ip.quantidade * ip.preco_unitario) AS receita_total,
        ROW_NUMBER() OVER (ORDER BY SUM(ip.quantidade) DESC) AS ranking
    FROM itens_pedido ip
    INNER JOIN produtos p ON ip.produto_id = p.produto_id
    INNER JOIN pedidos ped ON ip.pedido_id = ped.pedido_id
    WHERE ped.data_pedido >= DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY p.produto_id, p.nome, p.marca
),

-- Top 5 clientes que mais compraram
top_clientes AS (
    SELECT
        c.nome AS cliente,
        c.cidade,
        c.estado,
        COUNT(p.pedido_id) AS qtd_pedidos,
        SUM(p.valor_total) AS total_gasto,
        ROW_NUMBER() OVER (ORDER BY SUM(p.valor_total) DESC) AS ranking
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
    WHERE p.data_pedido >= DATE_TRUNC('month', CURRENT_DATE)
    GROUP BY c.cliente_id, c.nome, c.cidade, c.estado
)

-- Resultado do Dashboard
SELECT '=== RESUMO DE VENDAS ===' AS secao, NULL AS detalhe1, NULL AS detalhe2, NULL AS valor1, NULL AS valor2
UNION ALL
SELECT
    TO_CHAR(mes, 'Month/YYYY'),
    'Pedidos: ' || qtd_pedidos::TEXT,
    'Ticket Medio: R$' || ticket_medio::TEXT,
    total_vendas,
    taxa_crescimento_percentual
FROM comparacao_mensal
WHERE mes >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'

UNION ALL
SELECT '=== TOP 5 PRODUTOS ===' AS secao, NULL, NULL, NULL, NULL

UNION ALL
SELECT
    ranking || '. ' || produto,
    marca,
    'Qtd: ' || qtd_vendida::TEXT,
    receita_total,
    NULL
FROM top_produtos
WHERE ranking <= 5

UNION ALL
SELECT '=== TOP 5 CLIENTES ===' AS secao, NULL, NULL, NULL, NULL

UNION ALL
SELECT
    ranking || '. ' || cliente,
    cidade || '/' || estado,
    'Pedidos: ' || qtd_pedidos::TEXT,
    total_gasto,
    NULL
FROM top_clientes
WHERE ranking <= 5;


-- =================================================================
-- VERSAO ALTERNATIVA DO DASHBOARD (mais estruturada)
-- =================================================================

-- Parte 1: Resumo de Vendas Mensais com Comparacao
WITH vendas_mensais AS (
    SELECT
        DATE_TRUNC('month', data_pedido)::DATE AS mes,
        COUNT(*) AS qtd_pedidos,
        SUM(valor_total) AS total_vendas,
        ROUND(AVG(valor_total), 2) AS ticket_medio
    FROM pedidos
    GROUP BY DATE_TRUNC('month', data_pedido)
)
SELECT
    TO_CHAR(mes, 'YYYY-MM') AS mes,
    qtd_pedidos,
    total_vendas,
    ticket_medio,
    LAG(total_vendas) OVER (ORDER BY mes) AS vendas_mes_anterior,
    ROUND(
        CASE
            WHEN LAG(total_vendas) OVER (ORDER BY mes) > 0
            THEN ((total_vendas - LAG(total_vendas) OVER (ORDER BY mes)) /
                 LAG(total_vendas) OVER (ORDER BY mes)) * 100
            ELSE 0
        END, 2
    ) AS crescimento_percentual
FROM vendas_mensais
ORDER BY mes DESC
LIMIT 3;

-- Parte 2: Top 5 Produtos do Mes
SELECT
    p.nome AS produto,
    p.marca,
    SUM(ip.quantidade) AS qtd_vendida,
    SUM(ip.quantidade * ip.preco_unitario) AS receita_total
FROM itens_pedido ip
INNER JOIN produtos p ON ip.produto_id = p.produto_id
INNER JOIN pedidos ped ON ip.pedido_id = ped.pedido_id
WHERE ped.data_pedido >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY p.produto_id, p.nome, p.marca
ORDER BY qtd_vendida DESC
LIMIT 5;

-- Parte 3: Top 5 Clientes do Mes
SELECT
    c.nome AS cliente,
    c.cidade,
    c.estado,
    COUNT(p.pedido_id) AS qtd_pedidos,
    SUM(p.valor_total) AS total_gasto
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.data_pedido >= DATE_TRUNC('month', CURRENT_DATE)
GROUP BY c.cliente_id, c.nome, c.cidade, c.estado
ORDER BY total_gasto DESC
LIMIT 5;
