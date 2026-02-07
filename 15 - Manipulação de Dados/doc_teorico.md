# Módulo 13 - Manipulação de Dados - Material Didático

## Objetivo do Módulo
Dominar os comandos DML (Data Manipulation Language) para inserir, atualizar e deletar dados de forma segura e eficiente.

---
# AULA 54

<details>
<summary><strong>Expandir Aula 54</strong></summary>

## INSERT - Inserindo Um Registro

## O que é?

O comando `INSERT` adiciona **novos registros** em uma tabela do banco de dados.

## Sintaxe

```sql
-- Especificando as colunas (recomendado)
INSERT INTO tabela (coluna1, coluna2, coluna3)
VALUES (valor1, valor2, valor3);

-- Inserindo em todas as colunas (na ordem da tabela)
INSERT INTO tabela
VALUES (valor1, valor2, valor3, ...);
```

## Exemplos Práticos

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

## Valores Automáticos

```sql
-- Colunas com DEFAULT ou SERIAL são preenchidas automaticamente
INSERT INTO pedidos (cliente_id, valor_total, status)
VALUES (1, 500.00, 'pendente');
-- pedido_id é gerado automaticamente (SERIAL)
-- data_pedido pode ter DEFAULT CURRENT_DATE
```

## Retornando o ID Inserido

```sql
-- RETURNING retorna os valores inseridos
INSERT INTO produtos (nome, preco, estoque, marca, categoria_id)
VALUES ('Novo Produto', 99.90, 100, 'Marca X', 1)
RETURNING produto_id;

-- Retornar múltiplas colunas
INSERT INTO clientes (nome, email, cidade, estado)
VALUES ('Ana Costa', 'ana@email.com', 'Curitiba', 'PR')
RETURNING cliente_id, nome;
```

## Boas Práticas

```sql
-- ✅ Sempre especifique as colunas
INSERT INTO produtos (nome, preco, estoque)
VALUES ('Produto', 99.90, 10);

-- ❌ Evite inserir sem especificar colunas
INSERT INTO produtos
VALUES (DEFAULT, 'Produto', 99.90, 10, NULL, NULL, NULL);
-- Frágil: quebra se a estrutura da tabela mudar
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 54 - Desafio 1: Adicionar um novo produto na tabela
-- Insira um produto com: nome, preco, estoque, marca e categoria_id


-- Aula 54 - Desafio 2: Adicionar um novo cliente
-- Insira um cliente com: nome, email, telefone, cidade e estado

```

</details>

</details>

---

# AULA 55

<details>
<summary><strong>Expandir Aula 55</strong></summary>

## INSERT - Inserindo Múltiplos Registros

## O que é?

O comando `INSERT` pode adicionar **múltiplos registros de uma vez**, o que é mais eficiente do que inserir um por um.

## Sintaxe

```sql
INSERT INTO tabela (coluna1, coluna2, coluna3)
VALUES
    (valor1a, valor2a, valor3a),
    (valor1b, valor2b, valor3b),
    (valor1c, valor2c, valor3c);
```

## Exemplos Práticos

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

## INSERT SELECT - Inserindo a partir de uma consulta

```sql
-- Copiar dados de outra tabela
INSERT INTO produtos_backup (nome, preco, estoque)
SELECT nome, preco, estoque FROM produtos;

-- Inserir com filtro
INSERT INTO clientes_vip (cliente_id, nome, total_gasto)
SELECT c.cliente_id, c.nome, SUM(p.valor_total)
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome
HAVING SUM(p.valor_total) > 10000;
```

## Performance

```sql
-- ❌ Lento: múltiplos INSERTs individuais
INSERT INTO produtos (nome, preco) VALUES ('Produto 1', 10.00);
INSERT INTO produtos (nome, preco) VALUES ('Produto 2', 20.00);
INSERT INTO produtos (nome, preco) VALUES ('Produto 3', 30.00);
-- 3 transações separadas

-- ✅ Rápido: um INSERT com múltiplos valores
INSERT INTO produtos (nome, preco) VALUES
    ('Produto 1', 10.00),
    ('Produto 2', 20.00),
    ('Produto 3', 30.00);
-- 1 transação
```

## Tratando Conflitos

```sql
-- ON CONFLICT - atualiza se já existir (UPSERT)
INSERT INTO produtos (produto_id, nome, preco, estoque)
VALUES (1, 'Produto Atualizado', 150.00, 75)
ON CONFLICT (produto_id)
DO UPDATE SET
    nome = EXCLUDED.nome,
    preco = EXCLUDED.preco,
    estoque = EXCLUDED.estoque;

-- ON CONFLICT - ignorar se já existir
INSERT INTO produtos (codigo, nome, preco)
VALUES ('ABC123', 'Novo Produto', 99.90)
ON CONFLICT (codigo) DO NOTHING;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 55 - Desafio 1: Adicionar 3 novos produtos de uma vez
-- Use um único comando INSERT


-- Aula 55 - Desafio 2: Adicionar 5 novos clientes de uma vez
-- Use um único comando INSERT com dados fictícios

```

</details>

</details>

---

# AULA 56

<details>
<summary><strong>Expandir Aula 56</strong></summary>

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

-- Atualizar estoque de um produto
UPDATE produtos
SET estoque = estoque + 100
WHERE produto_id = 15;
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

-- Diminuir estoque
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

-- Atualizar com valor de outra tabela
UPDATE pedidos p
SET valor_total = (
    SELECT SUM(quantidade * preco_unitario)
    FROM itens_pedido ip
    WHERE ip.pedido_id = p.pedido_id
);
```

## Verificando Antes de Atualizar

```sql
-- 1. Primeiro, veja o que será afetado
SELECT * FROM produtos
WHERE marca = 'Samsung';

