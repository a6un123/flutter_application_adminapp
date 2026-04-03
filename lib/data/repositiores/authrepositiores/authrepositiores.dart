import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> login({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    final user = credential.user;
    if (user != null) {
      // Check role
      final role = await getUserRole(user.uid);
      if (role != 'admin') {
        await _auth.signOut();
        throw Exception('Access denied. Admin accounts only.');
      }
    }
    return user;
  }

  Future<String> getUserRole(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data()?['role'] ?? 'user';
    } catch (e) {
      return 'user';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
