# 🎬 Roteiro de Gravação do Vídeo — Etapa 1 (HOW VIII)

> **Projeto:** Caderneta Digital de Fiado  
> **Instituição:** UNIVALI — Curso de Ciência da Computação / Eng. de Software  
> **Disciplina:** Hands-On Work VIII (HOW VIII)  
> **Apresentador:** Arthur Rocha Laszlo Liszkievich (narrando individualmente pelo grupo)  
> **Duração Estimada:** ~2 minutos e 55 segundos (máximo de 3 minutos)  
> **Contagem de Palavras Faladas:** 376 palavras (~130 palavras por minuto)  
> **Data de Referência da Entrega:** 25/10/2026  

---

## 📋 Tabela de Gravação Segundo a Segundo

| Tempo | Seção | O que Mostrar na Tela (Comando / Arquivo Exato) | Fala do Arthur (Narração) |
| :--- | :--- | :--- | :--- |
| **0:00 - 0:20** *(20s)* | **1. Abertura e Apresentação** | **VS Code / Navegador:**<br>Arquivo [`README.md`](file:///home/arthur/projetos/HOW%20VIII/README.md) aberto no topo com os badges de status do CI, TDD e cobertura de 93,4%. | "Olá! Sou o Arthur e apresento os resultados da Etapa 1 do Hands on Work VIII da UNIVALI, desenvolvido em grupo com Matheus, Alifer, Fátima, Evy e Aghata. Nosso projeto é a Caderneta Digital de Fiado, app mobile em Flutter que substitui o caderno de papel dos comerciantes." |
| **0:20 - 0:45** *(25s)* | **2. Problema da Comunidade** | **VS Code:**<br>Seção "Contexto do Projeto e Dor da Comunidade" no [`README.md`](file:///home/arthur/projetos/HOW%20VIII/README.md#L14-L21). | "Mercearias, padarias e feirantes usam o fiado como ferramenta de fidelização, mas o papel gera descontrole: folhas se perdem, a soma manual induz ao erro e não há limites de crédito, causando dívidas impagáveis. A validação prática com comerciantes reais, liderada pela Alifer, é o foco da nossa Sprint 2." |
| **0:45 - 1:20** *(35s)* | **3. Clean Architecture & Domínio** | **VS Code (Duas Colunas):**<br>Coluna 1: [`customer.dart`](file:///home/arthur/projetos/HOW%20VIII/lib/domain/entities/customer.dart)<br>Coluna 2: [`record_purchase.dart`](file:///home/arthur/projetos/HOW%20VIII/lib/domain/usecases/record_purchase.dart) e [`process_payment.dart`](file:///home/arthur/projetos/HOW%20VIII/lib/domain/usecases/process_payment.dart). Mostrar que a camada `lib/domain/` é Dart puro sem widgets. | "Adotamos Clean Architecture, isolando a regra contábil no domínio, em Dart puro, sem emulador ou dependência da interface. São três regras centrais: cadastro do cliente com saldo inicial zero, compra fiada com trava automática de limite de crédito e baixa de pagamento que abate a dívida sem permitir saldo negativo. A interface atual é apenas um esqueleto." |
| **1:20 - 1:55** *(35s)* | **4. Metodologia TDD & Histórico Git** | **Terminal:**<br>Executar o comando:<br>`git log --oneline --reverse`<br>Dar zoom nos commits de cada regra (`[RED]`, `[GREEN]`, `[REFACTOR]`). | "Cada regra seguiu rigorosamente o ciclo Red-Green-Refactor do TDD: primeiro o commit do teste unitário falhando, depois o código mínimo para passar e, por fim, a refatoração. O histórico do Git comprova essa ordem. Eu construí a arquitetura e as regras um e dois; o Matheus implementou a regra três de pagamento e a camada de dados em memória." |
| **1:55 - 2:20** *(25s)* | **5. Testes, Cobertura e CI** | **Terminal & Navegador:**<br>1. Executar no terminal: `flutter test --coverage`<br>*(mostrar 13 testes passando)*<br>2. Alternar para a aba do GitHub Actions no navegador com o check verde da pipeline. | "Rodando flutter test, os 13 testes unitários passam com sucesso. A cobertura alcança 93,4% na camada de domínio e 100% nos casos de uso. No GitHub Actions, a cada push, a esteira de Integração Contínua roda a análise estática com flutter analyze e executa todos os testes com extração do relatório LCOV." |
| **2:20 - 2:40** *(20s)* | **6. Gestão Ágil no ClickUp (Scrum)** | **Navegador ou VS Code:**<br>Quadro do ClickUp com as tarefas da Sprint 1 em "Concluído" (ou a tabela "Equipe" no [`README.md`](file:///home/arthur/projetos/HOW%20VIII/README.md#L45-L54)). | "O Scrum foi estruturado no ClickUp pela Fátima, com backlog e sprints definidas. A Sprint 1, de 12 a 25 de outubro, concluiu as metas centrais: arquitetura limpa, as três regras de domínio, testes e CI. A Aghata atuou na consolidação das informações do relatório acadêmico." |
| **2:40 - 2:55** *(15s)* | **7. Próximos Passos & Encerramento** | **Terminal:**<br>Executar no terminal:<br>`dart run tool/demo_runner.dart`<br>Exibir a simulação matemática rodando ao vivo e o link do GitHub. | "Na Sprint 2, de 26 de outubro a 8 de novembro, entraremos na interface do usuário para o comerciante, persistência em banco local, testes de integração e validação em campo com pequenos varejistas. O repositório oficial está disponível no GitHub com todas as evidências. Muito obrigado!" |

---

## 🛠 Checklist de Preparação para Gravação

1. **Terminal:**
   - Ajustar a fonte para tamanho legível (Ctrl + Shift + `+`).
   - Comandos pré-testados no histórico do shell:
     ```bash
     git log --oneline --reverse
     flutter test --coverage
     dart run tool/demo_runner.dart
     ```
2. **VS Code:**
   - Deixar abertos em abas limpas:
     - [`README.md`](file:///home/arthur/projetos/HOW%20VIII/README.md)
     - [`lib/domain/entities/customer.dart`](file:///home/arthur/projetos/HOW%20VIII/lib/domain/entities/customer.dart)
     - [`lib/domain/usecases/record_purchase.dart`](file:///home/arthur/projetos/HOW%20VIII/lib/domain/usecases/record_purchase.dart)
     - [`lib/domain/usecases/process_payment.dart`](file:///home/arthur/projetos/HOW%20VIII/lib/domain/usecases/process_payment.dart)
3. **Navegador Web:**
   - Aba 1: Repositório GitHub na aba de Actions: `https://github.com/arthurliszkievich/hands-on-work-viii/actions`
   - Aba 2: Painel do ClickUp com o quadro Scrum da Sprint 1.

---

## ⚠️ Afirmações Não Verificadas (Pendentes de Confirmação do Usuário)

As seguintes afirmações foram incluídas no roteiro por solicitação ou contexto do grupo, mas **não puderam ser verificadas diretamente através do repositório de código**:

1. **Papel de Evy:** Não há commits, PRs, branches ou menções nominais a Evy no repositório Git. O papel específico precisa ser confirmado pelo grupo.
2. **Papel de Fátima (Scrum no ClickUp):** A existência do backlog, divisões de sprints e releases no ClickUp precisa ser confirmada visualmente no ambiente do ClickUp por Arthur e Fátima antes de exibir a tela.
3. **Papel de Alifer (Validação com Comerciantes):** A atribuição da validação de campo com comerciantes locais para a Sprint 2 precisa ser alinhada diretamente com o integrante.
4. **Papel de Aghata (Relatório Acadêmico):** A consolidação das seções acadêmicas do relatório no Word precisa ser confirmada com Aghata.
5. **Datas das Sprints:** Foram utilizadas as datas: Sprint 1 (12/10 a 25/10/2026) e Sprint 2 (26/10 a 08/11/2026). Verificar se essas datas coincidem exatamente com o cronograma oficial aprovado pelo professor no plano de ensino.
6. **Autoria dos Commits de Matheus:** Os commits de código de Matheus (`ef3ee9e`, `e2f77da`, `77bce07`) foram gerados com o autor `Cursor Agent <cursoragent@cursor.com>` e trailer `Co-authored-by: Matheus Yan <reismatheusyan83@gmail.com>`, enquanto os merges (`4f6c7b8` e `a471ec8`) estão com autor direto `Matheus Yan`. Caso o professor faça checagem estrita de autoria sem suporte a co-autoria, isso deve ser pontuado na apresentação ou no relatório.
