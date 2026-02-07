# Módulo 9 - Agrupamento - Material Didático

## Objetivo do Módulo
Dominar as técnicas de agrupamento de dados em SQL, aprendendo a usar GROUP BY para criar relatórios agregados e HAVING para filtrar grupos de resultados.

---
# AULA 39

<details>
<summary><strong>Expandir Aula 39</strong></summary>

## GROUP BY - Agrupando Dados

## O que é?

O `GROUP BY` é usado para **agrupar linhas** que têm valores iguais em uma ou mais colunas. É essencial quando você quer usar funções de agregação (COUNT, SUM, AVG, etc.) para cada grupo separadamente.

## Sintaxe

```sql
SELECT coluna, FUNCAO_AGREGACAO(coluna)
FROM tabela
GROUP BY coluna;
```

## Por que usar GROUP BY?

Sem GROUP BY, funções de agregação retornam um único valor para toda a tabela:

```sql
-- Sem GROUP BY: conta TODOS os produtos
SELECT COUNT(*) FROM produtos;
-- Resultado: 150

-- Com GROUP BY: conta produtos POR CATEGORIA
SELECT categoria_id, COUNT(*) FROM produtos GROUP BY categoria_id;
-- Resultado:
-- categoria_id | count
-- 1            | 25
-- 2            | 30
-- 3            | 45
-- ...
```

## Como funciona?

O GROUP BY "agrupa" as linhas com valores iguais e aplica a função de agregação em cada grupo:

```
Dados originais:
| categoria | produto     | preco |
|-----------|-------------|-------|
| Eletrônico| TV          | 2000  |
| Eletrônico| Celular     | 1500  |
| Móveis    | Sofá        | 3000  |
| Eletrônico| Notebook    | 4000  |
| Móveis    | Mesa        | 800   |

GROUP BY categoria com COUNT(*):
| categoria  | count |
|------------|-------|
| Eletrônico | 3     |
| Móveis     | 2     |

GROUP BY categoria com SUM(preco):
| categoria  | sum   |
|------------|-------|
| Eletrônico | 7500  |
| Móveis     | 3800  |
```

## Regra de Ouro do GROUP BY

**Toda coluna no SELECT que NÃO está dentro de uma função de agregação DEVE estar no GROUP BY!**

```sql
-- CORRETO: marca está no GROUP BY
SELECT marca, COUNT(*)
FROM produtos
GROUP BY marca;

-- ERRO! marca não está no GROUP BY
SELECT marca, COUNT(*)
FROM produtos;
-- Erro: column "marca" must appear in GROUP BY clause
```

## Exemplos Práticos

```sql
-- Contar produtos por marca
SELECT marca, COUNT(*) AS quantidade
FROM produtos
GROUP BY marca;

-- Valor total de pedidos por cliente
SELECT cliente_id, SUM(valor_total) AS total_gasto
FROM pedidos
GROUP BY cliente_id;

-- Média de preços por categoria
SELECT categoria_id, AVG(preco) AS preco_medio
FROM produtos
GROUP BY categoria_id;

-- Quantidade de pedidos por status
SELECT status, COUNT(*) AS quantidade
FROM pedidos
GROUP BY status;
```

## GROUP BY com ORDER BY

```sql
-- Marcas com mais produtos (ordenado)
SELECT marca, COUNT(*) AS quantidade
FROM produtos
GROUP BY marca
ORDER BY quantidade DESC;

-- Clientes que mais gastaram
SELECT cliente_id, SUM(valor_total) AS total_gasto
FROM pedidos
GROUP BY cliente_id
ORDER BY total_gasto DESC
LIMIT 10;
```

## GROUP BY com WHERE

O WHERE filtra as linhas **ANTES** do agrupamento:

```sql
-- Contar apenas produtos com preço > 100, agrupados por marca
SELECT marca, COUNT(*) AS quantidade
FROM produtos
WHERE preco > 100
GROUP BY marca;
```

**Ordem de execução:** FROM → WHERE → GROUP BY → SELECT → ORDER BY

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 39 - Desafio 1: Contar quantos produtos existem por categoria


-- Aula 39 - Desafio 2: Calcular o valor total de pedidos por cliente

```

</details>

</details>

---

# AULA 40

<details>
<summary><strong>Expandir Aula 40</strong></summary>

## GROUP BY com Múltiplas Colunas

## O que é?

Você pode agrupar por **mais de uma coluna** ao mesmo tempo. Isso cria grupos para cada combinação única de valores das colunas especificadas.

## Sintaxe

```sql
SELECT coluna1, coluna2, FUNCAO_AGREGACAO(coluna)
FROM tabela
GROUP BY coluna1, coluna2;
```

## Como funciona?

```
Dados originais:
| estado | cidade        | cliente |
|--------|---------------|---------|
| SP     | São Paulo     | João    |
| SP     | São Paulo     | Maria   |
| SP     | Campinas      | Pedro   |
| RJ     | Rio de Janeiro| Ana     |
| RJ     | Rio de Janeiro| Carlos  |
| RJ     | Niterói       | Paula   |

