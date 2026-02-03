-- ============================================
-- MÓDULO 8 - AGRUPAMENTO
-- Respostas do Desafio Final
-- ============================================

-- Desafio Final 1: Relatório de Vendas por Status
-- Mostre a quantidade de pedidos e o valor total para cada status
-- Ordene pelo valor total (maior primeiro)

SELECT
    status,
    COUNT(*) AS quantidade_pedidos,
    SUM(valor_total) AS valor_total
FROM pedidos
GROUP BY status
ORDER BY valor_total DESC;


-- Desafio Final 2: Análise de Clientes por Região
-- Conte quantos clientes existem em cada combinação de estado e cidade
-- Mostre apenas combinações com mais de 2 clientes
-- Ordene por estado e depois por quantidade (maior primeiro)

SELECT
    estado,
    cidade,
    COUNT(*) AS total_clientes
FROM clientes
GROUP BY estado, cidade
HAVING COUNT(*) > 2
ORDER BY estado ASC, total_clientes DESC;


-- Desafio Final 3: Performance de Marcas
-- Para cada marca, mostre:
-- - Quantidade de produtos
-- - Preço médio (arredondado para 2 casas)
-- - Estoque total
-- Filtre apenas marcas com mais de 3 produtos
-- Ordene por quantidade de produtos (maior primeiro)

SELECT
    marca,
    COUNT(*) AS quantidade_produtos,
    ROUND(AVG(preco), 2) AS preco_medio,
    SUM(estoque) AS estoque_total
FROM produtos
GROUP BY marca
HAVING COUNT(*) > 3
ORDER BY quantidade_produtos DESC;


-- Desafio Final 4: Análise de Pagamentos
-- Agrupe pagamentos por método e status
-- Mostre a quantidade e o valor total de cada grupo
-- Filtre grupos com valor total superior a R$ 1000

SELECT
    metodo,
    status,
    COUNT(*) AS quantidade,
    SUM(valor) AS valor_total
FROM pagamentos
GROUP BY metodo, status
HAVING SUM(valor) > 1000;


-- Desafio Final 5: Relatório Mensal de Vendas (Desafio Avançado)
-- Crie um relatório com:
-- - Ano e mês do pedido
-- - Quantidade de pedidos
-- - Valor total
-- - Ticket médio (valor médio por pedido)
-- Considere apenas pedidos com status diferente de "cancelado"
-- Filtre meses com mais de 10 pedidos
-- Ordene por ano e mês

SELECT
    EXTRACT(YEAR FROM data_pedido) AS ano,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    COUNT(*) AS quantidade_pedidos,
    SUM(valor_total) AS valor_total,
    ROUND(AVG(valor_total), 2) AS ticket_medio
FROM pedidos
WHERE status <> 'cancelado'
GROUP BY EXTRACT(YEAR FROM data_pedido), EXTRACT(MONTH FROM data_pedido)
HAVING COUNT(*) > 10
ORDER BY ano, mes;


-- Desafio Final 6: Dashboard Completo (Boss Final!)
-- Crie uma consulta que mostre para cada categoria:
-- - ID da categoria
-- - Total de produtos
-- - Preço mínimo, médio e máximo
-- - Estoque total
-- - Valor total em estoque (soma de preco * estoque)
-- Filtre categorias onde:
-- - Existam mais de 5 produtos
-- - O valor em estoque seja maior que R$ 5000
-- Ordene pelo valor em estoque (maior primeiro)

SELECT
    categoria_id,
    COUNT(*) AS total_produtos,
    MIN(preco) AS preco_minimo,
    ROUND(AVG(preco), 2) AS preco_medio,
    MAX(preco) AS preco_maximo,
    SUM(estoque) AS estoque_total,
    SUM(preco * estoque) AS valor_em_estoque
FROM produtos
GROUP BY categoria_id
HAVING COUNT(*) > 5
   AND SUM(preco * estoque) > 5000
ORDER BY valor_em_estoque DESC;
