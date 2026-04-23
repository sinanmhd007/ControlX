import '../entities/system_info.dart';
import '../repositories/device_repository.dart';

class GetSystemInfo {
  final DeviceRepository repository;

  GetSystemInfo(this.repository);

  Future<SystemInfo> call(String ip) async {
    return await repository.getSystemInfo(ip);
  }
}
