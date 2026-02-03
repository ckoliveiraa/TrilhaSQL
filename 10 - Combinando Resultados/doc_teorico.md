# Módulo 10 - Combinando Resultados - Material Didático

## Objetivo do Módulo
Dominar os operadores de conjunto em SQL (UNION, UNION ALL, INTERSECT, EXCEPT) para combinar resultados de múltiplas consultas em um único resultado.

---
# AULA 48

<details>
<summary><strong>Expandir Aula 48</strong></summary>

## UNION - Combinando Queries (sem duplicatas)

## O que é?

O operador `UNION` combina os resultados de duas ou mais consultas SELECT, **removendo duplicatas automaticamente**.

## Sintaxe

```sql
SELECT coluna1, coluna2 FROM tabela1
UNION
SELECT coluna1, coluna2 FROM tabela2;
```

## Regras Importantes

1. **Mesmo número de colunas**: Todas as consultas devem selecionar o mesmo número de colunas
2. **Tipos compatíveis**: As colunas correspondentes devem ter tipos de dados compatíveis
3. **Ordem das colunas**: A ordem das colunas deve ser a mesma em todas as consultas
4. **Nomes das colunas**: O resultado usa os nomes da primeira consulta

## Como Funciona?

```
Query 1:        Query 2:         UNION:
┌───────┐       ┌───────┐        ┌───────┐
│ João  │       │ Maria │        │ João  │
│ Maria │       │ Pedro │   →    │ Maria │ (duplicata removida)
│ Ana   │       │ Ana   │        │ Ana   │ (duplicata removida)
└───────┘       └───────┘        │ Pedro │
                                 └───────┘
```

## Exemplos Práticos

```sql
-- Combinar nomes de clientes e funcionários (sem repetir)
SELECT nome FROM clientes
UNION
SELECT nome FROM funcionarios;

-- Lista única de cidades (clientes e fornecedores)
SELECT cidade FROM clientes
UNION
SELECT cidade FROM fornecedores;

-- Combinar marcas de diferentes categorias
SELECT DISTINCT marca FROM produtos WHERE categoria_id = 1
UNION
SELECT DISTINCT marca FROM produtos WHERE categoria_id = 2;
```

## Adicionando Identificação de Origem

```sql
-- Saber de onde veio cada registro
SELECT nome, 'Cliente' AS origem FROM clientes
UNION
SELECT nome, 'Funcionário' AS origem FROM funcionarios;
```

Resultado:
```
| nome    | origem      |
|---------|-------------|
| João    | Cliente     |
| Maria   | Funcionário |
| Ana     | Cliente     |
```

## UNION com Múltiplas Tabelas

```sql
-- Combinar três fontes
SELECT email FROM clientes
UNION
SELECT email FROM funcionarios
UNION
SELECT email FROM fornecedores;
```

## Ordenando Resultados

```sql
-- ORDER BY vai no final de tudo
SELECT nome FROM clientes
UNION
SELECT nome FROM funcionarios
ORDER BY nome;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 48 - Desafio 1: Criar lista única de todas as marcas de produtos e nomes de categorias
-- Combine em uma única lista, sem duplicatas


-- Aula 48 - Desafio 2: Listar todas as cidades onde temos clientes
-- Crie uma lista única de cidades (sem repetição)

```

</details>

</details>

---

# AULA 49

<details>
<summary><strong>Expandir Aula 49</strong></summary>

## UNION ALL - Combinando Queries (com duplicatas)

## O que é?

O operador `UNION ALL` combina os resultados de duas ou mais consultas SELECT, **mantendo todas as duplicatas**.

## Sintaxe

```sql
SELECT coluna1, coluna2 FROM tabela1
UNION ALL
SELECT coluna1, coluna2 FROM tabela2;
```

## UNION vs UNION ALL

```
Query 1:        Query 2:         UNION:          UNION ALL:
┌───────┐       ┌───────┐        ┌───────┐       ┌───────┐
│ João  │       │ Maria │        │ João  │       │ João  │
│ Maria │       │ Pedro │   →    │ Maria │       │ Maria │
│ Ana   │       │ Ana   │        │ Ana   │       │ Ana   │
└───────┘       └───────┘        │ Pedro │       │ Maria │
                                 └───────┘       │ Pedro │
                                                 │ Ana   │
                                                 └───────┘
                                 4 registros     6 registros
```

## Quando usar UNION ALL?

- Quando você **sabe que não haverá duplicatas** (ou quer manter as duplicatas)
- Quando **performance é importante** (UNION ALL é mais rápido pois não precisa comparar registros)
- Para **histórico completo** de eventos

## Exemplos Práticos

```sql
-- Histórico completo de todas as transações
SELECT data, valor, 'Pedido' AS tipo FROM pedidos
UNION ALL
SELECT data, valor, 'Pagamento' AS tipo FROM pagamentos;

-- Todas as ações do cliente (incluindo repetições)
SELECT cliente_id, data_pedido AS data, 'Pedido' AS acao FROM pedidos
UNION ALL
SELECT cliente_id, data_pagamento AS data, 'Pagamento' AS acao FROM pagamentos;
```

