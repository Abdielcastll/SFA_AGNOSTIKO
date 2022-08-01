import 'package:flutter/material.dart';

class Product {
  final String productName;
  final int productUnits;
  final double unitPrice;
  final double totalPrice;
  final String urlImg;

  const Product({
    required this.productName,
    required this.productUnits,
    required this.unitPrice,
    required this.totalPrice,
    required this.urlImg,
  });
}

const allProductInShoppingCart = [
  Product(
      productName: 'ALMOHADA CLASS.KING NAC.NIEVE FIRME',
      productUnits: 10,
      unitPrice: 23.10,
      totalPrice: 23.10 * 10,
      urlImg:
          'https://colchonesvelez.com/wp-content/uploads/2017/01/almohadas-50x70-1.jpg'),
  Product(
    productName: 'ALMOHADA CLASS.KING.HOT.NAC.NIEVE FIRME S/ESTUCHE',
    productUnits: 3,
    unitPrice: 20.50,
    totalPrice: 20.50 * 3,
    urlImg:
        'https://colchonesvelez.com/wp-content/uploads/2017/01/almohadas-50x70-1.jpg',
  ),
  Product(
    productName: 'BATA KIMONO WAFFLE T-G  BRIDE & GLEN SANDERS MANSION',
    productUnits: 1,
    unitPrice: 30.00,
    totalPrice: 30.00 * 1,
    urlImg:
        'https://www.dhresource.com/0x0/f2/albu/g6/M01/68/40/rBVaR1uIA4CAQHdJAAJ_9Lkj9oc080.jpg',
  ),
  Product(
    productName: 'BATA T-G KIM MIX 340 HEALTHCARE',
    productUnits: 1,
    unitPrice: 31.10,
    totalPrice: 31.10 * 1,
    urlImg:
        'http://cdn.shopify.com/s/files/1/0444/6257/1670/products/kassatex_bathrobe_cream_s_m_1200x1200.jpg?v=1598566880',
  ),
];
