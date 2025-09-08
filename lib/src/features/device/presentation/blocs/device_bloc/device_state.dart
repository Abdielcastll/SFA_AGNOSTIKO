part of 'device_bloc.dart';

class DeviceState extends Equatable {
  const DeviceState({
    required this.device,
  });
  const DeviceState.initial() : this(device: null);

  final Device? device;

  DeviceState copyWith({
    Device? device,
  }) {
    return DeviceState(
      device: device ?? this.device,
    );
  }

  @override
  List<Object?> get props => [device];
}

class Loading extends DeviceState {
  final String message;

  const Loading({
    required this.message,
    required super.device,
  });

  @override
  List<Object?> get props => [message, device];
}

class Loaded extends DeviceState {
  const Loaded({
    required super.device,
  });

  @override
  List<Object?> get props => [device];
}

class Error extends DeviceState {
  final String message;

  const Error({
    required this.message,
    required super.device,
  });

  @override
  List<Object?> get props => [message, device];
}

class HardwareChecked extends DeviceState {
  final bool hasScannerHardware;

  const HardwareChecked({
    required this.hasScannerHardware,
    required super.device,
  });

  @override
  List<Object?> get props => [hasScannerHardware, device];
}

class HardwareScanState extends DeviceState {
  final String scanResult;

  const HardwareScanState({
    required this.scanResult,
    required super.device,
  });

  @override
  List<Object?> get props => [scanResult, device];
}
