-- ============================================
-- MÓDULO 5 - CONVERSÃO DE DADOS
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


-- Desafio Final 4 (Boss Final!): Dashboard de Vendas
-- Crie um relatório que mostre para cada pedido:
-- - "Pedido #" + pedido_id (como texto)
-- - Data formatada como texto
-- - Nome do cliente (ou "Cliente não identificado" se não encontrar)
-- - Valor total formatado como "R$ X.XX"
-- - Frete tratado (0 se nulo)
-- - Status do pedido (ou "Indefinido" se nulo)

SELECT
    'Pedido #' || CAST(p.pedido_id AS VARCHAR) AS identificador,
    CAST(p.data_pedido AS VARCHAR) AS data_texto,
    COALESCE(c.nome, 'Cliente não identificado') AS cliente,
    'R$ ' || CAST(ROUND(p.valor_total, 2) AS VARCHAR) AS valor_formatado,
    COALESCE(p.frete, 0) AS frete,
    COALESCE(p.status, 'Indefinido') AS status
FROM pedidos p
LEFT JOIN clientes c ON p.cliente_id = c.cliente_id;
