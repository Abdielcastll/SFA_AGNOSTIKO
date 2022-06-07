import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/Catalogue/catalogue_tab.dart';
import 'package:pwa_sales2go_flutter/src/pages/Catalogue/promotions_tab.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/drawer/drawer_widget.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const DrawerWidget(),
        appBar: const AppBarHome(
          title: 'Catalogo',
          backgroundColor: Color(0xFF4f42ed),
        ),
        body: Container(
          // decoration: BoxDecoration(),
          child: const TabBarView(
            children: [
              PromotionTab(),
              CatalogueTab(),
            ],
          ),
        ),
      ),
    );
  }
}
