import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/bin_entitites/bin_response_entity.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/enums/card_brand_enum.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/enums/card_type_enum.dart';
import 'package:pwa_sales2go_flutter/src/features/payment/domain/entitites/enums/msi_enum.dart';

class BinResponseModel {
  final int id;
  final String issuer;
  final String cardLevel;
  final String msi;
  final int binNumber;
  final int countryId;
  final bool isValid;
  final String cardType;
  final int cardBrandId;
  final List<String> listMsi;

  BinResponseModel({
    required this.id,
    required this.issuer,
    required this.cardLevel,
    required this.msi,
    required this.binNumber,
    required this.countryId,
    required this.isValid,
    required this.cardType,
    required this.cardBrandId,
    required this.listMsi,
  });

  factory BinResponseModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> jsonList =
        json["list_msi"] is List ? json["list_msi"] : [];
    final List<String> msiStringList =
        jsonList.map((e) => e.toString()).toList();

    return BinResponseModel(
      id: json["id"] ?? 0,
      issuer: json["issuer"] ?? "",
      cardLevel: json["card_level"] ?? "",
      msi: json["msi"] ?? "",
      binNumber: json["bin_number"] ?? 0,
      countryId: json["country_id"] ?? 0,
      isValid: json["is_valid"] ?? false,
      cardType: json["card_type"] ?? "",
      cardBrandId: json["card_brand_id"] ?? "",
      listMsi: msiStringList,
    );
  }

  BinResponseEntity toEntity() => BinResponseEntity(
        issuer: issuer,
        cardLevel: cardLevel,
        cardType: CardType.fromString(cardType),
        listMsi: MSI.fromListString(listMsi),
        cardBrand: CardBrand.fromBrandId(cardBrandId),
        goToMsi: listMsi.isNotEmpty,
      );

  @override
  String toString() => """
  BinResponseModel {
    id: $id,
    issuer: $issuer,
    card_level: $cardLevel,
    msi: $msi,
    bin_number: $binNumber,
    country_id: $countryId,
    is_valid: $isValid,
    card_type: $cardType,
    card_brand_id: $cardBrandId,
    list_msi: ${listMsi.toString()},
  }
  """;
}
