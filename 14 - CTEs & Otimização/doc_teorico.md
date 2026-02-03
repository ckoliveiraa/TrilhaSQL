# Módulo 14 - CTEs & Otimização - Material Didático

## Objetivo do Módulo
Dominar o uso de Common Table Expressions (CTEs) para escrever queries mais legíveis e organizadas, além de aprender técnicas básicas de otimização e análise de performance.

---
# AULA 63

<details>
<summary><strong>Expandir Aula 63</strong></summary>

## CTE - Common Table Expression (WITH)

## O que é?

Uma CTE (Common Table Expression) é uma **consulta temporária nomeada** que você define no início de uma query usando a cláusula `WITH`. Ela existe apenas durante a execução da query.

## Sintaxe

```sql
WITH nome_cte AS (
    SELECT ...
)
SELECT ... FROM nome_cte;
```

## Por que usar CTEs?

1. **Legibilidade**: Quebra queries complexas em partes nomeadas
2. **Reutilização**: Usa o mesmo resultado várias vezes na mesma query
3. **Organização**: Facilita manutenção e debugging
4. **Alternativa a subqueries**: Mais fácil de ler que subqueries aninhadas

## CTE vs Subquery

```sql
-- Subquery (mais difícil de ler)
SELECT * FROM (
    SELECT cliente_id, SUM(valor_total) AS total
    FROM pedidos
    GROUP BY cliente_id
) AS totais
WHERE total > 1000;

-- CTE (mais clara)
WITH totais_cliente AS (
    SELECT cliente_id, SUM(valor_total) AS total
    FROM pedidos
    GROUP BY cliente_id
)
SELECT * FROM totais_cliente
WHERE total > 1000;
```

## Exemplos Práticos

```sql
-- CTE simples: produtos mais vendidos
WITH produtos_vendidos AS (
    SELECT
        produto_id,
        SUM(quantidade) AS total_vendido
    FROM itens_pedido
    GROUP BY produto_id
)
SELECT
    p.nome,
    pv.total_vendido
FROM produtos p
INNER JOIN produtos_vendidos pv ON p.produto_id = pv.produto_id
ORDER BY pv.total_vendido DESC
LIMIT 10;
```

## Múltiplas CTEs

```sql
-- Usar várias CTEs na mesma query
WITH
vendas_por_cliente AS (
    SELECT
        cliente_id,
        COUNT(*) AS qtd_pedidos,
        SUM(valor_total) AS total_gasto
    FROM pedidos
    GROUP BY cliente_id
),
media_geral AS (
    SELECT AVG(total_gasto) AS media
    FROM vendas_por_cliente
)
SELECT
    c.nome,
    v.qtd_pedidos,
    v.total_gasto,
    m.media AS media_geral,
    CASE
        WHEN v.total_gasto > m.media THEN 'Acima da média'
        ELSE 'Abaixo da média'
    END AS classificacao
FROM clientes c
INNER JOIN vendas_por_cliente v ON c.cliente_id = v.cliente_id
CROSS JOIN media_geral m;
```

## CTEs que Referenciam Outras CTEs

```sql
WITH
-- Primeira CTE
vendas_mensais AS (
    SELECT
        EXTRACT(MONTH FROM data_pedido) AS mes,
        SUM(valor_total) AS total_mes
    FROM pedidos
    GROUP BY EXTRACT(MONTH FROM data_pedido)
),
-- Segunda CTE usa a primeira
vendas_com_media AS (
    SELECT
        mes,
        total_mes,
        AVG(total_mes) OVER () AS media_mensal
    FROM vendas_mensais
)
SELECT
    mes,
    total_mes,
    media_mensal,
    total_mes - media_mensal AS diferenca_media
FROM vendas_com_media
ORDER BY mes;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 63 - Desafio 1: Criar CTE com produtos mais vendidos e depois filtrar top 10
-- A CTE deve calcular o total vendido de cada produto


-- Aula 63 - Desafio 2: Criar CTE com resumo de clientes e calcular médias
-- Mostre clientes que gastaram acima da média geral

```

</details>

</details>

---

# AULA 64

<details>
<summary><strong>Expandir Aula 64</strong></summary>

## CTE Recursiva - Hierarquias

