-- =================================================================
-- MODULO 09 - JOINs - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 42 - INNER JOIN - Juntando Tabelas
-- =================================================================

-- Aula 42 - Desafio 1: Listar todos os produtos com o nome de suas categorias
-- Mostre: nome do produto, preco, nome da categoria
SELECT
    p.nome AS produto,
    p.preco,
    c.nome AS categoria
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id;


-- Aula 42 - Desafio 2: Listar todos os pedidos com o nome dos clientes
-- Mostre: pedido_id, data_pedido, valor_total, nome do cliente, email do cliente
SELECT
    ped.pedido_id,
    ped.data_pedido,
    ped.valor_total,
    cli.nome AS cliente,
    cli.email
FROM pedidos ped
INNER JOIN clientes cli ON ped.cliente_id = cli.cliente_id;


-- =================================================================
-- AULA 43 - LEFT JOIN - Mantendo Todos a Esquerda
-- =================================================================

-- Aula 43 - Desafio 1: Listar todos os produtos, incluindo os que nunca foram vendidos
-- Mostre: nome do produto, preco, quantidade vendida
SELECT
    p.nome AS produto,
    p.preco,
    SUM(ip.quantidade) AS quantidade_vendida
FROM produtos p
LEFT JOIN itens_pedido ip ON p.produto_id = ip.produto_id
GROUP BY p.produto_id, p.nome, p.preco
ORDER BY quantidade_vendida DESC;


-- Aula 43 - Desafio 2: Listar todos os clientes, incluindo os que nunca fizeram pedidos
-- Mostre: nome do cliente, email, quantidade de pedidos (0 se nunca fez)
SELECT
    c.nome AS cliente,
    c.email,
    COUNT(p.pedido_id) AS quantidade_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome, c.email
ORDER BY quantidade_pedidos DESC;


-- =================================================================
-- AULA 44 - RIGHT JOIN - Mantendo Todos a Direita
-- =================================================================

-- Aula 44 - Desafio 1: Listar todos os pedidos e seus pagamentos (mantendo pedidos sem pagamento)
-- Use RIGHT JOIN com pedidos a direita
SELECT
    ped.pedido_id,
    ped.valor_total AS valor_pedido,
    pg.metodo,
    pg.valor AS valor_pagamento
FROM pagamentos pg
RIGHT JOIN pedidos ped ON pg.pedido_id = ped.pedido_id;


-- Aula 44 - Desafio 2: Reescreva o desafio anterior usando LEFT JOIN
-- O resultado deve ser identico
SELECT
    ped.pedido_id,
    ped.valor_total AS valor_pedido,
    pg.metodo,
    pg.valor AS valor_pagamento
FROM pedidos ped
LEFT JOIN pagamentos pg ON ped.pedido_id = pg.pedido_id;


-- =================================================================
-- AULA 45 - FULL OUTER JOIN - Mantendo Todos os Registros
-- =================================================================

-- Aula 45 - Desafio 1: Listar todos os produtos e todas as avaliacoes
-- Mostre produtos sem avaliacao E avaliacoes (se houver alguma orfa)
SELECT
    p.produto_id,
    p.nome AS produto,
    a.avaliacao_id,
    a.nota
FROM produtos p
FULL OUTER JOIN avaliacoes a ON p.produto_id = a.produto_id;


-- Aula 45 - Desafio 2: Produtos com baixo engajamento de avaliações
-- Liste produtos com poucas ou nenhuma avaliação (menos de 3 avaliações)
-- Use FULL OUTER JOIN para garantir que todos os produtos sejam incluídos
SELECT
    p.produto_id,
    p.nome AS produto,
    p.preco,
    COUNT(a.avaliacao_id) AS total_avaliacoes,
    ROUND(AVG(a.nota), 2) AS nota_media,
    CASE
        WHEN COUNT(a.avaliacao_id) = 0 THEN 'Sem avaliações'
        WHEN COUNT(a.avaliacao_id) = 1 THEN 'Apenas 1 avaliação'
        ELSE 'Poucas avaliações'
    END AS status_engajamento
FROM produtos p
FULL OUTER JOIN avaliacoes a ON p.produto_id = a.produto_id
GROUP BY p.produto_id, p.nome, p.preco
HAVING COUNT(a.avaliacao_id) < 3
ORDER BY total_avaliacoes ASC, p.preco DESC;


-- =================================================================
-- AULA 46 - SELF JOIN - Juntando Tabela com Ela Mesma
-- =================================================================

-- Aula 46 - Desafio 1: Encontrar clientes que moram na mesma cidade
-- Evite duplicatas e auto-comparacao
SELECT
    c1.nome AS cliente1,
    c2.nome AS cliente2,
    c1.cidade
FROM clientes c1
INNER JOIN clientes c2
    ON c1.cidade = c2.cidade
    AND c1.cliente_id < c2.cliente_id
ORDER BY c1.cidade;


-- Aula 46 - Desafio 2: Encontrar produtos da mesma categoria com precos similares
-- Considere "similar" uma diferenca menor que R$ 100
SELECT
    p1.nome AS produto1,
    p1.preco AS preco1,
    p2.nome AS produto2,
    p2.preco AS preco2,
    p1.categoria_id,
    ABS(p1.preco - p2.preco) AS diferenca_preco
FROM produtos p1
INNER JOIN produtos p2
    ON p1.categoria_id = p2.categoria_id
    AND p1.produto_id < p2.produto_id
    AND ABS(p1.preco - p2.preco) < 100
ORDER BY p1.categoria_id, diferenca_preco;


-- =================================================================
-- AULA 47 - Multiplos JOINs na Mesma Consulta
-- =================================================================

-- Aula 47 - Desafio 1: Listar pedidos com nome do cliente, produtos comprados e categoria
-- Mostre: pedido_id, data_pedido, nome do cliente, nome do produto, categoria, quantidade
SELECT
    ped.pedido_id,
    ped.data_pedido,
    cli.nome AS cliente,
    prod.nome AS produto,
    cat.nome AS categoria,
    ip.quantidade
FROM pedidos ped
INNER JOIN clientes cli ON ped.cliente_id = cli.cliente_id
INNER JOIN itens_pedido ip ON ped.pedido_id = ip.pedido_id
INNER JOIN produtos prod ON ip.produto_id = prod.produto_id
INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
ORDER BY ped.pedido_id;


-- Aula 47 - Desafio 2: Criar relatorio completo de vendas
-- Mostre: pedido_id, cliente, cidade, produto, categoria, quantidade, valor unitario, subtotal, forma pagamento
-- Apenas pedidos com status 'entregue'
SELECT
    ped.pedido_id,
    cli.nome AS cliente,
    cli.cidade,
    prod.nome AS produto,
    cat.nome AS categoria,
    ip.quantidade,
    ip.preco_unitario,
    ip.quantidade * ip.preco_unitario AS subtotal,
    pg.metodo AS forma_pagamento
FROM pedidos ped
INNER JOIN clientes cli ON ped.cliente_id = cli.cliente_id
INNER JOIN itens_pedido ip ON ped.pedido_id = ip.pedido_id
INNER JOIN produtos prod ON ip.produto_id = prod.produto_id
INNER JOIN categorias cat ON prod.categoria_id = cat.categoria_id
LEFT JOIN pagamentos pg ON ped.pedido_id = pg.pedido_id
WHERE ped.status = 'entregue'
ORDER BY ped.data_pedido DESC, ped.pedido_id;