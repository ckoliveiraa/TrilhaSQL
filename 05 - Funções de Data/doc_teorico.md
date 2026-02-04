# Módulo 5 - Funções de Data

## Objetivo do Módulo
Dominar as funções de manipulação de datas em SQL, aprendendo a extrair partes de datas, calcular diferenças entre datas, adicionar intervalos de tempo e formatar datas para exibição.

---
# AULA 24

<details>
<summary><strong>Expandir Aula 24</strong></summary>

## CURRENT_DATE - Data Atual

## O que é?

A função `CURRENT_DATE` retorna a **data atual** do sistema, sem informação de hora.

## Sintaxe

```sql
-- Retorna a data de hoje
SELECT CURRENT_DATE;

-- Também funciona como
SELECT CURRENT_DATE AS data_hoje;
```

## Funções Relacionadas

```sql
-- Data atual (sem hora)
SELECT CURRENT_DATE;
-- Resultado: 2024-01-15

-- Data e hora atual
SELECT CURRENT_TIMESTAMP;
-- Resultado: 2024-01-15 14:30:45

-- Apenas hora atual
SELECT CURRENT_TIME;
-- Resultado: 14:30:45

-- NOW() é equivalente a CURRENT_TIMESTAMP
SELECT NOW();
-- Resultado: 2024-01-15 14:30:45
```

## Casos de Uso Práticos

```sql
-- Ver a data de hoje
SELECT CURRENT_DATE AS hoje;

-- Calcular quantos dias se passaram desde uma data
SELECT data_pedido, CURRENT_DATE - data_pedido AS dias_passados
FROM pedidos;

-- Filtrar pedidos de hoje
SELECT * FROM pedidos WHERE data_pedido = CURRENT_DATE;

-- Verificar se um pedido é recente (últimos 7 dias)
SELECT * FROM pedidos
WHERE data_pedido >= CURRENT_DATE - INTERVAL '7 days';
```

## Calculando Idade

```sql
-- Calcular idade dos clientes
SELECT
    nome,
    data_nascimento,
    EXTRACT(YEAR FROM AGE(data_nascimento)) AS idade
FROM clientes;

-- AGE() calcula a diferença entre duas datas
SELECT AGE(CURRENT_DATE, '1990-05-20');
-- Resultado: 33 years 7 mons 26 days
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 24 - Desafio 1: Calcular quantos dias se passaram desde cada pedido
-- Exiba pedido_id, data_pedido, data atual e dias desde o pedido


-- Aula 24 - Desafio 2: Mostrar idade aproximada dos clientes
-- Exiba o nome, data de nascimento e idade em anos

```

</details>

</details>

---

# AULA 25

<details>
<summary><strong>Expandir Aula 25</strong></summary>

## DATE_PART / EXTRACT - Extraindo Partes da Data

## O que é?

As funções `DATE_PART` e `EXTRACT` permitem **extrair componentes específicos** de uma data, como ano, mês, dia, hora, etc.

## Sintaxe

```sql
-- Usando DATE_PART
SELECT DATE_PART('year', data_coluna) FROM tabela;

-- Usando EXTRACT (padrão SQL)
SELECT EXTRACT(YEAR FROM data_coluna) FROM tabela;
```

## Componentes que podem ser extraídos

| Componente | Descrição | Exemplo |
|------------|-----------|---------|
| `year` | Ano | 2024 |
| `month` | Mês (1-12) | 7 |
| `day` | Dia do mês (1-31) | 15 |
| `hour` | Hora (0-23) | 14 |
| `minute` | Minuto (0-59) | 30 |
| `second` | Segundo (0-59) | 45 |
| `dow` | Dia da semana (0=Dom, 6=Sáb) | 3 |
| `week` | Semana do ano (1-53) | 28 |
| `quarter` | Trimestre (1-4) | 2 |

## Exemplos Práticos

```sql
-- Extrair o ano de cada pedido
SELECT
    pedido_id,
    data_pedido,
    EXTRACT(YEAR FROM data_pedido) AS ano
FROM pedidos;

-- Extrair mês e ano
SELECT
    pedido_id,
    EXTRACT(MONTH FROM data_pedido) AS mes,
    EXTRACT(YEAR FROM data_pedido) AS ano
FROM pedidos;

-- Descobrir o dia da semana
SELECT
    pedido_id,
    data_pedido,
    EXTRACT(DOW FROM data_pedido) AS dia_semana
FROM pedidos;
-- 0 = Domingo, 1 = Segunda, ..., 6 = Sábado
```

## Usando para Filtros

