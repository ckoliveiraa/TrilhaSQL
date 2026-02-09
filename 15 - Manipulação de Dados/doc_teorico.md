# Módulo 15 - Manipulação de Dados - Material Didático

## Objetivo do Módulo
Dominar os comandos DDL (Data Definition Language) e DML (Data Manipulation Language) para criar estruturas, inserir, atualizar e deletar dados de forma segura e eficiente.

---
# AULA 61

<details>
<summary><strong>Expandir Aula 61</strong></summary>

## CREATE - Criando Tabelas e Views

## O que é?

O comando `CREATE` permite criar **estruturas** no banco de dados, como **tabelas** (para armazenar dados) e **views** (consultas salvas).

## Sintaxe - CREATE TABLE

```sql
CREATE TABLE nome_tabela (
    coluna1 tipo_dado CONSTRAINTS,
    coluna2 tipo_dado CONSTRAINTS,
    ...
);
```

## Tipos de Dados Comuns

```sql
-- Numéricos
INT, BIGINT, DECIMAL(10,2), NUMERIC(8,2)

-- Texto
VARCHAR(100), TEXT, CHAR(10)

-- Data/Hora
DATE, TIMESTAMP, TIME

-- Booleano
BOOLEAN

-- Outros
JSON, JSONB, UUID
```

## Constraints (Restrições)

```sql
CREATE TABLE produtos_temp (
    produto_id SERIAL PRIMARY KEY,           -- Chave primária auto-incremento
    nome VARCHAR(100) NOT NULL,              -- Não pode ser nulo
    codigo VARCHAR(50) UNIQUE,               -- Deve ser único
    preco DECIMAL(10,2) CHECK (preco > 0),  -- Deve ser positivo
    categoria_id INT,
    ativo BOOLEAN DEFAULT true,              -- Valor padrão
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
);
```

## Exemplos Práticos - CREATE TABLE

```sql
-- Tabela simples para auditoria
CREATE TABLE log_vendas (
    log_id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL,
    data_log TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50),
    acao VARCHAR(20)
);

-- Tabela temporária para campanhas
CREATE TABLE campanhas (
    campanha_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    desconto_percentual DECIMAL(5,2) CHECK (desconto_percentual BETWEEN 0 AND 100),
    ativo BOOLEAN DEFAULT true
);

-- Tabela para rastrear histórico de preços
CREATE TABLE historico_precos (
    historico_id SERIAL PRIMARY KEY,
    produto_id INT NOT NULL,
    preco_antigo DECIMAL(10,2),
    preco_novo DECIMAL(10,2),
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
);
```

## O que é uma VIEW?

Uma **view** é uma **consulta salva** que funciona como uma tabela virtual. Ela não armazena dados, apenas a query.

## Sintaxe - CREATE VIEW

```sql
CREATE VIEW nome_view AS
SELECT ...
FROM ...
WHERE ...;
```

## Vantagens das Views

```
✅ Simplifica consultas complexas
✅ Segurança (oculta colunas sensíveis)
✅ Reutilização de queries
✅ Abstração da estrutura real
```

## Exemplos Práticos - CREATE VIEW

```sql
-- View de produtos em estoque
CREATE VIEW vw_produtos_disponiveis AS
SELECT
    produto_id,
    nome,
    preco,
    estoque,
    marca
FROM produtos
WHERE ativo = true AND estoque > 0;

-- View de vendas por cliente
CREATE VIEW vw_vendas_cliente AS
SELECT
    c.cliente_id,
    c.nome,
    COUNT(p.pedido_id) AS total_pedidos,
    SUM(p.valor_total) AS total_gasto
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome;

-- View de produtos mais vendidos
CREATE VIEW vw_top_produtos AS
SELECT
    pr.produto_id,
    pr.nome,
    COUNT(ip.item_pedido_id) AS total_vendas,
    SUM(ip.quantidade) AS quantidade_vendida
FROM produtos pr
INNER JOIN itens_pedido ip ON pr.produto_id = ip.produto_id
GROUP BY pr.produto_id, pr.nome
ORDER BY quantidade_vendida DESC;

-- View com cálculos
CREATE VIEW vw_pedidos_completos AS
SELECT
    p.pedido_id,
    c.nome AS cliente,
    p.data_pedido,
    p.valor_total,
    p.frete,
    p.desconto,
    (p.valor_total + p.frete - p.desconto) AS valor_final,
    pg.status AS status_pagamento
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
LEFT JOIN pagamentos pg ON p.pedido_id = pg.pedido_id;
```

