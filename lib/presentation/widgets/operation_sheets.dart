import 'package:flutter/material.dart';
import 'package:caderneta_digital_fiado/domain/entities/customer.dart';
import 'package:caderneta_digital_fiado/presentation/controllers/caderneta_controller.dart';
import 'package:caderneta_digital_fiado/presentation/utils/currency_formatter.dart';

/// Abre o modal de cadastro de novo cliente (Regra 1).
Future<bool?> showRegisterCustomerModal(
  BuildContext context,
  CadernetaController controller,
) {
  controller.limparErro();
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => _RegisterCustomerSheet(controller: controller),
  );
}

/// Abre o modal de lançamento de compra fiada (Regra 2).
Future<bool?> showRecordPurchaseModal(
  BuildContext context,
  CadernetaController controller,
  Customer customer,
) {
  controller.limparErro();
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => _RecordPurchaseSheet(
      controller: controller,
      customer: customer,
    ),
  );
}

/// Abre o modal de baixa / amortização de pagamento (Regra 3).
Future<bool?> showProcessPaymentModal(
  BuildContext context,
  CadernetaController controller,
  Customer customer,
) {
  controller.limparErro();
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => _ProcessPaymentSheet(
      controller: controller,
      customer: customer,
    ),
  );
}

class _RegisterCustomerSheet extends StatefulWidget {
  final CadernetaController controller;

  const _RegisterCustomerSheet({required this.controller});

  @override
  State<_RegisterCustomerSheet> createState() => _RegisterCustomerSheetState();
}

