# Módulo 3 - Filtros Avançados - Material Didático

## Objetivo do Módulo
Aprofundar nas técnicas de filtragem de dados, utilizando operadores avançados como NOT, IN, BETWEEN e LIKE para criar consultas mais precisas e poderosas.

---
# AULA 12

<details>
<summary><strong>Expandir Aula 12</strong></summary>

## NOT - Negando Condições

## O que é?

O operador `NOT` é usado para **inverter** o resultado de uma condição. Se uma condição é verdadeira, `NOT` a torna falsa, e vice-versa.

## Sintaxe

```sql
SELECT colunas FROM tabela WHERE NOT condição;
```

## Como funciona?

```sql
-- SEM NOT: Pedidos cancelados
SELECT * FROM pedidos WHERE status = 'cancelado';

-- COM NOT: Pedidos que NÃO foram cancelados
SELECT * FROM pedidos WHERE NOT status = 'cancelado';

-- Equivalente a:
SELECT * FROM pedidos WHERE status <> 'cancelado';
```

## Lógica do NOT

```
Condição: Verdadeira  → NOT: Falsa
Condição: Falsa       → NOT: Verdadeira
```

## Quando usar?

- Quando você quer **excluir** um cenário específico
- Quando a lógica "negativa" é mais clara que a "positiva"
- Combinado com outros operadores (NOT IN, NOT LIKE, NOT BETWEEN)

## NOT com diferentes operadores

```sql
-- NOT com igualdade
WHERE NOT status = 'cancelado'

-- NOT com IN (veremos em breve)
WHERE status NOT IN ('cancelado', 'devolvido')

-- NOT com LIKE (veremos em breve)
WHERE nome NOT LIKE '%teste%'

-- NOT com BETWEEN (veremos em breve)
WHERE preco NOT BETWEEN 100 AND 500

-- NOT com NULL
WHERE telefone IS NOT NULL
```

## Cuidado com a legibilidade

```sql
-- Às vezes <> é mais claro que NOT
WHERE NOT status = 'ativo'    -- Funciona, mas...
WHERE status <> 'ativo'       -- ...isso é mais direto

-- NOT brilha em casos complexos
WHERE NOT (status = 'cancelado' AND valor < 100)
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 12 - Desafio 1: Mostrar todos os pedidos que NÃO foram cancelados


-- Aula 12 - Desafio 2: Mostrar todos os pagamentos que NÃO foram feitos via 'boleto'

```

</details>

</details>

---

# AULA 13

<details>
<summary><strong>Expandir Aula 13</strong></summary>

## IN - Filtrando por Lista de Valores

## O que é?

O operador `IN` permite filtrar resultados com base em uma **lista de valores**. É uma forma mais limpa e eficiente de escrever múltiplos `OR`.

## Sintaxe

```sql
SELECT colunas FROM tabela WHERE coluna IN (valor1, valor2, valor3);
```

## IN vs Múltiplos OR

```sql
-- Com OR (verboso e repetitivo)
SELECT * FROM pedidos
WHERE status = 'entregue'
   OR status = 'enviado'
   OR status = 'em_transito';

-- Com IN (limpo e elegante)
SELECT * FROM pedidos
WHERE status IN ('entregue', 'enviado', 'em_transito');
```

**Resultado:** Ambos retornam o mesmo resultado, mas IN é mais legível!

## Exemplos Práticos

```sql
-- Produtos de marcas específicas
SELECT * FROM produtos
WHERE marca IN ('Samsung', 'Apple', 'Sony');

-- Clientes de estados específicos
SELECT * FROM clientes
WHERE estado IN ('SP', 'RJ', 'MG');

-- Pedidos de clientes específicos
SELECT * FROM pedidos
WHERE cliente_id IN (1, 5, 10, 15);

-- Pagamentos por métodos específicos
SELECT * FROM pagamentos
WHERE metodo IN ('pix', 'cartao_credito');
```

## IN com números

```sql
-- Funciona com IDs
SELECT * FROM produtos WHERE id IN (1, 2, 3, 4, 5);

-- Funciona com qualquer número
SELECT * FROM avaliacoes WHERE nota IN (4, 5);
```

