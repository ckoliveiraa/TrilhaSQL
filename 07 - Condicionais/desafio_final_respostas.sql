-- ============================================
-- MÓDULO 7 - CONDICIONAIS
-- Respostas do Desafio Final
-- ============================================

-- Desafio 1: Crie um relatório de produtos com as seguintes classificações:
-- - Preço: "Econômico" (< R$100), "Padrão" (R$100-500), "Premium" (> R$500)
-- - Estoque: "Crítico" (< 10), "Baixo" (10-29), "Normal" (30-99), "Alto" (>= 100)

SELECT
    nome,
    preco,
    estoque,
    CASE
        WHEN preco < 100 THEN 'Econômico'
        WHEN preco <= 500 THEN 'Padrão'
        ELSE 'Premium'
    END AS classificacao_preco,
    CASE
        WHEN estoque < 10 THEN 'Crítico'
        WHEN estoque < 30 THEN 'Baixo'
        WHEN estoque < 100 THEN 'Normal'
        ELSE 'Alto'
    END AS classificacao_estoque
FROM produtos;


-- Desafio 2: Crie um relatório de produtos com classificação combinada:
-- - Se o produto é de "Alta Prioridade" (preço > R$300 E estoque < 20)
-- - Se é "Promoção Possível" (preço > R$200 E estoque > 50)
-- - Se está em categoria específica (categoria_id IN (1, 2, 3))
-- - Adicione uma observação combinando essas condições

SELECT
    produto_id,
    nome,
    preco,
    estoque,
    categoria_id,
    CASE
        WHEN preco > 300 AND estoque < 20 THEN 'Alta Prioridade'
        WHEN preco > 200 AND estoque > 50 THEN 'Promoção Possível'
        WHEN preco < 100 AND estoque < 10 THEN 'Atenção: Baixo Valor e Estoque'
        ELSE 'Normal'
    END AS status_produto,
    CASE
        WHEN categoria_id IN (1, 2, 3) THEN 'Categoria Principal'
        WHEN categoria_id IN (4, 5) THEN 'Categoria Secundária'
        ELSE 'Outras Categorias'
    END AS grupo_categoria,
    CASE
        WHEN (preco > 300 AND estoque < 20) OR (preco < 100 AND estoque < 10) THEN 'REQUER ATENÇÃO'
        WHEN preco > 200 AND estoque > 50 THEN 'OPORTUNIDADE DE VENDA'
        ELSE 'SITUAÇÃO NORMAL'
    END AS observacao
FROM produtos;


-- Desafio 3: Classifique os clientes em:
-- - "Novo" - cadastrado há menos de 6 meses
-- - "Regular" - cadastrado entre 6 meses e 2 anos
-- - "Veterano" - cadastrado há mais de 2 anos

SELECT
    nome,
    data_cadastro,
    CASE
        WHEN data_cadastro > CURRENT_DATE - INTERVAL '6 months' THEN 'Novo'
        WHEN data_cadastro > CURRENT_DATE - INTERVAL '2 years' THEN 'Regular'
        ELSE 'Veterano'
    END AS classificacao_cliente
FROM clientes;


-- Desafio 4: Crie um relatório de análise de custos e descontos dos pedidos.
-- Classifique cada pedido considerando:
--
-- A) Classificação de Frete (campo 'frete'):
--    - "Frete Grátis" = 0
--    - "Frete Econômico" = R$ 0.01 até R$ 10.00
--    - "Frete Padrão" = R$ 10.01 até R$ 25.00
--    - "Frete Premium" = R$ 25.01 até R$ 49.96
--    - "Frete Especial" = acima de R$ 49.96
--
-- B) Classificação de Desconto (campo 'desconto'):
--    - "Sem Desconto" = 0
--    - "Desconto Básico" = R$ 0.24 até R$ 20.00
--    - "Desconto Bom" = R$ 20.01 até R$ 50.00
--    - "Desconto Excelente" = R$ 50.01 até R$ 99.85
--    - "Desconto Excepcional" = acima de R$ 99.85
--
-- Use CASE WHEN com BETWEEN para criar as classificações.

SELECT
    pedido_id,
    data_pedido,
    valor_total,
    frete,
    desconto,
    CASE
        WHEN frete = 0 THEN 'Frete Grátis'
        WHEN frete BETWEEN 0.01 AND 10 THEN 'Frete Econômico'
        WHEN frete BETWEEN 10.01 AND 25 THEN 'Frete Padrão'
        WHEN frete BETWEEN 25.01 AND 49.96 THEN 'Frete Premium'
        WHEN frete > 49.96 THEN 'Frete Especial'
        ELSE 'Sem Frete'
    END AS classificacao_frete,
    CASE
        WHEN desconto = 0 THEN 'Sem Desconto'
        WHEN desconto BETWEEN 0.24 AND 20 THEN 'Desconto Básico'
        WHEN desconto BETWEEN 20.01 AND 50 THEN 'Desconto Bom'
        WHEN desconto BETWEEN 50.01 AND 99.85 THEN 'Desconto Excelente'
        WHEN desconto > 99.85 THEN 'Desconto Excepcional'
        ELSE 'Sem Desconto'
    END AS classificacao_desconto
FROM pedidos;


-- Desafio 5 (Boss Final!): Crie um relatório de análise temporal de pedidos.
-- Combine múltiplos conceitos aprendidos no módulo:
--
-- A) Extraia informações da data usando EXTRACT:
--    - Ano, mês e dia da semana
--
-- B) Classifique o semestre:
--    - "1º Semestre" = meses 1 a 6
--    - "2º Semestre" = meses 7 a 12
--
-- C) Identifique o tipo de dia:
--    - "Final de Semana" = sábado (6) ou domingo (0)
--    - "Dia de Semana" = segunda a sexta
--
-- D) Crie uma análise de prioridade combinando valor e status:
--    Status disponíveis: cancelado, confirmado, em_separacao, entregue, enviado, pendente
--    - "CRÍTICO" = cancelado E valor > 500
--    - "ATENÇÃO" = pendente E valor > 300
--    - "SUCESSO" = entregue E valor > 400
--    - "NORMAL" = demais casos
--
-- Use EXTRACT, CASE WHEN, IN, AND/OR para resolver.

SELECT
    pedido_id,
    data_pedido,
    status,
    valor_total,
    EXTRACT(YEAR FROM data_pedido) AS ano,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    EXTRACT(DOW FROM data_pedido) AS dia_semana,
    CASE
        WHEN EXTRACT(MONTH FROM data_pedido) BETWEEN 1 AND 6 THEN '1º Semestre'
        ELSE '2º Semestre'
    END AS semestre,
    CASE
        WHEN EXTRACT(DOW FROM data_pedido) IN (0, 6) THEN 'Final de Semana'
        ELSE 'Dia de Semana'
    END AS tipo_dia,
    CASE
        WHEN status = 'cancelado' AND valor_total > 500 THEN 'CRÍTICO'
        WHEN status = 'pendente' AND valor_total > 300 THEN 'ATENÇÃO'
        WHEN status = 'entregue' AND valor_total > 400 THEN 'SUCESSO'
        ELSE 'NORMAL'
    END AS prioridade
FROM pedidos
ORDER BY
    valor_total DESC;
