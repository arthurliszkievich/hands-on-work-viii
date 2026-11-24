import 'package:flutter_test/flutter_test.dart';
import 'package:caderneta_digital_fiado/data/repositories/in_memory_customer_repository.dart';
import 'package:caderneta_digital_fiado/domain/entities/credit_transaction.dart';
import 'package:caderneta_digital_fiado/domain/entities/customer.dart';

void main() {
  late InMemoryCustomerRepository repository;

  setUp(() {
    repository = InMemoryCustomerRepository();
  });

  group('InMemoryCustomerRepository [Data Layer]', () {
    test('deve salvar, buscar, listar e atualizar clientes em memória', () async {
      final customer = Customer(
        id: 'cli-1',
        name: 'Dona Maria',
        phone: '47999990000',
        creditLimit: 300.0,
      );

      await repository.saveCustomer(customer);

      final fetched = await repository.getCustomerById('cli-1');
      expect(fetched, equals(customer));

      final all = await repository.getAllCustomers();
      expect(all, hasLength(1));

      final updated = customer.increaseDebt(75.0);
      await repository.updateCustomer(updated);

      final afterUpdate = await repository.getCustomerById('cli-1');
      expect(afterUpdate?.currentDebt, 75.0);
    });

    test('deve registrar e filtrar transações apenas do cliente solicitado', () async {
      final tx1 = CreditTransaction(
        id: 'tx-1',
        customerId: 'cli-1',
        amount: 40.0,
        type: TransactionType.purchase,
        description: 'Pão e leite',
        timestamp: DateTime(2026, 11, 24, 10, 0),
      );
      final tx2 = CreditTransaction(
        id: 'tx-2',
        customerId: 'cli-2',
        amount: 20.0,
        type: TransactionType.purchase,
        description: 'Café',
        timestamp: DateTime(2026, 11, 24, 11, 0),
      );

      await repository.saveTransaction(tx1);
      await repository.saveTransaction(tx2);

      final cli1Txs = await repository.getTransactionsByCustomer('cli-1');
      expect(cli1Txs, hasLength(1));
      expect(cli1Txs.first.description, 'Pão e leite');
    });
  });
}
