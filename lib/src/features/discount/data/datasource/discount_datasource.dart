import 'package:flutter/foundation.dart';
import 'package:pwa_sales2go_flutter/core/error/exception.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';

import '../models/discount_model.dart';

abstract class DiscountDatasource {
  Future<DiscountModel> getDiscounts({required String codigo});
  Future<void> removeDiscount({required String idDiscount});
  Future<void> addDiscountOrder(
      {required String idDiscount,
      required String idOrder,
      required String idClient});
  Future<void> addDiscountInvoice(
      {required String idDiscount,
      required String idInvoice,
      required String idClient});
}

class DiscountDatasourceFirebase extends DiscountDatasource {
  @override
  Future<DiscountModel> getDiscounts({required String codigo}) async {
    try {
      final discountdata = await getDiscountData();
      DiscountModel? discountModel;

      if (discountdata.isEmpty) {
        print(" ************* ERROR No discounts were found");
        throw const ApiException(
            message: 'No discounts were found', statusCode: 401);
      }
      for (var discount in discountdata) {
        if (discount['codigo'] == codigo) {
          if (discount['activo'] == false) {
            print(" ************* ERROR The discount is not active");
            throw const ApiException(
                message: 'The discount is not active', statusCode: 401);
          }

          discountModel = DiscountModel.fromMap(discount);
        }
      }
      if (discountModel == null) {
        print(" ************* ERROR The discount does not exist");
        throw const ApiException(
            message: 'The discount does not exist', statusCode: 401);
      }

      return discountModel;
    } on Exception catch (e, s) {
      print(" ************* ERROR  Exception${e.toString()}");
      debugPrintStack(stackTrace: s);
      throw ApiException(
        message: e.toString(),
        statusCode: 505,
      );
    } catch (e) {
      print(" ************* ERROR catch ${e.toString()}");
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> removeDiscount({required String idDiscount}) async {
    try {
      await disableDiscount(
        isDisabled: true,
        idDiscount: idDiscount,
      );
    } on Exception catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ApiException(
        message: e.toString(),
        statusCode: 505,
      );
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> addDiscountInvoice(
      {required String idDiscount,
      required String idInvoice,
      required String idClient}) async {
    try {
      await addInvoiceDiscount(
          idClient: idClient, idInvoice: idInvoice, idDiscount: idDiscount);
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> addDiscountOrder(
      {required String idDiscount,
      required String idOrder,
      required String idClient}) async {
    try {
      await addOrdenDiscount(
          idClient: idClient, idOrden: idOrder, idDiscount: idDiscount);
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }
}