## Usando Views

```sql
-- Views funcionam como tabelas em SELECT
SELECT * FROM vw_produtos_disponiveis;

SELECT * FROM vw_vendas_cliente
WHERE total_gasto > 1000;

SELECT * FROM vw_top_produtos
LIMIT 10;
```

## CREATE OR REPLACE VIEW

```sql
-- Atualizar uma view existente
CREATE OR REPLACE VIEW vw_produtos_disponiveis AS
SELECT
    produto_id,
    nome,
    preco,
    estoque,
    marca,
    categoria_id  -- Nova coluna adicionada
FROM produtos
WHERE ativo = true AND estoque > 0;
```

## Quando usar TABELA vs VIEW?

```sql
-- ✅ Use TABELA quando:
-- - Precisa ARMAZENAR dados
-- - Precisa de performance (dados físicos)
-- - Vai fazer INSERT/UPDATE/DELETE

-- ✅ Use VIEW quando:
-- - Quer simplificar consultas complexas
-- - Precisa de segurança (ocultar dados)
-- - Os dados mudam com frequência
-- - Quer reutilizar uma query
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 61 - Desafio 1: Criar uma tabela de cupons de desconto
-- Colunas: cupom_id (PK, SERIAL), codigo (VARCHAR UNIQUE), desconto (DECIMAL), validade (DATE), ativo (BOOLEAN)


-- Aula 61 - Desafio 2: Criar uma view de clientes VIP
-- Mostre clientes que já gastaram mais de R$ 5000 no total

```

</details>

</details>

---

# AULA 62

<details>
<summary><strong>Expandir Aula 62</strong></summary>

## INSERT - Inserindo Dados

## O que é?

O comando `INSERT` adiciona **novos registros** em uma tabela do banco de dados.

## Sintaxe

```sql
-- Inserindo um único registro
INSERT INTO tabela (coluna1, coluna2, coluna3)
VALUES (valor1, valor2, valor3);

-- Inserindo múltiplos registros
INSERT INTO tabela (coluna1, coluna2, coluna3)
VALUES
    (valor1a, valor2a, valor3a),
    (valor1b, valor2b, valor3b),
    (valor1c, valor2c, valor3c);
```

## Exemplos Práticos - INSERT Único

```sql
-- Inserir um novo produto
INSERT INTO produtos (nome, preco, estoque, marca, categoria_id)
VALUES ('Fone Bluetooth', 199.90, 50, 'JBL', 1);

-- Inserir um novo cliente
INSERT INTO clientes (nome, email, telefone, cidade, estado)
VALUES ('João Silva', 'joao@email.com', '11999999999', 'São Paulo', 'SP');

-- Inserir com valores NULL explícitos
INSERT INTO clientes (nome, email, telefone, cidade, estado)
VALUES ('Maria Santos', 'maria@email.com', NULL, 'Rio de Janeiro', 'RJ');
```

## Exemplos Práticos - INSERT Múltiplo

```sql
-- Inserir 3 produtos de uma vez
INSERT INTO produtos (nome, preco, estoque, marca, categoria_id)
VALUES
    ('Mouse Wireless', 89.90, 100, 'Logitech', 1),
    ('Teclado Mecânico', 299.90, 50, 'Redragon', 1),
    ('Webcam HD', 199.90, 30, 'Logitech', 1);

-- Inserir 5 clientes de uma vez
INSERT INTO clientes (nome, email, cidade, estado)
VALUES
    ('Carlos Lima', 'carlos@email.com', 'Brasília', 'DF'),
    ('Fernanda Souza', 'fernanda@email.com', 'Salvador', 'BA'),
    ('Roberto Alves', 'roberto@email.com', 'Fortaleza', 'CE'),
    ('Juliana Costa', 'juliana@email.com', 'Recife', 'PE'),
    ('Lucas Santos', 'lucas@email.com', 'Manaus', 'AM');
```

