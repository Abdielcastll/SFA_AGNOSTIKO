// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';

class AccountBalancePage extends StatelessWidget {
  const AccountBalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBarNavigation(message: 'Estado de cuenta'),
      body: AccountBalanceBody(),
    );
  }
}

class AccountBalanceBody extends StatefulWidget {
  const AccountBalanceBody({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountBalanceBody> createState() => _AccountBalanceBodyState();
}

class _AccountBalanceBodyState extends State<AccountBalanceBody> {
  bool isCheckedNotes = false;
  bool isCheckedFactures = false;
  bool isCheckedOnProcess = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'F. Pendientes',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '0',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'F. Pagadas',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '0',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'Monto Total',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '0',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'Saldo Total',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '0',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  value: isCheckedOnProcess,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckedOnProcess = value!;
                    });
                  },
                ),
                Text(
                  'Pendientes',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                  ),
                ),
                Checkbox(
                  checkColor: Colors.white,
                  value: isCheckedNotes,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckedNotes = value!;
                    });
                  },
                ),
                Text(
                  'Notas',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                  ),
                ),
                Checkbox(
                  checkColor: Colors.white,
                  value: isCheckedFactures,
                  onChanged: (bool? value) {
                    setState(() {
                      isCheckedFactures = value!;
                    });
                  },
                ),
                Text(
                  'Facturas',
                  style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 20, 10, 5),
            // ignore: prefer_const_literals_to_create_immutables
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                ListTile(
                  leading: Icon(
                    Icons.money_off_csred_outlined,
                    color: Colors.green,
                  ),
                  title: Text(
                    'Factura #00',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Monto original: \$ 00.00 - Saldo: \$ 00.00',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.money_off_csred_outlined,
                    color: Colors.amber,
                  ),
                  title: Text(
                    'Factura #01',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Monto original: \$ 00.00 - Saldo: \$ 00.00',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Factura #03',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Monto original: \$ 00.00 - Saldo: \$ 00.00',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.money_off_csred_outlined,
                    color: Colors.amber,
                  ),
                  title: Text(
                    'Nota #01',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Monto original: \$ 00.00 - Saldo: \$ 00.00',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}