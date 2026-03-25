import 'package:flutter_application_adminapp/data/repositiores/userrepositiores/userrepositiores.dart';
import 'package:flutter_application_adminapp/logic/users/bloc/usersbloc_event.dart';
import 'package:flutter_application_adminapp/logic/users/bloc/usersbloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
