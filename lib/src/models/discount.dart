import 'package:cloud_firestore/cloud_firestore.dart';

class Discount {
  late DiscountTypes _type;
  double discount;

  DiscountTypes get type => _type;

  Discount({required this.discount}) {
    _setType();
  }

  void _setType() {
    _type = DiscountTypes.discount;
  }
}

class DiscountByPaymentMethod extends Discount {
  List<PaymentMethods> paymentMethods;

  DiscountByPaymentMethod(
      {required super.discount, required this.paymentMethods});

  @override
  void _setType() {
    _type = DiscountTypes.paymentMethod;
  }
}

class DiscountByBank extends Discount {
  String bank;

  DiscountByBank({required super.discount, required this.bank});

  @override
  void _setType() {
    _type = DiscountTypes.paymentMethod;
  }
}

class DiscountByProductsBrand extends Discount {
  int productsCant;
  String brand;

  DiscountByProductsBrand(
      {required super.discount,
      required this.productsCant,
      required this.brand});

  @override
  void _setType() {
    _type = DiscountTypes.productsBrand;
  }
}

enum DiscountTypes {
  discount,
  paymentMethod,
  productsBrand,
  bank,
}

enum PaymentMethods {
  cash,
  debitCard,
  creditCard,
  check,
  transfer;

  static PaymentMethods fromString(String pm) {
    switch (pm) {
      case 'efectivo':
        return PaymentMethods.cash;
      case 'tarjeta_credito':
        return PaymentMethods.creditCard;
      case 'tarjeta_debito':
        return PaymentMethods.debitCard;
      case 'transferencia':
        return PaymentMethods.transfer;
      case 'cheque':
        return PaymentMethods.check;
      default:
        return PaymentMethods.cash;
    }
  }
}

List defaultDiscounts = [
  Discount(discount: 0.05),
  Discount(discount: 0.10),
  Discount(discount: 0.15),
  Discount(discount: 0.20),
  Discount(discount: 0.25),
  Discount(discount: 0.30),
  Discount(discount: 0.35),
  Discount(discount: 0.40),
  Discount(discount: 0.45),
  Discount(discount: 0.50),
];

List discountByMethodPayment = [
  DiscountByPaymentMethod(
      discount: 0.025,
      paymentMethods: [PaymentMethods.debitCard, PaymentMethods.creditCard]),
  DiscountByPaymentMethod(
      discount: 0.05, paymentMethods: [PaymentMethods.cash]),
];

List discountByBanks = [
  DiscountByBank(discount: 0.03, bank: "BBVA"),
  DiscountByBank(discount: 0.05, bank: "Banesco"),
  DiscountByBank(discount: 0.025, bank: "BNC"),
];

Future<List<Discount>> getDiscounts() async {
  final discounts =
      await FirebaseFirestore.instance.collection('descuentos').get();

  print("DESCUENTOS");
  List<Discount> res = [];
  for (var element in discounts.docs) {
    final type = element.get("tipo");
    print(type);
    Discount newDiscount;
    switch (type) {
      case "productosPorMarca":
        newDiscount = DiscountByProductsBrand(
            discount: element.get("descuento"),
            productsCant: element.get("cant_productos"),
            brand: element.get("marca").id);
        break;
      case "tipoDePago":
        List<PaymentMethods> paymentMethods = [];

        for (final paymentMethod in (element.get("tipos_pago") as Map).values) {
          paymentMethods.add(PaymentMethods.fromString(paymentMethod));
        }

        newDiscount = DiscountByPaymentMethod(
            discount: element.get("descuento"), paymentMethods: paymentMethods);
        break;
      case "banco":
        newDiscount = DiscountByBank(
            discount: element.get("descuento"), bank: element.get("banco"));
        break;
      default:
        newDiscount = Discount(discount: element.get("descuento"));
        break;
    }

    res.add(newDiscount);
  }
  print(res);

  return res;
}
