-- =================================================================
-- MODULO 11 - SUBCONSULTAS - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 50 - Subconsulta no WHERE
-- =================================================================

-- Aula 50 - Desafio 1: Produtos com preço acima da média geral
-- Use uma subconsulta no WHERE para comparar com a média de preços de todos os produtos
-- Mostre: nome e preço dos produtos
-- Ordene do mais caro para o mais barato
SELECT nome, preco
FROM produtos
WHERE preco > (SELECT AVG(preco) FROM produtos)
ORDER BY preco DESC;


-- Aula 50 - Desafio 2: Clientes que fizeram pedidos de alto valor (acima de R$ 1000)
-- Use uma subconsulta com IN no WHERE para filtrar clientes
-- Mostre: nome e email dos clientes que têm pelo menos um pedido acima de R$ 1000
-- Ordene por nome em ordem alfabética
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

-- Aula 51 - Desafio 1: Resumo de vendas por produto usando tabela derivada (Derived Table)
-- Crie uma subconsulta no FROM que agrupe as vendas por produto
-- Mostre: nome do produto, quantidade total vendida e valor total arrecadado
-- Ordene do produto que gerou mais receita para o que gerou menos
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


-- Aula 51 - Desafio 2: Calcular médias gerais a partir de dados agregados por cliente
-- Use uma subconsulta no FROM que agrupe pedidos por cliente (total de pedidos e valor total)
-- Mostre: média de pedidos por cliente e média de valor gasto por cliente
-- Arredonde ambos os valores para 2 casas decimais
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

-- Aula 52 - Desafio 1: Relatório de produtos com quantidade total vendida
-- Mostre: nome, preço, estoque atual e total de unidades vendidas de cada produto
-- Inclua produtos que nunca foram vendidos (devem aparecer com 0 unidades)
-- Ordene do produto mais vendido para o menos vendido
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


-- Aula 52 - Desafio 2: Relatório de clientes com valor total gasto individualmente
-- Mostre: ID, nome, email, cidade e total gasto por cada cliente
-- Inclua clientes que nunca fizeram pedidos (devem aparecer com R$ 0,00)
-- Ordene do cliente que mais gastou para o que menos gastou
SELECT
    c.cliente_id,
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

-- Aula 53 - Desafio 1: Produtos que já foram vendidos pelo menos uma vez
-- Mostre: nome, preço e estoque atual dos produtos
-- Ordene por nome do produto em ordem alfabética
SELECT p.nome, p.preco, p.estoque
FROM produtos p
WHERE EXISTS (
    SELECT 1
    FROM itens_pedido ip
    WHERE ip.produto_id = p.produto_id
)
ORDER BY p.nome;


-- Aula 53 - Desafio 2: Clientes que nunca avaliaram produtos
-- Mostre: nome e email dos clientes
-- Ordene por nome em ordem alfabética
SELECT c.nome, c.email
FROM clientes c
WHERE NOT EXISTS (
    SELECT 1
    FROM avaliacoes a
    WHERE a.cliente_id = c.cliente_id
)
ORDER BY c.nome;