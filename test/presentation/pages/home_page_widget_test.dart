import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:caderneta_digital_fiado/main.dart';

void main() {
  group('CadernetaApp Mobile UI [Widget & Integration Tests]', () {
    testWidgets(
      'deve exibir estado vazio inicialmente e cadastrar novo cliente pela interface',
      (tester) async {
        final controller =
            await createCadernetaController(seedInitialData: false);
        await tester.pumpWidget(CadernetaApp(controller: controller));

        expect(
          find.text('Nenhum cliente cadastrado no fiado.'),
          findsOneWidget,
        );
        expect(find.text('R\$ 0,00'), findsOneWidget);

        await tester.tap(find.byKey(const Key('fab_new_customer')));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('input_customer_name')),
          'Dona Maria',
        );
        await tester.enterText(
          find.byKey(const Key('input_customer_phone')),
          '(47) 99988-7766',
        );
        await tester.enterText(
          find.byKey(const Key('input_customer_limit')),
          '200,00',
        );

        await tester.tap(find.byKey(const Key('btn_confirm_register')));
        await tester.pumpAndSettle();

        expect(find.text('Dona Maria'), findsOneWidget);
        expect(find.text('Em dia'), findsOneWidget);
        expect(find.text('Dívida: R\$ 0,00'), findsOneWidget);
      },
    );

    testWidgets(
      'deve lançar compra fiada, exibir alerta visual ao estourar limite e quitar dívida',
      (tester) async {
        final controller =
            await createCadernetaController(seedInitialData: false);
        await controller.cadastrarCliente(
          id: 'cli-test',
          name: 'Seu Raimundo',
          phone: '(47) 98877-6655',
          limit: 100.0,
        );

        await tester.pumpWidget(CadernetaApp(controller: controller));
        await tester.pumpAndSettle();

        // 1. Lança compra válida de R$ 60,00
        await tester.tap(find.byKey(const Key('btn_purchase_cli-test')));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('input_purchase_description')),
          'Arroz e Feijão',
        );
        await tester.enterText(
          find.byKey(const Key('input_purchase_amount')),
          '60,00',
        );
        await tester.tap(find.byKey(const Key('btn_confirm_purchase')));
        await tester.pumpAndSettle();

        expect(find.text('Dívida: R\$ 60,00'), findsOneWidget);
        expect(find.text('Fiado ativo'), findsOneWidget);

        // 2. Tenta lançar compra de R$ 80,00 (estoura limite de R$ 100,00)
        await tester.tap(find.byKey(const Key('btn_purchase_cli-test')));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('input_purchase_description')),
          'Compra Acima do Limite',
        );
        await tester.enterText(
          find.byKey(const Key('input_purchase_amount')),
          '80,00',
        );
        await tester.tap(find.byKey(const Key('btn_confirm_purchase')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('domain_error_banner')), findsOneWidget);
        expect(
          find.text('Trava Automática de Crédito Acionada'),
          findsOneWidget,
        );

        // Fecha o modal de compra bloqueada
        Navigator.of(tester.element(find.byKey(const Key('domain_error_banner'))))
            .pop();
        await tester.pumpAndSettle();

        // 3. Quita a dívida integralmente pela modal de pagamento
        await tester.tap(find.byKey(const Key('btn_payment_cli-test')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('chip_pay_full')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('btn_confirm_payment')));
        await tester.pumpAndSettle();

        expect(find.text('Dívida: R\$ 0,00'), findsOneWidget);
        expect(find.text('Em dia'), findsOneWidget);

        // 4. Abre a Ficha de Fiado / Extrato e confere os 2 lançamentos registrados
        await tester.tap(find.byKey(const Key('btn_detail_cli-test')));
        await tester.pumpAndSettle();

        expect(find.text('Ficha de Fiado'), findsOneWidget);
        expect(find.text('Extrato de Lançamentos (2)'), findsOneWidget);
        expect(find.text('Arroz e Feijão'), findsOneWidget);
        expect(find.text('Quitação total da caderneta'), findsOneWidget);
      },
    );
  });
}
