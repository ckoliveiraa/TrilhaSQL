-- =====================================================
-- RESPOSTAS DOS DESAFIOS FINAIS - MÓDULO 2
-- Fundamentos SELECT
-- =====================================================

-- Desafio Final 1: Catálogo de Produtos Premium
-- Liste nome, marca e preço dos produtos com preço maior que R$ 2000
-- Ordene do mais caro para o mais barato
-- Renomeie as colunas para "Produto", "Fabricante" e "Valor (R$)"

SELECT nome AS "Produto", marca AS "Fabricante", preco AS "Valor (R$)"
FROM produtos
WHERE preco > 2000
ORDER BY preco DESC;


-- Desafio Final 2: Análise de Estoque Crítico
-- Encontre produtos com estoque menor que 50 unidades OU preço menor que R$ 200
-- Mostre nome, estoque e preço, ordenados por estoque (menor primeiro)
-- Limite a 10 resultados

SELECT nome, estoque, preco
FROM produtos
WHERE estoque < 50 OR preco < 200
ORDER BY estoque ASC
LIMIT 10;


-- Desafio Final 3: Clientes por Região
-- Liste todos os estados únicos onde há clientes cadastrados
-- Ordene em ordem alfabética

SELECT DISTINCT estado
FROM clientes
ORDER BY estado ASC;


-- Desafio Final 4: Relatório de Pedidos
-- Mostre os 15 pedidos mais recentes com status "entregue"
-- Exiba data_pedido (como "Data"), valor_total (como "Total") e status
-- Ordene pela data mais recente primeiro

SELECT data_pedido AS "Data", valor_total AS "Total", status
FROM pedidos
WHERE status = 'entregue'
ORDER BY data_pedido DESC
LIMIT 15;


-- Desafio Final 5: Produtos em Destaque (Desafio Avançado)
-- Encontre produtos que sejam:
-- (marca "Samsung" E preço > 1000) OU (marca "Sony" E estoque > 100)
-- Mostre nome, marca, preço e estoque
-- Ordene por preço decrescente

SELECT nome, marca, preco, estoque
FROM produtos
WHERE (marca = 'Samsung' AND preco > 1000) OR (marca = 'Sony' AND estoque > 100)
ORDER BY preco DESC;


-- Desafio Final 6: Análise de Avaliações
-- Liste as 10 piores avaliações (nota = 1 ou nota = 2)
-- Mostre nota (como "Estrelas") e comentario (como "Feedback")
-- Ordene pela nota (menor primeiro)

SELECT nota AS "Estrelas", comentario AS "Feedback"
FROM avaliacoes
WHERE nota = 1 OR nota = 2
ORDER BY nota ASC
LIMIT 10;


-- Desafio Final 7: Pagamentos Pendentes
-- Encontre pagamentos com status diferente de "aprovado"
-- Mostre metodo (como "Forma de Pagamento"), valor e status
-- Ordene pelo valor (maior primeiro), limitado a 20 resultados

SELECT metodo AS "Forma de Pagamento", valor, status
FROM pagamentos
WHERE status <> 'aprovado'
ORDER BY valor DESC
LIMIT 20;


-- Desafio Final 8: Relatório Completo (Boss Final!)
-- Crie uma consulta que mostre:
-- - Nome do produto (como "Produto")
-- - Marca (como "Fabricante")
-- - Preço (como "Preço (R$)")
-- - Estoque (como "Qtd Disponível")
-- Filtros: marca = "Samsung" OU marca = "LG" OU marca = "Sony"
--          E preço entre 1000 e 5000 (use >= e <=)
--          E estoque > 0
-- Ordenado por marca (A-Z), depois por preço (menor para maior)
-- Limitado aos 20 primeiros resultados

SELECT
    nome AS "Produto",
    marca AS "Fabricante",
    preco AS "Preço (R$)",
    estoque AS "Qtd Disponível"
FROM produtos
WHERE (marca = 'Samsung' OR marca = 'LG' OR marca = 'Sony')
    AND preco >= 1000
    AND preco <= 5000
    AND estoque > 0
ORDER BY marca ASC, preco ASC
LIMIT 20;
