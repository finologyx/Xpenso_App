import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../services/category_service.dart';
import '../utils/currency_utils.dart';
import '../utils/date_utils.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: Text(
                    expense.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  CurrencyUtils.formatCurrency(expense.amount, expense.currency),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                FutureBuilder<Category?>(
                  future: CategoryService.instance.getCategoryById(expense.category),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }

                    if (snapshot.hasError || !snapshot.hasData) {
                      return const SizedBox();
                    }

                    final category = snapshot.data!;
                    return Row(
                      children: [
                        Text(category.icon),
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],
                    );
                  },
                ),
                const SizedBox(width: 16),
                Text(expense.paymentMethod),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  XpensoDateUtils.formatDisplayDate(expense.date),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                if (expense.tags.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    children: expense.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        padding: EdgeInsets.zero,
                        labelStyle: const TextStyle(fontSize: 10),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
              ],
            ),
            if (expense.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                expense.notes,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}