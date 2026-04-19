import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/hive_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseService _firebaseService;

  AuthBloc({required FirebaseService firebaseService})
      : _firebaseService = firebaseService,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final currentUser = _firebaseService.currentUser;
      if (currentUser != null) {
        final userModel =
            await _firebaseService.getUserProfile(currentUser.uid);
        if (userModel != null) {
          await HiveService.saveUser(userModel.toMap());
          emit(AuthAuthenticated(user: userModel));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final currentUser = _firebaseService.currentUser;
      if (currentUser != null) {
        final userModel =
            await _firebaseService.getUserProfile(currentUser.uid);
        if (userModel != null) {
          await HiveService.saveUser(userModel.toMap());
          emit(AuthAuthenticated(user: userModel));
        } else {
          emit(AuthError(message: 'User profile not found'));
        }
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        default:
          message = 'Login failed. Please try again.';
      }
      emit(AuthError(message: message));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await _firebaseService.updateUserProfile(
        credential.user!.uid,
        {
          'uid': credential.user!.uid,
          'name': event.name,
          'email': event.email,
          'photoUrl': null,
          'neighborhood': null,
          'alertRadius': 1000,
          'isAdmin': false,
          'emergencyContacts': [],
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
      final userModel =
          await _firebaseService.getUserProfile(credential.user!.uid);
      if (userModel != null) {
        await HiveService.saveUser(userModel.toMap());
        emit(AuthAuthenticated(user: userModel));
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;
        case 'weak-password':
          message = 'Password is too weak.';
          break;
        default:
          message = 'Registration failed. Please try again.';
      }
      emit(AuthError(message: message));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _firebaseService.signOut();
    await HiveService.clearUser();
    emit(AuthUnauthenticated());
  }
}