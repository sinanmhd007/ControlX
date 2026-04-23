import '../repositories/device_repository.dart';

class PairDevice {
  final DeviceRepository repository;

  PairDevice(this.repository);

  Future<void> call(String ip, String pin) async {
    return await repository.pairDevice(ip, pin);
  }
}
