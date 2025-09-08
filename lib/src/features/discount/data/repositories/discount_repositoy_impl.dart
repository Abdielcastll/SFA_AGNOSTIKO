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
  ResultParams<Discount> getDiscount({required String codigo}) async{
    try {
      final Discount discount = await  datasource.getDiscounts(codigo: codigo);
      return Right(discount);
    } on ApiException catch (error) {
      return Left(
          ApiFailure(message: error.message, statusCode: error.statusCode));
    } catch (e) {
      return Left(ApiFailure(message: '$e', statusCode: 505));
    }
  }

  @override
  ResultParams<void> removeDiscount({required String idDiscount}) async {
    log("-- removeDiscount -- $idDiscount");
    try {
      await datasource.removeDiscount(idDiscount: idDiscount);
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
  
  @override
  ResultParams<void> addDiscountInvoice({required String idDiscount, required String idInvoice,required String idClient}) {
    // TODO: implement addDiscountInvoice
    throw UnimplementedError();
  }
  
  @override
  ResultParams<void> addDiscountOrder({required String idDiscount, required String idOrder,required String idClient}) {
    // TODO: implement addDiscountOrder
    throw UnimplementedError();
  }
}
