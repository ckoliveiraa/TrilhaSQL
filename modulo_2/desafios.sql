-- Aula 1 - Desafio 1: Visualizar todos os dados da tabela produtos
SELECT * FROM produtos

-- Aula 1 - Desafio 2: Visualizar todos os dados da tabela clientes
SELECT * FROM clientes

-- Aula 2 - Desafio 1: Mostrar apenas nome e preço dos produtos
SELECT nome, preco FROM produtos

-- Aula 2 - Desafio 2: Mostrar apenas nome, email e cidade dos clientes
SELECT nome, email, cidade FROM clientes

-- Aula 3 - Desafio 1: Renomear colunas para nomes mais amigáveis
-- Selecione nome, preco e estoque com aliases "Nome do Produto", "Preço (R$)" e "Quantidade em Estoque"
SELECT nome AS "Nome do Produto", preco AS "Preço (R$)", estoque AS "Quantidade em Estoque"
FROM produtos

-- Aula 3 - Desafio 2: Criar um relatório de pedidos
-- Selecione data_pedido, valor_total e status com aliases "Data da Compra", "Valor Total (R$)" e "Status do Pedido"
SELECT data_pedido AS "Data da Compra", valor_total AS "Valor Total (R$)", status AS "Status do Pedido"
FROM pedidos

-- Aula 4 - Desafio 1: Listar todas as cidades únicas dos clientes
SELECT DISTINCT cidade FROM clientes

-- Aula 4 - Desafio 2: Listar todas as marcas únicas de produtos
SELECT DISTINCT marca FROM produtos

-- Aula 5 - Desafio 1: Mostrar uma amostra de 5 produtos (todas as colunas)
SELECT * FROM produtos LIMIT 5

-- Aula 5 - Desafio 2: Mostrar apenas 3 clientes, exibindo nome e email
SELECT nome, email FROM clientes LIMIT 3