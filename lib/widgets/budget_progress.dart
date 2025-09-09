import 'package:flutter/material.dart';
import '../models/budget.dart';
import '../utils/currency_utils.dart';

class BudgetProgress extends StatelessWidget {
  final Budget budget;

  const BudgetProgress({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final double progress = budget.amount > 0 ? (budget.spent / budget.amount) * 100 : 0;
    final Color progressColor = progress >= 100 ? Colors.red : (progress >= 80 ? Colors.orange : Colors.green);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budget.category == 'Overall' ? 'Overall Budget' : budget.category,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${progress.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: progressColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${CurrencyUtils.formatCurrency(budget.spent, 'USD')} spent',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${CurrencyUtils.formatCurrency(budget.amount, 'USD')} budget',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}