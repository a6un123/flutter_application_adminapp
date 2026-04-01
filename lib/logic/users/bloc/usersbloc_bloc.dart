import 'package:flutter_application_adminapp/data/repositiores/userrepositiores/userrepositiories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'usersbloc_event.dart';
import 'usersbloc_state.dart';

class AdminUserBloc extends Bloc<AdminUserEvent, AdminUserState> {
  final UserRepository _repository;

  AdminUserBloc(this._repository) : super(AdminUserInitial()) {
    on<LoadAllUsers>(_onLoadAll);
    on<LoadCustomers>(_onLoadCustomers);
  }

  Future<void> _onLoadAll(
    LoadAllUsers event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(AdminUserLoading());
    await emit.forEach(
      _repository.getAllUsers(),
      onData: (users) => AdminUserLoaded(users),
      onError: (e, _) => AdminUserError(e.toString()),
    );
  }

  Future<void> _onLoadCustomers(
    LoadCustomers event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(AdminUserLoading());
    await emit.forEach(
      _repository.getCustomers(),
      onData: (users) => AdminUserLoaded(users),
      onError: (e, _) => AdminUserError(e.toString()),
    );
  }
}
