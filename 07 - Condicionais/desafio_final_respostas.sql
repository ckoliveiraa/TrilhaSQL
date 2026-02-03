-- ============================================
-- MÓDULO 6 - CONDICIONAIS
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


-- Desafio 2: Para cada categoria, mostre:
-- - Total de produtos
-- - Quantidade de produtos "caros" (> R$500)
-- - Quantidade de produtos com estoque crítico (< 10)
-- - Percentual de produtos caros

SELECT
    c.nome AS categoria,
    COUNT(*) AS total_produtos,
    COUNT(CASE WHEN p.preco > 500 THEN 1 END) AS produtos_caros,
    COUNT(CASE WHEN p.estoque < 10 THEN 1 END) AS estoque_critico,
    ROUND(
        100.0 * COUNT(CASE WHEN p.preco > 500 THEN 1 END) / COUNT(*),
        2
    ) AS percentual_caros
FROM categorias c
INNER JOIN produtos p ON c.categoria_id = p.categoria_id
GROUP BY c.categoria_id, c.nome;


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


-- Desafio 4: Crie um relatório de pedidos mostrando:
-- - Status traduzido para português
-- - Classificação do valor: "Pequeno" (< R$200), "Médio" (R$200-500), "Grande" (> R$500)
-- - Se teve frete grátis ou não

SELECT
    pedido_id,
    data_pedido,
    status,
    CASE status
        WHEN 'pending' THEN 'Pendente'
        WHEN 'pendente' THEN 'Pendente'
        WHEN 'processing' THEN 'Processando'
        WHEN 'processando' THEN 'Processando'
        WHEN 'shipped' THEN 'Enviado'
        WHEN 'enviado' THEN 'Enviado'
        WHEN 'delivered' THEN 'Entregue'
        WHEN 'entregue' THEN 'Entregue'
        WHEN 'cancelled' THEN 'Cancelado'
        WHEN 'cancelado' THEN 'Cancelado'
        ELSE 'Status Desconhecido'
    END AS status_portugues,
    valor_total,
    CASE
        WHEN valor_total < 200 THEN 'Pequeno'
        WHEN valor_total <= 500 THEN 'Médio'
        ELSE 'Grande'
    END AS classificacao_valor,
    CASE
        WHEN COALESCE(frete, 0) = 0 THEN 'Frete Grátis'
        ELSE 'Com Frete'
    END AS tipo_frete
FROM pedidos;


-- Desafio 5 (Boss Final!): Crie um dashboard de vendas que mostre por mês:
-- - Total de pedidos
-- - Pedidos entregues
-- - Pedidos cancelados
-- - Taxa de sucesso (% entregues)
-- - Classificação do mês: "Ruim" (< 70% sucesso), "Bom" (70-90%), "Excelente" (> 90%)

SELECT
    EXTRACT(YEAR FROM data_pedido) AS ano,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    COUNT(*) AS total_pedidos,
    SUM(CASE WHEN status = 'entregue' THEN 1 ELSE 0 END) AS pedidos_entregues,
    SUM(CASE WHEN status = 'cancelado' THEN 1 ELSE 0 END) AS pedidos_cancelados,
    ROUND(
        100.0 * SUM(CASE WHEN status = 'entregue' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS taxa_sucesso,
    CASE
        WHEN 100.0 * SUM(CASE WHEN status = 'entregue' THEN 1 ELSE 0 END) / COUNT(*) < 70 THEN 'Ruim'
        WHEN 100.0 * SUM(CASE WHEN status = 'entregue' THEN 1 ELSE 0 END) / COUNT(*) <= 90 THEN 'Bom'
        ELSE 'Excelente'
    END AS classificacao_mes
FROM pedidos
GROUP BY
    EXTRACT(YEAR FROM data_pedido),
    EXTRACT(MONTH FROM data_pedido)
ORDER BY ano, mes;
