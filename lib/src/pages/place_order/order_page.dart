// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/products.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_client.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_products.dart';
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
      backgroundColor: Colors.grey.shade100,
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
        SelectedProducts(widget: widget),
      ],
    );
  }
}
