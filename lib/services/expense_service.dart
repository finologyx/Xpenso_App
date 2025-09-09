import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  static final ExpenseService _instance = ExpenseService._();
  static ExpenseService get instance => _instance;

  ExpenseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _firestore.collection('expenses').doc(expense.id).set(expense.toFirestore());
  }

  // Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    await _firestore.collection('expenses').doc(expense.id).update(expense.toFirestore());
  }

  // Delete an expense
  Future<void> deleteExpense(String expenseId) async {
    await _firestore.collection('expenses').doc(expenseId).delete();
  }

  // Get all expenses for a user
  Stream<List<Expense>> getUserExpenses(String userId) {
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
    });
  }

  // Get expenses for a specific date range
  Stream<List<Expense>> getUserExpensesByDateRange(String userId, DateTime startDate, DateTime endDate) {
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
    });
  }

  // Get expenses by category
  Stream<List<Expense>> getUserExpensesByCategory(String userId, String category) {
    return _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
    });
  }

  // Get a specific expense by ID
  Future<Expense?> getExpenseById(String expenseId) async {
    DocumentSnapshot doc = await _firestore.collection('expenses').doc(expenseId).get();
    if (doc.exists) {
      return Expense.fromFirestore(doc);
    }
    return null;
  }

  // Get total expenses for a user in a date range
  Future<double> getTotalExpenses(String userId, DateTime startDate, DateTime endDate) async {
    QuerySnapshot snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
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

  // Get expenses grouped by category
  Future<Map<String, double>> getExpensesByCategory(String userId, DateTime startDate, DateTime endDate) async {
    QuerySnapshot snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    Map<String, double> categoryTotals = {};
    for (var doc in snapshot.docs) {
      Expense expense = Expense.fromFirestore(doc);
      if (categoryTotals.containsKey(expense.category)) {
        categoryTotals[expense.category] = categoryTotals[expense.category]! + expense.amount;
      } else {
        categoryTotals[expense.category] = expense.amount;
      }
    }

    return categoryTotals;
  }

  // Get recent expenses (last 5)
  Future<List<Expense>> getRecentExpenses(String userId, int limit) async {
    QuerySnapshot snapshot = await _firestore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => Expense.fromFirestore(doc)).toList();
  }
}