import 'package:intl/intl.dart';

class DateUtilsHelper {
  static String formatDisplay(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatIso(DateTime date) {
    return date.toIso8601String();
  }
}
