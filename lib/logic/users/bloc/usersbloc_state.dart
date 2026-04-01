import 'package:equatable/equatable.dart';
import 'package:flutter_application_adminapp/data/model/usersmodel/usersmodel.dart';

abstract class AdminUserState extends Equatable {
  const AdminUserState();
  @override
  List<Object?> get props => [];
}

class AdminUserInitial extends AdminUserState {}

class AdminUserLoading extends AdminUserState {}

class AdminUserLoaded extends AdminUserState {
  final List<UserModel> users;
  const AdminUserLoaded(this.users);
  @override
  List<Object?> get props => [users];
}

class AdminUserError extends AdminUserState {
  final String message;
  const AdminUserError(this.message);
  @override
  List<Object?> get props => [message];
}
