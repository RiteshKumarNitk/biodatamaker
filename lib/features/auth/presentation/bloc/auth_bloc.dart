import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:biodata_maker/core/services/service_locator.dart';
import 'package:biodata_maker/features/auth/data/repositories/auth_repository.dart';
import 'package:biodata_maker/features/auth/data/models/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthGuest extends AuthState {
  final User user;

  const AuthGuest(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuth extends AuthEvent {}

class SignUp extends AuthEvent {
  final String name;
  final String email;
  final String phone;

  const SignUp({required this.name, required this.email, required this.phone});

  @override
  List<Object?> get props => [name, email, phone];
}

class SignInWithEmail extends AuthEvent {
  final String email;

  const SignInWithEmail(this.email);

  @override
  List<Object?> get props => [email];
}

class SignInWithGoogle extends AuthEvent {}

class SignInAsGuest extends AuthEvent {}

class SignOut extends AuthEvent {}

class UpdateProfile extends AuthEvent {
  final User user;

  const UpdateProfile(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepo = sl<AuthRepository>();

  AuthBloc() : super(AuthInitial()) {
    on<CheckAuth>(_onCheckAuth);
    on<SignUp>(_onSignUp);
    on<SignInWithEmail>(_onSignInWithEmail);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignInAsGuest>(_onSignInAsGuest);
    on<SignOut>(_onSignOut);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onCheckAuth(CheckAuth event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final loggedIn = await _authRepo.isLoggedIn();
      if (loggedIn) {
        final user = await _authRepo.getCurrentUser();
        if (user != null) {
          if (user.isGuest) {
            emit(AuthGuest(user));
          } else {
            emit(AuthAuthenticated(user));
          }
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(SignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.signUp(event.name, event.email, event.phone);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithEmail(
      SignInWithEmail event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.signInWithEmail(event.email);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogle event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.signInWithGoogle();
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignInAsGuest(
      SignInAsGuest event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepo.signInAsGuest();
      emit(AuthGuest(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepo.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authRepo.updateProfile(event.user);
      emit(AuthAuthenticated(event.user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
