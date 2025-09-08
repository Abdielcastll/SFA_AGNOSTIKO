import 'dart:typed_data';

import 'package:agnostiko/agnostiko.dart';
import 'package:pwa_sales2go_flutter/src/features/device/domain/entities/token.dart';

class TokenModel extends Token {
  const TokenModel({required Uint8List value}) : super(value: value);

  factory TokenModel.fromHexString(String hexString) {
    return TokenModel(value: hexString.toHexBytes());
  }

  String toHexString() {
    return value.toHexStr();
  }
}
