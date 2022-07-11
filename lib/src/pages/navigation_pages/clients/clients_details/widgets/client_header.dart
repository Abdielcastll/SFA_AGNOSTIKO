// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ClientHeader extends StatelessWidget {
  const ClientHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.transparent,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.29,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.white,
              height: 156,
              width: 156,
              child: Icon(
                Icons.person,
                size: 150,
                color: Colors.grey.withOpacity(0.6),
              ),
            ),
          ),
          SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 116,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      //TODO: Implementar editar info
                    },
                    label: Text(
                      'Editar info',
                      style: TextStyle(
                        color: myTheme.colorScheme.secondary,
                        fontSize: 12,
                      ),
                    ),
                    icon: Icon(
                      Icons.edit_note_rounded,
                      color: myTheme.colorScheme.secondary,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      side: BorderSide(
                        width: 1,
                        color: myTheme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 116,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      //TODO: Implementar ir a historial
                    },
                    label: Text(
                      '  Historial',
                      style: TextStyle(
                        color: myTheme.colorScheme.secondary,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: myTheme.colorScheme.secondary,
                      size: 18,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      side: BorderSide(
                        width: 1,
                        color: myTheme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 17),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // ignore: todo
                      //TODO: Implementar reruta a pagina de nuevo pedido
                    },
                    label: Text(
                      'Crear pedido       ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    icon: Icon(
                      Icons.add_shopping_cart_rounded,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: myTheme.colorScheme.secondary,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      side: BorderSide(
                        width: 1,
                        color: myTheme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
