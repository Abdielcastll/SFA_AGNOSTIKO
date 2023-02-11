import 'package:objectbox/objectbox.dart';

@Entity()
class ShoppingCartProduct {
  int id;
  int? productQuantity;
  int? availableStock;
  String? code;
  String? productId;
  String? listOfPricesId;
  String? totalAmount;
  String? name;
  String? promotion;
  String? unitPrice;
  String? urlPicture;

  ShoppingCartProduct({
    this.id = 0,
    this.productQuantity,
    this.availableStock,
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
