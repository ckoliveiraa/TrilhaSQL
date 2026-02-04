-- Aula 24 - Desafio 1: Calcular quantos dias se passaram desde cada pedido
-- Exiba pedido_id, data_pedido, data atual e dias desde o pedido
SELECT pedido_id, data_pedido, CURRENT_DATE AS data_atual, CURRENT_DATE - data_pedido AS dias_desde_pedido
FROM pedidos;
-- Aula 24 - Desafio 2: Mostrar idade aproximada dos clientes
-- Exiba o nome, data de nascimento e idade em anos
SELECT nome, data_nascimento, CURRENT_DATE AS data_atual, AGE(CURRENT_DATE, data_nascimento) AS idade_aproximada
FROM clientes
WHERE data_nascimento IS NOT NULL;
-- Aula 25 - Desafio 1: Extrair o mês de cada pedido
-- Exiba o pedido_id, data_pedido e o mês
SELECT pedido_id, data_pedido, EXTRACT(MONTH FROM data_pedido) AS mes
FROM pedidos;
-- Aula 25 - Desafio 2: Extrair ano, mes e dia de cada pedido
-- Exiba pedido_id, data_pedido, ano, mes e dia separadamente
SELECT pedido_id, data_pedido, EXTRACT(YEAR FROM data_pedido) AS ano, EXTRACT(MONTH FROM data_pedido) AS mes, EXTRACT(DAY FROM data_pedido) AS dia
FROM pedidos;
-- Aula 26 - Desafio 1: Calcular prazo de entrega (data_pedido + 7 dias)
-- Exiba pedido_id, data_pedido e prazo_entrega
SELECT pedido_id, data_pedido, data_pedido + INTERVAL '7 days' AS prazo_entrega
FROM pedidos;
-- Aula 26 - Desafio 2: Adicionar 30 dias à data de nascimento dos clientes
-- Exiba nome, data_nascimento e a nova data
SELECT nome, data_nascimento, data_nascimento + INTERVAL '30 days' AS data_mais_30_dias
FROM clientes;
-- Aula 27 - Desafio 1: Calcular tempo de entrega em dias (data_entrega - data_pedido)
-- Exiba pedido_id, data_pedido, data_entrega e dias_para_entrega
SELECT pedido_id, data_pedido, data_entrega_realizada AS data_entrega, data_entrega_realizada - data_pedido AS dias_para_entrega
FROM pedidos
WHERE status = 'entregue';
-- Aula 27 - Desafio 2: Calcular quantos dias após o início do mês o pedido foi feito
-- Exiba pedido_id, data_pedido, início do mês e dias desde o início do mês
SELECT pedido_id, data_pedido, DATE_TRUNC('month', data_pedido) AS inicio_mes, data_pedido - DATE_TRUNC('month', data_pedido) AS dias_desde_inicio_mes
FROM pedidos;
-- Aula 28 - Desafio 1: Formatar data_pedido como "DD/MM/YYYY"
-- Exiba pedido_id e a data formatada
SELECT pedido_id, data_pedido, TO_CHAR(data_pedido, 'DD/MM/YYYY') AS data_formatada
FROM pedidos;
-- Aula 28 - Desafio 2: Mostrar mês por extenso dos pedidos
-- Exiba pedido_id, data_pedido e o nome do mês em inglês
SELECT pedido_id, data_pedido, TO_CHAR(data_pedido, 'TMMonth') AS nome_mes
FROM pedidos;
