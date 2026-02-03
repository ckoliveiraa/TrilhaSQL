# Módulo 1 - Fundamentos SELECT - Material Didático

## 🎯 Objetivo do Módulo
Dominar os fundamentos da consulta de dados em SQL, aprendendo a selecionar, filtrar e organizar informações de forma eficiente.

---
# AULA 1

<details>
<summary><strong>Expandir Aula 1</strong></summary>

## SELECT * - Sua Primeira Consulta SQL

## 📝 O que é?

O comando `SELECT` é o comando mais importante do SQL. Ele é usado para **consultar** (buscar/ler) dados de uma tabela.

O asterisco `*` significa "todas as colunas".

## 💡 Sintaxe

```sql
SELECT * FROM nome_da_tabela;
```

## ⚠️ Quando usar?

- ✅ Quando você quer ver TODOS os dados de uma tabela
- ✅ Para explorar uma tabela nova que você não conhece
- ❌ EVITE em produção com tabelas grandes (pode ser lento)

## 🎓 Conceitos Importantes

- SQL termina com ponto e vírgula `;`
- SQL não é case-sensitive (SELECT = select = SeLeCt)
- Mas é boa prática usar MAIÚSCULAS para comandos SQL

## 🎯 Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 1 - Desafio 1: Visualizar todos os dados da tabela produtos


-- Aula 1 - Desafio 2: Visualizar todos os dados da tabela clientes

```

</details>

</details>

---

# AULA 2

<details>
<summary><strong>Expandir Aula 2</strong></summary>

## SELECT com Colunas Específicas

## 📝 O que é?

Em vez de buscar TODAS as colunas, você pode selecionar apenas as colunas que precisa.

## 💡 Sintaxe

```sql
SELECT coluna1, coluna2, coluna3 FROM nome_da_tabela;
```

## ✅ Vantagens

- **Performance**: Mais rápido que SELECT *
- **Clareza**: Você vê só o que precisa
- **Economia**: Usa menos memória e rede

## 💭 Dica Profissional

Sempre especifique as colunas em queries de produção. SELECT * só para exploração!

## 🎯 Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 2 - Desafio 1: Mostrar apenas nome e preço dos produtos


-- Aula 2 - Desafio 2: Mostrar apenas nome, email e cidade dos clientes

```

</details>

</details>

---

# AULA 3

<details>
<summary><strong>Expandir Aula 3</strong></summary>

## AS - Criando Aliases para Colunas

## 📝 O que é?

AS permite dar um "apelido" (alias) para uma coluna no resultado da consulta. O nome original no banco não muda!

## 💡 Sintaxe

```sql
SELECT coluna AS novo_nome FROM tabela;

-- AS é opcional, mas recomendado para clareza
SELECT coluna novo_nome FROM tabela;
```

## 🎯 Quando usar?

- Para deixar relatórios mais legíveis
- Quando o nome da coluna é técnico/confuso
- Para padronizar nomes em diferentes tabelas
- Em queries complexas para organização

## ⚠️ Atenção

- Use aspas duplas `" "` quando o alias tiver espaços ou caracteres especiais
- Sem espaços, as aspas são opcionais

**Exemplo:**
```sql
-- Com espaços (precisa de aspas)
SELECT nome AS "Nome do Produto" FROM produtos;

-- Sem espaços (aspas opcionais)
SELECT nome AS NomeProduto FROM produtos;
```

## 🎯 Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 3 - Desafio 1: Renomear colunas para nomes mais amigáveis
-- Selecione nome, preco e estoque com aliases "Nome do Produto", "Preço (R$)" e "Quantidade em Estoque"


-- Aula 3 - Desafio 2: Criar um relatório de pedidos
-- Selecione data_pedido, valor_total e status com aliases "Data da Compra", "Valor Total (R$)" e "Status do Pedido"

