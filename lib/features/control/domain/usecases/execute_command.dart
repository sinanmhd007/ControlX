import '../repositories/device_repository.dart';

class ExecuteCommand {
  final DeviceRepository repository;

  ExecuteCommand(this.repository);

  Future<String> call(String ip, String action) async {
    return await repository.executeCommand(ip, action);
  }
}
