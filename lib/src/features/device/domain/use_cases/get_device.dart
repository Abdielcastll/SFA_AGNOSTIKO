import 'package:dartz/dartz.dart';
import 'package:pwa_sales2go_flutter/core/error/failure.dart';
import 'package:pwa_sales2go_flutter/src/utils/usecase.dart';

import '../entities/device.dart';
import '../repositories/device_repository.dart';

class GetDevice implements UseCaseWithOutParams<Device> {
  GetDevice(this.repository);

  final DeviceRepository repository;

  @override
  Future<Either<Failure, Device>> call() async {
    return await repository.getDevice();
  }
}