```

</details>

</details>

---

# AULA 4

<details>
<summary><strong>Expandir Aula 4</strong></summary>

## DISTINCT - Removendo Duplicatas

## 📝 O que é?

DISTINCT remove valores duplicados do resultado, mostrando apenas valores únicos.

## 💡 Sintaxe

```sql
SELECT DISTINCT coluna FROM tabela;

-- Com múltiplas colunas
SELECT DISTINCT coluna1, coluna2 FROM tabela;
```

## 🔍 Como funciona?

**SEM DISTINCT:**
```
São Paulo
São Paulo
Rio de Janeiro
São Paulo
Belo Horizonte
```

**COM DISTINCT:**
```
São Paulo
Rio de Janeiro
Belo Horizonte
```

## 💭 Casos de Uso

- Descobrir quais valores existem em uma coluna
- Análise exploratória de dados
- Relatórios de categorias/grupos
- Limpeza de dados duplicados

## 🎯 Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 4 - Desafio 1: Listar todas as cidades únicas dos clientes


-- Aula 4 - Desafio 2: Listar todas as marcas únicas de produtos


```

</details>

</details>

---

# AULA 5

<details>
<summary><strong>Expandir Aula 5</strong></summary>

## LIMIT - Limitando Resultados

## 📝 O que é?

LIMIT controla quantas linhas você quer no resultado da consulta.

## 💡 Sintaxe

```sql
SELECT colunas FROM tabela LIMIT número;
```

## 🎯 Quando usar?

- ✅ Testar queries antes de executar em tabelas grandes
- ✅ Ver uma "amostra" dos dados
- ✅ Pegar apenas os primeiros N resultados
- ✅ Proteger contra consultas que retornam milhões de linhas

## ⚡ Performance

LIMIT é executado DEPOIS de buscar os dados, então:

```sql
-- Isso ainda processa 1 milhão de linhas!
SELECT * FROM tabela_gigante LIMIT 10;
```

## 🎯 Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 5 - Desafio 1: Mostrar uma amostra de 5 produtos (todas as colunas)


-- Aula 5 - Desafio 2: Mostrar apenas 3 clientes, exibindo nome e email

```

</details>

</details>

---

# AULA 6

<details>
<summary><strong>Expandir Aula 6</strong></summary>

## ORDER BY - Ordenando Resultados

## 📝 O que é?

ORDER BY permite **ordenar** os resultados da consulta em ordem crescente ou decrescente.

## 💡 Sintaxe

```sql
-- Ordem crescente (padrão)
SELECT colunas FROM tabela ORDER BY coluna;

-- Ordem crescente (explícita)
SELECT colunas FROM tabela ORDER BY coluna ASC;

-- Ordem decrescente
SELECT colunas FROM tabela ORDER BY coluna DESC;
```

## 🔤 ASC vs DESC

- **ASC** (Ascending): Ordem crescente (A→Z, 1→100, mais antigo→mais novo)
- **DESC** (Descending): Ordem decrescente (Z→A, 100→1, mais novo→mais antigo)

## 📊 Ordenando por Múltiplas Colunas

```sql
-- Ordena por categoria, depois por preço dentro de cada categoria
SELECT nome, categoria, preco
FROM produtos
ORDER BY categoria ASC, preco DESC;
```

## 💭 Combinando com LIMIT

```sql
-- Top 10 produtos mais caros
SELECT nome, preco
FROM produtos
ORDER BY preco DESC
LIMIT 10;

-- 5 clientes mais recentes
SELECT nome, data_cadastro
FROM clientes
ORDER BY data_cadastro DESC
LIMIT 5;
```

## ⚠️ Atenção

- ORDER BY vem **ANTES** do LIMIT
- Sem ORDER BY, a ordem dos resultados não é garantida
- Ordenar dados grandes pode impactar a performance

## 🎯 Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 6 - Desafio 1: Listar produtos ordenados por preço do mais barato ao mais caro


-- Aula 6 - Desafio 2: Listar os 10 últimos pagamentos

```

</details>

</details>

---

# AULA 7

<details>
<summary><strong>Expandir Aula 7</strong></summary>

## WHERE - Filtrando com Igualdade

