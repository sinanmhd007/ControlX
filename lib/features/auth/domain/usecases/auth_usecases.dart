import 'package:controlx/core/error/result.dart';
import 'package:controlx/features/auth/domain/repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class LoginWithEmailAndPassword {
  final AuthRepository repository;
  LoginWithEmailAndPassword(this.repository);

  Future<Result<UserEntity?>> call(String email, String password) {
    return repository.loginWithEmailAndPassword(email, password);
  }
}

class SignUpWithEmailAndPassword {
  final AuthRepository repository;
  SignUpWithEmailAndPassword(this.repository);

  Future<Result<UserEntity?>> call(String email, String password) {
    return repository.signUpWithEmailAndPassword(email, password);
  }
}

class Logout {
  final AuthRepository repository;
  Logout(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}

class GetUserStream {
  final AuthRepository repository;
  GetUserStream(this.repository);

  Stream<UserEntity?> call() {
    return repository.user;
  }
}
