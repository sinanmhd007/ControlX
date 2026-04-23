import '../entities/system_info.dart';

abstract class DeviceRepository {
  Future<void> pairDevice(String ip, String pin);
  Future<SystemInfo> getSystemInfo(String ip);
  Future<String> executeCommand(String ip, String action);
  Stream<SystemInfo> listenToSystemStream(String ip);
  void disconnectSocket();
}
