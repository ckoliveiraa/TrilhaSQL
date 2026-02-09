-- =================================================================
-- DESAFIO FINAL 1: CTE COM ANÁLISE COMPLETA DE CLIENTES
-- =================================================================
-- Objetivo: Identificar os 10 clientes mais valiosos da empresa
--
-- Passo 1: Crie uma CTE chamada 'resumo_clientes' que calcule para cada cliente:
--   - cliente_id
--   - nome do cliente
--   - total_pedidos (COUNT de pedidos)
--   - valor_total_gasto (SUM de valor_total dos pedidos)
--   - ticket_medio (ROUND da média de valor_total, 2 decimais)
--   Dica: Use INNER JOIN entre clientes e pedidos, agrupe por cliente_id e nome
--
-- Passo 2: Use essa CTE no SELECT principal para:
--   - Selecionar as colunas: nome AS cliente, total_pedidos, valor_total_gasto, ticket_medio
--   - Ordenar por valor_total_gasto decrescente
--   - Limitar aos TOP 10
--
-- Resultado esperado: 10 linhas com os clientes que mais gastaram

WITH resumo_clientes AS (
    SELECT
        c.cliente_id,
        c.nome,
        COUNT(p.pedido_id) AS total_pedidos,
        SUM(p.valor_total) AS valor_total_gasto,
        ROUND(AVG(p.valor_total), 2) AS ticket_medio
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
    GROUP BY c.cliente_id, c.nome
)
SELECT
    nome AS cliente,
    total_pedidos,
    valor_total_gasto,
    ticket_medio
FROM resumo_clientes
ORDER BY valor_total_gasto DESC
LIMIT 10;


-- =================================================================
-- DESAFIO FINAL 2: CTE RECURSIVA DE DATAS
-- =================================================================
-- Objetivo: Criar um relatório de vendas diárias completo, incluindo dias sem vendas
--
-- Passo 1: Crie uma CTE chamada 'mes_referencia' que define:
--   - primeiro_dia: DATE '2025-12-01'
--   - ultimo_dia: DATE '2025-12-31'
--
-- Passo 2: Crie uma CTE RECURSIVA chamada 'datas_mes' que:
--   - Caso base: SELECT primeiro_dia AS data FROM mes_referencia
--   - Caso recursivo: SELECT data + INTERVAL '1 day' FROM datas_mes
--   - Condição de parada: WHERE data < mes_referencia.ultimo_dia
--   Dica: Use CROSS JOIN com mes_referencia no caso recursivo para acessar ultimo_dia
--
-- Passo 3: Crie uma CTE chamada 'vendas_diarias' que calcule:
--   - data (CAST de data_pedido como DATE)
--   - total_vendas (SUM de valor_total)
--   - qtd_pedidos (COUNT)
--   - Filtre apenas pedidos de dezembro/2025
--   - Agrupe por data
--
-- Passo 4: No SELECT principal:
--   - LEFT JOIN datas_mes com vendas_diarias
--   - Use COALESCE para mostrar 0 quando não houver vendas
--   - Ordene por data
--
-- Resultado esperado: 31 linhas (todos os dias de dezembro), com 0 nos dias sem vendas

WITH RECURSIVE
-- Define dezembro de 2025 como mês de referência
mes_referencia AS (
    SELECT
        DATE '2025-12-01' AS primeiro_dia,
        DATE '2025-12-31' AS ultimo_dia
),
-- CTE recursiva para gerar todas as datas do mês
datas_mes AS (
    -- Caso base: primeiro dia do mês
    SELECT primeiro_dia AS data
    FROM mes_referencia

    UNION ALL

    -- Caso recursivo: adiciona 1 dia até o último dia
    SELECT CAST(data + INTERVAL '1 day' AS DATE)
    FROM datas_mes, mes_referencia
    WHERE data < mes_referencia.ultimo_dia
),
vendas_diarias AS (
    SELECT
        CAST(data_pedido AS DATE) AS data,
        SUM(valor_total) AS total_vendas,
        COUNT(*) AS qtd_pedidos
    FROM pedidos
    WHERE valor_total > 0
      AND data_pedido >= (SELECT primeiro_dia FROM mes_referencia)
      AND data_pedido <= (SELECT ultimo_dia FROM mes_referencia)
    GROUP BY CAST(data_pedido AS DATE)
)
SELECT
    d.data,
    COALESCE(v.total_vendas, 0) AS total_vendas,
    COALESCE(v.qtd_pedidos, 0) AS qtd_pedidos
FROM datas_mes d
LEFT JOIN vendas_diarias v ON d.data = v.data
ORDER BY d.data;


