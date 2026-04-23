import '../../domain/entities/system_info.dart';

class SystemModel extends SystemInfo {
  const SystemModel({
    required super.cpu,
    required super.ram,
    required super.os,
  });

  factory SystemModel.fromJson(Map<String, dynamic> json) {
    return SystemModel(
      cpu: json['cpu'].toString().split('@')[0].trim(),
      ram: '${json['ram']['used_GB']} / ${json['ram']['total_GB']} GB',
      os: json['platform'],
    );
  }
}
