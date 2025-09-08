import 'dart:async';

import 'package:dartz/dartz.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pwa_sales2go_flutter/core/error/failure.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/entities/device.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/use_cases/get_device.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/use_cases/get_token.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/use_cases/has_hardware_scanner.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/use_cases/init_device.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/use_cases/start_hardware_scan.dart';

import 'package:rxdart/rxdart.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final GetDevice getDevice;
  final GetToken getToken;
  final InitDevice initDevice;
  final HasHardwareScanner hasHardwareScanner;
  final StartHardwareScan startHardwareScan;

  final _input = BehaviorSubject<String>();
  Stream<String> get input => _input.stream;

  DeviceBloc({
    required this.getDevice,
    required this.initDevice,
    required this.hasHardwareScanner,
    required this.startHardwareScan,
    required this.getToken,
  }) : super(const DeviceState.initial()) {
    _input.value = "";

    on<GetDeviceEvent>(_onGetDeviceHandler);
    on<GetTokenEvent>(_onGetTokenHandler);
    on<InitDeviceEvent>(_onInitDevice);
    on<CheckScannerHardwareEvent>(_onCheckScannerHardware);
    on<StartHardwareScanEvent>(_onStartHardwareScanHandler);
  }

  Future<void> _onStartHardwareScanHandler(
    StartHardwareScanEvent event,
    Emitter<DeviceState> emit,
  ) async {
    emit(Loading(message: "escaneando", device: state.device));
    final result = await startHardwareScan(event.timeout);
    result.fold(
      (failure) => emit(
        Error(message: failure.message, device: state.device),
      ),
      (scan) => emit(
        HardwareScanState(device: state.device, scanResult: scan ?? ""),
      ),
    );
  }

  FutureOr<void> _onCheckScannerHardware(
      CheckScannerHardwareEvent event, Emitter<DeviceState> emit) async {
    emit(Loading(
        message: "Verificando hardware del escáner", device: state.device));

    final Either<Failure, bool> result = await hasHardwareScanner();

    result.fold(
      (failure) {
        emit(Error(message: failure.message, device: state.device));
      },
      (hasScanner) {
        emit(HardwareChecked(
          hasScannerHardware: hasScanner,
          device: state.device,
        ));
      },
    );
  }

  FutureOr<void> _onInitDevice(
    InitDeviceEvent event,
    Emitter<DeviceState> emit,
  ) async {
    final result = await initDevice(event.initDeviceParams);

    result.fold(
      (failure) {
        emit(Error(
          message: failure.message,
          device: state.device,
        ));
      },
      (device) {
        // == Everything ok
        emit(Loaded(device: state.device));
      },
    );
  }

  FutureOr<void> _onGetDeviceHandler(
    GetDeviceEvent event,
    Emitter<DeviceState> emit,
  ) async {
    emit(const DeviceState.initial());
    // == Android permission
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      // Permission.manageExternalStorage
    ].request();
    if (statuses[Permission.storage] != PermissionStatus.granted
        //|| statuses[Permission.manageExternalStorage] != PermissionStatus.granted
        ) {
      emit(Error(
        message: "Sin permisos de almacenamiento",
        device: state.device,
      ));
      return;
    }
    // == Init device (SDK)
    emit(Loading(
      message: "Iniciando SDK",
      device: state.device,
    ));
    final result = await getDevice();
    result.fold(
      (failure) {
        emit(Error(
          message: failure.message,
          device: state.device,
        ));
      },
      (device) {
        add(GetTokenEvent(device.serialNumber));
      },
    );
  }

  FutureOr<void> _onGetTokenHandler(
    GetTokenEvent event,
    Emitter<DeviceState> emit,
  ) async {
    final result =
        await getToken(GetTokenParams(serialNumber: event.serialNumber));
    result.fold(
      (failure) {
        emit(Error(
          message: failure.message,
          device: state.device,
        ));
      },
      (token) {
        add(InitDeviceEvent(InitDeviceParams(token: token.value)));
      },
    );
  }
}
