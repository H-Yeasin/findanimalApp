import 'package:intl/intl.dart';

class Formatters {
  const Formatters._();

  static String date(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}
