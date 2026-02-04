-- Aula 18 - Desafio 1: Crie uma coluna com "Nome - Marca" para produtos
-- Exiba o nome do produto, a marca e a nova coluna concatenada.
SELECT nome, marca, CONCAT(nome, ' - ', marca) AS nome_marca
FROM produtos;
-- Aula 18 - Desafio 2: Crie o endereço completo dos clientes
-- Concatene cidade, estado e CEP em uma única coluna chamada "Endereço Completo". Ex: "São Paulo - SP, 01000-000"
SELECT nome, cidade, estado, CONCAT(cidade, ' - ', estado, ' , ', cep) AS endereco_completo
FROM clientes;
-- Aula 19 - Desafio 1: Mostrar todos os nomes de produtos em maiúsculas
-- Exiba o nome original e o nome em maiúsculas para comparação.
SELECT nome AS nome_original, UPPER(nome) AS nome_maiusculo
FROM produtos;
-- Aula 19 - Desafio 2: Mostrar nomes de clientes em maiúsculas
-- Crie um relatório com os nomes de todos os clientes em caixa alta.
SELECT UPPER(nome) AS nome_maiusculo
FROM clientes;
-- Aula 20 - Desafio 1: Mostrar todos os emails dos clientes em minúsculas
-- Ideal para criar uma lista de marketing padronizada.
SELECT nome, email AS email_original, LOWER(email) AS email_padronizado
FROM clientes;
-- Aula 20 - Desafio 2: Padronizar nomes de categorias em minúsculas
-- Exiba os nomes das categorias em sua forma original e em minúsculas.
SELECT nome AS nome_original, LOWER(nome) AS nome_minusculo
FROM categorias;
-- Aula 21 - Desafio 1: Extrair apenas o primeiro nome dos clientes
-- Dica: Use a função POSITION(' ' IN nome) para encontrar o primeiro espaço.
SELECT nome AS nome_completo, SUBSTRING(nome FROM 1 FOR POSITION(' ' IN nome) - 1) AS primeiro_nome
FROM clientes;
-- Aula 21 - Desafio 2: Extrair o DDD dos telefones dos clientes
-- Considere que os telefones podem ter formatos diferentes, como '(XX) YYYYY-ZZZZ' ou 'XX YYYYY ZZZZ'.
SELECT nome, telefone, SUBSTRING(telefone FROM 2 FOR 3) AS ddd
FROM clientes
WHERE telefone IS NOT NULL
AND telefone LIKE '(%)%';
-- Aula 22 - Desafio 1: Limpar espaços extras nos nomes de produtos
-- Suponha que alguns produtos foram cadastrados com espaços no início ou fim do nome. Mostre o nome original e o nome limpo.
SELECT nome AS nome_original, TRIM(nome) AS nome_limpo
FROM produtos;
-- Aula 22 - Desafio 2: Remover espaços de emails antes de comparar
-- Encontre os clientes cujo email, após a remoção dos espaços em branco
-- no início e no final do texto, comece com a letra 'c' e termine com '.com'.
SELECT *
FROM clientes
WHERE TRIM(email) LIKE 'c%.com';
-- Aula 23 - Desafio 1: Mostrar produtos cujo nome tenha mais de 20 caracteres
-- Exiba o nome do produto e o seu comprimento.
SELECT nome, LENGTH(nome) AS tamanho_nome
FROM produtos
WHERE LENGTH(nome) > 20
-- Aula 23 - Desafio 2: Validar CPFs que não tenham exatamente 14 caracteres (incluindo pontos e traço)
-- Liste os clientes com CPFs de tamanho inválido.
SELECT nome, cpf, LENGTH(cpf) AS tamanho_cpf
FROM clientes
WHERE LENGTH(cpf) <> 14
AND cpf IS NOT NULL;
