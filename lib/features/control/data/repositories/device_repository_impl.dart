import '../../domain/entities/system_info.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_remote_data_source.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource remoteDataSource;

  DeviceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> pairDevice(String ip, String pin) async {
    await remoteDataSource.pairDevice(ip, pin);
  }

  @override
  Future<SystemInfo> getSystemInfo(String ip) async {
    return await remoteDataSource.getSystemInfo(ip);
  }

  @override
  Future<String> executeCommand(String ip, String action) async {
    return await remoteDataSource.executeCommand(ip, action);
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
