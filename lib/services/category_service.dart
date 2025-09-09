import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class CategoryService {
  static final CategoryService _instance = CategoryService._();
  static CategoryService get instance => _instance;

  CategoryService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new category
  Future<void> addCategory(Category category) async {
    await _firestore.collection('categories').doc(category.id).set(category.toFirestore());
  }

  // Update an existing category
  Future<void> updateCategory(Category category) async {
    await _firestore.collection('categories').doc(category.id).update(category.toFirestore());
  }

  // Delete a category
  Future<void> deleteCategory(String categoryId) async {
    await _firestore.collection('categories').doc(categoryId).delete();
  }

  // Get all default categories
  Stream<List<Category>> getDefaultCategories() {
    return _firestore
        .collection('categories')
        .where('isCustom', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    });
  }

  // Get all categories for a user (including custom ones)
  Stream<List<Category>> getUserCategories(String userId) {
    return _firestore
        .collection('categories')
        .where(Filter.or(
          Filter('isCustom', isEqualTo: false),
          Filter('userId', isEqualTo: userId),
        ))
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    });
  }

  // Get a specific category by ID
  Future<Category?> getCategoryById(String categoryId) async {
    DocumentSnapshot doc = await _firestore.collection('categories').doc(categoryId).get();
    if (doc.exists) {
      return Category.fromFirestore(doc);
    }
    return null;
  }

  // Get category by name
  Future<Category?> getCategoryByName(String name) async {
    QuerySnapshot snapshot = await _firestore
        .collection('categories')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Category.fromFirestore(snapshot.docs.first);
    }
    return null;
  }
}