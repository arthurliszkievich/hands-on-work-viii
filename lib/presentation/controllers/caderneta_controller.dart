import 'package:flutter/foundation.dart';
import 'package:caderneta_digital_fiado/domain/entities/credit_transaction.dart';
import 'package:caderneta_digital_fiado/domain/entities/customer.dart';
import 'package:caderneta_digital_fiado/domain/repositories/customer_repository.dart';
import 'package:caderneta_digital_fiado/domain/usecases/process_payment.dart';
import 'package:caderneta_digital_fiado/domain/usecases/record_purchase.dart';
import 'package:caderneta_digital_fiado/domain/usecases/register_customer.dart';

/// Controller da Caderneta Digital de Fiado.
/// Orquestra os casos de uso do domínio e notifica a interface gráfica Flutter.
class CadernetaController extends ChangeNotifier {
  final RegisterCustomer registerCustomerUseCase;
  final RecordPurchase recordPurchaseUseCase;
  final ProcessPayment processPaymentUseCase;
  final CustomerRepository? customerRepository;

  List<Customer> _customers = [];
  final Map<String, List<CreditTransaction>> _localTransactions = {};

  String _searchQuery = '';
  bool _onlyWithDebt = false;
  String? errorMessage;
  bool isLoading = false;

  CadernetaController({
    required this.registerCustomerUseCase,
    required this.recordPurchaseUseCase,
    required this.processPaymentUseCase,
    this.customerRepository,
  });

  /// Lista completa de clientes cadastrados.
  List<Customer> get customers => List.unmodifiable(_customers);

  /// Termo de busca atual (nome ou telefone).
  String get searchQuery => _searchQuery;

  /// Filtro ativo para exibir apenas clientes com saldo devedor > 0.
  bool get onlyWithDebt => _onlyWithDebt;

  /// Lista de clientes filtrada pela busca e pelo filtro de inadimplência.
  List<Customer> get filteredCustomers {
    final query = _searchQuery.trim().toLowerCase();
    return _customers.where((customer) {
      if (_onlyWithDebt && customer.currentDebt <= 0) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      return customer.name.toLowerCase().contains(query) ||
          customer.phone.toLowerCase().contains(query);
    }).toList();
  }

  /// Soma total a receber no caderno de fiado.
  double get totalReceivable =>
      _customers.fold(0.0, (sum, customer) => sum + customer.currentDebt);

  /// Soma total de limites de crédito concedidos.
  double get totalCreditLimit =>
      _customers.fold(0.0, (sum, customer) => sum + customer.creditLimit);

  /// Quantidade de clientes que possuem dívida em aberto.
  int get customersWithDebtCount =>
      _customers.where((customer) => customer.currentDebt > 0).length;

  /// Busca a versão mais recente de um cliente pelo ID.
  Customer? buscarClientePorId(String id) {
    for (final customer in _customers) {
      if (customer.id == id) {
        return customer;
      }
    }
    return null;
  }

  /// Atualiza o termo de busca textual.
  void atualizarBusca(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Alterna o filtro de clientes com dívida pendente.
  void alternarFiltroComDivida(bool value) {
    _onlyWithDebt = value;
    notifyListeners();
  }

  /// Limpa a última mensagem de erro de domínio/validação.
  void limparErro() {
    if (errorMessage != null) {
      errorMessage = null;
      notifyListeners();
    }
  }

  /// Sincroniza a lista de clientes a partir do repositório configurado.
  Future<void> carregarClientes() async {
    final repository = customerRepository;
    if (repository == null) return;

    _setLoading(true);
    try {
      final loaded = await repository.getAllCustomers();
      _customers = List<Customer>.from(loaded);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Regra 1: Cadastra um novo cliente iniciando com saldo devedor zero.
  Future<bool> cadastrarCliente({
    String? id,
    required String name,
    required String phone,
    required double limit,
  }) async {
    _setLoading(true);
    try {
      final generatedId =
          id ?? 'cli-${DateTime.now().microsecondsSinceEpoch}';
      final customer = await registerCustomerUseCase(
        id: generatedId,
        name: name,
        phone: phone.trim(),
        creditLimit: limit,
      );
      _customers = [..._customers, customer];
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Regra 2: Registra nova compra fiada respeitando a trava de limite de crédito.
  Future<bool> registrarCompra({
    required String customerId,
    required double amount,
    required String description,
  }) async {
    _setLoading(true);
    try {
      final result = await recordPurchaseUseCase(
        customerId: customerId,
        amount: amount,
        description: description.trim(),
      );
      _replaceCustomer(result.customer);
      _appendLocalTransaction(customerId, result.transaction);
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Regra 3: Amortiza ou quita dívida impedindo saldo negativo.
  Future<bool> baixarPagamento({
    required String customerId,
    required double amount,
    String description = 'Pagamento / Amortização de Fiado',
  }) async {
    _setLoading(true);
    try {
      final cleanDescription = description.trim().isEmpty
          ? 'Pagamento / Amortização de Fiado'
          : description.trim();
      final result = await processPaymentUseCase(
        customerId: customerId,
        amount: amount,
        description: cleanDescription,
      );
      _replaceCustomer(result.customer);
      _appendLocalTransaction(customerId, result.transaction);
      errorMessage = null;
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Carrega o extrato de compras e pagamentos do cliente (mais recentes primeiro).
  Future<List<CreditTransaction>> carregarExtratoCliente(
    String customerId,
  ) async {
    final repository = customerRepository;
    final List<CreditTransaction> list;
    if (repository != null) {
      list = List<CreditTransaction>.from(
        await repository.getTransactionsByCustomer(customerId),
      );
    } else {
      list = List<CreditTransaction>.from(
        _localTransactions[customerId] ?? const [],
      );
    }
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  void _appendLocalTransaction(String customerId, CreditTransaction tx) {
    final existing = _localTransactions[customerId] ?? const [];
    _localTransactions[customerId] = [...existing, tx];
  }

  void _replaceCustomer(Customer updated) {
    final exists = _customers.any((c) => c.id == updated.id);
    if (exists) {
      _customers =
          _customers.map((c) => c.id == updated.id ? updated : c).toList();
    } else {
      _customers = [..._customers, updated];
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
