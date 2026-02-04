-- =================================================================
-- MODULO 04 - FUNCOES DE DATA - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 24 - CURRENT_DATE - Data Atual
-- =================================================================

-- Aula 24 - Desafio 1: Calcular quantos dias se passaram desde cada pedido
-- Exiba pedido_id, data_pedido, data atual e dias desde o pedido
SELECT
    pedido_id,
    data_pedido,
    CURRENT_DATE AS data_atual,
    CURRENT_DATE - data_pedido AS dias_desde_pedido
FROM pedidos;


-- Aula 24 - Desafio 2: Mostrar idade aproximada dos clientes
-- Exiba o nome e data atual e a idade aproximada (em anos)
SELECT
    nome,
    CURRENT_DATE AS data_atual,
    AGE(CURRENT_DATE, data_nascimento) AS idade_aproximada
FROM clientes
WHERE data_nascimento IS NOT NULL;


-- =================================================================
-- AULA 25 - DATE_PART / EXTRACT - Extraindo Partes da Data
-- =================================================================

-- Aula 25 - Desafio 1: Extrair o mes de cada pedido
-- Exiba o pedido_id, data_pedido e o mes
SELECT
    pedido_id,
    data_pedido,
    EXTRACT(MONTH FROM data_pedido) AS mes
FROM pedidos;


-- Aula 25 - Desafio 2: Extrair ano, mes e dia de cada pedido
-- Exiba pedido_id, data_pedido, ano, mes e dia separadamente
SELECT
    pedido_id,
    data_pedido,
    EXTRACT(YEAR FROM data_pedido) AS ano,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    EXTRACT(DAY FROM data_pedido) AS dia
FROM pedidos;


-- =================================================================
-- AULA 26 - Adicionando e Subtraindo Tempo
-- =================================================================

-- Aula 26 - Desafio 1: Calcular prazo de entrega (data_pedido + 7 dias)
-- Exiba pedido_id, data_pedido e prazo_entrega
SELECT
    pedido_id,
    data_pedido,
    data_pedido + INTERVAL '7 days' AS prazo_entrega
FROM pedidos;


-- Aula 26 - Desafio 2: Adicionar 30 dias a data atual
-- Exiba nome e a data daqui a 30 dias
SELECT
    nome,
    CURRENT_DATE AS data_atual,
    CURRENT_DATE + INTERVAL '30 days' AS data_mais_30_dias
FROM clientes;


-- =================================================================
-- AULA 27 - Diferenca Entre Datas
-- =================================================================

-- Aula 27 - Desafio 1: Calcular tempo de entrega em dias
-- Exiba pedido_id, data_pedido e dias ate hoje
SELECT
    pedido_id,
    data_pedido,
    CURRENT_DATE - data_pedido AS dias_desde_pedido
FROM pedidos
WHERE status = 'entregue';


-- Aula 27 - Desafio 2: Calcular atraso nas entregas
-- Considere prazo de 7 dias. Mostre apenas pedidos possivelmente atrasados
SELECT
    pedido_id,
    data_pedido,
    data_pedido + INTERVAL '7 days' AS prazo_maximo,
    CURRENT_DATE - (data_pedido + INTERVAL '7 days')::DATE AS dias_atraso
FROM pedidos
WHERE status NOT IN ('entregue', 'cancelado')
  AND (data_pedido + INTERVAL '7 days')::DATE < CURRENT_DATE;


-- =================================================================
-- AULA 28 - TO_CHAR - Formatando Datas
-- =================================================================

-- Aula 28 - Desafio 1: Formatar data_pedido como "DD/MM/YYYY"
-- Exiba pedido_id e a data formatada
SELECT
    pedido_id,
    data_pedido,
    TO_CHAR(data_pedido, 'DD/MM/YYYY') AS data_formatada
FROM pedidos;


-- Aula 28 - Desafio 2: Mostrar mes por extenso dos pedidos
-- Exiba pedido_id, data_pedido e o nome do mes
SELECT
    pedido_id,
    data_pedido,
    TO_CHAR(data_pedido, 'TMMonth') AS nome_mes
FROM pedidos;