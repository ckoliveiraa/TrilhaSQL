-- ============================================
-- MÓDULO 6 - CONVERSÃO DE DADOS
-- Respostas do Desafio Final
-- ============================================

-- Desafio Final 1: Ficha de Clientes Completa
-- Crie um relatório com:
-- - cliente_id convertido para texto com prefixo "CLI-"
-- - nome
-- - telefone (ou "Não informado" se nulo)
-- - email (ou "Não informado" se nulo)

SELECT
    'CLI-' || CAST(cliente_id AS VARCHAR) AS codigo_cliente,
    nome,
    COALESCE(telefone, 'Não informado') AS telefone,
    COALESCE(email, 'Não informado') AS email
FROM clientes;


-- Desafio Final 2: Relatório de Produtos com Preços
-- Mostre:
-- - nome do produto
-- - preco original
-- - preco como inteiro (sem centavos)
-- - "R$ " concatenado com o preço (como texto)

SELECT
    nome,
    preco AS preco_original,
    CAST(preco AS INTEGER) AS preco_inteiro,
    'R$ ' || CAST(preco AS VARCHAR) AS preco_formatado
FROM produtos;


-- Desafio Final 3: Pedidos com Valor Final
-- Calcule o valor final dos pedidos considerando:
-- - valor_total
-- - frete (pode ser NULL, tratar como 0)
-- - desconto (pode ser NULL, tratar como 0)
-- - valor_final = valor_total + frete - desconto

SELECT
    pedido_id,
    valor_total,
    COALESCE(frete, 0) AS frete,
    COALESCE(desconto, 0) AS desconto,
    valor_total + COALESCE(frete, 0) - COALESCE(desconto, 0) AS valor_final
FROM pedidos;

