import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:agnostiko/agnostiko.dart';
import 'package:flutter/foundation.dart';
import 'package:pwa_sales2go_flutter/core/url_singleton.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/data/models/bin_models/bin_query_model.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/data/models/bin_models/bin_response_model.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/data/models/bin_models/pharos_bin_builder.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/datasources/payment_host_datasource.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/bin_entitites/bin_response_entity.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/enums/msi_enum.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/repositories/backoffice_auth_data.dart';
import 'package:pwa_sales2go_flutter/src/models/transaction_args.dart';
import 'package:http/http.dart' as http;

class PaymentHostDatasourcePharos implements PaymentHostDatasource {
  final UrlSingleton url = UrlSingleton();

  @override
  Future<BinResponseEntity?> getAvailableMsi(TransactionArgs? transProv) async {
    try {
      debugPrint("Let's build amount bin query");
      BinQueryModel binQuery = await _buildBinQuery();

      debugPrint("Let's send query");
      final response = await _fetchBin(binQuery);
      debugPrint("Let's parse the response to entity");
      BinResponseEntity binResponse =
          BinResponseModel.fromJson(jsonDecode(response.body)[0]).toEntity();
      debugPrint("Let's see the builded entity ${binResponse.toString()}");

      debugPrint("Let's obtain the msi according to amount");
      final double amount = transProv?.amountInCents?.toDouble() ?? 0.00;
      binResponse.listMsi = _checkAmount(amount / 100, binResponse.listMsi);
      binResponse.goToMsi = binResponse.listMsi.isNotEmpty;
      debugPrint("Let's see the available msi ${binResponse.listMsi.toString()}");

      return binResponse;
    } catch (e) {
      debugPrint("==> getAvailableMsi: Error al obtener msi disponibles $e");
      return null;
    }
  }

  Future<BinQueryModel> _buildBinQuery() async {
    // TODO obtener el bin de otra manera, el tag 5A a veces viene vacio
    final String cardBin = (await EmvModule.instance.getTagValue(0x57))
            ?.toHexStr()
            .substring(0, 6) ??
        "";
    final String apiKey = BackofficeAuthData().apiKey ?? "";

    return PharosBinBuilder.instance
        .pharosBin(cardBin)
        .pharosApiKey(apiKey)
        .build();
  }

  Future<http.Response> _fetchBin(BinQueryModel binQuery) async {
    try {
      final Uri uri = Uri.parse("${url.binUrl}${binQuery.bin}");

      final headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        "Authorization": binQuery.apiKey,
      };

      final response = await http.get(uri, headers: headers);
      // TODO Mejorar el manejo de errores
      if (response.statusCode != 200) {
        throw Exception(
            "Something went wrong retrieving BIN data ${response.body}\n status_code ${response.statusCode}");
      }

      debugPrint("This is the pharos response ${response.body}");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  List<MSI> _checkAmount(double amount, List<MSI> binMsi) {
    List<MSI> msi = [];
    int msiListLen = binMsi.length;

    debugPrint("Let's see the amount for msi $amount");
    if (amount >= 1200) {
      msi.addAll(binMsi);
    } else if (amount >= 900) {
      msi.addAll(binMsi.sublist(0, min(3, msiListLen)));
    } else if (amount >= 600) {
      msi.addAll(binMsi.sublist(0, min(2, msiListLen)));
    } else if (amount >= 300) {
      msi.addAll(binMsi.sublist(0, min(1, msiListLen)));
    }

    print("This is the final msi list ${msi.toString()}");

    return msi;
  }
}
