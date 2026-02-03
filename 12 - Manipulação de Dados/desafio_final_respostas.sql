-- ============================================
-- MÓDULO 12 - MANIPULAÇÃO DE DADOS
-- Respostas do Desafio Final
-- ============================================

-- ⚠️ ATENÇÃO: Os comandos INSERT, UPDATE e DELETE modificam dados!
-- Execute com cuidado e faça backup antes de testar.


-- Desafio Final 1: Cadastro em Massa
-- Insira 3 novos produtos e 3 novos clientes
-- Use INSERTs com múltiplos valores

-- Inserindo 3 novos produtos
INSERT INTO produtos (nome, preco, estoque, marca, categoria_id)
VALUES
    ('Smart TV 55"', 2499.90, 25, 'LG', 1),
    ('Notebook Gamer', 5999.90, 15, 'ASUS', 1),
    ('Caixa de Som Bluetooth', 299.90, 100, 'JBL', 1);

-- Inserindo 3 novos clientes
INSERT INTO clientes (nome, email, telefone, cidade, estado)
VALUES
    ('Pedro Henrique', 'pedro.h@email.com', '11999001122', 'São Paulo', 'SP'),
    ('Camila Oliveira', 'camila.o@email.com', '21988776655', 'Rio de Janeiro', 'RJ'),
    ('Rafael Costa', 'rafael.c@email.com', '31977665544', 'Belo Horizonte', 'MG');


-- Desafio Final 2: Atualização Condicional
-- a) Aumente em 5% o preço de produtos com estoque > 100

-- Primeiro, verificar quais serão afetados:
SELECT nome, preco, estoque
FROM produtos
WHERE estoque > 100;

-- Executar o UPDATE:
UPDATE produtos
SET preco = preco * 1.05
WHERE estoque > 100;


-- b) Diminua em 10% o preço de produtos sem vendas nos últimos 30 dias

-- Primeiro, verificar quais serão afetados:
SELECT p.nome, p.preco
FROM produtos p
WHERE p.produto_id NOT IN (
    SELECT DISTINCT ip.produto_id
    FROM itens_pedido ip
    INNER JOIN pedidos ped ON ip.pedido_id = ped.pedido_id
    WHERE ped.data_pedido >= CURRENT_DATE - INTERVAL '30 days'
);

-- Executar o UPDATE:
UPDATE produtos
SET preco = preco * 0.90
WHERE produto_id NOT IN (
    SELECT DISTINCT ip.produto_id
    FROM itens_pedido ip
    INNER JOIN pedidos ped ON ip.pedido_id = ped.pedido_id
    WHERE ped.data_pedido >= CURRENT_DATE - INTERVAL '30 days'
);


-- Desafio Final 3: Limpeza Segura
-- Remova itens de pedido de pedidos cancelados

-- Primeiro: SELECT para verificar
SELECT ip.*
FROM itens_pedido ip
INNER JOIN pedidos p ON ip.pedido_id = p.pedido_id
WHERE p.status = 'cancelado';

-- Contar quantos serão removidos:
SELECT COUNT(*)
FROM itens_pedido ip
INNER JOIN pedidos p ON ip.pedido_id = p.pedido_id
WHERE p.status = 'cancelado';

-- Depois: DELETE com a mesma condição
DELETE FROM itens_pedido
WHERE pedido_id IN (
    SELECT pedido_id
    FROM pedidos
    WHERE status = 'cancelado'
);


-- Desafio Final 4 (Boss Final!): Operação Completa
-- Cenário: Fim de um produto
-- a) Transfira o estoque do produto ID 5 para o produto ID 10 (UPDATE)
-- b) Atualize itens_pedido para usar o novo produto_id (UPDATE)
-- c) Delete o produto antigo (DELETE)
-- Faça tudo verificando antes com SELECT

-- a) Verificar estoques atuais:
SELECT produto_id, nome, estoque
FROM produtos
WHERE produto_id IN (5, 10);

-- Transferir estoque:
UPDATE produtos
SET estoque = estoque + (SELECT estoque FROM produtos WHERE produto_id = 5)
WHERE produto_id = 10;

-- Zerar estoque do produto antigo:
UPDATE produtos
SET estoque = 0
WHERE produto_id = 5;


-- b) Verificar itens que serão atualizados:
SELECT *
FROM itens_pedido
WHERE produto_id = 5;

-- Atualizar itens_pedido:
UPDATE itens_pedido
SET produto_id = 10
WHERE produto_id = 5;


-- c) Verificar se o produto pode ser removido:
SELECT *
FROM produtos
WHERE produto_id = 5;

-- Verificar se ainda há referências:
SELECT COUNT(*)
FROM itens_pedido
WHERE produto_id = 5;

-- Deletar o produto antigo (somente se não houver mais referências):
DELETE FROM produtos
WHERE produto_id = 5;
