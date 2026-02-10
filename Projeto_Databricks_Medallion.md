# 🏅 Projeto Databricks - Arquitetura Medallion E-commerce

## 📋 Visão Geral do Projeto

Este projeto foi desenvolvido para ensinar os conceitos da **Arquitetura Medallion** no Databricks, aplicada a um case real de e-commerce. Você atuará como **Engenheiro de Dados** e deverá construir um pipeline de dados completo, desde a ingestão bruta até a entrega de métricas de negócio.

### 🎯 Objetivos de Aprendizagem

- Implementar a arquitetura medallion (Bronze → Silver → Gold)
- Aplicar conceitos de qualidade de dados
- Criar transformações incrementais e otimizadas
- Gerar métricas de negócio prontas para consumo
- Utilizar PySpark e SQL no Databricks

---

## 🏗️ Arquitetura Medallion

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   BRONZE    │  →   │   SILVER    │  →   │    GOLD     │
│ (Raw Data)  │      │  (Refined)  │      │ (Business)  │
└─────────────┘      └─────────────┘      └─────────────┘
     │                     │                     │
     │                     │                     │
  Ingestão          Limpeza/Padronização    Agregações
  Validação         Joins/Enrichment         KPIs/Métricas
  Histórico         Deduplicação             Dashboards
