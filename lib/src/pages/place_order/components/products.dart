import 'package:flutter/material.dart';

class Product {
  final String productName;
  final int productUnits;
  final double unitPrice;
  final double totalPrice;
  final String urlImg;
  final bool? promotion;

  Product({
    required this.productName,
    required this.productUnits,
    required this.unitPrice,
    required this.totalPrice,
    required this.urlImg,
    this.promotion,
  });
}

List<Product> allProductInShoppingCart = [
  Product(
      productName: 'ALMOHADA CLASS.KING NAC.NIEVE FIRME',
      productUnits: 10,
      unitPrice: 23.13,
      totalPrice: 23.13 * 10,
      promotion: true,
      urlImg:
          'https://colchonesvelez.com/wp-content/uploads/2017/01/almohadas-50x70-1.jpg'),
  Product(
    productName: 'ALMOHADA CLASS.KING.HOT.NAC.NIEVE FIRME S/ESTUCHE',
    productUnits: 3,
    unitPrice: 20.50,
    totalPrice: 20.50 * 3,
    promotion: false,
    urlImg:
        'https://ae01.alicdn.com/kf/Hafdfe64334a94c59bc3277cd48aa5e5ao/Almohada-central-para-Hotel-almohada-de-cinco-estrellas-de-Color-puro-de-alta-calidad-para-el.jpg_Q90.jpg_.webp',
  ),
  Product(
    productName: 'BATA KIMONO WAFFLE T-G  BRIDE & GLEN SANDERS MANSION',
    productUnits: 1,
    unitPrice: 30.00,
    totalPrice: 30.00 * 1,
    promotion: true,
    urlImg:
        'https://www.dhresource.com/0x0/f2/albu/g6/M01/68/40/rBVaR1uIA4CAQHdJAAJ_9Lkj9oc080.jpg',
  ),
  Product(
    productName: 'BATA T-G KIM MIX 340 HEALTHCARE',
    productUnits: 1,
    unitPrice: 31.10,
    totalPrice: 31.10 * 1,
    promotion: false,
    urlImg:
        'http://cdn.shopify.com/s/files/1/0444/6257/1670/products/kassatex_bathrobe_cream_s_m_1200x1200.jpg?v=1598566880',
  ),
];
