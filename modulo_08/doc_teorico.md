# Módulo 8 - Subconsultas - Material Didático

## Objetivo do Módulo
Aprender a usar consultas dentro de outras consultas, uma técnica poderosa para resolver problemas complexos em SQL.

---

# AULA 39

<details>
<summary><strong>Expandir Aula 39</strong></summary>

## Subconsulta no WHERE

## O que é?

Uma **subconsulta no WHERE** é uma consulta interna que retorna valores usados para filtrar a consulta externa. É como fazer uma pergunta dentro de outra pergunta.

## Sintaxe Básica

```sql
SELECT colunas
FROM tabela
WHERE coluna operador (SELECT coluna FROM outra_tabela WHERE condição);
```

## Tipos de Operadores com Subconsultas

| Operador | Uso | Descrição |
|----------|-----|-----------|
| `=`, `>`, `<`, etc. | Valor único | Subconsulta retorna um único valor |
| `IN` | Lista de valores | Subconsulta retorna múltiplos valores |
| `NOT IN` | Exclusão | Valores que NÃO estão na lista |
| `ANY` / `SOME` | Comparação flexível | Verdadeiro se qualquer valor satisfaz |
| `ALL` | Comparação rigorosa | Verdadeiro se todos os valores satisfazem |

## Exemplos Práticos

**1. Produtos com preço acima da média:**
```sql
SELECT nome, preco
FROM produtos
WHERE preco > (SELECT AVG(preco) FROM produtos);
```

**2. Clientes que fizeram pedidos:**
```sql
SELECT nome, email
FROM clientes
WHERE cliente_id IN (SELECT DISTINCT cliente_id FROM pedidos);
```

**3. Produtos que nunca foram vendidos:**
```sql
SELECT nome, preco, estoque
FROM produtos
WHERE produto_id NOT IN (SELECT DISTINCT produto_id FROM itens_pedido);
```

**4. Clientes que gastaram mais que a média:**
```sql
SELECT nome, email
FROM clientes
WHERE cliente_id IN (
    SELECT cliente_id
    FROM pedidos
    GROUP BY cliente_id
    HAVING SUM(valor_total) > (SELECT AVG(valor_total) FROM pedidos)
);
```

**5. Produto mais caro de cada categoria (usando ALL):**
```sql
SELECT nome, preco, categoria_id
FROM produtos p1
WHERE preco >= ALL (
    SELECT preco
    FROM produtos p2
    WHERE p2.categoria_id = p1.categoria_id
);
```

## Subconsulta Correlacionada vs Não-Correlacionada

| Tipo | Descrição | Performance |
|------|-----------|-------------|
| **Não-correlacionada** | Executa uma vez, independente da externa | Mais rápida |
| **Correlacionada** | Executa para cada linha da externa | Mais lenta |

**Exemplo de correlacionada:**
```sql
-- Produtos com preço acima da média da SUA categoria
SELECT nome, preco, categoria_id
FROM produtos p1
WHERE preco > (
    SELECT AVG(preco)
    FROM produtos p2
    WHERE p2.categoria_id = p1.categoria_id  -- Referência à consulta externa
);
```

## Desafios

<details>
<summary><strong>Ver Desafios</strong></summary>

1. Mostrar produtos com preço acima da média geral
2. Mostrar clientes que fizeram pedidos com valor acima de R$ 1000

</details>

</details>

---

# AULA 40

<details>
<summary><strong>Expandir Aula 40</strong></summary>

## Subconsulta no FROM (Derived Tables)

## O que é?

Uma **subconsulta no FROM** cria uma "tabela temporária" (derived table) que pode ser usada como fonte de dados para a consulta externa. É útil para pré-processar dados antes de aplicar outras operações.

## Sintaxe Básica

```sql
SELECT colunas
FROM (
    SELECT colunas
    FROM tabela
    WHERE condição
    GROUP BY coluna
) AS alias_obrigatorio
WHERE condição;
```

**Importante:** O alias é OBRIGATÓRIO para subconsultas no FROM!

## Quando Usar?

- Quando precisa agregar dados e depois filtrar pelo resultado agregado
- Quando quer reaproveitar um cálculo complexo
- Quando precisa fazer cálculos em cima de cálculos
- Para simplificar consultas complexas em etapas

## Exemplos Práticos

**1. Resumo de vendas por produto:**
```sql
SELECT
    produto,
    total_vendido,
    quantidade_vendas
FROM (
    SELECT
        p.nome AS produto,
        SUM(ip.quantidade * ip.preco_unitario) AS total_vendido,
        COUNT(*) AS quantidade_vendas
    FROM itens_pedido ip
    INNER JOIN produtos p ON ip.produto_id = p.produto_id
    GROUP BY p.produto_id, p.nome
) AS vendas_produto
WHERE total_vendido > 1000
ORDER BY total_vendido DESC;
```

