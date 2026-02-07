-- =================================================================
-- MODULO 12 - MANIPULACAO DE DADOS - DESAFIOS DAS AULAS
-- =================================================================
-- IMPORTANTE: Estes são exercícios de DML (INSERT, UPDATE, DELETE)
-- Sempre faça backup ou use transações antes de executar em produção!

-- =================================================================
-- AULA 54 - INSERT - Inserindo Um Registro
-- =================================================================

-- Aula 54 - Desafio 1: Adicionar um novo produto na tabela
-- Insira um produto com: nome, preco, estoque, marca e categoria_id
INSERT INTO produtos (nome, preco, estoque, marca, categoria_id)
VALUES ('Fone de Ouvido Bluetooth', 299.90, 50, 'JBL', 1);


-- Aula 54 - Desafio 2: Adicionar um novo cliente
-- Insira um cliente com: nome, email, telefone, cidade e estado
INSERT INTO clientes (nome, email, telefone, cidade, estado)
VALUES ('Maria Oliveira', 'maria.oliveira@email.com', '11988887777', 'Sao Paulo', 'SP');


-- =================================================================
-- AULA 55 - INSERT - Inserindo Múltiplos Registros
-- =================================================================

-- Aula 55 - Desafio 1: Adicionar 3 novos produtos de uma vez
-- Use um único comando INSERT
INSERT INTO produtos (nome, preco, estoque, marca, categoria_id)
VALUES
    ('Mouse Gamer RGB', 159.90, 100, 'Logitech', 1),
    ('Teclado Mecanico', 349.90, 75, 'Redragon', 1),
    ('Monitor 24 polegadas', 899.90, 30, 'Samsung', 1);


-- Aula 55 - Desafio 2: Adicionar 5 novos clientes de uma vez
-- Use um único comando INSERT com dados fictícios
INSERT INTO clientes (nome, email, telefone, cidade, estado)
VALUES
    ('Carlos Santos', 'carlos.santos@email.com', '21977776666', 'Rio de Janeiro', 'RJ'),
    ('Ana Paula Silva', 'ana.silva@email.com', '31966665555', 'Belo Horizonte', 'MG'),
    ('Pedro Henrique Lima', 'pedro.lima@email.com', '41955554444', 'Curitiba', 'PR'),
    ('Juliana Costa', 'juliana.costa@email.com', '51944443333', 'Porto Alegre', 'RS'),
    ('Roberto Ferreira', 'roberto.ferreira@email.com', '61933332222', 'Brasilia', 'DF');


-- =================================================================
-- AULA 56 - UPDATE - Atualizando Dados
-- =================================================================

-- Aula 56 - Desafio 1: Aumentar em 10% o preço de todos os produtos da categoria "Eletrônicos"
-- Dica: Use subconsulta ou JOIN para identificar a categoria

-- Primeiro, verificar quais produtos serão afetados:
-- SELECT p.nome, p.preco, p.preco * 1.10 AS novo_preco
-- FROM produtos p
-- INNER JOIN categorias c ON p.categoria_id = c.categoria_id
-- WHERE c.nome = 'Eletronicos';

-- Depois, executar o UPDATE:
UPDATE produtos
SET preco = preco * 1.10
WHERE categoria_id IN (
    SELECT categoria_id
    FROM categorias
    WHERE nome = 'Eletronicos'
);


-- Aula 56 - Desafio 2: Atualizar o estoque de um produto específico
-- Adicione 50 unidades ao estoque do produto com ID 1

-- Primeiro, verificar o estoque atual:
-- SELECT produto_id, nome, estoque FROM produtos WHERE produto_id = 1;

-- Depois, executar o UPDATE:
UPDATE produtos
SET estoque = estoque + 50
WHERE produto_id = 1;


-- =================================================================
-- AULA 57 - DELETE - Removendo Dados com Segurança
-- =================================================================

-- Aula 57 - Desafio 1: Remover produtos com estoque zerado
-- PRIMEIRO faça um SELECT para verificar, depois DELETE

-- Verificar quais produtos serão removidos:
-- SELECT produto_id, nome, estoque
-- FROM produtos
-- WHERE estoque = 0;

-- Se estiver correto, executar o DELETE:
DELETE FROM produtos
WHERE estoque = 0;


-- Aula 57 - Desafio 2: Remover clientes que nunca fizeram pedidos
-- Use WHERE com subquery ou NOT EXISTS

