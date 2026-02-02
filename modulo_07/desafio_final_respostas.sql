-- ============================================
-- MÓDULO 7 - SUBCONSULTAS
-- Respostas do Desafio Final
-- ============================================

-- Desafio Final 1: Produtos Acima da Média da Categoria
-- Liste todos os produtos com preço acima da média da sua categoria
-- Mostre: nome do produto, preço, nome da categoria, preço médio da categoria

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


-- Desafio Final 2: Clientes VIP
-- Encontre os clientes cujo total gasto está acima da média de todos os clientes
-- Mostre: nome, email, total gasto, média geral

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


-- Desafio Final 3: Produtos com Estoque Baixo por Categoria
-- Para cada categoria, mostre quantos produtos têm estoque abaixo de 10 unidades
-- Use subconsulta no SELECT

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


-- Desafio Final 4: Produtos em Pedidos Grandes
-- Liste produtos que foram vendidos em pedidos com valor total acima de R$ 1000
-- Use EXISTS

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


-- Desafio Final 5: Relatório Mensal de Vendas
-- Para cada mês: total de vendas, quantidade de pedidos
-- E se esse mês teve vendas acima da média mensal (sim/não)

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


-- Desafio Final 6: Dashboard Completo de Produtos (Boss Final!)
-- Nome do produto, categoria, preço, estoque
-- Total vendido (quantidade), receita gerada
-- Nota média das avaliações
-- Se já foi avaliado (sim/não usando EXISTS)
-- Classificação: "Campeão" se vendeu mais que a média, "Normal" caso contrário

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
