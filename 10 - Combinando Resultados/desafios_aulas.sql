-- =================================================================
-- MODULO 10 - COMBINANDO RESULTADOS - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 48 - UNION - Combinando Queries (sem duplicatas)
-- =================================================================

-- Aula 48 - Desafio 1: Criar lista única de todas as marcas de produtos e nomes de categorias
-- Combine em uma única lista, sem duplicatas
SELECT marca AS item
FROM produtos
WHERE marca IS NOT NULL
UNION
SELECT nome AS item
FROM categorias
ORDER BY item;


-- Aula 48 - Desafio 2: Listar todas as cidades onde temos clientes
-- Crie uma lista única de cidades (sem repetição)
SELECT DISTINCT cidade
FROM clientes
WHERE cidade IS NOT NULL
ORDER BY cidade;


-- =================================================================
-- AULA 49 - UNION ALL - Combinando Queries (com duplicatas)
-- =================================================================

-- Aula 49 - Desafio 1: Listar todos os nomes (produtos e clientes), permitindo repetição
-- Use UNION ALL para manter duplicatas
SELECT nome, 'Produto' AS tipo
FROM produtos
UNION ALL
SELECT nome, 'Cliente' AS tipo
FROM clientes
ORDER BY tipo, nome;


-- Aula 49 - Desafio 2: Criar histórico completo de ações
-- Combine pedidos e pagamentos em uma linha do tempo
-- Inclua: data, valor, tipo de ação
SELECT
    data_pedido AS data,
    valor_total AS valor,
    'Pedido' AS tipo_acao
FROM pedidos
UNION ALL
SELECT
    data_pagamento AS data,
    valor AS valor,
    'Pagamento' AS tipo_acao
FROM pagamentos
ORDER BY data;


-- =================================================================
-- DESAFIOS FINAIS DO MODULO 10
-- =================================================================

-- Desafio Final 1: Lista Unificada de Contatos
-- Crie uma lista única com:
-- - nome
-- - tipo ('Cliente' ou 'Outro')
-- De clientes. Não deve haver nomes duplicados.
SELECT
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
SELECT marca AS item, 'Marca' AS origem
FROM produtos
WHERE marca IS NOT NULL
UNION
SELECT nome AS item, 'Categoria' AS origem
FROM categorias
ORDER BY origem, item;

-- d) Se houvesse uma tabela de marcas preferidas do cliente,
--    como você encontraria marcas que existem em produtos
--    E na lista de preferidas? (uso conceitual do INTERSECT)
-- Exemplo conceitual:
-- SELECT marca FROM produtos
-- INTERSECT
-- SELECT marca FROM marcas_preferidas_cliente;

-- Demonstração com INTERSECT usando dados existentes:
-- Marcas que aparecem tanto em produtos quanto em categorias (se houvesse sobreposição de nomes)
SELECT marca AS nome FROM produtos WHERE marca IS NOT NULL
INTERSECT
SELECT nome FROM categorias;

-- Demonstração com EXCEPT: Marcas que NÃO são nomes de categorias
SELECT DISTINCT marca AS nome FROM produtos WHERE marca IS NOT NULL
EXCEPT
SELECT nome FROM categorias
ORDER BY nome;

