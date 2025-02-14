import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/bin_entitites/bin_response_entity.dart';
import 'package:pwa_sales2go_flutter/src/models/transaction_args.dart';

abstract class PaymentRepository {
  Future<BinResponseEntity?> getAvailableMsi(TransactionArgs? transProv);
}