import 'package:controlx/core/error/failure.dart';
import 'package:controlx/core/error/result.dart';
import 'package:controlx/core/network/network_info.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<UserEntity>> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.loginWithEmailAndPassword(
          email,
          password,
        );
        return Result.success(remoteUser);
      } catch (e) {
        return Result.failure(AuthFailure(e.toString()));
      }
    } else {
      return Result.failure(NetworkFailure());
    }
  }

  @override
  Future<Result<UserEntity>> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.signUpWithEmailAndPassword(
          email,
          password,
        );
        return Result.success(remoteUser);
      } catch (e) {
        return Result.failure(AuthFailure(e.toString()));
      }
    } else {
      return Result.failure(NetworkFailure());
    }
  }

  @override
  Future<Result<void>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logout();
        return Result.success(null);
      } catch (e) {
        return Result.failure(ServerFailure(e.toString()));
      }
    } else {
      return Result.failure(NetworkFailure());
    }
    }
    
      @override
      Stream<UserEntity?> get user => remoteDataSource.userStream;
  }