-- =================================================================
-- DESAFIO FINAL 3: MÚLTIPLAS CTES ENCADEADAS
-- =================================================================
-- Objetivo: Identificar produtos com desempenho acima da média usando CTEs encadeadas
--
-- Passo 1: Crie CTE 'vendas_por_produto' que calcule:
--   - produto_id, nome
--   - total_vendido (SUM de quantidade dos itens_pedido)
--   - receita_total (SUM de quantidade * preco_unitario)
--   Dica: JOIN produtos com itens_pedido, agrupe por produto_id e nome
--
-- Passo 2: Crie CTE 'media_vendas' que calcule:
--   - media_qtd (AVG de total_vendido da CTE anterior)
--   - media_receita (AVG de receita_total da CTE anterior)
--   Dica: Essa CTE usa vendas_por_produto
--
-- Passo 3: Crie CTE 'produtos_acima_media' que:
--   - Selecione todos os campos de vendas_por_produto
--   - Adicione as médias da CTE media_vendas (use CROSS JOIN)
--   - Calcule perc_acima_media_qtd: ((total_vendido - media_qtd) / media_qtd * 100)
--   - Calcule perc_acima_media_receita: ((receita_total - media_receita) / media_receita * 100)
--   - Filtre WHERE total_vendido > media_qtd OR receita_total > media_receita
--
-- Passo 4: No SELECT principal:
--   - Selecione: nome, total_vendido, receita_total, médias e percentuais
--   - Use ROUND para formatar decimais
--   - Ordene por receita_total DESC
--
-- Resultado esperado: Produtos que performaram acima da média

WITH
-- CTE 1: Vendas totais por produto
vendas_por_produto AS (
    SELECT
        p.produto_id,
        p.nome,
        SUM(ip.quantidade) AS total_vendido,
        SUM(ip.quantidade * ip.preco_unitario) AS receita_total
    FROM produtos p
    INNER JOIN itens_pedido ip ON p.produto_id = ip.produto_id
    GROUP BY p.produto_id, p.nome
),
-- CTE 2: Média de vendas usando a CTE 1
media_vendas AS (
    SELECT
        AVG(total_vendido) AS media_qtd,
        AVG(receita_total) AS media_receita
    FROM vendas_por_produto
),
-- CTE 3: Produtos acima da média usando as CTEs anteriores
produtos_acima_media AS (
    SELECT
        vp.nome,
        vp.total_vendido,
        vp.receita_total,
        mv.media_qtd,
        mv.media_receita,
        ROUND(((vp.total_vendido - mv.media_qtd) / mv.media_qtd * 100), 2) AS perc_acima_media_qtd,
        ROUND(((vp.receita_total - mv.media_receita) / mv.media_receita * 100), 2) AS perc_acima_media_receita
    FROM vendas_por_produto vp
    CROSS JOIN media_vendas mv
    WHERE vp.total_vendido > mv.media_qtd
       OR vp.receita_total > mv.media_receita
)
SELECT
    nome AS produto,
    total_vendido,
    receita_total,
    ROUND(media_qtd, 2) AS media_quantidade,
    ROUND(media_receita, 2) AS media_receita,
    perc_acima_media_qtd AS percent_acima_media_qtd,
    perc_acima_media_receita AS percent_acima_media_receita
FROM produtos_acima_media
ORDER BY receita_total DESC;


-- =================================================================
-- DESAFIO FINAL 4 (BOSS FINAL!): DASHBOARD EXECUTIVO
-- =================================================================
-- Objetivo: Criar um dashboard executivo completo com comparações e rankings
--
-- Passo 1: CTE 'mes_referencia'
--   - Encontre o mês mais recente: DATE_TRUNC('month', MAX(data_pedido))
--   - CAST como DATE e nomeie como 'ultimo_mes'
--
-- Passo 2: CTE 'vendas_mensais'
--   - Calcule para cada mês dos últimos 3 meses:
--     - mes (DATE_TRUNC de data_pedido)
--     - total_pedidos (COUNT)
--     - total_vendas (SUM de valor_total)
--     - ticket_medio (AVG de valor_total, arredondado)
--   - Filtre WHERE data_pedido >= (ultimo_mes - 2 meses)
--
-- Passo 3: CTE 'comparacao_mensal'
--   - Selecione todas as colunas de vendas_mensais
--   - Adicione vendas_mes_anterior: LAG(total_vendas) OVER (ORDER BY mes)
--   - Calcule taxa_crescimento: 100 * (total_vendas - vendas_mes_anterior) / vendas_mes_anterior
--   - Use NULLIF para evitar divisão por zero
--
-- Passo 4: CTE 'top_produtos'
--   - Calcule para o último mês:
--     - nome do produto
--     - total_vendido (SUM de quantidade)
--     - receita (SUM de quantidade * preco_unitario)
--   - Filtre apenas pedidos do último mês
--   - LIMIT 5
--
-- Passo 5: CTE 'top_clientes'
--   - Calcule para o último mês:
--     - nome do cliente
--     - qtd_pedidos (COUNT)
--     - total_gasto (SUM de valor_total)
--   - Filtre apenas pedidos do último mês
--   - LIMIT 5
--
-- Passo 6: SELECT principal - Combine tudo com UNION ALL
--   - Seção 1: RESUMO MENSAL (da comparacao_mensal do último mês)
--   - Seção 2: TOP 5 PRODUTOS (da top_produtos)
--   - Seção 3: TOP 5 CLIENTES (da top_clientes)
--   Dica: Use CAST(...AS TEXT) para padronizar colunas no UNION ALL
--
-- Resultado esperado: 1 linha de resumo + 5 produtos + 5 clientes = 11 linhas
--
-- DICA EXTRA: Este é o desafio mais complexo! Construa uma CTE por vez e teste antes de avançar.

