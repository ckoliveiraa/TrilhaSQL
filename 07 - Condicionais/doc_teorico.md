# Módulo 7 - Condicionais - Material Didático

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

**Classificar produtos por preço:**
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


```sql

 -- Aula 31 - Desafio 1: Classificar produtos como "Barato" (< R$250), "Medio" (R$250-1000) ou "Caro" (> R$1000)


-- Aula 31 - Desafio 2: Classificação de clientes por faixa etária
-- Utilize a data de nascimento para calcular a idade dos clientes
-- e classifique cada um em uma faixa etária, conforme as regras abaixo:
--
-- Jovem   → idade menor que 30 anos
-- Adulto  → idade entre 30 e 50 anos
-- Senior  → idade maior que 50 anos
--
-- Exiba: nome, data_nascimento, idade calculada e faixa_etaria.
```

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

**1. Urgência baseada em estoque E preço (usando AND):**
```sql
SELECT
    nome,
    estoque,
    preco,
    CASE
        WHEN estoque < 10 AND preco > 500 THEN 'Crítico - Produto Caro'
        WHEN estoque < 10 AND preco <= 500 THEN 'Crítico - Produto Barato'
        WHEN estoque < 30 THEN 'Baixo'
        ELSE 'OK'
    END AS urgencia
FROM produtos;
```

**2. Classificação de pedidos por frete E valor (usando OR):**
```sql
SELECT
    pedido_id,
    valor_total,
    frete,
    CASE
        WHEN frete = 0 OR valor_total > 500 THEN 'Frete Grátis'
        WHEN frete < 20 AND valor_total > 200 THEN 'Frete Reduzido'
        WHEN frete < 20 THEN 'Econômico'
        ELSE 'Normal'
    END AS tipo_frete
FROM pedidos;
```

**3. Múltiplas condições combinadas:**
```sql
SELECT
    nome,
    preco,
    estoque,
    CASE
        WHEN preco > 1000 AND estoque < 5 THEN 'Premium em Falta'
        WHEN preco > 1000 THEN 'Premium'
        WHEN estoque < 5 THEN 'Reposição Urgente'
        WHEN estoque < 20 THEN 'Estoque Baixo'
        ELSE 'Normal'
    END AS situacao
FROM produtos;
```

**4. CASE em cálculos condicionais com múltiplas condições:**
```sql
-- Calcular desconto baseado em preço E estoque
SELECT
    nome,
    preco,
    estoque,
    CASE
        WHEN preco >= 1000 AND estoque > 50 THEN preco * 0.80  -- 20% desconto: caro com alto estoque
        WHEN preco >= 1000 OR estoque < 5 THEN preco * 0.85    -- 15% desconto: ou é caro ou tem pouco estoque
        WHEN preco >= 500 AND estoque > 20 THEN preco * 0.90   -- 10% desconto: médio com bom estoque
        ELSE preco * 0.95                                       -- 5% desconto: demais casos
    END AS preco_com_desconto
FROM produtos;
```

**5. CASE para criar flags com condições combinadas (usando OR):**
```sql
-- Indicar se produto precisa de atenção urgente
SELECT
    nome,
    estoque,
    preco,
    CASE
        WHEN estoque = 0 OR (estoque < 5 AND preco > 1000) THEN 'URGENTE'
        WHEN estoque < 10 OR preco > 2000 THEN 'ATENÇÃO'
        WHEN estoque < 20 AND preco > 500 THEN 'MONITORAR'
        ELSE 'NORMAL'
    END AS prioridade
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

## Desafios

<details>
<summary><strong>Ver Desafios</strong></summary>


```sql
-- Aula 32 - Desafio 1: Definir status de produtos (Liquidação ou Reposição)
--
-- Neste desafio, você deve analisar os produtos com base
-- no preço e na quantidade em estoque.
--
-- Regras:
-- 1. Se o estoque for alto E o preço for alto,
--    o produto deve receber o status "Liquidação".
-- 2. Caso contrário, o produto deve receber o status "Reposição".
--
-- Considere:
-- estoque alto → estoque >= 100
-- preço alto   → preco >= 2000
--
-- Utilize a estrutura CASE para criar a coluna status_produto.
-- Exiba: produto_id, nome, preco, estoque e status_produto.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Aula 32 - Desafio 2: Verificando o status de entrega dos pedidos
--
-- Neste desafio, você deve analisar os pedidos e identificar
-- se eles foram entregues, não entregues ou cancelados.
--
-- Regras:
-- 1. Se o status do pedido for 'cancelado', o resultado deve ser "Cancelado".
-- 2. Se o status estiver em ('em_separacao', 'pendente', 'confirmado', 'enviado')
--    E a coluna data_entrega_realizada for NULL, o pedido deve ser classificado como "Não entregue".
-- 3. Se o status for 'entregue' OU a data_entrega_realizada não for NULL,
--    o pedido deve ser classificado como "Entregue".
--
-- Utilize a estrutura CASE para criar a coluna status_entrega.
-- Exiba: pedido_id, status, data_entrega_prevista, data_entrega_realizada e status_entrega.
```

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

**Desafio 2:** Crie um relatório de produtos com classificação combinada:
- Se o produto é de "Alta Prioridade" (preço > R$300 E estoque < 20)
- Se é "Promoção Possível" (preço > R$200 E estoque > 50)
- Se está em categoria específica (categoria_id IN (1, 2, 3))
- Adicione uma observação combinando essas condições usando AND/OR

**Desafio 3:** Classifique os clientes em:
- "Novo" - cadastrado há menos de 6 meses
- "Regular" - cadastrado entre 6 meses e 2 anos
- "Veterano" - cadastrado há mais de 2 anos

**Desafio 4:** Crie um relatório de análise de custos e descontos dos pedidos:
- **Classificação de Frete**: "Frete Grátis" (0), "Frete Econômico" (R$0.01-10.00), "Frete Padrão" (R$10.01-25.00), "Frete Premium" (R$25.01-49.96), "Frete Especial" (>R$49.96)
- **Classificação de Desconto**: "Sem Desconto" (0), "Desconto Básico" (R$0.24-20.00), "Desconto Bom" (R$20.01-50.00), "Desconto Excelente" (R$50.01-99.85), "Desconto Excepcional" (>R$99.85)
- Use CASE WHEN com BETWEEN para criar as classificações

**Desafio 5 (Boss Final!):** Crie um relatório de análise temporal de pedidos combinando múltiplos conceitos:
- **Extraia informações da data** usando EXTRACT: ano, mês e dia da semana
- **Classifique o semestre**: "1º Semestre" (meses 1-6), "2º Semestre" (meses 7-12)
- **Identifique o tipo de dia**: "Final de Semana" (sábado/domingo), "Dia de Semana" (segunda-sexta)
- **Crie análise de prioridade**: "CRÍTICO" (cancelado E valor > 500), "ATENÇÃO" (pendente E valor > 300), "SUCESSO" (entregue E valor > 400), "NORMAL" (demais casos)
- Use EXTRACT, CASE WHEN, IN, AND/OR e BETWEEN para resolver
- Status disponíveis: cancelado, confirmado, em_separacao, entregue, enviado, pendente

</details>