GROUP BY estado, cidade com COUNT(*):
| estado | cidade         | count |
|--------|----------------|-------|
| SP     | São Paulo      | 2     |
| SP     | Campinas       | 1     |
| RJ     | Rio de Janeiro | 2     |
| RJ     | Niterói        | 1     |
```

Cada combinação única de (estado, cidade) forma um grupo!

## Exemplos Práticos

```sql
-- Clientes por estado e cidade
SELECT estado, cidade, COUNT(*) AS total_clientes
FROM clientes
GROUP BY estado, cidade
ORDER BY estado, cidade;

-- Vendas por ano e mês
SELECT
    EXTRACT(YEAR FROM data_pedido) AS ano,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    COUNT(*) AS total_pedidos,
    SUM(valor_total) AS faturamento
FROM pedidos
GROUP BY EXTRACT(YEAR FROM data_pedido), EXTRACT(MONTH FROM data_pedido)
ORDER BY ano, mes;

-- Produtos por marca e faixa de preço
SELECT
    marca,
    CASE
        WHEN preco < 100 THEN 'Econômico'
        WHEN preco < 500 THEN 'Intermediário'
        ELSE 'Premium'
    END AS faixa,
    COUNT(*) AS quantidade
FROM produtos
GROUP BY marca,
    CASE
        WHEN preco < 100 THEN 'Econômico'
        WHEN preco < 500 THEN 'Intermediário'
        ELSE 'Premium'
    END;
```

## Agrupando por Data

```sql
-- Pedidos por ano
SELECT
    EXTRACT(YEAR FROM data_pedido) AS ano,
    COUNT(*) AS total_pedidos
FROM pedidos
GROUP BY EXTRACT(YEAR FROM data_pedido);

-- Pedidos por mês (em um ano específico)
SELECT
    EXTRACT(MONTH FROM data_pedido) AS mes,
    COUNT(*) AS total_pedidos,
    SUM(valor_total) AS faturamento
FROM pedidos
WHERE EXTRACT(YEAR FROM data_pedido) = 2024
GROUP BY EXTRACT(MONTH FROM data_pedido)
ORDER BY mes;

-- Valor médio por dia da semana
SELECT
    EXTRACT(DOW FROM data_pedido) AS dia_semana,
    AVG(valor_total) AS ticket_medio
FROM pedidos
GROUP BY EXTRACT(DOW FROM data_pedido)
ORDER BY dia_semana;
-- 0 = Domingo, 1 = Segunda, ..., 6 = Sábado
```

## Múltiplas Funções de Agregação

```sql
-- Estatísticas completas por categoria
SELECT
    categoria_id,
    COUNT(*) AS total_produtos,
    SUM(estoque) AS estoque_total,
    AVG(preco) AS preco_medio,
    MIN(preco) AS menor_preco,
    MAX(preco) AS maior_preco
FROM produtos
GROUP BY categoria_id;
```

## Ordem das colunas no GROUP BY

A ordem das colunas no GROUP BY não afeta o resultado, apenas a organização:

```sql
-- Ambos retornam os mesmos grupos
GROUP BY estado, cidade
GROUP BY cidade, estado
```

Mas a ordem no ORDER BY afeta a visualização!

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 40 - Desafio 1: Contar quantos clientes existem por estado e cidade


-- Aula 40 - Desafio 2: Calcular o valor médio de pedidos por mês e ano

```

</details>

</details>

---

# AULA 41

<details>
<summary><strong>Expandir Aula 41</strong></summary>

## HAVING - Filtrando Grupos

## O que é?

O `HAVING` é usado para **filtrar grupos** após o agrupamento. É como um WHERE, mas para resultados de GROUP BY.

## Sintaxe

```sql
SELECT coluna, FUNCAO_AGREGACAO(coluna)
FROM tabela
GROUP BY coluna
HAVING condição_sobre_agregação;
```

## WHERE vs HAVING

| WHERE | HAVING |
|-------|--------|
| Filtra **linhas** antes do agrupamento | Filtra **grupos** depois do agrupamento |
| Não pode usar funções de agregação | Usa funções de agregação |
| Executa antes do GROUP BY | Executa depois do GROUP BY |

```sql
-- WHERE: filtra produtos antes de agrupar
SELECT marca, COUNT(*)
FROM produtos
WHERE preco > 100        -- Filtra linhas
GROUP BY marca;

-- HAVING: filtra grupos depois de agrupar
SELECT marca, COUNT(*)
FROM produtos
GROUP BY marca
HAVING COUNT(*) > 5;     -- Filtra grupos
```

