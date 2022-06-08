import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/bottom_decoration.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarHome(
        title: 'Visitas',
        backgroundColor: Color(0xFF4f42ed),
      ),
      bottomNavigationBar: const BottomDecoration(),
      backgroundColor: Colors.white,
      body: visitsBody(),
    );
  }

  Widget visitsBody() {
    return SingleChildScrollView(
      child: Column(
        children: [],
      ),
    );
  }
}
