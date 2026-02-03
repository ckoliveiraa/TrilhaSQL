-- ============================================
-- MÓDULO 10 - COMBINANDO RESULTADOS
-- Respostas do Desafio Final
-- ============================================

-- Desafio Final 1: Lista Unificada de Contatos
-- Crie uma lista única com:
-- - nome
-- - tipo ('Cliente' ou 'Outro')
-- De clientes. Não deve haver nomes duplicados.

SELECT DISTINCT
    nome,
    'Cliente' AS tipo
FROM clientes
ORDER BY nome;


-- Desafio Final 2: Histórico Completo de Transações
-- Combine pedidos e pagamentos em uma timeline:
-- - data da transação
-- - valor
-- - tipo ('Pedido' ou 'Pagamento')
-- - identificador (pedido_id ou pagamento_id)
-- Ordene por data

SELECT
    data_pedido AS data_transacao,
    valor_total AS valor,
    'Pedido' AS tipo,
    pedido_id AS identificador
FROM pedidos

UNION ALL

SELECT
    data_pagamento AS data_transacao,
    valor AS valor,
    'Pagamento' AS tipo,
    pagamento_id AS identificador
FROM pagamentos

ORDER BY data_transacao;


-- Desafio Final 3: Relatório de Totais
-- Mostre um resumo com:
-- - Total de produtos
-- - Total de clientes
-- - Total de pedidos
-- - Total de pagamentos
-- Cada linha deve ter: tipo e quantidade

SELECT 'Produtos' AS tipo, COUNT(*) AS quantidade FROM produtos
UNION ALL
SELECT 'Clientes' AS tipo, COUNT(*) AS quantidade FROM clientes
UNION ALL
SELECT 'Pedidos' AS tipo, COUNT(*) AS quantidade FROM pedidos
UNION ALL
SELECT 'Pagamentos' AS tipo, COUNT(*) AS quantidade FROM pagamentos;


-- Desafio Final 4 (Boss Final!): Análise de Sobreposição
-- Descubra:
-- a) Quantas marcas diferentes existem nos produtos

SELECT COUNT(DISTINCT marca) AS total_marcas
FROM produtos;


-- b) Quantas categorias diferentes existem

SELECT COUNT(*) AS total_categorias
FROM categorias;


-- c) Crie uma lista combinada de todas as marcas e nomes de categorias (UNION)

SELECT DISTINCT marca AS item, 'Marca' AS tipo
FROM produtos
WHERE marca IS NOT NULL

UNION

SELECT nome AS item, 'Categoria' AS tipo
FROM categorias

ORDER BY tipo, item;


-- d) Se houvesse uma tabela de marcas preferidas do cliente,
--    como você encontraria marcas que existem em produtos
--    E na lista de preferidas? (exemplo conceitual com INTERSECT)

-- Exemplo conceitual (a tabela marcas_preferidas não existe no banco):
-- SELECT DISTINCT marca FROM produtos
-- INTERSECT
-- SELECT marca FROM marcas_preferidas;

-- Demonstração com dados existentes - marcas que têm produtos em mais de uma categoria:
SELECT marca
FROM produtos
WHERE marca IS NOT NULL
GROUP BY marca
HAVING COUNT(DISTINCT categoria_id) > 1;
