import 'dart:typed_data';
import 'package:agnostiko/agnostiko.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/core/error/exception.dart';

import '../models/device_model.dart';

abstract class DeviceLocalDatasource {
  /// Call the Agnostiko SDK to obtain device information
  ///
  /// Throws a [AgnostikoException] for any error
  Future<DeviceModel> getDevice();

  /// Init Agnostiko SDK with device serial number
  ///
  /// Throws a [AgnostikoException] for any error
  Future<DeviceModel> initDevice(Uint8List token);

  /// Returns true if the device has scanner hardware
  ///
  /// Throws a [AgnostikoException] for any error
  Future<bool> hasScannerHardware();

  /// Starts the hardware scanner and returns the scanned content.
  ///
  /// Throws a [AgnostikoException] for any error
  Future<String?> startHardwareScan(int timeout); // <-- Add this
}

class DeviceLocalDatasourceImpl implements DeviceLocalDatasource {
  @override
  Future<DeviceModel> getDevice() async {
    try {
      final String brand = (await getPlatformInfo()).deviceBrand;
      final DeviceType type = await getDeviceType();

      if (type == DeviceType.PINPAD) await connectPinpad();

      final String? serial = await getSerialNumber();

      if (serial == null) throw AgnostikoException(Error.agnostiko);

      final device = DeviceModel(model: brand, serialNumber: serial);
      return Future.value(device);
    } catch (e) {
      throw AgnostikoException(Error.agnostiko);
    }
  }

  @override
  Future<DeviceModel> initDevice(Uint8List token) async {
    try {
      final String? model = await getModel();
      final String? serial = await getSerialNumber();

      if (serial == null || model == null) {
        throw AgnostikoException(Error.agnostiko);
      }

      await initSDK(authToken: token);
      return Future.value(DeviceModel(model: model, serialNumber: serial));
    } catch (e) {
      throw AgnostikoException(Error.agnostiko);
    }
  }

  @override
  Future<bool> hasScannerHardware() async {
    try {
      final model = await getModel();
      debugPrint("is Model result: ${model}");
      bool isScanner = false;
      if (model == "N750") isScanner = true;

      return isScanner;
    } catch (e) {
      throw AgnostikoException(Error.agnostiko);
    }
  }

  @override
  Future<String?> startHardwareScan(int timeout) async {
    try {
      final result = await startScannerHw(timeout: timeout);
      debugPrint("Scanner result: $result");
      return result?.trim();
    } catch (e) {
      throw AgnostikoException(Error.agnostiko);
    }
  }
}
