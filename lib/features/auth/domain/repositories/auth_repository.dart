import 'package:controlx/core/error/result.dart';

import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> loginWithEmailAndPassword(
      String email, String password);

  Future<Result<UserEntity>> signUpWithEmailAndPassword(
      String email, String password);

  Future<Result<void>> logout();

  Stream<UserEntity?> get user;
}