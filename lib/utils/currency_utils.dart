import 'package:intl/intl.dart';

class CurrencyUtils {
  // Format amount with currency symbol
  static String formatCurrency(double amount, String currencyCode) {
    final format = NumberFormat.simpleCurrency(
      name: currencyCode,
      decimalDigits: 2,
    );
    return format.format(amount);
  }

  // Format amount without currency symbol
  static String formatAmount(double amount) {
    final format = NumberFormat.decimalPattern();
    return format.format(amount);
  }

  // Parse currency string to double
  static double parseCurrency(String amount) {
    try {
      // Remove currency symbols and commas
      String cleanedAmount = amount.replaceAll(RegExp(r'[^\d.-]'), '');
      return double.parse(cleanedAmount);
    } catch (e) {
      return 0.0;
    }
  }

  // Get currency symbol from code
  static String getCurrencySymbol(String currencyCode) {
    try {
      final format = NumberFormat.simpleCurrency(name: currencyCode);
      return format.currencySymbol;
    } catch (e) {
      return currencyCode;
    }
  }

  // Get list of currency symbols and codes
  static Map<String, String> getCurrencyOptions() {
    return {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CAD': 'CA\$',
      'AUD': 'A\$',
      'CHF': 'CHF',
      'CNY': '¥',
      'INR': '₹',
      'BRL': 'R\$',
      'MXN': '\$',
      'SGD': 'S\$',
    };
  }
}