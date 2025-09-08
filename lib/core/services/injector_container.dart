import 'package:get_it/get_it.dart';
import 'package:pwa_sales2go_flutter/src/features/device/data/datasources/device_local_datasource.dart';
import 'package:pwa_sales2go_flutter/src/features/device/data/datasources/token_local_datasource.dart';
import 'package:pwa_sales2go_flutter/src/features/device/data/datasources/token_remote_datasource.dart';
import 'package:pwa_sales2go_flutter/src/features/device/data/repositories/device_repository_impl.dart';
import 'package:pwa_sales2go_flutter/src/features/device/data/repositories/token_repository_impl.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/repositories/device_repository.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/repositories/token_repository.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/use_cases/get_device.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/use_cases/get_token.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/use_cases/has_hardware_scanner.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/use_cases/init_device.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/use_cases/start_hardware_scan.dart';
import 'package:pwa_sales2go_flutter/src/features/device/presentation/blocs/device_bloc/device_bloc.dart';
import 'package:pwa_sales2go_flutter/src/features/discount/data/datasource/discount_datasource.dart';
import 'package:pwa_sales2go_flutter/src/features/discount/data/repositories/discount_repositoy_impl.dart';
import 'package:pwa_sales2go_flutter/src/features/discount/domain/usecase/add_discount_order.dart';
import 'package:pwa_sales2go_flutter/src/features/discount/presentation/bloc/discount_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/features/discount/discount_data.dart';

final sl = GetIt.instance;

Future<void> initInjector() async {
  _initHome();

  _initDiscount();
}

void _initHome() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  // == Bloc
  sl.registerFactory(
    () => DeviceBloc(
      getDevice: sl<GetDevice>(),
      initDevice: sl<InitDevice>(),
      hasHardwareScanner: sl<HasHardwareScanner>(),
      startHardwareScan: sl<StartHardwareScan>(),
      getToken: sl<GetToken>(),
    ),
  );
  sl.registerLazySingleton<http.Client>(() => http.Client());
// Use cases
  sl.registerLazySingleton(() => GetDevice(sl<DeviceRepository>()));
  sl.registerLazySingleton(() => InitDevice(sl<DeviceRepository>()));
  sl.registerLazySingleton(() => HasHardwareScanner(sl<DeviceRepository>()));
  sl.registerLazySingleton(() => StartHardwareScan(sl<DeviceRepository>()));
  sl.registerLazySingleton(() => GetToken(sl<TokenRepository>()));

  // == Repositories
  sl.registerLazySingleton<DeviceRepository>(
      () => DeviceRepositoryImpl(localDatasource: sl()));
  sl.registerLazySingleton<TokenRepository>(() => TokenRepositoryImpl(
      remoteDatasource: sl(),
      localDatasource: sl(),
      serialNumber: 'serialNumber'));

  // == Datasources
  sl.registerLazySingleton<DeviceLocalDatasource>(
      () => DeviceLocalDatasourceImpl());
  sl.registerLazySingleton<TokenLocalDatasource>(
      () => TokenLocalDatasourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<TokenRemoteDatasource>(
      () => TokenRemoteDatasourceImpl(client: sl()));
}

void _initDiscount() {
  sl
    ..registerLazySingleton(() => DiscountBloc(
          sl<AddDiscountOrder>(),
          sl<GetDiscount>(),
          sl<RemoveDiscount>(),
        ))
    ..registerLazySingleton(() => AddDiscountOrder(
          sl<DiscountRepository>(),
        ))
    ..registerLazySingleton(() => GetDiscount(
          sl<DiscountRepository>(),
        ))
    ..registerLazySingleton(() => RemoveDiscount(
          sl<DiscountRepository>(),
        ))
    ..registerLazySingleton<DiscountRepository>(() => DiscountRepositoyImpl(
          datasource: sl<DiscountDatasource>(),
        ))
    ..registerLazySingleton<DiscountDatasource>(
        () => DiscountDatasourceFirebase());
}
