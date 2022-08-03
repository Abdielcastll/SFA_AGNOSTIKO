// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/products.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class SelectedClient extends StatelessWidget {
  const SelectedClient({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final OrderPage widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
        //   alignment: Alignment.topLeft,
        //   color: Colors.transparent,
        //   child: Text(
        //     'Cliente Seleccionado',
        //     style: TextStyle(
        //       color: myTheme.colorScheme.secondary,
        //       fontSize: 15,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // ),
        Container(
          height: 105,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Container(
            margin: EdgeInsets.all(16),
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                // color: myTheme.colorScheme.secondary.withOpacity(0.4),
                color: Colors.white,
              ),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(14, 8, 0, 0),
                      child: Text(
                        widget.clientName,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(14, 0, 0, 0),
                      height: 30,
                      width: 180,
                      child: Text(
                        widget.clientAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(40, 22, 10, 0),
                  child: Text(
                    'Rubro',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.purple.shade600,
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    // color: Colors.grey.withOpacity(0.5),
                    child: IconButton(
                      splashRadius: 30,
                      splashColor:
                          myTheme.colorScheme.secondary.withOpacity(0.7),
                      highlightColor:
                          myTheme.colorScheme.secondary.withOpacity(0.3),
                      onPressed: () {
                        // Press edit client button
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Feather.edit,
                        color: myTheme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: 325,
            child: Divider(
              height: 10,
              color: myTheme.colorScheme.secondary.withOpacity(0.2),
            ),
          ),
        ),
      ],
    );
  }
}
