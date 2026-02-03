# Módulo 6 - Condicionais - Material Didático

## Objetivo do Módulo
Dominar o uso de expressões condicionais em SQL com CASE WHEN, permitindo criar lógica condicional diretamente nas consultas.

---

# AULA 31

<details>
<summary><strong>Expandir Aula 31</strong></summary>

## CASE WHEN - Condicionais Simples

## O que é?

O `CASE WHEN` é uma expressão condicional que permite criar lógica "se-então" diretamente no SQL. Funciona como um IF/ELSE em outras linguagens de programação.

## Sintaxe Básica

```sql
SELECT
    coluna,
    CASE
        WHEN condição1 THEN resultado1
        WHEN condição2 THEN resultado2
        ELSE resultado_padrao
    END AS nome_coluna
FROM tabela;
```

## Como Funciona?

```
CASE avalia as condições em ORDEM:
├── Se condição1 é verdadeira → retorna resultado1
├── Se condição2 é verdadeira → retorna resultado2
├── ...
└── Se nenhuma condição → retorna ELSE (ou NULL se não houver ELSE)
```

**Importante:** Assim que uma condição é verdadeira, as demais são IGNORADAS!

## Exemplos Práticos

**1. Classificar produtos por preço:**
```sql
SELECT
    nome,
    preco,
    CASE
        WHEN preco < 100 THEN 'Barato'
        WHEN preco <= 500 THEN 'Médio'
        ELSE 'Caro'
    END AS classificacao
FROM produtos;
```

**2. Status legível dos pedidos:**
```sql
SELECT
    pedido_id,
    data_pedido,
    status,
    CASE
        WHEN status = 'pendente' THEN 'Aguardando Processamento'
        WHEN status = 'processando' THEN 'Em Preparação'
        WHEN status = 'enviado' THEN 'A Caminho'
        WHEN status = 'entregue' THEN 'Entregue com Sucesso'
        WHEN status = 'cancelado' THEN 'Pedido Cancelado'
        ELSE 'Status Desconhecido'
    END AS status_descritivo
FROM pedidos;
```

**3. Calcular idade a partir da data de nascimento:**
```sql
SELECT
    nome,
    data_nascimento,
    EXTRACT(YEAR FROM AGE(data_nascimento)) AS idade,
    CASE
        WHEN EXTRACT(YEAR FROM AGE(data_nascimento)) < 18 THEN 'Menor de idade'
        WHEN EXTRACT(YEAR FROM AGE(data_nascimento)) < 30 THEN 'Jovem'
        WHEN EXTRACT(YEAR FROM AGE(data_nascimento)) < 50 THEN 'Adulto'
        ELSE 'Sênior'
    END AS faixa_etaria
FROM clientes;
```

**4. Indicador de estoque:**
```sql
SELECT
    nome,
    estoque,
    CASE
        WHEN estoque = 0 THEN 'Sem Estoque'
        WHEN estoque < 10 THEN 'Estoque Baixo'
        WHEN estoque < 50 THEN 'Estoque Normal'
        ELSE 'Estoque Alto'
    END AS situacao_estoque
FROM produtos;
```

**5. CASE com cálculos:**
```sql
SELECT
    nome,
    preco,
    CASE
        WHEN preco < 100 THEN preco * 0.95  -- 5% desconto
        WHEN preco < 500 THEN preco * 0.90  -- 10% desconto
        ELSE preco * 0.85                    -- 15% desconto
    END AS preco_promocional
FROM produtos;
```

## CASE Simples (Alternativa)

Quando você compara uma coluna com valores específicos, pode usar a forma simplificada:

```sql
-- Forma completa
CASE
    WHEN status = 'A' THEN 'Ativo'
    WHEN status = 'I' THEN 'Inativo'
END

-- Forma simplificada (equivalente)
CASE status
    WHEN 'A' THEN 'Ativo'
    WHEN 'I' THEN 'Inativo'
END
```

## CASE com ORDER BY

```sql
SELECT nome, status
FROM pedidos
ORDER BY
    CASE status
        WHEN 'pendente' THEN 1
        WHEN 'processando' THEN 2
        WHEN 'enviado' THEN 3
        WHEN 'entregue' THEN 4
        WHEN 'cancelado' THEN 5
    END;
```

## Desafios

<details>
<summary><strong>Ver Desafios</strong></summary>

1. Classificar produtos como "Barato" (< R$100), "Médio" (R$100-500) ou "Caro" (> R$500)
2. Classificar clientes por faixa etária: "Jovem" (< 30), "Adulto" (30-50), "Sênior" (> 50)

