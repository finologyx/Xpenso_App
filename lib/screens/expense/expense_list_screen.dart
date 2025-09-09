import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/expense.dart';
import '../../services/expense_service.dart';
import '../../widgets/expense_card.dart';
import '../../widgets/banner_ad_widget.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  late Stream<List<Expense>> _expensesStream;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _expensesStream = ExpenseService.instance.getUserExpenses(user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return const SizedBox();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Expense>>(
              stream: _expensesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading expenses'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 100,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'No expenses yet',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Add your first expense to get started',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final expenses = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    return ExpenseCard(expense: expenses[index]);
                  },
                );
              },
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}