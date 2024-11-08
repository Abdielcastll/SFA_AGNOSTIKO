import 'dart:typed_data';

import 'package:agnostiko/agnostiko.dart';

class Tags {
  Uint8List? tag9A;
  Uint8List? tagC0;
  Uint8List? tag9F26;
  Uint8List? tag9B;
  Uint8List? tag4F;
  Uint8List? tag9F27;
  Uint8List? tag9F10;
  Uint8List? tag5F2A;
  Uint8List? tag9F09;
  Uint8List? tag9F35;
  Uint8List? tag9F02;
  Uint8List? tag82;
  Uint8List? tag9F34;
  Uint8List? tag9F36;
  Uint8List? tag9F03;
  Uint8List? tag9F1A;
  Uint8List? tag9F37;
  Uint8List? tag9F1E;
  Uint8List? tag9C;
  Uint8List? tag5F34;
  Uint8List? tag95;
  Uint8List? tag9F33;
  Uint8List? tag9F6E;
  Uint8List? tag9F66;
  Uint8List? tag9F6C;

  Tags({
    this.tag9A,
    this.tagC0,
    this.tag9F26,
    this.tag9B,
    this.tag4F,
    this.tag9F27,
    this.tag9F10,
    this.tag5F2A,
    this.tag9F09,
    this.tag9F35,
    this.tag9F02,
    this.tag82,
    this.tag9F34,
    this.tag9F36,
    this.tag9F03,
    this.tag9F1A,
    this.tag9F37,
    this.tag9F1E,
    this.tag9C,
    this.tag5F34,
    this.tag95,
    this.tag9F33,
    this.tag9F6E,
    this.tag9F66,
    this.tag9F6C,
  });

  Map<String, dynamic> toJson() {
    return {
      '9A': tag9A?.toHexStr().toUpperCase(),
      'C0': tagC0?.toHexStr().toUpperCase(),
      '9F26': tag9F26?.toHexStr().toUpperCase(),
      '9B': tag9B?.toHexStr().toUpperCase(),
      '4F': tag4F?.toHexStr().toUpperCase(),
      '9F27': tag9F27?.toHexStr().toUpperCase(),
      '9F10': tag9F10?.toHexStr().toUpperCase(),
      '5F2A': tag5F2A?.toHexStr().toUpperCase(),
      '9F09': tag9F09?.toHexStr().toUpperCase(),
      '9F35': tag9F35?.toHexStr().toUpperCase(),
      '9F02': tag9F02?.toHexStr().toUpperCase(),
      '82': tag82?.toHexStr().toUpperCase(),
      '9F34': tag9F34?.toHexStr().toUpperCase(),
      '9F36': tag9F36?.toHexStr().toUpperCase(),
      '9F03': tag9F03?.toHexStr().toUpperCase(),
      '9F1A': tag9F1A?.toHexStr().toUpperCase(),
      '9F37': tag9F37?.toHexStr().toUpperCase(),
      '9F1E': tag9F1E?.toHexStr().toUpperCase(),
      '9C': tag9C?.toHexStr().toUpperCase(),
      '5F34': tag5F34?.toHexStr().toUpperCase(),
      '95': tag95?.toHexStr().toUpperCase(),
      '9F33': tag9F33?.toHexStr().toUpperCase(),
      '9F6E': tag9F6E?.toHexStr().toUpperCase(),
      '9F66': tag9F66?.toHexStr().toUpperCase(),
      '9F6C': tag9F6C?.toHexStr().toUpperCase(),
    };
  }
}
