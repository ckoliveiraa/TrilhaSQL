# 📚 Trilha SQL - Materiais de Aprendizado

## 🎯 Objetivo
Dominar os fundamentos do SQL através de aulas práticas e desafios progressivos.

---

## 📖 Módulos Disponíveis

| # | Módulo | Descrição |
|---|--------|-----------|
| 01 | [Fundamentos - SELECT](01%20-%20Fundamentos%20-%20SELECT/) | SELECT, FROM, ORDER BY, LIMIT |
| 02 | [Filtros Avançados](02%20-%20Filtros%20Avançados/) | WHERE, AND, OR, LIKE, IN, BETWEEN |
| 03 | [Funções de String](03%20-%20Funções%20de%20String/) | CONCAT, UPPER, LOWER, TRIM, SUBSTRING |
| 04 | [Funções de Data](04%20-%20Funções%20de%20Data/) | DATE_PART, DATE_ADD, DATE_DIFF, DATE_FORMAT |
| 05 | [Conversão de Dados](05%20-%20Conversão%20de%20Dados/) | CAST, COALESCE |
| 06 | [Condicionais](06%20-%20Condicionais/) | CASE WHEN, IF |
| 07 | [Funções de Agregação](07%20-%20Funções%20de%20Agregação/) | COUNT, SUM, AVG, MIN, MAX |
| 08 | [Agrupamento](08%20-%20Agrupamento/) | GROUP BY, HAVING |
| 09 | [JOINs](09%20-%20JOINs/) | INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN |
| 10 | [Combinando Resultados](10%20-%20Combinando%20Resultados/) | UNION, INTERSECT, EXCEPT |
| 11 | [Subconsultas](11%20-%20Subconsultas/) | Subqueries, EXISTS, IN |
| 12 | [Manipulação de Dados](12%20-%20Manipulação%20de%20Dados/) | INSERT, UPDATE, DELETE |
| 13 | [Window Functions](13%20-%20Window%20Functions/) | ROW_NUMBER, RANK, LAG, LEAD |
| 14 | [CTEs & Otimização](14%20-%20CTEs%20%26%20Otimização/) | WITH, índices, EXPLAIN |

---

## 🗺️ Trilha de Aprendizado

```
═══════════════════════════════════════════════════════════════════════════════
                           TRILHA DE APRENDIZADO SQL
═══════════════════════════════════════════════════════════════════════════════

 FUNDAÇÃO                    TRANSFORMAÇÃO              AGREGAÇÃO
 ────────                    ─────────────              ─────────
 ┌─────────┐  ┌─────────┐   ┌─────────┐ ┌─────────┐   ┌─────────┐ ┌─────────┐
 │   01    │  │   02    │   │   03    │ │   04    │   │   06    │ │   07    │
 │ SELECT  │→ │ FILTROS │ → │ STRING  │→│  DATA   │ → │  CASE   │→│  AGG    │
 │ básico  │  │  WHERE  │   │  funcs  │ │  funcs  │   │  WHEN   │ │ funcs   │
 └─────────┘  └─────────┘   └─────────┘ └─────────┘   └─────────┘ └─────────┘
                                   │
                            ┌──────┴──────┐
                            │     05      │
                            │  CONVERSÃO  │
                            │    CAST     │
                            └─────────────┘

 AGRUPAMENTO                RELACIONAMENTOS            COMBINAÇÕES
 ───────────                ───────────────            ───────────
 ┌─────────┐               ┌─────────┐                ┌─────────┐
 │   08    │               │   09    │                │   10    │
 │ GROUP BY│ ────────────→ │  JOINs  │ ─────────────→ │  UNION  │
 │ HAVING  │               │múltiplas│                │INTERSECT│
 └─────────┘               │ tabelas │                └─────────┘
                           └─────────┘

 AVANÇADO
 ────────
 ┌─────────┐  ┌─────────┐   ┌─────────┐  ┌─────────┐
 │   11    │  │   12    │   │   13    │  │   14    │
 │  SUB    │→ │ INSERT  │ → │ WINDOW  │→ │  CTEs   │
 │ QUERIES │  │ UPDATE  │   │ FUNCS   │  │  OPTIM  │
 └─────────┘  │ DELETE  │   └─────────┘  └─────────┘
              └─────────┘
═══════════════════════════════════════════════════════════════════════════════
```

---

## 🗄️ Banco de Dados

O banco de dados de e-commerce utilizado nos exercícios contém as seguintes tabelas:

| Tabela | Descrição |
|--------|-----------|
| `categorias` | Categorias de produtos |
| `produtos` | Catálogo de produtos |
| `clientes` | Dados dos clientes |
| `pedidos` | Pedidos realizados |
| `itens_pedido` | Itens de cada pedido |
| `pagamentos` | Pagamentos dos pedidos |
| `avaliacoes` | Avaliações de produtos |

<!-- 📄 **[Script do Banco de Dados](Database/dados_ecommerce.sql)** -->

---

## 📖 Como Usar Este Material

1. Execute o script do banco de dados no PostgreSQL
2. Estude um módulo por vez, na ordem sugerida
3. Leia a teoria antes de praticar
4. Resolva os desafios de cada aula
5. Complete o desafio final do módulo
6. Avance para o próximo módulo

---

## 📂 Estrutura de Cada Módulo

```
XX - Nome do Módulo/
├── doc_teorico.md           # Material teórico com exemplos
├── desafio_final_respostas.sql  # Gabarito do desafio final
└── ementa.txt               # Ementa das aulas (se disponível)
```

---

## 💪 Bons Estudos!

Pratique bastante e não tenha medo de errar. SQL é uma habilidade que se desenvolve com a prática!
