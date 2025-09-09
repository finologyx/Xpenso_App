import '../models/category.dart';

class AppConstants {
  // App name
  static const String appName = 'Xpenso';

  // Default currency
  static const String defaultCurrency = 'USD';

  // Default categories
  static final List<Category> defaultCategories = [
    Category(
      id: 'food',
      name: 'Food & Dining',
      icon: '🍔',
      isCustom: false,
      createdAt: DateTime(2023, 1, 1),
      color: '#FF5722',
    ),
    Category(
      id: 'transport',
      name: 'Transportation',
      icon: '🚗',
      isCustom: false,
      createdAt: DateTime(2023, 1, 1),
      color: '#2196F3',
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      icon: '🛍️',
      isCustom: false,
      createdAt: DateTime(2023, 1, 1),
      color: '#4CAF50',
    ),
    Category(
      id: 'bills',
      name: 'Bills & Utilities',
      icon: '💡',
      isCustom: false,
      createdAt: DateTime(2023, 1, 1),
      color: '#9C27B0',
    ),
    Category(
      id: 'entertainment',
      name: 'Entertainment',
      icon: '🎬',
      isCustom: false,
      createdAt: DateTime(2023, 1, 1),
      color: '#FF9800',
    ),
    Category(
      id: 'health',
      name: 'Health & Fitness',
      icon: '🏥',
      isCustom: false,
      createdAt: DateTime(2023, 1, 1),
      color: '#E91E63',
    ),
    Category(
      id: 'travel',
      name: 'Travel',
      icon: '✈️',
      isCustom: false,
      createdAt: DateTime(2023, 1, 1),
      color: '#3F51B5',
    ),
    Category(
      id: 'education',
      name: 'Education',
      icon: '📚',
      isCustom: false,
      createdAt: DateTime(2023, 1, 1),
      color: '#00BCD4',
    ),
    Category(
      id: 'groceries',
      name: 'Groceries',
      icon: '🛒',
      isCustom: false,
      createdAt: DateTime(2023, 1, 1),
      color: '#8BC34A',
    ),
    Category(
      id: 'gifts',
      name: 'Gifts & Donations',
      icon: '🎁',
      isCustom: false,
      createdAt: DateTime(2023, 1, 1),
      color: '#795548',
    ),
  ];

  // Payment methods
  static const List<String> paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'Digital Wallet',
    'Check',
  ];

  // Currencies
  static const Map<String, String> currencies = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'CAD': 'Canadian Dollar',
    'AUD': 'Australian Dollar',
    'CHF': 'Swiss Franc',
    'CNY': 'Chinese Yuan',
    'INR': 'Indian Rupee',
    'BRL': 'Brazilian Real',
    'MXN': 'Mexican Peso',
    'SGD': 'Singapore Dollar',
  };

  // Theme colors
  static const Map<String, Map<String, String>> themes = {
    'red': {
      'primary': '#F44336',
      'secondary': '#D32F2F',
      'background': '#FFFFFF',
      'card': '#FFFFFF',
      'text': '#212121',
      'accent': '#FFCDD2',
    },
    'blue': {
      'primary': '#2196F3',
      'secondary': '#1976D2',
      'background': '#FFFFFF',
      'card': '#FFFFFF',
      'text': '#212121',
      'accent': '#BBDEFB',
    },
    'dark': {
      'primary': '#2196F3',
      'secondary': '#1976D2',
      'background': '#121212',
      'card': '#1E1E1E',
      'text': '#E0E0E0',
      'accent': '#BBDEFB',
    },
  };
}