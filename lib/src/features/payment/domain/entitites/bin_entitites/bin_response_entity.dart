import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/enums/card_brand_enum.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/enums/card_type_enum.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/enums/msi_enum.dart';

class BinResponseEntity {
  final String issuer;
  final String cardLevel;
  final CardType cardType;
  final CardBrand cardBrand;
  bool goToMsi;
  List<MSI> listMsi;

  BinResponseEntity({
    required this.issuer,
    required this.cardLevel,
    required this.cardType,
    required this.cardBrand,
    required this.goToMsi,
    required this.listMsi,
  });

  @override
  String toString() => '''
    BinResponse {
      issuer: $issuer,
      cardLevel: $cardLevel,
      cardType: ${cardType.mx},
      cardBrand: ${cardBrand.brand},
      goToMsi: $goToMsi,
      listMsi: $listMsi,
    }
  ''';
} 

