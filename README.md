# Caderneta Digital de Fiado 📱📓

[![Flutter CI/CD](https://github.com/arthurliszkievich/hands-on-work-viii/actions/workflows/flutter.yml/badge.svg)](https://github.com/arthurliszkievich/hands-on-work-viii/actions/workflows/flutter.yml)
[![TDD Methodology](https://img.shields.io/badge/Methodology-TDD%20(Red%2FGreen%2FRefactor)-blue.svg)](#-comprova%C3%A7%C3%A3o-acad%C3%AAmica-do-ciclo-tdd-hist%C3%B3rico-de-commits)
[![Coverage: 93.4%](https://img.shields.io/badge/Coverage-93.4%25%20(Domain)-brightgreen.svg)](#-m%C3%A9tricas-e-cobertura-de-testes)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-success.svg)](#-arquitetura-e-separa%C3%A7%C3%A3o-de-responsabilidades)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Repositório técnico oficial do trabalho prático **HOW VIII (Hands-On Work VIII)**.
Solução móvel desenvolvida em **Flutter/Dart** para resolução de um problema comunitário crítico: a desorganização financeira de pequenos comerciantes locais que anotam dívidas em cadernos de papel e sofrem com erros de cálculo e perda de controle contábil.

---

## 🎯 Contexto do Projeto e Dor da Comunidade
Pequenos comerciantes (mercearias de bairro, feirantes, padarias e pequenos bares) têm no "fiado" uma ferramenta vital de fidelização, mas enfrentam graves problemas:
1. **Desorganização Contábil:** Folhas soltas, rasuradas ou perdidas;
2. **Erros de Cálculo:** Erros manuais na soma de compras consecutivas ou na dedução de amortizações parciais;
3. **Ausência de Travas de Crédito:** Falta de limites claros, gerando endividamento impagável do cliente e quebra do caixa do comerciante.

A **Caderneta Digital de Fiado** soluciona essa dor priorizando a confiabilidade das regras contábeis, utilizando **Test-Driven Development (TDD)** e **Clean Architecture**, blindando a matemática do negócio contra inconsistências de cálculo e de limites.

---

## 📊 Status do Projeto

O desenvolvimento está estruturado em duas etapas principais:

* **Etapa 1 — Entrega Atual (25/10/2026):**
  * **Domínio e Regras de Negócio:** Modelagem em Dart puro das três regras financeiras essenciais (cadastro de cliente com saldo zero, registro de compra fiada com trava de limite de crédito e baixa de pagamento/amortização sem saldo negativo).
  * **TDD e Testes de Unidade:** Suíte com 13 testes unitários aprovados e cobertura de **93,44% na camada de domínio** (`lib/domain/`) e **100% nos casos de uso** (`lib/domain/usecases/`).
  * **Camada de Dados Inicial:** Implementação de repositório em memória (`InMemoryCustomerRepository`) desacoplado para simulação e validação rápida.
  * **CI/CD:** Pipeline automatizada no GitHub Actions executando análise estática (`flutter analyze`) e testes com cobertura (`flutter test --coverage`).
  * *Observação sobre a Interface:* Os arquivos `lib/presentation/pages/home_page.dart` e `lib/main.dart` formam atualmente um esqueleto/wireframe inicial para validação da estrutura, sem tela de cadastro completa.

* **Etapa 2 — Próxima Sprint (26/10 a 08/11/2026):**
  * **Interface Mobile do Comerciante:** Construção completa da UI para interação no balcão (cadastro de clientes, busca rápida, lançamento de compras e amortização).
  * **Persistência de Dados Local Definitiva:** Integração com banco de dados embutido (ex: SQLite / Isar / Hive).
  * **Testes de Integração e UI:** Testes de ponta a ponta e testes de widgets para validação da camada de apresentação.
  * **Validação com Comerciantes Reais:** Aplicação prática e coleta de feedback com comerciantes locais de bairro.

---

## 👥 Equipe do Projeto

| Integrante | Papel e Contribuições na Etapa 1 | Evidência / Canal |
| :--- | :--- | :--- |
| **Arthur Rocha Laszlo Liszkievich** | Tech Lead: arquitetura (Clean Architecture), Regra 1 (cadastro), Regra 2 (compra fiada), pipeline de CI/CD, script de demonstração interativa (`tool/demo_runner.dart`), roteiro e apresentação técnica do vídeo. | Commits no Git (19 commits), configuração do Actions e branches |
| **Matheus Yan Reis** | Segundo Desenvolvedor: Regra 3 (baixa de pagamento / amortização) e camada de dados (`InMemoryCustomerRepository`). | Commits no Git e Pull Request #1 no GitHub |
| **Alifer** | Pesquisa e validação com comerciantes locais (Etapa 2). | Validação externa / A confirmar |
| **Fátima** | Gestão ágil e Scrum no ClickUp (Backlog, releases e sprints). | Painel ClickUp / A confirmar |
| **Aghata** | Apoio na estruturação e consolidação do relatório acadêmico. | Documento acadêmico / A confirmar |
| **Evy** | A confirmar | A confirmar |

---

## 🏛 Arquitetura e Separação de Responsabilidades
A aplicação foi estruturada segundo os princípios da **Clean Architecture**, garantindo que a **Regra de Negócio** (onde a matemática do fiado acontece) esteja totalmente isolada da **Interface Gráfica** (Widgets Flutter) e da camada de persistência:

```text
HOW VIII/
├── .github/
│   └── workflows/
│       └── flutter.yml             # Pipeline de CI/CD automática no GitHub Actions
├── docs/
│   └── roteiro_video_etapa1.md     # Roteiro técnico consolidado da apresentação em vídeo
├── lib/
│   ├── core/
│   │   └── errors/
│   │       └── failures.dart       # Exceções explícitas de domínio (limite estourado, valores inválidos)
│   ├── domain/                     # NÚCLEO PURO DART (Zero acoplamento com Flutter UI)
│   │   ├── entities/
│   │   │   ├── customer.dart       # Entidade rica com invariantes de crédito e dívida
│   │   │   └── credit_transaction.dart # Registro imutável de transações (compra e amortização)
│   │   ├── repositories/
│   │   │   └── customer_repository.dart # Contrato de abstração (DIP)
│   │   └── usecases/               # Casos de uso financeiros
│   │       ├── register_customer.dart  # Regra 1: Cadastro com saldo inicial zero
│   │       ├── record_purchase.dart    # Regra 2: Nova compra com trava de limite
│   │       └── process_payment.dart    # Regra 3: Amortização sem saldo negativo
│   ├── data/
│   │   └── repositories/
│   │       └── in_memory_customer_repository.dart # Repositório para simulação e testes
│   ├── presentation/
│   │   ├── controllers/
│   │   │   └── caderneta_controller.dart # Gerenciamento de estado reativo
│   │   └── pages/
│   │       └── home_page.dart      # Esqueleto da interface gráfica do comerciante
│   └── main.dart                   # Ponto de entrada da aplicação
├── test/
│   ├── domain/
│   │   ├── entities/
│   │   │   └── customer_test.dart  # Testes de unidade da entidade de domínio
│   │   └── usecases/
│   │       ├── register_customer_test.dart # Testes unitários do caso de uso de cadastro
│   │       ├── record_purchase_test.dart   # Testes unitários do registro de fiado
│   │       └── process_payment_test.dart   # Testes unitários da baixa de pagamentos
└── tool/
    └── demo_runner.dart            # Demonstração interativa das regras no terminal
```

---

## 📈 Métricas e Cobertura de Testes

Os testes unitários foram executados com `flutter test --coverage` e mensurados com o relatório LCOV (`coverage/lcov.info`):

| Escopo Avaliado | Linhas Cobertas (LH) | Total de Linhas (LF) | Cobertura Real |
| :--- | :---: | :---: | :---: |
| **Casos de Uso (`lib/domain/usecases/`)** | 28 | 28 | **100,00%** |
| **Camada de Domínio (`lib/domain/`)** | 57 | 61 | **93,44%** |
| **Total do Código Avaliado** | 63 | 69 | **91,30%** |

* **Total de Testes Unitários:** 13 testes automatizados (13 aprovados, 0 falhas).
* **Escopo do Badge:** O badge no topo do repositório reflete a cobertura da **Camada de Domínio (`lib/domain`) de 93,4%**, onde residem as regras contábeis do fiado.

---

## 🧪 Comprovação Acadêmica do Ciclo TDD (Histórico de Commits)
Para comprovar que os testes foram **rigorosamente escritos antes do código de produção**, o repositório foi construído seguindo a disciplina cronológica de commits do TDD (*Red, Green, Refactor*):

### Regra 1: Cadastro de Cliente com Saldo Inicial Zero
* `6cb4389` `test(customer): [RED] add unit tests for customer registration entity and validation`
* `1890d91` `feat(customer): [GREEN] implement customer entity and register_customer use case`
* `c8a899f` `refactor(customer): [REFACTOR] extract customer domain validation and business exceptions`

### Regra 2: Registrar Nova Compra Fiada (com Trava de Limite)
* `fb78da3` `test(purchase): [RED] add unit tests for recording fiado purchase and credit limit check`
* `6430650` `feat(purchase): [GREEN] implement record_purchase use case with balance increment`
* `6c8704a` `refactor(purchase): [REFACTOR] optimize credit limit check and transaction immutability`

### Regra 3: Baixar Pagamento / Amortização (sem Saldo Negativo)
* **Entrega no Pull Request #1:**
  * `ef3ee9e` `test(payment): [RED] add unit tests for processing payment and debt reduction`
  * `e2f77da` `feat(payment): [GREEN] implement process_payment use case with debt deduction`
  * `77bce07` `feat(data): implement in-memory customer repository for data persistence`
  * `a471ec8` `Merge pull request #1 from MatheusYanr/main`
*(Observação: a regra também foi prototipada e validada previamente pelo Tech Lead nos commits `54196c0`, `1175c69` e `5a5435b`).*

### Auditoria Completa do Histórico
Para auditar a sequência histórica completa no terminal:
```bash
git log --oneline --reverse
```

---

## ⚙️ Continuous Integration (GitHub Actions)
O arquivo `.github/workflows/flutter.yml` automatiza a validação a cada `push` ou `pull_request`:
1. Prepara o ambiente Ubuntu com a versão estável do Flutter;
2. Resolve as dependências com `flutter pub get`;
3. Executa a análise estática com `flutter analyze` para conformidade de código limpo;
4. Executa a suíte de testes unitários com extração de cobertura LCOV via `flutter test --coverage`.

---

## 🚀 Como Executar Localmente

### Pré-requisitos
- Flutter SDK (versão >= 3.10)
- Dart SDK (versão >= 3.0)

### Comandos
```bash
# 1. Clonar o repositório
git clone https://github.com/arthurliszkievich/hands-on-work-viii.git
cd hands-on-work-viii

# 2. Instalar as dependências
flutter pub get

# 3. Executar a análise estática de código
flutter analyze

# 4. Executar a suíte de testes unitários (TDD)
flutter test

# 5. Executar os testes com extração de cobertura LCOV
flutter test --coverage

# 6. Executar a demonstração interativa no terminal
dart run tool/demo_runner.dart
```
