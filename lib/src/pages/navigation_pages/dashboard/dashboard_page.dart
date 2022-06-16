//Flutter
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
//Variable global
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
//Widgets
import 'package:pwa_sales2go_flutter/src/widgets/appbar/bottom_decoration.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Usuario conectado:');
    print(sharedPreferences!.getString('uid'));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            _ListCategories(),
            SizedBox(height: 10.0),
            _PromotionSwiper(),
            SizedBox(height: 30.0),
            _CategoryListView(),
          ],
        ),
      ),
    );
  }
}

class _ListCategories extends StatelessWidget {
  const _ListCategories({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Acceso rapido',
      'Acceso rapido',
      'Acceso rapido',
      'Nuevo pedido',
    ];
    final icons = [
      Icons.expand_more,
      Icons.expand_more,
      Icons.expand_more,
      Icons.add_shopping_cart_rounded,
    ];

    return Container(
      padding: EdgeInsets.only(top: 10.0, left: 8.0),
      width: double.infinity,
      height: 90.0,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int i) {
          final cName = categories[i];
          final cIcon = icons[i];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                _CategoryButton(
                  iconCategory: cIcon,
                ),
                SizedBox(height: 8.0),
                Text(
                  cName,
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    Key? key,
    required this.iconCategory,
  }) : super(key: key);

  final IconData iconCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: myTheme.colorScheme.secondary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Icon(
        iconCategory,
        color: Colors.white,
      ),
    );
  }
}

class _PromotionSwiper extends StatelessWidget {
  const _PromotionSwiper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> promotions = [
      'https://blog.magezon.com/wp-content/uploads/2020/08/fashion-banner.png',
      'https://www.edrawsoft.com/templates/images/horizontal-promotion-banner.png',
      'https://image.shutterstock.com/image-vector/brush-sale-banner-promotion-ribbon-260nw-1182942766.jpg',
    ];

    return Swiper(
      layout: SwiperLayout.STACK,
      itemWidth: 330.0,
      itemHeight: 115.0,
      itemCount: promotions.length,
      itemBuilder: (BuildContext context, int index) {
        return Image.network(
          promotions[index],
          fit: BoxFit.cover,
        );
      },
    );
  }
}

class _CategoryListView extends StatelessWidget {
  const _CategoryListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      height: 100,
      width: 100,
    );
  }
}
