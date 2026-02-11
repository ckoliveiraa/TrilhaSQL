# Módulo 14 - CTEs - Material Didático

## Objetivo do Módulo
Dominar o uso de Common Table Expressions (CTEs) para escrever queries mais legíveis e organizadas, incluindo CTEs recursivas para trabalhar com hierarquias e sequências.

---
# AULA 59

<details>
<summary><strong>Expandir Aula 59</strong></summary>

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
-- CTE simples: clientes com maior valor de compras
WITH valor_por_cliente AS (
    SELECT
        cliente_id,
        COUNT(*) AS total_pedidos,
        SUM(valor_total) AS valor_gasto
    FROM pedidos
    WHERE status = 'entregue'
    GROUP BY cliente_id
)
SELECT
    c.nome,
    c.email,
    vpc.total_pedidos,
    vpc.valor_gasto
FROM clientes c
INNER JOIN valor_por_cliente vpc ON c.cliente_id = vpc.cliente_id
ORDER BY vpc.valor_gasto DESC
LIMIT 10;
```

## Múltiplas CTEs

```sql
-- Usar várias CTEs na mesma query
WITH
vendas_por_categoria AS (
    SELECT
        cat.categoria_id,
        cat.nome AS categoria,
        COUNT(DISTINCT p.pedido_id) AS qtd_pedidos,
        SUM(ip.quantidade * ip.preco_unitario) AS receita_total
    FROM categorias cat
    INNER JOIN produtos prod ON cat.categoria_id = prod.categoria_id
    INNER JOIN itens_pedido ip ON prod.produto_id = ip.produto_id
    INNER JOIN pedidos p ON ip.pedido_id = p.pedido_id
    GROUP BY cat.categoria_id, cat.nome
),
top_categorias AS (
    SELECT
        categoria,
        receita_total,
        ROW_NUMBER() OVER (ORDER BY receita_total DESC) AS ranking
    FROM vendas_por_categoria
)
SELECT
    categoria,
    receita_total,
    ranking
FROM top_categorias
WHERE ranking <= 5
ORDER BY ranking;
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
-- Aula 59 - Desafio 1: Ranking de Produtos Mais Vendidos
-- A gerência quer saber quais são os 10 produtos campeões de vendas.
-- Crie uma consulta usando CTE que mostre o ranking dos 10 produtos
-- mais vendidos, incluindo o nome do produto e a quantidade total vendida.


-- Aula 59 - Desafio 2: Identificando Clientes VIP
-- O departamento de marketing precisa identificar os clientes VIP
-- para criar uma campanha especial.
-- Crie uma consulta com CTEs que mostre apenas os clientes que gastaram
-- ACIMA DA MÉDIA GERAL de todos os clientes. O relatório deve incluir:
-- nome, quantidade de pedidos, total gasto, média geral e diferença para a média.

```

</details>

</details>

---

# AULA 60

<details>
<summary><strong>Expandir Aula 60</strong></summary>

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
-- Aula 60 - Desafio 1: Gerador de Sequências
-- Você precisa gerar uma lista com os números de 1 a 100.
-- Use uma CTE recursiva para criar essa sequência.
-- Lembre-se: toda recursão precisa de um ponto de partida,
-- uma regra de repetição e uma condição de parada.


-- Aula 60 - Desafio 2: Relatório de Vendas Diárias Completo
-- O diretor financeiro precisa de um relatório de vendas que mostre
-- TODOS OS DIAS de janeiro de 2024, mesmo os dias que não tiveram vendas.
-- Use CTE recursiva para gerar um calendário completo do mês e combine
-- com os dados de vendas. Mostre: data, dia da semana, total de vendas
-- e quantidade de pedidos (use 0 para dias sem vendas).

```

</details>

</details>

---

## Resumo Rápido

| Conceito | O que faz | Exemplo |
|----------|-----------|---------|
| `WITH ... AS` | Define CTE simples | `WITH cte AS (SELECT ...)` |
| `WITH RECURSIVE` | CTE recursiva | Para hierarquias/sequências |
| Múltiplas CTEs | Define várias CTEs | `WITH cte1 AS (...), cte2 AS (...)` |
| CTE Encadeadas | CTE que referencia outra | Segunda CTE usa resultado da primeira |

