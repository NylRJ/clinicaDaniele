import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription? _userSubscription;

  AuthCubit({required AuthRepository authRepository}) : _authRepository = authRepository, super(AuthInitial());

  // Este método verifica o status do usuário quando o app inicia
  Future<void> appStarted() async {
    _userSubscription?.cancel();
    _userSubscription = _authRepository.user.listen((user) {
      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await _authRepository.signIn(email: email, password: password);
    result.fold((failure) => emit(AuthError(message: failure.message)), (user) => emit(Authenticated(user: user)));
  }

  Future<void> signUp({required String name, required String email, required String password}) async {
    emit(AuthLoading());
    final result = await _authRepository.signUp(name: name, email: email, password: password);
    result.fold((failure) => emit(AuthError(message: failure.message)), (user) => emit(Authenticated(user: user)));
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(Unauthenticated());
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
