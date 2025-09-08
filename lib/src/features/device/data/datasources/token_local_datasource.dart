import 'dart:typed_data';

import 'package:agnostiko/agnostiko.dart';
import 'package:pwa_sales2go_flutter/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/token_model.dart';

const cachedToken = 'CACHED_TOKEN';

abstract class TokenLocalDatasource {
  /// Gets the cached [TokenModel] which was gotten the last time we
  /// connect to server (if not expired)
  ///
  /// Throws a [CacheException] if no cahed token is present or is expired.
  Future<TokenModel> getToken(String serialNumber);

  ///
  Future<void> cacheToken(TokenModel tokenToSave);
}

class TokenLocalDatasourceImpl implements TokenLocalDatasource {
  final SharedPreferences sharedPreferences;

  TokenLocalDatasourceImpl({required this.sharedPreferences});

  bool _isTokenExpired(Uint8List authToken) {
    final expDateHex = authToken.sublist(257, 263);
    final expDateStr = expDateHex.toHexStr();
    final expDateToken = int.parse(expDateStr, radix: 16);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return expDateToken < timestamp;
  }

  @override
  Future<TokenModel> getToken(String serialNumber) {
    final tokenString = sharedPreferences.getString(cachedToken);

    if (tokenString == null) {
      throw CacheException(Error.emptyToken);
    }

    if (_isTokenExpired(tokenString.toHexBytes()) == true) {
      sharedPreferences.remove(cachedToken);
      throw CacheException(Error.expiredToken);
    }

    return Future.value(TokenModel.fromHexString(tokenString));
  }

  @override
  Future<void> cacheToken(TokenModel tokenToSave) {
    return sharedPreferences.setString(cachedToken, tokenToSave.toHexString());
  }
}