-- 2. Se estiver correto, faça o UPDATE
UPDATE produtos
SET preco = preco * 1.10
WHERE marca = 'Samsung';
```

## RETURNING - Ver o resultado

```sql
-- Ver os registros atualizados
UPDATE produtos
SET preco = preco * 1.10
WHERE marca = 'Apple'
RETURNING produto_id, nome, preco;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 56 - Desafio 1: Aumentar em 10% o preço de todos os produtos da categoria "Eletrônicos"
-- Dica: Use subconsulta ou JOIN para identificar a categoria


-- Aula 56 - Desafio 2: Atualizar o estoque de um produto específico
-- Adicione 50 unidades ao estoque do produto com ID 1

```

</details>

</details>

---

# AULA 57

<details>
<summary><strong>Expandir Aula 57</strong></summary>

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
WHERE estoque = 0;

-- Remover clientes inativos
DELETE FROM clientes
WHERE ultimo_acesso < '2020-01-01';
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
```

## RETURNING - Confirmar o que foi deletado

```sql
-- Ver os registros removidos
DELETE FROM produtos
WHERE estoque = 0
RETURNING produto_id, nome;
```

## Integridade Referencial

```sql
-- Se houver FK (chave estrangeira), pode dar erro
DELETE FROM categorias WHERE categoria_id = 1;
-- ERRO: produtos depende de categorias

-- Opções:
-- 1. Deletar os registros dependentes primeiro
DELETE FROM produtos WHERE categoria_id = 1;
DELETE FROM categorias WHERE categoria_id = 1;

-- 2. Usar CASCADE (se configurado na FK)
-- 3. Atualizar os registros dependentes para NULL
```

## TRUNCATE - Limpar tabela completa

```sql
-- Remove TODOS os registros (mais rápido que DELETE)
TRUNCATE TABLE tabela_temporaria;

-- Com RESTART IDENTITY (reinicia sequências)
TRUNCATE TABLE tabela_temporaria RESTART IDENTITY;

-- ⚠️ TRUNCATE não pode ter WHERE!
```

## Boas Práticas para DELETE

```
1. SEMPRE faça SELECT primeiro
2. SEMPRE use WHERE (exceto TRUNCATE)
3. Faça backup antes de operações em massa
4. Use RETURNING para confirmar
5. Considere usar "soft delete" (marcar como inativo)
```

## Soft Delete vs Hard Delete

```sql
-- Hard Delete (remove de verdade)
DELETE FROM clientes WHERE cliente_id = 5;

-- Soft Delete (apenas marca como inativo)
UPDATE clientes SET ativo = false WHERE cliente_id = 5;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 57 - Desafio 1: Remover produtos com estoque zerado
-- PRIMEIRO faça um SELECT para verificar, depois DELETE


-- Aula 57 - Desafio 2: Remover clientes que nunca fizeram pedidos
-- Use WHERE com subquery ou NOT EXISTS

```

</details>

</details>

---

## Resumo Rápido

| Comando | O que faz | Exemplo |
|---------|-----------|---------|
| `INSERT` | Adiciona registros | `INSERT INTO t (c) VALUES (v)` |
| `INSERT múltiplo` | Adiciona vários de uma vez | `VALUES (v1), (v2), (v3)` |
| `UPDATE` | Modifica registros | `UPDATE t SET c = v WHERE ...` |
| `DELETE` | Remove registros | `DELETE FROM t WHERE ...` |
| `TRUNCATE` | Limpa tabela inteira | `TRUNCATE TABLE t` |

---

## Checklist de Segurança DML

```
✅ Antes de UPDATE/DELETE:
   [ ] Fiz SELECT para verificar os registros afetados?
   [ ] A cláusula WHERE está correta?
   [ ] Tenho backup dos dados?

✅ Ao fazer INSERT:
   [ ] Especifiquei as colunas?
   [ ] Os tipos de dados estão corretos?
   [ ] Tratei possíveis conflitos?

⚠️ NUNCA:
   [ ] Rodar UPDATE sem WHERE (exceto intencionalmente)
   [ ] Rodar DELETE sem WHERE (exceto intencionalmente)
   [ ] Fazer operações em massa sem backup
```

---

## Próximos Passos

No próximo módulo, você aprenderá sobre:
- Window Functions (ROW_NUMBER, RANK, LEAD, LAG)

---

## Desafio Final do Módulo 13

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

Pratique operações DML de forma segura.

### Desafios

```sql
-- Desafio Final 1: Cadastro em Massa
-- Insira 3 novos produtos e 3 novos clientes
-- Use INSERTs com múltiplos valores


-- Desafio Final 2: Atualização Condicional
-- a) Aumente em 5% o preço de produtos com estoque > 100
-- b) Diminua em 10% o preço de produtos sem vendas nos últimos 30 dias


-- Desafio Final 3: Limpeza Segura
-- Remova itens de pedido de pedidos cancelados
-- Primeiro: SELECT para verificar
-- Depois: DELETE com a mesma condição


-- Desafio Final 4 (Boss Final!): Operação Completa
-- Cenário: Fim de um produto
-- a) Transfira o estoque do produto ID 5 para o produto ID 10 (UPDATE)
-- b) Atualize itens_pedido para usar o novo produto_id (UPDATE)
-- c) Delete o produto antigo (DELETE)
-- Faça tudo verificando antes com SELECT

```

</details>
