# Módulo 01 - Introdução - Configurando o Ambiente

## Objetivo do Módulo
Preparar todo o ambiente necessário para iniciar os estudos de SQL: criar banco de dados PostgreSQL na nuvem (Render), instalar ferramenta de gerenciamento (DBeaver) e popular o banco com dados do e-commerce.

---

## 📋 Visão Geral

Neste módulo você vai:
1. ✅ Criar conta gratuita no Render
2. ✅ Provisionar banco PostgreSQL na nuvem
3. ✅ Instalar DBeaver Community (cliente SQL)
4. ✅ Conectar ao banco de dados
5. ✅ Popular o banco com dados do e-commerce

**Tempo estimado:** 30-40 minutos

---

# PASSO 1: Criar Conta no Render

<details>
<summary><strong>Expandir Passo 1</strong></summary>

## O que é o Render?

O **Render** é uma plataforma de nuvem que oferece hospedagem gratuita de bancos de dados PostgreSQL. É perfeito para estudos e projetos pessoais.

## Vantagens
- ✅ Gratuito (plano free tier)
- ✅ Não precisa de cartão de crédito
- ✅ PostgreSQL atualizado
- ✅ Acesso de qualquer lugar
- ✅ Fácil de configurar

## Passo a Passo

### 1.1 Acessar o site