## Valores Automáticos

```sql
-- Colunas com DEFAULT ou SERIAL são preenchidas automaticamente
INSERT INTO pedidos (cliente_id, valor_total, status)
VALUES (1, 500.00, 'pendente');
-- pedido_id é gerado automaticamente (SERIAL)
-- data_pedido pode ter DEFAULT CURRENT_DATE
```
## INSERT SELECT - Copiar dados de outra consulta

```sql
-- Copiar produtos para uma tabela de backup
INSERT INTO produtos_backup (produto_id, nome, preco, estoque)
SELECT produto_id, nome, preco, estoque
FROM produtos
WHERE ativo = true;

-- Criar registros de clientes VIP
INSERT INTO clientes_vip (cliente_id, nome, total_gasto)
SELECT
    c.cliente_id,
    c.nome,
    SUM(p.valor_total)
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome
HAVING SUM(p.valor_total) > 10000;
```

## Performance - Múltiplos INSERTs

```sql
-- ❌ LENTO: múltiplos INSERTs individuais
INSERT INTO produtos (nome, preco) VALUES ('Produto 1', 10.00);
INSERT INTO produtos (nome, preco) VALUES ('Produto 2', 20.00);
INSERT INTO produtos (nome, preco) VALUES ('Produto 3', 30.00);
-- 3 transações separadas

-- ✅ RÁPIDO: um INSERT com múltiplos valores
INSERT INTO produtos (nome, preco) VALUES
    ('Produto 1', 10.00),
    ('Produto 2', 20.00),
    ('Produto 3', 30.00);
-- 1 transação
```
## Boas Práticas

```sql
-- ✅ SEMPRE especifique as colunas
INSERT INTO produtos (nome, preco, estoque)
VALUES ('Produto', 99.90, 10);

-- ❌ EVITE inserir sem especificar colunas
INSERT INTO produtos
VALUES (DEFAULT, 'Produto', 99.90, 10, NULL, NULL, NULL);
-- Frágil: quebra se a estrutura da tabela mudar
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 62 - Desafio 1: Inserir um novo produto completo
-- Adicione um produto eletrônico à sua escolha (ex: "Fone de Ouvido Bluetooth")
-- Inclua: nome, preco (valor realista), estoque (quantidade), marca e categoria_id


-- Aula 62 - Desafio 2: Inserir 3 novos clientes de uma vez
-- Use um único comando INSERT com dados fictícios de 3 clientes
-- Inclua: nome completo, email, telefone (opcional), cidade e estado

```

</details>

</details>

---

# AULA 63

<details>
<summary><strong>Expandir Aula 63</strong></summary>

## UPDATE - Atualizando Dados

## O que é?

O comando `UPDATE` modifica **dados existentes** em uma tabela.

## Sintaxe

```sql
UPDATE tabela
SET coluna1 = novo_valor1,
    coluna2 = novo_valor2
WHERE condição;
```

## ⚠️ CUIDADO CRÍTICO

```sql
-- ❌ PERIGO! Atualiza TODOS os registros!
UPDATE produtos
SET preco = 0;
-- Todos os produtos ficam com preço 0!

-- ✅ SEMPRE use WHERE para limitar
UPDATE produtos
SET preco = 0
WHERE produto_id = 5;
```

## Exemplos Práticos

```sql
-- Atualizar preço de um produto específico
UPDATE produtos
SET preco = 299.90
WHERE produto_id = 10;

-- Atualizar múltiplas colunas
UPDATE clientes
SET telefone = '11888888888',
    cidade = 'Campinas'
WHERE cliente_id = 5;

-- Atualizar status de um pedido
UPDATE pedidos
SET status = 'enviado'
WHERE pedido_id = 100;
```

## UPDATE com Cálculos

