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
      debugPrint("getAvailableMsi in");
      BinQueryModel binQuery = await _buildBinQuery();

      final response = await _fetchBin(binQuery);
      BinResponseEntity binResponse =
          BinResponseModel.fromJson(jsonDecode(response.body)[0]).toEntity();
      debugPrint("Bin entity ${binResponse.toString()}");

      final double amount = transProv?.amountInCents?.toDouble() ?? 0.00;
      binResponse.listMsi = _checkAmount(amount / 100, binResponse.listMsi);
      binResponse.goToMsi = binResponse.listMsi.isNotEmpty;
      debugPrint("Available msi list: ${binResponse.listMsi.toString()}");

      return binResponse;
    } catch (e) {
      debugPrint("==> getAvailableMsi: Error al obtener msi disponibles $e");
      return null;
    }
  }

  Future<BinQueryModel> _buildBinQuery() async {
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
      debugPrint("fetching bin...");
      final Uri uri = Uri.parse("${url.binUrl}${binQuery.bin}");

      final headers = {
        HttpHeaders.contentTypeHeader: "application/json",
        "Authorization": binQuery.apiKey,
      };

      final response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 10));
      // TODO Mejorar el manejo de errores
      if (response.statusCode != 200) {
        throw Exception(
            "Something went wrong retrieving BIN data ${response.body}\n status_code ${response.statusCode}");
      }

      debugPrint("pharos bin response ${response.body}");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  List<MSI> _checkAmount(double amount, List<MSI> binMsi) {
    List<MSI> msi = [];
    int msiListLen = binMsi.length;

    debugPrint("msi amount to check: $amount");
    if (amount >= 1200) {
      msi.addAll(binMsi);
    } else if (amount >= 900) {
      msi.addAll(binMsi.sublist(0, min(3, msiListLen)));
    } else if (amount >= 600) {
      msi.addAll(binMsi.sublist(0, min(2, msiListLen)));
    } else if (amount >= 300) {
      msi.addAll(binMsi.sublist(0, min(1, msiListLen)));
    }

    return msi;
  }
}