</details>

</details>

---

# AULA 32

<details>
<summary><strong>Expandir Aula 32</strong></summary>

## CASE WHEN com Múltiplas Condições

## O que é?

O CASE WHEN pode avaliar **múltiplas condições simultaneamente** usando operadores lógicos (AND, OR) e pode ser combinado com funções de agregação e outras cláusulas SQL.

## Sintaxe com Múltiplas Condições

```sql
CASE
    WHEN condição1 AND condição2 THEN resultado1
    WHEN condição1 OR condição3 THEN resultado2
    ELSE resultado_padrao
END
```

## Exemplos Práticos

**1. Urgência baseada em estoque E vendas:**
```sql
SELECT
    nome,
    estoque,
    CASE
        WHEN estoque < 10 THEN 'Crítico'
        WHEN estoque < 30 THEN 'Baixo'
        ELSE 'OK'
    END AS urgencia
FROM produtos;
```

**2. Classificação de pedidos por frete:**
```sql
SELECT
    pedido_id,
    valor_total,
    frete,
    CASE
        WHEN frete = 0 THEN 'Grátis'
        WHEN frete < 20 THEN 'Econômico'
        ELSE 'Normal'
    END AS tipo_frete
FROM pedidos;
```

**3. Múltiplas condições combinadas:**
```sql
SELECT
    p.nome,
    p.preco,
    p.estoque,
    CASE
        WHEN p.preco > 1000 AND p.estoque < 5 THEN 'Premium em Falta'
        WHEN p.preco > 1000 THEN 'Premium'
        WHEN p.estoque < 5 THEN 'Reposição Urgente'
        WHEN p.estoque < 20 THEN 'Estoque Baixo'
        ELSE 'Normal'
    END AS situacao
FROM produtos p;
```

**4. CASE em cálculos condicionais:**
```sql
-- Calcular preço com desconto baseado no valor
SELECT
    nome,
    preco,
    CASE
        WHEN preco >= 1000 THEN preco * 0.85  -- 15% desconto para caros
        WHEN preco >= 500 THEN preco * 0.90   -- 10% desconto para médios
        ELSE preco * 0.95                      -- 5% desconto para baratos
    END AS preco_com_desconto
FROM produtos;
```

**5. CASE para criar flags (indicadores):**
```sql
-- Indicar se produto precisa de reposição
SELECT
    nome,
    estoque,
    CASE
        WHEN estoque = 0 THEN 'SIM - URGENTE'
        WHEN estoque < 10 THEN 'SIM'
        ELSE 'NÃO'
    END AS precisa_repor
FROM produtos;
```

**6. CASE com datas:**
```sql
-- Classificar pedidos por antiguidade
SELECT
    pedido_id,
    data_pedido,
    CASE
        WHEN data_pedido >= CURRENT_DATE - INTERVAL '7 days' THEN 'Recente'
        WHEN data_pedido >= CURRENT_DATE - INTERVAL '30 days' THEN 'Este mês'
        WHEN data_pedido >= CURRENT_DATE - INTERVAL '90 days' THEN 'Último trimestre'
        ELSE 'Antigo'
    END AS classificacao_tempo
FROM pedidos;
```

**7. CASE para formatar saída:**
```sql
-- Formatar telefone ou mostrar mensagem
SELECT
    nome,
    CASE
        WHEN telefone IS NOT NULL THEN telefone
        ELSE 'Telefone não cadastrado'
    END AS contato
FROM clientes;
```

**8. CASE aninhado (CASE dentro de CASE):**
```sql
-- Classificação detalhada de produtos
SELECT
    nome,
    preco,
    estoque,
    CASE
        WHEN estoque = 0 THEN 'Indisponível'
        ELSE CASE
            WHEN preco > 1000 THEN 'Premium disponível'
            WHEN preco > 500 THEN 'Intermediário disponível'
            ELSE 'Econômico disponível'
        END
    END AS disponibilidade
FROM produtos;
```

> **Nota:** Exemplos mais avançados combinando CASE com funções de agregação (COUNT, SUM) e agrupamentos (GROUP BY) serão vistos nos **Módulos 7 e 8**. Exemplos com JOINs serão vistos no **Módulo 9**.

## COALESCE vs CASE

Para valores nulos simples, `COALESCE` é mais conciso:

```sql
-- Usando CASE
CASE WHEN telefone IS NULL THEN 'Não informado' ELSE telefone END

-- Usando COALESCE (mais simples)
COALESCE(telefone, 'Não informado')
```

