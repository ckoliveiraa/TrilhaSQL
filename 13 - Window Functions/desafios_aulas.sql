-- =================================================================
-- MODULO 13 - WINDOW FUNCTIONS - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 58 - ROW_NUMBER - Numerando Linhas
-- =================================================================

-- Aula 58 - Desafio 1: Numerar produtos ordenados por preço (do mais caro ao mais barato)
-- Exiba: número, nome e preço
SELECT
    ROW_NUMBER() OVER (ORDER BY preco DESC) AS numero,
    nome,
    preco
FROM produtos;


-- Aula 58 - Desafio 2: Numerar pedidos de cada cliente por data
-- Exiba: cliente_id, pedido_id, data_pedido e número do pedido
SELECT
    cliente_id,
    pedido_id,
    data_pedido,
    ROW_NUMBER() OVER (PARTITION BY cliente_id ORDER BY data_pedido) AS numero_pedido
FROM pedidos
ORDER BY cliente_id, numero_pedido;


-- =================================================================
-- AULA 59 - RANK - Ranking com Empates
-- =================================================================

-- Aula 59 - Desafio 1: Rankear produtos por preço (empatados ficam com mesmo número)
-- Exiba: ranking, nome, preco
SELECT
    RANK() OVER (ORDER BY preco DESC) AS ranking,
    nome,
    preco
FROM produtos;


-- Aula 59 - Desafio 2: Rankear clientes por total gasto
-- Use JOIN com pedidos, agrupe por cliente e aplique RANK
SELECT
    c.nome AS cliente,
    SUM(p.valor_total) AS total_gasto,
    RANK() OVER (ORDER BY SUM(p.valor_total) DESC) AS ranking
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome
ORDER BY ranking;


-- =================================================================
-- AULA 60 - DENSE_RANK - Ranking Denso
-- =================================================================

-- Aula 60 - Desafio 1: Rankear produtos por avaliação média (sem pular números)
-- Use DENSE_RANK com AVG(nota)
SELECT
    p.nome AS produto,
    ROUND(AVG(a.nota), 2) AS media_avaliacao,
    DENSE_RANK() OVER (ORDER BY AVG(a.nota) DESC) AS ranking
FROM produtos p
INNER JOIN avaliacoes a ON p.produto_id = a.produto_id
GROUP BY p.produto_id, p.nome
ORDER BY ranking;


-- Aula 60 - Desafio 2: Rankear categorias por número de produtos
-- Conte produtos por categoria e aplique DENSE_RANK
SELECT
    c.nome AS categoria,
    COUNT(p.produto_id) AS total_produtos,
    DENSE_RANK() OVER (ORDER BY COUNT(p.produto_id) DESC) AS ranking
FROM categorias c
LEFT JOIN produtos p ON c.categoria_id = p.categoria_id
GROUP BY c.categoria_id, c.nome
ORDER BY ranking;


-- =================================================================
-- AULA 61 - PARTITION BY - Dividindo em Grupos
-- =================================================================

-- Aula 61 - Desafio 1: Numerar produtos dentro de cada categoria
-- Ordenar por preço dentro de cada categoria
SELECT
    c.nome AS categoria,
    p.nome AS produto,
    p.preco,
    ROW_NUMBER() OVER (
        PARTITION BY p.categoria_id
        ORDER BY p.preco DESC
    ) AS ranking_na_categoria
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
ORDER BY c.nome, ranking_na_categoria;


-- Aula 61 - Desafio 2: Rankear vendas por mês
-- Mostre o ranking de pedidos por valor em cada mês
SELECT
    EXTRACT(YEAR FROM data_pedido) AS ano,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    pedido_id,
    valor_total,
    RANK() OVER (
        PARTITION BY EXTRACT(YEAR FROM data_pedido), EXTRACT(MONTH FROM data_pedido)
        ORDER BY valor_total DESC
    ) AS ranking_no_mes
FROM pedidos
ORDER BY ano, mes, ranking_no_mes;


-- =================================================================
-- AULA 62 - LEAD e LAG - Acessando Linhas Adjacentes
-- =================================================================

-- Aula 62 - Desafio 1: Comparar preço de cada produto com o próximo produto
-- Ordene por preço e mostre a diferença
SELECT
    nome,
    preco,
    LEAD(preco) OVER (ORDER BY preco) AS preco_proximo,
    LEAD(preco) OVER (ORDER BY preco) - preco AS diferenca
FROM produtos
ORDER BY preco;


