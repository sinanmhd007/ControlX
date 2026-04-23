import 'package:controlx/core/error/result.dart';
import 'package:controlx/core/error/failure.dart';
import 'package:controlx/core/network/network_info.dart';

import '../../domain/entities/system_info.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_remote_data_source.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DeviceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<void>> pairDevice(String ip, String pin) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.pairDevice(ip, pin);
        return Result.success(null);
      } catch (e) {
        return Result.failure(ServerFailure(e.toString()));
      }
    } else {
      return Result.failure(NetworkFailure());
    }
  }

  @override
  Future<Result<SystemInfo>> getSystemInfo(String ip) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteSystemInfo = await remoteDataSource.getSystemInfo(ip);
        return Result.success(remoteSystemInfo);
      } catch (e) {
        return Result.failure(ServerFailure());
      }
    } else {
      return Result.failure(NetworkFailure());
    }
  }

  @override
  Future<Result<String>> executeCommand(String ip, String action) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.executeCommand(ip, action);
        return Result.success(response);
      } catch (e) {
        return Result.failure(ServerFailure());
      }
    } else {
      return Result.failure(NetworkFailure());
    }
  }

  @override
  Stream<SystemInfo> listenToSystemStream(String ip) {
    return remoteDataSource.listenToSystemStream(ip);
  }

  @override
  void disconnectSocket() {
    remoteDataSource.disconnectSocket();
  }
}
