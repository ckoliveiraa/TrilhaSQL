-- Aula 59 - Desafio 1: Ranking de Produtos Mais Vendidos
-- A gerência quer saber quais são os 10 produtos campeões de vendas.
-- Crie uma consulta usando CTE que mostre o ranking dos 10 produtos
-- mais vendidos, incluindo o nome do produto e a quantidade total vendida.
WITH produtos_vendidos AS (
    SELECT
        produto_id,
        SUM(quantidade) AS total_vendido
    FROM itens_pedido
    GROUP BY produto_id
)
SELECT
    p.nome AS produto,
    pv.total_vendido
FROM produtos p
INNER JOIN produtos_vendidos pv ON p.produto_id = pv.produto_id
ORDER BY pv.total_vendido DESC
LIMIT 10;

-- Aula 59 - Desafio 2: Identificando Clientes VIP
-- O departamento de marketing precisa identificar os clientes VIP
-- para criar uma campanha especial.
-- Crie uma consulta com CTEs que mostre apenas os clientes que gastaram
-- ACIMA DA MÉDIA GERAL de todos os clientes. O relatório deve incluir:
-- nome, quantidade de pedidos, total gasto, média geral e diferença para a média.
WITH
vendas_por_cliente AS (
    SELECT
        cliente_id,
        COUNT(*) AS qtd_pedidos,
        SUM(valor_total) AS total_gasto
    FROM pedidos
    GROUP BY cliente_id
),
media_geral AS (
    SELECT AVG(total_gasto) AS media
    FROM vendas_por_cliente
)
SELECT
    c.nome AS cliente,
    v.qtd_pedidos,
    ROUND(v.total_gasto, 2) AS total_gasto,
    ROUND(m.media, 2) AS media_geral,
    ROUND(v.total_gasto - m.media, 2) AS diferenca_para_media,
    CASE
        WHEN v.total_gasto > m.media * 2 THEN 'VIP Premium'
        WHEN v.total_gasto > m.media * 1.5 THEN 'VIP'
        ELSE 'Acima da média'
    END AS classificacao
FROM clientes c
INNER JOIN vendas_por_cliente v ON c.cliente_id = v.cliente_id
CROSS JOIN media_geral m
WHERE v.total_gasto > m.media
ORDER BY v.total_gasto DESC;

-- Aula 60 - Desafio 1: Gerador de Sequências
-- Você precisa gerar uma lista com os números de 1 a 100.
-- Use uma CTE recursiva para criar essa sequência.
-- Lembre-se: toda recursão precisa de um ponto de partida,
-- uma regra de repetição e uma condição de parada.
WITH RECURSIVE add_numeros AS (
    -- Caso base: começa com 1
    SELECT 1 AS numero

    UNION ALL

    -- Caso recursivo: soma 1 ao número anterior
    SELECT numero + 1
    FROM add_numeros
    WHERE numero < 100  -- Para quando chegar em 100
)
SELECT numero
FROM add_numeros;

-- Aula 60 - Desafio 2: Relatório de Vendas Diárias Completo
-- O diretor financeiro precisa de um relatório de vendas que mostre
-- TODOS OS DIAS de janeiro de 2026, mesmo os dias que não tiveram vendas.
-- Use CTE recursiva para gerar um calendário completo do mês e combine
-- com os dados de vendas. Mostre: data, dia da semana, total de vendas
-- e quantidade de pedidos (use 0 para dias sem vendas).
WITH RECURSIVE
calendario_janeiro AS (
    -- Caso base: primeiro dia de janeiro
    SELECT DATE '2026-01-01' AS data

    UNION ALL

    -- Caso recursivo: adiciona 1 dia
    SELECT CAST(data + INTERVAL '1 day' AS DATE)
    FROM calendario_janeiro
    WHERE data < '2026-01-31'
),
vendas_diarias AS (
    SELECT
        CAST(data_pedido AS DATE) AS data,
        SUM(valor_total) AS total_vendas,
        COUNT(*) AS qtd_pedidos
    FROM pedidos
    WHERE data_pedido >= '2026-01-01'
      AND data_pedido < '2026-02-01'
    GROUP BY CAST(data_pedido AS DATE)
)
SELECT
    c.data,
    TO_CHAR(c.data, 'Day') AS dia_semana,
    COALESCE(v.total_vendas, 0) AS total_vendas,
    COALESCE(v.qtd_pedidos, 0) AS qtd_pedidos
FROM calendario_janeiro c
LEFT JOIN vendas_diarias v ON c.data = v.data
ORDER BY c.data;


