-- =================================================================
-- MODULO 08 - AGRUPAMENTO - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 39 - GROUP BY - Agrupando Dados
-- =================================================================

-- Aula 39 - Desafio 1: Contar quantos produtos existem por categoria
SELECT
    categoria_id,
    COUNT(*) AS total_produtos
FROM produtos
GROUP BY categoria_id
ORDER BY total_produtos DESC;


-- Aula 39 - Desafio 2: Calcular o valor total de pedidos por cliente
SELECT
    cliente_id,
    COUNT(*) AS qtd_pedidos,
    SUM(valor_total) AS total_gasto
FROM pedidos
GROUP BY cliente_id
ORDER BY total_gasto DESC;


-- =================================================================
-- AULA 40 - GROUP BY com Multiplas Colunas
-- =================================================================

-- Aula 40 - Desafio 1: Contar quantos clientes existem por estado e cidade
SELECT
    estado,
    cidade,
    COUNT(*) AS total_clientes
FROM clientes
GROUP BY estado, cidade
ORDER BY estado, total_clientes DESC;


-- Aula 40 - Desafio 2: Calcular o valor medio de pedidos por mes e ano
SELECT
    EXTRACT(YEAR FROM data_pedido) AS ano,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    COUNT(*) AS qtd_pedidos,
    ROUND(AVG(valor_total), 2) AS ticket_medio
FROM pedidos
GROUP BY EXTRACT(YEAR FROM data_pedido), EXTRACT(MONTH FROM data_pedido)
ORDER BY ano, mes;


-- =================================================================
-- AULA 41 - HAVING - Filtrando Grupos
-- =================================================================

-- Aula 41 - Desafio 1: Mostrar apenas categorias que tenham mais de 5 produtos
SELECT
    categoria_id,
    COUNT(*) AS total_produtos
FROM produtos
GROUP BY categoria_id
HAVING COUNT(*) > 5
ORDER BY total_produtos DESC;


-- Aula 41 - Desafio 2: Mostrar apenas clientes que fizeram mais de 2 pedidos
SELECT
    cliente_id,
    COUNT(*) AS total_pedidos,
    SUM(valor_total) AS total_gasto
FROM pedidos
GROUP BY cliente_id
HAVING COUNT(*) > 2
ORDER BY total_pedidos DESC;


-- =================================================================
-- DESAFIOS FINAIS DO MODULO 08
-- =================================================================

-- Desafio Final 1: Relatorio de Vendas por Status
-- Quantidade de pedidos e valor total para cada status
-- Ordenar pelo valor total (maior primeiro)
SELECT
    status,
    COUNT(*) AS qtd_pedidos,
    SUM(valor_total) AS valor_total
FROM pedidos
GROUP BY status
ORDER BY valor_total DESC;


-- Desafio Final 2: Analise de Clientes por Regiao
-- Contar clientes por estado e cidade
-- Mostrar apenas combinacoes com mais de 2 clientes
-- Ordenar por estado e depois por quantidade
SELECT
    estado,
    cidade,
    COUNT(*) AS total_clientes
FROM clientes
GROUP BY estado, cidade
HAVING COUNT(*) > 2
ORDER BY estado, total_clientes DESC;


-- Desafio Final 3: Performance de Marcas
-- Para cada marca: quantidade de produtos, preco medio, estoque total
-- Apenas marcas com mais de 3 produtos
-- Ordenar por quantidade de produtos
SELECT
    marca,
    COUNT(*) AS qtd_produtos,
    ROUND(AVG(preco), 2) AS preco_medio,
    SUM(estoque) AS estoque_total
FROM produtos
GROUP BY marca
HAVING COUNT(*) > 3
ORDER BY qtd_produtos DESC;


-- Desafio Final 4: Analise de Pagamentos
-- Agrupar por metodo e status
-- Mostrar quantidade e valor total
-- Filtrar grupos com valor total superior a R$ 1000
SELECT
    metodo,
    status,
    COUNT(*) AS qtd_pagamentos,
    SUM(valor) AS valor_total
FROM pagamentos
GROUP BY metodo, status
HAVING SUM(valor) > 1000
ORDER BY valor_total DESC;


-- Desafio Final 5: Relatorio Mensal de Vendas (Desafio Avancado)
-- Ano e mes, quantidade de pedidos, valor total, ticket medio
-- Apenas pedidos com status diferente de "cancelado"
-- Filtrar meses com mais de 10 pedidos
-- Ordenar por ano e mes
SELECT
    EXTRACT(YEAR FROM data_pedido) AS ano,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    COUNT(*) AS qtd_pedidos,
    SUM(valor_total) AS valor_total,
    ROUND(AVG(valor_total), 2) AS ticket_medio
FROM pedidos
WHERE status <> 'cancelado'
GROUP BY EXTRACT(YEAR FROM data_pedido), EXTRACT(MONTH FROM data_pedido)
HAVING COUNT(*) > 10
ORDER BY ano, mes;


-- Desafio Final 6: Dashboard Completo (Boss Final!)
-- Para cada categoria: ID, total produtos, preco min/med/max, estoque total, valor em estoque
-- Filtrar: mais de 5 produtos E valor em estoque maior que R$ 5000
-- Ordenar pelo valor em estoque
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