```sql
-- Pedidos de janeiro
SELECT * FROM pedidos
WHERE EXTRACT(MONTH FROM data_pedido) = 1;

-- Pedidos de 2024
SELECT * FROM pedidos
WHERE EXTRACT(YEAR FROM data_pedido) = 2024;

-- Pedidos de fim de semana (Sábado e Domingo)
SELECT * FROM pedidos
WHERE EXTRACT(DOW FROM data_pedido) IN (0, 6);
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 25 - Desafio 1: Extrair o mês de cada pedido
-- Exiba o pedido_id, data_pedido e o mês


-- Aula 25 - Desafio 2: Extrair ano, mes e dia de cada pedido
-- Exiba pedido_id, data_pedido, ano, mes e dia separadamente

```

</details>

</details>

---

# AULA 26

<details>
<summary><strong>Expandir Aula 26</strong></summary>

## Interval - Adicionando e Subtraindo Tempo

## O que é?

Em PostgreSQL, você pode adicionar ou subtrair intervalos de tempo de datas usando `INTERVAL` ou operadores aritméticos.

## Sintaxe

```sql
-- Adicionando tempo com INTERVAL
SELECT data_coluna + INTERVAL '7 days' FROM tabela;

-- Subtraindo tempo com INTERVAL
SELECT data_coluna - INTERVAL '1 month' FROM tabela;

-- Aritmética simples com inteiros (dias)
SELECT data_coluna + 7 FROM tabela;  -- Adiciona 7 dias
```

## Tipos de Intervalos

```sql
-- Dias
SELECT CURRENT_DATE + INTERVAL '7 days';

-- Meses
SELECT CURRENT_DATE + INTERVAL '1 month';

-- Anos
SELECT CURRENT_DATE + INTERVAL '1 year';

-- Combinações
SELECT CURRENT_DATE + INTERVAL '1 year 2 months 3 days';

-- Horas, minutos, segundos
SELECT CURRENT_TIMESTAMP + INTERVAL '2 hours 30 minutes';
```

## Exemplos Práticos

```sql
-- Calcular prazo de entrega (7 dias após o pedido)
SELECT
    pedido_id,
    data_pedido,
    data_pedido + INTERVAL '7 days' AS prazo_entrega
FROM pedidos;

-- Calcular data de vencimento (30 dias)
SELECT
    pedido_id,
    data_pedido,
    data_pedido + INTERVAL '30 days' AS vencimento
FROM pedidos;

-- Pedidos que deveriam ser entregues até hoje
SELECT * FROM pedidos
WHERE data_pedido + INTERVAL '7 days' <= CURRENT_DATE;

-- Aniversário do próximo ano
SELECT
    nome,
    data_nascimento,
    data_nascimento + INTERVAL '1 year' * (
        EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_nascimento) + 1
    ) AS proximo_aniversario
FROM clientes;
```

## Subtraindo Tempo

```sql
-- Pedidos da última semana
SELECT * FROM pedidos
WHERE data_pedido >= CURRENT_DATE - INTERVAL '7 days';

-- Pedidos do último mês
SELECT * FROM pedidos
WHERE data_pedido >= CURRENT_DATE - INTERVAL '1 month';
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 26 - Desafio 1: Calcular prazo de entrega (data_pedido + 7 dias)
-- Exiba pedido_id, data_pedido e prazo_entrega


-- Aula 26 - Desafio 2: Adicionar 30 dias à data de nascimento dos clientes
-- Exiba nome, data_nascimento e a nova data

```

</details>

</details>

---

# AULA 27

<details>
<summary><strong>Expandir Aula 27</strong></summary>

## Diferença Entre Datas

## O que é?

Calcular a **diferença entre duas datas** é fundamental para análises de tempo, como prazo de entrega, tempo de resposta, idade, etc.

## Sintaxe

```sql
-- Subtrair datas diretamente (retorna intervalo ou dias)
SELECT data_maior - data_menor FROM tabela;

-- Usando AGE() para diferença detalhada
SELECT AGE(data_maior, data_menor) FROM tabela;

-- Extraindo apenas dias da diferença
SELECT EXTRACT(DAY FROM AGE(data_maior, data_menor)) FROM tabela;
```

## Exemplos Práticos

```sql
-- Diferença simples em dias
SELECT
    pedido_id,
    data_pedido,
    data_entrega,
    data_entrega - data_pedido AS dias_para_entrega
FROM pedidos
WHERE data_entrega IS NOT NULL;

-- Usando AGE() para diferença completa
SELECT
    pedido_id,
    AGE(data_entrega, data_pedido) AS tempo_entrega
FROM pedidos
WHERE data_entrega IS NOT NULL;
-- Resultado: "5 days" ou "1 mon 2 days"

-- Calcular idade em anos
SELECT
    nome,
    data_nascimento,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, data_nascimento)) AS idade
FROM clientes;
```

## Calculando Atrasos

