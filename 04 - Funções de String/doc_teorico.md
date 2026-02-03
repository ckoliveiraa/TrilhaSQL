# Módulo 3 - Funções de String - Material Didático

## Objetivo do Módulo
Dominar as principais funções de manipulação de texto em SQL para limpar, formatar e extrair informações de strings.

---
# AULA 18

<details>
<summary><strong>Expandir Aula 18</strong></summary>

## CONCAT - Concatenando Textos

## O que é?

A função `CONCAT` une duas ou mais strings em uma única string.

## Sintaxe

```sql
-- Sintaxe padrão
SELECT CONCAT(string1, string2, ...) AS nova_string FROM tabela;

-- Operador de concatenação (padrão SQL)
SELECT string1 || string2 AS nova_string FROM tabela;
```

## Dica

Você pode concatenar strings literais (texto fixo) com colunas.

**Exemplo:**
```sql
-- Criando uma frase descritiva
SELECT CONCAT(nome, ' custa R$ ', preco) AS descricao_preco FROM produtos;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 18 - Desafio 1: Crie uma coluna com "Nome - Marca" para produtos
-- Exiba o nome do produto, a marca e a nova coluna concatenada.


-- Aula 18 - Desafio 2: Crie o endereço completo dos clientes
-- Concatene cidade, estado e CEP em uma única coluna chamada "Endereço Completo". Ex: "São Paulo - SP, 01000-000"


```

</details>

</details>

---

# AULA 19

<details>
<summary><strong>Expandir Aula 19</strong></summary>

## UPPER - Convertendo para Maiúsculas

## O que é?

A função `UPPER` converte todos os caracteres de uma string para maiúsculas.

## Sintaxe

```sql
SELECT UPPER(coluna_texto) AS texto_maiusculo FROM tabela;
```

## Quando usar?

- Para padronizar dados para comparação.
- Para formatar relatórios onde a caixa alta é necessária.
- Para garantir que a busca por texto não seja sensível a maiúsculas/minúsculas em alguns bancos de dados.

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 19 - Desafio 1: Mostrar todos os nomes de produtos em maiúsculas
-- Exiba o nome original e o nome em maiúsculas para comparação.


-- Aula 19 - Desafio 2: Mostrar nomes de clientes em maiúsculas
-- Crie um relatório com os nomes de todos os clientes em caixa alta.

```

</details>

</details>

---

# AULA 20

<details>
<summary><strong>Expandir Aula 20</strong></summary>

## LOWER - Convertendo para Minúsculas

## O que é?

A função `LOWER` converte todos os caracteres de uma string para minúsculas.

## Sintaxe

```sql
SELECT LOWER(coluna_texto) AS texto_minusculo FROM tabela;
```

## Quando usar?

- É muito comum para padronizar e-mails ou nomes de usuário antes de salvar no banco ou realizar buscas.
- Para garantir consistência nos dados.

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 20 - Desafio 1: Mostrar todos os emails dos clientes em minúsculas
-- Ideal para criar uma lista de marketing padronizada.


-- Aula 20 - Desafio 2: Padronizar nomes de categorias em minúsculas
-- Exiba os nomes das categorias em sua forma original e em minúsculas.

```

</details>

</details>

---

# AULA 21

<details>
<summary><strong>Expandir Aula 21</strong></summary>

## SUBSTRING - Extraindo Parte do Texto

## O que é?

A função `SUBSTRING` (ou `SUBSTR` em alguns bancos) extrai uma parte de uma string.

## Sintaxe

```sql
-- Extrai a partir da posição inicial até o fim
SELECT SUBSTRING(coluna FROM posicao_inicial) FROM tabela;

-- Extrai um número específico de caracteres a partir da posição inicial
SELECT SUBSTRING(coluna FROM posicao_inicial FOR quantidade_caracteres) FROM tabela;
```

## Dica

A posição inicial começa em `1`.

**Exemplo:**
```sql
-- Extrair os 3 primeiros caracteres de um CEP
SELECT SUBSTRING(cep FROM 1 FOR 3) FROM clientes;
```

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 21 - Desafio 1: Extrair apenas o primeiro nome dos clientes
-- Dica: Use a função POSITION(' ' IN nome) para encontrar o primeiro espaço.


