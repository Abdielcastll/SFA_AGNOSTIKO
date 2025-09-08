import 'dart:typed_data';

import 'package:agnostiko/agnostiko.dart';
import 'package:http/http.dart' as http;
import 'package:pwa_sales2go_flutter/core/error/exception.dart';

import '../models/token_model.dart';

//Original
// const agnostikoUrl =
//     'https://server-agnostiko-web-gnbxyenkeq-ue.a.run.app/token';
//Demo
const demoUrl = "https://tms-server-demo.apps2go.tech";
//Production
const productionUrl = "https://insightone-server.agnostiko.com";

const appId = "com.example.field_sales";

abstract class TokenRemoteDatasource {
  /// Calls the https://server-agnostiko-web-gnbxyenkeq-ue.a.run.app/token/{serialNumber} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<TokenModel> getToken(String serialNumber);
}

class TokenRemoteDatasourceImpl implements TokenRemoteDatasource {
  final http.Client client;

  TokenRemoteDatasourceImpl({required this.client});

  @override
  Future<TokenModel> getToken(String serialNumber) async {
    try {
      final brand = (await getPlatformInfo()).deviceBrand;
      Uint8List? authToken = await _getTokenOnline(serialNumber, brand);

      if (authToken == null) {
        throw ServerException(Error.requestFailed);
      }
      return TokenModel(value: authToken);
    } on Exception {
      throw ServerException(Error.requestFailed);
    }
  }

  Future<Uint8List?> _getTokenOnline(String serialNumber, String brand) async {
    Uint8List authToken;
    try {
      authToken = await getSDKToken(productionUrl, brand, serialNumber, appId);
    } catch (e) {
      try {
        authToken = await getSDKToken(demoUrl, brand, serialNumber, appId);
      } catch (e) {
        return null;
      }
    }
    return authToken;
  }
}
