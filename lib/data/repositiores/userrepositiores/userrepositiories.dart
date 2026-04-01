import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_adminapp/data/model/usersmodel/usersmodel.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  // Stream current user
  Stream<UserModel?> streamCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);
    return _db
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  // Update profile
  Future<void> updateProfile({
    required String uid,
    required String name,
    String phone = '',
  }) async {
    await _db.collection('users').doc(uid).update({
      'name': name,
      'phone': phone,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _auth.currentUser?.updateDisplayName(name);
  }

  // Stream all users
  Stream<List<UserModel>> getAllUsers() {
    return _db
        .collection('users')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => UserModel.fromFirestore(doc)).toList(),
        );
  }

  // Stream only customers
  Stream<List<UserModel>> getCustomers() {
    return _db
        .collection('users')
        .where('role', isEqualTo: 'user')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => UserModel.fromFirestore(doc)).toList(),
        );
  }
}
