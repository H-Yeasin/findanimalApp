import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Formatters {
  const Formatters._();

  static String date(
    DateTime date, {
    String pattern = 'dd MMM yyyy',
    String? locale,
  }) {
    return DateFormat(pattern, locale).format(date);
  }

  static String compactDate(DateTime date, {String? locale}) {
    return Formatters.date(date, pattern: 'dd/MM/yy', locale: locale);
  }

  static String dateTime(DateTime date, {String? locale}) {
    return Formatters.date(date, pattern: 'dd MMM yyyy, HH:mm', locale: locale);
  }

  static String recentOrDateTime(
    DateTime date, {
    required String locale,
    String pattern = 'HH:mm - dd MMM yyyy',
  }) {
    final localDate = date.toLocal();
    final now = DateTime.now();
    final isToday =
        now.year == localDate.year &&
        now.month == localDate.month &&
        now.day == localDate.day;

    if (isToday) {
      return timeago.format(localDate, locale: locale);
    }

    return Formatters.date(localDate, pattern: pattern, locale: locale);
  }
}
