-- =================================================================
-- MODULO 06 - CONDICIONAIS - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 31 - CASE WHEN - Condicionais Simples
-- =================================================================

-- Aula 31 - Desafio 1: Classificar produtos como "Barato" (< R$250), "Medio" (R$250-1000) ou "Caro" (> R$1000)
SELECT
    nome,
    preco,
    CASE
        WHEN preco < 250 THEN ('Barato')
        WHEN preco <= 1000 THEN ('Medio')
        ELSE ('Caro')
    END AS classificacao
FROM produtos;


-- Aula 31 - Desafio 2: Classificação de clientes por faixa etária
-- Utilize a data de nascimento para calcular a idade dos clientes
-- e classifique cada um em uma faixa etária, conforme as regras abaixo:
--
-- Jovem   → idade menor que 30 anos
-- Adulto  → idade entre 30 e 50 anos
-- Senior  → idade maior que 50 anos
--
-- Exiba: nome, data_nascimento, idade calculada e faixa_etaria.
SELECT
    nome,
    data_nascimento,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) AS idade,
    CASE
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) < 30 THEN 'Jovem'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) BETWEEN 30 AND 50 THEN 'Adulto'
        ELSE 'Senior'
    END AS faixa_etaria
FROM clientes;


-- =================================================================
-- AULA 32 - CASE WHEN com Multiplas Condicoes
-- =================================================================

-- Aula 32 - Desafio 1: Definir status de produtos (Liquidação ou Reposição)
--
-- Neste desafio, você deve analisar os produtos com base
-- no preço e na quantidade em estoque.
--
-- Regras:
-- 1. Se o estoque for alto E o preço for alto,
--    o produto deve receber o status "Liquidação".
-- 2. Caso contrário, o produto deve receber o status "Reposição".
--
-- Considere:
-- estoque alto → estoque >= 100
-- preço alto   → preco >= 2000
--
-- Utilize a estrutura CASE para criar a coluna status_produto.
-- Exiba: produto_id, nome, preco, estoque e status_produto.

SELECT
    produto_id,
    nome,
    preco,
    estoque,
    CASE
        WHEN estoque >= 100
             AND preco >= 2000
        THEN 'Liquidação'
        ELSE 'Reposição'
    END AS status_produto
FROM produtos;



-- Aula 32 - Desafio 2: Verificando o status de entrega dos pedidos
--
-- Neste desafio, você deve analisar os pedidos e identificar
-- se eles foram entregues, não entregues ou cancelados.
--
-- Regras:
-- 1. Se o status do pedido for 'cancelado', o resultado deve ser "Cancelado".
-- 2. Se o status estiver em ('em_separacao', 'pendente', 'confirmado', 'enviado')
--    E a coluna data_entrega_realizada for NULL, o pedido deve ser classificado como "Não entregue".
-- 3. Se o status for 'entregue' OU a data_entrega_realizada não for NULL,
--    o pedido deve ser classificado como "Entregue".
--
-- Utilize a estrutura CASE para criar a coluna status_entrega.
-- Exiba: pedido_id, status, data_entrega_prevista, data_entrega_realizada e status_entrega.

SELECT
    pedido_id,
    cliente_id,
    status,
    data_entrega_prevista,
    data_entrega_realizada,
    CASE
        WHEN status = 'cancelado'
        THEN 'Cancelado'

        WHEN status IN ('em_separacao', 'pendente', 'confirmado', 'enviado')
             AND data_entrega_realizada IS NULL
        THEN 'Não entregue'

        WHEN status = 'entregue'
             OR data_entrega_realizada IS NOT NULL
        THEN 'Entregue'

        ELSE 'Status indefinido'
    END AS status_entrega
FROM pedidos;



-- =================================================================
-- DESAFIOS FINAIS DO MODULO 06
-- =================================================================

-- Desafio Final 1: Relatorio de Produtos com Classificacoes
-- Preco: "Economico" (< R$100), "Padrao" (R$100-500), "Premium" (> R$500)
-- Estoque: "Critico" (< 10), "Baixo" (10-29), "Normal" (30-99), "Alto" (>= 100)
SELECT
    nome,
    preco,
    estoque,
    CASE
        WHEN preco < 100 THEN 'Economico'
        WHEN preco <= 500 THEN 'Padrao'
        ELSE 'Premium'
    END AS faixa_preco,
    CASE
        WHEN estoque < 10 THEN 'Critico'
        WHEN estoque < 30 THEN 'Baixo'
        WHEN estoque < 100 THEN 'Normal'
        ELSE 'Alto'
    END AS situacao_estoque
