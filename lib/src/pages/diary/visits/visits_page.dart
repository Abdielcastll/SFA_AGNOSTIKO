// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:pwa_sales2go_flutter/examples/example_visit_list.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/filter_visits.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visits_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visits_on_process.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  DateTime today = DateTime.now();
  var dateFormatter = DateFormat('dd-MM-yyyy');
  String? selectedValueA;
  String? selectedValueB;

  void showCreateClientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          String formattedDate = dateFormatter.format(today);
          String? nameOfCurrentUser = sharedPreferences!.getString('nombre');
          final List<String> items = [
            'TERRITORIO1',
            'TERRITORIO2',
            'TERRITORIO3',
            'TERRITORIO4',
            'TERRITORIO5',
            'TERRITORIO6',
            'TERRITORIO7',
            'TERRITORIO8',
          ];
          final List<String> items2 = [
            'CLIENTE 1',
            'CLIENTE 2',
            'CLIENTE 3',
            'CLIENTE 4',
            'CLIENTE 5',
            'CLIENTE 6',
            'CLIENTE 7',
            'CLIENTE 8',
          ];
          print(formattedDate);
          print(sharedPreferences!.getString('nombre'));

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Nueva Visita',
              style: TextStyle(
                fontFamily: 'Poppins-regular',
                color: myTheme.colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Container(
                height: 400,
                width: 300,
                // color: Colors.amber,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'Fecha',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: myTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: myTheme.colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.7),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: IconButton(
                                onPressed: () async {
                                  // Seleccionar fecha
                                  DateTime? newDate = await showDatePicker(
                                    context: context,
                                    initialDate: today,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2023),
                                  );
                                  if (newDate == null) return;
                                  setState(() {
                                    today = newDate;
                                  });
                                },
                                splashRadius: 5,
                                icon: Icon(
                                  Icons.calendar_month,
                                  color: myTheme.colorScheme.primary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'Vendedor (Usuario actual)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: myTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: myTheme.colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              nameOfCurrentUser.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          'Zona',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: myTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            // ignore: prefer_const_literals_to_create_immutables
                            hint: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedValueA ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: myTheme.colorScheme.primary
                                          .withOpacity(0.7),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            items: items
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: myTheme.colorScheme.primary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            value: selectedValueA,
                            onChanged: (value) {
                              setState(
                                () {
                                  selectedValueA = value as String;
                                },
                              );
                              // Mover la funcion en la base de datos para cambiar la lista
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 11,
                            iconEnabledColor:
                                myTheme.colorScheme.primary.withOpacity(0.5),
                            iconDisabledColor: Colors.grey,
                            buttonHeight: 50,
                            buttonWidth: 200,
                            buttonPadding:
                                const EdgeInsets.only(left: 14, right: 14),
                            buttonDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.3),
                              ),
                              color: Colors.white,
                            ),
                            buttonElevation: 0,
                            itemHeight: 40,
                            itemPadding:
                                const EdgeInsets.only(left: 14, right: 14),
                            dropdownMaxHeight: 200,
                            dropdownWidth: 200,
                            dropdownPadding: null,
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            dropdownElevation: 8,
                            scrollbarRadius: const Radius.circular(10),
                            scrollbarThickness: 6,
                            scrollbarAlwaysShow: true,
                            offset: const Offset(-20, 0),
                          ),
                        ),
                      ),
                      selectedValueA != null
                          ? Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                  child: Text(
                                    'Cliente',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: myTheme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      isExpanded: true,
                                      // ignore: prefer_const_literals_to_create_immutables
                                      hint: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              selectedValueB ?? '',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: myTheme
                                                    .colorScheme.primary
                                                    .withOpacity(0.7),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: items2
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(
                                                  item,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: myTheme
                                                        .colorScheme.primary,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      value: selectedValueB,
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            selectedValueB = value as String;
                                          },
                                        );
                                        // Mover la funcion en la base de datos para cambiar la lista
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                      ),
                                      iconSize: 11,
                                      iconEnabledColor: myTheme
                                          .colorScheme.primary
                                          .withOpacity(0.5),
                                      iconDisabledColor: Colors.grey,
                                      buttonHeight: 50,
                                      buttonWidth: 200,
                                      buttonPadding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      buttonDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: myTheme.colorScheme.primary
                                              .withOpacity(0.3),
                                        ),
                                        color: Colors.white,
                                      ),
                                      buttonElevation: 0,
                                      itemHeight: 40,
                                      itemPadding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                      dropdownMaxHeight: 200,
                                      dropdownWidth: 200,
                                      dropdownPadding: null,
                                      dropdownDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      dropdownElevation: 8,
                                      scrollbarRadius:
                                          const Radius.circular(10),
                                      scrollbarThickness: 6,
                                      scrollbarAlwaysShow: true,
                                      offset: const Offset(-20, 0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Regresar',
                                        style: TextStyle(
                                          fontFamily: 'Poppins-regular',
                                          color: myTheme.colorScheme.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: myTheme.colorScheme.primary),
                                      child: TextButton(
                                        onPressed: () {
                                          // Crear en DB una visita
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              myTheme.colorScheme.primary,
                                        ),
                                        child: Text(
                                          'Crear Visita',
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listExample = visitsList;
    List onProcess = [];
    List completed = [];
    for (var i = 0; i < listExample.length; i++) {
      if (listExample[i]['status'] == 'On process') {
        onProcess.add(listExample[i]);
      } else if (listExample[i]['status'] == 'Completed' ||
          listExample[i]['status'] == 'Cancelled') {
        completed.add(listExample[i]);
      }
      // print(cancelled);
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        floatingActionButton: Wrap(
          direction: Axis.vertical,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: FloatingActionButton(
                heroTag: '1',
                elevation: 0,
                backgroundColor: myTheme.colorScheme.primary,
                onPressed: () {
                  // ShowDialog de a;adir visita
                  showCreateClientDialog();
                },
                child: Icon(
                  MaterialCommunityIcons.calendar_plus,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: VisitsBody(onProcess: onProcess, completed: completed),
      ),
    );
  }
}

class VisitsBody extends StatelessWidget {
  const VisitsBody({
    Key? key,
    required this.onProcess,
    required this.completed,
  }) : super(key: key);

  final List onProcess;
  final List completed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          VisitsOnProcess(onProcessList: onProcess),
          VisitsList(completedList: completed),
        ],
      ),
    );
  }
}
