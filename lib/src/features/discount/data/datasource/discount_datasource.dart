import 'package:flutter/foundation.dart';
import 'package:pwa_sales2go_flutter/core/error/exception.dart';
import 'package:pwa_sales2go_flutter/src/utils/typedef.dart';

import '../models/discount_model.dart';

abstract class DiscountDatasource {
  DiscountModel getDiscounts({required String codigo});
  Future<void> removeDiscount({required String idOrder});
}

class DiscountDatasourceFirebase extends DiscountDatasource {
  // final InventaryLocal _inventory = InventaryLocal();
  // final FirebaseServiceManager _firebaseService = FirebaseServiceManager();

  @override
  DiscountModel getDiscounts({required String codigo}) {
    try {
      /* final inventoryData = _inventory.getInventory;
      final List<DataMap>? discountInventory = inventoryData.discount;
      DiscountModel? discountModel;
      if (discountInventory == null) {
        throw const ApiException(
            message: 'No discounts were found', statusCode: 401);
      }
      for (var discount in discountInventory) {
        if (discount['codigo'] == codigo) {
          if (discount['activo'] == false) {
            throw const ApiException(
                message: 'The discount is not active', statusCode: 401);
          }

          discountModel = DiscountModel.fromMap(discount);
        }
      }
      if (discountModel == null) {
        throw const ApiException(
            message: 'The discount does not exist', statusCode: 401);
      }
*/
      return DiscountModel.empty();
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
  Future<void> removeDiscount({required String idOrder}) async {
    try {
      /*final inventoryData = _inventory.getInventory;
      final OrderModel? order = inventoryData.order;

      if (order == null) {
        throw const ApiException(
            message: 'It is necessary to create an order', statusCode: 401);
      }
      if (order.discount == null) {
        return;
      }

      await _firebaseService.disableDiscount(
        isDisabled: true,
        idDiscount: order.discount!.codigo,
      );

      order.discount = null;*/
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
}
