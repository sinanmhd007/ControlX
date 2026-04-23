import '../entities/system_info.dart';
import '../repositories/device_repository.dart';

class ListenToSystemStream {
  final DeviceRepository repository;

  ListenToSystemStream(this.repository);

  Stream<SystemInfo> call(String ip) {
    return repository.listenToSystemStream(ip);
  }
}

class DisconnectSocket {
  final DeviceRepository repository;

  DisconnectSocket(this.repository);

  void call() {
    repository.disconnectSocket();
  }
}