## O que é?

Uma **CTE Recursiva** é uma CTE que referencia a si mesma, permitindo trabalhar com **dados hierárquicos** ou gerar sequências.

## Sintaxe

```sql
WITH RECURSIVE nome_cte AS (
    -- Caso base (anchor)
    SELECT ...

    UNION ALL

    -- Caso recursivo (referencia a si mesma)
    SELECT ...
    FROM nome_cte
    WHERE condição_parada
)
SELECT * FROM nome_cte;
```

## Como Funciona?

```
1. Executa o caso base → resultado inicial
2. Executa o caso recursivo com o resultado anterior
3. Repete até não haver mais resultados
4. Combina tudo com UNION ALL
```

## Exemplo: Gerar Sequência de Números

```sql
-- Gerar números de 1 a 10
WITH RECURSIVE numeros AS (
    -- Caso base: começa com 1
    SELECT 1 AS n

    UNION ALL

    -- Caso recursivo: soma 1 ao anterior
    SELECT n + 1
    FROM numeros
    WHERE n < 10  -- Condição de parada
)
SELECT * FROM numeros;

-- Resultado: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
```

## Exemplo: Gerar Datas

```sql
-- Gerar todas as datas de janeiro de 2024
WITH RECURSIVE datas AS (
    SELECT DATE '2024-01-01' AS data

    UNION ALL

    SELECT data + INTERVAL '1 day'
    FROM datas
    WHERE data < '2024-01-31'
)
SELECT * FROM datas;
```

## Hierarquia de Categorias

```sql
-- Supondo uma tabela de categorias com subcategorias
-- categorias (categoria_id, nome, categoria_pai_id)

WITH RECURSIVE hierarquia AS (
    -- Caso base: categorias raiz (sem pai)
    SELECT
        categoria_id,
        nome,
        categoria_pai_id,
        1 AS nivel,
        nome AS caminho
    FROM categorias
    WHERE categoria_pai_id IS NULL

    UNION ALL

    -- Caso recursivo: subcategorias
    SELECT
        c.categoria_id,
        c.nome,
        c.categoria_pai_id,
        h.nivel + 1,
        h.caminho || ' > ' || c.nome
    FROM categorias c
    INNER JOIN hierarquia h ON c.categoria_pai_id = h.categoria_id
)
SELECT * FROM hierarquia
ORDER BY caminho;
```

## Árvore de Funcionários

```sql
-- Estrutura: funcionarios (id, nome, gerente_id)

WITH RECURSIVE organograma AS (
    -- CEO (sem gerente)
    SELECT
        id,
        nome,
        gerente_id,
        0 AS nivel,
        ARRAY[id] AS caminho
    FROM funcionarios
    WHERE gerente_id IS NULL

    UNION ALL

    -- Subordinados
    SELECT
        f.id,
        f.nome,
        f.gerente_id,
        o.nivel + 1,
        o.caminho || f.id
    FROM funcionarios f
    INNER JOIN organograma o ON f.gerente_id = o.id
)
SELECT
    REPEAT('  ', nivel) || nome AS organograma,
    nivel
FROM organograma
ORDER BY caminho;
```

## Cuidados com Recursão

```sql
-- ⚠️ SEMPRE tenha uma condição de parada!
-- Sem ela, a query roda infinitamente

-- ❌ ERRADO - sem condição de parada
WITH RECURSIVE infinito AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM infinito  -- Nunca para!
)
SELECT * FROM infinito;

-- ✅ CORRETO - com condição de parada
WITH RECURSIVE finito AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM finito WHERE n < 100  -- Para em 100
)
SELECT * FROM finito;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 64 - Desafio 1: Criar hierarquia de categorias (se houver subcategorias)
-- Use CTE recursiva para mostrar categorias e suas subcategorias


-- Aula 64 - Desafio 2: Gerar sequência de números de 1 a 100
-- Use CTE recursiva

```

</details>

</details>

---

# AULA 65

<details>
<summary><strong>Expandir Aula 65</strong></summary>

## Dicas de Performance e Otimização

## O que é EXPLAIN?

O comando `EXPLAIN` mostra o **plano de execução** de uma query, ajudando a entender como o PostgreSQL vai executá-la.

## Sintaxe

