# Módulo 13 - Window Functions - Material Didático

## Objetivo do Módulo
Dominar as funções de janela (Window Functions) em SQL, que permitem realizar cálculos em grupos de linhas relacionadas sem agrupar os resultados, mantendo o detalhe de cada registro.

---
# AULA 58

<details>
<summary><strong>Expandir Aula 58</strong></summary>

## ROW_NUMBER - Numerando Linhas

## O que é?

A função `ROW_NUMBER()` atribui um **número sequencial único** a cada linha do resultado, começando em 1.

## Sintaxe

```sql
ROW_NUMBER() OVER (ORDER BY coluna)
```

## Window Functions vs Agregação

```
GROUP BY (Agregação):           Window Functions:
┌────────┬────────┐             ┌────────┬────────┬─────┐
│ Grupo  │ Total  │             │ Linha  │ Valor  │ Num │
├────────┼────────┤             ├────────┼────────┼─────┤
│ A      │ 300    │             │ A      │ 100    │ 1   │
│ B      │ 200    │             │ A      │ 200    │ 2   │
└────────┴────────┘             │ B      │ 150    │ 3   │
Perde os detalhes!              │ B      │ 50     │ 4   │
                                └────────┴────────┴─────┘
                                Mantém os detalhes!
```

## Exemplos Práticos

```sql
-- Numerar todos os produtos ordenados por preço
SELECT
    ROW_NUMBER() OVER (ORDER BY preco DESC) AS ranking,
    nome,
    preco
FROM produtos;

-- Resultado:
-- | ranking | nome          | preco   |
-- |---------|---------------|---------|
-- | 1       | iPhone 15     | 8999.00 |
-- | 2       | MacBook Pro   | 7999.00 |
-- | 3       | Samsung S24   | 5999.00 |
```

## Ordenação Diferente

```sql
-- Numerar por preço crescente
SELECT
    ROW_NUMBER() OVER (ORDER BY preco ASC) AS num,
    nome,
    preco
FROM produtos;

-- Numerar por nome alfabético
SELECT
    ROW_NUMBER() OVER (ORDER BY nome) AS num,
    nome,
    preco
FROM produtos;
```

## Uso Prático: Paginação

```sql
-- Pegar apenas os registros 11 a 20 (página 2)
SELECT * FROM (
    SELECT
        ROW_NUMBER() OVER (ORDER BY produto_id) AS num,
        nome,
        preco
    FROM produtos
) AS numerado
WHERE num BETWEEN 11 AND 20;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 58 - Desafio 1: Numerar produtos ordenados por preço (do mais caro ao mais barato)
-- Exiba: número, nome e preço


-- Aula 58 - Desafio 2: Numerar pedidos de cada cliente por data
-- Exiba: cliente_id, pedido_id, data_pedido e número do pedido

```

</details>

</details>

---

# AULA 59

<details>
<summary><strong>Expandir Aula 59</strong></summary>

## RANK - Ranking com Empates

## O que é?

A função `RANK()` atribui uma classificação às linhas, mas **valores iguais recebem o mesmo número** e o próximo número é pulado.

## Sintaxe

```sql
RANK() OVER (ORDER BY coluna)
```

## ROW_NUMBER vs RANK

```
Dados: 100, 100, 80, 70

ROW_NUMBER:              RANK:
┌───────┬───────┐        ┌───────┬───────┐
│ Valor │ Num   │        │ Valor │ Rank  │
├───────┼───────┤        ├───────┼───────┤
│ 100   │ 1     │        │ 100   │ 1     │
│ 100   │ 2     │  vs    │ 100   │ 1     │ ← mesmo rank!
│ 80    │ 3     │        │ 80    │ 3     │ ← pulou o 2
│ 70    │ 4     │        │ 70    │ 4     │
└───────┴───────┘        └───────┴───────┘
```

## Exemplos Práticos

```sql
-- Rankear produtos por preço
SELECT
    RANK() OVER (ORDER BY preco DESC) AS ranking,
    nome,
    preco
FROM produtos;

-- Se dois produtos custam R$ 500, ambos ficam em 1º lugar
-- O próximo produto fica em 3º lugar (não 2º)
```

## Aplicação: Top N com Empates

```sql
-- Top 3 produtos mais caros (inclui empates)
SELECT * FROM (
    SELECT
        RANK() OVER (ORDER BY preco DESC) AS ranking,
        nome,
        preco
    FROM produtos
) AS ranked
WHERE ranking <= 3;
-- Pode retornar mais de 3 se houver empates
```

