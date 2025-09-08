import 'package:equatable/equatable.dart';

enum DeviceState {
  notReady, //Init state, before validate agnostiko license
  notConfigured, //Agnostiko license ready, but financial application not configured
  ready //Financial application ready for transactions
}

class Device extends Equatable {
  const Device({
    this.state = DeviceState.notReady,
    required this.model,
    required this.serialNumber,
  });

  final DeviceState state;
  final String model;
  final String serialNumber;

  /// Returns an empty device instance.
  static Device empty() {
    return const Device(
      state: DeviceState.notReady,
      model: '',
      serialNumber: '',
    );
  }

  @override
  List<Object?> get props => [state, model, serialNumber];
}