```sql
-- Verificar dias de entrega vs prazo (7 dias)
SELECT
    pedido_id,
    data_pedido,
    data_entrega,
    data_entrega - data_pedido AS dias_reais,
    data_pedido + INTERVAL '7 days' AS prazo_estimado
FROM pedidos
WHERE data_entrega IS NOT NULL;

-- Calcular dias de atraso (se houver)
-- GREATEST retorna o maior valor entre os argumentos
SELECT
    pedido_id,
    data_pedido,
    data_entrega,
    GREATEST(0, (data_entrega - data_pedido) - 7) AS dias_atraso
FROM pedidos
WHERE data_entrega IS NOT NULL;
```

> **Nota:** Para classificar entregas como "Atrasado" ou "No Prazo", você usará `CASE WHEN` no **Módulo 7 - Condicionais**.

## Função Útil: DATE_TRUNC

A função `DATE_TRUNC` "trunca" uma data para o início de um período específico. Pense nela como um "arredondamento para baixo" da data.

### Sintaxe

```sql
DATE_TRUNC('período', coluna_data)
```

### Períodos Disponíveis

| Período | Descrição | Exemplo (2024-07-15) |
|---------|-----------|----------------------|
| `'day'` | Início do dia | 2024-07-15 00:00:00 |
| `'week'` | Início da semana (segunda) | 2024-07-15 |
| `'month'` | Início do mês | 2024-07-01 |
| `'year'` | Início do ano | 2024-01-01 |

### Exemplos Práticos

```sql
-- Truncar para o início do mês
SELECT DATE_TRUNC('month', data_pedido) AS inicio_mes
FROM pedidos;
-- 2024-07-15 → 2024-07-01
-- 2024-07-28 → 2024-07-01

-- Truncar para o início do ano
SELECT DATE_TRUNC('year', data_pedido) AS inicio_ano
FROM pedidos;
-- 2024-07-15 → 2024-01-01
-- 2024-03-10 → 2024-01-01
```

### Quando usar?

- Para agrupar datas por mês ou ano em relatórios
- Para comparar se duas datas estão no mesmo período
- Para calcular o início de um período a partir de qualquer data

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 27 - Desafio 1: Calcular tempo de entrega em dias (data_entrega - data_pedido)
-- Exiba pedido_id, data_pedido, data_entrega e dias_para_entrega


-- Aula 27 - Desafio 2: Calcular atraso nas entregas
-- Considere prazo de 7 dias. Mostre apenas pedidos atrasados e quantos dias de atraso

```

</details>

</details>

---

# AULA 28

<details>
<summary><strong>Expandir Aula 28</strong></summary>

## TO_CHAR - Formatando Datas

## O que é?

A função `TO_CHAR` converte datas para **texto formatado**, permitindo exibir datas em formatos personalizados.

## Sintaxe

```sql
SELECT TO_CHAR(data_coluna, 'formato') FROM tabela;
```

## Códigos de Formatação

| Código | Descrição | Exemplo |
|--------|-----------|---------|
| `DD` | Dia (01-31) | 15 |
| `MM` | Mês numérico (01-12) | 07 |
| `YYYY` | Ano com 4 dígitos | 2024 |
| `YY` | Ano com 2 dígitos | 24 |
| `Month` | Nome do mês completo | July |
| `Mon` | Nome do mês abreviado | Jul |
| `Day` | Nome do dia completo | Monday |
| `Dy` | Nome do dia abreviado | Mon |
| `HH24` | Hora (00-23) | 14 |
| `HH12` | Hora (01-12) | 02 |
| `MI` | Minutos | 30 |
| `SS` | Segundos | 45 |
| `AM`/`PM` | Indicador AM/PM | PM |

## Exemplos Práticos

```sql
-- Formato brasileiro (DD/MM/YYYY)
SELECT
    pedido_id,
    TO_CHAR(data_pedido, 'DD/MM/YYYY') AS data_formatada
FROM pedidos;

-- Formato americano (MM-DD-YYYY)
SELECT TO_CHAR(data_pedido, 'MM-DD-YYYY') AS data_us
FROM pedidos;

-- Com nome do mês
SELECT TO_CHAR(data_pedido, 'DD "de" Month "de" YYYY') AS data_extenso
FROM pedidos;
-- Resultado: "15 de July     de 2024"

-- Usar TMMonth para remover espaços extras
SELECT TO_CHAR(data_pedido, 'DD "de" TMMonth "de" YYYY') AS data_extenso
FROM pedidos;
-- Resultado: "15 de July de 2024"
```

## Formatando com Hora

```sql
-- Data e hora completa
SELECT TO_CHAR(CURRENT_TIMESTAMP, 'DD/MM/YYYY HH24:MI:SS') AS agora;
-- Resultado: "15/07/2024 14:30:45"

