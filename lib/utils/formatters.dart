// lib/utils/formatters.dart
import 'package:intl/intl.dart';

class Formatters {
  static String formatPrice(double price) {
    final formatter = NumberFormat.decimalPattern('es_PE');
    return 'S/${formatter.format(price)}';
  }

  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm'); // sin locale
    return formatter.format(date);
  }
}