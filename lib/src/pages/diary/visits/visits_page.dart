// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/visit_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visits_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visits_on_process.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/visits_alerts_and_dialogs/create_visit_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  @override
  Widget build(BuildContext context) {
    final currentDayProvider = Provider.of<CounterLimitFirestore>(context);
    final currentDay = currentDayProvider.currentDayVisits;

    final currentDayDateTime = currentDayProvider.currentDayVisits.toDate();
    DateTime tomorrow = DateTime(currentDayDateTime.year,
        currentDayDateTime.month, currentDayDateTime.day + 1);

    final user = Provider.of<UserModel?>(context);
    // print('VISITAS');
    // print(user?.uid);
    return StreamProvider<List<Visits>>.value(
      value: currentDay !=
              Timestamp.fromDate(DateTime(
                DateTime.now().year + 99,
                DateTime.now().month + 99,
                DateTime.now().day + 99,
                0,
                0,
                0,
                0,
                0,
              ))
          ? FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user?.uid)
              .collection('visitas')
              .orderBy('fecha', descending: true)
              .where('fecha',
                  isGreaterThanOrEqualTo: currentDayProvider.currentDayVisits)
              .where('fecha', isLessThan: tomorrow)
              .snapshots()
              .map(visitsFromSnasphot)
          : FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user?.uid)
              .collection('visitas')
              .orderBy('fecha', descending: true)
              .snapshots()
              .map(visitsFromSnasphot),
      initialData: const [],
      catchError: (context, error) {
        print('ERROR ON VISITS PROVIDER ON VISIT PAGE');
        print(error);
        return [];
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: myTheme.colorScheme.background,
          floatingActionButton: Wrap(
            direction: Axis.vertical,
            children: [
              Container(
                // margin: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  elevation: 10,
                  backgroundColor: myTheme.colorScheme.primary,
                  onPressed: () {
                    // ShowDialog de a;adir visita
                    showCreateClientDialog(context, user?.uid);
                  },
                  child: const Icon(
                    MaterialCommunityIcons.calendar_plus,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: const VisitsBody(),
        ),
      ),
    );
  }
}

class VisitsBody extends StatefulWidget {
  const VisitsBody({
    Key? key,
  }) : super(key: key);

  @override
  State<VisitsBody> createState() => _VisitsBodyState();
}

class _VisitsBodyState extends State<VisitsBody> {
  bool seeCompleted = false;
  bool isDescending = false;
  bool light = false;
  DateTime today = DateTime.now();
  var dateFormatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
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
                        currentDayProvider.setNewDayVisits(newDay);
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
              // Container(
              //   height: 40,
              //   padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(16),
              //     border: Border.all(
              //         color: myTheme.colorScheme.primary.withOpacity(0.3)),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Text(
              //         currentDay !=
              //                 Timestamp.fromDate(DateTime(
              //                   DateTime.now().year + 99,
              //                   DateTime.now().month + 99,
              //                   DateTime.now().day + 99,
              //                   0,
              //                   0,
              //                   0,
              //                   0,
              //                   0,
              //                 ))
              //             ? formattedDate
              //             : '00-00-0000',
              //         style: TextStyle(
              //           fontSize: 14,
              //           // fontWeight: FontWeight.bold,
              //           fontFamily: 'Poppins-regular',
              //           color: myTheme.colorScheme.primary,
              //         ),
              //       ),
              //       Container(
              //         width: 20,
              //         child: IconButton(
              //           onPressed: () async {
              //             final currentDayProvider =
              //                 Provider.of<CounterLimitFirestore>(context,
              //                     listen: false);
              //             DateTime? newDate = await showDatePicker(
              //               context: context,
              //               initialDate: DateTime.now(),
              //               firstDate: DateTime(2010),
              //               lastDate: DateTime(2030),
              //             );
              //             if (newDate == null) {
              //               return;
              //             }
              //             // setState(() {
              //             //   today = newDate;
              //             //   formattedDate = dateFormatter.format(newDate);
              //             //   final newDay = Timestamp.fromDate(newDate);
              //             //   currentDayProvider.setNewDayVisits(newDay);
              //             // });
              //           },
              //           splashRadius: 5,
              //           icon: Icon(
              //             MaterialCommunityIcons.calendar_edit,
              //             color: myTheme.colorScheme.primary.withOpacity(0.8),
              //             size: 20,
              //           ),
              //         ),
              //       ),
              //       Container(
              //         margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
              //         child: IconButton(
              //           onPressed: () {
              //             final currentDayProvider =
              //                 Provider.of<CounterLimitFirestore>(context,
              //                     listen: false);
              //             setState(() {
              //               currentDayProvider
              //                   .setNewDayVisits(Timestamp.fromDate(DateTime(
              //                 DateTime.now().year + 99,
              //                 DateTime.now().month + 99,
              //                 DateTime.now().day + 99,
              //                 0,
              //                 0,
              //                 0,
              //                 0,
              //                 0,
              //               )));
              //             });
              //           },
              //           icon: Icon(
              //             MaterialCommunityIcons.calendar_remove,
              //             color: myTheme.colorScheme.onPrimaryContainer,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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
          seeCompleted == false
              ? VisitsOnProcess(isDescending: isDescending)
              : VisitsCompleted(isDescending: isDescending),
        ],
      ),
    );
  }
}
