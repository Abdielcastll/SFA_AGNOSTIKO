// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/examples/clients_example.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/products.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_client.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/selected_products.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_orderd.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  final CLientsExample client;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBarOrder(),
      body: OrderBody(client: widget.client),
      bottomNavigationBar: const BottomDecoration(),
    );
  }
}

class OrderBody extends StatelessWidget {
  const OrderBody({
    Key? key,
    required this.client,
  }) : super(key: key);

  final CLientsExample client;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectedClient(client: client, isEditable: true),
        SelectedProducts(client: client),
      ],
    );
  }
}
