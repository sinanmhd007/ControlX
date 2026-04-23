part of 'control_bloc.dart';

abstract class ControlEvent extends Equatable {
  const ControlEvent();
  @override
  List<Object> get props => [];
}

class ConnectDeviceEvent extends ControlEvent {
  final String ip;
  final String pin;
  const ConnectDeviceEvent(this.ip, this.pin);
  @override
  List<Object> get props => [ip, pin];
}

class SendCommandEvent extends ControlEvent {
  final String ip;
  final String action;
  const SendCommandEvent(this.ip, this.action);
  @override
  List<Object> get props => [ip, action];
}

class RefreshSystemInfoEvent extends ControlEvent {
  final String ip;
  const RefreshSystemInfoEvent(this.ip);
  @override
  List<Object> get props => [ip];
}

class DisconnectDeviceEvent extends ControlEvent {}

class SystemInfoUpdatedEvent extends ControlEvent {
  final SystemInfo systemInfo;
  const SystemInfoUpdatedEvent(this.systemInfo);
  @override
  List<Object> get props => [systemInfo];
}
