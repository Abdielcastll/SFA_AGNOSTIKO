import 'package:flutter/material.dart';

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class FilterInvoices extends StatefulWidget {
  const FilterInvoices({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterInvoices> createState() => FilterInvoicesState();
}

class FilterInvoicesState extends State<FilterInvoices> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              print('redireccion a search delegate de facturas');
              // Redireccionar a search delegate de facturas
            },
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 35,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Ionicons.ios_search_outline,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Busqueda de facturas...',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      SizedBox(width: 76),
                      Icon(
                        Fontisto.arrow_right,
                        color: Colors.grey.shade400,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Feather.filter,
              color: Colors.grey.shade400,
            ),
            onPressed: () {
              // Pop up de filtros
            },
            splashRadius: 20,
            splashColor: myTheme.colorScheme.secondary.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}
