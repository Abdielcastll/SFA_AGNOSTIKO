// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/examples/clients_example.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/product_in_cart.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/products.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/checkout_page.dart';

class SelectedProducts extends StatefulWidget {
  const SelectedProducts({
    Key? key,
    required this.client,
  }) : super(key: key);

  final CLientsExample client;

  @override
  State<SelectedProducts> createState() => _SelectedProductsState();
}

class _SelectedProductsState extends State<SelectedProducts> {
  List<Product> products = allProductInShoppingCart;
  String moneySymbol = '\$';

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
    double total = products.fold(0.0, (sum, item) => (sum + item.totalPrice));
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double subTotalPrice = totalPriceSum();
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          alignment: Alignment.topLeft,
          color: Colors.transparent,
          child: cartStatus(),
        ),
        ProductsInCart(products: products, client: widget.client),
        Container(
          height: 133,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Text(
                      '$moneySymbol ${subTotalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff000C99),
                      ),
                    ),
                  ],
                ),
              ),
              products.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 340,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            MaterialCommunityIcons.tag_plus,
                            size: 17,
                          ),
                          label: Text(
                            'Agregar productos',
                            style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                color: Colors.grey.shade300),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.grey.shade500),
                        ),
                      ),
                    )
                  : Container(
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
                            primary: myTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 10),
              products.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey.shade500,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'CONTINUAR',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  fontSize: 14,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                                child: Icon(
                                  SimpleLineIcons.arrow_right,
                                  size: 14,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ElevatedButton(
                          onPressed: () {
                            // Continuar con la compra
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                    client: widget.client,
                                    cart: products,
                                    subTotalPrice: subTotalPrice),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: myTheme.colorScheme.primary,
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
                                  color: Colors.grey.shade300,
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
