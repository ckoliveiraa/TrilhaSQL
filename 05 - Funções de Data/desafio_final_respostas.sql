-- ============================================
-- MÓDULO 5 - FUNÇÕES DE DATA
-- Respostas do Desafio Final
-- ============================================

-- Desafio Final 1: Relatório de Pedidos com Datas Formatadas
-- Crie um relatório que mostre:
-- - pedido_id
-- - data_pedido formatada como "DD/MM/YYYY"
-- - dia da semana do pedido (nome)
-- - mês do pedido por extenso

SELECT
    pedido_id,
    TO_CHAR(data_pedido, 'DD/MM/YYYY') AS data_formatada,
    TO_CHAR(data_pedido, 'Day') AS dia_semana_nome,
    TO_CHAR(data_pedido, 'Month') AS mes_extenso
FROM pedidos;


-- Desafio Final 2: Análise de Tempo de Entrega
-- Para pedidos com data_entrega preenchida, mostre:
-- - pedido_id
-- - data_pedido
-- - data_entrega
-- - dias para entrega

SELECT
    pedido_id,
    data_pedido,
    data_entrega,
    data_entrega - data_pedido AS dias_para_entrega
FROM pedidos
WHERE data_entrega IS NOT NULL;


-- Desafio Final 3: Extraindo Partes das Datas
-- Mostre os pedidos com:
-- - pedido_id
-- - ano do pedido
-- - mês do pedido (número)
-- - dia do pedido
-- Ordene por data_pedido

SELECT
    pedido_id,
    EXTRACT(YEAR FROM data_pedido) AS ano,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    EXTRACT(DAY FROM data_pedido) AS dia
FROM pedidos
ORDER BY data_pedido;


-- Desafio Final 4: Clientes e Idades
-- Crie um relatório de clientes com:
-- - nome
-- - data_nascimento formatada
-- - idade em anos

SELECT
    nome,
    TO_CHAR(data_nascimento, 'DD/MM/YYYY') AS data_nascimento_formatada,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) AS idade
FROM clientes;


-- Desafio Final 5 (Boss Final!): Relatório Completo de Pedidos
-- Crie um relatório detalhado que mostre:
-- - pedido_id
-- - data_pedido formatada como "Dia da semana, DD de Mês de YYYY"
-- - há quantos dias o pedido foi realizado
-- - data_entrega formatada (se existir)

SELECT
    pedido_id,
    TO_CHAR(data_pedido, 'Day, DD "de" Month "de" YYYY') AS data_completa,
    CURRENT_DATE - data_pedido AS dias_desde_pedido,
    TO_CHAR(data_entrega, 'DD/MM/YYYY') AS data_entrega_formatada
FROM pedidos;
