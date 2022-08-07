// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/product_in_cart.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/products.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/checkout_page.dart';

class SelectedProducts extends StatefulWidget {
  const SelectedProducts({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final OrderPage widget;

  @override
  State<SelectedProducts> createState() => _SelectedProductsState();
}

class _SelectedProductsState extends State<SelectedProducts> {
  List<Product> products = allProductInShoppingCart;

  cartStatus() {
    if (products.isEmpty) {
      return Text(
        'No hay productos seleccionados en su carrito',
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (products.isNotEmpty) {
      return;
    }
  }

  double totalPriceSum() {
    return products.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          alignment: Alignment.topLeft,
          color: Colors.transparent,
          child: cartStatus(),
        ),
        ProductsInCart(products: products, widget: widget.widget),
        Container(
          height: 133,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Total del pedido:',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000C99),
                    ),
                  ),
                  SizedBox(width: 100),
                  Text(
                    '\$ ${totalPriceSum().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000C99),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 340,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Agregar Productos
                      Navigator.pushNamed(context, 'catalogue');
                    },
                    icon: Icon(
                      MaterialCommunityIcons.tag_plus,
                      size: 17,
                    ),
                    label: Text(
                      'Agregar productos',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: myTheme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 340,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Continuar con la compra
                      print('Continuar con la compra');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CheckoutPage(widget: widget.widget),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: myTheme.colorScheme.secondary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CONTINUAR',
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                          child: Icon(
                            SimpleLineIcons.arrow_right,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