```sql
-- Aumentar preço em 10%
UPDATE produtos
SET preco = preco * 1.10
WHERE categoria_id = 1;

-- Aplicar desconto de 15%
UPDATE produtos
SET preco = preco * 0.85
WHERE marca = 'Samsung';

-- Adicionar estoque
UPDATE produtos
SET estoque = estoque + 100
WHERE produto_id = 15;

-- Diminuir estoque (com validação)
UPDATE produtos
SET estoque = estoque - 1
WHERE produto_id = 20 AND estoque > 0;
```

## UPDATE com Subconsulta

```sql
-- Atualizar baseado em outra tabela
UPDATE produtos p
SET preco = preco * 1.05
WHERE categoria_id IN (
    SELECT categoria_id FROM categorias WHERE nome = 'Eletrônicos'
);

-- Atualizar com valor calculado de outra tabela
UPDATE pedidos p
SET valor_total = (
    SELECT SUM(quantidade * preco_unitario)
    FROM itens_pedido ip
    WHERE ip.pedido_id = p.pedido_id
);

-- Marcar clientes VIP
UPDATE clientes c
SET categoria = 'VIP'
WHERE cliente_id IN (
    SELECT cliente_id
    FROM pedidos
    GROUP BY cliente_id
    HAVING SUM(valor_total) > 10000
);
```

## Verificando Antes de Atualizar

```sql
-- 1. SEMPRE faça SELECT primeiro para ver o que será afetado
SELECT * FROM produtos
WHERE marca = 'Samsung';

-- 2. Confira a quantidade de registros
SELECT COUNT(*) FROM produtos
WHERE marca = 'Samsung';

-- 3. Se estiver correto, faça o UPDATE
UPDATE produtos
SET preco = preco * 1.10
WHERE marca = 'Samsung';
```

## UPDATE com FROM (JOIN)

```sql
-- Atualizar com dados de outra tabela
UPDATE produtos p
SET estoque = estoque + t.quantidade
FROM transferencias t
WHERE p.produto_id = t.produto_id
  AND t.tipo = 'entrada';
```

## Boas Práticas

```
✅ SEMPRE faça SELECT antes de UPDATE
✅ Use WHERE para limitar registros
✅ Use RETURNING para confirmar
✅ Faça backup antes de operações em massa
✅ Teste em ambiente de desenvolvimento primeiro
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 63 - Desafio 1: Aumentar em 10% o preço de produtos da categoria "Eletrônicos"
-- Dica: Use WHERE com subconsulta para identificar a categoria


-- Aula 63 - Desafio 2: Adicionar 50 unidades ao estoque do produto com ID 1
-- Use UPDATE com cálculo


-- Aula 63 - Desafio 3: Atualizar o status de pedidos antigos
-- Mude o status para "arquivado" de pedidos com data_pedido anterior a 2023-01-01

```

</details>

</details>

---

# AULA 64

<details>
<summary><strong>Expandir Aula 64</strong></summary>

## DELETE - Removendo Dados com Segurança

## O que é?

O comando `DELETE` remove **registros** de uma tabela.

## Sintaxe

```sql
DELETE FROM tabela
WHERE condição;
```

## ⚠️ CUIDADO CRÍTICO

```sql
-- ❌ PERIGO EXTREMO! Remove TODOS os registros!
DELETE FROM produtos;
-- Tabela fica vazia!

-- ✅ SEMPRE use WHERE
DELETE FROM produtos
WHERE produto_id = 5;
```

## Exemplos Práticos

```sql
-- Remover um produto específico
DELETE FROM produtos
WHERE produto_id = 100;

-- Remover produtos sem estoque
DELETE FROM produtos
WHERE estoque = 0 AND ativo = false;

-- Remover clientes inativos há mais de 1 ano
DELETE FROM clientes
WHERE ativo = false
  AND ultimo_acesso < CURRENT_DATE - INTERVAL '1 year';

-- Remover pedidos cancelados antigos
DELETE FROM pedidos
WHERE status = 'cancelado'
  AND data_pedido < '2023-01-01';
```

## Verificando Antes de Deletar