**2. Média de pedidos por cliente:**
```sql
SELECT
    ROUND(AVG(total_pedidos), 2) AS media_pedidos_por_cliente,
    ROUND(AVG(valor_total), 2) AS media_valor_por_cliente
FROM (
    SELECT
        cliente_id,
        COUNT(*) AS total_pedidos,
        SUM(valor_total) AS valor_total
    FROM pedidos
    GROUP BY cliente_id
) AS pedidos_cliente;
```

**3. Top 5 clientes com ranking:**
```sql
SELECT
    cliente,
    total_gasto,
    total_pedidos
FROM (
    SELECT
        c.nome AS cliente,
        SUM(p.valor_total) AS total_gasto,
        COUNT(*) AS total_pedidos
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
    GROUP BY c.cliente_id, c.nome
) AS resumo_clientes
ORDER BY total_gasto DESC
LIMIT 5;
```

**4. Categorias com estatísticas:**
```sql
SELECT
    categoria,
    total_produtos,
    preco_medio,
    CASE
        WHEN preco_medio > 500 THEN 'Premium'
        WHEN preco_medio > 100 THEN 'Intermediário'
        ELSE 'Econômico'
    END AS classificacao
FROM (
    SELECT
        c.nome AS categoria,
        COUNT(*) AS total_produtos,
        ROUND(AVG(p.preco), 2) AS preco_medio
    FROM categorias c
    INNER JOIN produtos p ON c.categoria_id = p.categoria_id
    GROUP BY c.categoria_id, c.nome
) AS stats_categoria;
```

**5. Comparando com a média geral:**
```sql
SELECT
    cliente,
    total_gasto,
    media_geral,
    ROUND(total_gasto - media_geral, 2) AS diferenca_da_media
FROM (
    SELECT
        c.nome AS cliente,
        SUM(p.valor_total) AS total_gasto
    FROM clientes c
    INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
    GROUP BY c.cliente_id, c.nome
) AS gastos,
(
    SELECT AVG(valor_total) AS media_geral FROM pedidos
) AS media
WHERE total_gasto > media_geral;
```

## Desafios

<details>
<summary><strong>Ver Desafios</strong></summary>

1. Criar uma tabela temporária com resumo de vendas por produto (nome, quantidade vendida, valor total)
2. Calcular a média de pedidos por cliente usando subquery no FROM

</details>

</details>

---

# AULA 41

<details>
<summary><strong>Expandir Aula 41</strong></summary>

## Subconsulta no SELECT (Scalar Subqueries)

## O que é?

Uma **subconsulta no SELECT** adiciona uma coluna calculada para cada linha do resultado. Deve retornar exatamente UM valor (escalar) para cada linha.

## Sintaxe Básica

```sql
SELECT
    coluna1,
    coluna2,
    (SELECT expressão FROM tabela WHERE condição) AS coluna_calculada
FROM tabela_principal;
```

## Características

- Deve retornar **apenas um valor** (escalar)
- Executada para **cada linha** do resultado
- Pode referenciar colunas da consulta externa (correlacionada)
- Útil para adicionar dados relacionados ou cálculos

## Exemplos Práticos

**1. Produtos com quantidade total vendida:**
```sql
SELECT
    p.nome,
    p.preco,
    p.estoque,
    (
        SELECT COALESCE(SUM(ip.quantidade), 0)
        FROM itens_pedido ip
        WHERE ip.produto_id = p.produto_id
    ) AS total_vendido
FROM produtos p
ORDER BY total_vendido DESC;
```

**2. Clientes com total gasto:**
```sql
SELECT
    c.nome,
    c.email,
    c.cidade,
    (
        SELECT COALESCE(SUM(ped.valor_total), 0)
        FROM pedidos ped
        WHERE ped.cliente_id = c.cliente_id
    ) AS total_gasto
FROM clientes c
ORDER BY total_gasto DESC;
```

**3. Produtos com média de avaliação:**
```sql
SELECT
    p.nome,
    p.preco,
    (
        SELECT ROUND(AVG(a.nota), 1)
        FROM avaliacoes a
        WHERE a.produto_id = p.produto_id
    ) AS nota_media,
    (
        SELECT COUNT(*)
        FROM avaliacoes a
        WHERE a.produto_id = p.produto_id
    ) AS total_avaliacoes
FROM produtos p
WHERE p.ativo = TRUE
ORDER BY nota_media DESC NULLS LAST;
```