## Ranking de Clientes por Total Gasto

```sql
-- Rankear clientes por valor total de compras
SELECT
    c.nome,
    SUM(p.valor_total) AS total_gasto,
    RANK() OVER (ORDER BY SUM(p.valor_total) DESC) AS ranking
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id, c.nome;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 59 - Desafio 1: Rankear produtos por preço (empatados ficam com mesmo número)
-- Exiba: ranking, nome, preco


-- Aula 59 - Desafio 2: Rankear clientes por total gasto
-- Use JOIN com pedidos, agrupe por cliente e aplique RANK

```

</details>

</details>

---

# AULA 60

<details>
<summary><strong>Expandir Aula 60</strong></summary>

## DENSE_RANK - Ranking Denso

## O que é?

A função `DENSE_RANK()` é similar ao RANK, mas **não pula números** após empates.

## Sintaxe

```sql
DENSE_RANK() OVER (ORDER BY coluna)
```

## RANK vs DENSE_RANK

```
Dados: 100, 100, 80, 70

RANK:                    DENSE_RANK:
┌───────┬───────┐        ┌───────┬───────┐
│ Valor │ Rank  │        │ Valor │ Dense │
├───────┼───────┤        ├───────┼───────┤
│ 100   │ 1     │        │ 100   │ 1     │
│ 100   │ 1     │  vs    │ 100   │ 1     │
│ 80    │ 3     │ ← pula │ 80    │ 2     │ ← não pula!
│ 70    │ 4     │        │ 70    │ 3     │
└───────┴───────┘        └───────┴───────┘
```

## Quando usar qual?

| Função | Empates | Pula números | Uso comum |
|--------|---------|--------------|-----------|
| ROW_NUMBER | Valores diferentes | Não | Paginação, IDs únicos |
| RANK | Mesmo número | Sim | Competições (1º, 1º, 3º) |
| DENSE_RANK | Mesmo número | Não | Rankings sem gaps |

## Exemplos Práticos

```sql
-- Comparando as três funções
SELECT
    nome,
    preco,
    ROW_NUMBER() OVER (ORDER BY preco DESC) AS row_num,
    RANK() OVER (ORDER BY preco DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY preco DESC) AS dense_rank
FROM produtos;

-- Resultado (com empates em preco):
-- | nome      | preco | row_num | rank | dense_rank |
-- |-----------|-------|---------|------|------------|
-- | Produto A | 500   | 1       | 1    | 1          |
-- | Produto B | 500   | 2       | 1    | 1          |
-- | Produto C | 400   | 3       | 3    | 2          |
-- | Produto D | 300   | 4       | 4    | 3          |
```

## Ranking de Avaliações

```sql
-- Rankear produtos por avaliação média
SELECT
    p.nome,
    ROUND(AVG(a.nota), 2) AS media_avaliacao,
    DENSE_RANK() OVER (ORDER BY AVG(a.nota) DESC) AS ranking
FROM produtos p
INNER JOIN avaliacoes a ON p.produto_id = a.produto_id
GROUP BY p.produto_id, p.nome;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 60 - Desafio 1: Rankear produtos por avaliação média (sem pular números)
-- Use DENSE_RANK com AVG(nota)


-- Aula 60 - Desafio 2: Rankear categorias por número de produtos
-- Conte produtos por categoria e aplique DENSE_RANK

```

</details>

</details>

---

# AULA 61

<details>
<summary><strong>Expandir Aula 61</strong></summary>

## PARTITION BY - Dividindo em Grupos

## O que é?

A cláusula `PARTITION BY` divide os dados em **grupos independentes** antes de aplicar a função de janela. Cada grupo tem sua própria numeração/ranking.

## Sintaxe

```sql
função() OVER (PARTITION BY coluna_grupo ORDER BY coluna_ordem)
```

## Sem PARTITION vs Com PARTITION

```
Sem PARTITION:                   Com PARTITION BY categoria:
┌──────────┬────┐                ┌──────────┬───────┬────┐
│ Produto  │ Num│                │ Categoria│ Produto│ Num│
├──────────┼────┤                ├──────────┼───────┼────┤
│ iPhone   │ 1  │                │ Celulares│ iPhone│ 1  │
│ Galaxy   │ 2  │   vs           │ Celulares│ Galaxy│ 2  │
│ MacBook  │ 3  │                │ Notebooks│ MacBook│ 1  │ ← recomeça!
│ Dell     │ 4  │                │ Notebooks│ Dell  │ 2  │
└──────────┴────┘                └──────────┴───────┴────┘
Numeração global                 Numeração por grupo
```