## 📝 O que é?

WHERE é usado para **filtrar** os dados, mostrando apenas as linhas que atendem a uma condição.

## 💡 Sintaxe

```sql
SELECT colunas FROM tabela WHERE condição;
```

## 🔤 Importante sobre Texto

```sql
-- Textos (strings) usam aspas simples ' '
WHERE marca = 'Nike'  ✅
WHERE marca = "Nike"  ❌ (funciona em alguns bancos, mas evite)
WHERE marca = Nike    ❌ (vai dar erro!)

-- SQL é case-sensitive com valores!
WHERE marca = 'Nike'  ≠  WHERE marca = 'nike'
```

## 🔢 Filtrando Números

```sql
-- Números NÃO usam aspas
SELECT * FROM produtos WHERE preco = 199.90;
SELECT * FROM clientes WHERE id = 42;
```

## 💭 Conceito Fundamental

WHERE funciona como um "filtro":
- Ele verifica cada linha da tabela
- Se a condição for verdadeira, a linha aparece no resultado
- Se for falsa, a linha é ignorada

## 🔗 Combinando com ORDER BY

```sql
-- Produtos da Nike ordenados por preço (mais barato primeiro)
SELECT nome, preco
FROM produtos
WHERE marca = 'Nike'
ORDER BY preco ASC;

-- Clientes de SP ordenados por nome
SELECT nome, cidade
FROM clientes
WHERE estado = 'SP'
ORDER BY nome;
```

**Lembre-se:** A ordem é sempre `SELECT → FROM → WHERE → ORDER BY`

## 🎯 Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 7 - Desafio 1: Mostrar apenas pedidos em separação


-- Aula 7 - Desafio 2: Mostrar as últimas 5 avaliações nota 1


```

</details>

</details>

---

# AULA 8

<details>
<summary><strong>Expandir Aula 8</strong></summary>

## WHERE com Maior e Menor (>, <, >=, <=)

## 📝 O que é?

Operadores de comparação para filtrar valores numéricos e datas.

## 💡 Operadores Disponíveis

```sql
>   Maior que
<   Menor que
>=  Maior ou igual
<=  Menor ou igual
```

## 📅 Funciona com Datas!

```sql
-- Pedidos feitos depois de 01/01/2024
SELECT * FROM pedidos WHERE data_pedido > '2024-01-01';

-- Clientes nascidos antes de 1990
SELECT * FROM clientes WHERE data_nascimento < '1990-01-01';
```

## ⚠️ Cuidado com Igualdade vs Comparação

```sql
=  é igualdade
>  é maior
>= é maior OU igual (inclui o valor)
<  é menor
<= é menor OU igual (inclui o valor)
```

**Exemplo:**
```sql
-- Maior que 100 (não inclui 100)
WHERE preco > 100

-- Maior ou igual a 100 (inclui 100)
WHERE preco >= 100
```

## 🎯 Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 8 - Desafio 1: Produtos com preço maior que R$ 500


-- Aula 8 - Desafio 2: Produtos com estoque menor que 20 unidades


```

</details>

</details>

---

# AULA 9

<details>
<summary><strong>Expandir Aula 9</strong></summary>

## WHERE com Diferente (<> ou !=)

## 📝 O que é?

Operador para filtrar valores que são **diferentes** de algo.

## 💡 Sintaxe

```sql
-- Duas formas (ambas funcionam igualmente)
WHERE coluna <> valor
WHERE coluna != valor
```

## 🤔 Qual usar: <> ou != ?

- `<>` é o padrão SQL (mais portável)
- `!=` funciona na maioria dos bancos (MySQL, PostgreSQL)
- **Recomendação**: Use `<>` para compatibilidade

## ⚠️ CUIDADO com NULL!

```sql
-- Isto NÃO funciona como esperado!
WHERE telefone <> NULL  ❌

-- Forma correta para NULL:
WHERE telefone IS NOT NULL  ✅
```

