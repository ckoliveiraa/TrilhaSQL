# Módulo 6- Conversão de Dados - Material Didático

## Objetivo do Módulo
Dominar a conversão de tipos de dados em SQL e o tratamento de valores nulos, habilidades essenciais para manipular e formatar dados corretamente.

---
# AULA 29

<details>
<summary><strong>Expandir Aula 29</strong></summary>

## CAST - Convertendo Tipos de Dados

## O que é?

A função `CAST` permite **converter um valor de um tipo de dado para outro**. Isso é essencial quando você precisa comparar ou operar com dados de tipos diferentes.

## Sintaxe

```sql
-- Sintaxe padrão (recomendada - funciona em todos os bancos de dados)
CAST(expressão AS tipo_destino)

-- Exemplo prático com alias de coluna
CAST(coluna AS TIPO) AS nova_coluna
```

### Sintaxe Alternativa do PostgreSQL

O PostgreSQL também oferece uma sintaxe mais curta usando o operador `::`:

```sql
-- Sintaxe específica do PostgreSQL (atalho)
expressão::tipo_destino
```

**Ambas produzem o mesmo resultado**, mas neste curso usaremos `CAST` por ser o padrão SQL universal.

## Tipos de Dados Comuns

| Tipo | Descrição | Exemplo |
|------|-----------|---------|
| `INTEGER` | Número inteiro | 42 |
| `NUMERIC(p,s)` | Decimal com precisão | 123.45 |
| `VARCHAR(n)` | Texto variável | 'Olá' |
| `TEXT` | Texto sem limite | 'Texto longo...' |
| `DATE` | Data | '2024-01-15' |
| `BOOLEAN` | Verdadeiro/Falso | TRUE, FALSE |

## Tipos Numéricos Detalhados

| Nome | Tamanho de armazenamento | Descrição | Intervalo dos valores |
|------|-------------------------|-----------|----------------------|
| `smallint` | 2 bytes | inteiro com intervalo de valores pequeno | -32768 a +32767 |
| `integer` | 4 bytes | escolha usual para inteiro | -2147483648 a +2147483647 |
| `bigint` | 8 bytes | inteiro com intervalo de valores grande | -9223372036854775808 a +9223372036854775807 |
| `decimal` | variável | precisão especificada pelo usuário, exato | até 131072 dígitos antes do ponto decimal; até 16383 dígitos após o ponto decimal |
| `numeric` | variável | precisão especificada pelo usuário, exato | até 131072 dígitos antes do ponto decimal; até 16383 dígitos após o ponto decimal |
| `real` | 4 bytes | precisão variável, inexato | precisão de 6 dígitos decimais |
| `double precision` | 8 bytes | precisão variável, inexato | precisão de 15 dígitos decimais |
| `smallserial` | 2 bytes | inteiro pequeno com autoincremento | 1 a 32767 |
| `serial` | 4 bytes | inteiro com autoincremento | 1 a 2147483647 |
| `bigserial` | 8 bytes | inteiro grande com autoincremento | 1 a 9223372036854775807 |

## Exemplos Práticos

### Conversões Numéricas

```sql
-- Número para texto
SELECT CAST(123 AS VARCHAR);
-- Resultado: '123'

-- Texto para número inteiro
SELECT CAST('456' AS INTEGER);
-- Resultado: 456

-- Decimal para inteiro (trunca os decimais)
SELECT CAST(99.99 AS INTEGER);
-- Resultado: 99

-- Inteiro para decimal
SELECT CAST(10 AS NUMERIC(10,2));
-- Resultado: 10.00

-- Conversão em consultas reais
SELECT
    nome,
    preco,
    CAST(preco AS INTEGER) AS preco_inteiro,           -- Remove centavos
    CAST(ROUND(preco) AS INTEGER) AS preco_arredondado -- Arredonda antes
FROM produtos;
-- Exemplo: 199.90 → preco_inteiro: 199 | preco_arredondado: 200
```

### Conversões de Texto

