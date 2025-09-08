import 'package:equatable/equatable.dart';

class Discount extends Equatable {
  final bool? active;
  final String name;
  final double amount;
  final String codigo;
  final String type;
  final DateTime? expirationDate;

  const Discount(
      {required this.active,
      required this.amount,
      required this.name,
      required this.codigo,
      required this.type,
      this.expirationDate});

  const Discount.empty()
      : this(active: false, name: '', codigo: '', type: '', amount: 0.0);

  @override
  List<Object?> get props =>
      [active, name, codigo, type, expirationDate, amount];
}