**Importante:** NULL não é um valor, é a ausência de valor. Por isso precisa de operadores especiais.

## 💭 Quando usar?

- Excluir um valor específico
- Filtrar "todos exceto X"
- Encontrar anomalias (ex: status != 'Ativo')

## 🎯 Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 9 - Desafio 1: Pedidos com status diferente de "Entregue"


-- Aula 9 - Desafio 2: Listar as avaliações sem comentários

```

</details>

</details>

---

# AULA 10

<details>
<summary><strong>Expandir Aula 10</strong></summary>

## AND - Combinando Condições

## 📝 O que é?

AND permite combinar **múltiplas condições** que devem ser **TODAS verdadeiras** ao mesmo tempo.

## 💡 Sintaxe

```sql
SELECT * FROM tabela 
WHERE condição1 AND condição2 AND condição3;
```

## 🧠 Lógica do AND

```
Condição 1: Verdadeira  AND  Condição 2: Verdadeira  = ✅ Aparece
Condição 1: Verdadeira  AND  Condição 2: Falsa      = ❌ Não aparece
Condição 1: Falsa       AND  Condição 2: Verdadeira = ❌ Não aparece
Condição 1: Falsa       AND  Condição 2: Falsa      = ❌ Não aparece
```

**Resumo:** TODAS as condições precisam ser verdadeiras!

## 💡 Múltiplas Condições

```sql
-- Você pode ter quantas condições quiser!
SELECT * 
FROM produtos 
WHERE categoria = 'Eletrônicos' 
  AND marca = 'Samsung' 
  AND preco > 500 
  AND estoque > 0;
```

**Dica de formatação:** Use uma linha para cada condição AND para facilitar a leitura!

## 🎯 Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 10 - Desafio 1: Produtos da marca "Samsung" com preço maior que R$ 1000


-- Aula 10 - Desafio 2: Pedidos entregues que possuem data de entrega registrada

```

</details>

</details>

---

# AULA 11

<details>
<summary><strong>Expandir Aula 11</strong></summary>

## OR - Condições Alternativas

## 📝 O que é?

OR permite combinar condições onde **pelo menos UMA** precisa ser verdadeira.

## 💡 Sintaxe

```sql
SELECT * FROM tabela 
WHERE condição1 OR condição2 OR condição3;
```

## 🧠 Lógica do OR

```
Condição 1: Verdadeira  OR  Condição 2: Verdadeira  = ✅ Aparece
Condição 1: Verdadeira  OR  Condição 2: Falsa      = ✅ Aparece
Condição 1: Falsa       OR  Condição 2: Verdadeira = ✅ Aparece
Condição 1: Falsa       OR  Condição 2: Falsa      = ❌ Não aparece
```

**Resumo:** Pelo menos UMA condição precisa ser verdadeira!

## 🎯 Diferença AND vs OR

```sql
-- AND = TODAS as condições devem ser verdadeiras
WHERE marca = 'Nike' AND preco > 100
-- Resultado: Produtos Nike que custam mais de R$100

-- OR = PELO MENOS UMA condição deve ser verdadeira
WHERE marca = 'Nike' OR preco > 100
-- Resultado: Produtos Nike OU produtos caros (de qualquer marca)
```

## ⚠️ Combinando AND e OR - USE PARÊNTESES!

```sql
-- ERRADO (ambíguo):
WHERE marca = 'Nike' OR marca = 'Adidas' AND preco > 100

-- CORRETO (claro):
WHERE (marca = 'Nike' OR marca = 'Adidas') AND preco > 100
-- Produtos Nike ou Adidas que custam mais de R$100

-- CORRETO (outro exemplo):
WHERE marca = 'Nike' OR (marca = 'Adidas' AND preco > 100)
-- Todos os Nike OU Adidas que custam mais de R$100
```

**Importante:** Os parênteses controlam a ordem de avaliação, como na matemática!

## 🎯 Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 11 - Desafio 1: Produtos premium de marcas específicas
-- Encontre produtos que sejam: marca "Samsung" OU marca "Sony" E preço maior que 2000
-- Traga somente as colunas necessárias