-- Aula 62 - Desafio 2: Calcular diferença de valor entre pedidos consecutivos de cada cliente
-- Use PARTITION BY cliente_id
SELECT
    cliente_id,
    pedido_id,
    data_pedido,
    valor_total,
    LAG(valor_total) OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido
    ) AS valor_pedido_anterior,
    valor_total - LAG(valor_total) OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido
    ) AS diferenca
FROM pedidos
ORDER BY cliente_id, data_pedido;


-- =================================================================
-- DESAFIOS FINAIS DO MODULO 13
-- =================================================================

-- Desafio Final 1: Ranking Completo de Produtos
-- Para cada produto, mostre:
-- - nome, preco, categoria
-- - ROW_NUMBER, RANK e DENSE_RANK por preço
-- Compare os resultados
SELECT
    p.nome,
    p.preco,
    c.nome AS categoria,
    ROW_NUMBER() OVER (ORDER BY p.preco DESC) AS row_num,
    RANK() OVER (ORDER BY p.preco DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY p.preco DESC) AS dense_rank
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
ORDER BY p.preco DESC;


-- Desafio Final 2: Top 2 Produtos por Categoria
-- Liste os 2 produtos mais caros de cada categoria
-- Use PARTITION BY e ROW_NUMBER
SELECT
    categoria,
    produto,
    preco,
    ranking
FROM (
    SELECT
        c.nome AS categoria,
        p.nome AS produto,
        p.preco,
        ROW_NUMBER() OVER (
            PARTITION BY p.categoria_id
            ORDER BY p.preco DESC
        ) AS ranking
    FROM produtos p
    INNER JOIN categorias c ON p.categoria_id = c.categoria_id
) AS ranked
WHERE ranking <= 2
ORDER BY categoria, ranking;


-- Desafio Final 3: Análise de Pedidos do Cliente
-- Para cada pedido, mostre:
-- - cliente_id, pedido_id, data_pedido, valor_total
-- - valor do pedido anterior do mesmo cliente
-- - diferença entre pedidos
-- - número do pedido do cliente (1º, 2º, 3º...)
SELECT
    cliente_id,
    pedido_id,
    data_pedido,
    valor_total,
    LAG(valor_total) OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido
    ) AS valor_anterior,
    valor_total - LAG(valor_total) OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido
    ) AS diferenca,
    ROW_NUMBER() OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido
    ) AS numero_pedido_cliente
FROM pedidos
ORDER BY cliente_id, data_pedido;


-- Desafio Final 4: Variação de Vendas
-- Calcule a variação percentual de vendas diárias
-- Mostre: data, total do dia, total do dia anterior, variação %
SELECT
    data_pedido,
    total_dia,
    LAG(total_dia) OVER (ORDER BY data_pedido) AS total_dia_anterior,
    ROUND(
        100.0 * (total_dia - LAG(total_dia) OVER (ORDER BY data_pedido))
        / NULLIF(LAG(total_dia) OVER (ORDER BY data_pedido), 0),
        2
    ) AS variacao_percentual
FROM (
    SELECT
        DATE(data_pedido) AS data_pedido,
        SUM(valor_total) AS total_dia
    FROM pedidos
    GROUP BY DATE(data_pedido)
) AS vendas_diarias
ORDER BY data_pedido;


-- Desafio Final 5 (Boss Final!): Dashboard de Performance
-- Crie um relatório que mostre para cada produto:
-- - nome, categoria, preco, estoque
-- - Ranking geral por preço
-- - Ranking dentro da categoria
-- - Se é o mais caro da categoria (sim/não)
-- - Diferença de preço para o produto mais caro da mesma categoria
SELECT
    p.nome AS produto,
    c.nome AS categoria,
    p.preco,
    p.estoque,
    RANK() OVER (ORDER BY p.preco DESC) AS ranking_geral,
    RANK() OVER (
        PARTITION BY p.categoria_id
        ORDER BY p.preco DESC
    ) AS ranking_categoria,
    CASE
        WHEN RANK() OVER (PARTITION BY p.categoria_id ORDER BY p.preco DESC) = 1
        THEN 'Sim'
        ELSE 'Nao'
    END AS mais_caro_categoria,
    FIRST_VALUE(p.preco) OVER (
        PARTITION BY p.categoria_id
        ORDER BY p.preco DESC
    ) - p.preco AS diferenca_para_mais_caro
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
ORDER BY c.nome, p.preco DESC;

