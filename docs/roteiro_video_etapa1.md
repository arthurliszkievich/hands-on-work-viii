# 🎙️ STUDIO PROMPTER — Roteiro de Gravação (Etapa 1)
### 📓 Caderneta Digital de Fiado — HOW VIII (UNIVALI)
> **Apresentador:** Arthur Rocha Laszlo Liszkievich (narrando pelo grupo)  
> **Duração Total da Fala:** ~2 minutos e 55 segundos (Teto regulamentar: 3 minutos)  
> **Contagem de Palavras:** 376 palavras (~130 palavras/minuto — ritmo pausado e firme)  
> **Data Limite da Etapa 1:** 25/10/2026 às 23:59  

---

## 🎛️ Cockpit de Preparação (Antes de Apertar o REC)

| Janela / Aba | O que deixar aberto | Atalho / Preparação |
| :--- | :--- | :--- |
| **Aba 1 (VS Code)** | [`README.md`](file:///home/arthur/projetos/HOW%20VIII/README.md) aberto no topo (visíveis os badges) e arquivos de domínio em split screen. | Fonte nítida (`Ctrl` + `+`) |
| **Aba 2 (Terminal)** | Terminal integrado do VS Code ou Kitty/GNOME Terminal maximizado. | Prompt limpo com comandos prontos no histórico |
| **Aba 3 (Navegador)** | Página do GitHub Actions com o check verde ✅: `https://github.com/arthurliszkievich/hands-on-work-viii/actions` | Deixar na aba pronta |
| **Aba 4 (ClickUp)** | Quadro Scrum da Sprint 1 do grupo no ClickUp (ou tabela no README). | Zoom ajustado |

---

## 🎬 Cartões de Gravação — Segundo a Segundo

```
================================================================================
⏱️ BLOCO 1 | 0:00 - 0:20 (Duração: 20s | Ritmo: 44 palavras)
📌 TEMA: ABERTURA & APRESENTAÇÃO DA EQUIPE
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA:**
  * Abra o [`README.md`](file:///home/arthur/projetos/HOW%20VIII/README.md) no topo. Destaque com o cursor o título **"Caderneta Digital de Fiado"** e os badges de **CI**, **TDD** e **Coverage 93.4%**.
* **🗣️ FALA NO TELEPROMPTER (Leia com entusiasmo e segurança de Tech Lead):**
  > "Olá! Sou o **Arthur** e apresento os resultados da **Etapa 1** do Hands on Work VIII da UNIVALI, desenvolvido em grupo com **Matheus, Alifer, Fátima, Evy e Aghata**."  
  > *[PAUSA: 1s]*  
  > "Nosso projeto é a **Caderneta Digital de Fiado**, um app mobile em Flutter que substitui com segurança o caderno de papel dos pequenos comerciantes."
* **💡 DICA DE GRAVAÇÃO:** Olhe para a câmera no primeiro segundo antes de compartilhar a tela. Mostre confiança!

---

```
================================================================================
⏱️ BLOCO 2 | 0:20 - 0:45 (Duração: 25s | Ritmo: 54 palavras)
📌 TEMA: A DOR DA COMUNIDADE & O PROBLEMA REAL
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA:**
  * No [`README.md`](file:///home/arthur/projetos/HOW%20VIII/README.md#L14-L21), role suavemente até a seção **"🎯 Contexto do Projeto e Dor da Comunidade"**. Aponte os 3 tópicos de dor (folhas soltas, erros de cálculo e ausência de travas).
* **🗣️ FALA NO TELEPROMPTER (Tom empático e explicativo):**
  > "Mercearias, padarias e feirantes usam o fiado como **ferramenta de fidelização**, mas o papel gera descontrole: as folhas se perdem, a soma manual induz ao erro e não há limites de crédito, causando **dívidas impagáveis**."  
  > *[PAUSA: 1s]*  
  > "A validação prática com comerciantes reais, liderada pela **Alifer**, é o foco da nossa **Sprint 2**."
* **💡 DICA DE GRAVAÇÃO:** Dê ênfase na palavra *"dívidas impagáveis"*. É a dor central que o software resolve.

---

```
================================================================================
⏱️ BLOCO 3 | 0:45 - 1:20 (Duração: 35s | Ritmo: 61 palavras)
📌 TEMA: CLEAN ARCHITECTURE & REGRAS BLINDADAS NO DOMÍNIO
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA:**
  * VS Code dividido em 2 colunas:
    * Coluna Esquerda: [`customer.dart`](file:///home/arthur/projetos/HOW%20VIII/lib/domain/entities/customer.dart) (destaque os campos `currentDebt` e `creditLimit`).
    * Coluna Direita: [`record_purchase.dart`](file:///home/arthur/projetos/HOW%20VIII/lib/domain/usecases/record_purchase.dart) e [`process_payment.dart`](file:///home/arthur/projetos/HOW%20VIII/lib/domain/usecases/process_payment.dart).
  * Aponte na árvore de pastas que `lib/domain/` é **Dart puro**, sem nenhuma dependência do Flutter ou UI.
* **🗣️ FALA NO TELEPROMPTER (Tom técnico e analítico):**
  > "Adotamos **Clean Architecture**, isolando a regra contábil no domínio, em **Dart puro**, sem emulador ou dependência da interface."  
  > *[PAUSA: 1s]*  
  > "São três regras centrais: cadastro do cliente com **saldo inicial zero**, compra fiada com **trava automática de limite de crédito**, e baixa de pagamento que abate a dívida **sem permitir saldo negativo**. A interface gráfica atual é apenas um esqueleto."
* **💡 DICA DE GRAVAÇÃO:** Mostre a linha da trava no código onde lança `CreditLimitExceededFailure`. Professores adoram ver exceções de domínio explícitas!

---

```
================================================================================
⏱️ BLOCO 4 | 1:20 - 1:55 (Duração: 35s | Ritmo: 65 palavras)
📌 TEMA: TDD NA PRÁTICA & AUDITORIA DO HISTÓRICO GIT
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA:**
  * Mude para o **Terminal** e execute:
    ```bash
    git log --oneline --reverse
    ```
  * Destaque com o mouse a alternância de tags:
    * `[RED]` -> `[GREEN]` -> `[REFACTOR]` para a Regra 1 e Regra 2.
    * Os commits do **Matheus** (`[RED]` e `[GREEN]`) na Regra 3 via PR #1.
* **🗣️ FALA NO TELEPROMPTER (Tom afirmativo e disciplinado):**
  > "Cada regra seguiu rigorosamente o ciclo **Red-Green-Refactor** do TDD: primeiro o commit do teste unitário falhando, depois o código mínimo para passar e, por fim, a refatoração."  
  > *[PAUSA: 1s]*  
  > "O histórico do Git comprova essa ordem cronológica. Eu construí a arquitetura e as regras um e dois; o **Matheus** implementou a regra três de pagamento e a camada de dados em memória."
* **💡 DICA DE GRAVAÇÃO:** Se quiser demonstrar a divisão de autoria, rode rapidamente `git shortlog -sn` (mostrará Arthur: 23 commits e Matheus Yan: 5 commits).

---

```
================================================================================
⏱️ BLOCO 5 | 1:55 - 2:20 (Duração: 25s | Ritmo: 57 palavras)
📌 TEMA: BATERIA DE TESTES (100% GREEN) & CI NO GITHUB ACTIONS
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA:**
  1. No terminal, execute:
     ```bash
     flutter test --coverage
     ```
     *(Aguarde os segundos finais e aponte para: "All tests passed! (13 passed)")*
  2. Dê `Alt` + `Tab` para o navegador na aba **Actions** do GitHub, mostrando o pipeline **Flutter CI/CD Pipeline** com check verde ✅.
* **🗣️ FALA NO TELEPROMPTER (Tom enérgico e comprobatório):**
  > "Rodando `flutter test`, os **13 testes unitários passam com sucesso**. A cobertura alcança **93,4%** na camada de domínio e **100% nos casos de uso**."  
  > *[PAUSA: 1s]*  
  > "No GitHub Actions, a cada push, a esteira de Integração Contínua roda a análise estática com `flutter analyze` e executa todos os testes com extração do relatório LCOV."
* **💡 DICA DE GRAVAÇÃO:** Esse é o clímax técnico da apresentação! Mostre os 13 testes passando sem cortes.

---

```
================================================================================
⏱️ BLOCO 6 | 2:20 - 2:40 (Duração: 20s | Ritmo: 47 palavras)
📌 TEMA: SCRUM NO CLICKUP & GESTÃO DO TIME
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA:**
  * Navegador com a aba do **ClickUp** aberta exibindo o quadro da **Sprint 1** (ou a tabela de **Equipe do Projeto** no [`README.md`](file:///home/arthur/projetos/HOW%20VIII/README.md#L45-L54)).
* **🗣️ FALA NO TELEPROMPTER (Tom colaborativo de equipe):**
  > "O Scrum foi estruturado no ClickUp pela **Fátima**, com backlog e sprints definidas. A **Sprint 1**, de 12 a 25 de outubro, concluiu as metas centrais: arquitetura limpa, as três regras de domínio, testes e CI. A **Aghata** atuou na consolidação das informações do relatório acadêmico."
* **💡 DICA DE GRAVAÇÃO:** Mostre que o grupo não é apenas código, mas possui processo ágil estruturado e papéis distribuídos.

---

```
================================================================================
⏱️ BLOCO 7 | 2:40 - 2:55 (Duração: 15s | Ritmo: 48 palavras)
📌 TEMA: SPRINT 2 (PRÓXIMOS PASSOS) & ENCERRAMENTO
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA:**
  * Terminal rodando a demonstração interativa:
    ```bash
    dart run tool/demo_runner.dart
    ```
  * O script executará o cadastro da Dona Maria, compras e a **🛡️ TRAVA AUTOMÁTICA DISPARADA COM SUCESSO!**
* **🗣️ FALA NO TELEPROMPTER (Tom conclusivo e profissional):**
  > "Na **Sprint 2**, de 26 de outubro a 8 de novembro, entraremos na interface do usuário para o comerciante, persistência em banco local, testes de integração e validação em campo com pequenos varejistas."  
  > *[PAUSA: 1s]*  
  > "O repositório oficial está disponível no GitHub com todas as evidências. Muito obrigado!"
* **💡 DICA DE GRAVAÇÃO:** Termine o vídeo sorrindo ou com aceno curto. Dá sensação de entrega completa e profissional!

---

## ⚡ Cheat Sheet: Comandos Rápidos do Terminal
Copie e cole na ordem durante o vídeo:

```bash
# 1. Auditoria do TDD
git log --oneline --reverse

# 2. Resumo de contribuições da equipe
git shortlog -sn

# 3. Execução dos testes e cobertura
flutter test --coverage

# 4. Demonstração prática das regras e trava de limite
dart run tool/demo_runner.dart
```

---

## 🧭 Plano de Contingência (E se eu errar uma fala?)
* **Não precisa reiniciar do zero:** Faça uma pausa em silêncio de **3 segundos**, respire, e retome a frase do início daquele bloco. Na edição, o corte fica invisível na onda sonora.
* **Se o comando demorar para rodar:** Preencha o silêncio comentando: *"Como vocês podem ver, o compilador do Dart executa a suite de testes de forma determinística..."*
