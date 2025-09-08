import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pwa_sales2go_flutter/core/error/failure.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/entities/token.dart';
import 'package:pwa_sales2go_flutter/src/utils/usecase.dart';

import '../repositories/token_repository.dart';

class GetToken implements UseCaseWithParams<Token, GetTokenParams> {
  GetToken(this.repository);

  final TokenRepository repository;

  @override
  Future<Either<Failure, Token>> call(GetTokenParams params) async {
    return await repository.getToken(params.serialNumber);
  }
}

class GetTokenParams extends Equatable {
  final String serialNumber;

  const GetTokenParams({
    required this.serialNumber,
  });

  const GetTokenParams.empty() : this(serialNumber: '');

  @override
  List<Object?> get props => [
        serialNumber,
      ];
}
