import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_adminapp/data/model/productmodels/productmodels.dart';

class ProductRepository {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final String _collection = 'products';

  // Stream all products
  Stream<List<Productmodel>> getProducts() {
    return _db
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => Productmodel.fromFirestore(doc)).toList(),
        );
  }

  // Add product
  Future<void> addProduct(Productmodel product, {File? imageFile}) async {
    String imageUrl = product.imageUrl;
    if (imageFile != null) {
      final ref = _storage.ref().child(
        'products/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }
    await _db.collection(_collection).add({
      ...product.toFirestore(),
      'imageUrl': imageUrl,
    });
  }

  // Update product
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _db.collection(_collection).doc(id).update(data);
  }

  // Delete product
  Future<void> deleteProduct(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
}
