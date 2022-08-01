// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/products.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_client.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_orderd.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class OrderPage extends StatefulWidget {
  const OrderPage(
      {Key? key,
      required this.clientName,
      required this.clientStatus,
      required this.clientAddress})
      : super(key: key);

  final String clientName;
  final String clientStatus;
  final String clientAddress;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBarOrder(),
      body: OrderBody(widget: widget),
      bottomNavigationBar: const BottomDecoration(),
    );
  }
}

class OrderBody extends StatelessWidget {
  const OrderBody({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final OrderPage widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectedClient(widget: widget),
        SelectedProducts(),
      ],
    );
  }
}

class SelectedProducts extends StatefulWidget {
  const SelectedProducts({
    Key? key,
  }) : super(key: key);

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
      return Text(
        'Tu Carrito',
        style: TextStyle(
          color: myTheme.colorScheme.secondary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      );
    }
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
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: myTheme.colorScheme.secondary.withOpacity(0.4),
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: ListTile(
                    leading: Image.network(
                      product.urlImg,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                    title: Text(
                      product.productName,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
