// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class DashboardHeaderButtons extends StatefulWidget {
  const DashboardHeaderButtons({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardHeaderButtons> createState() => _DashboardHeaderButtonsState();
}

class _DashboardHeaderButtonsState extends State<DashboardHeaderButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 5),
          height: 100,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade200,
          child: Row(
            children: [
              SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 83,
                  width: 230,
                  child: ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.blue.shade800),
                    onPressed: () {
                      // Redireccionar a las promociones
                    },
                    icon: Icon(
                      Fontisto.shopify,
                      size: 34,
                    ),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Promociones',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              height: 20,
                              width: 27,
                              decoration: BoxDecoration(
                                  color: myTheme.colorScheme.secondary),
                              ////////////// Mostrar cantidad de promociones activas
                              child: Center(
                                child: Text(
                                  '4',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration:
                      BoxDecoration(color: myTheme.colorScheme.secondary),
                  height: 83.0,
                  width: 83.0,
                  child: TextButton(
                    child: Icon(
                      Ionicons.ios_search_outline,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: () {
                      // redireccionar a un search delegate para buscar productos
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