-- Aula 21 - Desafio 2: Extrair o DDD dos telefones dos clientes
-- Considere que os telefones podem ter formatos diferentes, como '(XX) YYYYY-ZZZZ' ou 'XX YYYYY ZZZZ'.


```

</details>

</details>

---

# AULA 22

<details>
<summary><strong>Expandir Aula 22</strong></summary>

## TRIM - Removendo Espaços

## O que é?

A função `TRIM` remove espaços (ou outros caracteres) do início, do fim ou de ambos os lados de uma string.

## Sintaxe

```sql
-- Remove espaços do início e do fim
SELECT TRIM(coluna) FROM tabela;

-- Remove espaços do início (leading)
SELECT LTRIM(coluna) FROM tabela; -- Ou TRIM(LEADING ' ' FROM coluna)

-- Remove espaços do fim (trailing)
SELECT RTRIM(coluna) FROM tabela; -- Ou TRIM(TRAILING ' ' FROM coluna)
```

## Quando usar?

- Essencial para limpar dados inseridos por usuários, que frequentemente contêm espaços extras.
- Antes de realizar comparações de texto para evitar erros.

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 22 - Desafio 1: Limpar espaços extras nos nomes de produtos
-- Suponha que alguns produtos foram cadastrados com espaços no início ou fim do nome. Mostre o nome original e o nome limpo.


-- Aula 22 - Desafio 2: Remover espaços de emails antes de comparar
-- Encontre clientes cujo email, após a limpeza de espaços, seja 'exemplo@email.com'.


```

</details>

</details>

---

# AULA 23

<details>
<summary><strong>Expandir Aula 23</strong></summary>

## LENGTH - Contando Caracteres

## O que é?

A função `LENGTH` (ou `LEN` em alguns bancos) retorna o número de caracteres em uma string.

## Sintaxe

```sql
SELECT LENGTH(coluna_texto) AS quantidade_caracteres FROM tabela;
```

## Quando usar?

- Para validar o tamanho de campos, como CPF, CNPJ, senhas, etc.
- Para encontrar dados que não seguem um padrão de tamanho.
- Para análises de texto, como o tamanho médio de comentários.

## Desafio

<details>
<summary><strong>Ver Desafios</strong></summary>

```sql
-- Aula 23 - Desafio 1: Mostrar produtos cujo nome tenha mais de 20 caracteres
-- Exiba o nome do produto e o seu comprimento.


-- Aula 23 - Desafio 2: Validar CPFs que não tenham exatamente 14 caracteres (incluindo pontos e traço)
-- Liste os clientes com CPFs de tamanho inválido.


```

</details>

</details>

---

## Desafio Final do Módulo 3

<details>
<summary><strong>Expandir Desafio Final</strong></summary>

Parabéns! Use suas novas habilidades com strings para resolver estes desafios.

### Desafios

```sql
-- Desafio Final 1: Relatório de Contato Padronizado
-- Crie um relatório para a equipe de marketing que contenha:
-- - O nome completo do cliente em maiúsculas.
-- - O email do cliente em minúsculas.
-- - Uma coluna "Localização" formatada como "Cidade (UF)". Ex: "São Paulo (SP)".


-- Desafio Final 2: Análise de Marcas
-- Encontre todas as marcas únicas de produtos.
-- Exiba o nome da marca em maiúsculas e o número de caracteres do nome da marca.
-- Ordene pelo nome da marca.


-- Desafio Final 3: Nomes Curtos de Produtos
-- Liste todos os produtos cujos nomes (sem espaços no início ou fim) tenham 10 caracteres ou menos.
-- Exiba o nome e o comprimento do nome.


-- Desafio Final 4: (Avançado) Gerador de Nome de Usuário
-- Crie uma sugestão de nome de usuário para cada cliente.
-- O nome de usuário deve ser:
-- - As 3 primeiras letras do primeiro nome (em minúsculas).
-- - Concatenado com o comprimento total do nome completo.
-- - Exemplo: Para "Ana Clara", o resultado seria "ana8".
-- Dica: Você precisará combinar SUBSTRING, LOWER, LENGTH e CONCAT.

```

</details>