-- Aula 11 - Desafio 2: Pagamentos problemáticos
-- Encontre pagamentos que sejam  Pix ou boleto e não tenham sido aprovados
-- Traga somente as colunas necessárias

```

</details>

</details>

---

## 🎓 Resumo Rápido

| Comando | Função | Exemplo |
|---------|--------|---------|
| `SELECT *` | Busca todas as colunas | `SELECT * FROM produtos` |
| `SELECT col1, col2` | Busca colunas específicas | `SELECT nome, preco FROM produtos` |
| `AS` | Renomeia colunas | `SELECT nome AS "Produto"` |
| `DISTINCT` | Remove duplicatas | `SELECT DISTINCT cidade FROM clientes` |
| `LIMIT` | Limita quantidade de resultados | `SELECT * FROM produtos LIMIT 10` |
| `ORDER BY` | Ordena resultados | `ORDER BY preco DESC` |
| `WHERE =` | Filtra por igualdade | `WHERE marca = 'Nike'` |
| `WHERE >, <` | Filtra por comparação | `WHERE preco > 100` |
| `WHERE <>` | Filtra por diferença | `WHERE status <> 'Entregue'` |
| `AND` | Combina condições (todas) | `WHERE preco > 100 AND estoque > 50` |
| `OR` | Combina condições (pelo menos uma) | `WHERE estado = 'SP' OR estado = 'RJ'` |

---

## 🎯 Checklist de Domínio

- [ ] Sei usar SELECT * e SELECT com colunas específicas
- [ ] Consigo renomear colunas com AS
- [ ] Entendo como DISTINCT remove duplicatas
- [ ] Uso LIMIT para controlar resultados
- [ ] Sei usar ORDER BY para ordenar resultados
- [ ] Domino WHERE com = para filtrar
- [ ] Sei usar operadores >, <, >=, <=
- [ ] Entendo quando usar <> (diferente)
- [ ] Combino múltiplas condições com AND
- [ ] Uso OR para condições alternativas
- [ ] Sei a diferença entre AND e OR

---

## 💪 Próximos Passos

1. **Pratique** todos os desafios de cada aula
2. **Experimente** combinar os comandos
3. **Crie** suas próprias queries
4. **Avance** para o próximo módulo!

---

## 🔢 Ordem dos Comandos SQL

Ao escrever uma query SQL, os comandos devem seguir uma **ordem específica**. Aqui está a ordem correta de todos os comandos aprendidos neste módulo:

```sql
SELECT [DISTINCT] colunas [AS alias]
FROM tabela
WHERE condição [AND/OR condição]
ORDER BY coluna [ASC/DESC]
LIMIT número;
```

### Por que essa ordem?

O SQL foi projetado para ser lido de forma **declarativa** (você diz O QUE quer, não COMO fazer). A ordem reflete a lógica de processamento:

| Ordem | Comando | O que faz | Por que nessa posição? |
|-------|---------|-----------|------------------------|
| 1º | `SELECT` | Define quais colunas você quer | Sempre primeiro - é o objetivo da query |
| 2º | `FROM` | Define de qual tabela buscar | Precisa saber DE ONDE vêm os dados |
| 3º | `WHERE` | Filtra as linhas | Filtra ANTES de ordenar (mais eficiente) |
| 4º | `ORDER BY` | Ordena os resultados | Ordena só o que passou pelo filtro |
| 5º | `LIMIT` | Limita a quantidade | Sempre por último - corta o resultado final |

### Exemplo Completo

```sql
SELECT DISTINCT nome AS "Produto", preco AS "Preço"
FROM produtos
WHERE marca = 'Nike' AND preco > 100
ORDER BY preco DESC
LIMIT 10;
```

**Leitura:** "Selecione nome e preço (sem duplicatas) dos produtos, onde a marca seja Nike E o preço maior que 100, ordenado por preço decrescente, limitado a 10 resultados."

### ⚠️ Erros Comuns

```sql
-- ❌ ERRADO: LIMIT antes de ORDER BY
SELECT * FROM produtos LIMIT 10 ORDER BY preco;

