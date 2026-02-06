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
-- Sintaxe padrão SQL
CAST(expressão AS tipo_destino)

-- Sintaxe PostgreSQL (atalho)
expressão::tipo_destino
```

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

```sql
-- Converter número para texto
SELECT CAST(123 AS VARCHAR);
-- Resultado: '123'

-- Sintaxe alternativa PostgreSQL
SELECT 123::VARCHAR;
-- Resultado: '123'

-- Converter texto para número
SELECT CAST('456' AS INTEGER);
-- Resultado: 456

-- Converter preço para inteiro (remove centavos)
SELECT
    nome,
    preco,
    CAST(preco AS INTEGER) AS preco_inteiro
FROM produtos;
-- 199.90 → 199

-- Arredondar antes de converter
SELECT
    nome,
    preco,
    CAST(ROUND(preco) AS INTEGER) AS preco_arredondado
FROM produtos;
-- 199.90 → 200
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
```

## Casos de Uso Comuns

```sql
-- Concatenar número com texto
SELECT 'Pedido #' || CAST(pedido_id AS VARCHAR) AS descricao
FROM pedidos;

-- Comparar texto numérico com número
SELECT * FROM produtos
WHERE CAST(codigo AS INTEGER) > 100;

-- Formatar valores monetários
SELECT
    nome,
    'R$ ' || CAST(preco AS VARCHAR) AS preco_formatado
FROM produtos;
```

## Cuidados com CAST

```sql
-- Erro: texto inválido para número
SELECT CAST('abc' AS INTEGER);
-- ERRO: invalid input syntax for integer

-- Perda de dados ao converter para inteiro
SELECT CAST(9.99 AS INTEGER);
-- Resultado: 9 (centavos perdidos!)
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
-- Aula 30 - Desafio 2: Substituir comentários nulos por "Sem comentarios"
-- Exiba o ID da avaliação, o ID do cliente e o comentário tratado


-- Aula 30 - Desafio 4: Simular correção de pedido com erro de sistema
-- Exiba o pedido 7 com status "cancelado" e data de entrega realizada ajustada para NULL

```

</details>

</details>

---

## Resumo Rápido

| Função | O que faz | Exemplo |
|--------|-----------|---------|
| `CAST(x AS tipo)` | Converte tipo de dado | `CAST(123 AS VARCHAR)` |
| `x::tipo` | Atalho PostgreSQL para CAST | `123::VARCHAR` |
| `COALESCE(a, b, c)` | Primeiro valor não nulo | `COALESCE(telefone, 'N/A')` |
| `NULLIF(a, b)` | NULL se a = b | `NULLIF(quantidade, 0)` |

---

## Conversões Comuns

```sql
-- Número → Texto
CAST(preco AS VARCHAR)
preco::VARCHAR

-- Texto → Número
CAST('123' AS INTEGER)
'123'::INTEGER

-- Data → Texto
CAST(data AS VARCHAR)
TO_CHAR(data, 'DD/MM/YYYY')

-- Texto → Data
CAST('2024-01-15' AS DATE)
'2024-01-15'::DATE

-- Decimal → Inteiro
CAST(preco AS INTEGER)
ROUND(preco)::INTEGER
```

---

## Checklist de Domínio

- [ ] Sei converter números para texto com CAST
- [ ] Sei converter texto para números
- [ ] Entendo a sintaxe alternativa `::tipo` do PostgreSQL
- [ ] Uso COALESCE para tratar valores NULL
- [ ] Sei usar NULLIF para evitar divisão por zero
- [ ] Consigo combinar COALESCE com NULLIF para tratar vazios e nulos

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