```sql
-- Número para texto em consultas
SELECT
    CONCAT('Produto #', CAST(produto_id AS VARCHAR)) AS codigo,
    CONCAT('R$ ', CAST(preco AS VARCHAR)) AS preco_formatado
FROM produtos;
-- Resultado: 'Produto #15' | 'R$ 199.90'

-- Conversão de tipos de texto
SELECT CAST('Olá Mundo' AS TEXT);       -- VARCHAR para TEXT
SELECT CAST('POSTGRESQL' AS CHAR(5));   -- Resultado: 'POSTG' (trunca)
```

## Convertendo Datas

```sql
-- Data para texto
SELECT CAST(CURRENT_DATE AS VARCHAR);
-- Resultado: '2024-01-15'

-- Texto para data
SELECT CAST('2024-12-25' AS DATE);
-- Resultado: 2024-12-25

-- Timestamp para data (remove a hora)
SELECT CAST(CURRENT_TIMESTAMP AS DATE);
-- Resultado: 2024-01-15

-- Data para timestamp (adiciona hora 00:00:00)
SELECT CAST('2024-01-15' AS TIMESTAMP);
-- Resultado: 2024-01-15 00:00:00

-- Exemplos em consultas reais
SELECT
    pedido_id,
    data_pedido,
    CAST(data_pedido AS VARCHAR) AS data_texto,
    CAST(EXTRACT(YEAR FROM data_pedido) AS INTEGER) AS ano
FROM pedidos;
```

## Casos de Uso Comuns

```sql
-- Concatenar número com texto
SELECT 'Pedido #' || CAST(pedido_id AS VARCHAR) AS descricao
FROM pedidos;
-- Resultado: 'Pedido #1001'

-- Comparar texto numérico com número
SELECT * FROM produtos
WHERE CAST(codigo AS INTEGER) > 100;

-- Formatar valores monetários
SELECT
    nome,
    'R$ ' || CAST(preco AS VARCHAR) AS preco_formatado,
    'R$ ' || CAST(preco * 0.9 AS NUMERIC(10,2)) AS preco_com_desconto
FROM produtos;
-- Resultado: 'R$ 199.90' | 'R$ 179.91'

-- Calcular com conversão de tipos
SELECT
    CAST(cliente_id AS VARCHAR) || '-' || CAST(pedido_id AS VARCHAR) AS codigo_rastreio,
    CAST(valor_total AS INTEGER) AS valor_aproximado
FROM pedidos;
-- Resultado: '5-1001' | 450
```

## ⚠️ Cuidados com CAST

```sql
-- ❌ ERRO: texto inválido para número
SELECT CAST('abc' AS INTEGER);
-- ERRO: invalid input syntax for type integer: "abc"

-- ❌ ERRO: formato de data inválido
SELECT CAST('15/01/2024' AS DATE);
-- ERRO: date/time field value out of range
-- ✅ Correto: CAST('2024-01-15' AS DATE) -- formato: YYYY-MM-DD

-- ⚠️ PERDA DE DADOS ao converter para inteiro
SELECT CAST(9.99 AS INTEGER);
-- Resultado: 9 (os centavos são perdidos!)

-- ✅ Melhor: arredondar antes de converter
SELECT CAST(ROUND(9.99) AS INTEGER);
-- Resultado: 10

-- ⚠️ CUIDADO com conversões em cálculos
SELECT
    preco,
    quantidade,
    CAST(preco AS INTEGER) * quantidade AS total_errado,        -- Perde precisão!
    CAST(preco * quantidade AS NUMERIC(10,2)) AS total_certo    -- Mantém precisão
FROM itens_pedido;
-- Exemplo: preco=19.99, qtd=3
-- total_errado: 57 (19 * 3)
-- total_certo: 59.97 (19.99 * 3)
```

## 💡 CAST vs :: - Qual usar?

| Aspecto | `CAST(x AS tipo)` | `x::tipo` |
|---------|------------------|-----------|
| **Compatibilidade** | ✅ Funciona em todos os SGBDs (MySQL, Oracle, SQL Server, PostgreSQL) | ❌ Apenas PostgreSQL |
| **Legibilidade** | ✅ Mais explícito e claro | Mais conciso |
| **Portabilidade** | ✅ Código funciona em qualquer banco | Código "preso" ao PostgreSQL |
| **Performance** | Idêntica | Idêntica |
| **Padrão SQL** | ✅ Sim (SQL ANSI) | Não (extensão PostgreSQL) |

