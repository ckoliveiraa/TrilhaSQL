-- =================================================================
-- MODULO 11 - SUBCONSULTAS - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 50 - Subconsulta no WHERE
-- =================================================================

-- Aula 50 - Desafio 1: Mostrar produtos com preço acima da média geral
SELECT nome, preco
FROM produtos
WHERE preco > (SELECT AVG(preco) FROM produtos)
ORDER BY preco DESC;


-- Aula 50 - Desafio 2: Mostrar clientes que fizeram pedidos com valor acima de R$ 1000
SELECT nome, email
FROM clientes
WHERE cliente_id IN (
    SELECT DISTINCT cliente_id
    FROM pedidos
    WHERE valor_total > 1000
)
ORDER BY nome;


-- =================================================================
-- AULA 51 - Subconsulta no FROM (Derived Tables)
-- =================================================================

-- Aula 51 - Desafio 1: Criar uma tabela temporária com resumo de vendas por produto
-- (nome, quantidade vendida, valor total)
SELECT
    produto,
    quantidade_vendida,
    valor_total
FROM (
    SELECT
        p.nome AS produto,
        SUM(ip.quantidade) AS quantidade_vendida,
        SUM(ip.quantidade * ip.preco_unitario) AS valor_total
    FROM itens_pedido ip
    INNER JOIN produtos p ON ip.produto_id = p.produto_id
    GROUP BY p.produto_id, p.nome
) AS resumo_vendas
ORDER BY valor_total DESC;


-- Aula 51 - Desafio 2: Calcular a média de pedidos por cliente usando subquery no FROM
SELECT
    ROUND(AVG(total_pedidos), 2) AS media_pedidos_por_cliente,
    ROUND(AVG(valor_total), 2) AS media_valor_por_cliente
FROM (
    SELECT
        cliente_id,
        COUNT(*) AS total_pedidos,
        SUM(valor_total) AS valor_total
    FROM pedidos
    GROUP BY cliente_id
) AS pedidos_por_cliente;


-- =================================================================
-- AULA 52 - Subconsulta no SELECT (Scalar Subqueries)
-- =================================================================

-- Aula 52 - Desafio 1: Listar produtos com a quantidade total vendida em cada linha
SELECT
    p.nome,
    p.preco,
    p.estoque,
    (
        SELECT COALESCE(SUM(ip.quantidade), 0)
        FROM itens_pedido ip
        WHERE ip.produto_id = p.produto_id
    ) AS total_vendido
FROM produtos p
ORDER BY total_vendido DESC;


-- Aula 52 - Desafio 2: Listar clientes com o total gasto por cada um
SELECT
    c.nome,
    c.email,
    c.cidade,
    (
        SELECT COALESCE(SUM(ped.valor_total), 0)
        FROM pedidos ped
        WHERE ped.cliente_id = c.cliente_id
    ) AS total_gasto
FROM clientes c
ORDER BY total_gasto DESC;


-- =================================================================
-- AULA 53 - EXISTS - Verificando Existência
-- =================================================================

-- Aula 53 - Desafio 1: Listar produtos que já foram vendidos (usando EXISTS)
SELECT p.nome, p.preco, p.estoque
FROM produtos p
WHERE EXISTS (
    SELECT 1
    FROM itens_pedido ip
    WHERE ip.produto_id = p.produto_id
)
ORDER BY p.nome;


-- Aula 53 - Desafio 2: Listar clientes que já fizeram avaliações (usando EXISTS)
SELECT c.nome, c.email
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM avaliacoes a
    WHERE a.cliente_id = c.cliente_id
)
ORDER BY c.nome;


-- =================================================================
-- DESAFIOS FINAIS DO MODULO 11
-- =================================================================

-- Desafio Final 1: Produtos com preço acima da média da sua categoria
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


-- Desafio Final 2: Clientes VIP (total gasto acima da média de todos os clientes)
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
) AS gastos_cliente,
(
    SELECT ROUND(AVG(total), 2) AS media_geral
    FROM (
        SELECT SUM(valor_total) AS total
        FROM pedidos
        GROUP BY cliente_id
    ) AS totais
) AS media
WHERE total_gasto > media_geral
ORDER BY total_gasto DESC;


-- Desafio Final 3: Para cada categoria, quantos produtos têm estoque abaixo de 10 unidades
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
ORDER BY produtos_estoque_baixo DESC;


-- Desafio Final 4: Produtos vendidos em pedidos com valor total acima de R$ 1000
-- Use EXISTS
SELECT DISTINCT p.nome, p.preco
FROM produtos p
WHERE EXISTS (
    SELECT 1
    FROM itens_pedido ip
    INNER JOIN pedidos ped ON ip.pedido_id = ped.pedido_id
    WHERE ip.produto_id = p.produto_id
      AND ped.valor_total > 1000
)
ORDER BY p.nome;


-- Desafio Final 5: Relatório mostrando para cada mês: total de vendas, quantidade de pedidos
-- e se esse mês teve vendas acima da média mensal (sim/não)
SELECT
    ano,
    mes,
    total_vendas,
    qtd_pedidos,
    CASE
        WHEN total_vendas > media_mensal THEN 'Sim'
        ELSE 'Nao'
    END AS acima_da_media
FROM (
    SELECT
        EXTRACT(YEAR FROM data_pedido) AS ano,
        EXTRACT(MONTH FROM data_pedido) AS mes,
        SUM(valor_total) AS total_vendas,
        COUNT(*) AS qtd_pedidos
    FROM pedidos
    GROUP BY EXTRACT(YEAR FROM data_pedido), EXTRACT(MONTH FROM data_pedido)
) AS vendas_mensais,
(
    SELECT AVG(total) AS media_mensal
    FROM (
        SELECT SUM(valor_total) AS total
        FROM pedidos
        GROUP BY EXTRACT(YEAR FROM data_pedido), EXTRACT(MONTH FROM data_pedido)
    ) AS totais_mensais
) AS media
ORDER BY ano, mes;


-- Desafio Final 6 (Boss Final!): Dashboard de produtos
-- Nome, Categoria, Preço, Estoque, Total vendido, Receita gerada,
-- Nota média, Se já foi avaliado (sim/não), Classificação (Campeão/Normal)
SELECT
    p.nome AS produto,
    c.nome AS categoria,
    p.preco,
    p.estoque,
    (
        SELECT COALESCE(SUM(ip.quantidade), 0)
        FROM itens_pedido ip
        WHERE ip.produto_id = p.produto_id
    ) AS total_vendido,
    (
        SELECT COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0)
        FROM itens_pedido ip
        WHERE ip.produto_id = p.produto_id
    ) AS receita_gerada,
    (
        SELECT ROUND(AVG(a.nota), 1)
        FROM avaliacoes a
        WHERE a.produto_id = p.produto_id
    ) AS nota_media,
    CASE
        WHEN EXISTS (SELECT 1 FROM avaliacoes a WHERE a.produto_id = p.produto_id)
        THEN 'Sim'
        ELSE 'Nao'
    END AS foi_avaliado,
    CASE
        WHEN (
            SELECT COALESCE(SUM(ip.quantidade), 0)
            FROM itens_pedido ip
            WHERE ip.produto_id = p.produto_id
        ) > (
            SELECT AVG(qtd)
            FROM (
                SELECT SUM(quantidade) AS qtd
                FROM itens_pedido
                GROUP BY produto_id
            ) AS vendas
        )
        THEN 'Campeao'
        ELSE 'Normal'
    END AS classificacao
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
ORDER BY total_vendido DESC;

