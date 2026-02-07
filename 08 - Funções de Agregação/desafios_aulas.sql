-- =================================================================
-- MODULO 07 - FUNCOES DE AGREGACAO - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 33 - COUNT - Contando Registros
-- =================================================================

-- Aula 33 - Desafio 1: Contar quantos produtos existem no banco
SELECT COUNT(*) AS total_produtos
FROM produtos;


-- Aula 33 - Desafio 2: Contar quantos pedidos foram feitos em 2025
SELECT COUNT(*) AS pedidos_2025
FROM pedidos
WHERE EXTRACT(YEAR FROM data_pedido) = 2025;


-- =================================================================
-- AULA 34 - COUNT DISTINCT - Contando Valores Unicos
-- =================================================================

-- Aula 34 - Desafio 1: Contar quantas marcas diferentes de produtos existem
SELECT COUNT(DISTINCT marca) AS total_marcas
FROM produtos;


-- Aula 34 - Desafio 2: Contar em quantas cidades diferentes temos clientes
SELECT COUNT(DISTINCT cidade) AS total_cidades
FROM clientes;


-- =================================================================
-- AULA 35 - SUM - Somando Valores
-- =================================================================

-- Aula 35 - Desafio 1: Calcular o valor total de todos os pedidos
SELECT SUM(valor_total) AS faturamento_total
FROM pedidos;


-- Aula 35 - Desafio 2: Calcular o estoque total de todos os produtos
SELECT SUM(estoque) AS estoque_total
FROM produtos;


-- =================================================================
-- AULA 36 - AVG - Calculando Media
-- =================================================================

-- Aula 36 - Desafio 1: Calcular o preco medio dos produtos
SELECT AVG(preco) AS preco_medio
FROM produtos;


-- Aula 36 - Desafio 2: Calcular o valor medio dos pedidos
SELECT AVG(valor_total) AS ticket_medio
FROM pedidos;


-- =================================================================
-- AULA 37 - MIN - Encontrando Minimo
-- =================================================================

-- Aula 37 - Desafio 1:  Encontre o menor preço dos produto da categoria Automotivo
SELECT MIN(preco) AS menor_preco_automotivo
FROM produtos
WHERE categoria_id = 6;

-- Aula 37 - Desafio 2: Identifique o menor desconto aplicado em pedidos com desconto
SELECT MIN(desconto) AS menor_desconto
FROM pedidos
WHERE desconto > 0 OR desconto IS NOT NULL;

-- =================================================================
-- AULA 38 - MAX - Encontrando Maximo
-- =================================================================

-- Aula 38 - Desafio 1: Encontrar o produto mais caro
SELECT nome, preco
FROM produtos
ORDER BY preco DESC
LIMIT 1;


-- Aula 38 - Desafio 2: Encontrar o pedido de maior valor
SELECT MAX(valor_total) AS maior_pedido
FROM pedidos;