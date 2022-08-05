// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/dashboard/dashboard_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class CompletedOrderPage extends StatelessWidget {
  const CompletedOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomDecoration(),
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(20),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: myTheme.colorScheme.secondary,
        ),
      ),
      body: SingleChildScrollView(child: CompletedOrderBody()),
    );
  }
}

class CompletedOrderBody extends StatefulWidget {
  const CompletedOrderBody({
    Key? key,
  }) : super(key: key);

  @override
  State<CompletedOrderBody> createState() => _CompletedOrderBody();
}

class _CompletedOrderBody extends State<CompletedOrderBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.transparent,
          margin: EdgeInsets.fromLTRB(15, 40, 20, 0),
          child: Text(
            '¡Pedido Completado!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: myTheme.colorScheme.secondary,
              fontFamily: 'Poppins-regular',
              fontSize: 25,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 40, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CLIENTE',
                    style: TextStyle(
                      color: Colors.purple.shade600,
                      fontFamily: 'Poppins-regular',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Nombre del Cliente',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins-regular',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FECHA DE PEDIDO',
                    style: TextStyle(
                      color: Colors.purple.shade600,
                      fontFamily: 'Poppins-regular',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '00/00/0000',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins-regular',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 40, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PEDIDO',
                    style: TextStyle(
                      color: Colors.purple.shade600,
                      fontFamily: 'Poppins-regular',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '#56ar4rg6s',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins-regular',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MÉTODD DE PAGO',
                    style: TextStyle(
                      color: Colors.purple.shade600,
                      fontFamily: 'Poppins-regular',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Transferencia',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins-regular',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 40, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MONTO A PAGAR',
                    style: TextStyle(
                      color: Colors.purple.shade600,
                      fontFamily: 'Poppins-regular',
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'USD\$ 000.00',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins-regular',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          width: 340,
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: ElevatedButton(
              onPressed: () {
                // Continuar con la compra
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                primary: myTheme.colorScheme.secondary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Regresar al Dashboard',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                    child: Icon(
                      SimpleLineIcons.check,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Image.asset(
          'assets/images/receipt.png',
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