**Recomendação:** Use `CAST` como padrão! É mais portável e legível.

```sql
-- ✅ RECOMENDADO: Use CAST (padrão SQL)
SELECT CAST('123' AS INTEGER), CAST(preco AS NUMERIC(10,2));

-- ✅ ALTERNATIVA (PostgreSQL): Sintaxe :: também funciona
SELECT '123'::INTEGER, preco::NUMERIC(10,2);

-- ❌ EVITE: Misturar os dois estilos no mesmo código
SELECT CAST('123' AS INTEGER), preco::NUMERIC(10,2);  -- Inconsistente
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 29 - Desafio 1: Converter preço para inteiro (sem centavos)
-- Exiba nome, preco original e preco convertido para inteiro


-- Aula 29 - Desafio 2: Converter data_pedido para texto
-- Exiba pedido_id e data_pedido como texto

```

</details>

</details>

---

# AULA 30

<details>
<summary><strong>Expandir Aula 30</strong></summary>

## COALESCE - Tratando Valores Nulos

## O que é?

A função `COALESCE` retorna o **primeiro valor não nulo** de uma lista de expressões. É extremamente útil para tratar valores NULL e fornecer valores padrão.

## Sintaxe

```sql
COALESCE(valor1, valor2, valor3, ...)
```

Retorna o primeiro valor que **não é NULL**.

## Como Funciona?

```sql
COALESCE(NULL, NULL, 'terceiro', 'quarto')
-- Resultado: 'terceiro'

COALESCE('primeiro', 'segundo', 'terceiro')
-- Resultado: 'primeiro'

COALESCE(NULL, NULL, NULL)
-- Resultado: NULL (todos são nulos)
```

## Exemplos Práticos

```sql
-- Substituir telefone nulo por mensagem padrão
SELECT
    nome,
    COALESCE(telefone, 'Não informado') AS telefone
FROM clientes;

-- Substituir desconto nulo por zero
SELECT
    nome,
    preco,
    COALESCE(desconto, 0) AS desconto
FROM produtos;

-- Calcular preço final com desconto (tratando NULL)
SELECT
    nome,
    preco,
    preco - COALESCE(desconto, 0) AS preco_final
FROM produtos;
```

## Múltiplos Valores de Fallback

```sql
-- Tentar telefone, depois celular, depois mensagem
SELECT
    nome,
    COALESCE(telefone, celular, 'Sem contato') AS contato
FROM clientes;

-- Usar email corporativo, pessoal ou padrão
SELECT
    nome,
    COALESCE(email_corporativo, email_pessoal, 'sem_email@empresa.com') AS email
FROM funcionarios;
```
## NULLIF - O Inverso

`NULLIF(a, b)` retorna NULL se `a = b`, senão retorna `a`.

```sql
-- Evitar divisão por zero
SELECT
    total_vendas / NULLIF(quantidade, 0) AS media
FROM resumo;
-- Se quantidade = 0, retorna NULL ao invés de erro

-- Converter string vazia para NULL
SELECT
    NULLIF(telefone, '') AS telefone
FROM clientes;
-- '' (vazio) vira NULL
```

## Combinando COALESCE e NULLIF

```sql
-- Tratar tanto NULL quanto string vazia
SELECT
    nome,
    COALESCE(NULLIF(telefone, ''), 'Não informado') AS telefone
FROM clientes;
-- NULL → 'Não informado'
-- '' → 'Não informado'
-- '11999...' → '11999...'
```

## Casos de Uso Reais

```sql
-- Calcular valor total com frete (frete pode ser NULL)
SELECT
    pedido_id,
    valor_total,
    COALESCE(frete, 0) AS frete,
    valor_total + COALESCE(frete, 0) AS valor_final
FROM pedidos;

-- Exibir endereço completo (campos opcionais)
SELECT
    nome,
    CONCAT(
        endereco,
        COALESCE(', ' || complemento, ''),
        ' - ',
        cidade
    ) AS endereco_completo
FROM clientes;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 30 - Desafio 1: Substituir comentários nulos por "Sem comentarios"
-- Exiba o ID da avaliação, o ID do cliente e o comentário tratado


-- Aula 30 - Desafio 2: Simular correção de pedido com erro de sistema
-- Exiba o pedido 7 com status "cancelado" e data de entrega realizada ajustada para NULL

```

