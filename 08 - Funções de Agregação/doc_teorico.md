# Módulo 8 - Funções de Agregação - Material Didático

## Objetivo do Módulo
Dominar as funções de agregação em SQL, aprendendo a contar, somar, calcular médias e encontrar valores mínimos e máximos em conjuntos de dados.

---
# AULA 33

<details>
<summary><strong>Expandir Aula 33</strong></summary>

## COUNT - Contando Registros

## O que é?

A função `COUNT` é usada para **contar** o número de registros (linhas) em uma tabela ou resultado de consulta.

## Sintaxe

```sql
-- Contar todas as linhas
SELECT COUNT(*) FROM tabela;

-- Contar valores não-nulos de uma coluna específica
SELECT COUNT(coluna) FROM tabela;
```

## Diferença entre COUNT(*) e COUNT(coluna)

```sql
-- COUNT(*) conta TODAS as linhas, incluindo NULLs
SELECT COUNT(*) FROM clientes;

-- COUNT(coluna) conta apenas valores NÃO NULOS
SELECT COUNT(telefone) FROM clientes;
```

**Exemplo prático:**
```
| id | nome  | telefone |
|----|-------|----------|
| 1  | João  | 11999... |
| 2  | Maria | NULL     |
| 3  | Pedro | 21888... |

COUNT(*)         = 3 (conta todas as linhas)
COUNT(telefone)  = 2 (ignora o NULL da Maria)
```

## Quando usar?

- Saber quantos registros existem em uma tabela
- Verificar quantos itens atendem a uma condição (com WHERE)
- Validar se há dados antes de processar
- Gerar estatísticas e relatórios

## Combinando com WHERE

```sql
-- Quantos pedidos foram feitos em 2024?
SELECT COUNT(*) FROM pedidos WHERE data_pedido >= '2024-01-01';

-- Quantos produtos custam mais de R$ 500?
SELECT COUNT(*) FROM produtos WHERE preco > 500;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 33 - Desafio 1: Contar quantos produtos existem no banco


-- Aula 33 - Desafio 2: Contar quantos pedidos foram feitos em 2025

```

</details>

</details>

---

# AULA 34

<details>
<summary><strong>Expandir Aula 34</strong></summary>

## COUNT DISTINCT - Contando Valores Únicos

## O que é?

`COUNT(DISTINCT coluna)` conta apenas os **valores únicos** (diferentes) de uma coluna, ignorando duplicatas.

## Sintaxe

```sql
SELECT COUNT(DISTINCT coluna) FROM tabela;
```

## Como funciona?

**Dados da coluna `marca`:**
```
Samsung
Apple
Samsung
LG
Apple
Samsung
Sony
```

```sql
-- COUNT normal: conta todas as ocorrências
SELECT COUNT(marca) FROM produtos;
-- Resultado: 7

-- COUNT DISTINCT: conta valores únicos
SELECT COUNT(DISTINCT marca) FROM produtos;
-- Resultado: 4 (Samsung, Apple, LG, Sony)
```

## Casos de Uso Práticos

```sql
-- Quantas marcas diferentes vendemos?
SELECT COUNT(DISTINCT marca) FROM produtos;

-- Em quantas cidades temos clientes?
SELECT COUNT(DISTINCT cidade) FROM clientes;

-- Quantos clientes fizeram pedidos?
SELECT COUNT(DISTINCT cliente_id) FROM pedidos;

-- Quantos dias diferentes tiveram vendas?
SELECT COUNT(DISTINCT data_pedido) FROM pedidos;
```

## Atenção

- NULL é ignorado no COUNT DISTINCT
- COUNT DISTINCT pode ser mais lento em tabelas muito grandes
- Útil para análise de diversidade de dados

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 34 - Desafio 1: Contar quantas marcas diferentes de produtos existem


-- Aula 34 - Desafio 2: Contar em quantas cidades diferentes temos clientes

```

</details>

</details>

---

# AULA 35

<details>
<summary><strong>Expandir Aula 35</strong></summary>

## SUM - Somando Valores

## O que é?

A função `SUM` **soma** todos os valores numéricos de uma coluna.

## Sintaxe

```sql
SELECT SUM(coluna_numerica) FROM tabela;
```

## Exemplos Práticos

```sql
-- Valor total de todos os pedidos
SELECT SUM(valor_total) FROM pedidos;

