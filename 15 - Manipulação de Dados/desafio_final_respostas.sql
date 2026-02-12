-- =================================================================
-- DESAFIOS FINAIS DO MODULO 15
-- =================================================================

-- Desafio Final 1: Estrutura de Campanha
-- Crie uma tabela chamada "promocao_verao" com:
--   - promocao_id (PK, SERIAL)
--   - produto_id (FK para produtos)
--   - desconto_percentual (DECIMAL, entre 0 e 100)
--   - data_inicio (DATE)
--   - data_fim (DATE)
--   - ativo (BOOLEAN, default true)

CREATE TABLE promocao_verao (
    promocao_id SERIAL PRIMARY KEY,
    produto_id INT NOT NULL,
    desconto_percentual DECIMAL(5,2) CHECK (desconto_percentual BETWEEN 0 AND 100),
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    ativo BOOLEAN DEFAULT true,
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
);


-- Desafio Final 2: Popular Dados
-- Insira 5 produtos na promoção de uma vez
-- Escolha produtos reais da tabela produtos
-- Use descontos entre 10% e 50%

-- Primeiro, veja alguns produtos disponíveis:
-- SELECT produto_id, nome, preco FROM produtos LIMIT 10;

-- Inserir promoções (ajuste os IDs conforme seus dados):
INSERT INTO promocao_verao (produto_id, desconto_percentual, data_inicio, data_fim, ativo)
VALUES
    (1, 20.00, CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days', true),
    (2, 15.00, CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days', true),
    (3, 30.00, CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days', true),
    (4, 25.00, CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days', true),
    (5, 10.00, CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days', true);


-- Desafio Final 3: Criar View de Análise
-- Crie uma view chamada vw_produtos_promocao que mostre:
--   - Nome do produto
--   - Preço original
--   - Desconto percentual
--   - Preço com desconto (calculado)
--   - Data início e fim da promoção

CREATE VIEW vw_produtos_promocao AS
SELECT
    p.nome AS produto,
    p.preco AS preco_original,
    pv.desconto_percentual,
    ROUND(p.preco * (1 - pv.desconto_percentual / 100), 2) AS preco_com_desconto,
    pv.data_inicio,
    pv.data_fim
FROM promocao_verao pv
INNER JOIN produtos p ON pv.produto_id = p.produto_id
WHERE pv.ativo = true;


-- Desafio Final 4: Ajustes na Campanha
-- a) Aumente em 5% o desconto de produtos com preço acima de R$ 1000

-- Verificar:
-- SELECT pv.promocao_id, p.nome, p.preco, pv.desconto_percentual,
--        pv.desconto_percentual + 5 AS novo_desconto
-- FROM promocao_verao pv
-- INNER JOIN produtos p ON pv.produto_id = p.produto_id
-- WHERE p.preco > 1000;

UPDATE promocao_verao pv
SET desconto_percentual = CASE
    WHEN desconto_percentual + 5 > 100 THEN 100
    ELSE desconto_percentual + 5
END
WHERE produto_id IN (
    SELECT produto_id FROM produtos WHERE preco > 1000
);

-- b) Desative promoções que já passaram da data_fim

-- Verificar:
-- SELECT * FROM promocao_verao
-- WHERE data_fim < CURRENT_DATE AND ativo = true;

UPDATE promocao_verao
SET ativo = false
WHERE data_fim < CURRENT_DATE;


-- Desafio Final 5: Limpeza de Dados
-- a) Remova da promoção os produtos que estão sem estoque

-- Verificar:
-- SELECT pv.*, p.nome, p.estoque
-- FROM promocao_verao pv
-- INNER JOIN produtos p ON pv.produto_id = p.produto_id
-- WHERE p.estoque = 0;

DELETE FROM promocao_verao
WHERE produto_id IN (
    SELECT produto_id FROM produtos WHERE estoque = 0
);

-- b) Delete promoções inativas

-- Verificar:
-- SELECT * FROM promocao_verao WHERE ativo = false;

DELETE FROM promocao_verao
WHERE ativo = false;


-- Desafio Final 6 (Boss Final!): Encerramento Completo
-- A campanha acabou. Faça a limpeza completa:

-- a) Criar uma tabela de backup chamada "promocao_verao_historico"
CREATE TABLE promocao_verao_historico (
    historico_id SERIAL PRIMARY KEY,
    promocao_id INT,
    produto_id INT,
    desconto_percentual DECIMAL(5,2),
    data_inicio DATE,
    data_fim DATE,
    ativo BOOLEAN,
    data_backup TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- b) Copiar todos os dados da promocao_verao para o histórico
INSERT INTO promocao_verao_historico (promocao_id, produto_id, desconto_percentual, data_inicio, data_fim, ativo)
SELECT promocao_id, produto_id, desconto_percentual, data_inicio, data_fim, ativo
FROM promocao_verao;

-- c) Drope a view vw_produtos_promocao
DROP VIEW IF EXISTS vw_produtos_promocao;

-- d) Drope a tabela promocao_verao
DROP TABLE IF EXISTS promocao_verao;

-- e) Confirme que o histórico foi salvo corretamente
-- SELECT * FROM promocao_verao_historico;
-- SELECT COUNT(*) FROM promocao_verao_historico;