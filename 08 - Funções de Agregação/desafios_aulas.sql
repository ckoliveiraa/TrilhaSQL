-- Aula 33 - Desafio 1: Contar quantos produtos existem no banco
SELECT count(produto_id) AS total_produtos
FROM produtos

SELECT count (*) AS total_produtos
FROM produtos
WHERE produto_id IS NOT NULL
-- Aula 33 - Desafio 2: Contar quantos pedidos foram feitos em 2025
SELECT COUNT(*) AS pedidos_2025
FROM pedidos
WHERE EXTRACT(YEAR FROM data_pedido) = 2025;
-- Aula 34 - Desafio 1: Contar quantas marcas diferentes de produtos existem
SELECT COUNT(DISTINCT marca) AS total_marcas
FROM produtos;
-- Aula 34 - Desafio 2: Contar em quantas cidades diferentes temos clientes
SELECT COUNT(DISTINCT cidade) AS total_cidades
FROM clientes;
-- Aula 35 - Desafio 1: Calcular o valor total de todos os pedidos
SELECT SUM(valor_total) AS faturamento_total
FROM pedidos;
-- Aula 35 - Desafio 2: Calcular o estoque total de todos os produtos
SELECT SUM(estoque) AS estoque_total
FROM produtos;
-- Aula 36 - Desafio 1: Calcular o preço médio dos produtos
SELECT ROUND (AVG(preco), 2) AS preco_medio
FROM produtos;
-- Aula 36 - Desafio 2: Calcular o valor médio dos pedidos
SELECT ROUND (AVG(valor_total), 3) AS ticket_medio
FROM pedidos;
-- Aula 37 - Desafio 1:  Encontre o menor preço do produto da categoria Automotivo = 6
SELECT MIN(preco) AS menor_preco_automotivo
FROM produtos
WHERE categoria_id = 6;
-- Aula 37 - Desafio 2: Identifique o menor desconto aplicado em pedidos com desconto
SELECT MIN(desconto) AS menor_desconto
FROM pedidos
WHERE desconto > 0
OR desconto IS NOT NULL;
-- Aula 38 - Desafio 1: Encontrar o produto mais caro
SELECT MAX(preco) AS maior_preco
FROM produtos;
--Query correta para min e max
SELECT nome, preco
FROM produtos
ORDER BY preco DESC
LIMIT 1;
-- Aula 38 - Desafio 2: Encontrar o valor do maior pedido
SELECT MAX(valor_total) AS maior_pedido
FROM pedidos;