class _RegisterCustomerSheetState extends State<_RegisterCustomerSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _limitController = TextEditingController(text: '300,00');
  String? _localError;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final limit = CurrencyFormatter.tryParse(_limitController.text);
    if (limit == null) {
      setState(() {
        _localError = 'Informe um valor numérico válido para o limite de crédito.';
      });
      return;
    }

    setState(() => _localError = null);

    final ok = await widget.controller.cadastrarCliente(
      name: _nameController.text,
      phone: _phoneController.text.trim().isEmpty
          ? 'Não informado'
          : _phoneController.text,
      limit: limit,
    );

    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente cadastrado com saldo devedor R\$ 0,00!'),
          backgroundColor: Color(0xFF0F766E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        _localError = widget.controller.errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SheetHandle(),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Color(0xFF0F766E),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Novo Cliente na Caderneta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Inicia automaticamente com dívida R\$ 0,00',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            key: const Key('input_customer_name'),
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nome completo do cliente',
              hintText: 'Ex: Dona Maria da Silva',
              prefixIcon: Icon(Icons.badge_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            key: const Key('input_customer_phone'),
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Telefone / WhatsApp',
              hintText: 'Ex: (47) 99988-7766',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            key: const Key('input_customer_limit'),
            controller: _limitController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Limite máximo de fiado (R\$)',
              prefixIcon: Icon(Icons.shield_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              for (final preset in const [150.0, 300.0, 500.0])
                ActionChip(
                  label: Text('Limite ${CurrencyFormatter.format(preset)}'),
                  onPressed: () {
                    _limitController.text = preset.toStringAsFixed(2).replaceAll('.', ',');
                  },
                ),
            ],
          ),
          if (_localError != null) ...[
            const SizedBox(height: 14),
            _DomainRuleErrorBox(
              title: 'Validação de Cadastro',
              message: _localError!,
            ),
          ],
          const SizedBox(height: 20),
          FilledButton.icon(
            key: const Key('btn_confirm_register'),
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text(
              'Cadastrar Cliente',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordPurchaseSheet extends StatefulWidget {
  final CadernetaController controller;
  final Customer customer;

  const _RecordPurchaseSheet({
    required this.controller,
    required this.customer,
  });

  @override
  State<_RecordPurchaseSheet> createState() => _RecordPurchaseSheetState();
}

class _RecordPurchaseSheetState extends State<_RecordPurchaseSheet> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = CurrencyFormatter.tryParse(_amountController.text);
    if (amount == null) {
      setState(() {
        _localError = 'Informe um valor numérico válido para a compra.';
      });
      return;
    }

    final description = _descriptionController.text.trim().isEmpty
        ? 'Compra no balcão'
        : _descriptionController.text.trim();

    setState(() => _localError = null);

    final ok = await widget.controller.registrarCompra(
      customerId: widget.customer.id,
      amount: amount,
      description: description,
    );

    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Compra de ${CurrencyFormatter.format(amount)} anotada para ${widget.customer.name}!',
          ),
          backgroundColor: const Color(0xFF0F766E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        _localError = widget.controller.errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final currentCustomer =
        widget.controller.buscarClientePorId(widget.customer.id) ??
            widget.customer;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SheetHandle(),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFFC2410C),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anotar Fiado • ${currentCustomer.name}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Crédito disponível: ${CurrencyFormatter.format(currentCustomer.availableCredit)} (Limite: ${CurrencyFormatter.format(currentCustomer.creditLimit)})',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F766E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              ActionChip(
                avatar: const Icon(Icons.bakery_dining_outlined, size: 16),
                label: const Text('Pão e Leite (R\$ 25,00)'),
                onPressed: () {
                  _descriptionController.text = 'Pão francês, leite e café';
                  _amountController.text = '25,00';
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.shopping_basket_outlined, size: 16),
                label: const Text('Mercearia (R\$ 85,50)'),
                onPressed: () {
                  _descriptionController.text = 'Arroz 5kg, feijão e óleo';
                  _amountController.text = '85,50';
                },
              ),
              ActionChip(
                avatar: const Icon(Icons.warning_amber_rounded, size: 16),
                label: const Text('Testar Estouro (+R\$ 500)'),
                onPressed: () {
                  _descriptionController.text = 'Compra acima do teto';
                  _amountController.text = '500,00';
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            key: const Key('input_purchase_description'),
            controller: _descriptionController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Itens da compra',
              hintText: 'Ex: 5kg Arroz, Feijão e Café',
              prefixIcon: Icon(Icons.receipt_long_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            key: const Key('input_purchase_amount'),
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Valor da compra (R\$)',
              hintText: 'Ex: 45,90',
              prefixIcon: Icon(Icons.attach_money_rounded),
              border: OutlineInputBorder(),
            ),
          ),
          if (_localError != null) ...[
            const SizedBox(height: 14),
            _DomainRuleErrorBox(
              title: 'Trava Automática de Crédito Acionada',
              message: _localError!,
            ),
          ],
          const SizedBox(height: 20),
          FilledButton.icon(
            key: const Key('btn_confirm_purchase'),
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFC2410C),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add_shopping_cart_rounded),
            label: const Text(
              'Confirmar Compra no Fiado',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessPaymentSheet extends StatefulWidget {
  final CadernetaController controller;
  final Customer customer;

  const _ProcessPaymentSheet({
    required this.controller,
    required this.customer,
  });

  @override
  State<_ProcessPaymentSheet> createState() => _ProcessPaymentSheetState();
}

class _ProcessPaymentSheetState extends State<_ProcessPaymentSheet> {
  final _amountController = TextEditingController();
  final _descriptionController =
      TextEditingController(text: 'Pagamento recebido no balcão');
  String? _localError;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = CurrencyFormatter.tryParse(_amountController.text);
    if (amount == null) {
      setState(() {
        _localError = 'Informe um valor numérico válido para o pagamento.';
      });
      return;
    }

    setState(() => _localError = null);

    final ok = await widget.controller.baixarPagamento(
      customerId: widget.customer.id,
      amount: amount,
      description: _descriptionController.text,
    );

    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pagamento de ${CurrencyFormatter.format(amount)} registrado com sucesso!',
          ),
          backgroundColor: const Color(0xFF15803D),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      setState(() {
        _localError = widget.controller.errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final currentCustomer =
        widget.controller.buscarClientePorId(widget.customer.id) ??
            widget.customer;
    final debt = currentCustomer.currentDebt;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SheetHandle(),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: Color(0xFF15803D),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Receber Pagamento • ${currentCustomer.name}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Dívida pendente: ${CurrencyFormatter.format(debt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB91C1C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (debt > 0)
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                ActionChip(
                  key: const Key('chip_pay_full'),
                  avatar: const Icon(Icons.done_all_rounded, size: 16),
                  label: Text('Quitar Total (${CurrencyFormatter.format(debt)})'),
                  onPressed: () {
                    _amountController.text =
                        debt.toStringAsFixed(2).replaceAll('.', ',');
                    _descriptionController.text = 'Quitação total da caderneta';
                  },
                ),
                if (debt >= 20)
                  ActionChip(
                    label: Text(
                      'Metade (${CurrencyFormatter.format(debt / 2)})',
                    ),
                    onPressed: () {
                      _amountController.text =
                          (debt / 2).toStringAsFixed(2).replaceAll('.', ',');
                      _descriptionController.text =
                          'Amortização parcial de fiado';
                    },
                  ),
              ],
            ),
          const SizedBox(height: 14),
          TextField(
            key: const Key('input_payment_amount'),
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Valor recebido (R\$)',
              hintText: 'Ex: 50,00',
              prefixIcon: Icon(Icons.savings_outlined),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            key: const Key('input_payment_description'),
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Observação',
              prefixIcon: Icon(Icons.notes_rounded),
              border: OutlineInputBorder(),
            ),
          ),
          if (_localError != null) ...[
            const SizedBox(height: 14),
            _DomainRuleErrorBox(
              title: 'Bloqueio Contábil (Saldo Negativo Impedido)',
              message: _localError!,
            ),
          ],
          const SizedBox(height: 20),
          FilledButton.icon(
            key: const Key('btn_confirm_payment'),
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF15803D),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.check_circle_outline),
            label: const Text(
              'Registrar Baixa de Pagamento',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _DomainRuleErrorBox extends StatelessWidget {
  final String title;
  final String message;

  const _DomainRuleErrorBox({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('domain_error_banner'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.gpp_maybe_rounded,
            color: Color(0xFFB91C1C),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF991B1B),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF7F1D1D),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
