-- =================================================================
-- MODULO 07 - FUNCOES DE AGREGACAO - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 33 - COUNT - Contando Registros
-- =================================================================

-- Aula 33 - Desafio 1: Contar quantos produtos existem no banco
SELECT COUNT(*) AS total_produtos
FROM produtos;


-- Aula 33 - Desafio 2: Contar quantos pedidos foram feitos em 2024
SELECT COUNT(*) AS pedidos_2024
FROM pedidos
WHERE EXTRACT(YEAR FROM data_pedido) = 2024;


-- =================================================================
-- AULA 34 - COUNT DISTINCT - Contando Valores Unicos
-- =================================================================

-- Aula 34 - Desafio 1: Contar quantas marcas diferentes de produtos existem
SELECT COUNT(DISTINCT marca) AS total_marcas
FROM produtos;


-- Aula 34 - Desafio 2: Contar em quantas cidades diferentes temos clientes
SELECT COUNT(DISTINCT cidade) AS total_cidades
FROM clientes;


-- =================================================================
-- AULA 35 - SUM - Somando Valores
-- =================================================================

-- Aula 35 - Desafio 1: Calcular o valor total de todos os pedidos
SELECT SUM(valor_total) AS faturamento_total
FROM pedidos;


-- Aula 35 - Desafio 2: Calcular o estoque total de todos os produtos
SELECT SUM(estoque) AS estoque_total
FROM produtos;


-- =================================================================
-- AULA 36 - AVG - Calculando Media
-- =================================================================

-- Aula 36 - Desafio 1: Calcular o preco medio dos produtos
SELECT ROUND(AVG(preco), 2) AS preco_medio
FROM produtos;


-- Aula 36 - Desafio 2: Calcular o valor medio dos pedidos
SELECT ROUND(AVG(valor_total), 2) AS ticket_medio
FROM pedidos;


-- =================================================================
-- AULA 37 - MIN - Encontrando Minimo
-- =================================================================

-- Aula 37 - Desafio 1: Encontrar o produto mais barato
SELECT MIN(preco) AS menor_preco
FROM produtos;

-- Para ver qual produto:
SELECT nome, preco
FROM produtos
ORDER BY preco ASC
LIMIT 1;


-- Aula 37 - Desafio 2: Encontrar o pedido de menor valor
SELECT MIN(valor_total) AS menor_pedido
FROM pedidos;


-- =================================================================
-- AULA 38 - MAX - Encontrando Maximo
-- =================================================================

-- Aula 38 - Desafio 1: Encontrar o produto mais caro
SELECT MAX(preco) AS maior_preco
FROM produtos;

-- Para ver qual produto:
SELECT nome, preco
FROM produtos
ORDER BY preco DESC
LIMIT 1;


-- Aula 38 - Desafio 2: Encontrar o pedido de maior valor
SELECT MAX(valor_total) AS maior_pedido
FROM pedidos;


-- =================================================================
-- DESAFIOS FINAIS DO MODULO 07
-- =================================================================

-- Desafio Final 1: Visao Geral do Catalogo
-- Total de produtos, estoque total, preco medio, menor e maior preco
SELECT
    COUNT(*) AS total_produtos,
    SUM(estoque) AS estoque_total,
    ROUND(AVG(preco), 2) AS preco_medio,
    MIN(preco) AS menor_preco,
    MAX(preco) AS maior_preco
FROM produtos;


-- Desafio Final 2: Analise de Vendas
-- Total de pedidos, valor total, ticket medio, menor e maior pedido
SELECT
    COUNT(*) AS total_pedidos,
    SUM(valor_total) AS valor_total_vendido,
    ROUND(AVG(valor_total), 2) AS ticket_medio,
    MIN(valor_total) AS menor_pedido,
    MAX(valor_total) AS maior_pedido
FROM pedidos;


-- Desafio Final 3: Diversidade de Clientes
-- Quantos clientes, em quantas cidades, em quantos estados
SELECT
    COUNT(*) AS total_clientes,
    COUNT(DISTINCT cidade) AS total_cidades,
    COUNT(DISTINCT estado) AS total_estados
FROM clientes;


-- Desafio Final 4: Estatisticas de Avaliacoes
-- Total de avaliacoes, nota media, menor e maior nota
SELECT
    COUNT(*) AS total_avaliacoes,
    ROUND(AVG(nota), 1) AS nota_media,
    MIN(nota) AS menor_nota,
    MAX(nota) AS maior_nota
FROM avaliacoes;


-- Desafio Final 5: Analise de Pagamentos (Desafio Avancado)
-- Para pagamentos com status "aprovado":
-- Quantos aprovados, valor total, valor medio, metodos diferentes
SELECT
    COUNT(*) AS qtd_aprovados,
    SUM(valor) AS valor_total_aprovado,
    ROUND(AVG(valor), 2) AS valor_medio_aprovado,
    COUNT(DISTINCT metodo) AS metodos_diferentes
FROM pagamentos
WHERE status = 'aprovado';


-- Desafio Final 6: Relatorio Completo (Boss Final!)
-- Para produtos da marca "Samsung":
-- Quantidade, estoque total, preco medio, mais barato e mais caro
SELECT
    COUNT(*) AS qtd_produtos_samsung,
    SUM(estoque) AS estoque_total,
    ROUND(AVG(preco), 2) AS preco_medio,
    MIN(preco) AS produto_mais_barato,
    MAX(preco) AS produto_mais_caro
FROM produtos
WHERE marca = 'Samsung';
