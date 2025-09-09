import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/budget.dart';
import '../models/expense.dart';

class BudgetService {
  static final BudgetService _instance = BudgetService._();
  static BudgetService get instance => _instance;

  BudgetService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new budget
  Future<void> addBudget(Budget budget) async {
    await _firestore.collection('budgets').doc(budget.id).set(budget.toFirestore());
  }

  // Update an existing budget
  Future<void> updateBudget(Budget budget) async {
    await _firestore.collection('budgets').doc(budget.id).update(budget.toFirestore());
  }

  // Delete a budget
  Future<void> deleteBudget(String budgetId) async {
    await _firestore.collection('budgets').doc(budgetId).delete();
  }

  // Get all budgets for a user
  Stream<List<Budget>> getUserBudgets(String userId) {
    return _firestore
        .collection('budgets')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Budget.fromFirestore(doc)).toList();
    });
  }

  // Get a specific budget by ID
  Future<Budget?> getBudgetById(String budgetId) async {
    DocumentSnapshot doc = await _firestore.collection('budgets').doc(budgetId).get();
    if (doc.exists) {
      return Budget.fromFirestore(doc);
    }
    return null;
  }

  // Get budget by category for a user
  Future<Budget?> getUserBudgetByCategory(String userId, String category) async {
    QuerySnapshot snapshot = await _firestore
        .collection('budgets')
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: category)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Budget.fromFirestore(snapshot.docs.first);
    }
    return null;
  }

  // Get total spent in a category for a user in a date range
  Future<double> getTotalSpentInCategory(String userId, String category, DateTime startDate, DateTime endDate) async {
    QuerySnapshot snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: category)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    double total = 0.0;
    for (var doc in snapshot.docs) {
      Expense expense = Expense.fromFirestore(doc);
      total += expense.amount;
    }

    return total;
  }

  // Update spent amount for a budget
  Future<void> updateBudgetSpent(String budgetId, double amount) async {
    await _firestore.collection('budgets').doc(budgetId).update({
      'spent': FieldValue.increment(amount),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get all active budgets for a user
  Stream<List<Budget>> getActiveUserBudgets(String userId) {
    return _firestore
        .collection('budgets')
        .where('userId', isEqualTo: userId)
        .where('endDate', isGreaterThanOrEqualTo: Timestamp.now())
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Budget.fromFirestore(doc)).toList();
    });
  }

  // Check if user has exceeded any budget
  Future<List<Budget>> getExceededBudgets(String userId) async {
    List<Budget> allBudgets = await getUserBudgets(userId).first;
    List<Budget> exceededBudgets = [];

    for (Budget budget in allBudgets) {
      if (budget.spent > budget.amount) {
        exceededBudgets.add(budget);
      }
    }

    return exceededBudgets;
  }
}