import 'package:pwa_sales2go_flutter/src/utils/typedef.dart';
import '../entities/discount.dart';

abstract class DiscountRepository {
  ResultParams<Discount> getDiscount({required String codigo});
  ResultParams<void> removeDiscount({required String idDiscount});
  ResultParams<void> addDiscountOrder({required String idDiscount, required String idOrder, required String idClient});
  ResultParams<void> addDiscountInvoice({required String idDiscount,required String idInvoice,required String idClient});


}