```

### Camadas

| Camada | Objetivo | Transformações |
|--------|----------|----------------|
| **Bronze** | Dados brutos (raw) | Mínima transformação, validação básica |
| **Silver** | Dados limpos e confiáveis | Limpeza, padronização, joins, deduplicação |
| **Gold** | Métricas de negócio | Agregações, KPIs, modelos dimensionais |

---

## 🥉 BRONZE LAYER - Ingestão e Validação

### Contexto
Você recebeu dados brutos em formato CSV/JSON de um sistema legado de e-commerce. Sua missão é ingerir esses dados no Data Lake mantendo a rastreabilidade e aplicando validações básicas.

### Tabelas de Origem
- `categorias` - Categorias de produtos
- `produtos` - Catálogo de produtos
- `clientes` - Base de clientes
- `pedidos` - Histórico de pedidos
- `itens_pedido` - Itens dos pedidos
- `pagamentos` - Transações de pagamento
- `avaliacoes` - Avaliações de produtos

---

### 📝 Desafios Bronze

<details>
<summary><strong>Desafio B1 - Ingestão com Auditoria</strong></summary>

**Objetivo:** Criar uma função de ingestão genérica que adicione metadados de auditoria

**Requisitos:**
- Ler arquivos CSV da camada landing
- Adicionar colunas de auditoria:
  - `data_ingestao` (timestamp da ingestão)
  - `arquivo_origem` (nome do arquivo fonte)
  - `hash_registro` (hash MD5 da linha para rastreabilidade)
- Salvar no formato Delta na camada bronze
- Particionar por `data_ingestao`

**Tabelas:** Todas (categorias, produtos, clientes, pedidos, itens_pedido, pagamentos, avaliacoes)

**Dica:** Use `input_file_name()` e `current_timestamp()` do PySpark

</details>

<details>
<summary><strong>Desafio B2 - Validação de Integridade</strong></summary>

**Objetivo:** Implementar validações de qualidade nos dados brutos

**Validações por tabela:**

**Produtos:**
- `produto_id` não pode ser nulo
- `preco` deve ser maior que 0
- `estoque` não pode ser negativo
- `categoria_id` deve existir em categorias

**Clientes:**
- `cliente_id` não pode ser nulo
- `email` deve conter '@'
- `cpf` deve ter formato válido (XXX.XXX.XXX-XX)
- `estado` deve ter 2 caracteres

**Pedidos:**
- `pedido_id` não pode ser nulo
- `data_pedido` deve ser válida e não futura
- `valor_total` deve ser >= (itens - desconto + frete)
- `status` deve estar em: ['pendente', 'processando', 'enviado', 'entregue', 'cancelado']

**Entrega:**
- Criar tabela `bronze_validacao_log` com registros inválidos
- Marcar registros válidos com coluna `is_valid = true/false`

</details>

<details>
<summary><strong>Desafio B3 - Detecção de Duplicatas</strong></summary>

**Objetivo:** Identificar e marcar registros duplicados

**Requisitos:**
- Analisar todas as tabelas bronze
- Criar coluna `is_duplicado` (boolean)
- Criar coluna `ocorrencia_numero` (1 para primeira ocorrência, 2+ para duplicatas)
- Gerar relatório com:
  - Tabela
  - Total de registros
  - Registros duplicados
  - % de duplicação

**Critério de duplicação:**
- Use a PK de cada tabela (produto_id, cliente_id, pedido_id, etc.)

</details>

<details>
<summary><strong>Desafio B4 - Monitoramento de Qualidade</strong></summary>

**Objetivo:** Criar dashboard de qualidade da camada bronze

**Métricas a calcular:**
- Total de registros ingeridos por tabela
- Registros válidos vs inválidos (%)
- Registros duplicados (%)
- Campos nulos por coluna (top 10)
- Taxa de sucesso de ingestão (%)
- Volume de dados por dia de ingestão

**Entrega:**
- Tabela `bronze_quality_metrics`
- Atualizada a cada ingestão

</details>

---

## 🥈 SILVER LAYER - Limpeza e Padronização

### Contexto
Agora que os dados brutos estão no bronze, você precisa criar tabelas confiáveis e prontas para análise. Essa camada será consumida por cientistas de dados e analistas.

---

### 📝 Desafios Silver

<details>
<summary><strong>Desafio S1 - Limpeza e Padronização</strong></summary>

**Objetivo:** Limpar e padronizar os dados bronze

**Transformações por tabela:**

**Produtos:**
- Remover espaços em branco extras em `nome` e `marca`
- Padronizar `marca` para Title Case (Dell, Samsung, Apple)
- Converter `preco` para decimal(10,2)
- Adicionar coluna `faixa_preco`: 'Econômico' (<100), 'Médio' (100-500), 'Premium' (>500)
- Filtrar apenas produtos ativos e válidos

**Clientes:**
- Padronizar `nome` para Title Case
- Converter `email` para lowercase
- Formatar `telefone` no padrão (XX) XXXXX-XXXX
- Criar coluna `regiao` baseada no estado:
  - Sudeste: SP, RJ, MG, ES
  - Sul: PR, SC, RS
  - Nordeste: BA, PE, CE, RN, PB, AL, SE, MA, PI
  - Norte: AM, PA, AC, RO, RR, AP, TO
  - Centro-Oeste: GO, MT, MS, DF

**Pedidos:**
- Calcular `valor_liquido = valor_total - desconto`
- Criar coluna `trimestre` e `ano` a partir de `data_pedido`
- Classificar `ticket`: 'Baixo' (<200), 'Médio' (200-1000), 'Alto' (>1000)

</details>

<details>
<summary><strong>Desafio S2 - Enriquecimento com Joins</strong></summary>

**Objetivo:** Criar visões enriquecidas combinando tabelas

**Criar as seguintes tabelas silver:**

**`silver_pedidos_completos`:**
- Juntar: pedidos + clientes + itens_pedido + produtos + categorias + pagamentos
- Incluir:
  - Dados do cliente (nome, cidade, estado, regiao)
  - Dados do produto (nome, categoria, marca)
  - Status do pagamento
  - Quantidade de itens no pedido
  - Método de pagamento

**`silver_produtos_enriquecidos`:**
- Juntar: produtos + categorias + avaliacoes
- Calcular:
  - Média de avaliações por produto
  - Quantidade total de avaliações
  - Categoria do produto

**`silver_clientes_consolidados`:**
- Juntar: clientes + pedidos + avaliacoes
- Calcular:
  - Total gasto por cliente (lifetime value)
  - Quantidade de pedidos
  - Ticket médio
  - Data do primeiro pedido
  - Data do último pedido
  - Produtos avaliados

</details>

<details>
<summary><strong>Desafio S3 - Slowly Changing Dimension (SCD Tipo 2)</strong></summary>

**Objetivo:** Implementar histórico de mudanças em produtos

**Requisitos:**
- Criar `silver_produtos_scd2` com colunas:
  - Todas as colunas de produtos
  - `valid_from` (início da vigência)
  - `valid_to` (fim da vigência, NULL se atual)
  - `is_current` (boolean, true para versão atual)
  - `version` (número da versão)

**Lógica:**
- Quando `preco` ou `estoque` mudar, criar nova versão
- Manter histórico completo de alterações
- Sempre manter uma versão `is_current = true`

**Dica:** Use merge do Delta Lake

</details>

<details>
<summary><strong>Desafio S4 - Detecção de Anomalias</strong></summary>

**Objetivo:** Identificar comportamentos anômalos nos dados

**Anomalias a detectar:**

**Pedidos suspeitos:**
- Valor muito alto (> 3x desvio padrão)
- Valor muito baixo (< R$ 10)
- Mesmo cliente com múltiplos pedidos no mesmo minuto
- Frete maior que valor dos produtos

**Produtos com problemas:**
- Estoque negativo
- Preço zerado mas produto ativo
- Sem vendas nos últimos 90 dias

**Clientes atípicos:**
- Mais de 10 pedidos no mesmo dia
- Pedidos cancelados > 50% do total

**Entrega:**
- Tabela `silver_anomalias` com:
  - tipo_anomalia
  - tabela_origem
  - id_registro
  - descricao
  - severidade ('baixa', 'média', 'alta')
  - data_deteccao

</details>

<details>
<summary><strong>Desafio S5 - Deduplicação Inteligente</strong></summary>

**Objetivo:** Remover duplicatas mantendo o melhor registro

**Critérios de escolha:**
- Para clientes: manter registro mais completo (menos nulls)
- Para produtos: manter registro mais recente
- Para pedidos: manter registro com maior valor_total

**Requisitos:**
- Aplicar em todas as tabelas silver
- Criar log de deduplicação mostrando:
  - Registros removidos
  - Critério utilizado
  - IDs dos registros mesclados

</details>

---

## 🥇 GOLD LAYER - Métricas de Negócio

### Contexto
A camada Gold é consumida diretamente por ferramentas de BI (Power BI, Tableau) e pela diretoria. As tabelas devem estar otimizadas, agregadas e responder perguntas de negócio específicas.

---

### 📝 Desafios Gold

<details>
<summary><strong>Desafio G1 - KPIs de Vendas</strong></summary>

**Objetivo:** Criar tabela `gold_kpis_vendas` com visão diária/mensal/anual

**Métricas:**
- Receita total (bruta e líquida)
- Ticket médio
- Quantidade de pedidos
- Quantidade de itens vendidos
- Desconto total concedido
- Frete total
- Taxa de conversão (pedidos entregues / total)
- AOV (Average Order Value)
- Receita por região

**Granularidades:**
- Diária (`gold_kpis_vendas_diario`)
- Mensal (`gold_kpis_vendas_mensal`)
- Anual (`gold_kpis_vendas_anual`)

**Dica:** Use window functions para calcular variação % vs período anterior

</details>

<details>
<summary><strong>Desafio G2 - Análise de Produtos</strong></summary>

**Objetivo:** Criar `gold_produtos_performance`

**Métricas por produto:**
- Quantidade vendida
- Receita gerada
- Ticket médio
- Frequência de compra
- Avaliação média
- Taxa de avaliação (avaliações / vendas)
- Estoque atual vs média de vendas (dias de estoque)
- Ranking de vendas (geral e por categoria)
- % de participação na receita
- Produtos mais vendidos em combo

**Segmentações:**
- Por categoria
- Por faixa de preço
- Por marca

</details>

<details>
<summary><strong>Desafio G3 - Análise RFM (Recency, Frequency, Monetary)</strong></summary>

**Objetivo:** Criar `gold_clientes_rfm` para segmentação

**Calcular:**
- **Recency:** Dias desde o último pedido
- **Frequency:** Quantidade de pedidos
- **Monetary:** Valor total gasto

**Criar scores (1-5) para cada dimensão:**
- Score 5: melhor performance
- Score 1: pior performance

**Criar segmentos:**
- Champions (RFM: 555, 554, 544, 545)
- Loyal Customers (RFM: 543, 444, 435)
- Potential Loyalists (RFM: 553, 551, 552)
- At Risk (RFM: 244, 334, 343)
- Can't Lose Them (RFM: 155, 154, 144)
- Lost (RFM: 111, 112, 121)

**Entrega:**
- Tabela com cliente_id, R, F, M, scores, segmento
- Contagem de clientes por segmento
- Receita por segmento

</details>

<details>
<summary><strong>Desafio G4 - Análise de Coorte</strong></summary>

**Objetivo:** Criar `gold_cohort_analysis` analisando retenção de clientes

**Definição:**
- Coorte = mês da primeira compra
- Análise de retenção mensal

**Métricas:**
- Taxa de retenção mês a mês
- Receita por coorte ao longo do tempo
- Quantidade de clientes ativos por coorte
- LTV (Lifetime Value) por coorte
- Churn rate por coorte

**Formato da tabela:**
```
cohort_mes | mes_0 | mes_1 | mes_2 | mes_3 | ...
2024-01    | 100%  | 45%   | 32%   | 28%   | ...
2024-02    | 100%  | 50%   | 35%   | ...   | ...
```

</details>

<details>
<summary><strong>Desafio G5 - Market Basket Analysis</strong></summary>

**Objetivo:** Identificar produtos frequentemente comprados juntos

**Criar `gold_product_affinity`:**
- Pares de produtos comprados juntos
- Support: % de pedidos que contém o par
- Confidence: P(produto_B | produto_A)
- Lift: Confidence / P(produto_B)

**Métricas:**
- Top 20 combinações mais frequentes
- Sugestões de cross-sell por produto
- Produtos que raramente são comprados sozinhos

**Entrega:**
- Tabela com pares de produtos e métricas
- Filtrar apenas pares com support > 1% e lift > 1

</details>

<details>
<summary><strong>Desafio G6 - Análise de Pagamentos</strong></summary>

**Objetivo:** Criar `gold_pagamentos_analysis`

**Métricas:**
- Taxa de aprovação por método de pagamento
- Ticket médio por método
- Tempo médio de aprovação
- Taxa de fraude (pagamentos recusados)
- Preferência de pagamento por região
- Evolução de métodos ao longo do tempo

**Análises:**
- Método mais usado por faixa de valor
- Correlação entre método e taxa de cancelamento
- Sazonalidade nos métodos de pagamento

</details>

<details>
<summary><strong>Desafio G7 - Análise de Churn</strong></summary>

**Objetivo:** Criar `gold_churn_prediction`

**Definir churn:**
- Cliente sem compras nos últimos 90 dias (considerando frequência histórica)

**Calcular features:**
- Dias desde última compra
- Média de dias entre compras
- Tendência de compra (crescente/decrescente)
- Valor da última compra vs média
- Quantidade de avaliações deixadas
- Taxa de cancelamento histórica

**Entrega:**
- Tabela com cliente_id e flag `em_risco_churn`
- Score de propensão ao churn (0-100)
- Segmento de risco (baixo, médio, alto)

</details>

<details>
<summary><strong>Desafio G8 - Dashboard Executivo</strong></summary>

**Objetivo:** Criar `gold_executive_dashboard` - Snapshot diário

**Métricas em tempo real:**
- Receita do dia/mês/ano
- Pedidos do dia/mês/ano
- Ticket médio
- Top 5 produtos do mês
- Top 5 categorias do mês
- Top 5 clientes do mês
- Novos clientes do mês
- Taxa de conversão
- NPS (Net Promoter Score) baseado em avaliações
- Comparativo com mesmo período do ano anterior

**Formato:**
- Uma linha por dia
- Otimizada para visualização em dashboard

</details>

---

## 🎯 Desafio Final Integrado

<details>
<summary><strong>🏆 Boss Final - Pipeline Completo End-to-End</strong></summary>

### Contexto
Você foi promovido a **Lead Data Engineer** e precisa entregar um pipeline completo de dados para o CEO do e-commerce. Ele quer respostas para as seguintes perguntas estratégicas:

### Perguntas de Negócio

1. **Qual categoria de produto tem maior margem e deve receber investimento em marketing?**
   - Considere: receita, ticket médio, avaliações, frequência de recompra

2. **Quais clientes devemos focar em retenção urgente?**
   - Identifique clientes de alto valor em risco de churn
   - Calcule o impacto financeiro da perda desses clientes

3. **Existe oportunidade de cross-sell e upsell?**
   - Identifique padrões de compra
   - Sugira produtos complementares
   - Calcule potencial de receita adicional

4. **Nossa operação de frete está otimizada?**
   - Analise correlação entre frete e cancelamento
   - Identifique regiões com maior custo de frete
   - Sugira otimizações

5. **Qual o perfil do nosso cliente ideal (ICP)?**
   - Defina baseado em: região, ticket, frequência, produtos comprados
   - Compare com clientes de baixo valor

6. **Como está nossa saúde financeira mês a mês?**
   - Tendências de crescimento
   - Sazonalidade
   - Previsão para próximos 3 meses (usar média móvel)

### Requisitos Técnicos

**Pipeline deve incluir:**
- ✅ Ingestão incremental (processar apenas dados novos)
- ✅ Validação de qualidade em cada camada
- ✅ Logging e monitoramento
- ✅ Otimização de performance (particionamento, Z-order, vacuum)
- ✅ Testes automatizados (Great Expectations ou similar)
- ✅ Documentação das tabelas (data catalog)
- ✅ Orquestração (Databricks Workflows ou Airflow)

**Entrega:**
1. Notebooks organizados por camada (bronze/silver/gold)
2. Tabelas Gold respondendo cada pergunta de negócio
3. README.md explicando arquitetura e como executar
4. Dashboard visual (Databricks SQL ou Power BI)
5. Apresentação executiva (10 slides) com insights

### Critérios de Avaliação

| Critério | Peso |
|----------|------|
| Qualidade do código (PEP8, docstrings) | 15% |
| Modelagem de dados (normalização, performance) | 20% |
| Qualidade e validação dos dados | 20% |
| Insights de negócio gerados | 25% |
| Documentação e organização | 10% |
| Otimização e performance | 10% |

</details>

---

## 📚 Recursos Adicionais

### Conceitos Importantes

**Delta Lake:**
- Time Travel
- ACID Transactions
- Schema Evolution
- MERGE operations

**Otimização:**
- Z-Order
- Particionamento
- Vacuum
- Optimize

**Qualidade de Dados:**
- Great Expectations
- Data validation rules
- Anomaly detection

**Orquestração:**
- Databricks Workflows
- Apache Airflow
- Task dependencies

### Boas Práticas

1. **Nomenclatura:**
   - `bronze_<nome_tabela>` para dados brutos
   - `silver_<nome_tabela>` para dados limpos
   - `gold_<metrica>_<granularidade>` para agregações

2. **Particionamento:**
   - Bronze: `data_ingestao`
   - Silver: `ano` e `mes`
   - Gold: `data_referencia`

3. **Incrementalidade:**
   - Use watermarks para processar apenas novos dados
   - Mantenha controle de última execução

4. **Performance:**
   - Cache tabelas pequenas e frequentemente usadas
   - Use broadcast joins quando apropriado
   - Particione antes de joins grandes

---

## 🚀 Como Começar

1. **Setup do Ambiente:**
   - Criar workspace Databricks (Community Edition ou trial)
   - Configurar cluster
   - Upload dos dados CSV

2. **Estrutura de Pastas:**
```
/dbfs/mnt/datalake/
├── landing/          # Dados brutos (CSV/JSON)
├── bronze/          # Delta tables - raw
├── silver/          # Delta tables - refined
└── gold/            # Delta tables - business
```

3. **Ordem de Execução:**
   - Comece pela camada Bronze (ingestão)
   - Avance para Silver (limpeza)
   - Finalize com Gold (métricas)
   - Desenvolva o pipeline incremental

4. **Iteração:**
   - Faça um desafio por vez
   - Valide os resultados
   - Otimize conforme necessário

---

## ✅ Checklist de Conclusão

### Bronze
- [ ] Ingestão com auditoria implementada
- [ ] Validações de integridade funcionando
- [ ] Duplicatas identificadas
- [ ] Dashboard de qualidade criado

### Silver
- [ ] Dados limpos e padronizados
- [ ] Joins e enriquecimentos realizados
- [ ] SCD Tipo 2 implementado
- [ ] Anomalias detectadas
- [ ] Deduplicação aplicada

### Gold
- [ ] KPIs de vendas calculados
- [ ] Performance de produtos analisada
- [ ] Análise RFM concluída
- [ ] Análise de coorte implementada
- [ ] Market basket analysis feita
- [ ] Análise de pagamentos completa
- [ ] Modelo de churn criado
- [ ] Dashboard executivo funcionando

### Desafio Final
- [ ] Pipeline end-to-end implementado
- [ ] Todas as perguntas de negócio respondidas
- [ ] Documentação completa
- [ ] Dashboard visual criado
- [ ] Apresentação preparada

---

## 🎓 Próximos Passos

Após concluir este projeto, você estará preparado para:

1. **Trabalhar com Data Lakes modernos**
2. **Implementar arquiteturas de dados escaláveis**
3. **Aplicar engenharia de dados em casos reais**
4. **Gerar valor através de dados**
5. **Avançar para Machine Learning e IA**

### Sugestões de Evolução

- Implementar streaming com Structured Streaming
- Adicionar camada de feature store para ML
- Criar pipelines de CI/CD para código
- Implementar data quality com Great Expectations
- Orquestrar com Airflow ou Databricks Workflows
- Adicionar governança com Unity Catalog

---

**Boa sorte e bons estudos! 🚀**

*Lembre-se: dados de qualidade são a base de qualquer decisão inteligente.*
