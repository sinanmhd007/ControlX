import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../models/system_model.dart';
import 'package:controlx/core/error/exception.dart';

abstract class DeviceRemoteDataSource {
  Future<void> pairDevice(String ip, String pin);
  Future<SystemModel> getSystemInfo(String ip);
  Future<String> executeCommand(String ip, String action);
  Stream<SystemModel> listenToSystemStream(String ip);
  void disconnectSocket();
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final Dio client;
  io.Socket? _socket;
  final StreamController<SystemModel> _infoStreamController =
      StreamController<SystemModel>.broadcast();
  String? _token;

  DeviceRemoteDataSourceImpl({required this.client});

  Future<void> _ensureToken() async {
    if (_token == null) {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('controlx_token');
    }
    if (_token != null) {
      client.options.headers['Authorization'] = 'Bearer $_token';
    }
  }

  @override
  Future<void> pairDevice(String ip, String pin) async {
    client.options.baseUrl = 'http://$ip:3000';
    try {
      final response = await client.post('/pair', data: {'pin': pin});
      if (response.data['success'] == true) {
        _token = response.data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('controlx_token', _token!);
        return;
      }
      throw Exception('Invalid response');
    } catch (e) {
      if (e is DioException && e.response != null) {
        throw Exception(e.response?.data['error'] ?? 'Incorrect PIN');
      }
      throw ServerException();
    }
  }

  @override
  Future<SystemModel> getSystemInfo(String ip) async {
    client.options.baseUrl = 'http://$ip:3000';
    await _ensureToken();
    try {
      final response = await client.get('/system-info');
      if (response.data['success'] == true) {
        return SystemModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to get system info');
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  @override
  Future<String> executeCommand(String ip, String action) async {
    client.options.baseUrl = 'http://$ip:3000';
    await _ensureToken();
    try {
      final response = await client.post('/command', data: {'action': action});
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['message'];
      }
      throw Exception(response.data['error'] ?? 'Unknown error');
    } catch (e) {
      if (e is DioException && e.response != null) {
        throw Exception(e.response?.data['error'] ?? e.toString());
      }
      throw Exception(e.toString());
    }
  }

  @override
  Stream<SystemModel> listenToSystemStream(String ip) {
    disconnectSocket();

    _socket = io.io(
      'http://$ip:3000',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': _token ?? ''})
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      _socket!.emit('connect_device', {});
    });

    _socket!.on('system_update', (data) {
      if (data != null) {
        _infoStreamController.add(SystemModel.fromJson(data));
      }
    });

    _socket!.onConnectError((err) {
      _infoStreamController.addError(Exception("Socket Connection Error"));
    });

    return _infoStreamController.stream;
  }

  @override
  void disconnectSocket() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
  }
}
