import 'package:objectbox/objectbox.dart';

@Entity()
class ShoppingCartProduct {
  int id;
  int? productQuantity;
  String? code;
  String? productId;
  String? listOfPricesId;
  double? totalAmount;
  String? name;
  String? promotion;
  double? unitPrice;
  String? urlPicture;

  ShoppingCartProduct({
    this.id = 0,
    this.productQuantity,
    this.code,
    this.productId,
    this.listOfPricesId,
    this.totalAmount,
    this.name,
    this.promotion,
    this.unitPrice,
    this.urlPicture,
  });
}
