-- ============================================
-- MÓDULO 9 - JOINs
-- Respostas do Desafio Final
-- ============================================

-- Desafio Final 1: Catálogo Completo
-- Liste todos os produtos com suas categorias
-- Mostre: nome do produto, preço, estoque, marca, nome da categoria
-- Inclua produtos mesmo que a categoria esteja inativa
-- Ordene por categoria e depois por nome do produto

SELECT
    p.nome AS produto,
    p.preco,
    p.estoque,
    p.marca,
    c.nome AS categoria
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
ORDER BY c.nome, p.nome;


-- Desafio Final 2: Clientes sem Compras
-- Encontre todos os clientes que nunca fizeram pedidos
-- Mostre: nome, email, cidade, estado, data de cadastro
-- Ordene por data de cadastro (mais antigos primeiro)

SELECT
    c.nome,
    c.email,
    c.cidade,
    c.estado,
    c.data_cadastro
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.pedido_id IS NULL
ORDER BY c.data_cadastro ASC;


-- Desafio Final 3: Análise de Pagamentos
-- Liste todos os pedidos com informações de pagamento
-- Mostre: pedido_id, nome do cliente, valor do pedido, método de pagamento, status do pagamento
-- Inclua pedidos que ainda não têm pagamento registrado
-- Ordene por valor do pedido (maior primeiro)

SELECT
    p.pedido_id,
    c.nome AS cliente,
    p.valor_total,
    pg.metodo AS metodo_pagamento,
    pg.status AS status_pagamento
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
LEFT JOIN pagamentos pg ON p.pedido_id = pg.pedido_id
ORDER BY p.valor_total DESC;


-- Desafio Final 4: Produtos Mais Avaliados
-- Liste produtos que têm avaliações, com estatísticas
-- Mostre: nome do produto, categoria, quantidade de avaliações, nota média
-- Apenas produtos com mais de 1 avaliação
-- Ordene por nota média (maior primeiro)

SELECT
    p.nome AS produto,
    c.nome AS categoria,
    COUNT(a.avaliacao_id) AS total_avaliacoes,
    ROUND(AVG(a.nota), 2) AS nota_media
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
INNER JOIN avaliacoes a ON p.produto_id = a.produto_id
GROUP BY p.produto_id, p.nome, c.nome
HAVING COUNT(a.avaliacao_id) > 1
ORDER BY nota_media DESC;


-- Desafio Final 5: Relatório de Vendas por Cliente (Desafio Avançado)
-- Para cada cliente que fez pedidos, mostre:
-- Nome do cliente, cidade, estado, total de pedidos, valor total gasto, ticket médio
-- Apenas clientes com mais de 1 pedido
-- Ordene por valor total gasto (maior primeiro)

SELECT
    c.nome AS cliente,
    c.cidade,
    c.estado,
    COUNT(p.pedido_id) AS total_pedidos,
    SUM(p.valor_total) AS valor_total_gasto,
    ROUND(AVG(p.valor_total), 2) AS ticket_medio
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome, c.cidade, c.estado
HAVING COUNT(p.pedido_id) > 1
ORDER BY valor_total_gasto DESC;


-- Desafio Final 6: Dashboard Completo (Boss Final!)
-- Crie um relatório detalhado de vendas que mostre:
-- - pedido_id
-- - data do pedido
-- - nome do cliente
-- - cidade e estado do cliente
-- - nome do produto
-- - categoria do produto
-- - quantidade comprada
-- - preço unitário
-- - subtotal (quantidade * preço unitário)
-- - método de pagamento
-- Filtros:
-- - Apenas pedidos com status 'entregue' ou 'enviado'
-- - Apenas produtos de categorias ativas
-- Ordene por data do pedido (mais recente primeiro), depois por pedido_id

SELECT
    ped.pedido_id,
    ped.data_pedido,
    cli.nome AS cliente,
    cli.cidade,
    cli.estado,
    prod.nome AS produto,
    cat.nome AS categoria,
    ip.quantidade,
    ip.preco_unitario,
    (ip.quantidade * ip.preco_unitario) AS subtotal,
    pg.metodo AS metodo_pagamento
FROM pedidos ped
INNER JOIN clientes cli ON ped.cliente_id = cli.cliente_id
INNER JOIN itens_pedido ip ON ped.pedido_id = ip.pedido_id
INNER JOIN produtos prod ON ip.produto_id = prod.produto_id
INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
LEFT JOIN pagamentos pg ON ped.pedido_id = pg.pedido_id
WHERE ped.status IN ('entregue', 'enviado')
  AND cat.ativo = TRUE
ORDER BY ped.data_pedido DESC, ped.pedido_id;
