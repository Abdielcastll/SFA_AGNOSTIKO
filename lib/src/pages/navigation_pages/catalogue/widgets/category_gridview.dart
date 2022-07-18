import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/catalogue/widgets/category_item.dart';

class CategoryGridView extends StatelessWidget {
  const CategoryGridView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Categoria 1',
        'picture': 'https://cdn-icons-png.flaticon.com/128/4151/4151882.png',
      },
      {
        'name': 'Categoria 2',
        'picture': 'https://cdn-icons-png.flaticon.com/512/202/202477.png',
      },
      {
        'name': 'Categoria 3',
        'picture':
            'https://img.icons8.com/external-flaticons-lineal-color-flat-icons/2x/external-products-office-and-office-supplies-flaticons-lineal-color-flat-icons-2.png',
      },
      {
        'name': 'Categoria 4',
        'picture': 'https://cdn-icons-png.flaticon.com/128/4964/4964103.png',
      },
      {
        'name': 'Categoria 5',
        'picture':
            'https://img.icons8.com/external-flaticons-lineal-color-flat-icons/2x/external-products-sustainable-living-flaticons-lineal-color-flat-icons-2.png',
      },
      {
        'name': 'Categoria 6',
        'picture': 'https://cdn-icons-png.flaticon.com/128/4840/4840721.png',
      },
      {
        'name': 'Categoria 7',
        'picture': 'https://cdn-icons-png.flaticon.com/128/5931/5931699.png',
      },
      {
        'name': 'Categoria 8',
        'picture': 'https://cdn-icons-png.flaticon.com/128/7678/7678998.png',
      },
      {
        'name': 'Categoria 9',
        'picture':
            'https://img.icons8.com/external-flaticons-lineal-color-flat-icons/2x/external-products-medical-ecommerce-flaticons-lineal-color-flat-icons-4.png',
      },
      {
        'name': 'Categoria 10',
        'picture': 'https://cdn-icons-png.flaticon.com/128/3081/3081867.png',
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
                return CategoryItem(
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