FROM produtos;


-- Desafio Final 2: Prioridade de Reposicao
-- "URGENTE" - estoque = 0 E preco > 500
-- "ALTA" - estoque < 5
-- "MEDIA" - estoque < 20
-- "BAIXA" - estoque >= 20
SELECT
    nome,
    preco,
    estoque,
    CASE
        WHEN estoque = 0 AND preco > 500 THEN 'URGENTE'
        WHEN estoque < 5 THEN 'ALTA'
        WHEN estoque < 20 THEN 'MEDIA'
        ELSE 'BAIXA'
    END AS prioridade_reposicao
FROM produtos
ORDER BY
    CASE
        WHEN estoque = 0 AND preco > 500 THEN 1
        WHEN estoque < 5 THEN 2
        WHEN estoque < 20 THEN 3
        ELSE 4
    END;


-- Desafio Final 3: Classificar pedidos por antiguidade
-- "Novo" - ultimos 30 dias
-- "Regular" - 30 dias a 6 meses
-- "Antigo" - mais de 6 meses
SELECT
    pedido_id,
    data_pedido,
    CASE
        WHEN data_pedido >= CURRENT_DATE - INTERVAL '30 days' THEN 'Novo'
        WHEN data_pedido >= CURRENT_DATE - INTERVAL '6 months' THEN 'Regular'
        ELSE 'Antigo'
    END AS classificacao_tempo
FROM pedidos;


-- Desafio Final 4: Relatorio de Pedidos
-- Status traduzido para portugues
-- Classificacao do valor: "Pequeno" (< R$200), "Medio" (R$200-500), "Grande" (> R$500)
-- Se teve frete gratis ou nao
SELECT
    pedido_id,
    status,
    CASE status
        WHEN 'pendente' THEN 'Pendente'
        WHEN 'confirmado' THEN 'Confirmado'
        WHEN 'processando' THEN 'Processando'
        WHEN 'enviado' THEN 'Enviado'
        WHEN 'entregue' THEN 'Entregue'
        WHEN 'cancelado' THEN 'Cancelado'
        ELSE 'Desconhecido'
    END AS status_pt,
    valor_total,
    CASE
        WHEN valor_total < 200 THEN 'Pequeno'
        WHEN valor_total <= 500 THEN 'Medio'
        ELSE 'Grande'
    END AS tamanho_pedido,
    COALESCE(frete, 0) AS frete,
    CASE
        WHEN frete = 0 OR frete IS NULL THEN 'Sim'
        ELSE 'Nao'
    END AS frete_gratis
FROM pedidos;


-- Desafio Final 5 (Boss Final!): Relatorio Completo de Pedidos
-- pedido_id, valor_total, status traduzido
-- Classificacao do valor: "Pequeno" (< R$200), "Medio" (R$200-1000), "Grande" (> R$1000)
-- Tipo de frete: "Gratis" (frete = 0), "Economico" (< R$30), "Normal" (>= R$30)
-- Indicador de desconto: "Com desconto" (desconto > 0), "Sem desconto"
-- Ordene por valor_total decrescente
SELECT
    pedido_id,
    valor_total,
    CASE status
        WHEN 'pendente' THEN 'Aguardando Processamento'
        WHEN 'confirmado' THEN 'Confirmado'
        WHEN 'processando' THEN 'Em Preparacao'
        WHEN 'enviado' THEN 'A Caminho'
        WHEN 'entregue' THEN 'Entregue com Sucesso'
        WHEN 'cancelado' THEN 'Pedido Cancelado'
        ELSE 'Status Desconhecido'
    END AS status_descritivo,
    CASE
        WHEN valor_total < 200 THEN 'Pequeno'
        WHEN valor_total <= 1000 THEN 'Medio'
        ELSE 'Grande'
    END AS tamanho_pedido,
    CASE
        WHEN frete IS NULL OR frete = 0 THEN 'Gratis'
        WHEN frete < 30 THEN 'Economico'
        ELSE 'Normal'
    END AS tipo_frete,
    CASE
        WHEN desconto IS NOT NULL AND desconto > 0 THEN 'Com desconto'
        ELSE 'Sem desconto'
    END AS indicador_desconto
FROM pedidos
ORDER BY valor_total DESC;
