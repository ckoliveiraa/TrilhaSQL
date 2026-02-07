-- ============================================
-- MÓDULO 12 - SUBCONSULTAS
-- Respostas do Desafio Final
-- ============================================

-- Desafio Final 1: Produtos com preço acima da média da sua categoria
-- Use subconsultas no WHERE (para filtrar) e no SELECT (para calcular a média)
-- Mostre: nome do produto, preço, nome da categoria e preço médio da categoria
-- Ordene por categoria e depois por preço (do mais caro para o mais barato)

SELECT
    p.nome AS produto,
    p.preco,
    c.nome AS categoria,
    (
        SELECT ROUND(AVG(p2.preco), 2)
        FROM produtos p2
        WHERE p2.categoria_id = p.categoria_id
    ) AS preco_medio_categoria
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
WHERE p.preco > (
    SELECT AVG(p2.preco)
    FROM produtos p2
    WHERE p2.categoria_id = p.categoria_id
)
ORDER BY c.nome, p.preco DESC;


-- Desafio Final 2: Identificar clientes VIP (gastam acima da média)
-- Use subconsulta no FROM para calcular o total gasto por cliente
-- Use outra subconsulta para calcular a média geral de gastos
-- Mostre: nome, email, total gasto e média geral (apenas clientes acima da média)
-- Ordene do cliente que mais gastou para o que menos gastou

SELECT
    cliente,
    email,
    total_gasto,
    media_geral
FROM (
    SELECT
        c.nome AS cliente,
        c.email,
        SUM(p.valor_total) AS total_gasto
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
    GROUP BY c.cliente_id, c.nome, c.email
) AS gastos_clientes,
(
    SELECT ROUND(AVG(total_por_cliente), 2) AS media_geral
    FROM (
        SELECT SUM(valor_total) AS total_por_cliente
        FROM pedidos
        GROUP BY cliente_id
    ) AS totais
) AS media
WHERE total_gasto > media_geral
ORDER BY total_gasto DESC;


-- Desafio Final 3: Contagem de produtos com estoque baixo por categoria
-- Use uma subconsulta escalar no SELECT para contar produtos com estoque < 10
-- Mostre: nome da categoria e quantidade de produtos com estoque baixo
-- Considere apenas categorias ativas
-- Ordene da categoria com mais produtos em estoque baixo para a com menos

SELECT
    c.nome AS categoria,
    (
        SELECT COUNT(*)
        FROM produtos p
        WHERE p.categoria_id = c.categoria_id
          AND p.estoque < 10
    ) AS produtos_estoque_baixo
FROM categorias c
WHERE c.ativo = TRUE
ORDER BY produtos_estoque_baixo DESC;


-- Desafio Final 4: Produtos vendidos em pedidos de alto valor (acima de R$ 1000)
-- Use EXISTS para verificar se o produto aparece em pedidos grandes
-- Mostre: nome, preço e marca dos produtos (sem duplicatas)
-- Ordene por nome do produto

SELECT DISTINCT
    p.nome AS produto,
    p.preco,
    p.marca
FROM produtos p
WHERE EXISTS (
    SELECT 1
    FROM itens_pedido ip
    INNER JOIN pedidos ped ON ip.pedido_id = ped.pedido_id
    WHERE ip.produto_id = p.produto_id
      AND ped.valor_total > 1000
)
ORDER BY p.nome;


-- Desafio Final 5: Análise mensal de desempenho de vendas
-- Use subconsulta no FROM para agrupar vendas por ano/mês
-- Use outra subconsulta para calcular a média mensal de vendas
-- Mostre: ano, mês, total de vendas, quantidade de pedidos e se superou a média (Sim/Não)
-- Exclua pedidos cancelados da análise
-- Ordene por ano e mês cronologicamente

SELECT
    ano,
    mes,
    total_vendas,
    quantidade_pedidos,
    CASE
        WHEN total_vendas > media_mensal THEN 'Sim'
        ELSE 'Não'
    END AS acima_da_media
FROM (
    SELECT
        EXTRACT(YEAR FROM data_pedido) AS ano,
        EXTRACT(MONTH FROM data_pedido) AS mes,
        SUM(valor_total) AS total_vendas,
        COUNT(*) AS quantidade_pedidos
    FROM pedidos
    WHERE status <> 'cancelado'
    GROUP BY EXTRACT(YEAR FROM data_pedido), EXTRACT(MONTH FROM data_pedido)
) AS vendas_mensais,
(
    SELECT AVG(total_mes) AS media_mensal
    FROM (
        SELECT SUM(valor_total) AS total_mes
        FROM pedidos
        WHERE status <> 'cancelado'
        GROUP BY EXTRACT(YEAR FROM data_pedido), EXTRACT(MONTH FROM data_pedido)
    ) AS totais_mensais
) AS media
ORDER BY ano, mes;


-- Desafio Final 6: Dashboard executivo completo de produtos (Boss Final!)
-- Combine TODOS os tipos de subconsultas: no SELECT, no WHERE e EXISTS
-- Mostre para cada produto:
--   - Nome, categoria, preço, estoque atual
--   - Total de unidades vendidas e receita total gerada
--   - Nota média das avaliações (arredondada para 1 casa decimal)
--   - Se o produto já foi avaliado alguma vez (Sim/Não usando EXISTS)
--   - Classificação: "Campeão" se vendeu acima da média geral, "Normal" caso contrário
-- Ordene do produto mais vendido para o menos vendido
-- DICA: Use COALESCE para produtos que nunca foram vendidos ou avaliados

SELECT
    p.nome AS produto,
    c.nome AS categoria,
    p.preco,
    p.estoque,
    COALESCE(
        (SELECT SUM(ip.quantidade) FROM itens_pedido ip WHERE ip.produto_id = p.produto_id),
        0
    ) AS total_vendido,
    COALESCE(
        (SELECT SUM(ip.quantidade * ip.preco_unitario) FROM itens_pedido ip WHERE ip.produto_id = p.produto_id),
        0
    ) AS receita_gerada,
    (
        SELECT ROUND(AVG(a.nota), 1)
        FROM avaliacoes a
        WHERE a.produto_id = p.produto_id
    ) AS nota_media,
    CASE
        WHEN EXISTS (SELECT 1 FROM avaliacoes a WHERE a.produto_id = p.produto_id)
        THEN 'Sim'
        ELSE 'Não'
    END AS foi_avaliado,
    CASE
        WHEN COALESCE(
            (SELECT SUM(ip.quantidade) FROM itens_pedido ip WHERE ip.produto_id = p.produto_id),
            0
        ) > (
            SELECT AVG(vendas_produto)
            FROM (
                SELECT SUM(quantidade) AS vendas_produto
                FROM itens_pedido
                GROUP BY produto_id
            ) AS media_vendas
        )
        THEN 'Campeão'
        ELSE 'Normal'
    END AS classificacao
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
ORDER BY total_vendido DESC;