```sql
-- 1. SEMPRE verifique primeiro com SELECT
SELECT * FROM produtos
WHERE estoque = 0 AND ativo = false;

-- 2. Confira a quantidade
SELECT COUNT(*) FROM produtos
WHERE estoque = 0 AND ativo = false;

-- 3. Se estiver correto, DELETE
DELETE FROM produtos
WHERE estoque = 0 AND ativo = false;
```

## DELETE com Subconsulta

```sql
-- Remover itens de pedidos cancelados
DELETE FROM itens_pedido
WHERE pedido_id IN (
    SELECT pedido_id FROM pedidos WHERE status = 'cancelado'
);

-- Remover clientes que nunca fizeram pedidos
DELETE FROM clientes
WHERE cliente_id NOT IN (
    SELECT DISTINCT cliente_id FROM pedidos
);

-- Alternativa mais eficiente com NOT EXISTS
DELETE FROM clientes c
WHERE NOT EXISTS (
    SELECT 1 FROM pedidos p WHERE p.cliente_id = c.cliente_id
);

-- Remover produtos sem vendas
DELETE FROM produtos p
WHERE NOT EXISTS (
    SELECT 1 FROM itens_pedido ip WHERE ip.produto_id = p.produto_id
)
AND ativo = false;
```

## RETURNING - Confirmar o que foi deletado

```sql
-- Ver os registros removidos
DELETE FROM produtos
WHERE estoque = 0
RETURNING produto_id, nome;

-- Guardar os dados deletados em outra tabela
INSERT INTO produtos_removidos
SELECT * FROM produtos WHERE produto_id = 99;

DELETE FROM produtos
WHERE produto_id = 99
RETURNING *;
```

## Integridade Referencial (Foreign Keys)

```sql
-- Se houver FK (chave estrangeira), pode dar erro
DELETE FROM categorias WHERE categoria_id = 1;
-- ERRO: produtos depende de categorias

-- Opções:
-- 1. Deletar os registros dependentes primeiro
DELETE FROM produtos WHERE categoria_id = 1;
DELETE FROM categorias WHERE categoria_id = 1;

-- 2. Usar CASCADE (se configurado na FK)
-- Deleta automaticamente os registros dependentes

-- 3. Atualizar os registros dependentes para NULL
UPDATE produtos SET categoria_id = NULL WHERE categoria_id = 1;
DELETE FROM categorias WHERE categoria_id = 1;
```

## TRUNCATE vs DELETE

```sql
-- DELETE - Remove registros com condição
DELETE FROM tabela WHERE condição;
-- Pode ter WHERE
-- Mais lento
-- Pode ser revertido (dentro de transação)

-- TRUNCATE - Remove TODOS os registros
TRUNCATE TABLE tabela_temporaria;
-- NÃO pode ter WHERE
-- Muito mais rápido
-- Reinicia sequências (IDs)
-- Difícil de reverter

-- TRUNCATE com RESTART IDENTITY
TRUNCATE TABLE tabela_temporaria RESTART IDENTITY;
-- Reinicia os IDs para 1
```

## Soft Delete vs Hard Delete

```sql
-- Hard Delete (remove de verdade)
DELETE FROM clientes WHERE cliente_id = 5;
-- Dados são perdidos permanentemente

-- Soft Delete (apenas marca como inativo)
UPDATE clientes SET ativo = false WHERE cliente_id = 5;
-- Dados ficam no banco, apenas "escondidos"

-- ✅ Use Soft Delete quando:
-- - Precisa manter histórico
-- - Pode precisar restaurar dados
-- - Auditoria exige rastro completo

-- ✅ Use Hard Delete quando:
-- - Dados temporários/descartáveis
-- - Conformidade com LGPD/GDPR (direito ao esquecimento)
-- - Performance (limpeza de dados antigos)
```

## Boas Práticas para DELETE

```
✅ SEMPRE faça SELECT primeiro
✅ SEMPRE use WHERE (exceto TRUNCATE)
✅ Faça backup antes de operações em massa
✅ Use RETURNING para confirmar
✅ Considere usar "soft delete" (marcar como inativo)
✅ Delete registros dependentes antes das FKs
✅ Use transações para operações complexas
```


## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 64 - Desafio 1: Remover produtos com estoque zerado
-- PRIMEIRO faça SELECT para verificar, depois DELETE


-- Aula 64 - Desafio 2: Remover clientes que nunca fizeram pedidos
-- Use WHERE com subconsulta ou NOT EXISTS


-- Aula 64 - Desafio 3: Remover avaliações de produtos que não existem mais
-- Use subconsulta para identificar produtos inexistentes

```

</details>

</details>

---

# AULA 65

<details>
<summary><strong>Expandir Aula 65</strong></summary>

## DROP - Removendo Estruturas

## O que é?

O comando `DROP` **remove permanentemente** estruturas do banco de dados como tabelas, views, índices, etc.

## ⚠️ PERIGO EXTREMO

```sql
-- DROP remove a estrutura COMPLETA e TODOS os dados
-- NÃO HÁ COMO REVERTER sem backup!
```

## Sintaxe

```sql
-- Remover tabela
DROP TABLE nome_tabela;

-- Remover view
DROP VIEW nome_view;

-- Remover apenas se existir (evita erro)
DROP TABLE IF EXISTS nome_tabela;
DROP VIEW IF EXISTS nome_view;
```

## DROP TABLE - Removendo Tabelas

```sql
-- Remover tabela simples
DROP TABLE produtos_temporarios;

-- Remover apenas se existir
DROP TABLE IF EXISTS produtos_backup;

-- Remover com CASCADE (remove dependências)
DROP TABLE categorias CASCADE;
-- Remove também as FKs que apontam para esta tabela
-- ⚠️ MUITO PERIGOSO!

-- Remover com RESTRICT (padrão - falha se houver dependências)
DROP TABLE categorias RESTRICT;
-- Erro se houver FKs ou outras dependências
```

## DROP VIEW - Removendo Views

```sql
-- Remover view
DROP VIEW vw_produtos_disponiveis;

-- Remover apenas se existir
DROP VIEW IF EXISTS vw_vendas_cliente;

-- Remover múltiplas views
DROP VIEW IF EXISTS
    vw_produtos_disponiveis,
    vw_vendas_cliente,
    vw_top_produtos;
```

## Diferença entre DELETE, TRUNCATE e DROP

```sql
-- DELETE - Remove registros, mantém estrutura
DELETE FROM produtos WHERE estoque = 0;
-- ✅ Remove apenas dados específicos
-- ✅ Pode ter WHERE
-- ✅ Estrutura da tabela permanece
-- ❌ Mais lento

-- TRUNCATE - Remove todos os registros, mantém estrutura
TRUNCATE TABLE produtos_temporarios;
-- ✅ Remove todos os dados
-- ✅ Muito rápido
-- ✅ Estrutura da tabela permanece
-- ❌ Não pode ter WHERE

-- DROP - Remove estrutura E dados
DROP TABLE produtos_temporarios;
-- ✅ Remove tudo (estrutura + dados)
-- ❌ Não pode ter WHERE
-- ❌ NÃO HÁ VOLTA!
```

## Quando usar DROP?

```sql
-- ✅ Use DROP quando:
-- - Tabela/view não é mais necessária
-- - Quer refazer a estrutura do zero
-- - Limpeza de objetos temporários
-- - Remover backups antigos

-- ❌ NÃO use DROP quando:
-- - Só quer limpar dados (use DELETE ou TRUNCATE)
-- - Não tem certeza se vai precisar depois
-- - Não tem backup
-- - Em produção sem aprovação
```

## Verificando Antes de Dropar

```sql
-- 1. Verificar se a tabela tem dados importantes
SELECT COUNT(*) FROM tabela_a_dropar;

-- 2. Verificar dependências (FKs)
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND ccu.table_name = 'tabela_a_dropar';

-- 3. Fazer backup antes de dropar
CREATE TABLE backup_tabela AS SELECT * FROM tabela_a_dropar;

-- 4. Agora pode dropar com segurança
DROP TABLE tabela_a_dropar;
```

## Exemplos Práticos

```sql
-- Remover tabela temporária de campanha encerrada
DROP TABLE IF EXISTS campanha_black_friday_2023;

