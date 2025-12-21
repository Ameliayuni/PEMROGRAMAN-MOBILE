// lib/utils/formatters.dart
import 'package:intl/intl.dart';

class Formatters {
  static String toRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy HH:mm').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yy').format(date);
  }
}