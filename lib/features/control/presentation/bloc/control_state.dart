part of 'control_bloc.dart';

abstract class ControlState extends Equatable {
  const ControlState();
  @override
  List<Object?> get props => [];
}

class ControlInitial extends ControlState {}

class ControlLoading extends ControlState {}

class ControlConnected extends ControlState {
  final SystemInfo systemInfo;
  final String? lastMessage;
  const ControlConnected({required this.systemInfo, this.lastMessage});
  @override
  List<Object?> get props => [systemInfo, lastMessage];
}

class ControlError extends ControlState {
  final String message;
  const ControlError(this.message);
  @override
  List<Object?> get props => [message];
}

class ControlCommandLoading extends ControlState {
  final SystemInfo previousInfo;
  const ControlCommandLoading(this.previousInfo);
  @override
  List<Object?> get props => [previousInfo];
}

class ControlErrorCommandFailed extends ControlState {
  final SystemInfo systemInfo;
  final String error;
  const ControlErrorCommandFailed({required this.systemInfo, required this.error});
  @override
  List<Object?> get props => [systemInfo, error];
}