**4. Categorias com contagem de produtos:**
```sql
SELECT
    c.nome AS categoria,
    c.descricao,
    (
        SELECT COUNT(*)
        FROM produtos p
        WHERE p.categoria_id = c.categoria_id
    ) AS total_produtos,
    (
        SELECT ROUND(AVG(p.preco), 2)
        FROM produtos p
        WHERE p.categoria_id = c.categoria_id
    ) AS preco_medio
FROM categorias c
WHERE c.ativo = TRUE;
```

**5. Pedidos com informações extras:**
```sql
SELECT
    p.pedido_id,
    p.data_pedido,
    p.valor_total,
    (
        SELECT c.nome
        FROM clientes c
        WHERE c.cliente_id = p.cliente_id
    ) AS cliente,
    (
        SELECT COUNT(*)
        FROM itens_pedido ip
        WHERE ip.pedido_id = p.pedido_id
    ) AS qtd_itens
FROM pedidos p
ORDER BY p.data_pedido DESC
LIMIT 10;
```

## COALESCE para Valores Nulos

Quando a subconsulta pode não encontrar dados, use `COALESCE` para definir um valor padrão:

```sql
SELECT
    p.nome,
    COALESCE(
        (SELECT SUM(ip.quantidade) FROM itens_pedido ip WHERE ip.produto_id = p.produto_id),
        0
    ) AS vendas
FROM produtos p;
```

## Quando Usar Subconsulta no SELECT vs JOIN?

| Situação | Melhor Opção |
|----------|--------------|
| Adicionar um valor agregado | Subconsulta no SELECT |
| Trazer múltiplas colunas relacionadas | JOIN |
| Dados que podem não existir (permitir NULL) | Subconsulta ou LEFT JOIN |
| Performance com muitas linhas | JOIN (geralmente) |

## Desafios

<details>
<summary><strong>Ver Desafios</strong></summary>

1. Listar produtos com a quantidade total vendida em cada linha
2. Listar clientes com o total gasto por cada um

</details>

</details>

---

# AULA 42

<details>
<summary><strong>Expandir Aula 42</strong></summary>

## EXISTS - Verificando Existência

## O que é?

O operador **EXISTS** verifica se uma subconsulta retorna algum resultado. Retorna TRUE se encontrar pelo menos uma linha, FALSE caso contrário. É muito eficiente porque para de procurar assim que encontra a primeira correspondência.

## Sintaxe Básica

```sql
SELECT colunas
FROM tabela
WHERE EXISTS (SELECT 1 FROM outra_tabela WHERE condição);
```

**Nota:** Usamos `SELECT 1` porque o conteúdo não importa, apenas se existe ou não.

## EXISTS vs IN

| Característica | EXISTS | IN |
|---------------|--------|-----|
| Verifica | Se há pelo menos um resultado | Se valor está na lista |
| NULL handling | Funciona bem com NULLs | Problemas com NULLs |
| Performance (tabela grande) | Geralmente melhor | Pode ser mais lento |
| Legibilidade | Menos intuitivo | Mais intuitivo |

## Exemplos Práticos

**1. Produtos que já foram vendidos:**
```sql
SELECT p.nome, p.preco, p.estoque
FROM produtos p
WHERE EXISTS (
    SELECT 1
    FROM itens_pedido ip
    WHERE ip.produto_id = p.produto_id
);
```

**2. Produtos que NUNCA foram vendidos (NOT EXISTS):**
```sql
SELECT p.nome, p.preco, p.estoque
FROM produtos p
WHERE NOT EXISTS (
    SELECT 1
    FROM itens_pedido ip
    WHERE ip.produto_id = p.produto_id
);
```

**3. Clientes que fizeram avaliações:**
```sql
SELECT c.nome, c.email
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM avaliacoes a
    WHERE a.cliente_id = c.cliente_id
);
```

**4. Categorias com produtos em estoque:**
```sql
SELECT cat.nome AS categoria
FROM categorias cat
WHERE EXISTS (
    SELECT 1
    FROM produtos p
    WHERE p.categoria_id = cat.categoria_id
      AND p.estoque > 0
      AND p.ativo = TRUE
);
```

**5. Clientes com pedidos entregues:**
```sql
SELECT c.nome, c.email, c.cidade
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM pedidos p
    WHERE p.cliente_id = c.cliente_id
      AND p.status = 'entregue'
);
```

**6. Produtos com avaliação 5 estrelas:**
```sql
SELECT p.nome, p.preco
FROM produtos p
WHERE EXISTS (
    SELECT 1
    FROM avaliacoes a
    WHERE a.produto_id = p.produto_id
      AND a.nota = 5
);
```