## NULLIF - Complemento útil

`NULLIF(a, b)` retorna NULL se a = b, senão retorna a. Útil para evitar divisão por zero:

```sql
-- Evitar divisão por zero
SELECT
    total_vendas / NULLIF(total_clientes, 0) AS media_por_cliente
FROM resumo;
```

## Desafios

<details>
<summary><strong>Ver Desafios</strong></summary>

1. Criar coluna "Urgência" baseado em: estoque < 10 = "Crítico", < 30 = "Baixo", >= 30 = "OK"
2. Classificar pedidos por frete: 0 = "Grátis", < 20 = "Econômico", >= 20 = "Normal"

</details>

</details>

---

## Resumo Rápido

| Conceito | Descrição | Exemplo |
|----------|-----------|---------|
| **CASE WHEN** | Condicional básico | `CASE WHEN x > 10 THEN 'Alto' ELSE 'Baixo' END` |
| **CASE simples** | Comparação direta | `CASE status WHEN 'A' THEN 'Ativo' END` |
| **Múltiplas condições** | AND/OR no WHEN | `WHEN preco > 100 AND estoque < 5 THEN ...` |
| **CASE em ORDER BY** | Ordenação personalizada | `ORDER BY CASE status WHEN 'A' THEN 1 END` |
| **CASE com cálculos** | Valores condicionais | `CASE WHEN preco > 100 THEN preco * 0.9 END` |
| **COALESCE** | Tratar NULL | `COALESCE(valor, 0)` |
| **NULLIF** | Retornar NULL se igual | `NULLIF(divisor, 0)` |

### Ordem de Avaliação

```
CASE avalia condições de CIMA para BAIXO
├── Primeira condição verdadeira → retorna resultado
├── Para de avaliar as demais
└── Se nenhuma → retorna ELSE (ou NULL)

⚠️ A ORDEM das condições IMPORTA!
   WHEN preco > 100    -- Se isso vier primeiro...
   WHEN preco > 500    -- ...isso nunca será avaliado para preços > 500
```

---

## Checklist de Aprendizado

- [ ] Sei usar CASE WHEN com condições simples
- [ ] Entendo a diferença entre CASE completo e CASE simples
- [ ] Sei combinar múltiplas condições com AND/OR
- [ ] Sei criar colunas calculadas condicionalmente
- [ ] Consigo usar CASE com ORDER BY para ordenação personalizada
- [ ] Entendo quando usar COALESCE vs CASE para NULLs
- [ ] Sei usar NULLIF para evitar divisão por zero

---

## Próximos Passos

No próximo módulo, você aprenderá sobre:
- **Funções de Agregação**: COUNT, SUM, AVG, MIN, MAX
- Como contar, somar e calcular médias de dados
- Estatísticas básicas em SQL

---

## Desafio Final

<details>
<summary><strong>Ver Desafio Final</strong></summary>

Usando seus conhecimentos de CASE WHEN, resolva os seguintes problemas:

**Desafio 1:** Crie um relatório de produtos com as seguintes classificações:
- Preço: "Econômico" (< R$100), "Padrão" (R$100-500), "Premium" (> R$500)
- Estoque: "Crítico" (< 10), "Baixo" (10-29), "Normal" (30-99), "Alto" (>= 100)

**Desafio 2:** Crie uma coluna que mostre a "prioridade de reposição":
- "URGENTE" - estoque = 0 E preço > 500
- "ALTA" - estoque < 5
- "MÉDIA" - estoque < 20
- "BAIXA" - estoque >= 20

**Desafio 3:** Classifique os clientes em:
- "Novo" - cadastrado há menos de 6 meses
- "Regular" - cadastrado entre 6 meses e 2 anos
- "Veterano" - cadastrado há mais de 2 anos

**Desafio 4:** Crie um relatório de pedidos mostrando:
- Status traduzido para português
- Classificação do valor: "Pequeno" (< R$200), "Médio" (R$200-500), "Grande" (> R$500)
- Se teve frete grátis ou não

**Desafio 5 (Boss Final!):** Crie um relatório completo de pedidos que mostre:
- pedido_id
- valor_total
- status traduzido para português
- Classificação do valor: "Pequeno" (< R$200), "Médio" (R$200-1000), "Grande" (> R$1000)
- Tipo de frete: "Grátis" (frete = 0), "Econômico" (< R$30), "Normal" (>= R$30)
- Indicador de desconto: "Com desconto" (desconto > 0), "Sem desconto"
- Ordene por valor_total decrescente

</details>
