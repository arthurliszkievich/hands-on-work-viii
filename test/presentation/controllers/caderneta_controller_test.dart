import 'package:flutter_test/flutter_test.dart';
import 'package:caderneta_digital_fiado/data/repositories/in_memory_customer_repository.dart';
import 'package:caderneta_digital_fiado/domain/usecases/process_payment.dart';
import 'package:caderneta_digital_fiado/domain/usecases/record_purchase.dart';
import 'package:caderneta_digital_fiado/domain/usecases/register_customer.dart';
import 'package:caderneta_digital_fiado/presentation/controllers/caderneta_controller.dart';

void main() {
  late InMemoryCustomerRepository repository;
  late CadernetaController controller;

  setUp(() {
    repository = InMemoryCustomerRepository();
    controller = CadernetaController(
      registerCustomerUseCase: RegisterCustomer(repository),
      recordPurchaseUseCase: RecordPurchase(repository),
      processPaymentUseCase: ProcessPayment(repository),
      customerRepository: repository,
    );
  });

  group('CadernetaController [Presentation State & TDD]', () {
    test('deve cadastrar cliente com saldo inicial zero e atualizar métricas', () async {
      final ok = await controller.cadastrarCliente(
        id: 'cli-1',
        name: 'Dona Maria',
        phone: '47999998888',
        limit: 200.0,
      );

      expect(ok, isTrue);
      expect(controller.errorMessage, isNull);
      expect(controller.customers, hasLength(1));
      expect(controller.totalReceivable, 0.0);
      expect(controller.totalCreditLimit, 200.0);
      expect(controller.customersWithDebtCount, 0);
    });

    test('deve expor mensagem de erro ao tentar cadastrar cliente inválido', () async {
      final ok = await controller.cadastrarCliente(
        id: 'cli-invalido',
        name: '   ',
        phone: '47999998888',
        limit: 200.0,
      );

      expect(ok, isFalse);
      expect(controller.customers, isEmpty);
      expect(controller.errorMessage, contains('nome do cliente'));
    });

    test('deve somar dívida em compra fiada e bloquear quando ultrapassar o limite', () async {
      await controller.cadastrarCliente(
        id: 'cli-1',
        name: 'Dona Maria',
        phone: '47999998888',
        limit: 100.0,
      );

      final purchaseOk = await controller.registrarCompra(
        customerId: 'cli-1',
        amount: 70.0,
        description: 'Compras da semana',
      );
      expect(purchaseOk, isTrue);
      expect(controller.totalReceivable, 70.0);
      expect(controller.customersWithDebtCount, 1);

      final blocked = await controller.registrarCompra(
        customerId: 'cli-1',
        amount: 50.0,
        description: 'Tentativa acima do limite',
      );
      expect(blocked, isFalse);
      expect(controller.totalReceivable, 70.0);
      expect(controller.errorMessage, contains('Limite de crédito excedido'));
    });

    test('deve amortizar pagamento parcial e bloquear pagamento maior que a dívida', () async {
      await controller.cadastrarCliente(
        id: 'cli-1',
        name: 'Seu Raimundo',
        phone: '47988887777',
        limit: 300.0,
      );
      await controller.registrarCompra(
        customerId: 'cli-1',
        amount: 120.0,
        description: 'Feira mensal',
      );

      final overPay = await controller.baixarPagamento(
        customerId: 'cli-1',
        amount: 150.0,
      );
      expect(overPay, isFalse);
      expect(controller.totalReceivable, 120.0);
      expect(controller.errorMessage, contains('excede a dívida atual'));

      final validPay = await controller.baixarPagamento(
        customerId: 'cli-1',
        amount: 50.0,
        description: 'Adiantamento',
      );
      expect(validPay, isTrue);
      expect(controller.totalReceivable, 70.0);
      expect(controller.errorMessage, isNull);

      final extrato = await controller.carregarExtratoCliente('cli-1');
      expect(extrato, hasLength(2));
    });

    test('deve filtrar clientes por busca textual e por status de dívida', () async {
      await controller.cadastrarCliente(
        id: 'cli-1',
        name: 'Dona Maria',
        phone: '47911112222',
        limit: 200.0,
      );
      await controller.cadastrarCliente(
        id: 'cli-2',
        name: 'João Pedro',
        phone: '47933334444',
        limit: 200.0,
      );
      await controller.registrarCompra(
        customerId: 'cli-1',
        amount: 45.0,
        description: 'Pão e café',
      );

      controller.alternarFiltroComDivida(true);
      expect(controller.filteredCustomers, hasLength(1));
      expect(controller.filteredCustomers.first.name, 'Dona Maria');

      controller.alternarFiltroComDivida(false);
      controller.atualizarBusca('joão');
      expect(controller.filteredCustomers, hasLength(1));
      expect(controller.filteredCustomers.first.name, 'João Pedro');
    });
  });
}
