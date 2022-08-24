// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ListOfProductsButton extends StatefulWidget {
  ListOfProductsButton({Key? key}) : super(key: key);

  @override
  State<ListOfProductsButton> createState() => _ListOfProductsButtonState();
}

class _ListOfProductsButtonState extends State<ListOfProductsButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
      width: MediaQuery.of(context).size.width,
      height: 38,
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(20),
        child: ElevatedButton.icon(
          onPressed: () {
            // Redireccionar a list full de productos
            Navigator.pushNamed(context, 'products');
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            overlayColor: MaterialStateProperty.all<Color>(
                myTheme.colorScheme.primary.withOpacity(0.5)),
          ),
          icon: Icon(
            MaterialCommunityIcons.tag_outline,
            color: myTheme.colorScheme.secondary,
            size: 20,
          ),
          label: Row(
            // ignore: prefer_const_literals_to_create_immutables
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lista de productos',
                style: TextStyle(
                  color: myTheme.colorScheme.secondary,
                  fontFamily: 'Poppins-regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                MaterialIcons.keyboard_arrow_right,
                color: myTheme.colorScheme.secondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
