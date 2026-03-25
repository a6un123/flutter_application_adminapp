import 'package:equatable/equatable.dart';

abstract class AdminOrderEvent extends Equatable {
  const AdminOrderEvent();
  @override
  List<Object?> get props => [];
}

class LoadAllOrders extends AdminOrderEvent {}

class UpdateOrderStatus extends AdminOrderEvent {
  final String orderId;
  final String status;
  const UpdateOrderStatus({required this.orderId, required this.status});
  @override
  List<Object?> get props => [orderId, status];
}

class CancelOrder extends AdminOrderEvent {
  final String orderId;
  const CancelOrder(this.orderId);
  @override
  List<Object?> get props => [orderId];
}
