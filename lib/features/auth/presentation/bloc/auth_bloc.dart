import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmailAndPassword loginWithEmailAndPassword;
  final SignUpWithEmailAndPassword signUpWithEmailAndPassword;
  final Logout logout;
  final GetUserStream getUserStream;

  StreamSubscription<UserEntity?>? _userSubscription;

  AuthBloc({
    required this.loginWithEmailAndPassword,
    required this.signUpWithEmailAndPassword,
    required this.logout,
    required this.getUserStream,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);

    _userSubscription = getUserStream().listen((user) {
      add(AuthUserChanged(user));
    });
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) {
    // Already handled passively by Stream
  }

  void _onAuthUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginWithEmailAndPassword(event.email, event.password);

    result.fold(
      onFailure: (failure) {
        emit(AuthUnauthenticated());
        emit(AuthError(failure.message));
      },
      onSuccess: (user) {
        // No need to emit AuthAuthenticated here
        // because your stream listener will handle it
      },
    );
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await signUpWithEmailAndPassword(
      event.email,
      event.password,
    );

    result.fold(
      onFailure: (failure) {
        emit(AuthUnauthenticated());
        emit(AuthError(failure.message));
      },
      onSuccess: (user) {
        // Stream will update state automatically
      },
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await logout();
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
