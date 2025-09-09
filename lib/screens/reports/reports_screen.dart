import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/expense_service.dart';
import '../../utils/currency_utils.dart';
import '../../utils/date_utils.dart';
import '../../widgets/banner_ad_widget.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  Map<String, double> _categoryExpenses = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (user == null) return;

    try {
      final categoryExpenses = await ExpenseService.instance.getExpensesByCategory(
        user!.uid,
        _startDate,
        _endDate,
      );
      setState(() {
        _categoryExpenses = categoryExpenses;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading report data')),
        );
      }
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    if (picked != null && (picked.start != _startDate || picked.end != _endDate)) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadData();
    }
  }

  List<PieChartSectionData> _generatePieChartSections() {
    if (_categoryExpenses.isEmpty) return [];

    final total = _categoryExpenses.values.fold(0.0, (a, b) => a + b);
    final List<PieChartSectionData> sections = [];

    final sortedCategories = _categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.yellow,
      Colors.brown,
      Colors.cyan,
    ];

    for (int i = 0; i < sortedCategories.length && i < 10; i++) {
      final entry = sortedCategories[i];
      final percentage = (entry.value / total) * 100;
      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: entry.value,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Expense Report',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _selectDateRange,
                        child: Text(
                          '${XpensoDateUtils.formatShortDate(_startDate)} - ${XpensoDateUtils.formatShortDate(_endDate)}',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_categoryExpenses.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text('No expense data available for the selected period'),
                      ),
                    )
                  else ...[
                    const Text(
                      'Expenses by Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          sections: _generatePieChartSections(),
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Category Breakdown',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _categoryExpenses.length,
                        itemBuilder: (context, index) {
                          final entry = _categoryExpenses.entries.toList()[index];
                          final total = _categoryExpenses.values.fold(0.0, (a, b) => a + b);
                          final percentage = (entry.value / total) * 100;
                          return ListTile(
                            title: Text(entry.key),
                            trailing: Text(
                              '${CurrencyUtils.formatCurrency(entry.value, 'USD')} (${percentage.toStringAsFixed(1)}%)',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}