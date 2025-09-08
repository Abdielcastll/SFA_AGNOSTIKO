import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:pwa_sales2go_flutter/core/error/exception.dart';
import 'package:pwa_sales2go_flutter/core/error/failure.dart';
import 'package:pwa_sales2go_flutter/src/utils/typedef.dart';
import '../../discount_data.dart';
import '../datasource/discount_datasource.dart';

class DiscountRepositoyImpl implements DiscountRepository {
  final DiscountDatasource datasource;
  DiscountRepositoyImpl({required this.datasource});

  @override
  ResultParam<Discount> getDiscount({required String codigo}) {
    try {
      final Discount discount = datasource.getDiscounts(codigo: codigo);
      return Right(discount);
    } on ApiException catch (error) {
      return Left(
          ApiFailure(message: error.message, statusCode: error.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: '$e', statusCode: 505));
    }
  }

  @override
  ResultParams<void> removeDiscount({required String idOrder}) async {
    log("-- removeDiscount -- $idOrder");
    try {
      await datasource.removeDiscount(idOrder: idOrder);
      return const Right(null);
    } on ApiException catch (error) {
      log("-- removeDiscount ApiException -- ${error.message}");
      return Left(
          ApiFailure(message: error.message, statusCode: error.statusCode));
    } catch (e) {
      log("-- removeDiscount catch -- ${e.toString()}");
      return Left(ApiFailure(message: '$e', statusCode: 505));
    }
  }
}
