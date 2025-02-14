import 'package:pwa_sales2go_flutter/src/features/payment/domain/datasources/payment_host_datasource.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/bin_entitites/bin_response_entity.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/repositories/payment_repository.dart';
import 'package:pwa_sales2go_flutter/src/models/transaction_args.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentHostDatasource datasource;

  PaymentRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<BinResponseEntity?> getAvailableMsi(TransactionArgs? transProv) {
    return datasource.getAvailableMsi(transProv);
  }
  
}