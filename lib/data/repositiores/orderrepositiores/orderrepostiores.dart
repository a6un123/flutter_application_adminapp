import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_adminapp/data/model/ordermodeles/ordermodel.dart';

class OrderRepository {
  final _db = FirebaseFirestore.instance;
  final String _collection = 'orders';

  // Stream ALL orders in real-time
  Stream<List<OrderModel>> getAllOrders() {
    return _db
        .collection(_collection)
        .orderBy('orderedAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => OrderModel.fromFirestore(doc)).toList(),
        );
  }

  // Update order status
  Future<void> updateStatus(String orderId, String status) async {
    await _db.collection(_collection).doc(orderId).update({'status': status});
  }

  // Cancel order
  Future<void> cancelOrder(String orderId) async {
    await _db.collection(_collection).doc(orderId).update({
      'status': 'cancelled',
    });
  }
}
