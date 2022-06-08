import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/bottom_decoration.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarHome(
        title: 'Pedidos',
        backgroundColor: Color(0xFF4f42ed),
      ),
      bottomNavigationBar: const BottomDecoration(),
      backgroundColor: Colors.white,
      body: ordersBody(),
    );
  }

  Widget ordersBody() {
    return SingleChildScrollView(
      child: Column(
        children: [],
      ),
    );
  }
}
