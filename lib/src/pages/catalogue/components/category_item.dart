// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    Key? key,
    required this.name,
    required this.picture,
  }) : super(key: key);

  final String name;
  final picture;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Redireccionar a productos de esta categoria
        Navigator.pushNamed(context, 'products');
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 150.0,
          width: 140.0,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.transparent,
                  height: 120.0,
                  width: 156.0,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/loading.gif'),
                    image: NetworkImage(picture),
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
                    color: myTheme.colorScheme.secondary,
                    fontSize: 16,
                    fontFamily: 'Poppins-regular',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
