# Módulo 13 - Window Functions - Material Didático

## Objetivo do Módulo
Dominar as funções de janela (Window Functions) em SQL, que permitem realizar cálculos em grupos de linhas relacionadas sem agrupar os resultados, mantendo o detalhe de cada registro.


## Introdução às Window Functions

## O que são Window Functions?

**Window Functions** (Funções de Janela) são funções especiais que permitem fazer **cálculos em grupos de linhas** sem perder o detalhe individual de cada registro.

Diferente do `GROUP BY` que **colapsa** as linhas em um único resultado por grupo, as Window Functions **mantêm todas as linhas** e adicionam informações calculadas baseadas em "janelas" (grupos) de dados.

## A Diferença Fundamental

### Com GROUP BY (Agregação Tradicional):
```sql
-- Conta quantos produtos temos por categoria
SELECT
    c.nome AS categoria,
    COUNT(*) AS total_produtos
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id
GROUP BY c.categoria_id, c.nome;

-- Resultado:
-- | categoria    | total_produtos |
-- |--------------|----------------|
-- | Eletrônicos  | 15             |
-- | Roupas       | 8              |
-- | Livros       | 12             |

-- 👎 PERDEMOS os detalhes de CADA produto!
-- 👎 Só vemos o total agregado por categoria
```

### Com Window Functions:
```sql
-- Mostra CADA produto E conta o total da categoria
SELECT
    c.nome AS categoria,
    p.nome AS produto,
    p.preco,
    COUNT(*) OVER (PARTITION BY p.categoria_id) AS total_na_categoria
FROM produtos p
INNER JOIN categorias c ON p.categoria_id = c.categoria_id;

-- Resultado:
-- | categoria    | produto      | preco  | total_na_categoria |
-- |--------------|--------------|--------|-------------------|
-- | Eletrônicos  | iPhone 15    | 8999   | 15                |
-- | Eletrônicos  | Galaxy S24   | 5999   | 15                |
-- | Eletrônicos  | MacBook Pro  | 7999   | 15                |
-- | Roupas       | Camiseta     | 49     | 8                 |
-- | Roupas       | Calça Jeans  | 129    | 8                 |

-- ✅ Mantemos TODAS as linhas de produtos!
-- ✅ Cada linha mostra o total da SUA categoria
```

## Visualização da Diferença

```
GROUP BY (Agregação):           Window Functions:
┌──────────┬────────┐            ┌──────────┬──────────┬───────┬─────┐
│ Categoria│ Total  │            │ Categoria│ Produto  │ Preço │Total│
├──────────┼────────┤            ├──────────┼──────────┼───────┼─────┤
│ Celular  │ 3      │            │ Celular  │ iPhone   │ 8999  │ 3   │
│ Notebook │ 2      │            │ Celular  │ Galaxy   │ 5999  │ 3   │
└──────────┴────────┘            │ Celular  │ Xiaomi   │ 2999  │ 3   │
5 produtos viram                 │ Notebook │ MacBook  │ 7999  │ 2   │
2 linhas!                        │ Notebook │ Dell     │ 4999  │ 2   │
                                 └──────────┴──────────┴───────┴─────┘
                                 5 produtos permanecem 5 linhas!
```

## Quando usar cada um?

| Situação | Use GROUP BY | Use Window Functions |
|----------|--------------|---------------------|
| **Quer apenas totais/resumos** | ✅ Sim | ❌ Não necessário |
| **Precisa de detalhes + cálculos** | ❌ Não consegue | ✅ Perfeito! |
| **Ranking/numeração** | ❌ Não consegue | ✅ Ideal |
| **Comparar com linha anterior** | ❌ Impossível | ✅ LAG/LEAD |
| **Top N por grupo** | 🟡 Difícil | ✅ Fácil |

## Exemplo Prático: Ranking de Vendas

**Pergunta:** "Quero ver TODOS os pedidos E o ranking de valor de cada um"

