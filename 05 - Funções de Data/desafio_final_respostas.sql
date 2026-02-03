-- ============================================
-- MÓDULO 4 - FUNÇÕES DE DATA
-- Respostas do Desafio Final
-- ============================================

-- Desafio Final 1: Relatório de Pedidos com Datas Formatadas
-- Crie um relatório que mostre:
-- - pedido_id
-- - data_pedido formatada como "DD/MM/YYYY"
-- - dia da semana do pedido (nome ou número)
-- - mês do pedido por extenso

SELECT
    pedido_id,
    TO_CHAR(data_pedido, 'DD/MM/YYYY') AS data_formatada,
    EXTRACT(DOW FROM data_pedido) AS dia_semana_num,
    CASE EXTRACT(DOW FROM data_pedido)
        WHEN 0 THEN 'Domingo'
        WHEN 1 THEN 'Segunda-feira'
        WHEN 2 THEN 'Terça-feira'
        WHEN 3 THEN 'Quarta-feira'
        WHEN 4 THEN 'Quinta-feira'
        WHEN 5 THEN 'Sexta-feira'
        WHEN 6 THEN 'Sábado'
    END AS dia_semana_nome,
    CASE EXTRACT(MONTH FROM data_pedido)
        WHEN 1 THEN 'Janeiro'
        WHEN 2 THEN 'Fevereiro'
        WHEN 3 THEN 'Março'
        WHEN 4 THEN 'Abril'
        WHEN 5 THEN 'Maio'
        WHEN 6 THEN 'Junho'
        WHEN 7 THEN 'Julho'
        WHEN 8 THEN 'Agosto'
        WHEN 9 THEN 'Setembro'
        WHEN 10 THEN 'Outubro'
        WHEN 11 THEN 'Novembro'
        WHEN 12 THEN 'Dezembro'
    END AS mes_extenso
FROM pedidos;


-- Desafio Final 2: Análise de Tempo de Entrega
-- Para pedidos com data_entrega preenchida, mostre:
-- - pedido_id
-- - data_pedido
-- - data_entrega
-- - dias para entrega
-- - status: "Rápido" (até 3 dias), "Normal" (4-7 dias), "Lento" (mais de 7 dias)

SELECT
    pedido_id,
    data_pedido,
    data_entrega,
    data_entrega - data_pedido AS dias_para_entrega,
    CASE
        WHEN data_entrega - data_pedido <= 3 THEN 'Rápido'
        WHEN data_entrega - data_pedido <= 7 THEN 'Normal'
        ELSE 'Lento'
    END AS status_entrega
FROM pedidos
WHERE data_entrega IS NOT NULL;


-- Desafio Final 3: Pedidos por Período
-- Mostre a quantidade de pedidos por:
-- - Ano
-- - Mês (número)
-- Ordene por ano e mês

SELECT
    EXTRACT(YEAR FROM data_pedido) AS ano,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    COUNT(*) AS total_pedidos
FROM pedidos
GROUP BY
    EXTRACT(YEAR FROM data_pedido),
    EXTRACT(MONTH FROM data_pedido)
ORDER BY ano, mes;


-- Desafio Final 4: Clientes e Idades
-- Crie um relatório de clientes com:
-- - nome
-- - data_nascimento formatada
-- - idade em anos
-- - classificação: "Jovem" (< 30), "Adulto" (30-50), "Sênior" (> 50)

SELECT
    nome,
    TO_CHAR(data_nascimento, 'DD/MM/YYYY') AS data_nascimento_formatada,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) AS idade,
    CASE
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) < 30 THEN 'Jovem'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) <= 50 THEN 'Adulto'
        ELSE 'Sênior'
    END AS classificacao
FROM clientes;


-- Desafio Final 5 (Boss Final!): Dashboard de Vendas Mensal
-- Crie um relatório que agrupe pedidos por mês/ano e mostre:
-- - Mês/Ano formatado (ex: "Janeiro/2024")
-- - Total de pedidos
-- - Valor total vendido
-- - Primeiro pedido do mês
-- - Último pedido do mês

SELECT
    CASE EXTRACT(MONTH FROM data_pedido)
        WHEN 1 THEN 'Janeiro'
        WHEN 2 THEN 'Fevereiro'
        WHEN 3 THEN 'Março'
        WHEN 4 THEN 'Abril'
        WHEN 5 THEN 'Maio'
        WHEN 6 THEN 'Junho'
        WHEN 7 THEN 'Julho'
        WHEN 8 THEN 'Agosto'
        WHEN 9 THEN 'Setembro'
        WHEN 10 THEN 'Outubro'
        WHEN 11 THEN 'Novembro'
        WHEN 12 THEN 'Dezembro'
    END || '/' || EXTRACT(YEAR FROM data_pedido) AS mes_ano,
    COUNT(*) AS total_pedidos,
    SUM(valor_total) AS valor_total_vendido,
    MIN(data_pedido) AS primeiro_pedido,
    MAX(data_pedido) AS ultimo_pedido
FROM pedidos
GROUP BY
    EXTRACT(YEAR FROM data_pedido),
    EXTRACT(MONTH FROM data_pedido)
ORDER BY
    EXTRACT(YEAR FROM data_pedido),
    EXTRACT(MONTH FROM data_pedido);
