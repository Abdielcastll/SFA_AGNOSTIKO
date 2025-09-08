import 'package:pwa_sales2go_flutter/src/utils/typedef.dart';
import '../entities/discount.dart';

abstract class DiscountRepository {
  ResultParam<Discount> getDiscount({required String codigo});
  ResultParams<void> removeDiscount({required String idOrder});
}
