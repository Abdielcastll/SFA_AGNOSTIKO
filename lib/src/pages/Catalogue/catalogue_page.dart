import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/bottom_decoration.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarHome(
        title: 'Catalogo',
        backgroundColor: Color(0xFF4f42ed),
      ),
      bottomNavigationBar: const BottomDecoration(),
      backgroundColor: Colors.white,
      body: catalogueBody(),
    );
  }

  Widget catalogueBody() {
    return SingleChildScrollView(
      child: Column(
        children: [],
      ),
    );
  }
}