## Exemplos Práticos

```sql
-- Categorias com mais de 10 produtos
SELECT categoria_id, COUNT(*) AS total
FROM produtos
GROUP BY categoria_id
HAVING COUNT(*) > 10;

-- Clientes que gastaram mais de R$ 5000
SELECT cliente_id, SUM(valor_total) AS total_gasto
FROM pedidos
GROUP BY cliente_id
HAVING SUM(valor_total) > 5000;

-- Marcas com preço médio acima de R$ 500
SELECT marca, AVG(preco) AS preco_medio
FROM produtos
GROUP BY marca
HAVING AVG(preco) > 500;

-- Meses com mais de 100 pedidos
SELECT
    EXTRACT(MONTH FROM data_pedido) AS mes,
    COUNT(*) AS total_pedidos
FROM pedidos
GROUP BY EXTRACT(MONTH FROM data_pedido)
HAVING COUNT(*) > 100;
```

## Combinando WHERE e HAVING

Você pode usar ambos na mesma query:

```sql
-- Marcas de produtos caros (>500) que têm mais de 3 produtos
SELECT marca, COUNT(*) AS quantidade
FROM produtos
WHERE preco > 500          -- Primeiro: filtra produtos caros
GROUP BY marca             -- Depois: agrupa por marca
HAVING COUNT(*) > 3        -- Por fim: filtra marcas com mais de 3
ORDER BY quantidade DESC;
```

**Ordem de execução:**
1. FROM - define a tabela
2. WHERE - filtra linhas
3. GROUP BY - agrupa
4. HAVING - filtra grupos
5. SELECT - seleciona colunas
6. ORDER BY - ordena resultado

## HAVING com múltiplas condições

```sql
-- Categorias com muitos produtos E alto valor em estoque
SELECT
    categoria_id,
    COUNT(*) AS total_produtos,
    SUM(preco * estoque) AS valor_estoque
FROM produtos
GROUP BY categoria_id
HAVING COUNT(*) > 5
   AND SUM(preco * estoque) > 10000;

-- Clientes frequentes E de alto valor
SELECT
    cliente_id,
    COUNT(*) AS total_pedidos,
    SUM(valor_total) AS total_gasto
FROM pedidos
GROUP BY cliente_id
HAVING COUNT(*) >= 5
   AND SUM(valor_total) > 1000;
```

## Usando alias no HAVING

Em alguns bancos de dados, você pode usar o alias do SELECT no HAVING:

```sql
-- Funciona em MySQL e alguns outros bancos
SELECT marca, COUNT(*) AS quantidade
FROM produtos
GROUP BY marca
HAVING quantidade > 5;

-- Forma mais portável (funciona em todos os bancos)
SELECT marca, COUNT(*) AS quantidade
FROM produtos
GROUP BY marca
HAVING COUNT(*) > 5;
```

## Casos de Uso Comuns

```sql
-- Top 5 clientes que mais compraram
SELECT cliente_id, COUNT(*) AS total_compras
FROM pedidos
GROUP BY cliente_id
HAVING COUNT(*) > 1
ORDER BY total_compras DESC
LIMIT 5;

-- Produtos com avaliação média baixa (menos de 3 estrelas)
SELECT produto_id, AVG(nota) AS media_avaliacao
FROM avaliacoes
GROUP BY produto_id
HAVING AVG(nota) < 3;

-- Estados com mais de 100 clientes
SELECT estado, COUNT(*) AS total_clientes
FROM clientes
GROUP BY estado
HAVING COUNT(*) > 100
ORDER BY total_clientes DESC;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 41 - Desafio 1: Mostrar apenas categorias que tenham mais de 5 produtos


-- Aula 41 - Desafio 2: Mostrar apenas clientes que fizeram mais de 2 pedidos

```

</details>

</details>

---

## Resumo Rápido

| Comando | O que faz | Exemplo |
|---------|-----------|---------|
| `GROUP BY` | Agrupa linhas por valores iguais | `GROUP BY marca` |
| `GROUP BY col1, col2` | Agrupa por combinação de colunas | `GROUP BY estado, cidade` |
| `HAVING` | Filtra grupos após agregação | `HAVING COUNT(*) > 5` |

---

## Ordem de Execução do SQL

Quando você usa GROUP BY e HAVING, a ordem de execução é:

```sql
SELECT coluna, FUNCAO_AGREGACAO()   -- 5º Executado
FROM tabela                          -- 1º Executado
WHERE condição                       -- 2º Executado
GROUP BY coluna                      -- 3º Executado
HAVING condição_agregação            -- 4º Executado
ORDER BY coluna                      -- 6º Executado
LIMIT número                         -- 7º Executado
```