```sql
-- Ver plano de execução
EXPLAIN SELECT * FROM produtos WHERE preco > 100;

-- Ver plano com estatísticas reais (executa a query)
EXPLAIN ANALYZE SELECT * FROM produtos WHERE preco > 100;
```

## Lendo o EXPLAIN

```sql
EXPLAIN SELECT * FROM produtos WHERE preco > 100;

-- Resultado:
-- Seq Scan on produtos  (cost=0.00..15.00 rows=500 width=100)
--   Filter: (preco > 100)

-- Seq Scan = varredura sequencial (lê toda a tabela)
-- cost = custo estimado (início..fim)
-- rows = linhas estimadas
-- width = tamanho médio da linha em bytes
```

## Tipos de Scan

| Tipo | Descrição | Performance |
|------|-----------|-------------|
| Seq Scan | Lê toda a tabela | Lento para tabelas grandes |
| Index Scan | Usa índice | Rápido |
| Index Only Scan | Usa apenas o índice | Muito rápido |
| Bitmap Scan | Combina índices | Intermediário |

## Índices

```sql
-- Criar um índice
CREATE INDEX idx_produtos_preco ON produtos(preco);

-- Criar índice único
CREATE UNIQUE INDEX idx_clientes_email ON clientes(email);

-- Índice composto
CREATE INDEX idx_pedidos_cliente_data ON pedidos(cliente_id, data_pedido);

-- Remover índice
DROP INDEX idx_produtos_preco;
```

## Quando Criar Índices?

```
✅ Criar índice quando:
   - Coluna usada frequentemente em WHERE
   - Coluna usada em JOIN
   - Coluna usada em ORDER BY
   - Tabela grande com buscas específicas

❌ Evitar índice quando:
   - Tabelas pequenas
   - Colunas raramente consultadas
   - Tabelas com muitos INSERTs/UPDATEs (índices deixam escrita mais lenta)
```

## Comparando Performance

```sql
-- Sem índice
EXPLAIN ANALYZE
SELECT * FROM produtos WHERE marca = 'Samsung';
-- Seq Scan (lento)

-- Criar índice
CREATE INDEX idx_produtos_marca ON produtos(marca);

-- Com índice
EXPLAIN ANALYZE
SELECT * FROM produtos WHERE marca = 'Samsung';
-- Index Scan (rápido)
```

## Dicas de Otimização

### 1. Evite SELECT *

```sql
-- ❌ Ruim: traz todas as colunas
SELECT * FROM produtos;

-- ✅ Bom: traz apenas o necessário
SELECT nome, preco FROM produtos;
```

### 2. Use LIMIT

```sql
-- ❌ Traz tudo para mostrar 10
SELECT * FROM produtos ORDER BY preco;

-- ✅ Limita no banco
SELECT * FROM produtos ORDER BY preco LIMIT 10;
```

### 3. Filtre Cedo

```sql
-- ❌ Filtra depois do JOIN
SELECT * FROM produtos p
INNER JOIN itens_pedido ip ON p.produto_id = ip.produto_id
WHERE p.categoria_id = 1;

-- ✅ Filtra antes (mesma lógica, às vezes melhor)
-- O otimizador geralmente faz isso automaticamente
```

### 4. Evite Funções em WHERE

```sql
-- ❌ Não usa índice (aplica função em cada linha)
SELECT * FROM clientes WHERE LOWER(email) = 'joao@email.com';

-- ✅ Usa índice funcional ou padronize os dados
CREATE INDEX idx_clientes_email_lower ON clientes(LOWER(email));
-- Ou armazene sempre em minúsculas
```

### 5. Use EXISTS ao invés de IN para subqueries grandes

```sql
-- ❌ IN com subquery grande pode ser lento
SELECT * FROM clientes
WHERE cliente_id IN (SELECT cliente_id FROM pedidos);

-- ✅ EXISTS geralmente é mais rápido
SELECT * FROM clientes c
WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.cliente_id);
```

## VACUUM e ANALYZE

