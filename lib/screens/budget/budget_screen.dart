import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/budget.dart';
import '../../services/budget_service.dart';
import '../../widgets/budget_progress.dart';
import '../../widgets/banner_ad_widget.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late Stream<List<Budget>> _budgetsStream;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _budgetsStream = BudgetService.instance.getUserBudgets(user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return const SizedBox();

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Budget>>(
              stream: _budgetsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading budgets'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          size: 100,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'No budgets yet',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Create your first budget to get started',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final budgets = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    return BudgetProgress(budget: budgets[index]);
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