Acesse: [https://render.com](https://render.com)

### 1.2 Criar conta

1. Clique em **"Get Started"** ou **"Sign Up"**
2. Escolha uma das opções:
   - **GitHub** (recomendado - mais rápido)
   - **GitLab**
   - **Email** (preencher formulário)

### 1.3 Confirmar email

Se você escolheu criar com email:
1. Verifique sua caixa de entrada
2. Clique no link de confirmação
3. Faça login

### 1.4 Completar perfil

1. Informe seu nome
2. (Opcional) Adicione informações adicionais
3. Clique em **"Continue"**

**✅ Pronto! Sua conta está criada.**

</details>

---

# PASSO 2: Criar Banco PostgreSQL

<details>
<summary><strong>Expandir Passo 2</strong></summary>

## Criando seu Banco de Dados

### 2.1 Acessar Dashboard

1. Faça login no Render
2. Você verá o **Dashboard** principal

### 2.2 Criar novo PostgreSQL

1. Clique em **"New +"** (canto superior direito)
2. Selecione **"PostgreSQL"**

### 2.3 Configurar o banco

Preencha as informações:

| Campo | Valor Sugerido | Descrição |
|-------|----------------|-----------|
| **Name** | `trilha-sql-ecommerce` | Nome do banco |
| **Database** | `ecommerce` | Nome do schema |
| **User** | `admin_sql` | Usuário |
| **Region** | `Oregon (US West)` ou mais próximo | Região do servidor |
| **PostgreSQL Version** | `16` (mais recente) | Versão |
| **Plan** | **Free** | Plano gratuito |

### 2.4 Criar banco

1. Clique em **"Create Database"**
2. Aguarde 2-5 minutos (provisionamento)
3. Quando o status mudar para **"Available"**, está pronto!

### 2.5 Obter credenciais de conexão

Após criado, você verá as informações de conexão:

```
Hostname: dpg-xxxxx.oregon-postgres.render.com
Port: 5432
Database: ecommerce
Username: admin_sql
Password: xxxxxxxxxx (gerado automaticamente)
```

⚠️ **IMPORTANTE:** Salve essas credenciais! Você vai precisar delas.

### 2.6 Copiar Connection String

Role até encontrar **"External Database URL"** ou **"PSQL Command"**:

```bash
postgresql://admin_sql:senha@dpg-xxxxx.oregon-postgres.render.com/ecommerce
```

Copie e salve em um arquivo de texto por enquanto.

**✅ Banco PostgreSQL criado e rodando na nuvem!**

</details>

---

# PASSO 3: Instalar DBeaver Community

<details>
<summary><strong>Expandir Passo 3</strong></summary>

## O que é o DBeaver?

**DBeaver** é um cliente SQL gratuito e open-source. É a ferramenta que usaremos para:
- Conectar ao banco de dados
- Escrever e executar queries SQL
- Visualizar dados
- Gerenciar tabelas

## Alternativas

Você pode usar outras ferramentas se preferir:
- **pgAdmin** (específico para PostgreSQL)
- **DataGrip** (pago, da JetBrains)
- **VSCode** + extensão PostgreSQL
- **Terminal** com `psql`

## Passo a Passo

### 3.1 Baixar DBeaver

1. Acesse: [https://dbeaver.io/download/](https://dbeaver.io/download/)
2. Clique em **"Download"** na versão **Community Edition** (gratuita)
3. Escolha seu sistema operacional:
   - **Windows** → `.exe`
   - **macOS** → `.dmg`
   - **Linux** → `.deb` ou `.rpm`

### 3.2 Instalar

**Windows:**
1. Execute o arquivo `.exe`
2. Clique em "Next" → "Next" → "Install"
3. Aguarde a instalação
4. Clique em "Finish"

**macOS:**
1. Abra o arquivo `.dmg`
2. Arraste o DBeaver para a pasta "Applications"
3. Abra o DBeaver pela primeira vez (pode pedir permissão)

**Linux (Ubuntu/Debian):**
```bash
sudo dpkg -i dbeaver-ce_*.deb
sudo apt-get install -f
```

### 3.3 Primeira execução

1. Abra o DBeaver
2. Na primeira vez, pode aparecer um assistente de configuração
3. Clique em "Skip" ou "Close" nas telas iniciais
4. Você verá a interface principal

**✅ DBeaver instalado com sucesso!**

</details>

---

# PASSO 4: Conectar ao Banco de Dados

<details>
<summary><strong>Expandir Passo 4</strong></summary>

## Criando a Conexão

### 4.1 Nova Conexão

1. No DBeaver, clique em **"Database"** → **"New Database Connection"**
   - Ou clique no ícone de **plug (🔌)** na barra de ferramentas
   - Ou use `Ctrl + Shift + N` (Windows/Linux) ou `Cmd + Shift + N` (macOS)

### 4.2 Selecionar PostgreSQL

1. Na janela "Connect to a database":
2. Digite "postgres" na busca
3. Selecione **"PostgreSQL"**
4. Clique em **"Next"**

### 4.3 Configurar Conexão

Preencha com as credenciais do Render:

| Campo | Valor |
|-------|-------|
| **Host** | `dpg-xxxxx.oregon-postgres.render.com` |
| **Port** | `5432` |
| **Database** | `ecommerce` |
| **Username** | `admin_sql` |
| **Password** | A senha gerada pelo Render |

⚠️ **Marque:** ☑️ "Save password"

### 4.4 Testar Conexão

1. Clique em **"Test Connection"** (canto inferior esquerdo)
2. Se aparecer "Connected", está tudo certo! ✅
3. Se der erro:
   - Verifique se copiou as credenciais corretamente
   - Confirme se o banco está "Available" no Render
   - Verifique sua conexão com a internet

### 4.5 Finalizar

1. (Opcional) Dê um nome melhor para a conexão no campo **"Connection name"**:
   - Sugestão: `Render - E-commerce`
2. Clique em **"Finish"**

### 4.6 Navegar no Banco

No painel esquerdo (Database Navigator), você verá:

```
📁 Render - E-commerce
  └─ 📁 Databases
      └─ 📁 ecommerce
          ├─ 📁 Schemas
          │   └─ 📁 public
          │       ├─ 📁 Tables (vazio ainda)
          │       ├─ 📁 Views
          │       └─ ...
```

**✅ Conectado ao banco PostgreSQL na nuvem!**

</details>

---

# PASSO 5: Popular o Banco com Dados

<details>
<summary><strong>Expandir Passo 5</strong></summary>

## Inserindo o Dataset do E-commerce

Agora vamos criar as tabelas e inserir os dados que usaremos durante toda a trilha.

### 5.1 Obter o Script SQL

Você precisará do arquivo **`dados_ecommerce.sql`** que contém:
- Criação das 7 tabelas (categorias, produtos, clientes, pedidos, itens_pedido, pagamentos, avaliacoes)
- Inserção de dados de exemplo

**Onde encontrar:**
- 📁 Pasta `Database/dados_ecommerce.sql` deste repositório
- Ou obtenha com o instrutor/professor

### 5.2 Abrir Script no DBeaver

**Opção 1 - Arrastar arquivo:**
1. Localize o arquivo `dados_ecommerce.sql` no seu computador
2. Arraste e solte na área de trabalho do DBeaver

**Opção 2 - Menu:**
1. No DBeaver, clique em **"SQL Editor"** → **"Open SQL Script"**
2. Navegue até o arquivo `dados_ecommerce.sql`
3. Clique em **"Open"**

### 5.3 Selecionar Banco Correto

⚠️ **IMPORTANTE:**
1. Na barra superior do editor SQL, verifique se está selecionado:
   - **Database:** `ecommerce`
   - **Schema:** `public`

### 5.4 Executar o Script

1. Selecione TODO o conteúdo do script (Ctrl+A / Cmd+A)
2. Execute de uma das formas:
   - Clique no botão **"Execute SQL Statement"** (ícone ▶️)
   - Pressione `Ctrl + Enter` (Windows/Linux) ou `Cmd + Return` (macOS)
   - Menu: **"SQL Editor"** → **"Execute SQL Script"**

### 5.5 Aguardar Execução

Você verá:
- ✅ Mensagens de sucesso no painel inferior
- ✅ "Query executed successfully"
- ✅ Estatísticas (linhas inseridas, tempo)

**Exemplo de saída:**
```
CREATE TABLE - categorias
INSERT 0 10 - 10 categorias inseridas
CREATE TABLE - produtos
INSERT 0 50 - 50 produtos inseridos
...
```

### 5.6 Verificar Tabelas Criadas

1. No **Database Navigator** (painel esquerdo)
2. Expanda: `ecommerce → Schemas → public → Tables`
3. Você deve ver as 7 tabelas:
   - ✅ categorias
   - ✅ produtos
   - ✅ clientes
   - ✅ pedidos
   - ✅ itens_pedido
   - ✅ pagamentos
   - ✅ avaliacoes

### 5.7 Verificar Dados

Vamos testar se os dados foram inseridos:

1. Abra um novo **SQL Editor**: `Ctrl + ]` ou clique em **"SQL Editor"** → **"New SQL Editor"**
2. Digite a seguinte query:

```sql
-- Contar registros em cada tabela
SELECT 'categorias' AS tabela, COUNT(*) AS registros FROM categorias
UNION ALL
SELECT 'produtos', COUNT(*) FROM produtos
UNION ALL
SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL
SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL
SELECT 'itens_pedido', COUNT(*) FROM itens_pedido
UNION ALL
SELECT 'pagamentos', COUNT(*) FROM pagamentos
UNION ALL
SELECT 'avaliacoes', COUNT(*) FROM avaliacoes;
```

3. Execute a query (Ctrl+Enter / Cmd+Return)
4. Você deve ver uma tabela com a contagem de registros em cada tabela

**Resultado esperado:**
```
categorias     | 10
produtos       | 50
clientes       | 100
pedidos        | 200
itens_pedido   | 350
pagamentos     | 200
avaliacoes     | 120
```

### 5.8 Testar com Query Simples

Vamos ver alguns produtos:

```sql
SELECT * FROM produtos
LIMIT 5;
```

Você deve ver 5 produtos com informações como nome, preço, estoque, marca, etc.

**✅ Banco populado com sucesso! Pronto para aprender SQL!**

</details>

---

## 🎉 Parabéns!

Você concluiu a configuração do ambiente! Agora você tem:

- ✅ Banco PostgreSQL rodando na nuvem (Render)
- ✅ DBeaver instalado e configurado
- ✅ Conexão ativa com o banco
- ✅ Dataset do e-commerce carregado
- ✅ Ambiente pronto para os próximos módulos

---

## 🔧 Troubleshooting (Problemas Comuns)

### ❌ Erro: "Connection refused" ou "Timeout"

**Possíveis causas:**
- Firewall bloqueando a porta 5432
- Credenciais incorretas
- Banco ainda não está "Available" no Render

**Solução:**
1. Verifique no Dashboard do Render se o status está "Available"
2. Confirme se copiou as credenciais corretamente
3. Tente desativar temporariamente o firewall/antivírus
4. Aguarde alguns minutos e tente novamente

### ❌ Erro: "Password authentication failed"

**Solução:**
1. Copie novamente a senha no Render Dashboard
2. Certifique-se de não ter espaços extras
3. Se necessário, resete a senha no Render:
   - Dashboard → PostgreSQL → Settings → Reset Password

### ❌ Erro: "SSL connection required"

**Solução no DBeaver:**
1. Edite a conexão (botão direito → Edit Connection)
2. Vá na aba **"Driver Properties"**
3. Procure por `ssl` e altere para `true`
4. Ou na aba **"PostgreSQL"**, marque "Use SSL"

### ❌ Script SQL falha com erros

**Solução:**
1. Verifique se o banco está vazio (se já rodou antes, pode ter conflito)
2. Para limpar e recomeçar:
```sql
DROP TABLE IF EXISTS avaliacoes CASCADE;
DROP TABLE IF EXISTS pagamentos CASCADE;
DROP TABLE IF EXISTS itens_pedido CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;
DROP TABLE IF EXISTS produtos CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;
```
3. Execute o script `dados_ecommerce.sql` novamente

---

## 📚 Recursos Adicionais

### Documentação Oficial
- [Render PostgreSQL Docs](https://render.com/docs/databases)
- [DBeaver Documentation](https://dbeaver.com/docs/)
- [PostgreSQL Official Docs](https://www.postgresql.org/docs/)

### Tutoriais em Vídeo (YouTube)
- "Como criar banco PostgreSQL no Render"
- "DBeaver Tutorial para iniciantes"
- "PostgreSQL Setup Guide"

### Comunidades
- [Stack Overflow - PostgreSQL](https://stackoverflow.com/questions/tagged/postgresql)
- [Reddit - r/PostgreSQL](https://reddit.com/r/PostgreSQL)
- [DBeaver Community Forum](https://github.com/dbeaver/dbeaver/discussions)

---

## ✅ Checklist Final

Antes de avançar para o Módulo 02, confirme:

- [ ] Conta no Render criada e verificada
- [ ] Banco PostgreSQL criado e status "Available"
- [ ] Credenciais de conexão salvas
- [ ] DBeaver Community instalado
- [ ] Conexão com banco funcionando (teste passou)
- [ ] Script `dados_ecommerce.sql` executado sem erros
- [ ] As 7 tabelas criadas e visíveis no Database Navigator
- [ ] Consegui executar um SELECT simples e ver dados

---

## 🚀 Próximo Módulo

Agora que seu ambiente está pronto, no **Módulo 02 - Fundamentos SELECT** você aprenderá:
- Como fazer suas primeiras consultas SQL
- SELECT, FROM, ORDER BY, LIMIT
- Filtrar e ordenar dados
- Trabalhar com colunas e alias

**Vamos começar a jornada SQL! 💪**

---

## 📝 Anotações Pessoais

Use o espaço abaixo para anotar suas credenciais e observações:

```
===========================================
MINHAS CREDENCIAIS - RENDER
===========================================

Database Name: _______________________
Hostname: ____________________________
Port: 5432
Username: ____________________________
Password: ____________________________

External URL:
postgresql://________________________

===========================================
OBSERVAÇÕES
===========================================

Data de criação: ___/___/______

Notas:
_________________________________________
_________________________________________
_________________________________________
```

---

## Como Usar Este Material

1. Siga os passos na ordem apresentada
2. Não pule etapas
3. Teste cada conexão antes de avançar
4. Anote suas credenciais de forma segura
5. Use o troubleshooting se encontrar problemas
6. Só avance para o Módulo 02 quando tudo estiver funcionando
