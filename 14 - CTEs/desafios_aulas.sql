-- =================================================================
-- AULA 59 - DESAFIO 1: RANKING DE PRODUTOS MAIS VENDIDOS
-- =================================================================
-- A gerência quer saber quais são os 10 produtos campeões de vendas.
--
-- Crie uma consulta usando CTE que mostre o ranking dos 10 produtos
-- mais vendidos, incluindo o nome do produto e a quantidade total vendida.
--
-- Dica: Pense em como organizar primeiro os dados de vendas e depois
-- juntar com as informações dos produtos.

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


-- =================================================================
-- AULA 59 - DESAFIO 2: IDENTIFICANDO CLIENTES VIP
-- =================================================================
-- O departamento de marketing precisa identificar os clientes VIP
-- para criar uma campanha especial.
--
-- Crie uma consulta com CTEs que mostre apenas os clientes que gastaram
-- ACIMA DA MÉDIA GERAL de todos os clientes. O relatório deve incluir:
-- - Nome do cliente
-- - Quantidade de pedidos
-- - Total gasto
-- - A média geral (para comparação)
-- - Quanto cada cliente gastou acima da média
--
-- Desafio extra: Classifique os clientes em categorias (VIP Premium, VIP, etc.)
-- baseado em quanto eles superam a média.

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


-- =================================================================
-- AULA 60 - DESAFIO 1: GERADOR DE SEQUÊNCIAS
-- =================================================================
-- Você precisa gerar uma lista com os números de 1 a 100.
--
-- Use uma CTE recursiva para criar essa sequência. Lembre-se que
-- toda recursão precisa de:
-- - Um ponto de partida (caso base)
-- - Uma regra de repetição (caso recursivo)
-- - Uma condição de parada

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


-- =================================================================
-- AULA 60 - DESAFIO 2: RELATÓRIO DE VENDAS DIÁRIAS COMPLETO
-- =================================================================
-- O diretor financeiro precisa de um relatório de vendas que mostre
-- TODOS OS DIAS de janeiro de 2024, mesmo os dias que não tiveram
-- nenhuma venda (mostrando 0).
--
-- Use CTE recursiva para gerar um calendário completo do mês e depois
-- combine com os dados de vendas. O relatório deve mostrar:
-- - A data
-- - O dia da semana
-- - Total de vendas do dia (ou 0 se não houve vendas)
-- - Quantidade de pedidos do dia (ou 0 se não houve)
--
-- Desafio extra: Adicione uma coluna que identifique se o dia
-- é fim de semana ou dia útil.

WITH RECURSIVE
calendario_janeiro AS (
    -- Caso base: primeiro dia de janeiro
    SELECT DATE '2024-01-01' AS data

    UNION ALL

    -- Caso recursivo: adiciona 1 dia
    SELECT CAST(data + INTERVAL '1 day' AS DATE)
    FROM calendario_janeiro
    WHERE data < '2024-01-31'
),
vendas_diarias AS (
    SELECT
        CAST(data_pedido AS DATE) AS data,
        SUM(valor_total) AS total_vendas,
        COUNT(*) AS qtd_pedidos
    FROM pedidos
    WHERE data_pedido >= '2024-01-01'
      AND data_pedido < '2024-02-01'
    GROUP BY CAST(data_pedido AS DATE)
)
SELECT
    c.data,
    TO_CHAR(c.data, 'Day') AS dia_semana,
    COALESCE(v.total_vendas, 0) AS total_vendas,
    COALESCE(v.qtd_pedidos, 0) AS qtd_pedidos,
    CASE
        WHEN EXTRACT(DOW FROM c.data) IN (0, 6) THEN 'Fim de semana'
        ELSE 'Dia útil'
    END AS tipo_dia
FROM calendario_janeiro c
LEFT JOIN vendas_diarias v ON c.data = v.data
ORDER BY c.data;
