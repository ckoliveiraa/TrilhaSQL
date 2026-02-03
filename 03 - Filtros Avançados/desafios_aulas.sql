-- =================================================================
-- MODULO 02 - FILTROS AVANCADOS - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 12 - NOT - Negando Condicoes
-- =================================================================

-- Aula 12 - Desafio 1: Mostrar todos os pedidos que NAO foram cancelados
SELECT *
FROM pedidos
WHERE NOT status = 'cancelado';

-- Alternativa mais comum:
SELECT *
FROM pedidos
WHERE status <> 'cancelado';


-- Aula 12 - Desafio 2: Mostrar todos os pagamentos que NAO foram feitos via 'boleto'
SELECT *
FROM pagamentos
WHERE NOT metodo = 'boleto';

-- Alternativa:
SELECT *
FROM pagamentos
WHERE metodo <> 'boleto';


-- =================================================================
-- AULA 13 - IN - Filtrando por Lista de Valores
-- =================================================================

-- Aula 13 - Desafio 1: Mostrar pedidos com status 'entregue' ou 'enviado'
SELECT *
FROM pedidos
WHERE status IN ('entregue', 'enviado');


-- Aula 13 - Desafio 2: Mostrar pagamentos feitos com 'pix' ou 'cartao_credito'
SELECT *
FROM pagamentos
WHERE metodo IN ('pix', 'cartao_credito');


-- =================================================================
-- AULA 14 - NOT IN - Excluindo Lista de Valores
-- =================================================================

-- Aula 14 - Desafio 1: Mostrar avaliacoes que NAO tenham nota 1 ou 5
SELECT *
FROM avaliacoes
WHERE nota NOT IN (1, 5);


-- Aula 14 - Desafio 2: Mostrar pedidos com status que NAO sejam "pendente" ou "confirmado"
SELECT *
FROM pedidos
WHERE status NOT IN ('pendente', 'confirmado');


-- =================================================================
-- AULA 15 - BETWEEN - Filtrando por Intervalo
-- =================================================================

-- Aula 15 - Desafio 1: Mostrar pedidos com valor total entre R$ 500 e R$ 1500
SELECT *
FROM pedidos
WHERE valor_total BETWEEN 500 AND 1500;


-- Aula 15 - Desafio 2: Mostrar pagamentos realizados no ano de 2025
-- Filtra pagamentos cujo pedido associado foi feito em 2025
SELECT *
FROM pagamentos
WHERE data_pagamento BETWEEN '2025-01-01' AND '2025-12-31';


-- =================================================================
-- AULA 16 - LIKE - Buscando Padroes de Texto
-- =================================================================

-- Aula 16 - Desafio 1: Mostrar categorias cuja descricao contenha a palavra 'acessorios'
-- Nota: Use ILIKE para busca case-insensitive no PostgreSQL
SELECT *
FROM categorias
WHERE descricao ILIKE '%acessorio%';


-- Aula 16 - Desafio 2: Mostrar avaliacoes cujo comentario contenha a palavra "rapida"
-- Nota: Use ILIKE para busca case-insensitive no PostgreSQL
SELECT *
FROM avaliacoes
WHERE comentario ILIKE '%rapida%';


-- =================================================================
-- AULA 17 - LIKE com % e _ - Padroes Avancados
-- =================================================================

-- Aula 17 - Desafio 1: Mostrar todos os metodos de pagamento que comecem com 'cartao'
SELECT DISTINCT metodo
FROM pagamentos
WHERE metodo LIKE 'cartao%';


-- Aula 17 - Desafio 2: Mostrar os status de pedido que terminem com a letra 'o'
SELECT DISTINCT status
FROM pedidos
WHERE status LIKE '%o';


-- =================================================================
-- DESAFIOS FINAIS DO MODULO 02
-- =================================================================

-- Desafio Final 1: Analise de Pedidos por Status
-- Mostre todos os pedidos que estao "em_separacao", "enviado" ou "em_transito"
-- Ordene por data do pedido (mais recente primeiro)
SELECT *
FROM pedidos
WHERE status IN ('em_separacao', 'enviado', 'em_transito')
ORDER BY data_pedido DESC;


-- Desafio Final 2: Produtos Fora de Faixa
-- Encontre produtos com preco FORA do intervalo de R$ 200 a R$ 2000
-- Mostre nome, marca e preco, ordenados por preco
SELECT nome, marca, preco
FROM produtos
WHERE preco NOT BETWEEN 200 AND 2000
ORDER BY preco;


-- Desafio Final 3: Busca de Clientes
-- Encontre clientes cujo nome comeca com "Maria" ou "Ana"
-- E que NAO sejam de Sao Paulo (SP)
-- Mostre nome, cidade e estado
SELECT nome, cidade, estado
FROM clientes
WHERE (nome LIKE 'Maria%' OR nome LIKE 'Ana%')
  AND estado <> 'SP';


-- Desafio Final 4: Avaliacoes Medianas
-- Encontre avaliacoes com nota entre 2 e 4 (nem muito boas, nem muito ruins)
-- Que tenham algum comentario (comentario nao vazio)
-- Mostre nota e comentario
SELECT nota, comentario
FROM avaliacoes
WHERE nota BETWEEN 2 AND 4
  AND comentario IS NOT NULL
  AND comentario <> '';


-- Desafio Final 5: Pagamentos Especificos (Desafio Avancado)
-- Encontre pagamentos que:
-- - Sejam de cartao (credito ou debito) - use LIKE 'cartao%'
-- - Com valor entre R$ 100 e R$ 1000
-- - Que NAO tenham status "recusado"
-- Mostre metodo, valor e status, ordenados por valor (maior primeiro)
SELECT metodo, valor, status
FROM pagamentos
WHERE metodo LIKE 'cartao%'
  AND valor BETWEEN 100 AND 1000
  AND status <> 'recusado'
ORDER BY valor DESC;


-- Desafio Final 6: Relatorio Complexo (Boss Final!)
-- Crie uma consulta que mostre produtos onde:
-- - A marca seja "Samsung", "Apple", "Sony" ou "LG"
-- - O preco esteja entre R$ 500 e R$ 5000
-- - O nome contenha "Smart" ou "Pro" (use OR com dois LIKE)
-- - O estoque NAO esteja entre 0 e 5 (evitar produtos quase esgotados)
-- Mostre nome, marca, preco e estoque
-- Ordene por marca (A-Z) e depois por preco (menor para maior)
SELECT nome, marca, preco, estoque
FROM produtos
WHERE marca IN ('Samsung', 'Apple', 'Sony', 'LG')
  AND preco BETWEEN 500 AND 5000
  AND (nome LIKE '%Smart%' OR nome LIKE '%Pro%')
  AND estoque NOT BETWEEN 0 AND 5
ORDER BY marca ASC, preco ASC;
