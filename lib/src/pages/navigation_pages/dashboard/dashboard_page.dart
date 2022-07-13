// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Usuario conectado:');
    print(sharedPreferences!.getString('uid'));
    print('pantalla dasghboard activa');

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              _ListCategories(),
              SizedBox(height: 10.0),
              PromotionSwiper(),
              SizedBox(height: 20.0),
              _CategoryListView(),
              SizedBox(height: 10.0),
              _PendingOrders(
                title: 'Pedidos pendientes',
                quantity: 0,
              ),
              SizedBox(height: 10.0),
              _PendingOrders(
                title: 'Visitas pendientes',
                quantity: 0,
              ),
              SizedBox(height: 10.0),
              _PendingOrders(
                title: 'Facturas pendientes',
                quantity: 0,
              ),
              SizedBox(height: 30.0),
            ],
          ),
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
    final _categories = [
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
        itemCount: _categories.length,
        itemBuilder: (BuildContext context, int i) {
          final cName = _categories[i];
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

class PromotionSwiper extends StatelessWidget {
  const PromotionSwiper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> promotions = [
      'https://blog.magezon.com/wp-content/uploads/2020/08/fashion-banner.png',
      'https://www.edrawsoft.com/templates/images/horizontal-promotion-banner.png',
      'https://image.shutterstock.com/image-vector/brush-sale-banner-promotion-ribbon-260nw-1182942766.jpg',
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Swiper(
          autoplay: true,
          autoplayDisableOnInteraction: true,
          autoplayDelay: 5000,
          layout: SwiperLayout.STACK,
          itemWidth: 330.0,
          itemHeight: 115.0,
          itemCount: promotions.length,
          itemBuilder: (BuildContext context, int index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () {
                  print('promotion tapped');
                },
                child: Image.network(
                  promotions[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryListView extends StatelessWidget {
  const _CategoryListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categoriesList = [
      {
        'name': 'categoria 1',
        'picture':
            'https://nypost.com/wp-content/uploads/sites/2/2022/03/Best-Amazon-Products.jpg?quality=75&strip=all',
      },
      {
        'name': 'categoria 2',
        'picture':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnO8le2AWamrna2gmvj1AcxLL5dKXXI_n0Eg&usqp=CAU',
      },
      {
        'name': 'categoria 3',
        'picture':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrRdQFKgATKJ-5RAVZ-ftSPK6chgGKV579gA&usqp=CAU',
      },
      {
        'name': 'categoria 4',
        'picture':
            'https://nypost.com/wp-content/uploads/sites/2/2022/03/Best-Amazon-Products.jpg?quality=75&strip=all',
      },
      {
        'name': 'categoria 5',
        'picture':
            'https://nypost.com/wp-content/uploads/sites/2/2022/03/Best-Amazon-Products.jpg?quality=75&strip=all',
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      // color: Colors.grey[300],
      height: 150,
      width: double.infinity,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: categoriesList.length,
        itemBuilder: (BuildContext context, int i) {
          final cImg = categoriesList[i];
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CategoryListViewButton(
                  imgCategory: cImg['picture'],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    cImg['name'],
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
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

class _CategoryListViewButton extends StatelessWidget {
  const _CategoryListViewButton({
    Key? key,
    required this.imgCategory,
  }) : super(key: key);

  final String imgCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.0),
      // color: Colors.grey[500],
      height: 100.0,
      width: 118.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.network(
          imgCategory,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PendingOrders extends StatelessWidget {
  const _PendingOrders({
    Key? key,
    required this.quantity,
    required this.title,
  }) : super(key: key);

  final int quantity;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Redireccionar a su lista respectiva');
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        height: 35.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.shade100,
          border: Border.all(
            color: myTheme.colorScheme.secondary.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 150.0,
              child: Text(title, textWidthBasis: TextWidthBasis.longestLine),
            ),
            SizedBox(width: 30.0),
            Container(
              width: 25.0,
              height: 25.0,
              // margin: EdgeInsets.only(right: 1.0),
              decoration: BoxDecoration(
                color: myTheme.colorScheme.secondary,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$quantity',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
