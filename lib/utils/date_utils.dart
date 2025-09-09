import 'package:intl/intl.dart';

class XpensoDateUtils {
  // Format date as "MMM dd, yyyy"
  static String formatDisplayDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Format date as "yyyy-MM-dd"
  static String formatISODate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Format date as "EEEE, MMM dd, yyyy"
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, MMM dd, yyyy').format(date);
  }

  // Format date as "MMM dd"
  static String formatShortDate(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  // Format date as "HH:mm"
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  // Format date as "MMM dd, yyyy HH:mm"
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }

  // Get the start of the current week (Monday)
  static DateTime getStartOfWeek(DateTime date) {
    int decreaseNum = date.weekday - 1;
    return date.subtract(Duration(days: decreaseNum));
  }

  // Get the end of the current week (Sunday)
  static DateTime getEndOfWeek(DateTime date) {
    int increaseNum = 7 - date.weekday;
    return date.add(Duration(days: increaseNum));
  }

  // Get the start of the current month
  static DateTime getStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Get the end of the current month
  static DateTime getEndOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  // Get the start of the current year
  static DateTime getStartOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }

  // Get the end of the current year
  static DateTime getEndOfYear(DateTime date) {
    return DateTime(date.year, 12, 31);
  }

  // Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Get the number of days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}