## Vantagens do IN

- Código mais limpo e legível
- Fácil de adicionar/remover valores
- Melhor performance em alguns bancos de dados
- Menos chance de erro de digitação

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 13 - Desafio 1: Mostrar pedidos com status 'entregue' ou 'enviado'


-- Aula 13 - Desafio 2: Mostrar pagamentos feitos com 'pix' ou 'cartao_credito'

```

</details>

</details>

---

# AULA 14

<details>
<summary><strong>Expandir Aula 14</strong></summary>

## NOT IN - Excluindo Lista de Valores

## O que é?

O operador `NOT IN` é o **oposto do IN**. Ele exclui todos os valores presentes na lista, retornando apenas os que NÃO correspondem.

## Sintaxe

```sql
SELECT colunas FROM tabela WHERE coluna NOT IN (valor1, valor2, valor3);
```

## Como funciona?

```sql
-- IN: Inclui apenas esses status
SELECT * FROM pedidos WHERE status IN ('cancelado', 'devolvido');
-- Resultado: Apenas pedidos cancelados ou devolvidos

-- NOT IN: Exclui esses status
SELECT * FROM pedidos WHERE status NOT IN ('cancelado', 'devolvido');
-- Resultado: Todos os pedidos EXCETO cancelados e devolvidos
```

## Exemplos Práticos

```sql
-- Produtos que NÃO são dessas marcas
SELECT * FROM produtos
WHERE marca NOT IN ('Genérica', 'Sem Marca', 'Outros');

-- Clientes fora da região sudeste
SELECT * FROM clientes
WHERE estado NOT IN ('SP', 'RJ', 'MG', 'ES');

-- Avaliações que não são extremas (nem muito boas, nem muito ruins)
SELECT * FROM avaliacoes
WHERE nota NOT IN (1, 5);

-- Pagamentos que não estão pendentes ou recusados
SELECT * FROM pagamentos
WHERE status NOT IN ('pendente', 'recusado');
```

## Cuidado com NULL!

```sql
-- NOT IN com NULL pode dar resultados inesperados!
-- Se a lista contiver NULL, o resultado pode ser vazio

-- Evite isso:
WHERE coluna NOT IN ('valor1', NULL)  -- Pode não funcionar como esperado

-- Prefira:
WHERE coluna NOT IN ('valor1', 'valor2') AND coluna IS NOT NULL
```

## Quando usar NOT IN?

- Excluir valores indesejados de uma lista conhecida
- Filtrar dados "problemáticos" ou de teste
- Criar relatórios excluindo categorias específicas

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 14 - Desafio 1: Mostrar avaliações que NÃO tenham nota 1 ou 5


-- Aula 14 - Desafio 2: Mostrar pedidos com status que NÃO sejam "pendente" ou "confirmado"

```

</details>

</details>

---

# AULA 15

<details>
<summary><strong>Expandir Aula 15</strong></summary>

## BETWEEN - Filtrando por Intervalo

## O que é?

O operador `BETWEEN` é usado para selecionar valores dentro de um **intervalo**. É **inclusivo**, o que significa que os valores de início e fim estão incluídos no resultado.

## Sintaxe

```sql
SELECT colunas FROM tabela WHERE coluna BETWEEN valor_inicial AND valor_final;
```

## BETWEEN vs >= e <=

```sql
-- Com >= e <= (verboso)
SELECT * FROM produtos
WHERE preco >= 100 AND preco <= 500;

-- Com BETWEEN (elegante)
SELECT * FROM produtos
WHERE preco BETWEEN 100 AND 500;
```

**Importante:** Ambos incluem 100 e 500 no resultado!

## BETWEEN com números

```sql
-- Produtos com preço entre R$ 500 e R$ 1500
SELECT * FROM produtos
WHERE preco BETWEEN 500 AND 1500;

-- Produtos com estoque entre 10 e 100 unidades
SELECT * FROM produtos
WHERE estoque BETWEEN 10 AND 100;

-- Avaliações com nota entre 3 e 5
SELECT * FROM avaliacoes
WHERE nota BETWEEN 3 AND 5;
```

