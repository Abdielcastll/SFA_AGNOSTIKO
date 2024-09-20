// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/visit_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visits_map.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visits_list.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/visits_alerts_and_dialogs/create_visit_dialog.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  bool seeCompleted = false;
  bool isDescending = false;
  DateTime dateSelected =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  toggleSeeCompleted() {
    print('toggleSeeCompleted');
    setState(() {
      seeCompleted = !seeCompleted;
    });
  }

  toggleOrder() {
    print('toggleOrder');
    setState(() {
      isDescending = !isDescending;
    });
  }

  onDateSelected(DateTime date) {
    print('onDateSelected');
    setState(() {
      dateSelected = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final currentDayProvider = context.watch<CounterLimitFirestore>();
    final currentDay = currentDayProvider.currentDayVisits;

    final currentDayDateTime = currentDayProvider.currentDayVisits.toDate();
    DateTime tomorrow = currentDayDateTime;
    tomorrow = tomorrow.add(Duration(days: 1));

    final user = context.watch<UserModel?>();
    return StreamBuilder<List<Visits>>(
      stream: currentDay !=
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
          ? usuariosRef
              .doc(user?.uid)
              .collection('visitas')
              .where('fecha',
                  isGreaterThanOrEqualTo: currentDayProvider.currentDayVisits)
              .where('fecha', isLessThan: tomorrow)
              .orderBy('fecha', descending: isDescending)
              .snapshots()
              .map(visitsFromSnasphot)
          : usuariosRef
              .doc(user?.uid)
              .collection('visitas')
              .orderBy('fecha', descending: isDescending)
              .snapshots()
              .map(visitsFromSnasphot),
      initialData: const [],
      builder: (context, snapshot) {
        print('snapshot.data');
        print(snapshot.data);
        print(snapshot.error);
        return SafeArea(
          child: Scaffold(
            backgroundColor: themeProvider.myTheme.colorScheme.background,
            floatingActionButton: Wrap(
              direction: Axis.vertical,
              children: [
                FloatingActionButton(
                  elevation: 10,
                  heroTag: null,
                  backgroundColor: themeProvider.myTheme.colorScheme.primary,
                  onPressed: () {
                    if (globalRemoteConfig.visitas == true)
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              StreamProvider<List<Visits>>.value(
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
                                ? usuariosRef
                                    .doc(user?.uid)
                                    .collection('visitas')
                                    .orderBy('fecha', descending: isDescending)
                                    .where('fecha',
                                        isGreaterThanOrEqualTo:
                                            currentDayProvider.currentDayVisits)
                                    .where('fecha', isLessThan: tomorrow)
                                    .snapshots()
                                    .map(visitsFromSnasphot)
                                : usuariosRef
                                    .doc(user?.uid)
                                    .collection('visitas')
                                    .orderBy('fecha', descending: isDescending)
                                    .snapshots()
                                    .map(visitsFromSnasphot),
                            initialData: snapshot.data ?? [],
                            lazy: true,
                            child: VisitsMap(),
                          ),
                        ),
                      );
                  },
                  child: const Icon(
                    MaterialCommunityIcons.map,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                FloatingActionButton(
                  heroTag: null,
                  elevation: 10,
                  backgroundColor: themeProvider.myTheme.colorScheme.primary,
                  onPressed: () {
                    // ShowDialog de a;adir visita
                    showCreateClientDialog(context, user?.uid);
                  },
                  child: const Icon(
                    MaterialCommunityIcons.calendar_plus,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: VisitsBody(
              toggleSeeCompleted: toggleSeeCompleted,
              seeCompleted: seeCompleted,
              isDescending: isDescending,
              toggleOrder: toggleOrder,
              onDateSelected: onDateSelected,
              dateSelected: dateSelected,
              isLoading: snapshot.connectionState == ConnectionState.waiting,
              visits: snapshot.data ?? [],
            ),
          ),
        );
      },
    );
  }
}

class VisitsBody extends StatelessWidget {
  VisitsBody(
      {Key? key,
      required this.toggleSeeCompleted,
      required this.seeCompleted,
      required this.toggleOrder,
      required this.isDescending,
      required this.onDateSelected,
      required this.dateSelected,
      required this.isLoading,
      required this.visits})
      : super(key: key);

  final Function() toggleSeeCompleted;
  final bool seeCompleted;
  final Function() toggleOrder;
  final bool isDescending;
  final Function(DateTime) onDateSelected;
  final DateTime dateSelected;
  final bool isLoading;
  final List<Visits> visits;

  final dateFormatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final currentDay =
        Provider.of<CounterLimitFirestore>(context).currentDayVisits;
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
                    toggleOrder();
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
                      formattedDate = dateFormatter.format(newDate);
                      onDateSelected(newDate);
                      final newDay = Timestamp.fromDate(newDate);
                      currentDayProvider.setNewDayVisits(newDay);
                    },
                    icon: Icon(
                      MaterialIcons.event,
                      color:
                          themeProvider.myTheme.colorScheme.onPrimaryContainer,
                    ),
                    label: SizedBox(
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
                    fontFamily: 'Poppins-Medium',
                    color: Color(0xFF5A5D77),
                  ),
                ),
                SizedBox(width: 8),
                FlutterSwitch(
                  onToggle: (val) {
                    toggleSeeCompleted();
                  },
                  width: 39,
                  height: 24,
                  toggleSize: 12,
                  value: seeCompleted,
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
          VisitsList(
            visits: seeCompleted
                ? visits
                    .where(
                      (element) =>
                          element.isCancelled == seeCompleted ||
                          element.isCompleted == seeCompleted,
                    )
                    .toList()
                : visits
                    .where(
                      (element) => !element.isCancelled && !element.isCompleted,
                    )
                    .toList(),
            isLoading: isLoading,
          )
        ],
      ),
    );
  }
}
