import 'package:flutter/material.dart';
import 'package:caderneta_digital_fiado/data/repositories/in_memory_customer_repository.dart';
import 'package:caderneta_digital_fiado/domain/usecases/process_payment.dart';
import 'package:caderneta_digital_fiado/domain/usecases/record_purchase.dart';
import 'package:caderneta_digital_fiado/domain/usecases/register_customer.dart';
import 'package:caderneta_digital_fiado/presentation/controllers/caderneta_controller.dart';
import 'package:caderneta_digital_fiado/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await createCadernetaController(seedInitialData: true);
  runApp(CadernetaApp(controller: controller));
}

/// Constrói e injeta toda a árvore de dependências da Clean Architecture.
Future<CadernetaController> createCadernetaController({
  bool seedInitialData = false,
}) async {
  final repository = InMemoryCustomerRepository();
  final registerCustomer = RegisterCustomer(repository);
  final recordPurchase = RecordPurchase(repository);
  final processPayment = ProcessPayment(repository);

  final controller = CadernetaController(
    registerCustomerUseCase: registerCustomer,
    recordPurchaseUseCase: recordPurchase,
    processPaymentUseCase: processPayment,
    customerRepository: repository,
  );

  if (seedInitialData) {
    await _seedNeighborhoodCustomers(controller);
  }

  return controller;
}

Future<void> _seedNeighborhoodCustomers(CadernetaController controller) async {
  await controller.cadastrarCliente(
    id: 'cli-001',
    name: 'Dona Maria da Silva',
    phone: '(47) 99876-5432',
    limit: 300.0,
  );
  await controller.registrarCompra(
    customerId: 'cli-001',
    amount: 85.50,
    description: 'Arroz 5kg, Feijão e Óleo',
  );
  await controller.registrarCompra(
    customerId: 'cli-001',
    amount: 150.00,
    description: 'Carnes e Frios da semana',
  );

  await controller.cadastrarCliente(
    id: 'cli-002',
    name: 'Seu Raimundo Nonato',
    phone: '(47) 99123-4567',
    limit: 250.0,
  );
  await controller.registrarCompra(
    customerId: 'cli-002',
    amount: 140.00,
    description: 'Hortifruti, café e laticínios',
  );
  await controller.baixarPagamento(
    customerId: 'cli-002',
    amount: 40.00,
    description: 'Adiantamento em dinheiro no balcão',
  );

  await controller.cadastrarCliente(
    id: 'cli-003',
    name: 'João Pedro Ferreira',
    phone: '(47) 98811-2233',
    limit: 200.0,
  );
}

class CadernetaApp extends StatelessWidget {
  final CadernetaController controller;

  const CadernetaApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caderneta Digital de Fiado',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isDesktopViewport =
                constraints.maxWidth >= 600 && constraints.maxHeight >= 700;
            if (!isDesktopViewport) {
              return child ?? const SizedBox.shrink();
            }

            return ColoredBox(
              color: const Color(0xFF0F172A),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    width: 420,
                    constraints: const BoxConstraints(maxHeight: 860),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(38),
                      border: Border.all(
                        color: const Color(0xFF334155),
                        width: 6,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 40,
                          offset: Offset(0, 20),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: child ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      home: HomePage(controller: controller),
    );
  }
}
