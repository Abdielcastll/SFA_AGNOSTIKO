import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/bottom_decoration.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({Key? key}) : super(key: key);

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarHome(
        title: 'Facturas',
        backgroundColor: Color(0xFF4f42ed),
      ),
      bottomNavigationBar: const BottomDecoration(),
      backgroundColor: Colors.white,
      body: cartBody(),
    );
  }

  Widget cartBody() {
    return SingleChildScrollView(
      child: Column(
        children: [],
      ),
    );
  }
}
