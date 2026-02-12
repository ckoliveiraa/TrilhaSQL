-- Aula 61 - Desafio 1: Criar uma tabela de cupons de desconto
-- Crie uma tabela chamada "cupons_desconto" com as seguintes colunas:
--   - cupom_id (SERIAL PRIMARY KEY)
--   - codigo (VARCHAR(50) UNIQUE NOT NULL)
--   - desconto_percentual (DECIMAL(5,2) entre 0 e 100)
--   - data_validade (DATE)
--   - ativo (BOOLEAN DEFAULT true)
CREATE TABLE cupons_desconto (
    cupom_id SERIAL PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    desconto_percentual DECIMAL(5,2) CHECK (desconto_percentual BETWEEN 0 AND 100),
    data_validade DATE,
    ativo BOOLEAN DEFAULT true
);

-- Aula 61 - Desafio 2: Criar uma view de cupons válidos
-- Crie uma view chamada "vw_cupons_validos" que mostre apenas cupons ativos
-- e com data de validade futura (maior que a data atual)
CREATE VIEW vw_cupons_validos AS
SELECT
    cupom_id,
    codigo,
    desconto_percentual,
    data_validade
FROM cupons_desconto
WHERE ativo = true
  AND data_validade >= CURRENT_DATE;

-- SELECT * FROM vw_cupons_validos 
-- Rodou mas sem dados

-- Aula 62 - Desafio 1: Inserir um cupom de desconto
-- Insira um cupom com:
--   - codigo: 'BEMVINDO10'
--   - desconto_percentual: 10.00
--   - data_validade: 30 dias a partir de hoje
--   - ativo: true
INSERT INTO cupons_desconto (codigo, desconto_percentual, data_validade, ativo)
VALUES ('BEMVINDO10', 10.00, CURRENT_DATE + INTERVAL '30 days', true);

SELECT * FROM cupons_desconto
-- Aula 62 - Desafio 2: Inserir múltiplos cupons de uma vez
-- Insira 5 cupons diferentes usando um único INSERT:
--   - 'BLACKFRIDAY' - 50% de desconto, validade 7 dias
--   - 'NATAL25' - 25% de desconto, validade 15 dias
--   - 'FRETEGRATIS' - 100% de desconto (representa frete grátis), validade 60 dias
--   - 'VOLTESEMPRE' - 15% de desconto, validade 90 dias
--   - 'PRIMEIRACOMPRA' - 20% de desconto, validade 365 dias
--   - 'ECO10' - 10% de desconto, validade de 45 dias negativos
INSERT INTO cupons_desconto (codigo, desconto_percentual, data_validade, ativo)
VALUES
    ('BLACKFRIDAY', 50.00, CURRENT_DATE + INTERVAL '7 days', true),
    ('NATAL25', 25.00, CURRENT_DATE + INTERVAL '15 days', true),
    ('FRETEGRATIS', 100.00, CURRENT_DATE + INTERVAL '60 days', true),
    ('VOLTESEMPRE', 15.00, CURRENT_DATE + INTERVAL '90 days', true),
    ('PRIMEIRACOMPRA', 20.00, CURRENT_DATE + INTERVAL '365 days', true),
    ('ECO10', 10.00, CURRENT_DATE - INTERVAL '45 days', true);

-- Aula 63 - Desafio 1: Atualizar desconto de um cupom específico
-- Aumente o desconto do cupom 'BEMVINDO10' de 10% para 15%
UPDATE cupons_desconto
SET desconto_percentual = 15.00
WHERE codigo = 'BEMVINDO10';

SELECT * FROM cupons_desconto

-- Aula 63 - Desafio 2: Desativar cupons expirados
-- Atualize o campo "ativo" para false de todos os cupons com data_validade no passado
UPDATE cupons_desconto
SET ativo = FALSE
WHERE data_validade < CURRENT_DATE;

SELECT * FROM cupons_desconto


-- Aula 64 - Desafio 1: Remover cupons expirados e inativos
-- Delete cupons que estão inativos E com data de validade anterior a 30 dias atrás
DELETE FROM cupons_desconto
WHERE ativo = false
  AND data_validade < CURRENT_DATE - INTERVAL '30 days';

SELECT * FROM cupons_desconto

-- Aula 64 - Desafio 2: Remover um cupom específico
-- Delete o cupom com código 'BLACKFRIDAY' (pois a campanha já acabou)
DELETE FROM cupons_desconto
WHERE codigo = 'BLACKFRIDAY';


-- Aula 65 - Desafio 1: Dropar a view de cupons válidos
-- Remova a view "vw_cupons_validos" criada na Aula 61
SELECT * FROM vw_cupons_validos

DROP VIEW IF EXISTS vw_cupons_validos;

-- Aula 65 - Desafio 2: Dropar a tabela de cupons de desconto
-- Remova a tabela "cupons_desconto" criada na Aula 61
SELECT * FROM cupons_desconto

DROP TABLE IF EXISTS cupons_desconto;