## BETWEEN com datas

```sql
-- Pedidos de janeiro de 2024
SELECT * FROM pedidos
WHERE data_pedido BETWEEN '2024-01-01' AND '2024-01-31';

-- Pedidos do primeiro semestre de 2024
SELECT * FROM pedidos
WHERE data_pedido BETWEEN '2024-01-01' AND '2024-06-30';

-- Pagamentos do ano de 2025
SELECT * FROM pagamentos
WHERE data_pagamento BETWEEN '2025-01-01' AND '2025-12-31';
```

## NOT BETWEEN

```sql
-- Produtos FORA da faixa de preço
SELECT * FROM produtos
WHERE preco NOT BETWEEN 100 AND 500;
-- Retorna: preços < 100 OU preços > 500
```

## Ordem importa!

```sql
-- CORRETO: menor valor primeiro
WHERE preco BETWEEN 100 AND 500

-- ERRADO: não retorna resultados!
WHERE preco BETWEEN 500 AND 100
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 15 - Desafio 1: Mostrar pedidos com valor total entre R$ 500 e R$ 1500


-- Aula 15 - Desafio 2: Mostrar pagamentos realizados no ano de 2025

```

</details>

</details>

---

# AULA 16

<details>
<summary><strong>Expandir Aula 16</strong></summary>

## LIKE - Buscando Padrões de Texto

## O que é?

O operador `LIKE` é usado para pesquisar um **padrão** em uma coluna de texto. É essencial para buscas flexíveis onde você não sabe o valor exato.

## Sintaxe

```sql
SELECT colunas FROM tabela WHERE coluna LIKE 'padrão';
```

## Caracteres Curinga (Wildcards)

| Caractere | Significado | Exemplo |
|-----------|-------------|---------|
| `%` | Zero ou mais caracteres | `'%ana%'` encontra "Banana", "Ana", "Cabana" |
| `_` | Exatamente um caractere | `'_asa'` encontra "Casa", "Masa", "Rasa" |

## Padrões com %

```sql
-- Começa com "Smart"
SELECT * FROM produtos WHERE nome LIKE 'Smart%';
-- Encontra: Smartphone, Smart TV, Smartwatch

-- Termina com "Pro"
SELECT * FROM produtos WHERE nome LIKE '%Pro';
-- Encontra: iPhone Pro, MacBook Pro, AirPods Pro

-- Contém "Samsung"
SELECT * FROM produtos WHERE nome LIKE '%Samsung%';
-- Encontra: TV Samsung 50", Samsung Galaxy, Geladeira Samsung
```

## Exemplos Práticos

```sql
-- Clientes com email do Gmail
SELECT * FROM clientes WHERE email LIKE '%@gmail.com';

-- Produtos que contêm "wireless"
SELECT * FROM produtos WHERE nome LIKE '%wireless%';

-- Clientes cujo nome começa com "Maria"
SELECT * FROM clientes WHERE nome LIKE 'Maria%';

-- Comentários que mencionam "entrega"
SELECT * FROM avaliacoes WHERE comentario LIKE '%entrega%';
```

## Case Sensitivity

```sql
-- Em alguns bancos (PostgreSQL), LIKE é case-sensitive
WHERE nome LIKE '%samsung%'  -- NÃO encontra "Samsung"
WHERE nome LIKE '%Samsung%'  -- Encontra "Samsung"

-- Use ILIKE (PostgreSQL) ou LOWER() para ignorar maiúsculas/minúsculas
WHERE LOWER(nome) LIKE '%samsung%'
```

## NOT LIKE

```sql
-- Produtos que NÃO contêm "teste"
SELECT * FROM produtos WHERE nome NOT LIKE '%teste%';

-- Emails que NÃO são do Gmail
SELECT * FROM clientes WHERE email NOT LIKE '%@gmail.com';
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 16 - Desafio 1: Mostrar categorias cuja descrição contenha a palavra 'acessórios'


-- Aula 16 - Desafio 2: Mostrar avaliações cujo comentário contenha a palavra "rápida"

```

