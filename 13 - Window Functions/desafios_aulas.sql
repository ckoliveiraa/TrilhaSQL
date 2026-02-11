-- Aula 54 - Desafio 1: Numerar produtos ordenados por preço (do mais caro ao mais barato)
-- Exiba: número, nome e preço
SELECT ROW_NUMBER() OVER (
ORDER BY preco DESC) AS numero, nome, preco
FROM produtos;
-- Aula 54 - Desafio 2: Numerar pedidos de cada cliente por data
-- Exiba: cliente_id, pedido_id, data_pedido e número do pedido
SELECT cliente_id, pedido_id, data_pedido, ROW_NUMBER() OVER (PARTITION BY cliente_id
ORDER BY data_pedido) AS numero_pedido
FROM pedidos
ORDER BY cliente_id, numero_pedido;
-- Aula 55 - Desafio 1: Ranking de produtos mais caros
-- Crie um ranking dos produtos ordenados do mais caro para o mais barato.
-- Exiba: posição no ranking, nome do produto e preço
SELECT RANK() OVER (
ORDER BY preco DESC) AS ranking, nome, preco
FROM produtos;
-- Aula 55 - Desafio 2: Ranking de clientes por valor total de compras
-- Identifique quais clientes gastam mais na loja criando um ranking.
-- Calcule o total gasto por cada cliente somando o valor_total de todos os seus pedidos.
-- Exiba: nome do cliente, total gasto e ranking
SELECT c.nome AS cliente, SUM(p.valor_total) AS total_gasto, RANK() OVER (
ORDER BY SUM(p.valor_total) DESC) AS ranking
FROM clientes c
INNER JOIN pedidos p ON
c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome
ORDER BY ranking
-- Aula 56 - Desafio 1: Rankear produtos por avaliação média (sem pular números)
-- Use DENSE_RANK com AVG(nota)
SELECT p.nome AS produto, ROUND(AVG(a.nota), 2) AS media_avaliacao, DENSE_RANK() OVER (
ORDER BY AVG(a.nota) DESC) AS ranking
FROM produtos p
INNER JOIN avaliacoes a ON
p.produto_id = a.produto_id
GROUP BY p.produto_id, p.nome
ORDER BY ranking;
-- Aula 56 - Desafio 2: Rankear categorias por número de produtos
-- Conte produtos por categoria e aplique DENSE_RANK
SELECT c.nome AS categoria, COUNT(p.produto_id) AS total_produtos, DENSE_RANK() OVER (
ORDER BY COUNT(p.produto_id) DESC) AS ranking
FROM categorias c
LEFT JOIN produtos p ON
c.categoria_id = p.categoria_id
GROUP BY c.categoria_id, c.nome
ORDER BY ranking;
-- Aula 57 - Desafio 1: Numerar produtos dentro de cada categoria
-- Ordenar por preço dentro de cada categoria
SELECT c.nome AS categoria, p.nome AS produto, p.preco, ROW_NUMBER() OVER (
        PARTITION BY p.categoria_id
ORDER BY p.preco DESC
    ) AS ranking_na_categoria
FROM produtos p
INNER JOIN categorias c ON
p.categoria_id = c.categoria_id
ORDER BY c.nome, ranking_na_categoria;
-- Aula 57 - Desafio 2: Rankear vendas por mês
-- Mostre o ranking de pedidos por valor em cada mês
SELECT EXTRACT(YEAR FROM data_pedido) AS ano, EXTRACT(MONTH FROM data_pedido) AS mes, pedido_id, valor_total, RANK() OVER (
        PARTITION BY EXTRACT(YEAR FROM data_pedido), EXTRACT(MONTH FROM data_pedido)
ORDER BY valor_total DESC
    ) AS ranking_no_mes
FROM pedidos
ORDER BY ano, mes, ranking_no_mes;
-- Aula 58 - Desafio 1: Comparar preço de cada produto com o próximo produto
-- Ordene por preço e mostre a diferença
SELECT nome, preco, LEAD(preco) OVER (
ORDER BY preco) AS preco_proximo, LEAD(preco) OVER (
ORDER BY preco) - preco AS diferenca
FROM produtos
ORDER BY preco
-- Aula 58 - Desafio 2: Calcular diferença de valor entre pedidos consecutivos de cada cliente
-- Use PARTITION BY cliente_id
SELECT cliente_id, pedido_id, data_pedido, valor_total, LAG(valor_total) OVER (
        PARTITION BY cliente_id
ORDER BY data_pedido
    ) AS valor_pedido_anterior, valor_total - LAG(valor_total) OVER (
        PARTITION BY cliente_id
ORDER BY data_pedido
    ) AS diferenca
FROM pedidos
ORDER BY cliente_id, data_pedido;