</details>

</details>

---

## Resumo Rápido

| Função | O que faz | Exemplo |
|--------|-----------|---------|
| `CAST(x AS tipo)` | Converte tipo de dado (padrão SQL) | `CAST(123 AS VARCHAR)` |
| `x::tipo` | Sintaxe alternativa do PostgreSQL | `123::VARCHAR` |
| `COALESCE(a, b, c)` | Primeiro valor não nulo | `COALESCE(telefone, 'N/A')` |
| `NULLIF(a, b)` | NULL se a = b | `NULLIF(quantidade, 0)` |

---

## Conversões Comuns (Guia Rápido)

```sql
-- 📊 Número → Texto
CAST(preco AS VARCHAR)
-- Exemplo: 199.90 → '199.90'

-- 🔢 Texto → Número
CAST('123' AS INTEGER)
-- Exemplo: '123' → 123

-- 📝 Texto → Decimal
CAST('99.99' AS NUMERIC(10,2))
-- Exemplo: '99.99' → 99.99

-- 📅 Data → Texto
CAST(data AS VARCHAR)                   -- Formato padrão: 2024-01-15
TO_CHAR(data, 'DD/MM/YYYY')            -- Formato personalizado: 15/01/2024
-- Exemplo: 2024-01-15 → '2024-01-15'

-- 📆 Texto → Data
CAST('2024-01-15' AS DATE)
-- Exemplo: '2024-01-15' → 2024-01-15
-- ⚠️ IMPORTANTE: Use formato YYYY-MM-DD (ISO 8601)

-- 🔄 Decimal → Inteiro
CAST(preco AS INTEGER)                  -- Trunca (9.99 → 9)
CAST(ROUND(preco) AS INTEGER)           -- Arredonda (9.99 → 10)
-- ⚠️ CUIDADO: Perda de precisão ao truncar!

-- ⏰ Timestamp → Data (remove hora)
CAST(CURRENT_TIMESTAMP AS DATE)
-- Exemplo: 2024-01-15 14:30:00 → 2024-01-15

-- 📦 Conversões com cálculos
CAST(preco * quantidade AS NUMERIC(10,2))      -- Converte resultado
CAST(pedido_id AS VARCHAR) || '-2024'          -- Concatena após converter
-- Exemplo: 1001 → '1001-2024'
```

---

## Checklist de Domínio

- [ ] Sei usar CAST para converter números para texto
- [ ] Sei usar CAST para converter texto para números
- [ ] Conheço a sintaxe alternativa `::` do PostgreSQL
- [ ] Entendo que CAST é o padrão SQL recomendado
- [ ] Sei converter datas e timestamps com CAST
- [ ] Evito perda de precisão ao converter decimais para inteiros
- [ ] Uso COALESCE para tratar valores NULL
- [ ] Sei usar NULLIF para evitar divisão por zero
- [ ] Consigo combinar COALESCE com NULLIF para tratar vazios e nulos
- [ ] Faço conversões dentro de cálculos corretamente

---

## Próximos Passos

No próximo módulo, você aprenderá sobre:
- CASE WHEN - Expressões condicionais

---

## Desafio Final do Módulo 5

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

Use seus conhecimentos de conversão e tratamento de nulos para resolver estes desafios.

### Desafios

```sql
-- Desafio Final 1: Ficha de Clientes Completa
-- Crie um relatório com:
-- - cliente_id convertido para texto com prefixo "CLI-"
-- - nome
-- - telefone (ou "Não informado" se nulo)
-- - email (ou "Não informado" se nulo)


-- Desafio Final 2: Relatório de Produtos com Preços
-- Mostre:
-- - nome do produto
-- - preco original
-- - preco como inteiro (sem centavos)
-- - "R$ " concatenado com o preço (como texto)


-- Desafio Final 3: Pedidos com Valor Final
-- Calcule o valor final dos pedidos considerando:
-- - valor_total
-- - frete (pode ser NULL, tratar como 0)
-- - desconto (pode ser NULL, tratar como 0)
-- - valor_final = valor_total + frete - desconto
```

</details>