-- Estoque total de todos os produtos
SELECT SUM(estoque) FROM produtos;

-- Soma dos valores de pagamentos aprovados
SELECT SUM(valor) FROM pagamentos WHERE status = 'aprovado';
```

## Cuidados Importantes

```sql
-- SUM ignora valores NULL
| valor |
|-------|
| 100   |
| NULL  |
| 200   |

SELECT SUM(valor) FROM tabela;
-- Resultado: 300 (NULL é ignorado)
```

## SUM só funciona com números!

```sql
-- Funciona
SELECT SUM(preco) FROM produtos;
SELECT SUM(estoque) FROM produtos;

-- Erro! Não funciona com texto
SELECT SUM(nome) FROM produtos;  -- ERRO!
```

## Combinando com WHERE

```sql
-- Soma dos pedidos entregues
SELECT SUM(valor_total) FROM pedidos WHERE status = 'entregue';

-- Valor total em estoque de produtos Samsung
SELECT SUM(preco * estoque) FROM produtos WHERE marca = 'Samsung';
```

## Usando Alias para melhor leitura

```sql
SELECT SUM(valor_total) AS "Faturamento Total" FROM pedidos;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 35 - Desafio 1: Calcular o valor total de todos os pedidos


-- Aula 35 - Desafio 2: Calcular o estoque total de todos os produtos

```

</details>

</details>

---

# AULA 36

<details>
<summary><strong>Expandir Aula 36</strong></summary>

## AVG - Calculando Média

## O que é?

A função `AVG` (Average) calcula a **média aritmética** dos valores numéricos de uma coluna.

## Sintaxe

```sql
SELECT AVG(coluna_numerica) FROM tabela;
```

## Como funciona?

```
Valores: 100, 200, 300, 400, 500
Média = (100 + 200 + 300 + 400 + 500) / 5 = 300
```

```sql
SELECT AVG(preco) FROM produtos;
-- Se os preços forem 100, 200, 300, 400, 500
-- Resultado: 300
```

## Cuidado com NULL!

```sql
| preco |
|-------|
| 100   |
| NULL  |
| 200   |

-- AVG ignora NULL na contagem!
SELECT AVG(preco) FROM tabela;
-- Resultado: 150 (soma 300 / 2 registros, não 3!)
```

**Importante:** NULL não é considerado como zero, ele é simplesmente ignorado!

## Exemplos Práticos

```sql
-- Preço médio dos produtos
SELECT AVG(preco) AS "Preço Médio" FROM produtos;

-- Valor médio dos pedidos
SELECT AVG(valor_total) AS "Ticket Médio" FROM pedidos;

-- Nota média das avaliações
SELECT AVG(nota) AS "Avaliação Média" FROM avaliacoes;
```

## Arredondando o Resultado

```sql
-- AVG pode retornar muitas casas decimais
SELECT AVG(preco) FROM produtos;
-- Resultado: 1234.567891234...

-- Use ROUND para arredondar
SELECT ROUND(AVG(preco), 2) AS "Preço Médio" FROM produtos;
-- Resultado: 1234.57
```

## Combinando com WHERE

```sql
-- Preço médio de produtos Samsung
SELECT AVG(preco) FROM produtos WHERE marca = 'Samsung';

-- Valor médio de pedidos entregues
SELECT AVG(valor_total) FROM pedidos WHERE status = 'entregue';
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 36 - Desafio 1: Calcular o preço médio dos produtos


-- Aula 36 - Desafio 2: Calcular o valor médio dos pedidos

```

</details>

</details>

---

# AULA 37

<details>
<summary><strong>Expandir Aula 37</strong></summary>

## MIN - Encontrando Mínimo

## O que é?

A função `MIN` retorna o **menor valor** de uma coluna.

## Sintaxe

```sql
SELECT MIN(coluna) FROM tabela;
```

## Funciona com diferentes tipos de dados

```sql
-- Números: retorna o menor valor numérico
SELECT MIN(preco) FROM produtos;
-- Resultado: 29.90

