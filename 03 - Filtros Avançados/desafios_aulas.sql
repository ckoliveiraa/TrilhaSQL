-- Aula 12 - Desafio 1: Mostrar todos os pedidos que NÃO foram cancelados
SELECT *
FROM pedidos
WHERE NOT status = 'cancelado'
-- Alternativa mais comum:
SELECT *
FROM pedidos
WHERE status <> 'cancelado'
-- Aula 12 - Desafio 2: Mostrar todos os pagamentos que NÃO foram feitos via 'boleto'
SELECT *
FROM pagamentos
WHERE NOT metodo = 'boleto';
-- Alternativa:
SELECT *
FROM pagamentos
WHERE metodo <> 'boleto';
-- Aula 13 - Desafio 1: Mostrar pedidos com status 'entregue' ou 'enviado'
SELECT *
FROM pedidos
WHERE status IN ('entregue', 'enviado')
-- Aula 13 - Desafio 2: Mostrar pagamentos feitos com 'pix' ou 'cartao_credito'
SELECT *
FROM pagamentos
WHERE metodo IN ('pix', 'cartao_credito')
-- Aula 14 - Desafio 1: Mostrar avaliações que NÃO tenham nota 1 ou 5
SELECT *
FROM avaliacoes
WHERE nota NOT IN (1, 5);
-- Aula 14 - Desafio 2: Mostrar pedidos com status que NÃO sejam "pendente" ou "confirmado"
SELECT *
FROM pedidos
WHERE status NOT IN ('pendente', 'confirmado');
-- Aula 15 - Desafio 1: Mostrar pedidos com valor total entre R$ 500 e R$ 1500
SELECT *
FROM pedidos
WHERE valor_total BETWEEN 500 AND 1500;
-- Aula 15 - Desafio 2: Mostrar pagamentos realizados no ano de 2025
SELECT *
FROM pagamentos
WHERE data_pagamento BETWEEN '2025-01-01' AND '2025-12-31';
-- Aula 16 - Desafio 1: Mostrar categorias cuja descrição contenha a palavra 'casa'
SELECT *
FROM categorias
WHERE lower(descricao) LIKE '%casa%';
-- Aula 16 - Desafio 2: Mostrar avaliações cujo comentário contenha a palavra "qualidade"
SELECT *
FROM avaliacoes
WHERE LOWER(comentario) LIKE '%qualidade%';
-- Aula 17 - Desafio 1: Mostrar clientes cujo estado comece com a letra 'S'
SELECT *
FROM clientes
WHERE estado LIKE 'S_';
--Query alternativa
SELECT *
FROM clientes
WHERE estado LIKE 'S%';
-- Aula 17 - Desafio 2: Mostrar clientes com email de dominio 'example' ou 'exemple' com o final .net.
SELECT *
FROM clientes
WHERE email LIKE '%@ex_mple.net';
