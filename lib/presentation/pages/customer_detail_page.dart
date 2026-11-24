import 'package:flutter/material.dart';
import 'package:caderneta_digital_fiado/domain/entities/credit_transaction.dart';
import 'package:caderneta_digital_fiado/domain/entities/customer.dart';
import 'package:caderneta_digital_fiado/presentation/controllers/caderneta_controller.dart';
import 'package:caderneta_digital_fiado/presentation/utils/currency_formatter.dart';
import 'package:caderneta_digital_fiado/presentation/widgets/operation_sheets.dart';

/// Tela de Ficha Individual e Extrato Contábil do Cliente.
class CustomerDetailPage extends StatelessWidget {
  final CadernetaController controller;
  final String customerId;

  const CustomerDetailPage({
    super.key,
    required this.controller,
    required this.customerId,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final customer = controller.buscarClientePorId(customerId);
        if (customer == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cliente')),
            body: const Center(child: Text('Cliente não encontrado.')),
          );
        }

        final usageRatio = customer.creditLimit > 0
            ? (customer.currentDebt / customer.creditLimit).clamp(0.0, 1.0)
            : 0.0;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: const Text(
              'Ficha de Fiado',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            backgroundColor: const Color(0xFF0F766E),
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              _CustomerFinancialHeader(
                customer: customer,
                usageRatio: usageRatio,
                onPurchaseTap: () => showRecordPurchaseModal(
                  context,
                  controller,
                  customer,
                ),
                onPaymentTap: () => showProcessPaymentModal(
                  context,
                  controller,
                  customer,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<CreditTransaction>>(
                  future: controller.carregarExtratoCliente(customer.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final transactions = snapshot.data ?? const [];
                    if (transactions.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48,
                                color: Color(0xFF94A3B8),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Nenhuma movimentação registrada ainda.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF475569),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Toque em "Anotar Compra" para lançar o primeiro fiado.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                          child: Text(
                            'Extrato de Lançamentos (${transactions.length})',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                            itemCount: transactions.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final tx = transactions[index];
                              return _TransactionTile(transaction: tx);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CustomerFinancialHeader extends StatelessWidget {
  final Customer customer;
  final double usageRatio;
  final VoidCallback onPurchaseTap;
  final VoidCallback onPaymentTap;

  const _CustomerFinancialHeader({
    required this.customer,
    required this.usageRatio,
    required this.onPurchaseTap,
    required this.onPaymentTap,
  });

  @override
  Widget build(BuildContext context) {
    final barColor = usageRatio >= 0.85
        ? const Color(0xFFDC2626)
        : usageRatio >= 0.6
            ? const Color(0xFFD97706)
            : const Color(0xFF0D9488);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFFCCFBF1),
                child: Text(
                  customer.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 20,
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
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Contato: ${customer.phone}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Dívida Atual',
                  value: CurrencyFormatter.format(customer.currentDebt),
                  valueColor: customer.currentDebt > 0
                      ? const Color(0xFFB91C1C)
                      : const Color(0xFF15803D),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Disponível',
                  value: CurrencyFormatter.format(customer.availableCredit),
                  valueColor: const Color(0xFF0F766E),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Limite Total',
                  value: CurrencyFormatter.format(customer.creditLimit),
                  valueColor: const Color(0xFF334155),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: usageRatio,
              minHeight: 8,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Uso do limite aprovado: ${(usageRatio * 100).toStringAsFixed(0)}%',
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  key: const Key('detail_btn_purchase'),
                  onPressed: onPurchaseTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFC2410C),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 18),
                  label: const Text('Anotar Compra'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  key: const Key('detail_btn_payment'),
                  onPressed: onPaymentTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF15803D),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.payments_outlined, size: 18),
                  label: const Text('Receber Valor'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _MetricBox({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final CreditTransaction transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPurchase = transaction.type == TransactionType.purchase;
    final badgeBg =
        isPurchase ? const Color(0xFFFFEDD5) : const Color(0xFFDCFCE7);
    final accent =
        isPurchase ? const Color(0xFFC2410C) : const Color(0xFF15803D);
    final sign = isPurchase ? '+' : '-';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPurchase
                  ? Icons.shopping_bag_outlined
                  : Icons.payments_outlined,
              color: accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${isPurchase ? 'Compra fiada' : 'Amortização'} • ${CurrencyFormatter.formatDateTime(transaction.timestamp)}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$sign ${CurrencyFormatter.format(transaction.amount)}',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}
