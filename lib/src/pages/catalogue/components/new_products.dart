// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class NewProductsWidget extends StatefulWidget {
  const NewProductsWidget({Key? key, this.listOfProducts}) : super(key: key);

  final listOfProducts;

  @override
  State<NewProductsWidget> createState() => _NewProductsWidgetState();
}

class _NewProductsWidgetState extends State<NewProductsWidget> {
  @override
  Widget build(BuildContext context) {
    print(widget.listOfProducts);
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                MdiIcons.star,
                color: myTheme.colorScheme.secondary,
                size: 25.0,
              ),
              SizedBox(width: 5.0),
              Text(
                'Nuevos Productos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: myTheme.colorScheme.secondary,
                  fontSize: 16.0,
                  fontFamily: 'Poppins-regular',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