### ❌ Com GROUP BY não dá:
```sql
-- Isso não funciona como queremos
SELECT
    pedido_id,
    valor_total,
    RANK() -- ❌ ERRO: não pode usar RANK com GROUP BY
FROM pedidos
GROUP BY ...;
```

### ✅ Com Window Functions:
```sql
-- Perfeito! Cada pedido mantém seus detalhes
SELECT
    pedido_id,
    cliente_id,
    data_pedido,
    valor_total,
    RANK() OVER (ORDER BY valor_total DESC) AS ranking
FROM pedidos;

-- Resultado:
-- | pedido_id | cliente_id | data_pedido | valor_total | ranking |
-- |-----------|------------|-------------|-------------|---------|
-- | 1523      | 45         | 2024-03-15  | 2500.00     | 1       |
-- | 1891      | 12         | 2024-03-18  | 2500.00     | 1       |
-- | 1456      | 89         | 2024-03-10  | 1800.00     | 3       |
-- | 1678      | 23         | 2024-03-14  | 950.00      | 4       |
```

## Em resumo

- **GROUP BY**: Agrupa e resume → Perde detalhes
- **Window Functions**: Calcula em grupos → Mantém detalhes
- **Poder das Window Functions**: "Faça cálculos em grupos SEM agrupar o resultado!"

Agora vamos aprender as principais Window Functions disponíveis! 🚀

---
# AULA 54

<details>
<summary><strong>Expandir Aula 54</strong></summary>

## ROW_NUMBER - Numerando Linhas

## O que é?

A função `ROW_NUMBER()` atribui um **número sequencial único** a cada linha do resultado, começando em 1.

## Sintaxe

```sql
ROW_NUMBER() OVER (ORDER BY coluna)
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
-- Aula 54 - Desafio 1: Numerar produtos ordenados por preço (do mais caro ao mais barato)
-- Exiba: número, nome e preço


-- Aula 54 - Desafio 2: Numerar pedidos de cada cliente por data
-- Exiba: cliente_id, pedido_id, data_pedido e número do pedido

```

</details>

</details>

---

# AULA 55

<details>
<summary><strong>Expandir Aula 55</strong></summary>

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
## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 55 - Desafio 1: Ranking de produtos mais caros
-- Crie um ranking dos produtos ordenados do mais caro para o mais barato.
-- Exiba: posição no ranking, nome do produto e preço


-- Aula 55 - Desafio 2: Ranking de clientes por valor total de compras
-- Identifique quais clientes gastam mais na loja criando um ranking.
-- Calcule o total gasto por cada cliente somando o valor_total de todos os seus pedidos.
-- Exiba: nome do cliente, total gasto e ranking

```

</details>

</details>

---

# AULA 56

<details>
<summary><strong>Expandir Aula 56</strong></summary>

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

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 56 - Desafio 1: Rankear produtos por avaliação média (sem pular números)
-- Use DENSE_RANK com AVG(nota)


-- Aula 56 - Desafio 2: Rankear categorias por número de produtos
-- Conte produtos por categoria e aplique DENSE_RANK

```

</details>

</details>

---

# AULA 57

<details>
<summary><strong>Expandir Aula 57</strong></summary>

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

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 57 - Desafio 1: Numerar produtos dentro de cada categoria
-- Ordenar por preço dentro de cada categoria


-- Aula 57 - Desafio 2: Rankear vendas por mês
-- Mostre o ranking de pedidos por valor em cada mês

```

</details>

</details>

---

# AULA 58

<details>
<summary><strong>Expandir Aula 58</strong></summary>

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


--Ultimo valor da janela
SELECT
    nome,
    preco,
    LAST_VALUE(nome) OVER (ORDER BY preco DESC) AS mais_barato,
    LAST_VALUE(preco) OVER (ORDER BY preco DESC) AS menor_preco
FROM produtos;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 58 - Desafio 1: Comparar preço de cada produto com o próximo produto
-- Ordene por preço e mostre a diferença


-- Aula 58 - Desafio 2: Calcular diferença de valor entre pedidos consecutivos de cada cliente
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
