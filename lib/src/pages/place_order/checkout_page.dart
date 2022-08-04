// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/completed_order.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/products.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_checkout.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key, required this.widget}) : super(key: key);

  final OrderPage widget;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCheckout(),
      bottomNavigationBar: const BottomDecoration(),
      backgroundColor: Colors.grey.shade100,
      body: CheckoutBody(client: widget.widget),
    );
  }
}

class CheckoutBody extends StatefulWidget {
  const CheckoutBody({
    Key? key,
    required this.client,
  }) : super(key: key);

  final OrderPage client;

  @override
  State<CheckoutBody> createState() => _CheckoutBodyState();
}

class _CheckoutBodyState extends State<CheckoutBody> {
  List<Product> products = allProductInShoppingCart;

  double totalPriceSum() {
    return products.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          height: 160,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(14, 16, 14, 0),
                color: Colors.transparent,
                child: Text(
                  'Verifique los detalles de su pedido.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: myTheme.colorScheme.secondary,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(14, 16, 14, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nombre del Cliente:',
                      style: TextStyle(
                        color: myTheme.colorScheme.secondary,
                        fontFamily: 'Poppins-regular',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.client.clientName,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins-regular',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(14, 5, 14, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Direccion:',
                      style: TextStyle(
                        color: myTheme.colorScheme.secondary,
                        fontFamily: 'Poppins-regular',
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      width: 200,
                      child: Text(
                        widget.client.clientAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins-regular',
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 14, 0, 0),
          child: Text(
            'Pedido',
            style: TextStyle(
              color: myTheme.colorScheme.secondary,
              fontFamily: 'Poppins-regular',
              fontSize: 20,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  height: 30,
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  padding: EdgeInsets.fromLTRB(10, 3, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          product.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'U: ${product.productUnits}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: myTheme.colorScheme.secondary,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        child: Text(
                          '\$ ${product.unitPrice}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.purple.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 5),
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
            child: ElevatedButton(
              onPressed: () {
                // Continuar con la compra
                print('Continuar a Completado');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompletedOrderPage(),
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
                    'Completar pedido',
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
    );
  }
}