WITH
-- Encontra o mês mais recente com dados
mes_referencia AS (
    SELECT CAST(DATE_TRUNC('month', MAX(data_pedido)) AS DATE) AS ultimo_mes
    FROM pedidos
),
-- Vendas por mês (últimos 3 meses com dados)
vendas_mensais AS (
    SELECT
        CAST(DATE_TRUNC('month', data_pedido) AS DATE) AS mes,
        COUNT(pedido_id) AS total_pedidos,
        SUM(valor_total) AS total_vendas,
        ROUND(AVG(valor_total), 2) AS ticket_medio
    FROM pedidos
    WHERE data_pedido >= (
        SELECT CAST(DATE_TRUNC('month', MAX(data_pedido) - INTERVAL '2 months') AS DATE)
        FROM pedidos
    )
    GROUP BY DATE_TRUNC('month', data_pedido)
),
-- Comparação mês a mês com LAG
comparacao_mensal AS (
    SELECT
        mes,
        total_pedidos,
        total_vendas,
        ticket_medio,
        LAG(total_vendas) OVER (ORDER BY mes) AS vendas_mes_anterior,
        ROUND(
            100.0 * (total_vendas - LAG(total_vendas) OVER (ORDER BY mes))
            / NULLIF(LAG(total_vendas) OVER (ORDER BY mes), 0),
            2
        ) AS taxa_crescimento
    FROM vendas_mensais
),
-- Top 5 produtos mais vendidos no último mês
top_produtos AS (
    SELECT
        p.nome AS produto,
        SUM(ip.quantidade) AS total_vendido,
        ROUND(SUM(ip.quantidade * ip.preco_unitario), 2) AS receita
    FROM produtos p
    INNER JOIN itens_pedido ip ON p.produto_id = ip.produto_id
    INNER JOIN pedidos ped ON ip.pedido_id = ped.pedido_id
    WHERE CAST(DATE_TRUNC('month', ped.data_pedido) AS DATE) = (SELECT ultimo_mes FROM mes_referencia)
    GROUP BY p.produto_id, p.nome
    ORDER BY total_vendido DESC
    LIMIT 5
),
-- Top 5 clientes que mais compraram no último mês
top_clientes AS (
    SELECT
        c.nome AS cliente,
        COUNT(p.pedido_id) AS qtd_pedidos,
        ROUND(SUM(p.valor_total), 2) AS total_gasto
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
    WHERE CAST(DATE_TRUNC('month', p.data_pedido) AS DATE) = (SELECT ultimo_mes FROM mes_referencia)
    GROUP BY c.cliente_id, c.nome
    ORDER BY total_gasto DESC
    LIMIT 5
)
-- Resultado final combinando todas as CTEs
SELECT
    'RESUMO MENSAL' AS secao,
    TO_CHAR(mes, 'YYYY-MM') AS periodo,
    CAST(total_pedidos AS TEXT) AS valor1,
    CAST(total_vendas AS TEXT) AS valor2,
    CAST(ticket_medio AS TEXT) AS valor3,
    COALESCE(CAST(taxa_crescimento AS TEXT), 'N/A') AS taxa_crescimento
FROM comparacao_mensal
WHERE mes = (SELECT ultimo_mes FROM mes_referencia)

UNION ALL

SELECT
    'TOP 5 PRODUTOS' AS secao,
    produto AS periodo,
    CAST(total_vendido AS TEXT) AS valor1,
    CAST(receita AS TEXT) AS valor2,
    NULL AS valor3,
    NULL AS taxa_crescimento
FROM top_produtos

UNION ALL

SELECT
    'TOP 5 CLIENTES' AS secao,
    cliente AS periodo,
    CAST(qtd_pedidos AS TEXT) AS valor1,
    CAST(total_gasto AS TEXT) AS valor2,
    NULL AS valor3,
    NULL AS taxa_crescimento
FROM top_clientes;