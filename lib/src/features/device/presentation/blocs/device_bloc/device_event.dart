part of 'device_bloc.dart';

abstract class DeviceEvent extends Equatable {
  const DeviceEvent();

  @override
  List<Object> get props => [];
}

class InitDeviceEvent extends DeviceEvent {
  final InitDeviceParams initDeviceParams;

  const InitDeviceEvent(this.initDeviceParams);

  @override
  List<Object> get props => [initDeviceParams];
}

class GetDeviceEvent extends DeviceEvent {}

class GetTokenEvent extends DeviceEvent {
  final String serialNumber;

  const GetTokenEvent(this.serialNumber);
  @override
  List<Object> get props => [serialNumber];
}

class CheckScannerHardwareEvent extends DeviceEvent {}

class StartHardwareScanEvent extends DeviceEvent {
  const StartHardwareScanEvent(this.timeout);
  final int timeout;

  @override
  List<Object> get props => [timeout];
}
