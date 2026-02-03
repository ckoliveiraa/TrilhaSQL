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

-- Aula 16 - Desafio 1: Mostrar categorias cuja descricao contenha a palavra 'casa'
-- Nota: Use ILIKE para busca case-insensitive no PostgreSQL
SELECT *
FROM categorias
WHERE descricao ILIKE '%casa%';

-- Aula 16 - Desafio 2: Mostrar avaliacoes cujo comentario contenha a palavra "qualidade"
SELECT *
FROM avaliacoes
WHERE comentario LIKE '%qualidade%';

-- =================================================================
-- AULA 17 - LIKE com % e _ - Padroes Avancados
-- =================================================================

-- Aula 17 - Desafio 1: Mostrar clientes cujo estado comece com a letra 'S'
-- Usa _ para representar o segundo caractere (estados tem exatamente 2 letras)
SELECT *
FROM clientes
WHERE estado LIKE 'S_';


-- Aula 17 - Desafio 2: Mostrar clientes com email de dominio 'example' ou 'exemple' com o final .net.
SELECT *
FROM clientes
WHERE email LIKE '%@exampl_.n__';
