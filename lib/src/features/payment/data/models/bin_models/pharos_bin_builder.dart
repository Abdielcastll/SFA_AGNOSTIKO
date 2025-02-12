import 'package:pwa_sales2go_flutter/src/features/payment/data/models/bin_models/bin_query_model.dart';

class PharosBinBuilder {
  final BinQueryModel binQuery = BinQueryModel();
  
  PharosBinBuilder._();

  static PharosBinBuilder get instance => PharosBinBuilder._();

  PharosBinBuilder pharosBin(String bin) {
    binQuery.bin = bin;
    return this;
  }

  PharosBinBuilder pharosApiKey(String apiKey){
    binQuery.apiKey = apiKey;
    return this;
  }

  BinQueryModel build() {
    return binQuery;
  }
}