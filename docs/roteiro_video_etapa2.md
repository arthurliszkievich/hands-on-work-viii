# 🎙️ STUDIO PROMPTER — Roteiro de Gravação (Etapa 2)
### 📱 Caderneta Digital de Fiado — Aplicação Mobile, Testes & Validação (HOW VIII)
> **Apresentador:** Arthur Rocha Laszlo Liszkievich (narrando pelo grupo)  
> **Duração Total da Fala:** ~2 minutos e 45 segundos (Teto regulamentar: 3 minutos)  
> **Contagem de Palavras:** ~355 palavras (~130 palavras/minuto — ritmo firme e natural)  
> **Itens do Relatório Cobertos:** `5.1.1` Aplicação Mobile, `5.1.2` Testes, `5.1.3` Validação, `5.1.4` Ciclo TDD e `7.2` Vídeo Etapa 2

---

## 🎛️ Cockpit de Preparação (Antes de Apertar o REC)

| Janela / Aba | O que deixar aberto | Preparação |
| :--- | :--- | :--- |
| **Janela 1 (Chrome — App)** | App rodando em `http://localhost:8080` via `flutter run -d web-server --web-port=8080` | Dê `F5` antes de gravar para garantir os 3 clientes iniciais limpos (`R$ 335,50` no topo) |
| **Janela 2 (Chrome — Teleprompter)** | [teleprompter_etapa2.html](file:///home/arthur/projetos/HOW%20VIII/docs/teleprompter_etapa2.html) posicionado próximo à webcam | Fonte ajustada e timer pronto |
| **Janela 3 (IDE + Terminal)** | Terminal maximizado pronto para rodar `flutter analyze && flutter test` | Deixar [home_page_widget_test.dart](file:///home/arthur/projetos/HOW%20VIII/test/presentation/pages/home_page_widget_test.dart) aberto atrás caso queira apontar |
| **Aba 4 (GitHub Actions)** | Pipeline verde no GitHub: `https://github.com/arthurliszkievich/hands-on-work-viii/actions` | Aberta no navegador para mostrar com `Alt + Tab` |

---

## 🎬 Cartões de Gravação — Bloco a Bloco

```
================================================================================
⏱️ BLOCO 1 | 0:00 - 0:20 (Duração: 20s)
📌 TEMA: ABERTURA & EVOLUÇÃO DA ETAPA 1 PARA A ETAPA 2
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA:**
  * App Flutter aberto no Chrome dentro da moldura mobile (`Total a Receber na Rua: R$ 335,50`, `2 de 3` clientes).
* **🗣️ FALA NO TELEPROMPTER:**
  > "Olá! Sou o **Arthur** e apresento a entrega da **Etapa 2** da **Caderneta Digital de Fiado**, no Hands on Work VIII da UNIVALI, com **Matheus, Alifer, Fátima, Evy e Aghata**."  
  > *[PAUSA: 1s]*  
  > "Na Etapa 1, blindamos as regras contábeis em Dart puro. Agora, materializamos a **Aplicação Mobile** completa em Flutter e os testes integrados da interface."
* **💡 DICA:** Comece já com o app aparecendo bonito na tela. Mostra evolução visual imediata em relação ao terminal da Etapa 1!

---

```
================================================================================
⏱️ BLOCO 2 | 0:20 - 0:45 (Duração: 25s)
📌 TEMA: PAINEL DO COMERCIANTE & REGRA 1 (CADASTRO COM SALDO ZERO)
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA (CLICKS):**
  1. Clique no chip **`Com dívida (2)`** e volte para **`Todos (3)`**.
  2. Clique no botão **`+ Novo Cliente`**.
  3. Digite **`Ana Paula`**, toque no chip **`Limite R$ 150,00`** e clique em **`Cadastrar Cliente`**.
* **🗣️ FALA NO TELEPROMPTER:**
  > "Na tela inicial, o comerciante acompanha o total a receber na rua em tempo real e filtra rapidamente quem tem pendências."  
  > *[PAUSA: 1s]*  
  > "Ao cadastrar um novo cliente pelo modal, o app aciona a **Regra 1** do domínio, garantindo que toda conta comece com **saldo devedor zero** e limite definido."
* **💡 DICA:** Usar o chip `Limite R$ 150,00` evita perder tempo digitando valores durante a gravação.

---

```
================================================================================
⏱️ BLOCO 3 | 0:45 - 1:25 (Duração: 40s)
📌 TEMA: REGRA 2 — COMPRA FIADA & TRAVA AUTOMÁTICA NA TELA
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA (CLICKS):**
  1. No card da **Dona Maria da Silva** (que tem `R$ 64,50` disponíveis), clique em **`Fiado`**.
  2. Clique no chip **`Mercearia (R$ 85,50)`** ➔ **`Confirmar Compra no Fiado`**.
  3. **Aponte o banner vermelho:** *"Trava Automática de Crédito Acionada"*.
  4. Clique no chip **`Pão e Leite (R$ 25,00)`** ➔ **`Confirmar Compra no Fiado`** (o selo vira **`Limite próximo`**).
* **🗣️ FALA NO TELEPROMPTER:**
  > "Agora validamos a **Regra 2** na prática. A Dona Maria tem apenas sessenta e quatro reais e cinquenta de crédito livre."  
  > *[PAUSA: 1s]*  
  > "Ao tentar anotar oitenta e cinco reais, a interface exibe na hora a **Trava Automática de Crédito**, impedindo o endividamento acima do teto. Já uma compra de vinte e cinco reais dentro do limite é aprovada e atualiza o alerta visual para **limite próximo**."
* **💡 DICA:** Esse é o momento mais forte da demonstração. Deixe o banner vermelho visível por 2 a 3 segundos antes de clicar no chip menor!

---

```
================================================================================
⏱️ BLOCO 4 | 1:25 - 1:55 (Duração: 30s)
📌 TEMA: REGRA 3 — BAIXA DE PAGAMENTO & EXTRATO INDIVIDUAL
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA (CLICKS):**
  1. No card do **Seu Raimundo Nonato** (`R$ 100,00`), clique em **`Receber`**.
  2. *(Opcional rápido)* Digite `150` e confirme para mostrar o bloqueio de saldo negativo, depois toque em **`Quitar Total (R$ 100,00)`** ➔ **`Registrar Baixa de Pagamento`**.
  3. Clique no **ícone de recibo** do Seu Raimundo para abrir a **Ficha de Fiado** e rolar pelo **Extrato de Lançamentos**.
* **🗣️ FALA NO TELEPROMPTER:**
  > "Na **Regra 3**, acessamos o pagamento do Seu Raimundo. O sistema também bloqueia valores acima da dívida para nunca gerar saldo negativo. Ao quitar os cem reais, o status muda automaticamente para **Em dia**, e todo o histórico de compras e amortizações fica auditável na **Ficha de Fiado**."
* **💡 DICA:** Mostrar o extrato cronológico (`+ Compra` e `- Amortização`) prova o controle contábil completo na mão do comerciante.

---

```
================================================================================
⏱️ BLOCO 5 | 1:55 - 2:30 (Duração: 35s)
📌 TEMA: TESTES DE WIDGET/CONTROLLER (TDD) & CI NO GITHUB ACTIONS
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA:**
  1. `Alt + Tab` para o **Terminal** da IDE e execute:
     ```bash
     flutter analyze && flutter test
     ```
     *(Aponte para `No issues found!` e `00:02 +22: All tests passed!`)*
  2. `Alt + Tab` para a aba do **GitHub Actions** com a pipeline verde ✅.
* **🗣️ FALA NO TELEPROMPTER:**
  > "Seguindo o rigor do **TDD**, evoluímos nossa suíte de treze para **vinte e dois testes automatizados**, cobrindo o repositório em memória, o `CadernetaController` e testes de widget simulando toques reais nas telas."  
  > *[PAUSA: 1s]*  
  > "O `flutter analyze` fecha sem nenhum alerta, alcançamos **88,8% de cobertura global** com mais de noventa e cinco por cento nas telas, e toda a esteira segue validada no **GitHub Actions**."
* **💡 DICA:** Deixe o comando `flutter analyze && flutter test` já preparado ou copiado antes de gravar.

---

```
================================================================================
⏱️ BLOCO 6 | 2:30 - 2:45 (Duração: 15s)
📌 TEMA: VALIDAÇÃO FINAL & ENCERRAMENTO
================================================================================
```
* **🖥️ O QUE MOSTRAR NA TELA:**
  * Volte rapidamente para o app aberto (ou para o repositório no GitHub).
* **🗣️ FALA NO TELEPROMPTER:**
  > "Com isso, entregamos a **Etapa 2** unindo Clean Architecture, TDD e uma aplicação mobile pronta para validação prática com pequenos comerciantes. Todo o código e evidências estão no repositório oficial. Muito obrigado!"
* **💡 DICA:** Sorria, finalize firme e dê 2 segundos de pausa antes de encerrar a gravação.

---

## ⚡ Comando Único para o Bloco 5
```bash
flutter analyze && flutter test
```