-- ❌ ERRADO: WHERE depois de ORDER BY
SELECT * FROM produtos ORDER BY preco WHERE marca = 'Nike';

-- ✅ CORRETO: Ordem certa
SELECT * FROM produtos WHERE marca = 'Nike' ORDER BY preco LIMIT 10;
```

---

## 🏆 Desafio Final do Módulo 1

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

Parabéns por chegar até aqui! Agora é hora de testar tudo que você aprendeu em um cenário real de e-commerce.

### 📋 Contexto

Você é analista de dados de um e-commerce e precisa gerar relatórios para diferentes áreas da empresa. Use as tabelas disponíveis: `produtos`, `clientes`, `pedidos`, `pagamentos` e `avaliacoes`.

### 🎯 Desafios

```sql
-- Desafio Final 1: Catálogo de Produtos Premium
-- Liste nome, marca e preço dos produtos com preço maior que R$ 2000
-- Ordene do mais caro para o mais barato
-- Renomeie as colunas para "Produto", "Fabricante" e "Valor (R$)"


-- Desafio Final 2: Análise de Estoque Crítico
-- Encontre produtos com estoque menor que 50 unidades OU preço menor que R$ 200
-- Mostre nome, estoque e preço, ordenados por estoque (menor primeiro)
-- Limite a 10 resultados


-- Desafio Final 3: Clientes por Região
-- Liste todos os estados únicos onde há clientes cadastrados
-- Ordene em ordem alfabética


-- Desafio Final 4: Relatório de Pedidos
-- Mostre os 15 pedidos mais recentes com status "entregue"
-- Exiba data_pedido (como "Data"), valor_total (como "Total") e status
-- Ordene pela data mais recente primeiro


-- Desafio Final 5: Produtos em Destaque (Desafio Avançado)
-- Encontre produtos que sejam:
-- (marca "Samsung" E preço > 1000) OU (marca "Sony" E estoque > 100)
-- Mostre nome, marca, preço e estoque
-- Ordene por preço decrescente


-- Desafio Final 6: Análise de Avaliações
-- Liste as 10 piores avaliações (nota = 1 ou nota = 2)
-- Mostre nota (como "Estrelas") e comentario (como "Feedback")
-- Ordene pela nota (menor primeiro)


-- Desafio Final 7: Pagamentos Pendentes
-- Encontre pagamentos com status diferente de "aprovado"
-- Mostre metodo (como "Forma de Pagamento"), valor e status
-- Ordene pelo valor (maior primeiro), limitado a 20 resultados


-- Desafio Final 8: Relatório Completo (Boss Final!)
-- Crie uma consulta que mostre:
-- - Nome do produto (como "Produto")
-- - Marca (como "Fabricante")
-- - Preço (como "Preço (R$)")
-- - Estoque (como "Qtd Disponível")
-- Filtros: marca = "Samsung" OU marca = "LG" OU marca = "Sony"
--          E preço entre 1000 e 5000 (use >= e <=)
--          E estoque > 0
-- Ordenado por marca (A-Z), depois por preço (menor para maior)
-- Limitado aos 20 primeiros resultados

```

### 💡 Dicas

- Lembre-se da ordem: `SELECT → FROM → WHERE → ORDER BY → LIMIT`
- Use aspas simples para textos: `'Samsung'`
- Use parênteses para agrupar condições com AND e OR
- Aspas duplas são para aliases com espaços: `AS "Nome do Produto"`

</details>

---

## 📖 Como Usar Este Material

1. Estude uma aula por vez
2. Leia todos os conceitos com atenção
3. Pratique os desafios antes de avançar
4. Revise os conceitos quando necessário
5. Use o resumo para consultas rápidas

**Dica:** Cada aula tem seções expansíveis (clique para abrir/fechar) para facilitar a navegação!
