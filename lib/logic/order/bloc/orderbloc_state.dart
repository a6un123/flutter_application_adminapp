import 'package:equatable/equatable.dart';
import 'package:flutter_application_adminapp/data/model/ordermodeles/ordermodel.dart';

abstract class AdminOrderState extends Equatable {
  const AdminOrderState();
  @override
  List<Object?> get props => [];
}

class AdminOrderInitial extends AdminOrderState {}

class AdminOrderLoading extends AdminOrderState {}

class AdminOrderSuccess extends AdminOrderState {}

class AdminOrderLoaded extends AdminOrderState {
  final List<OrderModel> orders;
  const AdminOrderLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}

class AdminOrderError extends AdminOrderState {
  final String message;
  const AdminOrderError(this.message);
  @override
  List<Object?> get props => [message];
}
