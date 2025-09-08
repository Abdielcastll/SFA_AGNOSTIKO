import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:pwa_sales2go_flutter/core/error/failure.dart';

import '../entities/device.dart';

abstract class DeviceRepository {
  /// Init device (sdk agnostiko, payment processor, payment repository and payment settings)
  Future<Either<Failure, Device>> initDevice(Uint8List token);

  /// Read device information
  Future<Either<Failure, Device>> getDevice();
  Future<Either<Failure, bool>> hasScannerHardware();
  Future<Either<Failure, String?>> startHardwareScan(int timeout);
}
