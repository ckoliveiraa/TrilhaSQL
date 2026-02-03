-- ============================================
-- MÓDULO 7 - FUNÇÕES DE AGREGAÇÃO
-- Respostas do Desafio Final
-- ============================================

-- Desafio Final 1: Visão Geral do Catálogo
-- Mostre em uma única consulta:
-- - Total de produtos cadastrados
-- - Quantidade total em estoque
-- - Preço médio dos produtos (arredondado para 2 casas)
-- - Produto mais barato
-- - Produto mais caro

SELECT
    COUNT(*) AS "Total de Produtos",
    SUM(estoque) AS "Estoque Total",
    ROUND(AVG(preco), 2) AS "Preço Médio",
    MIN(preco) AS "Menor Preço",
    MAX(preco) AS "Maior Preço"
FROM produtos;


-- Desafio Final 2: Análise de Vendas
-- Mostre em uma única consulta:
-- - Total de pedidos realizados
-- - Valor total vendido
-- - Ticket médio (valor médio por pedido)
-- - Menor pedido
-- - Maior pedido

SELECT
    COUNT(*) AS "Total de Pedidos",
    SUM(valor_total) AS "Valor Total Vendido",
    ROUND(AVG(valor_total), 2) AS "Ticket Médio",
    MIN(valor_total) AS "Menor Pedido",
    MAX(valor_total) AS "Maior Pedido"
FROM pedidos;


-- Desafio Final 3: Diversidade de Clientes
-- Descubra:
-- - Quantos clientes estão cadastrados
-- - Em quantas cidades diferentes
-- - Em quantos estados diferentes

SELECT
    COUNT(*) AS "Total de Clientes",
    COUNT(DISTINCT cidade) AS "Cidades Diferentes",
    COUNT(DISTINCT estado) AS "Estados Diferentes"
FROM clientes;


-- Desafio Final 4: Estatísticas de Avaliações
-- Mostre:
-- - Total de avaliações
-- - Nota média (arredondada para 1 casa decimal)
-- - Menor nota
-- - Maior nota

SELECT
    COUNT(*) AS "Total de Avaliações",
    ROUND(AVG(nota), 1) AS "Nota Média",
    MIN(nota) AS "Menor Nota",
    MAX(nota) AS "Maior Nota"
FROM avaliacoes;


-- Desafio Final 5: Análise de Pagamentos (Desafio Avançado)
-- Para pagamentos com status "aprovado":
-- - Quantos pagamentos foram aprovados
-- - Valor total aprovado
-- - Valor médio aprovado
-- - Quantos métodos de pagamento diferentes foram usados

SELECT
    COUNT(*) AS "Pagamentos Aprovados",
    SUM(valor) AS "Valor Total Aprovado",
    ROUND(AVG(valor), 2) AS "Valor Médio Aprovado",
    COUNT(DISTINCT metodo) AS "Métodos Diferentes"
FROM pagamentos
WHERE status = 'aprovado';


-- Desafio Final 6: Relatório Completo (Boss Final!)
-- Crie uma consulta que mostre para produtos da marca "Samsung":
-- - Quantidade de produtos Samsung
-- - Estoque total de produtos Samsung
-- - Preço médio (arredondado)
-- - Produto Samsung mais barato
-- - Produto Samsung mais caro

SELECT
    COUNT(*) AS "Qtd Produtos Samsung",
    SUM(estoque) AS "Estoque Total",
    ROUND(AVG(preco), 2) AS "Preço Médio",
    MIN(preco) AS "Mais Barato",
    MAX(preco) AS "Mais Caro"
FROM produtos
WHERE marca = 'Samsung';