## Exemplos Práticos

```sql
-- Numerar produtos dentro de cada categoria
SELECT
    c.nome AS categoria,
    p.nome AS produto,
    p.preco,
    ROW_NUMBER() OVER (
        PARTITION BY p.categoria_id
        ORDER BY p.preco DESC
    ) AS ranking_na_categoria
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id;
```

## Top N por Grupo

```sql
-- Top 3 produtos mais caros de CADA categoria
SELECT * FROM (
    SELECT
        c.nome AS categoria,
        p.nome AS produto,
        p.preco,
        ROW_NUMBER() OVER (
            PARTITION BY p.categoria_id
            ORDER BY p.preco DESC
        ) AS rank_cat
    FROM produtos p
    INNER JOIN categorias c ON p.categoria_id = c.categoria_id
) AS ranked
WHERE rank_cat <= 3;
```

## Múltiplas Partições

```sql
-- Ranking por marca E categoria
SELECT
    p.marca,
    c.nome AS categoria,
    p.nome,
    p.preco,
    RANK() OVER (
        PARTITION BY p.marca, p.categoria_id
        ORDER BY p.preco DESC
    ) AS ranking
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id;
```

## Ranking de Vendas por Mês

```sql
-- Ranking de vendedores por mês
SELECT
    EXTRACT(MONTH FROM p.data_pedido) AS mes,
    v.nome AS vendedor,
    SUM(p.valor_total) AS total_vendas,
    RANK() OVER (
        PARTITION BY EXTRACT(MONTH FROM p.data_pedido)
        ORDER BY SUM(p.valor_total) DESC
    ) AS ranking_mes
FROM pedidos p
INNER JOIN vendedores v ON p.vendedor_id = v.vendedor_id
GROUP BY EXTRACT(MONTH FROM p.data_pedido), v.vendedor_id, v.nome;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 61 - Desafio 1: Numerar produtos dentro de cada categoria
-- Ordenar por preço dentro de cada categoria


-- Aula 61 - Desafio 2: Rankear vendas por mês
-- Mostre o ranking de pedidos por valor em cada mês

```

</details>

</details>

---

# AULA 62

<details>
<summary><strong>Expandir Aula 62</strong></summary>

## LEAD e LAG - Acessando Linhas Adjacentes

## O que é?

- `LAG()` acessa o valor da **linha anterior**
- `LEAD()` acessa o valor da **próxima linha**

## Sintaxe

```sql
LAG(coluna, offset, default) OVER (ORDER BY coluna)
LEAD(coluna, offset, default) OVER (ORDER BY coluna)
```

- `offset`: quantas linhas pular (padrão: 1)
- `default`: valor se não houver linha (padrão: NULL)

## Como Funciona

```
LAG (olha para trás):           LEAD (olha para frente):
┌───────┬───────┬─────┐         ┌───────┬───────┬──────┐
│ Data  │ Valor │ LAG │         │ Data  │ Valor │ LEAD │
├───────┼───────┼─────┤         ├───────┼───────┼──────┤
│ Jan   │ 100   │ NULL│ ← sem   │ Jan   │ 100   │ 150  │
│ Fev   │ 150   │ 100 │   antes │ Fev   │ 150   │ 200  │
│ Mar   │ 200   │ 150 │         │ Mar   │ 200   │ NULL │ ← sem
└───────┴───────┴─────┘         └───────┴───────┴──────┘   depois
```

## Exemplos Práticos

```sql
-- Comparar preço de cada produto com o anterior (por ordem de preço)
SELECT
    nome,
    preco,
    LAG(preco) OVER (ORDER BY preco) AS preco_anterior,
    preco - LAG(preco) OVER (ORDER BY preco) AS diferenca
FROM produtos;

-- Comparar com o próximo
SELECT
    nome,
    preco,
    LEAD(preco) OVER (ORDER BY preco) AS preco_proximo
FROM produtos;
```

## Análise de Vendas

```sql
-- Comparar valor de cada pedido com o pedido anterior do mesmo cliente
SELECT
    cliente_id,
    pedido_id,
    data_pedido,
    valor_total,
    LAG(valor_total) OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido
    ) AS pedido_anterior,
    valor_total - LAG(valor_total) OVER (
        PARTITION BY cliente_id
        ORDER BY data_pedido
    ) AS variacao
FROM pedidos;
```

## Calculando Crescimento