**Visualização:**

```
1. FROM      → Define de onde vêm os dados
2. WHERE     → Filtra as linhas individualmente
3. GROUP BY  → Agrupa as linhas filtradas
4. HAVING    → Filtra os grupos formados
5. SELECT    → Escolhe as colunas e calcula agregações
6. ORDER BY  → Ordena o resultado final
7. LIMIT     → Limita a quantidade de resultados
```

---

## WHERE vs HAVING - Quando usar cada um?

```sql
-- Use WHERE para filtrar LINHAS (dados individuais)
WHERE preco > 100
WHERE status = 'ativo'
WHERE data >= '2024-01-01'

-- Use HAVING para filtrar GRUPOS (resultados agregados)
HAVING COUNT(*) > 5
HAVING SUM(valor) > 1000
HAVING AVG(nota) >= 4
```

**Regra prática:** Se a condição envolve uma função de agregação (COUNT, SUM, AVG, MIN, MAX), use HAVING. Caso contrário, use WHERE.

---

## Checklist de Domínio

- [ ] Sei usar GROUP BY para agrupar dados
- [ ] Entendo a regra: colunas no SELECT devem estar no GROUP BY ou em funções de agregação
- [ ] Consigo agrupar por múltiplas colunas
- [ ] Sei extrair partes de datas para agrupar (ano, mês, dia)
- [ ] Entendo a diferença entre WHERE e HAVING
- [ ] Uso HAVING para filtrar grupos
- [ ] Consigo combinar WHERE e HAVING na mesma query
- [ ] Entendo a ordem de execução do SQL com GROUP BY

---

## Próximos Passos

1. **Pratique** todos os desafios de cada aula
2. **Experimente** diferentes combinações de agrupamento
3. **Crie** relatórios agregados complexos
4. **Avance** para o próximo módulo (JOINs)!

---

## Desafio Final do Módulo 9

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

Parabéns por chegar até aqui! Agora é hora de testar tudo que você aprendeu sobre agrupamento.

### Contexto

Você é analista de dados de um e-commerce e precisa criar relatórios gerenciais com dados agregados.

### Desafios

```sql
-- Desafio Final 1: Relatório de Vendas por Status
-- Mostre a quantidade de pedidos e o valor total para cada status
-- Ordene pelo valor total (maior primeiro)


-- Desafio Final 2: Análise de Clientes por Região
-- Conte quantos clientes existem em cada combinação de estado e cidade
-- Mostre apenas combinações com mais de 2 clientes
-- Ordene por estado e depois por quantidade (maior primeiro)


-- Desafio Final 3: Performance de Marcas
-- Para cada marca, mostre:
-- - Quantidade de produtos
-- - Preço médio (arredondado para 2 casas)
-- - Estoque total
-- Filtre apenas marcas com mais de 3 produtos
-- Ordene por quantidade de produtos (maior primeiro)


-- Desafio Final 4: Análise de Pagamentos
-- Agrupe pagamentos por método e status
-- Mostre a quantidade e o valor total de cada grupo
-- Filtre grupos com valor total superior a R$ 1000


-- Desafio Final 5: Relatório Mensal de Vendas (Desafio Avançado)
-- Crie um relatório com:
-- - Ano e mês do pedido
-- - Quantidade de pedidos
-- - Valor total
-- - Ticket médio (valor médio por pedido)
-- Considere apenas pedidos com status diferente de "cancelado"
-- Filtre meses com mais de 10 pedidos
-- Ordene por ano e mês


-- Desafio Final 6: Dashboard Completo (Boss Final!)
-- Crie uma consulta que mostre para cada categoria:
-- - ID da categoria
-- - Total de produtos
-- - Preço mínimo, médio e máximo
-- - Estoque total
-- - Valor total em estoque (soma de preco * estoque)
-- Filtre categorias onde:
-- - Existam mais de 5 produtos
-- - O valor em estoque seja maior que R$ 5000
-- Ordene pelo valor em estoque (maior primeiro)

```

### Dicas

- Lembre-se: colunas no SELECT precisam estar no GROUP BY ou em funções de agregação
- Use WHERE para filtrar antes do agrupamento
- Use HAVING para filtrar depois do agrupamento
- EXTRACT(YEAR/MONTH FROM data) ajuda a agrupar por períodos
- Você pode usar múltiplas funções de agregação no mesmo SELECT

</details>

---

## Como Usar Este Material

1. Estude uma aula por vez
2. Leia todos os conceitos com atenção
3. Pratique os desafios antes de avançar
4. Revise os conceitos quando necessário
5. Use o resumo para consultas rápidas

**Dica:** Cada aula tem seções expansíveis (clique para abrir/fechar) para facilitar a navegação!
