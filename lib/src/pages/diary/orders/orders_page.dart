// ignore_for_file: prefer_const_constructors

import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/orders_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/orders_on_process.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CurrentUserInfo?>(context);
    final userUid = Provider.of<CurrentUserInfo?>(context)?.uid ?? {};
    final userDoc = usersCollection.doc(userUid);
    // print(userDoc);
    final currentDay =
        Provider.of<CounterLimitFirestore>(context).currentDayOrder;
    final currentDayDateTime = currentDay.toDate();
    DateTime tomorrow = DateTime(currentDayDateTime.year,
        currentDayDateTime.month, currentDayDateTime.day + 1);

    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;

    return MultiProvider(
      providers: [
        FutureProvider<UserRole?>.value(
          value: user?.getUserRole(),
          initialData: null,
          catchError: (context, error) {
            print(error);
            return;
          },
        ),
        StreamProvider<List<Orders>?>.value(
          value: currentDay !=
                  Timestamp.fromDate(
                    DateTime(
                      DateTime.now().year + 99,
                      DateTime.now().month + 99,
                      DateTime.now().day + 99,
                      0,
                      0,
                      0,
                      0,
                      0,
                    ),
                  )
              ? firebase
                  .collectionGroup('pedidos')
                  .where('vendedor', isEqualTo: userDoc)
                  .where('fecha', isGreaterThanOrEqualTo: currentDay)
                  .where('fecha', isLessThan: tomorrow)
                  .orderBy('fecha')
                  .snapshots()
                  .map(ordersFromSnapshot)
              : firebase
                  .collectionGroup('pedidos')
                  .where('vendedor', isEqualTo: userDoc)
                  .orderBy('fecha')
                  .snapshots()
                  .map(ordersFromSnapshot),
          initialData: const [],
          catchError: (context, error) {
            print('ERROR ON GETTING ORDERS IN ORDERS PAGE PROVIDER');
            print(error);
            return [];
          },
        ),
        StreamProvider<Coin?>.value(
          initialData: Coin(),
          catchError: (context, error) {
            print(
                'ERROR ON STREAM PROVIDER OF COINEXCHANGE RATES IN ADD CLIENT');
            print(error);
            return;
          },
          value: coinCollection
              .doc(currentCoinSelectedCode)
              .snapshots()
              .map(coinFromSnapshot),
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: myTheme.colorScheme.background,
          body: OrdersBody(),
        ),
      ),
    );
  }
}

class OrdersBody extends StatefulWidget {
  const OrdersBody({
    Key? key,
  }) : super(key: key);

  @override
  State<OrdersBody> createState() => _OrdersBodyState();
}

class _OrdersBodyState extends State<OrdersBody> {
  bool seeCompleted = false;
  bool isDescending = false;
  bool light = false;
  DateTime today = DateTime.now();
  var dateFormatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final currentDay =
        Provider.of<CounterLimitFirestore>(context).currentDayOrder;
    final currentDateTime = currentDay.toDate();
    String formattedDate = dateFormatter.format(currentDateTime);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 160,
                height: 40,
                margin: EdgeInsets.only(top: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() => isDescending = !isDescending);
                    print('descending: $isDescending');
                  },
                  icon: Icon(
                    isDescending
                        ? MaterialCommunityIcons.sort_calendar_descending
                        : MaterialCommunityIcons.sort_calendar_ascending,
                    color: myTheme.colorScheme.onPrimaryContainer,
                  ),
                  label: Container(
                    width: 88,
                    child: Text(
                      isDescending
                          ? 'Más recientes'
                          // AppLocalizations.of(context)!.ascendingFilter
                          : 'Más antiguos',
                      // AppLocalizations.of(context)!.descendingFilter,
                      style: TextStyle(
                        fontFamily: 'Poppins-medium',
                        color: myTheme.colorScheme.onPrimaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFDFE0FF)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(0),
                  ),
                ),
              ),
              Container(
                width: 160,
                height: 40,
                margin: EdgeInsets.only(top: 16),
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final currentDayProvider =
                          Provider.of<CounterLimitFirestore>(context,
                              listen: false);

                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2030),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              dialogTheme: DialogTheme(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      28), // this is the border radius of the picker
                                ),
                              ),
                              colorScheme: ColorScheme.dark(
                                primary: myTheme.colorScheme.primary,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Color(0xFF1D1B20),
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: myTheme
                                      .colorScheme.primary, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (newDate == null) {
                        return;
                      }
                      setState(() {
                        today = newDate;
                        formattedDate = dateFormatter.format(newDate);
                        final newDay = Timestamp.fromDate(newDate);
                        currentDayProvider.setNewDayOrder(newDay);
                      });
                    },
                    icon: Icon(
                      MaterialIcons.event,
                      color: myTheme.colorScheme.onPrimaryContainer,
                    ),
                    label: Container(
                      width: 100,
                      child: Text(
                        currentDay !=
                                Timestamp.fromDate(
                                  DateTime(
                                    DateTime.now().year + 99,
                                    DateTime.now().month + 99,
                                    DateTime.now().day + 99,
                                    0,
                                    0,
                                    0,
                                    0,
                                    0,
                                  ),
                                )
                            ? formattedDate
                            : 'Elige una fecha',
                        style: TextStyle(
                          fontFamily: 'Poppins-medium',
                          color: myTheme.colorScheme.onPrimaryContainer,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFDFE0FF)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Ver completados',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins-medium',
                    color: Color(0xFF5A5D77),
                  ),
                ),
                SizedBox(width: 8),
                FlutterSwitch(
                  onToggle: (val) {
                    setState(() {
                      light = val;
                      seeCompleted = !seeCompleted;
                    });
                  },
                  width: 39,
                  height: 24,
                  toggleSize: 12,
                  value: light,
                  borderRadius: 26,
                  padding: 6,
                  activeColor: Colors.green.shade300,
                  inactiveColor: Color(0xFFDFE0FF),
                  inactiveToggleColor: Color(0xFF5A5D77),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     Container(
          //       width: 120,
          //       margin: const EdgeInsets.fromLTRB(16, 10, 0, 10),
          //       child: Text(
          //         seeCompleted == true
          //             ? AppLocalizations.of(context)!.completed
          //             : AppLocalizations.of(context)!.onProcess,
          //         textAlign: TextAlign.start,
          //         style: TextStyle(
          //           color: seeCompleted == true
          //               ? Colors.green.shade600
          //               : Colors.amber.shade600,
          //           fontSize: 15,
          //           fontWeight: FontWeight.bold,
          //           fontFamily: 'Poppins-regular',
          //         ),
          //       ),
          //     ),
          //     Row(
          //       children: [
          //         Container(
          //           margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          //           child: Text(
          //             'Ver completados',
          //             style: TextStyle(
          //               fontSize: 14,
          //               // fontWeight: FontWeight.bold,
          //               fontFamily: 'Poppins-regular',
          //               color: myTheme.colorScheme.primary,
          //             ),
          //           ),
          //         ),
          //         Checkbox(
          //           checkColor: Colors.white,
          //           shape: CircleBorder(),
          //           fillColor:
          //               MaterialStateProperty.all(myTheme.colorScheme.primary),
          //           activeColor: myTheme.colorScheme.primary,
          //           value: seeCompleted,
          //           onChanged: (value) {
          //             setState(() {
          //               seeCompleted = !seeCompleted;
          //             });
          //           },
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          seeCompleted == false
              ? OrdersOnProcess(isDescending: isDescending)
              : CompletedOrders(isDescending: isDescending),
        ],
      ),
    );
  }
}