---

## Checklist de Domínio

- [ ] Sei usar CTEs para organizar queries complexas
- [ ] Consigo usar múltiplas CTEs na mesma query
- [ ] Entendo como CTEs podem referenciar outras CTEs
- [ ] Entendo o conceito de CTE recursiva
- [ ] Sei gerar sequências de números com recursão
- [ ] Sei gerar sequências de datas com recursão
- [ ] Consigo trabalhar com hierarquias usando CTEs recursivas

---

## Desafio Final do Módulo 14

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

### Contexto
Você é o analista de dados do e-commerce e precisa criar relatórios complexos usando CTEs para facilitar a leitura e manutenção das queries. Os relatórios serão usados pela diretoria para tomada de decisão.

### Desafios

```sql
-- =================================================================
-- DESAFIO FINAL 1: CTE COM ANÁLISE COMPLETA DE CLIENTES
-- =================================================================
-- Objetivo: Identificar os 10 clientes mais valiosos da empresa
--
-- Passo 1: Crie uma CTE chamada 'resumo_clientes' que calcule para cada cliente:
--   - cliente_id
--   - nome do cliente
--   - total_pedidos (COUNT de pedidos)
--   - valor_total_gasto (SUM de valor_total dos pedidos)
--   - ticket_medio (ROUND da média de valor_total, 2 decimais)
--   Dica: Use INNER JOIN entre clientes e pedidos, agrupe por cliente_id e nome
--
-- Passo 2: Use essa CTE no SELECT principal para:
--   - Selecionar as colunas: nome AS cliente, total_pedidos, valor_total_gasto, ticket_medio
--   - Ordenar por valor_total_gasto decrescente
--   - Limitar aos TOP 10
--
-- Resultado esperado: 10 linhas com os clientes que mais gastaram


-- =================================================================
-- DESAFIO FINAL 2: CTE RECURSIVA DE DATAS
-- =================================================================
-- Objetivo: Criar um relatório de vendas diárias completo, incluindo dias sem vendas
--
-- Passo 1: Crie uma CTE chamada 'mes_referencia' que define:
--   - primeiro_dia: DATE '2025-12-01'
--   - ultimo_dia: DATE '2025-12-31'
--
-- Passo 2: Crie uma CTE RECURSIVA chamada 'datas_mes' que:
--   - Caso base: SELECT primeiro_dia AS data FROM mes_referencia
--   - Caso recursivo: SELECT data + INTERVAL '1 day' FROM datas_mes
--   - Condição de parada: WHERE data < mes_referencia.ultimo_dia
--   Dica: Use CROSS JOIN com mes_referencia no caso recursivo para acessar ultimo_dia
--
-- Passo 3: Crie uma CTE chamada 'vendas_diarias' que calcule:
--   - data (CAST de data_pedido como DATE)
--   - total_vendas (SUM de valor_total)
--   - qtd_pedidos (COUNT)
--   - Filtre apenas pedidos de dezembro/2025
--   - Agrupe por data
--
-- Passo 4: No SELECT principal:
--   - LEFT JOIN datas_mes com vendas_diarias
--   - Use COALESCE para mostrar 0 quando não houver vendas
--   - Ordene por data
--
-- Resultado esperado: 31 linhas (todos os dias de dezembro), com 0 nos dias sem vendas


-- =================================================================
-- DESAFIO FINAL 3: MÚLTIPLAS CTES ENCADEADAS
-- =================================================================
-- Objetivo: Identificar produtos com desempenho acima da média usando CTEs encadeadas
--
-- Passo 1: Crie CTE 'vendas_por_produto' que calcule:
--   - produto_id, nome
--   - total_vendido (SUM de quantidade dos itens_pedido)
--   - receita_total (SUM de quantidade * preco_unitario)
--   Dica: JOIN produtos com itens_pedido, agrupe por produto_id e nome
--
-- Passo 2: Crie CTE 'media_vendas' que calcule:
--   - media_qtd (AVG de total_vendido da CTE anterior)
--   - media_receita (AVG de receita_total da CTE anterior)
--   Dica: Essa CTE usa vendas_por_produto
--
-- Passo 3: Crie CTE 'produtos_acima_media' que:
--   - Selecione todos os campos de vendas_por_produto
--   - Adicione as médias da CTE media_vendas (use CROSS JOIN)
--   - Calcule perc_acima_media_qtd: ((total_vendido - media_qtd) / media_qtd * 100)
--   - Calcule perc_acima_media_receita: ((receita_total - media_receita) / media_receita * 100)
--   - Filtre WHERE total_vendido > media_qtd OR receita_total > media_receita
--
-- Passo 4: No SELECT principal:
--   - Selecione: nome, total_vendido, receita_total, médias e percentuais
--   - Use ROUND para formatar decimais
--   - Ordene por receita_total DESC
--
-- Resultado esperado: Produtos que performaram acima da média


-- =================================================================
-- DESAFIO FINAL 4 (BOSS FINAL!): DASHBOARD EXECUTIVO
-- =================================================================
-- Objetivo: Criar um dashboard executivo completo com comparações e rankings
--
-- Passo 1: CTE 'mes_referencia'
--   - Encontre o mês mais recente: DATE_TRUNC('month', MAX(data_pedido))
--   - CAST como DATE e nomeie como 'ultimo_mes'
--
-- Passo 2: CTE 'vendas_mensais'
--   - Calcule para cada mês dos últimos 3 meses:
--     - mes (DATE_TRUNC de data_pedido)
--     - total_pedidos (COUNT)
--     - total_vendas (SUM de valor_total)
--     - ticket_medio (AVG de valor_total, arredondado)
--   - Filtre WHERE data_pedido >= (ultimo_mes - 2 meses)
--
-- Passo 3: CTE 'comparacao_mensal'
--   - Selecione todas as colunas de vendas_mensais
--   - Adicione vendas_mes_anterior: LAG(total_vendas) OVER (ORDER BY mes)
--   - Calcule taxa_crescimento: 100 * (total_vendas - vendas_mes_anterior) / vendas_mes_anterior
--   - Use NULLIF para evitar divisão por zero
--
-- Passo 4: CTE 'top_produtos'
--   - Calcule para o último mês:
--     - nome do produto
--     - total_vendido (SUM de quantidade)
--     - receita (SUM de quantidade * preco_unitario)
--   - Filtre apenas pedidos do último mês
--   - LIMIT 5
--
-- Passo 5: CTE 'top_clientes'
--   - Calcule para o último mês:
--     - nome do cliente
--     - qtd_pedidos (COUNT)
--     - total_gasto (SUM de valor_total)
--   - Filtre apenas pedidos do último mês
--   - LIMIT 5
--
-- Passo 6: SELECT principal - Combine tudo com UNION ALL
--   - Seção 1: RESUMO MENSAL (da comparacao_mensal do último mês)
--   - Seção 2: TOP 5 PRODUTOS (da top_produtos)
--   - Seção 3: TOP 5 CLIENTES (da top_clientes)
--   Dica: Use CAST(...AS TEXT) para padronizar colunas no UNION ALL
--
-- Resultado esperado: 1 linha de resumo + 5 produtos + 5 clientes = 11 linhas
--
-- DICA EXTRA: Este é o desafio mais complexo! Construa uma CTE por vez e teste antes de avançar.

```

### Dicas Gerais

1. **Teste incrementalmente**: Construa uma CTE por vez e teste com `SELECT * FROM nome_cte`
2. **Use comentários**: Documente cada CTE para facilitar a manutenção
3. **Formatação**: Quebre linhas longas para melhor legibilidade
4. **COALESCE**: Use para lidar com NULLs em LEFT JOINs e divisões
5. **CAST**: Use para converter tipos quando necessário (especialmente em UNION ALL)
6. **Window Functions**: Combine com CTEs para análises poderosas (LAG, LEAD, etc.)

</details>

---

## Próximos Passos na sua Jornada SQL

1. **Pratique** com dados reais do seu dia a dia
2. **Explore** funções específicas do seu banco (PostgreSQL, MySQL, etc.)
3. **Aprenda** sobre modelagem de dados e normalização
4. **Estude** sobre otimização de queries (EXPLAIN, índices)
5. **Investigue** sobre transações e controle de concorrência
6. **Explore** ferramentas de BI e relatórios

**Parabéns por completar a trilha!** 🎉
