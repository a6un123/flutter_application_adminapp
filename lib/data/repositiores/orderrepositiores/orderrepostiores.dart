import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_adminapp/data/model/ordermodeles/ordermodel.dart';

class OrderRepository {
  final _db = FirebaseFirestore.instance;
  final String _collection = 'orders';

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

  // Update status + save date timestamp
  Future<void> updateStatus(String orderId, String status) async {
    // Map status to date field
    final dateField = switch (status) {
      'confirmed' => 'confirmedAt',
      'shipped' => 'shippedAt',
      'delivered' => 'deliveredAt',
      'cancelled' => 'cancelledAt',
      _ => null,
    };

    final Map<String, dynamic> updateData = {'status': status};

    // Add date timestamp for this status
    if (dateField != null) {
      updateData[dateField] = FieldValue.serverTimestamp();
    }

    await _db.collection(_collection).doc(orderId).update(updateData);
  }

  Future<void> cancelOrder(String orderId) async {
    await _db.collection(_collection).doc(orderId).update({
      'status': 'cancelled',
      'cancelledAt': FieldValue.serverTimestamp(),
    });
  }
}
