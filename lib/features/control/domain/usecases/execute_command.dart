import 'package:controlx/core/error/result.dart';

import '../repositories/device_repository.dart';

class ExecuteCommand {
  final DeviceRepository repository;

  ExecuteCommand(this.repository);

  Future<Result<String>> call(String ip, String action) async {
    return await repository.executeCommand(ip, action);
  }
}
