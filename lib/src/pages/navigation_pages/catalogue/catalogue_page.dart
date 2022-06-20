// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/dashboard/dashboard_page.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  @override
  Widget build(BuildContext context) {
    print('pantalla catalogo activa');

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              SizedBox(
                height: 15,
              ),
              PromotionSwiper(),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Text(
                  'PROMOCIONES',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),
              _CategoryGridView(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryGridView extends StatelessWidget {
  const _CategoryGridView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
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
      {
        'name': 'categoria 5',
        'picture':
            'https://nypost.com/wp-content/uploads/sites/2/2022/03/Best-Amazon-Products.jpg?quality=75&strip=all',
      },
      {
        'name': 'categoria 5',
        'picture':
            'https://nypost.com/wp-content/uploads/sites/2/2022/03/Best-Amazon-Products.jpg?quality=75&strip=all',
      },
      {
        'name': 'categoria 5',
        'picture':
            'https://nypost.com/wp-content/uploads/sites/2/2022/03/Best-Amazon-Products.jpg?quality=75&strip=all',
      },
      {
        'name': 'categoria 5',
        'picture':
            'https://nypost.com/wp-content/uploads/sites/2/2022/03/Best-Amazon-Products.jpg?quality=75&strip=all',
      },
      {
        'name': 'categoria 5',
        'picture':
            'https://nypost.com/wp-content/uploads/sites/2/2022/03/Best-Amazon-Products.jpg?quality=75&strip=all',
      },
    ];

    return SingleChildScrollView(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: GridView.count(
              // padding: EdgeInsets.only(left: 20, right: 20),
              physics: BouncingScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              shrinkWrap: true,
              children: categories.map((dynamic doc) {
                return _CategoryItem(
                  name: doc['name'],
                  picture: doc['picture'].toString(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    Key? key,
    required this.name,
    required this.picture,
  }) : super(key: key);

  final String name;
  final String picture;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 150.0,
        width: 156.0,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.lightGreen,
                height: 120.0,
                width: 156.0,
                child: Image.network(
                  picture,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10),
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