-- Datas: retorna a data mais antiga
SELECT MIN(data_pedido) FROM pedidos;
-- Resultado: 2024-01-01

-- Texto: retorna o primeiro em ordem alfabética
SELECT MIN(nome) FROM produtos;
-- Resultado: "Ar Condicionado"
```

## Exemplos Práticos

```sql
-- Produto mais barato
SELECT MIN(preco) AS "Menor Preço" FROM produtos;

-- Primeiro pedido feito
SELECT MIN(data_pedido) AS "Primeiro Pedido" FROM pedidos;

-- Menor valor de pagamento
SELECT MIN(valor) AS "Menor Pagamento" FROM pagamentos;

-- Menor estoque
SELECT MIN(estoque) AS "Estoque Crítico" FROM produtos;
```

## Combinando com WHERE

```sql
-- Produto mais barato da marca Samsung
SELECT MIN(preco) FROM produtos WHERE marca = 'Samsung';

-- Menor pedido de 2024
SELECT MIN(valor_total) FROM pedidos WHERE data_pedido >= '2024-01-01';
```

## Limitação do MIN

```sql
-- MIN retorna apenas o VALOR, não a linha inteira!
SELECT MIN(preco) FROM produtos;
-- Retorna: 29.90

-- Se quiser saber QUAL produto é o mais barato:
SELECT nome, preco FROM produtos ORDER BY preco ASC LIMIT 1;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 37 - Desafio 1:  Encontre o menor preço dos produto da categoria Automotivo


-- Aula 37 - Desafio 2: Identifique o menor desconto aplicado em pedidos com desconto

```

</details>

</details>

---

# AULA 38

<details>
<summary><strong>Expandir Aula 38</strong></summary>

## MAX - Encontrando Máximo

## O que é?

A função `MAX` retorna o **maior valor** de uma coluna.

## Sintaxe

```sql
SELECT MAX(coluna) FROM tabela;
```

## Funciona com diferentes tipos de dados

```sql
-- Números: retorna o maior valor numérico
SELECT MAX(preco) FROM produtos;
-- Resultado: 8999.90

-- Datas: retorna a data mais recente
SELECT MAX(data_pedido) FROM pedidos;
-- Resultado: 2024-12-31

-- Texto: retorna o último em ordem alfabética
SELECT MAX(nome) FROM produtos;
-- Resultado: "Xbox Series X"
```

## Exemplos Práticos

```sql
-- Produto mais caro
SELECT MAX(preco) AS "Maior Preço" FROM produtos;

-- Pedido mais recente
SELECT MAX(data_pedido) AS "Último Pedido" FROM pedidos;

-- Maior valor de pagamento
SELECT MAX(valor) AS "Maior Pagamento" FROM pagamentos;

-- Maior estoque
SELECT MAX(estoque) AS "Maior Estoque" FROM produtos;
```

## Combinando com WHERE

```sql
-- Produto mais caro da marca Apple
SELECT MAX(preco) FROM produtos WHERE marca = 'Apple';

-- Maior pedido de 2024
SELECT MAX(valor_total) FROM pedidos WHERE data_pedido >= '2024-01-01';

-- Melhor avaliação
SELECT MAX(nota) FROM avaliacoes;
```

## MIN e MAX juntos

```sql
-- Ver amplitude de preços
SELECT
    MIN(preco) AS "Menor Preço",
    MAX(preco) AS "Maior Preço"
FROM produtos;

-- Período de vendas
SELECT
    MIN(data_pedido) AS "Primeira Venda",
    MAX(data_pedido) AS "Última Venda"
FROM pedidos;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 38 - Desafio 1: Encontrar o produto mais caro


-- Aula 38 - Desafio 2: Encontrar o valor do maior pedido

