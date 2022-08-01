// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/catalogue/components/category_gridview.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/catalogue/components/promotion_swiper.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_catalogue.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  @override
  Widget build(BuildContext context) {
    print('pantalla catalogo activa');

    return Scaffold(
      appBar: AppBarCatalogue(),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Text(
                'PROMOCIONES',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: myTheme.colorScheme.secondary,
                  fontSize: 18,
                  fontFamily: 'Poppins-regular',
                ),
              ),
            ),
            SizedBox(height: 10),
            PromotionSwiper(),
            SizedBox(height: 20),
            CategoryGridView(),
          ],
        ),
      ),
    );
  }
}
