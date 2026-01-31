# 📚 Trilha SQL - Materiais de Aprendizado

## 🎯 Objetivo
Dominar os fundamentos do SQL através de aulas práticas e desafios progressivos.

---

## 📖 Módulos Disponíveis

### **Módulo 2 - Fundamentos SELECT**

Dominar os fundamentos da consulta de dados em SQL, aprendendo a selecionar, filtrar e organizar informações de forma eficiente.

📄 **[Acessar Módulo 2 - Fundamentos SELECT](modulo_2\doc_teorico.md)**

---

## 📚 Conteúdo do Módulo 2 - Índice de Aulas

<details>
<summary><strong>Aula 1: SELECT * - Sua Primeira Consulta SQL</strong></summary>

Aprenda o comando mais importante do SQL e como visualizar todos os dados de uma tabela.

**Conceitos:** SELECT, *, sintaxe básica, boas práticas

📄 [Ir para Aula 1](modulo_2\doc_teorico.md#aula-1)

</details>

<details>
<summary><strong>Aula 2: SELECT com Colunas Específicas</strong></summary>

Selecione apenas as colunas que você precisa para otimizar suas consultas.

**Conceitos:** Performance, especificidade, clareza

📄 [Ir para Aula 2](modulo_2\doc_teorico.md#aula-2)

</details>

<details>
<summary><strong>Aula 3: AS - Criando Aliases para Colunas</strong></summary>

Aprenda a renomear colunas para deixar seus resultados mais legíveis.

**Conceitos:** Aliases, AS, aspas, nomenclatura

📄 [Ir para Aula 3](modulo_2\doc_teorico.md#aula-3)

</details>

<details>
<summary><strong>Aula 4: DISTINCT - Removendo Duplicatas</strong></summary>

Descubra como obter apenas valores únicos em suas consultas.

**Conceitos:** DISTINCT, valores únicos, análise exploratória

📄 [Ir para Aula 4](modulo_2\doc_teorico.md#aula-4)

</details>

<details>
<summary><strong>Aula 5: LIMIT - Limitando Resultados</strong></summary>

Controle a quantidade de resultados retornados em suas queries.

**Conceitos:** LIMIT, amostragem, performance

📄 [Ir para Aula 5](modulo_2\doc_teorico.md#aula-5)

</details>

<details>
<summary><strong>Aula 6: WHERE - Filtrando com Igualdade</strong></summary>

Aprenda a filtrar dados usando o operador de igualdade.

**Conceitos:** WHERE, filtros, igualdade, tipos de dados

📄 [Ir para Aula 6](modulo_2\doc_teorico.md#aula-6)

</details>

<details>
<summary><strong>Aula 7: WHERE com Maior e Menor (>, <, >=, <=)</strong></summary>

Use operadores de comparação para filtrar valores numéricos e datas.

**Conceitos:** Operadores de comparação, filtros numéricos, datas

📄 [Ir para Aula 7](modulo_2\doc_teorico.md#aula-7)

</details>

<details>
<summary><strong>Aula 8: WHERE com Diferente (<> ou !=)</strong></summary>

Filtre valores que são diferentes de um valor específico.

**Conceitos:** Diferença, exclusão, NULL

📄 [Ir para Aula 8](modulo_2\doc_teorico.md#aula-8)

</details>

<details>
<summary><strong>Aula 9: AND - Combinando Condições</strong></summary>

Combine múltiplas condições que devem ser todas verdadeiras.

**Conceitos:** AND, lógica booleana, múltiplas condições

📄 [Ir para Aula 9](modulo_2\doc_teorico.md#aula-9)

</details>

<details>
<summary><strong>Aula 10: OR - Condições Alternativas</strong></summary>

Use OR quando pelo menos uma condição precisa ser verdadeira.

**Conceitos:** OR, lógica booleana, parênteses, IN

📄 [Ir para Aula 10](modulo_2\doc_teorico.md#aula-10)

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
4. **Avance** para o Módulo 3: Filtros Avançados!

---

## 📖 Como Usar Este Material

1. Estude uma aula por vez
2. Leia todos os conceitos com atenção
3. Pratique os desafios antes de avançar
4. Revise os conceitos quando necessário
5. Use o resumo para consultas rápidas

**Dica:** Cada aula tem seções expansíveis (clique para abrir/fechar) para facilitar a navegação!
