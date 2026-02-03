-- ============================================
-- MÓDULO 2 - FILTROS AVANÇADOS
-- Respostas do Desafio Final
-- ============================================

-- Desafio Final 1: Análise de Pedidos por Status
-- Mostre todos os pedidos que estão "em_separacao", "enviado" ou "em_transito"
-- Ordene por data do pedido (mais recente primeiro)

SELECT *
FROM pedidos
WHERE status IN ('em_separacao', 'enviado', 'em_transito')
ORDER BY data_pedido DESC;


-- Desafio Final 2: Produtos Fora de Faixa
-- Encontre produtos com preço FORA do intervalo de R$ 200 a R$ 2000
-- Mostre nome, marca e preço, ordenados por preço

SELECT nome, marca, preco
FROM produtos
WHERE preco NOT BETWEEN 200 AND 2000
ORDER BY preco;


-- Desafio Final 3: Busca de Clientes
-- Encontre clientes cujo nome começa com "Maria" ou "Ana"
-- E que NÃO sejam de São Paulo (SP)
-- Mostre nome, cidade e estado

SELECT nome, cidade, estado
FROM clientes
WHERE (nome LIKE 'Maria%' OR nome LIKE 'Ana%')
  AND estado <> 'SP';


-- Desafio Final 4: Avaliações Medianas
-- Encontre avaliações com nota entre 2 e 4 (nem muito boas, nem muito ruins)
-- Que tenham algum comentário (comentario NOT LIKE '')
-- Mostre nota e comentário

SELECT nota, comentario
FROM avaliacoes
WHERE nota BETWEEN 2 AND 4
  AND comentario IS NOT NULL
  AND comentario <> '';


-- Desafio Final 5: Pagamentos Específicos (Desafio Avançado)
-- Encontre pagamentos que:
-- - Sejam de cartão (crédito ou débito) - use LIKE 'cartao%'
-- - Com valor entre R$ 100 e R$ 1000
-- - Que NÃO tenham status "recusado"
-- Mostre método, valor e status, ordenados por valor (maior primeiro)

SELECT metodo, valor, status
FROM pagamentos
WHERE metodo LIKE 'cartao%'
  AND valor BETWEEN 100 AND 1000
  AND status <> 'recusado'
ORDER BY valor DESC;


-- Desafio Final 6: Relatório Complexo (Boss Final!)
-- Crie uma consulta que mostre produtos onde:
-- - A marca seja "Samsung", "Apple", "Sony" ou "LG"
-- - O preço esteja entre R$ 500 e R$ 5000
-- - O nome contenha "Smart" ou "Pro" (use OR com dois LIKE)
-- - O estoque NÃO esteja entre 0 e 5 (evitar produtos quase esgotados)
-- Mostre nome, marca, preço e estoque
-- Ordene por marca (A-Z) e depois por preço (menor para maior)

SELECT nome, marca, preco, estoque
FROM produtos
WHERE marca IN ('Samsung', 'Apple', 'Sony', 'LG')
  AND preco BETWEEN 500 AND 5000
  AND (nome LIKE '%Smart%' OR nome LIKE '%Pro%')
  AND estoque NOT BETWEEN 0 AND 5
ORDER BY marca ASC, preco ASC;