**7. Combinando EXISTS com outras condições:**
```sql
SELECT
    c.nome,
    c.cidade,
    c.estado
FROM clientes c
WHERE c.ativo = TRUE
  AND EXISTS (
      SELECT 1
      FROM pedidos p
      WHERE p.cliente_id = c.cliente_id
        AND p.valor_total > 500
  )
  AND NOT EXISTS (
      SELECT 1
      FROM pedidos p
      WHERE p.cliente_id = c.cliente_id
        AND p.status = 'cancelado'
  );
-- Clientes ativos que fizeram pedidos > R$500 e nunca cancelaram
```

## Por que EXISTS é Eficiente?

```
EXISTS para na PRIMEIRA correspondência encontrada
IN precisa verificar TODOS os valores da lista

Para verificar se "João fez algum pedido":
- EXISTS: Encontrou 1 pedido? PARA! Retorna TRUE
- IN: Lista TODOS os clientes com pedidos, depois verifica se João está na lista
```

## Desafios

<details>
<summary><strong>Ver Desafios</strong></summary>

1. Listar produtos que já foram vendidos (usando EXISTS)
2. Listar clientes que já fizeram avaliações (usando EXISTS)

</details>

</details>

---

## Resumo Rápido

| Tipo de Subconsulta | Local | Retorno | Uso Principal |
|---------------------|-------|---------|---------------|
| **WHERE** | Cláusula WHERE | Valor(es) para filtro | Filtrar baseado em outra consulta |
| **FROM** | Cláusula FROM | Tabela temporária | Pré-processar dados |
| **SELECT** | Lista de colunas | Valor escalar | Adicionar cálculos por linha |
| **EXISTS** | Cláusula WHERE | TRUE/FALSE | Verificar existência |

### Fluxo de Decisão

```
Precisa filtrar por valores de outra tabela?
├── Sim → Subconsulta no WHERE ou EXISTS
│
Precisa agregar dados antes de usar?
├── Sim → Subconsulta no FROM
│
Precisa adicionar uma coluna calculada?
├── Sim → Subconsulta no SELECT
│
Precisa verificar se algo existe?
├── Sim → EXISTS (mais eficiente que IN para isso)
```

---

## Checklist de Aprendizado

- [ ] Sei usar subconsulta no WHERE com operadores (=, >, IN, NOT IN)
- [ ] Entendo a diferença entre subconsulta correlacionada e não-correlacionada
- [ ] Sei criar tabelas derivadas no FROM
- [ ] Lembro que subconsultas no FROM precisam de alias
- [ ] Sei adicionar colunas calculadas com subconsulta no SELECT
- [ ] Uso COALESCE para tratar valores nulos em subconsultas
- [ ] Entendo quando usar EXISTS vs IN
- [ ] Sei usar NOT EXISTS para encontrar registros sem correspondência

---

## Próximos Passos

No próximo módulo, você aprenderá sobre:
- Operadores de conjunto (UNION, INTERSECT, EXCEPT)
- CTEs (Common Table Expressions)
- Funções de janela (Window Functions)

---

## Desafio Final

<details>
<summary><strong>Ver Desafio Final</strong></summary>

Usando seus conhecimentos de subconsultas, resolva os seguintes problemas:

**Desafio 1:** Liste todos os produtos com preço acima da média da sua categoria. Mostre: nome do produto, preço, nome da categoria, preço médio da categoria.

**Desafio 2:** Encontre os clientes "VIP" - aqueles cujo total gasto está acima da média de todos os clientes. Mostre: nome, email, total gasto, média geral.

**Desafio 3:** Para cada categoria, mostre quantos produtos têm estoque abaixo de 10 unidades. Use subconsulta no SELECT.

**Desafio 4:** Liste produtos que foram vendidos em pedidos com valor total acima de R$ 1000. Use EXISTS.

**Desafio 5:** Crie um relatório mostrando para cada mês: total de vendas, quantidade de pedidos, e se esse mês teve vendas acima da média mensal (sim/não). Use subconsulta no FROM.

**Desafio 6 (Boss Final!):** Crie um dashboard de produtos que mostre:
- Nome do produto
- Categoria
- Preço
- Estoque
- Total vendido (quantidade)
- Receita gerada
- Nota média das avaliações
- Se já foi avaliado (sim/não usando EXISTS)
- Classificação: "Campeão" se vendeu mais que a média, "Normal" caso contrário

Ordene pelos mais vendidos primeiro.

</details>
