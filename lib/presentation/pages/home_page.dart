import 'package:flutter/material.dart';
import 'package:caderneta_digital_fiado/domain/entities/customer.dart';
import 'package:caderneta_digital_fiado/presentation/controllers/caderneta_controller.dart';
import 'package:caderneta_digital_fiado/presentation/pages/customer_detail_page.dart';
import 'package:caderneta_digital_fiado/presentation/utils/currency_formatter.dart';
import 'package:caderneta_digital_fiado/presentation/widgets/operation_sheets.dart';

/// Tela Principal do Comerciante — Caderneta Digital de Fiado.
class HomePage extends StatelessWidget {
  final CadernetaController controller;

  const HomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Caderneta Digital 📓',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              'Controle de Fiado para Comerciantes',
              style: TextStyle(fontSize: 11.5, color: Color(0xFFCCFBF1)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('fab_new_customer'),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        onPressed: () => showRegisterCustomerModal(context, controller),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text(
          'Novo Cliente',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final visibleCustomers = controller.filteredCustomers;

          return Column(
            children: [
              _DashboardSummaryBanner(controller: controller),
              _SearchAndFilterBar(controller: controller),
              if (controller.isLoading)
                const LinearProgressIndicator(minHeight: 3),
              Expanded(
                child: controller.customers.isEmpty
                    ? _EmptyCadernetaView(
                        onAddCustomer: () =>
                            showRegisterCustomerModal(context, controller),
                      )
                    : visibleCustomers.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                'Nenhum cliente corresponde ao filtro atual.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 92),
                            itemCount: visibleCustomers.length,
                            itemBuilder: (context, index) {
                              final customer = visibleCustomers[index];
                              return _CustomerCard(
                                customer: customer,
                                onOpenDetail: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => CustomerDetailPage(
                                        controller: controller,
                                        customerId: customer.id,
                                      ),
                                    ),
                                  );
                                },
                                onPurchase: () => showRecordPurchaseModal(
                                  context,
                                  controller,
                                  customer,
                                ),
                                onPayment: () => showProcessPaymentModal(
                                  context,
                                  controller,
                                  customer,
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DashboardSummaryBanner extends StatelessWidget {
  final CadernetaController controller;

  const _DashboardSummaryBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    final availablePool =
        (controller.totalCreditLimit - controller.totalReceivable)
            .clamp(0.0, double.infinity);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF115E59)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(28),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withAlpha(45)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL A RECEBER NA RUA',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: Color(0xFFCCFBF1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      CurrencyFormatter.format(controller.totalReceivable),
                      key: const Key('summary_total_receivable'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Crédito livre: ${CurrencyFormatter.format(availablePool)}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF99F6E4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white.withAlpha(45),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CLIENTES C/ FIADO',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFCCFBF1),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${controller.customersWithDebtCount} de ${controller.customers.length}',
                    key: const Key('summary_customers_count'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Limites protegidos',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF99F6E4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchAndFilterBar extends StatelessWidget {
  final CadernetaController controller;

  const _SearchAndFilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        children: [
          TextField(
            key: const Key('input_search_customer'),
            onChanged: controller.atualizarBusca,
            decoration: InputDecoration(
              hintText: 'Buscar cliente por nome ou telefone...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              FilterChip(
                key: const Key('chip_filter_all'),
                label: Text('Todos (${controller.customers.length})'),
                selected: !controller.onlyWithDebt,
                onSelected: (_) => controller.alternarFiltroComDivida(false),
              ),
              const SizedBox(width: 8),
              FilterChip(
                key: const Key('chip_filter_debt'),
                label: Text(
                  'Com dívida (${controller.customersWithDebtCount})',
                ),
                selected: controller.onlyWithDebt,
                onSelected: (selected) =>
                    controller.alternarFiltroComDivida(selected),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onOpenDetail;
  final VoidCallback onPurchase;
  final VoidCallback onPayment;

  const _CustomerCard({
    required this.customer,
    required this.onOpenDetail,
    required this.onPurchase,
    required this.onPayment,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = customer.creditLimit > 0
        ? (customer.currentDebt / customer.creditLimit).clamp(0.0, 1.0)
        : 0.0;

    final bool hasDebt = customer.currentDebt > 0;
    final bool isNearLimit = ratio >= 0.8;

    final Color statusBg = !hasDebt
        ? const Color(0xFFDCFCE7)
        : isNearLimit
            ? const Color(0xFFFEE2E2)
            : const Color(0xFFFEF3C7);
    final Color statusFg = !hasDebt
        ? const Color(0xFF15803D)
        : isNearLimit
            ? const Color(0xFFB91C1C)
            : const Color(0xFFB45309);
    final String statusText = !hasDebt
        ? 'Em dia'
        : isNearLimit
            ? 'Limite próximo'
            : 'Fiado ativo';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onOpenDetail,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 21,
                    backgroundColor: const Color(0xFFCCFBF1),
                    child: Text(
                      customer.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F766E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Contato: ${customer.phone}',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: statusFg,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dívida: ${CurrencyFormatter.format(customer.currentDebt)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: hasDebt
                          ? const Color(0xFFB91C1C)
                          : const Color(0xFF15803D),
                    ),
                  ),
                  Text(
                    'Disp: ${CurrencyFormatter.format(customer.availableCredit)} / ${CurrencyFormatter.format(customer.creditLimit)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isNearLimit
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF0D9488),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      key: Key('btn_purchase_${customer.id}'),
                      onPressed: onPurchase,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFC2410C),
                        side: const BorderSide(color: Color(0xFFFED7AA)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
                        size: 16,
                      ),
                      label: const Text(
                        'Fiado',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      key: Key('btn_payment_${customer.id}'),
                      onPressed: onPayment,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF15803D),
                        side: const BorderSide(color: Color(0xFFBBF7D0)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      icon: const Icon(Icons.payments_outlined, size: 16),
                      label: const Text(
                        'Receber',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    key: Key('btn_detail_${customer.id}'),
                    tooltip: 'Ver extrato completo',
                    onPressed: onOpenDetail,
                    icon: const Icon(Icons.receipt_long_outlined, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCadernetaView extends StatelessWidget {
  final VoidCallback onAddCustomer;

  const _EmptyCadernetaView({required this.onAddCustomer});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Color(0xFFCCFBF1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 44,
                color: Color(0xFF0F766E),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhum cliente cadastrado no fiado.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Cadastre seu primeiro cliente com limite de crédito aprovado para começar a anotar compras.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onAddCustomer,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
              ),
              icon: const Icon(Icons.person_add_alt_1_rounded),
              label: const Text('Cadastrar Primeiro Cliente'),
            ),
          ],
        ),
      ),
    );
  }
}
