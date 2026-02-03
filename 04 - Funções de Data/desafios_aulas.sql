-- =================================================================
-- MODULO 04 - FUNCOES DE DATA - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 24 - CURRENT_DATE - Data Atual
-- =================================================================

-- Aula 24 - Desafio 1: Calcular quantos dias se passaram desde o primeiro pedido
-- Dica: Use MIN(data_pedido) e CURRENT_DATE
SELECT
    MIN(data_pedido) AS primeiro_pedido,
    CURRENT_DATE AS data_atual,
    CURRENT_DATE - MIN(data_pedido) AS dias_desde_primeiro_pedido
FROM pedidos;


-- Aula 24 - Desafio 2: Mostrar idade aproximada dos clientes
-- Exiba o nome e data atual (tabela nao possui data_nascimento)
SELECT
    nome,
    CURRENT_DATE AS data_atual
FROM clientes;


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
FROM pedidos
ORDER BY data_pedido;


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


-- =================================================================
-- DESAFIOS FINAIS DO MODULO 04
-- =================================================================

-- Desafio Final 1: Relatorio de Pedidos com Datas Formatadas
-- Crie um relatorio que mostre:
-- - pedido_id
-- - data_pedido formatada como "DD/MM/YYYY"
-- - dia da semana do pedido (numero: 0=Dom, 6=Sab)
-- - mes do pedido (numero)
SELECT
    pedido_id,
    TO_CHAR(data_pedido, 'DD/MM/YYYY') AS data_formatada,
    EXTRACT(DOW FROM data_pedido) AS dia_semana,
    EXTRACT(MONTH FROM data_pedido) AS mes
FROM pedidos;


-- Desafio Final 2: Analise de Tempo de Entrega
-- Para pedidos entregues, mostre:
-- - pedido_id
-- - data_pedido
-- - status
-- - prazo estimado de 7 dias
SELECT
    pedido_id,
    data_pedido,
    status,
    data_pedido + INTERVAL '7 days' AS prazo_entrega
FROM pedidos
WHERE status = 'entregue';


-- Desafio Final 3: Pedidos Recentes
-- Mostre os pedidos dos ultimos 30 dias:
-- - pedido_id
-- - data_pedido formatada como "DD/MM/YYYY"
-- - data_pedido formatada como "Dia da semana, DD de Mes"
SELECT
    pedido_id,
    TO_CHAR(data_pedido, 'DD/MM/YYYY') AS data_formatada,
    TO_CHAR(data_pedido, 'TMDay", "DD" de "TMMonth') AS data_extenso
FROM pedidos
WHERE data_pedido >= CURRENT_DATE - INTERVAL '30 days';


-- Desafio Final 4: Clientes e Datas
-- Crie um relatorio de clientes com:
-- - nome
-- - cidade, estado
-- - data atual
SELECT
    nome,
    cidade,
    estado,
    TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY') AS data_atual
FROM clientes
ORDER BY nome;


-- Desafio Final 5 (Boss Final!): Analise de Prazos
-- Para cada pedido, mostre:
-- - pedido_id
-- - data_pedido e status
-- - prazo estimado (data_pedido + 7 dias)
-- - dias ate o prazo (a partir da data atual)
SELECT
    pedido_id,
    TO_CHAR(data_pedido, 'DD/MM/YYYY') AS data_pedido_fmt,
    status,
    TO_CHAR(data_pedido + INTERVAL '7 days', 'DD/MM/YYYY') AS prazo_estimado,
    (data_pedido + INTERVAL '7 days')::DATE - CURRENT_DATE AS dias_ate_prazo
FROM pedidos
ORDER BY data_pedido DESC;
