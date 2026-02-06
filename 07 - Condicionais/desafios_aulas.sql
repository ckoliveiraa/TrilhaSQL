-- Aula 31 - Desafio 1: Classificar produtos como "Barato" (< R$250), "Medio" (R$250-1000) ou "Caro" (> R$1000)
SELECT nome, preco, CASE
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
SELECT nome, data_nascimento, EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) AS idade_calculada, CASE
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) < 30 THEN 'Jovem'
WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) BETWEEN 30 AND 50 THEN 'Adulto'
ELSE 'Senior'
    END AS faixa_etaria
FROM clientes;
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
SELECT produto_id, nome, preco, estoque, CASE
        WHEN estoque >= 100
AND preco >= 2000
        THEN 'Liquidação'
ELSE 'Reposição'
    END AS status_produto
FROM produtos;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
SELECT pedido_id, cliente_id, status, data_entrega_prevista, data_entrega_realizada, CASE
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
