-- Aula 39 - Desafio 1: Contar quantos produtos existem por categoria
SELECT categoria_id, COUNT(*) AS total_produtos
FROM produtos
GROUP BY categoria_id
ORDER BY total_produtos DESC
-- Aula 39 - Desafio 2: Calcular o valor total de pedidos por cliente
SELECT cliente_id, COUNT(*) AS qtd_pedidos, SUM(valor_total) AS total_gasto
FROM pedidos
GROUP BY cliente_id
ORDER BY total_gasto DESC;
-- Aula 40 - Desafio 1: Contar quantos clientes existem por estado e cidade
SELECT estado, cidade, COUNT(*) AS total_clientes
FROM clientes
GROUP BY estado, cidade
ORDER BY total_clientes DESC;
-- Aula 40 - Desafio 2: Calcular o valor médio de pedidos por mês e ano
SELECT EXTRACT(YEAR FROM data_pedido) AS ano, EXTRACT(MONTH FROM data_pedido) AS mes, COUNT(*) AS qtd_pedidos, ROUND(AVG(valor_total), 2) AS ticket_medio
FROM pedidos
GROUP BY EXTRACT(YEAR FROM data_pedido), EXTRACT(MONTH FROM data_pedido)
ORDER BY ano, mes;
-- Aula 41 - Desafio 1: Mostrar apenas categorias que tenham mais de 5 produtos
SELECT categoria_id, COUNT(*) AS total_produtos
FROM produtos
GROUP BY categoria_id
HAVING COUNT(*) > 5
ORDER BY total_produtos DESC;
-- Aula 41 - Desafio 2: Mostrar apenas clientes que fizeram mais de 2 pedidos
SELECT cliente_id, COUNT(*) AS total_pedidos
FROM pedidos
GROUP BY cliente_id
HAVING COUNT(*) > 2
ORDER BY total_pedidos DESC;