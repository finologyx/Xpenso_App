import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._();
  static AuthService get instance => _instance;

  AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Email and password sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // Email and password registration
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    // Create user document in Firestore
    XpensoUser user = XpensoUser(
      uid: userCredential.user!.uid,
      email: email,
      name: name,
      isPro: false,
      createdAt: DateTime.now(),
      isActive: true,
      lastLoginAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .set(user.toFirestore());

    return userCredential;
  }

  // Google Sign In
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'google_sign_in_aborted',
        message: 'Google Sign In was aborted by the user',
      );
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    // Create or update user document in Firestore
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userCredential.user!.uid).get();

    if (!userDoc.exists) {
      XpensoUser user = XpensoUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email ?? '',
        name: userCredential.user!.displayName ?? 'Anonymous',
        photoUrl: userCredential.user!.photoURL,
        isPro: false,
        createdAt: DateTime.now(),
        isActive: true,
        lastLoginAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toFirestore());
    } else {
      // Update last login time
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .update({'lastLoginAt': FieldValue.serverTimestamp()});
    }

    return userCredential;
  }

  // Phone authentication
  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(PhoneAuthCredential) verificationCompleted,
    Function(FirebaseAuthException) verificationFailed,
    Function(String, int?) codeSent,
    Function(String) codeAutoRetrievalTimeout,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      timeout: const Duration(seconds: 60),
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Get user document from Firestore
  Future<XpensoUser?> getUserDocument(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return XpensoUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // Get current user document from Firestore
  Future<XpensoUser?> getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user == null) return null;
    return getUserDocument(user.uid);
  }
}