```

</details>

</details>

---

## Resumo Rápido

| Função | O que faz | Exemplo |
|--------|-----------|---------|
| `COUNT(*)` | Conta todas as linhas | `SELECT COUNT(*) FROM produtos` |
| `COUNT(coluna)` | Conta valores não-nulos | `SELECT COUNT(telefone) FROM clientes` |
| `COUNT(DISTINCT)` | Conta valores únicos | `SELECT COUNT(DISTINCT marca) FROM produtos` |
| `SUM` | Soma valores numéricos | `SELECT SUM(valor_total) FROM pedidos` |
| `AVG` | Calcula a média | `SELECT AVG(preco) FROM produtos` |
| `MIN` | Encontra o menor valor | `SELECT MIN(preco) FROM produtos` |
| `MAX` | Encontra o maior valor | `SELECT MAX(preco) FROM produtos` |

---

## Combinando Funções de Agregação

Você pode usar várias funções de agregação na mesma consulta:

```sql
SELECT
    COUNT(*) AS "Total de Produtos",
    SUM(estoque) AS "Estoque Total",
    AVG(preco) AS "Preço Médio",
    MIN(preco) AS "Menor Preço",
    MAX(preco) AS "Maior Preço"
FROM produtos;
```

---

## Checklist de Domínio

- [ ] Sei usar COUNT(*) para contar todas as linhas
- [ ] Entendo a diferença entre COUNT(*) e COUNT(coluna)
- [ ] Uso COUNT DISTINCT para contar valores únicos
- [ ] Consigo somar valores com SUM
- [ ] Sei calcular médias com AVG
- [ ] Entendo como NULL afeta AVG
- [ ] Uso MIN para encontrar o menor valor
- [ ] Uso MAX para encontrar o maior valor
- [ ] Sei combinar várias funções de agregação
- [ ] Consigo usar funções de agregação com WHERE

---

## Próximos Passos

1. **Pratique** todos os desafios de cada aula
2. **Experimente** combinar as funções de agregação
3. **Crie** suas próprias queries de análise
4. **Avance** para o próximo módulo (GROUP BY)!

---

## Desafio Final do Módulo 8

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

Parabéns por chegar até aqui! Agora é hora de testar tudo que você aprendeu sobre funções de agregação.

### Contexto

Você é analista de dados de um e-commerce e precisa gerar relatórios estatísticos para a diretoria.

### Desafios

```sql
-- Desafio Final 1: Visão Geral do Catálogo
-- Mostre em uma única consulta:
-- - Total de produtos cadastrados
-- - Quantidade total em estoque
-- - Preço médio dos produtos (arredondado para 2 casas)
-- - Produto mais barato
-- - Produto mais caro


-- Desafio Final 2: Análise de Vendas
-- Mostre em uma única consulta:
-- - Total de pedidos realizados
-- - Valor total vendido
-- - Ticket médio (valor médio por pedido)
-- - Menor pedido
-- - Maior pedido


-- Desafio Final 3: Diversidade de Clientes
-- Descubra:
-- - Quantos clientes estão cadastrados
-- - Em quantas cidades diferentes
-- - Em quantos estados diferentes


-- Desafio Final 4: Estatísticas de Avaliações
-- Mostre:
-- - Total de avaliações
-- - Nota média (arredondada para 1 casa decimal)
-- - Menor nota
-- - Maior nota


-- Desafio Final 5: Análise de Pagamentos (Desafio Avançado)
-- Para pagamentos com status "aprovado":
-- - Quantos pagamentos foram aprovados
-- - Valor total aprovado
-- - Valor médio aprovado
-- - Quantos métodos de pagamento diferentes foram usados


-- Desafio Final 6: Relatório Completo (Boss Final!)
-- Crie uma consulta que mostre para produtos da marca "Samsung":
-- - Quantidade de produtos Samsung
-- - Estoque total de produtos Samsung
-- - Preço médio (arredondado)
-- - Produto Samsung mais barato
-- - Produto Samsung mais caro

```

### Dicas

- Use `AS` para dar nomes amigáveis aos resultados
- Combine várias funções de agregação na mesma consulta
- Use `ROUND(valor, casas_decimais)` para arredondar
- Use `WHERE` para filtrar antes de agregar

</details>

---

## Como Usar Este Material

1. Estude uma aula por vez
2. Leia todos os conceitos com atenção
3. Pratique os desafios antes de avançar
4. Revise os conceitos quando necessário
5. Use o resumo para consultas rápidas

**Dica:** Cada aula tem seções expansíveis (clique para abrir/fechar) para facilitar a navegação!
