import '../../domain/entities/device.dart';

class DeviceModel extends Device {
  const DeviceModel({
    required String model,
    required String serialNumber,
  }) : super(
          model: model,
          serialNumber: serialNumber,
        );
}
