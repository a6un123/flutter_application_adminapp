import 'package:equatable/equatable.dart';

abstract class AdminUserEvent extends Equatable {
  const AdminUserEvent();
  @override
  List<Object?> get props => [];
}

class LoadAllUsers extends AdminUserEvent {}

class LoadCustomers extends AdminUserEvent {}
