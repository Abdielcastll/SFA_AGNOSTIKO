// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ButtonOptions extends StatelessWidget {
  const ButtonOptions({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 170,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: myTheme.colorScheme.primary,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Ver historial en un bottomSheetMenu del cliente
                },
                icon: Icon(
                  MaterialCommunityIcons.calendar_month_outline,
                  color: myTheme.colorScheme.primary,
                  size: 18,
                ),
                label: Text(
                  'Historial',
                  style: TextStyle(
                    color: myTheme.colorScheme.primary,
                    fontFamily: 'Poppins-regular',
                    fontSize: 13,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color?>(
                    Colors.white,
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    myTheme.colorScheme.primary.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 170,
            height: 35,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Ver historial en un bottomSheetMenu del cliente
                },
                icon: Icon(
                  MaterialCommunityIcons.cart_plus,
                  color: myTheme.colorScheme.tertiary,
                  size: 18,
                ),
                label: Text(
                  'Crear Pedido',
                  style: TextStyle(
                    color: myTheme.colorScheme.tertiary,
                    fontFamily: 'Poppins-regular',
                    fontSize: 13,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color?>(
                    myTheme.colorScheme.primary,
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    myTheme.colorScheme.tertiary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
