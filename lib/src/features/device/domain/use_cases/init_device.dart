import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pwa_sales2go_flutter/core/error/failure.dart';
import 'package:pwa_sales2go_flutter/src/utils/usecase.dart';

import '../entities/device.dart';
import '../repositories/device_repository.dart';

class InitDevice implements UseCaseWithParams<Device, InitDeviceParams> {
  InitDevice(this.deviceRepository);

  final DeviceRepository deviceRepository;

  @override
  Future<Either<Failure, Device>> call(InitDeviceParams params) async {
    return await deviceRepository.initDevice(params.token);
  }
}

class InitDeviceParams extends Equatable {
  final Uint8List token;

  const InitDeviceParams({
    required this.token,
  });

  @override
  List<Object?> get props => [
        token,
      ];
}
