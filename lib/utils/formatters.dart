import 'package:intl/intl.dart';

class Formatters {
  static String formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'es_CL',
      symbol: '\$',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }
}