-- Verificar quais clientes serão removidos:
-- SELECT c.cliente_id, c.nome
-- FROM clientes c
-- WHERE NOT EXISTS (
--     SELECT 1 FROM pedidos p WHERE p.cliente_id = c.cliente_id
-- );

-- Se estiver correto, executar o DELETE:
DELETE FROM clientes c
WHERE NOT EXISTS (
    SELECT 1
    FROM pedidos p
    WHERE p.cliente_id = c.cliente_id
);


-- =================================================================
-- DESAFIOS FINAIS DO MODULO 12
-- =================================================================

-- Desafio Final 1: Cadastro em Massa
-- Insira 3 novos produtos e 3 novos clientes
-- Use INSERTs com múltiplos valores

-- 3 novos produtos:
INSERT INTO produtos (nome, preco, estoque, marca, categoria_id)
VALUES
    ('Smartwatch Fitness', 499.90, 40, 'Xiaomi', 1),
    ('Caixa de Som Portatil', 199.90, 60, 'JBL', 1),
    ('Carregador Wireless', 89.90, 100, 'Samsung', 1);

-- 3 novos clientes:
INSERT INTO clientes (nome, email, telefone, cidade, estado)
VALUES
    ('Fernanda Almeida', 'fernanda.almeida@email.com', '71922221111', 'Salvador', 'BA'),
    ('Lucas Mendes', 'lucas.mendes@email.com', '81911110000', 'Recife', 'PE'),
    ('Patricia Rocha', 'patricia.rocha@email.com', '92900009999', 'Manaus', 'AM');


-- Desafio Final 2: Atualização Condicional
-- a) Aumente em 5% o preço de produtos com estoque > 100

-- Verificar:
-- SELECT nome, preco, estoque, preco * 1.05 AS novo_preco
-- FROM produtos WHERE estoque > 100;

UPDATE produtos
SET preco = preco * 1.05
WHERE estoque > 100;

-- b) Diminua em 10% o preço de produtos sem vendas nos últimos 30 dias
-- Verificar:
-- SELECT p.nome, p.preco, p.preco * 0.90 AS novo_preco
-- FROM produtos p
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM itens_pedido ip
--     INNER JOIN pedidos ped ON ip.pedido_id = ped.pedido_id
--     WHERE ip.produto_id = p.produto_id
--       AND ped.data_pedido >= CURRENT_DATE - INTERVAL '30 days'
-- );

UPDATE produtos p
SET preco = preco * 0.90
WHERE NOT EXISTS (
    SELECT 1
    FROM itens_pedido ip
    INNER JOIN pedidos ped ON ip.pedido_id = ped.pedido_id
    WHERE ip.produto_id = p.produto_id
      AND ped.data_pedido >= CURRENT_DATE - INTERVAL '30 days'
);


-- Desafio Final 3: Limpeza Segura
-- Remova itens de pedido de pedidos cancelados
-- Primeiro: SELECT para verificar

-- Verificar itens a serem removidos:
-- SELECT ip.*
-- FROM itens_pedido ip
-- INNER JOIN pedidos p ON ip.pedido_id = p.pedido_id
-- WHERE p.status = 'cancelado';

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

-- PASSO 1: Verificar produtos envolvidos
-- SELECT produto_id, nome, estoque FROM produtos WHERE produto_id IN (5, 10);

-- PASSO 2a: Transferir estoque do produto 5 para o produto 10
-- Primeiro, pegar o estoque atual do produto 5:
-- SELECT estoque FROM produtos WHERE produto_id = 5;

-- Adicionar ao produto 10:
UPDATE produtos
SET estoque = estoque + (SELECT estoque FROM produtos WHERE produto_id = 5)
WHERE produto_id = 10;

-- Zerar estoque do produto 5:
UPDATE produtos
SET estoque = 0
WHERE produto_id = 5;


-- PASSO 2b: Atualizar itens_pedido para usar o novo produto_id
-- Verificar:
-- SELECT * FROM itens_pedido WHERE produto_id = 5;

UPDATE itens_pedido
SET produto_id = 10
WHERE produto_id = 5;


-- PASSO 2c: Remover o produto antigo
-- Verificar:
-- SELECT * FROM produtos WHERE produto_id = 5;

-- Verificar se há avaliacoes vinculadas:
-- SELECT * FROM avaliacoes WHERE produto_id = 5;

-- Se houver avaliacoes, remover primeiro:
DELETE FROM avaliacoes WHERE produto_id = 5;

-- Agora remover o produto:
DELETE FROM produtos WHERE produto_id = 5;