-- Remover view obsoleta
DROP VIEW IF EXISTS vw_relatorio_antigo;

-- Limpar múltiplas tabelas de teste
DROP TABLE IF EXISTS
    teste_produtos,
    teste_clientes,
    teste_pedidos;

-- Remover tabela de backup antigo
DROP TABLE IF EXISTS produtos_backup_2023_01_01;
```

## Recreando Estruturas

```sql
-- Padrão: Dropar e recriar (quando estrutura muda muito)
DROP TABLE IF EXISTS log_vendas;

CREATE TABLE log_vendas (
    log_id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL,
    data_log TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50),
    acao VARCHAR(20),
    detalhes TEXT  -- Nova coluna adicionada
);
```

## Boas Práticas para DROP

```
⚠️ CHECKLIST ANTES DE DROP:
   [ ] Tenho backup dos dados?
   [ ] Tenho certeza que não vou precisar?
   [ ] Verifiquei as dependências (FKs)?
   [ ] Estou no banco correto? (dev/prod)
   [ ] Tenho aprovação (em produção)?

✅ Use sempre IF EXISTS para evitar erros
✅ Faça backup antes de dropar
✅ Documente o que foi removido
✅ Em produção, prefira renomear antes de dropar
```

## Alternativa Segura: Renomear

```sql
-- Em vez de dropar direto, renomeie primeiro
ALTER TABLE produtos_antigos RENAME TO produtos_antigos_BACKUP_2024;

-- Se algo quebrar, volte o nome
ALTER TABLE produtos_antigos_BACKUP_2024 RENAME TO produtos_antigos;

-- Depois de confirmar que está tudo OK, aí sim drope
DROP TABLE produtos_antigos_BACKUP_2024;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 65 - Desafio 1: Criar e depois dropar uma tabela de teste
-- Crie uma tabela chamada teste_drop com 2 colunas, depois remova ela


-- Aula 65 - Desafio 2: Criar e dropar uma view
-- Crie uma view vw_teste com uma consulta simples, depois remova


```

</details>

</details>

---

## Resumo Rápido

| Comando | O que faz | Exemplo | Reversível? |
|---------|-----------|---------|-------------|
| `CREATE TABLE` | Cria tabela | `CREATE TABLE t (...)` | Sim (DROP) |
| `CREATE VIEW` | Cria view (consulta salva) | `CREATE VIEW v AS SELECT ...` | Sim (DROP) |
| `INSERT` | Adiciona registros | `INSERT INTO t (c) VALUES (v)` | Sim (DELETE) |
| `UPDATE` | Modifica registros | `UPDATE t SET c = v WHERE ...` | Difícil |
| `DELETE` | Remove registros | `DELETE FROM t WHERE ...` | Difícil |
| `TRUNCATE` | Limpa tabela | `TRUNCATE TABLE t` | Não |
| `DROP` | Remove estrutura | `DROP TABLE t` | Não |

---

## Combinando Operações

```sql
-- Fluxo completo: Criar, Popular, Modificar, Limpar

-- 1. Criar estrutura
CREATE TABLE campanhas_2024 (
    campanha_id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    desconto DECIMAL(5,2)
);

-- 2. Inserir dados
INSERT INTO campanhas_2024 (nome, desconto)
VALUES
    ('Black Friday', 50.00),
    ('Natal', 30.00),
    ('Ano Novo', 20.00);

-- 3. Atualizar
UPDATE campanhas_2024
SET desconto = desconto + 5
WHERE nome = 'Black Friday';

-- 4. Remover registros específicos
DELETE FROM campanhas_2024
WHERE desconto < 25;

-- 5. Limpar tudo (se acabou a campanha)
TRUNCATE TABLE campanhas_2024;

-- 6. Remover estrutura (fim do ano)
DROP TABLE campanhas_2024;
```

---

## Checklist de Segurança

```
✅ Antes de CREATE:
   [ ] A estrutura está bem planejada?
   [ ] Os tipos de dados estão corretos?
   [ ] As constraints fazem sentido?

