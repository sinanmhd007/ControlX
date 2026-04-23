import 'package:controlx/core/error/result.dart';

import '../entities/system_info.dart';

abstract class DeviceRepository {
  Future<Result<void>> pairDevice(String ip, String pin);
  Future<Result<SystemInfo>> getSystemInfo(String ip);
  Future<Result<String>> executeCommand(String ip, String action);
  Stream<SystemInfo> listenToSystemStream(String ip);
  void disconnectSocket();
}