## Performance: UNION vs UNION ALL

```sql
-- UNION (mais lento - precisa verificar duplicatas)
SELECT nome FROM clientes      -- 10.000 registros
UNION
SELECT nome FROM funcionarios; -- 1.000 registros
-- Tempo: precisa comparar 11.000 registros

-- UNION ALL (mais rápido - apenas concatena)
SELECT nome FROM clientes      -- 10.000 registros
UNION ALL
SELECT nome FROM funcionarios; -- 1.000 registros
-- Tempo: apenas junta os resultados
```

## Contando com UNION ALL

```sql
-- Contar total de registros combinados
SELECT COUNT(*) FROM (
    SELECT pedido_id FROM pedidos
    UNION ALL
    SELECT pagamento_id FROM pagamentos
) AS combinado;

-- Relatório de totais
SELECT 'Pedidos' AS tipo, COUNT(*) AS total FROM pedidos
UNION ALL
SELECT 'Pagamentos' AS tipo, COUNT(*) AS total FROM pagamentos
UNION ALL
SELECT 'Clientes' AS tipo, COUNT(*) AS total FROM clientes;
```

## Outros Operadores de Conjunto

### INTERSECT - Apenas registros em comum

```sql
-- Clientes que também são funcionários (mesmo nome)
SELECT nome FROM clientes
INTERSECT
SELECT nome FROM funcionarios;
```

### EXCEPT - Registros da primeira que não estão na segunda

```sql
-- Clientes que NÃO são funcionários
SELECT nome FROM clientes
EXCEPT
SELECT nome FROM funcionarios;
```

## Resumo Visual

```
UNION:      A ∪ B (sem duplicatas)
UNION ALL:  A + B (com duplicatas)
INTERSECT:  A ∩ B (apenas em comum)
EXCEPT:     A - B (apenas em A)
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 49 - Desafio 1: Listar todos os nomes (produtos e clientes), permitindo repetição
-- Use UNION ALL para manter duplicatas


-- Aula 49 - Desafio 2: Criar histórico completo de ações
-- Combine pedidos e pagamentos em uma linha do tempo
-- Inclua: data, valor, tipo de ação

```

</details>

</details>

---

## Resumo Rápido

| Operador | O que faz | Duplicatas |
|----------|-----------|------------|
| `UNION` | Combina resultados | Remove |
| `UNION ALL` | Combina resultados | Mantém |
| `INTERSECT` | Registros em comum | Remove |
| `EXCEPT` | Registros exclusivos da primeira query | Remove |

---

## Regras para Operadores de Conjunto

```
✅ Mesma quantidade de colunas
✅ Tipos de dados compatíveis
✅ ORDER BY no final de tudo
✅ Nomes de coluna vêm da primeira query
❌ Não misturar tipos incompatíveis
❌ Não usar ORDER BY entre as queries
```

---

## Checklist de Domínio

- [ ] Sei usar UNION para combinar resultados sem duplicatas
- [ ] Entendo quando usar UNION ALL para melhor performance
- [ ] Sei adicionar coluna de identificação de origem
- [ ] Consigo combinar mais de duas queries
- [ ] Entendo a diferença entre UNION, INTERSECT e EXCEPT
- [ ] Sei ordenar resultados combinados com ORDER BY

---

## Próximos Passos

No próximo módulo, você aprenderá sobre:
- Subconsultas no WHERE, FROM e SELECT
- EXISTS e NOT EXISTS

---

## Desafio Final do Módulo 10

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

Use seus conhecimentos de operadores de conjunto para resolver estes desafios.

### Desafios

```sql
-- Desafio Final 1: Lista Unificada de Contatos
-- Crie uma lista única com:
-- - nome
-- - tipo ('Cliente' ou 'Outro')
-- De clientes. Não deve haver nomes duplicados.


-- Desafio Final 2: Histórico Completo de Transações
-- Combine pedidos e pagamentos em uma timeline:
-- - data da transação
-- - valor
-- - tipo ('Pedido' ou 'Pagamento')
-- - identificador (pedido_id ou pagamento_id)
-- Ordene por data


-- Desafio Final 3: Relatório de Totais
-- Mostre um resumo com:
-- - Total de produtos
-- - Total de clientes
-- - Total de pedidos
-- - Total de pagamentos
-- Cada linha deve ter: tipo e quantidade


-- Desafio Final 4 (Boss Final!): Análise de Sobreposição
-- Descubra:
-- a) Quantas marcas diferentes existem nos produtos
-- b) Quantas categorias diferentes existem
-- c) Crie uma lista combinada de todas as marcas e nomes de categorias (UNION)
-- d) Se houvesse uma tabela de marcas preferidas do cliente,
--    como você encontraria marcas que existem em produtos
--    E na lista de preferidas? (use INTERSECT conceitualmente)

```

</details>
