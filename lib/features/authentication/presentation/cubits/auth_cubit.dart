import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/features/authentication/data/firebase_auth_repository.dart';
import 'package:social_app/features/authentication/domain/app_user.dart';
import 'package:social_app/features/authentication/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuthRepository firebaseAuthRepository;
  AppUser? _currentUser;

  AuthCubit({required this.firebaseAuthRepository}) : super(AuthInitial());

  void checkAuth() async {
    final AppUser? user = await firebaseAuthRepository.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  AppUser? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final user =
          await firebaseAuthRepository.loginWithEmailPassword(email, password);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await firebaseAuthRepository.registerWithEmailPassword(
          name: name, email: email, password: password);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> logout() async {
    firebaseAuthRepository.logout();
    emit(Unauthenticated());
  }
}