</details>

</details>

---

# AULA 17

<details>
<summary><strong>Expandir Aula 17</strong></summary>

## LIKE com % e _ - Padrões Avançados

## O que é?

Combinando os wildcards `%` e `_`, você pode criar padrões de busca muito específicos e poderosos.

## O caractere % (porcentagem)

Representa **zero, um ou múltiplos caracteres** em qualquer posição.

| Padrão | Descrição | Exemplos que correspondem |
|--------|-----------|---------------------------|
| `'Ana%'` | Começa com "Ana" | Ana, Anabel, Anastacia |
| `'%silva'` | Termina com "silva" | Silva, Da Silva, José silva |
| `'%art%'` | Contém "art" em qualquer lugar | Artigo, Cartão,Epartida |
| `'%'` | Qualquer texto (inclusive vazio) | Tudo |

## O caractere _ (underline)

Representa **exatamente um único caractere** na posição especificada.

| Padrão | Descrição | Exemplos que correspondem |
|--------|-----------|---------------------------|
| `'_asa'` | 4 letras, terminando em "asa" | Casa, Masa, Rasa |
| `'A__a'` | 4 letras, A no início, a no fim | Ana, Aula, Área |
| `'___'` | Exatamente 3 caracteres | São, Rio, Abc |
| `'S_o Paulo'` | S + 1 char + o Paulo | São Paulo |

## Combinando % e _

```sql
-- CEPs que começam com 01 e têm formato específico
SELECT * FROM enderecos WHERE cep LIKE '01___-___';

-- Códigos de produto com padrão específico
SELECT * FROM produtos WHERE codigo LIKE 'PRD-____-%';
-- Encontra: PRD-0001-A, PRD-1234-B, etc.
```

## Exemplos Práticos

```sql
-- Nomes com exatamente 4 letras
SELECT * FROM clientes WHERE nome LIKE '____';

-- Telefones que começam com DDD 11
SELECT * FROM clientes WHERE telefone LIKE '11%';

-- Emails com domínio de 3 letras (.com, .net, .org)
SELECT * FROM clientes WHERE email LIKE '%.___.%';

-- Placas de carro no formato antigo (ABC-1234)
SELECT * FROM veiculos WHERE placa LIKE '___-____';
```

## Escapando caracteres especiais

```sql
-- Se precisar buscar o próprio % ou _
-- Use ESCAPE para definir um caractere de escape

-- Buscar textos que contêm "50%"
SELECT * FROM produtos WHERE descricao LIKE '%50\%%' ESCAPE '\';
```

## Dicas de Performance

```sql
-- BOM: Padrão no final (usa índice)
WHERE nome LIKE 'João%'

-- RUIM: Padrão no início (não usa índice, mais lento)
WHERE nome LIKE '%Silva'

-- Se precisar buscar no meio, considere Full-Text Search para tabelas grandes
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 17 - Desafio 1: Mostrar todos os métodos de pagamento que comecem com 'cartao'


-- Aula 17 - Desafio 2: Mostrar os status de pedido que terminem com a letra 'o'

```

</details>

</details>

---

## Resumo Rápido

| Operador | O que faz | Exemplo |
|----------|-----------|---------|
| `NOT` | Inverte uma condição | `WHERE NOT status = 'cancelado'` |
| `IN` | Filtra por lista de valores | `WHERE marca IN ('Samsung', 'Apple')` |
| `NOT IN` | Exclui lista de valores | `WHERE status NOT IN ('cancelado', 'devolvido')` |
| `BETWEEN` | Filtra por intervalo (inclusivo) | `WHERE preco BETWEEN 100 AND 500` |
| `NOT BETWEEN` | Exclui intervalo | `WHERE preco NOT BETWEEN 100 AND 500` |
| `LIKE` | Busca padrão de texto | `WHERE nome LIKE '%Samsung%'` |
| `NOT LIKE` | Exclui padrão de texto | `WHERE nome NOT LIKE '%teste%'` |
| `%` | Zero ou mais caracteres | `'%texto%'` |
| `_` | Exatamente um caractere | `'A__a'` |

