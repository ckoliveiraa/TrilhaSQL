-- Aula 1 - Desafio 1: Visualizar todos os dados da tabela produtos
SELECT *
FROM produtos
-- Aula 1 - Desafio 2: Visualizar todos os dados da tabela clientes
SELECT *
FROM clientes
-- Aula 2 - Desafio 1: Mostrar apenas nome e preço dos produtos
SELECT nome, preco
FROM produtos
-- Aula 2 - Desafio 2: Mostrar apenas nome, email e cidade dos clientes
SELECT nome, email, cidade
FROM clientes
-- Aula 3 - Desafio 1: Renomear colunas para nomes mais amigáveis
-- Selecione nome, preco e estoque com aliases "Nome do Produto", "Preço (R$)" e "Quantidade em Estoque"
SELECT nome AS "Nome do Produto", preco AS "Preço (R$)", estoque AS "Quantidade em Estoque"
FROM produtos
-- Aula 3 - Desafio 2: Criar um relatório de pedidos
-- Selecione data_pedido, valor_total e status com aliases "Data da Compra", "Valor Total (R$)" e "Status do Pedido"
SELECT data_pedido AS "Data da Compra", valor_total AS "Valor Total (R$)", status AS "Status do Pedido"
FROM pedidos
-- Aula 4 - Desafio 1: Listar todas as cidades únicas dos clientes
SELECT DISTINCT cidade
FROM clientes
-- Aula 4 - Desafio 2: Listar todas as marcas únicas de produtos
SELECT DISTINCT marca
FROM produtos
-- Aula 5 - Desafio 1: Mostrar uma amostra de 5 produtos (todas as colunas)
SELECT *
FROM produtos
LIMIT 5
-- Aula 5 - Desafio 2: Mostrar apenas 3 clientes, exibindo nome e email
SELECT nome, email
FROM clientes
LIMIT 3
-- Aula 6 - Desafio 1: Listar produtos ordenados por preço do mais barato ao mais caro
SELECT *
FROM produtos
ORDER BY preco ASC
-- Aula 6 - Desafio 2: Listar os 10 últimos pagamentos
SELECT *
FROM pagamentos
ORDER BY data_pagamento DESC
LIMIT 10
-- Aula 7 - Desafio 1: Mostrar apenas pedidos em separação
SELECT *
FROM pedidos
WHERE status = 'em_separacao'
-- Aula 7 - Desafio 2: Mostrar as últimas 5 avaliações nota 1
SELECT *
FROM avaliacoes
WHERE nota = 1
ORDER BY data_avaliacao DESC
LIMIT 5
-- Aula 8 - Desafio 1: Produtos com preço maior que R$ 500
SELECT *
FROM produtos
WHERE preco > 500
-- Aula 8 - Desafio 2: Produtos com estoque menor que 20 unidades
SELECT *
FROM produtos
WHERE estoque < 20
-- Aula 9 - Desafio 1: Pedidos com status diferente de "Entregue"
SELECT *
FROM pedidos
WHERE status <> 'entregue'
-- Aula 9 - Desafio 2: Listar as avaliações sem comentários
SELECT *
FROM avaliacoes
WHERE comentario IS NULL
--Pedidos entregues que possuem data de entrega registrada (status = 'entregue' E data_entrega_realizada IS NOT NULL)
SELECT *
FROM pedidos
WHERE status = 'entregue'
AND data_entrega_realizada IS NULL
-- Aula 10 - Desafio 1: Produtos da marca "Samsung" com preço maior que R$ 1000
SELECT *
FROM produtos
WHERE marca = 'Samsung'
AND preco > 1000
-- Aula 10 - Desafio 2: Pedidos entregues que possuem data de entrega registrada
SELECT *
FROM pedidos
WHERE status = 'entregue'
AND data_entrega_realizada IS NOT NULL
-- Aula 11 - Desafio 1: Produtos premium de marcas específicas
-- Encontre produtos que sejam: marca "Samsung" OU marca "Sony" E preço maior que 2000
-- Traga somente as colunas necessárias
SELECT nome, marca, preco
FROM produtos
WHERE(marca = 'Samsung'
	OR marca = 'Sony')
AND preco > 2000
-- Aula 11 - Desafio 2: Pagamentos problemáticos
-- Encontre pagamentos que sejam  Pix ou boleto e não tenham sido aprovados
-- Traga somente as colunas necessárias
SELECT pagamento_id, metodo, status
FROM pagamentos
WHERE(metodo = 'pix'
OR metodo = 'boleto')
AND status <> 'aprovado'