```sql
-- Atualiza estatísticas da tabela (ajuda o otimizador)
ANALYZE produtos;

-- Limpa espaço de registros deletados
VACUUM produtos;

-- Faz ambos
VACUUM ANALYZE produtos;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 65 - Desafio 1: Comparar tempo de execução de queries com e sem índice
-- Use EXPLAIN ANALYZE antes e depois de criar um índice


-- Aula 65 - Desafio 2: Otimizar uma query complexa usando EXPLAIN
-- Analise o plano de execução e sugira melhorias

```

</details>

</details>

---

## Resumo Rápido

| Conceito | O que faz | Exemplo |
|----------|-----------|---------|
| `WITH ... AS` | Define CTE | `WITH cte AS (SELECT ...)` |
| `WITH RECURSIVE` | CTE recursiva | Para hierarquias/sequências |
| `EXPLAIN` | Mostra plano de execução | `EXPLAIN SELECT ...` |
| `EXPLAIN ANALYZE` | Executa e mostra estatísticas | Tempo real |
| `CREATE INDEX` | Cria índice | `CREATE INDEX idx ON t(c)` |
| `VACUUM ANALYZE` | Otimiza tabela | `VACUUM ANALYZE tabela` |

---

## Checklist de Domínio

- [ ] Sei usar CTEs para organizar queries complexas
- [ ] Consigo usar múltiplas CTEs na mesma query
- [ ] Entendo o conceito de CTE recursiva
- [ ] Sei gerar sequências com recursão
- [ ] Consigo ler o resultado do EXPLAIN
- [ ] Sei criar índices para melhorar performance
- [ ] Entendo quando criar e quando não criar índices

---

## Conclusão do Curso

Parabéns! Você completou todos os módulos da Trilha SQL. Agora você domina:

1. **Fundamentos**: SELECT, FROM, WHERE, ORDER BY
2. **Filtros**: AND, OR, LIKE, IN, BETWEEN
3. **Funções de String**: CONCAT, UPPER, LOWER, SUBSTRING, TRIM
4. **Funções de Data**: EXTRACT, DATE_TRUNC, TO_CHAR
5. **Conversão**: CAST, COALESCE
6. **Condicionais**: CASE WHEN
7. **Agregação**: COUNT, SUM, AVG, MIN, MAX
8. **Agrupamento**: GROUP BY, HAVING
9. **JOINs**: INNER, LEFT, RIGHT, FULL
10. **Combinações**: UNION, INTERSECT, EXCEPT
11. **Subconsultas**: WHERE, FROM, SELECT, EXISTS
12. **DML**: INSERT, UPDATE, DELETE
13. **Window Functions**: ROW_NUMBER, RANK, LAG, LEAD
14. **CTEs e Otimização**: WITH, EXPLAIN, índices

---

## Desafio Final do Módulo 14

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

Use todos os conhecimentos adquiridos para resolver estes desafios avançados.

### Desafios

```sql
-- Desafio Final 1: CTE com Análise Completa
-- Crie uma CTE que calcule para cada cliente:
-- - Total de pedidos
-- - Valor total gasto
-- - Ticket médio
-- Depois use essa CTE para mostrar apenas os top 10 clientes


-- Desafio Final 2: CTE Recursiva de Datas
-- Gere todas as datas do último mês
-- Use essa lista para fazer um relatório de vendas diárias
-- (inclusive dias sem vendas, mostrando 0)


-- Desafio Final 3: Análise de Performance
-- Use EXPLAIN ANALYZE em diferentes versões da mesma query:
-- a) Query com subquery no WHERE
-- b) Mesma query com JOIN
-- c) Mesma query com CTE
-- Compare os planos de execução


-- Desafio Final 4 (Boss Final!): Dashboard Executivo
-- Crie um relatório completo usando CTEs que mostre:
-- - Resumo de vendas do mês atual
-- - Comparação com mês anterior (usando LAG)
-- - Top 5 produtos mais vendidos
-- - Top 5 clientes que mais compraram
-- - Taxa de crescimento

```

</details>

---

## Próximos Passos na sua Jornada SQL

1. **Pratique** com dados reais
2. **Explore** funções específicas do seu banco (PostgreSQL, MySQL, etc.)
3. **Aprenda** sobre modelagem de dados e normalização
4. **Estude** sobre transações e controle de concorrência
5. **Investigue** ferramentas de BI e relatórios

**Parabéns por completar a trilha!** 🎉