-- Hora no formato 12h
SELECT TO_CHAR(CURRENT_TIMESTAMP, 'DD/MM/YYYY HH12:MI AM') AS agora;
-- Resultado: "15/07/2024 02:30 PM"
```

## Mês por Extenso em Português

> **Nota:** Para exibir o mês por extenso em português, você precisará usar `CASE WHEN`, que será ensinado no **Módulo 6 - Condicionais**. Por enquanto, use o número do mês ou o nome em inglês com `TMMonth`.

```sql
-- Exemplo usando o nome do mês (em inglês)
SELECT
    pedido_id,
    TO_CHAR(data_pedido, 'DD "de" TMMonth "de" YYYY') AS data_extenso
FROM pedidos;
-- Resultado: "15 de July de 2024"

-- Ou apenas o número do mês
SELECT
    pedido_id,
    EXTRACT(MONTH FROM data_pedido) AS numero_mes
FROM pedidos;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 28 - Desafio 1: Formatar data_pedido como "DD/MM/YYYY"
-- Exiba pedido_id e a data formatada


-- Aula 28 - Desafio 2: Mostrar mês por extenso dos pedidos
-- Exiba pedido_id, data_pedido e o nome do mês

```

</details>

</details>

---

## Resumo Rápido

| Função | O que faz | Exemplo |
|--------|-----------|---------|
| `CURRENT_DATE` | Data de hoje | `SELECT CURRENT_DATE` |
| `CURRENT_TIMESTAMP` | Data e hora atual | `SELECT CURRENT_TIMESTAMP` |
| `EXTRACT(parte FROM data)` | Extrai parte da data | `EXTRACT(YEAR FROM data_pedido)` |
| `DATE_PART('parte', data)` | Extrai parte da data | `DATE_PART('month', data_pedido)` |
| `+ INTERVAL` | Adiciona tempo | `data + INTERVAL '7 days'` |
| `- INTERVAL` | Subtrai tempo | `data - INTERVAL '1 month'` |
| `AGE(data1, data2)` | Diferença entre datas | `AGE(data_entrega, data_pedido)` |
| `TO_CHAR(data, formato)` | Formata data como texto | `TO_CHAR(data, 'DD/MM/YYYY')` |
| `DATE_TRUNC(parte, data)` | Trunca para início do período | `DATE_TRUNC('month', data)` |

---

## Checklist de Domínio

- [ ] Sei obter a data e hora atual com CURRENT_DATE e CURRENT_TIMESTAMP
- [ ] Consigo extrair ano, mês, dia com EXTRACT ou DATE_PART
- [ ] Sei adicionar e subtrair intervalos de tempo
- [ ] Consigo calcular diferenças entre datas
- [ ] Sei formatar datas com TO_CHAR
- [ ] Entendo como truncar datas com DATE_TRUNC
- [ ] Consigo calcular idade a partir de data de nascimento

---

## Próximos Passos

No próximo módulo, você aprenderá sobre:
- CAST - Conversão de tipos de dados
- COALESCE - Tratamento de valores nulos

---

## Desafio Final do Módulo 5

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

Use seus conhecimentos de funções de data para resolver estes desafios.

### Desafios

```sql
-- Desafio Final 1: Relatório de Pedidos com Datas Formatadas
-- Crie um relatório que mostre:
-- - pedido_id
-- - data_pedido formatada como "DD/MM/YYYY"
-- - dia da semana do pedido (número: 0=Dom, 6=Sáb)
-- - mês do pedido (número)


-- Desafio Final 2: Análise de Tempo de Entrega
-- Para pedidos com data_entrega preenchida, mostre:
-- - pedido_id
-- - data_pedido
-- - data_entrega
-- - dias para entrega (data_entrega - data_pedido)
-- Dica: Use WHERE data_entrega IS NOT NULL


-- Desafio Final 3: Pedidos Recentes
-- Mostre os pedidos dos últimos 30 dias:
-- - pedido_id
-- - data_pedido formatada como "DD/MM/YYYY"
-- - data_pedido formatada como "Dia da semana, DD de Mês"
-- Dica: Use WHERE data_pedido >= CURRENT_DATE - INTERVAL '30 days'


-- Desafio Final 4: Clientes e Idades
-- Crie um relatório de clientes com:
-- - nome
-- - data_nascimento formatada como "DD/MM/YYYY"
-- - idade em anos (use EXTRACT com AGE)
-- Ordene pelos mais velhos primeiro


-- Desafio Final 5 (Boss Final!): Relatório Completo de Pedidos
-- Crie um relatório detalhado que mostre:
-- - pedido_id
-- - data_pedido formatada como "Dia da semana, DD de Mês de YYYY"
-- - há quantos dias o pedido foi realizado
-- - data_entrega formatada (se existir)

```

</details>
