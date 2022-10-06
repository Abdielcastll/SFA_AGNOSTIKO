// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_client.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_products.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_orderd.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  final Clients? client;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBarOrder(),
      body: Column(
        children: [
          SelectedClient(client: widget.client, isEditable: true),
          SelectedProducts(client: widget.client),
        ],
      ),
    );
  }
}
