// domain/use_cases/start_hardware_scan.dart
import 'package:dartz/dartz.dart';
import 'package:pwa_sales2go_flutter/core/error/failure.dart';
import 'package:pwa_sales2go_flutter/src/utils/usecase.dart';

import '../repositories/device_repository.dart';

class StartHardwareScan implements UseCaseWithParams<String?, int> {
  final DeviceRepository repository;

  StartHardwareScan(this.repository);

  @override
  Future<Either<Failure, String?>> call(int timeout) {
    return repository.startHardwareScan(timeout);
  }
}
