// ignore_for_file: prefer_const_constructors

import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/order_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/client_orders_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/account_balance/client_orders_onprocess,.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ClientOrders extends StatefulWidget {
  const ClientOrders({super.key, required this.clientDocument});

  final clientDocument;

  @override
  State<ClientOrders> createState() => _ClientOrdersState();
}

class _ClientOrdersState extends State<ClientOrders> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final user = Provider.of<CurrentUserInfo?>(context);
    final userUID = Provider.of<UserModel?>(context);

    // print('+++++++++++++++++++++++');
    // print(userUID?.uid);
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;
    final currentDay =
        Provider.of<CounterLimitFirestore>(context).currentDayOrder;
    final currentDayDateTime = currentDay.toDate();
    DateTime tomorrow = DateTime(currentDayDateTime.year,
        currentDayDateTime.month, currentDayDateTime.day + 1);

    final scrollLimit =
        Provider.of<CounterLimitFirestore>(context).getScrollOrderBalance;
    final document = clientsCollection
        .doc(widget.clientDocument)
        .collection('pedidos')
        .where('vendedor', isEqualTo: usersCollection.doc(userUID?.uid))
        .where('fecha', isGreaterThanOrEqualTo: currentDay)
        .where('fecha', isLessThan: tomorrow)
        .orderBy('fecha')
        .limit(scrollLimit)
        .snapshots();
    return MultiProvider(
      providers: [
        StreamProvider<List<Orders>?>.value(
          value: document.map(ordersFromSnapshot),
          initialData: const [],
          catchError: (context, error) {
            print('ERROR ON GETTING CLIENT ORDERS IN CLIENT DETAILS');
            print(error);
            return;
          },
        ),
        StreamProvider<Coin?>.value(
          initialData: Coin(),
          catchError: (context, error) {
            print(
                'ERROR ON STREAM PROVIDER OF COINEXCHANGE RATES  IN CLIENT DETAILS');
            print(error);
            return;
          },
          value: coinCollection
              .doc(currentCoinSelectedCode)
              .snapshots()
              .map(coinFromSnapshot),
        ),
        FutureProvider<UserRole?>.value(
          value: user?.getUserRole(),
          initialData: null,
          catchError: (context, error) {
            print(
                'ERROR ON GETTING USER ROLE IN CLIENT ORDERS IN CLIENT DETAILS');
            print(error);
            return;
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: themeProvider.myTheme.colorScheme.surface,
          body: ClientOrdersBody(),
        ),
      ),
    );
  }
}

class ClientOrdersBody extends StatefulWidget {
  const ClientOrdersBody({super.key});

  @override
  State<ClientOrdersBody> createState() => _ClientOrdersBodyState();
}

class _ClientOrdersBodyState extends State<ClientOrdersBody> {
  bool seeCompleted = false;
  final _controller = ScrollController();
  bool isDescending = false;
  bool light = false;
  DateTime today = DateTime.now();
  var dateFormatter = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    // products = widget.listOfProducts;
    _controller.addListener(() {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

      final productsLimitProvider =
          Provider.of<CounterLimitFirestore>(context, listen: false);
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          print('Top balance page');
          productsLimitProvider.setOrderBalanceLimit(30, 30);
        } else {
          if (productsLimitProvider.getScrollOrderBalanceLimit == 0) {
            productsLimitProvider.setOrderBalanceLimit(0, 0);
          } else {
            int newValor = int.parse(
                productsLimitProvider.getScrollOrderBalanceLimit.toString());
            if (newValor == 30) {
              productsLimitProvider.setOrderBalanceLimit(
                  productsLimitProvider.getScrollOrderBalance + newValor, 30);
            } else if (newValor == 50) {
              productsLimitProvider.setOrderBalanceLimit(
                  productsLimitProvider.getScrollOrderBalance + newValor, 50);
            }
          }
          print('Bottom balance page');
          Fluttertoast.showToast(
            msg: 'Solicitando +10 pedidos',
            backgroundColor: themeProvider.myTheme.colorScheme.primary,
            textColor: Colors.white,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

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
                    color: themeProvider.myTheme.colorScheme.onPrimaryContainer,
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
                        color: themeProvider
                            .myTheme.colorScheme.onPrimaryContainer,
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
                                primary:
                                    themeProvider.myTheme.colorScheme.primary,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Color(0xFF1D1B20),
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: themeProvider.myTheme
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
                      color:
                          themeProvider.myTheme.colorScheme.onPrimaryContainer,
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
                          color: themeProvider
                              .myTheme.colorScheme.onPrimaryContainer,
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
            child: Divider(
              color: Colors.grey,
            ),
          ),
          seeCompleted == false
              ? ClientsOrdersOnProcess(controller: _controller)
              : ClientOrdersCompleted(controller: _controller),
        ],
      ),
    );
  }
}
