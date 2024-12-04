// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({
    Key? key,
    required this.name,
    required this.productId,
  }) : super(key: key);

  final String name;
  final String productId;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.435,
      child: Padding(
        padding: EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 30),
        child: Container(
          width: double.infinity,
          height: 70.0,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 328,
                color: Colors.transparent,
                height: 70,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.only(top: 7),
                      width: 90,
                      height: 36,
                      color: Colors.white,
                      child: Text(
                        'Precio \$',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 156,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Añadir Producto
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              themeProvider.myTheme.colorScheme.secondary,
                        ),
                        icon: Icon(
                          Icons.add_shopping_cart_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Agregar al carrito',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                'Marca',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 21),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Stock: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '000',
                    // Future Stock
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 21),
              Text(
                'ID: $productId',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
