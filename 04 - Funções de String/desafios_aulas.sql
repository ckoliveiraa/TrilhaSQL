-- =================================================================
-- MODULO 03 - FUNCOES DE STRING - DESAFIOS DAS AULAS
-- =================================================================

-- =================================================================
-- AULA 18 - CONCAT - Concatenando Textos
-- =================================================================

-- Aula 18 - Desafio 1: Crie uma coluna com "Nome - Marca" para produtos
-- Exiba o nome do produto, a marca e a nova coluna concatenada.
SELECT
    nome,
    marca,
    CONCAT(nome, ' - ', marca) AS nome_marca
FROM produtos;


-- Aula 18 - Desafio 2: Crie o endereco completo dos clientes
-- Concatene cidade, estado. Ex: "Sao Paulo - SP"
SELECT
    nome,
    cidade,
    estado,
    CONCAT(cidade, ' - ', estado) AS endereco_completo
FROM clientes;


-- =================================================================
-- AULA 19 - UPPER - Convertendo para Maiusculas
-- =================================================================

-- Aula 19 - Desafio 1: Mostrar todos os nomes de produtos em maiusculas
-- Exiba o nome original e o nome em maiusculas para comparacao.
SELECT
    nome AS nome_original,
    UPPER(nome) AS nome_maiusculo
FROM produtos;


-- Aula 19 - Desafio 2: Mostrar nomes de clientes em maiusculas
-- Crie um relatorio com os nomes de todos os clientes em caixa alta.
SELECT
    nome AS nome_original,
    UPPER(nome) AS nome_maiusculo
FROM clientes;


-- =================================================================
-- AULA 20 - LOWER - Convertendo para Minusculas
-- =================================================================

-- Aula 20 - Desafio 1: Mostrar todos os emails dos clientes em minusculas
-- Ideal para criar uma lista de marketing padronizada.
SELECT
    nome,
    email AS email_original,
    LOWER(email) AS email_padronizado
FROM clientes;


-- Aula 20 - Desafio 2: Padronizar nomes de categorias em minusculas
-- Exiba os nomes das categorias em sua forma original e em minusculas.
SELECT
    nome AS nome_original,
    LOWER(nome) AS nome_minusculo
FROM categorias;


-- =================================================================
-- AULA 21 - SUBSTRING - Extraindo Parte do Texto
-- =================================================================

-- Aula 21 - Desafio 1: Extrair os primeiros 10 caracteres do nome dos clientes
-- Usando SUBSTRING com posicao fixa
SELECT
    nome AS nome_completo,
    SUBSTRING(nome FROM 1 FOR 10) AS inicio_nome
FROM clientes;

-- Alternativa: Extrair caracteres a partir de uma posicao especifica
SELECT
    nome AS nome_completo,
    SUBSTRING(nome FROM 1 FOR 5) AS primeiros_5_chars
FROM clientes;


-- Aula 21 - Desafio 2: Extrair o DDD dos telefones dos clientes
-- Considerando formato '(XX) YYYYY-ZZZZ'
SELECT
    nome,
    telefone,
    SUBSTRING(telefone FROM 2 FOR 2) AS ddd
FROM clientes
WHERE telefone IS NOT NULL
  AND telefone LIKE '(%)%';


-- =================================================================
-- AULA 22 - TRIM - Removendo Espacos
-- =================================================================

-- Aula 22 - Desafio 1: Limpar espacos extras nos nomes de produtos
-- Suponha que alguns produtos foram cadastrados com espacos no inicio ou fim.
SELECT
    nome AS nome_original,
    TRIM(nome) AS nome_limpo,
    LENGTH(nome) AS tamanho_original,
    LENGTH(TRIM(nome)) AS tamanho_limpo
FROM produtos;


-- Aula 22 - Desafio 2: Remover espacos de emails antes de comparar
-- Encontre clientes cujo email, apos a limpeza de espacos, seja 'exemplo@email.com'.
SELECT *
FROM clientes
WHERE TRIM(email) = 'exemplo@email.com';


-- =================================================================
-- AULA 23 - LENGTH - Contando Caracteres
-- =================================================================

-- Aula 23 - Desafio 1: Mostrar produtos cujo nome tenha mais de 20 caracteres
-- Exiba o nome do produto e o seu comprimento.
SELECT
    nome,
    LENGTH(nome) AS tamanho_nome
FROM produtos
WHERE LENGTH(nome) > 20
ORDER BY LENGTH(nome) DESC;


-- Aula 23 - Desafio 2: Validar CPFs que nao tenham exatamente 14 caracteres (incluindo pontos e traco)
-- Liste os clientes com CPFs de tamanho invalido.
SELECT
    nome,
    cpf,
    LENGTH(cpf) AS tamanho_cpf
FROM clientes
WHERE LENGTH(cpf) <> 14
  AND cpf IS NOT NULL;
