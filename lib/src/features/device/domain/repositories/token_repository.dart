import 'package:dartz/dartz.dart';
import 'package:pwa_sales2go_flutter/core/error/failure.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/entities/token.dart';

abstract class TokenRepository {
  /// Get Agnostiko Token required for SDK initialization
  Future<Either<Failure, Token>> getToken(String serialNumber);
}
