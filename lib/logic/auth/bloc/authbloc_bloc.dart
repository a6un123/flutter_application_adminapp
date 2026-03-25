import 'package:flutter_application_adminapp/data/repositiores/authrepositiores/authrepositiores.dart';
import 'package:flutter_application_adminapp/logic/auth/bloc/authbloc_event.dart';
import 'package:flutter_application_adminapp/logic/auth/bloc/authbloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuth);
    on<Loginsubmit>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuth(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final user = _authRepository.currentUser;
    if (user != null) {
      final role = await _authRepository.getUserRole(user.uid);
      emit(
        Authenticated(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '',
          role: role,
        ),
      );
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogin(Loginsubmit event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        final role = await _authRepository.getUserRole(user.uid);
        emit(
          Authenticated(
            uid: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? '',
            role: role,
          ),
        );
      }
    } catch (e) {
      emit(Autherror(message: _friendlyError(e.toString())));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    emit(Unauthenticated());
  }

  String _friendlyError(String error) {
    if (error.contains('user-not-found')) return 'No account found';
    if (error.contains('wrong-password')) return 'Incorrect password';
    if (error.contains('invalid-email')) return 'Invalid email';
    if (error.contains('network-request-failed')) return 'No internet';
    return 'Something went wrong. Please try again';
  }
}
