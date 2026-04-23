import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/system_info.dart';
import '../../domain/usecases/get_system_info.dart';
import '../../domain/usecases/execute_command.dart';
import '../../domain/usecases/listen_to_system_stream.dart';
import '../../domain/usecases/pair_device.dart';

part 'control_event.dart';
part 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final PairDevice pairDevice;
  final GetSystemInfo getSystemInfo;
  final ExecuteCommand executeCommand;
  final ListenToSystemStream listenToSystemStream;
  final DisconnectSocket disconnectSocket;

  StreamSubscription<SystemInfo>? _systemStreamSubscription;

  ControlBloc({
    required this.pairDevice,
    required this.getSystemInfo,
    required this.executeCommand,
    required this.listenToSystemStream,
    required this.disconnectSocket,
  }) : super(ControlInitial()) {
    on<ConnectDeviceEvent>(_onConnectDevice);
    on<RefreshSystemInfoEvent>(_onRefreshSystemInfo);
    on<SendCommandEvent>(_onSendCommand);
    on<DisconnectDeviceEvent>(_onDisconnectDevice);
    on<SystemInfoUpdatedEvent>(_onSystemInfoUpdated);
  }

  Future<void> _onConnectDevice(ConnectDeviceEvent event, Emitter<ControlState> emit) async {
    emit(ControlLoading());
    try {
      if (event.pin.isNotEmpty) {
        await pairDevice(event.ip, event.pin);
      }
      
      await _systemStreamSubscription?.cancel();
      _systemStreamSubscription = listenToSystemStream(event.ip).listen(
        (info) => add(SystemInfoUpdatedEvent(info)),
      );
      
      final result = await getSystemInfo(event.ip);
      if (result.isSuccess) {
        emit(ControlConnected(systemInfo: result.data!, lastMessage: null));
      } else {
        emit(ControlError(result.failure?.message ?? 'Failed to get system info'));
      }
    } catch (e) {
      emit(ControlError(e.toString().replaceAll('Exception: ', '')));
    }
  }

  void _onSystemInfoUpdated(SystemInfoUpdatedEvent event, Emitter<ControlState> emit) {
    if (state is ControlConnected) {
      final currentState = state as ControlConnected;
      emit(ControlConnected(systemInfo: event.systemInfo, lastMessage: currentState.lastMessage));
    } else if (state is ControlCommandLoading || state is ControlErrorCommandFailed) {
      
    } else {
      emit(ControlConnected(systemInfo: event.systemInfo, lastMessage: null));
    }
  }

  Future<void> _onRefreshSystemInfo(RefreshSystemInfoEvent event, Emitter<ControlState> emit) async {
    if (state is ControlConnected) {
      try {
        final result = await getSystemInfo(event.ip);
        if (result.isSuccess) {
          emit(ControlConnected(systemInfo: result.data!, lastMessage: null));
        } else {
          emit(ControlError(result.failure?.message ?? 'Refresh failed'));
        }
      } catch (e) {
        emit(ControlError(e.toString().replaceAll('Exception: ', '')));
      }
    }
  }

  Future<void> _onSendCommand(SendCommandEvent event, Emitter<ControlState> emit) async {
    if (state is ControlConnected) {
      final previousState = state as ControlConnected;
      emit(ControlCommandLoading(previousState.systemInfo));
      try {
        final result = await executeCommand(event.ip, event.action);
        if (result.isSuccess) {
          emit(ControlConnected(systemInfo: previousState.systemInfo, lastMessage: 'Success: ${result.data}'));
        } else {
          throw Exception(result.failure?.message ?? 'Command failed');
        }
      } catch (e) {
        emit(ControlErrorCommandFailed(
          systemInfo: previousState.systemInfo,
          error: e.toString().replaceAll('Exception: ', ''),
        ));
        emit(ControlConnected(systemInfo: previousState.systemInfo, lastMessage: null));
      }
    }
  }

  Future<void> _onDisconnectDevice(DisconnectDeviceEvent event, Emitter<ControlState> emit) async {
    await _systemStreamSubscription?.cancel();
    disconnectSocket();
    emit(ControlInitial());
  }

  @override
  Future<void> close() {
    _systemStreamSubscription?.cancel();
    disconnectSocket();
    return super.close();
  }
}
