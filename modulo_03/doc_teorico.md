# Módulo 3 - Filtros Avançados - Material Didático

## 🎯 Objetivo do Módulo
Aprofundar nas técnicas de filtragem de dados, utilizando operadores avançados como NOT, IN, BETWEEN e LIKE para criar consultas mais precisas e poderosas.

---
# AULA 14

<details>
<summary><strong>Expandir Aula 14</strong></summary>

## NOT - Negando Condições

## 📝 O que é?
O operador `NOT` é usado para inverter o resultado de uma condição. Se uma condição é verdadeira, `NOT` a torna falsa, e vice-versa.

## 💡 Sintaxe
```sql
SELECT colunas FROM tabela WHERE NOT condição;
```

## 🎯 Desafio
<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 14 - Desafio 1: Mostrar todos os pedidos que NÃO foram cancelados.


-- Aula 14 - Desafio 2: Mostrar todos os pagamentos que NÃO foram feitos via 'boleto'.

```
</details>
</details>

---

# AULA 15

<details>
<summary><strong>Expandir Aula 15</strong></summary>

## IN - Filtrando por Lista de Valores

## 📝 O que é?
O operador `IN` permite filtrar resultados com base em uma lista de valores. É uma forma mais limpa e eficiente de escrever múltiplos `OR`.

## 💡 Sintaxe
```sql
SELECT colunas FROM tabela WHERE coluna IN (valor1, valor2, valor3);
```

## 🎯 Desafio
<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 15 - Desafio 1: Mostrar pedidos com status 'entregue' ou 'enviado'.


-- Aula 15 - Desafio 2: Mostrar pagamentos feitos com 'pix' ou 'cartao_credito'.

```
</details>
</details>

---

# AULA 16

<details>
<summary><strong>Expandir Aula 16</strong></summary>

## NOT IN - Excluindo Lista de Valores

## 📝 O que é?
O operador `NOT IN` é o oposto do `IN`. Ele exclui todos os valores presentes na lista.

## 💡 Sintaxe
```sql
SELECT colunas FROM tabela WHERE coluna NOT IN (valor1, valor2, valor3);
```

## 🎯 Desafio
<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 16 - Desafio 1: Mostrar avaliações que NÃO tenham nota 1 ou 5.


-- Aula 16 - Desafio 2: Mostrar pedidos com status que NÃO sejam "pendente" ou "confirmado"

```
</details>
</details>

---

# AULA 17

<details>
<summary><strong>Expandir Aula 17</strong></summary>

## BETWEEN - Filtrando por Intervalo

## 📝 O que é?
O operador `BETWEEN` é usado para selecionar valores dentro de um intervalo. É inclusivo, o que significa que os valores de início e fim estão incluídos.

## 💡 Sintaxe
```sql
SELECT colunas FROM tabela WHERE coluna BETWEEN valor1 AND valor2;
```

## 🎯 Desafio
<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 17 - Desafio 1: Mostrar pedidos com valor total entre R$ 500 e R$ 1500.


-- Aula 17 - Desafio 2: Mostrar pagamentos realizados no ano de 2025.

```
</details>
</details>

---

# AULA 18

<details>
<summary><strong>Expandir Aula 18</strong></summary>

## LIKE - Buscando Padrões de Texto

## 📝 O que é?
O operador `LIKE` é usado em uma cláusula `WHERE` para pesquisar um padrão especificado em uma coluna.

## 💡 Sintaxe
```sql
SELECT colunas FROM tabela WHERE coluna LIKE padrão;
```

## 🎯 Desafio
<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 18 - Desafio 1: Mostrar categorias cuja descrição contenha a palavra 'acessórios'.


-- Aula 18 - Desafio 2: Mostrar avaliações cujo comentário contenha a palavra "rápida".

```
</details>
</details>

---

# AULA 19

<details>
<summary><strong>Expandir Aula 19</strong></summary>

## LIKE com % e _ - Operadores Coringas

## 📝 O que é?
Os **wildcards** (caracteres curinga) são símbolos especiais usados junto com o operador `LIKE` para criar padrões de busca flexíveis em textos.

### O caractere `%` (porcentagem)
Representa **zero, um ou múltiplos caracteres** em qualquer posição.

| Padrão | Descrição | Exemplos que correspondem |
|--------|-----------|---------------------------|
| `'Ana%'` | Começa com "Ana" | Ana, Anabel, Anastacia |
| `'%silva'` | Termina com "silva" | Silva, Da Silva, José silva |
| `'%art%'` | Contém "art" em qualquer lugar | Artigo, Cartão,Epartida |

### O caractere `_` (underline)
Representa **exatamente um único caractere** na posição especificada.

| Padrão | Descrição | Exemplos que correspondem |
|--------|-----------|---------------------------|
| `'_asa'` | 4 letras, terminando em "asa" | Casa, Masa, Rasa |
| `'A__a'` | 4 letras, começando com "A" e terminando com "a" | Ana, Aula, Área |
| `'___'` | Exatamente 3 caracteres | São, Rio, Abc |

## 💡 Sintaxe
```sql
SELECT colunas FROM tabela WHERE coluna LIKE 'padrão%';
SELECT colunas FROM tabela WHERE coluna LIKE '_adrão';
SELECT colunas FROM tabela WHERE coluna LIKE '%texto%';
```

## 🎯 Desafio
<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 19 - Desafio 1: Mostrar todos os métodos de pagamento que comecem com 'cartao'.


-- Aula 19 - Desafio 2: Mostrar os status de pedido que terminem com a letra 'o'.

```
</details>
</details>

---