---

## Combinando Operadores

Você pode combinar todos esses operadores com AND e OR:

```sql
-- Produtos Samsung ou Apple, com preço entre 1000 e 5000,
-- que NÃO estejam em promoção
SELECT * FROM produtos
WHERE marca IN ('Samsung', 'Apple')
  AND preco BETWEEN 1000 AND 5000
  AND nome NOT LIKE '%promo%';
```

---

## Checklist de Domínio

- [ ] Sei usar NOT para inverter condições
- [ ] Uso IN para filtrar por lista de valores
- [ ] Entendo quando usar NOT IN
- [ ] Sei que NOT IN com NULL pode causar problemas
- [ ] Uso BETWEEN para intervalos numéricos
- [ ] Uso BETWEEN para intervalos de datas
- [ ] Entendo que BETWEEN é inclusivo
- [ ] Sei usar LIKE com % para buscas flexíveis
- [ ] Sei usar LIKE com _ para posições específicas
- [ ] Consigo combinar os operadores avançados

---

## Próximos Passos

1. **Pratique** todos os desafios de cada aula
2. **Experimente** combinar os operadores
3. **Crie** suas próprias queries de filtro
4. **Avance** para o próximo módulo (Funções de Agregação)!

---

## Desafio Final do Módulo 3

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

Parabéns por chegar até aqui! Agora é hora de testar tudo que você aprendeu sobre filtros avançados.

### Contexto

Você é analista de dados de um e-commerce e precisa criar consultas complexas para diferentes departamentos.

### Desafios

```sql
-- Desafio Final 1: Análise de Pedidos por Status
-- Mostre todos os pedidos que estão "em_separacao", "enviado" ou "em_transito"
-- Ordene por data do pedido (mais recente primeiro)


-- Desafio Final 2: Produtos Fora de Faixa
-- Encontre produtos com preço FORA do intervalo de R$ 200 a R$ 2000
-- Mostre nome, marca e preço, ordenados por preço


-- Desafio Final 3: Busca de Clientes
-- Encontre clientes cujo nome começa com "Maria" ou "Ana"
-- E que NÃO sejam de São Paulo (SP)
-- Mostre nome, cidade e estado


-- Desafio Final 4: Avaliações Medianas
-- Encontre avaliações com nota entre 2 e 4 (nem muito boas, nem muito ruins)
-- Que tenham algum comentário (comentario NOT LIKE '')
-- Mostre nota e comentário


-- Desafio Final 5: Pagamentos Específicos (Desafio Avançado)
-- Encontre pagamentos que:
-- - Sejam de cartão (crédito ou débito) - use LIKE 'cartao%'
-- - Com valor entre R$ 100 e R$ 1000
-- - Que NÃO tenham status "recusado"
-- Mostre método, valor e status, ordenados por valor (maior primeiro)


-- Desafio Final 6: Relatório Complexo (Boss Final!)
-- Crie uma consulta que mostre produtos onde:
-- - A marca seja "Samsung", "Apple", "Sony" ou "LG"
-- - O preço esteja entre R$ 500 e R$ 5000
-- - O nome contenha "Smart" ou "Pro" (use OR com dois LIKE)
-- - O estoque NÃO esteja entre 0 e 5 (evitar produtos quase esgotados)
-- Mostre nome, marca, preço e estoque
-- Ordene por marca (A-Z) e depois por preço (menor para maior)

```

### Dicas

- Use parênteses para agrupar condições OR
- Lembre-se que BETWEEN é inclusivo
- LIKE é case-sensitive em alguns bancos
- NOT IN, NOT BETWEEN e NOT LIKE são seus aliados para exclusões

</details>

---

## Como Usar Este Material

1. Estude uma aula por vez
2. Leia todos os conceitos com atenção
3. Pratique os desafios antes de avançar
4. Revise os conceitos quando necessário
5. Use o resumo para consultas rápidas

**Dica:** Cada aula tem seções expansíveis (clique para abrir/fechar) para facilitar a navegação!