```sql
-- Crescimento percentual entre pedidos
SELECT
    data_pedido,
    valor_total,
    LAG(valor_total) OVER (ORDER BY data_pedido) AS valor_anterior,
    ROUND(
        100.0 * (valor_total - LAG(valor_total) OVER (ORDER BY data_pedido))
        / NULLIF(LAG(valor_total) OVER (ORDER BY data_pedido), 0),
        2
    ) AS crescimento_pct
FROM pedidos;
```

## Usando Offset

```sql
-- Comparar com 2 pedidos atrás
SELECT
    pedido_id,
    data_pedido,
    valor_total,
    LAG(valor_total, 2) OVER (ORDER BY data_pedido) AS dois_atras
FROM pedidos;

-- Com valor default para NULLs
SELECT
    pedido_id,
    valor_total,
    LAG(valor_total, 1, 0) OVER (ORDER BY data_pedido) AS anterior_ou_zero
FROM pedidos;
```

## FIRST_VALUE e LAST_VALUE

```sql
-- Primeiro valor da janela
SELECT
    nome,
    preco,
    FIRST_VALUE(nome) OVER (ORDER BY preco DESC) AS mais_caro,
    FIRST_VALUE(preco) OVER (ORDER BY preco DESC) AS maior_preco
FROM produtos;

-- Último valor (cuidado com o frame!)
SELECT
    nome,
    preco,
    LAST_VALUE(nome) OVER (
        ORDER BY preco DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS mais_barato
FROM produtos;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 62 - Desafio 1: Comparar preço de cada produto com o próximo produto
-- Ordene por preço e mostre a diferença


-- Aula 62 - Desafio 2: Calcular diferença de valor entre pedidos consecutivos de cada cliente
-- Use PARTITION BY cliente_id

```

</details>

</details>

---

## Resumo Rápido

| Função | O que faz | Empates | Pula |
|--------|-----------|---------|------|
| `ROW_NUMBER()` | Número sequencial único | Valores diferentes | Não |
| `RANK()` | Ranking com empates | Mesmo número | Sim |
| `DENSE_RANK()` | Ranking sem gaps | Mesmo número | Não |
| `LAG(col)` | Valor da linha anterior | - | - |
| `LEAD(col)` | Valor da próxima linha | - | - |

---

## Anatomia de uma Window Function

```sql
função() OVER (
    PARTITION BY coluna_grupo     -- Opcional: divide em grupos
    ORDER BY coluna_ordem         -- Define a ordem
    ROWS/RANGE ...                -- Opcional: define o frame
)
```

---

## Checklist de Domínio

- [ ] Sei usar ROW_NUMBER para numerar linhas
- [ ] Entendo a diferença entre RANK e DENSE_RANK
- [ ] Sei usar PARTITION BY para rankings por grupo
- [ ] Consigo fazer Top N por categoria com window functions
- [ ] Sei usar LAG para acessar a linha anterior
- [ ] Sei usar LEAD para acessar a próxima linha
- [ ] Consigo calcular variações e crescimentos

---

## Próximos Passos

No próximo módulo, você aprenderá sobre:
- CTEs (Common Table Expressions)
- Otimização de queries
- EXPLAIN e índices

---

## Desafio Final do Módulo 13

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

Use seus conhecimentos de Window Functions para resolver estes desafios.

### Desafios

```sql
-- Desafio Final 1: Ranking Completo de Produtos
-- Para cada produto, mostre:
-- - nome, preco, categoria
-- - ROW_NUMBER, RANK e DENSE_RANK por preço
-- Compare os resultados


-- Desafio Final 2: Top 2 Produtos por Categoria
-- Liste os 2 produtos mais caros de cada categoria
-- Use PARTITION BY e ROW_NUMBER


-- Desafio Final 3: Análise de Pedidos do Cliente
-- Para cada pedido, mostre:
-- - cliente_id, pedido_id, data_pedido, valor_total
-- - valor do pedido anterior do mesmo cliente
-- - diferença entre pedidos
-- - número do pedido do cliente (1º, 2º, 3º...)


-- Desafio Final 4: Variação de Vendas
-- Calcule a variação percentual de vendas diárias
-- Mostre: data, total do dia, total do dia anterior, variação %


-- Desafio Final 5 (Boss Final!): Dashboard de Performance
-- Crie um relatório que mostre para cada produto:
-- - nome, categoria, preco, estoque
-- - Ranking geral por preço
-- - Ranking dentro da categoria
-- - Se é o mais caro da categoria (sim/não)
-- - Diferença de preço para o produto mais caro da mesma categoria

```

</details>
