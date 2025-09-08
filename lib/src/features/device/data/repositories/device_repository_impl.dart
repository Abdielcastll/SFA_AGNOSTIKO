import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:pwa_sales2go_flutter/core/error/exception.dart';
import 'package:pwa_sales2go_flutter/core/error/failure.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/entities/device.dart';

import '../../domain/repositories/device_repository.dart';
import '../datasources/device_local_datasource.dart';
import '../models/device_model.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceLocalDatasource localDatasource;

  DeviceRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, Device>> getDevice() async {
    try {
      final DeviceModel deviceModel = await localDatasource.getDevice();
      return Right(deviceModel);
    } on AgnostikoException catch (e) {
      return Left(AgnostikoFailure(
        message: e.error.value,
        statusCode: 400,
      ));
    }
  }

  @override
  Future<Either<Failure, Device>> initDevice(Uint8List token) async {
    try {
      await localDatasource.initDevice(token);
      final DeviceModel deviceModel = await localDatasource.getDevice();
      return Right(deviceModel);
    } on AgnostikoException catch (e) {
      return Left(AgnostikoFailure(
        message: e.error.value,
        statusCode: 400,
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> hasScannerHardware() async {
    try {
      final hasScanner = await localDatasource.hasScannerHardware();
      return Right(hasScanner);
    } on AgnostikoException catch (e) {
      return Left(AgnostikoFailure(
        message: e.error.value,
        statusCode: 400,
      ));
    }
  }

  @override
  Future<Either<Failure, String?>> startHardwareScan(int timeout) async {
    try {
      final result = await localDatasource.startHardwareScan(timeout);
      return Right(result?.trim());
    } on AgnostikoException catch (e) {
      return Left(AgnostikoFailure(message: e.error.value, statusCode: 500));
    }
  }
}
