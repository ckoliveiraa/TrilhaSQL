-- Aula 48 - Desafio 1: Lista unificada de marcas e categorias
-- Combine marcas de produtos + nomes de categorias em uma única lista
-- Adicione coluna "origem" identificando se é 'produtos' ou 'categorias'
-- Exclua marcas nulas e garanta que não haja duplicatas
SELECT marca AS item, 'produtos' AS origem
FROM produtos
WHERE marca IS NOT NULL
UNION
SELECT nome AS item, 'categorias' AS origem
FROM categorias
ORDER BY item
-- Aula 48 - Desafio 2: Lista unificada de todos os status do sistema
-- Combine status de pedidos + status de pagamentos em uma única lista
-- Adicione coluna "origem" para identificar de qual tabela vem cada status
-- Liste apenas valores únicos (sem duplicatas)
SELECT DISTINCT status, 'pedidos' AS origem
FROM pedidos
UNION
SELECT DISTINCT status, 'pagamentos' AS origem
FROM pagamentos
ORDER BY origem, status;
-- Aula 49 - Desafio 1: Clientes que compraram mas nunca avaliaram
-- Encontre clientes que fizeram pedidos MAS NUNCA avaliaram produtos
SELECT DISTINCT cliente_id
FROM pedidos
EXCEPT
SELECT DISTINCT cliente_id
FROM avaliacoes
ORDER BY cliente_id;
-- Aula 49 - Desafio 2: Criar histórico completo de ações
-- Combine pedidos e pagamentos em uma linha do tempo
-- Inclua: data, valor, tipo de ação ('Pedido realizado' ou 'Pagamento registrado')
SELECT pedido_id, cliente_id, data_pedido AS DATA, valor_total AS valor, 'Pedido realizado' AS tipo_acao
FROM pedidos
UNION ALL
SELECT pg.pedido_id, p.cliente_id, p.data_pedido AS DATA, pg.valor AS valor, 'Pagamento registrado' AS tipo_acao
FROM pagamentos pg
INNER JOIN pedidos p ON
pg.pedido_id = p.pedido_id
ORDER BY DATA, pedido_id;
-- Aula 49 - Desafio 3: Clientes engajados (que compraram E avaliaram)
-- Encontre clientes que fizeram pedidos E também avaliaram produtos
-- Use INTERSECT para encontrar IDs que aparecem em ambas as tabelas
SELECT DISTINCT cliente_id
FROM pedidos
INTERSECT
SELECT DISTINCT cliente_id
FROM avaliacoes
ORDER BY cliente_id;