✅ Antes de INSERT:
   [ ] Especifiquei as colunas?
   [ ] Os dados estão no formato correto?
   [ ] Tratei possíveis duplicatas?

✅ Antes de UPDATE/DELETE:
   [ ] Fiz SELECT para verificar?
   [ ] A cláusula WHERE está correta?
   [ ] Tenho backup dos dados?

✅ Antes de DROP:
   [ ] Tenho CERTEZA que não preciso mais?
   [ ] Fiz backup completo?
   [ ] Verifiquei todas as dependências?
   [ ] Estou no banco correto? (dev/prod)
```

---

## Checklist de Domínio

- [ ] Sei criar tabelas com constraints (PK, FK, NOT NULL, UNIQUE, CHECK)
- [ ] Sei criar views para simplificar consultas complexas
- [ ] Sei a diferença entre tabela e view
- [ ] Domino INSERT único e múltiplo
- [ ] Sei usar INSERT SELECT para copiar dados
- [ ] Sei usar RETURNING para confirmar operações
- [ ] Sempre faço SELECT antes de UPDATE/DELETE
- [ ] Entendo a diferença entre DELETE, TRUNCATE e DROP
- [ ] Sei quando usar soft delete vs hard delete
- [ ] Sempre uso WHERE em UPDATE/DELETE (exceto quando intencional)
- [ ] Sei tratar conflitos com ON CONFLICT (UPSERT)
- [ ] Sempre faço backup antes de DROP

---

## Próximos Passos

1. **Pratique** todos os desafios de cada aula
2. **Experimente** criar suas próprias estruturas temporárias
3. **Crie** queries combinando CREATE, INSERT, UPDATE e DELETE

---

## Desafio Final do Módulo 15

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

### Contexto
Você é o analista de dados responsável por criar uma estrutura temporária para análise de uma campanha promocional do e-commerce. Precisa criar estruturas, popular dados, fazer ajustes e depois limpar tudo.

### Desafios

```sql
-- Desafio Final 1: Estrutura de Campanha
-- Crie uma tabela chamada "promocao_verao" com:
--   - promocao_id (PK, SERIAL)
--   - produto_id (FK para produtos)
--   - desconto_percentual (DECIMAL, entre 0 e 100)
--   - data_inicio (DATE)
--   - data_fim (DATE)
--   - ativo (BOOLEAN, default true)


-- Desafio Final 2: Popular Dados
-- Insira 5 produtos na promoção de uma vez
-- Escolha produtos reais da tabela produtos
-- Use descontos entre 10% e 50%


-- Desafio Final 3: Criar View de Análise
-- Crie uma view chamada vw_produtos_promocao que mostre:
--   - Nome do produto
--   - Preço original
--   - Desconto percentual
--   - Preço com desconto (calculado)
--   - Data início e fim da promoção


-- Desafio Final 4: Ajustes na Campanha
-- a) Aumente em 5% o desconto de produtos com preço acima de R$ 1000
-- b) Desative promoções que já passaram da data_fim


-- Desafio Final 5: Limpeza de Dados
-- a) Remova da promoção os produtos que estão sem estoque
-- b) Delete promoções inativas


-- Desafio Final 6 (Boss Final!): Encerramento Completo
-- A campanha acabou. Faça a limpeza completa:
-- a) Crie uma tabela de backup chamada "promocao_verao_historico"
-- b) Copie todos os dados da promocao_verao para o histórico
-- c) Drope a view vw_produtos_promocao
-- d) Drope a tabela promocao_verao
-- e) Confirme que o histórico foi salvo corretamente

```

### Dicas
- Use transações (BEGIN/COMMIT) para operações complexas
- Sempre faça SELECT antes de UPDATE/DELETE
- Use RETURNING para confirmar suas operações
- Lembre-se do IF EXISTS ao usar DROP

</details>

---

## Como Usar Este Material

1. Estude uma aula por vez
2. Leia todos os conceitos com atenção
3. Pratique os desafios antes de avançar
4. Revise os conceitos quando necessário
5. Use o resumo para consultas rápidas
