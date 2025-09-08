import 'package:dartz/dartz.dart';
import 'package:pwa_sales2go_flutter/core/error/failure.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/repositories/device_repository.dart';
import 'package:pwa_sales2go_flutter/src/utils/usecase.dart';

class HasHardwareScanner implements UseCaseWithOutParams<bool> {
  final DeviceRepository repository;

  HasHardwareScanner(this.repository);

  @override
  Future<Either<Failure, bool>> call() async {
    return repository.hasScannerHardware();
  }
}
