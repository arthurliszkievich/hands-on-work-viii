/// Utilitários puros de formatação monetária (BRL) e datas para a interface.
class CurrencyFormatter {
  const CurrencyFormatter._();

  /// Formata um double no padrão brasileiro: R$ 1.234,56
  static String format(double value) {
    final isNegative = value < 0;
    final fixed = value.abs().toStringAsFixed(2);
    final parts = fixed.split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    final buffer = StringBuffer();
    for (var i = 0; i < integerPart.length; i++) {
      final positionFromRight = integerPart.length - i;
      buffer.write(integerPart[i]);
      if (positionFromRight > 1 && positionFromRight % 3 == 1) {
        buffer.write('.');
      }
    }

    final prefix = isNegative ? '-R\$ ' : 'R\$ ';
    return '$prefix${buffer.toString()},$decimalPart';
  }

  /// Converte texto digitado pelo usuário ("85,50", "85.50", "1.200,00") em double.
  static double? tryParse(String raw) {
    var cleaned = raw.replaceAll('R\$', '').trim();
    if (cleaned.isEmpty) return null;

    if (cleaned.contains(',') && cleaned.contains('.')) {
      cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
    } else if (cleaned.contains(',')) {
      cleaned = cleaned.replaceAll(',', '.');
    }

    return double.tryParse(cleaned);
  }

  /// Formata data e hora curta para o extrato: 24/11/2026 • 16:30
  static String formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year • $hour:$minute';
  }
}
