import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pwa_sales2go_flutter/src/features/discount/discount_data.dart';
import 'package:pwa_sales2go_flutter/src/utils/callbacks.dart';
import 'package:pwa_sales2go_flutter/src/utils/typedef.dart';

class DiscountModel extends Discount {
  const DiscountModel(
      {required super.name,
      required super.active,
      required super.codigo,
      required super.type,
      required super.amount,
      super.expirationDate});

  DiscountModel.fromMap(DataMap map)
      : this(
            name: map['nombre'] as String,
            active: map['activo'] as bool,
            codigo: map['codigo'] as String,
            type: map['tipo'] as String,
            amount: double.parse('${map['cantidad'] ?? '0'}'),
            expirationDate: safeCallback<DateTime, Timestamp>(
                map['fecha_expiracion'],
                (timestamp) => DateTime.fromMillisecondsSinceEpoch(
                    timestamp.seconds * 1000 +
                        timestamp.nanoseconds ~/ 1000000)));

  factory DiscountModel.fromJson(String json) =>
      DiscountModel.fromMap(jsonDecode(json) as DataMap);

  DataMap toMap() => {
        'nombre': name,
        'activo': active,
        'codigo': codigo,
        'tipo': type,
        'cantidad': amount,
        'fecha_expiracion': expirationDate
      };

  String toJson() => jsonEncode(toMap());

  const DiscountModel.empty()
      : this(
            name: '',
            active: false,
            codigo: '',
            type: '',
            amount: 0,
            expirationDate: null);

  @override
  String toString() => """
  BinResponseModel {
    name:$name,
    active:$active,
    codigo:$codigo,
    type:$type,
    amount:$amount,
    expirationDate:$expirationDate
  }
  """;

  DiscountModel copyWith(
      {String? name,
      bool? active,
      String? codigo,
      String? type,
      double? amount,
      DateTime? expirationDate}) {
    return DiscountModel(
        name: name ?? this.name,
        active: active ?? this.active,
        codigo: codigo ?? this.codigo,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        expirationDate: expirationDate ?? this.expirationDate);
  }
}
