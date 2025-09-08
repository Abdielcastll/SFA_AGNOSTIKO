import 'package:dartz/dartz.dart';
import 'package:pwa_sales2go_flutter/core/error/exception.dart';
import 'package:pwa_sales2go_flutter/core/error/failure.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/entities/token.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/repositories/token_repository.dart';

import '../datasources/token_local_datasource.dart';
import '../datasources/token_remote_datasource.dart';
import '../models/token_model.dart';

class TokenRepositoryImpl implements TokenRepository {
  final TokenRemoteDatasource remoteDatasource;
  final TokenLocalDatasource localDatasource;

  final String serialNumber;

  TokenRepositoryImpl(
      {required this.remoteDatasource,
      required this.localDatasource,
      required this.serialNumber});

  @override
  Future<Either<Failure, Token>> getToken(String serialNumber) async {
    try {
      // == Search token in local datasource (exist and not expired)
      final TokenModel localToken =
          await localDatasource.getToken(serialNumber);
      return Right(localToken);
    } on CacheException {
      try {
        // == Search token online
        final TokenModel remoteToken =
            await remoteDatasource.getToken(serialNumber);
        // == Save token in local datasource
        localDatasource.cacheToken(remoteToken);
        return Right(remoteToken);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.error.value, statusCode: 400));
      }
    }
  }
}
