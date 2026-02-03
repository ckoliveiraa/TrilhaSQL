-- =================================================================
-- MODULO 05 - CONVERSAO DE DADOS - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 29 - CAST - Convertendo Tipos de Dados
-- =================================================================

-- Aula 29 - Desafio 1: Converter preco para inteiro (sem centavos)
-- Exiba nome, preco original e preco convertido para inteiro
SELECT
    nome,
    preco,
    CAST(preco AS INTEGER) AS preco_inteiro,
    CAST(ROUND(preco) AS INTEGER) AS preco_arredondado
FROM produtos;


-- Aula 29 - Desafio 2: Converter data_pedido para texto
-- Exiba pedido_id e data_pedido como texto
SELECT
    pedido_id,
    data_pedido,
    CAST(data_pedido AS VARCHAR) AS data_como_texto
FROM pedidos;


-- =================================================================
-- AULA 30 - COALESCE - Tratando Valores Nulos
-- =================================================================

-- Aula 30 - Desafio 1: Substituir telefones nulos por "Nao informado"
-- Exiba nome e telefone de todos os clientes
SELECT
    nome,
    COALESCE(telefone, 'Nao informado') AS telefone
FROM clientes;


-- Aula 30 - Desafio 2: Substituir descontos nulos por 0
-- Exiba pedido_id, valor_total, desconto (tratado) e valor final
SELECT
    pedido_id,
    valor_total,
    COALESCE(desconto, 0) AS desconto,
    valor_total - COALESCE(desconto, 0) AS valor_final
FROM pedidos;


-- =================================================================
-- DESAFIOS FINAIS DO MODULO 05
-- =================================================================

-- Desafio Final 1: Ficha de Clientes Completa
-- Crie um relatorio com:
-- - cliente_id convertido para texto com prefixo "CLI-"
-- - nome
-- - telefone (ou "Nao informado" se nulo)
-- - email (ou "Nao informado" se nulo)
SELECT
    'CLI-' || CAST(cliente_id AS VARCHAR) AS codigo_cliente,
    nome,
    COALESCE(telefone, 'Nao informado') AS telefone,
    COALESCE(email, 'Nao informado') AS email
FROM clientes;


-- Desafio Final 2: Relatorio de Produtos com Precos
-- Mostre:
-- - nome do produto
-- - preco original
-- - preco como inteiro (sem centavos)
-- - "R$ " concatenado com o preco (como texto)
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
-- Crie um relatorio que mostre para cada pedido:
-- - "Pedido #" + pedido_id (como texto)
-- - Data formatada como texto
-- - cliente_id como texto
-- - Valor total formatado como "R$ X.XX"
-- - Frete tratado (0 se nulo)
-- - Status do pedido (ou "Indefinido" se nulo)
SELECT
    'Pedido #' || CAST(pedido_id AS VARCHAR) AS codigo_pedido,
    CAST(data_pedido AS VARCHAR) AS data_texto,
    'Cliente #' || CAST(cliente_id AS VARCHAR) AS cliente,
    'R$ ' || CAST(valor_total AS VARCHAR) AS valor_formatado,
    COALESCE(frete, 0) AS frete,
    COALESCE(status, 'Indefinido') AS status
FROM pedidos;
