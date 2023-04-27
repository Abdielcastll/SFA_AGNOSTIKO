// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading/loading_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showCreateClientDialog(context, uid) {
  var dateFormatter = DateFormat('dd-MM-yyyy');
  DateTime today = DateTime.now();
  String formattedDate = dateFormatter.format(today);
  final nameOfCurrentUser =
      Provider.of<CurrentUserInfo>(context, listen: false).name;
  print('nameOfCurrentUser: $nameOfCurrentUser');

  final List<ClientName> allClientsFromZone = [];

  String? selectedValueA;
  String? selectedValueB;
  bool isLoading = false;
  bool isAllSelected = false;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MultiProvider(
        providers: [
          StreamProvider<ZoneSummary?>.value(
            value: DatabaseServiceStreams().zoneSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<List<ClientName>?>.value(
            value: FirebaseFirestore.instance
                .collection('clientes')
                .snapshots()
                .map(clientNameFromDocumentID),
            initialData: const [],
          ),
        ],
        child: StatefulBuilder(builder: (context, setState) {
          final zonesSummary =
              Provider.of<ZoneSummary?>(context)?.summary ?? {};
          final zonesList = zonesSummary.values.toList();
          final List<String> zonesStrings = List<String>.from(zonesList);
          final zonesKeys = zonesSummary.keys.toList();

          return StatefulBuilder(builder: (context, setState) {
            final clients = Provider.of<List<ClientName>?>(context) ?? [];

            final clientsList = clients;
            final clientsFiltered = clientsList
                .where(
                    (element) => zonesSummary[element.zone] == selectedValueA)
                .toList();
            final List clientsFilteredNames = [];
            var clientDocID;

            if (clientsFiltered.isNotEmpty) {
              clientsFiltered
                  .map(
                    (instance) => clientsFilteredNames.add(instance.name),
                  )
                  .toList();
            }
            if (selectedValueB != null) {
              clientsFiltered
                  .where((element) => element.name == selectedValueB)
                  .map((e) => clientDocID = e.clientDocumentId)
                  .toString();
            }
            print(clientDocID);
            final List<String> items2 = List<String>.from(clientsFilteredNames);
            // print('Nombres de los clientes: $names');

            final clientHint = items2.isEmpty
                ? AppLocalizations.of(context)!.noClientsAvaliable
                : AppLocalizations.of(context)!.selectClient;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                AppLocalizations.of(context)!.newVisit,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: myTheme.colorScheme.onPrimaryContainer,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Container(
                  // height: MediaQuery.of(context).size.height * 0.60,
                  width: 300,
                  child: isLoading == true
                      ? LoadingWidget(
                          message: AppLocalizations.of(context)!.creatingVisit)
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  AppLocalizations.of(context)!.date,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: myTheme.colorScheme.primary,
                                    fontFamily: 'Poppins-regular',
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: myTheme.colorScheme.primary
                                        .withOpacity(0.3),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: myTheme.colorScheme.primary,
                                        fontFamily: 'Poppins-regular',
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 30,
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                      child: IconButton(
                                        onPressed: () async {
                                          // Seleccionar fecha
                                          DateTime? newDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: today,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2030),
                                          );
                                          if (newDate == null) return;

                                          setState(() {
                                            today = newDate;
                                            formattedDate =
                                                dateFormatter.format(today);
                                          });

                                          setState(() {
                                            today = newDate;
                                          });
                                        },
                                        splashRadius: 5,
                                        icon: Icon(
                                          MaterialCommunityIcons.calendar_edit,
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
                                margin: EdgeInsets.fromLTRB(14, 5, 0, 0),
                                child: Text(
                                  AppLocalizations.of(context)!.seller,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: myTheme.colorScheme.primary,
                                    fontFamily: 'Poppins-regular',
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: myTheme.colorScheme.primary
                                        .withOpacity(0.3),
                                  ),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      nameOfCurrentUser.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: myTheme.colorScheme.primary,
                                        fontFamily: 'Poppins-regular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(14, 0, 0, 0),
                                child: Text(
                                  AppLocalizations.of(context)!.salesArea,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: myTheme.colorScheme.primary,
                                    fontFamily: 'Poppins-regular',
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
                                            selectedValueA ??
                                                'EJ: Caracas este',
                                            textAlign: TextAlign.left,
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
                                    items: zonesStrings
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: myTheme
                                                      .colorScheme.primary
                                                      .withOpacity(0.7),
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
                                          selectedValueB = null;
                                        },
                                      );
                                      // Mover la funcion en la base de datos para cambiar la lista
                                    },
                                    iconStyleData: IconStyleData(
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                      ),
                                      iconSize: 11,
                                      iconEnabledColor: myTheme
                                          .colorScheme.primary
                                          .withOpacity(0.5),
                                      iconDisabledColor: Colors.grey,
                                    ),
                                    buttonStyleData: ButtonStyleData(
                                      height: 50,
                                      // width: 200,
                                      padding: const EdgeInsets.only(right: 14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: myTheme.colorScheme.primary
                                              .withOpacity(0.3),
                                        ),
                                        color: Colors.white,
                                      ),
                                      elevation: 0,
                                    ),
                                    menuItemStyleData: MenuItemStyleData(
                                      height: 40,
                                      padding: const EdgeInsets.only(
                                          left: 14, right: 14),
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 200,
                                      // width: 200,
                                      padding: null,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      elevation: 8,
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(10),
                                        thickness:
                                            MaterialStateProperty.all<double>(
                                                6),
                                        thumbVisibility:
                                            MaterialStateProperty.all<bool>(
                                                true),
                                      ),
                                      offset: const Offset(0, 0),
                                    ),
                                  ),
                                ),
                              ),
                              selectedValueA != null
                                  ? Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin:
                                              EdgeInsets.fromLTRB(14, 5, 0, 0),
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .clients,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  myTheme.colorScheme.primary,
                                              fontFamily: "Poppins-regular",
                                            ),
                                          ),
                                        ),
                                        isAllSelected == false
                                            ? Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 5, 10, 10),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    isExpanded: true,
                                                    // ignore: prefer_const_literals_to_create_immutables
                                                    hint: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            clientHint,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: myTheme
                                                                  .colorScheme
                                                                  .primary
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    items: items2
                                                        .map((item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: item,
                                                              child: Text(
                                                                item,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: myTheme
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: selectedValueB,
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          selectedValueB =
                                                              value as String;
                                                        },
                                                      );
                                                      // Mover la funcion en la base de datos para cambiar la lista
                                                    },

                                                    iconStyleData:
                                                        IconStyleData(
                                                      icon: const Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                      ),
                                                      iconSize: 11,
                                                      iconEnabledColor: myTheme
                                                          .colorScheme.primary
                                                          .withOpacity(0.5),
                                                      iconDisabledColor:
                                                          Colors.grey,
                                                    ),
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      height: 50,
                                                      // width: 200,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14,
                                                              right: 14),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.3),
                                                        ),
                                                        color: Colors.white,
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    menuItemStyleData:
                                                        MenuItemStyleData(
                                                      height: 40,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14,
                                                              right: 14),
                                                    ),
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      maxHeight: 200,
                                                      width: 200,
                                                      padding: null,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white,
                                                      ),
                                                      elevation: 8,
                                                      scrollbarTheme:
                                                          ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(10),
                                                        thickness:
                                                            MaterialStateProperty
                                                                .all<double>(6),
                                                        thumbVisibility:
                                                            MaterialStateProperty
                                                                .all<bool>(
                                                                    true),
                                                      ),
                                                      offset:
                                                          const Offset(0, 0),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: 200,
                                                margin: EdgeInsets.fromLTRB(
                                                    14, 10, 14, 5),
                                                // alignment: Alignment.center,
                                                child: Center(
                                                  child: Text(
                                                    'Todos los clientes de la zona han sido seleccionados',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      color: myTheme.colorScheme
                                                          .onPrimaryContainer,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        clientsFiltered.isNotEmpty
                                            ? Center(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: Checkbox(
                                                        checkColor:
                                                            Colors.white,
                                                        shape: CircleBorder(),
                                                        fillColor:
                                                            MaterialStateProperty
                                                                .all(myTheme
                                                                    .colorScheme
                                                                    .primary),
                                                        activeColor: myTheme
                                                            .colorScheme
                                                            .primary,
                                                        value: isAllSelected,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            selectedValueB =
                                                                null;
                                                            isAllSelected =
                                                                !isAllSelected;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                        child: Text(
                                                      'Seleccionar todos',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Poppins-regular',
                                                        color: myTheme
                                                            .colorScheme
                                                            .primary,
                                                        fontSize: 14,
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.goBack,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: myTheme.colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    selectedValueB != null
                        ? Container(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // Crear en DB una visita//
                                if (selectedValueA != null &&
                                    selectedValueB != null) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var result = await createVisitData(
                                    uid,
                                    clientDocID,
                                    today,
                                  );
                                  if (result == null) {
                                    setState(() {
                                      isLoading = false;
                                      Navigator.pop(context);
                                    });
                                    Fluttertoast.showToast(
                                      msg: AppLocalizations.of(context)!
                                          .visitCreated,
                                    );
                                  } else if (result != null) {
                                    Fluttertoast.showToast(
                                      msg: AppLocalizations.of(context)!
                                          .createVisitError,
                                    );
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  myTheme.colorScheme.onPrimaryContainer,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              icon: Icon(
                                  MaterialCommunityIcons.truck_fast_outline),
                              label: Text(
                                AppLocalizations.of(context)!.createVisit,
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: Colors.white,
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    isAllSelected == true
                        ? Container(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // Crear en DB visitas//
                                if (clientsFiltered.isNotEmpty) {
                                  print(clientsFiltered);
                                  setState(() {
                                    isLoading = true;
                                  });

                                  for (var client in clientsFiltered) {
                                    await createVisitData(
                                        uid, client.clientDocumentId, today);
                                  }

                                  setState(() {
                                    isLoading = false;
                                    Navigator.pop(context);
                                  });
                                  Fluttertoast.showToast(
                                    msg: 'Visitas creadas',
                                  );
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  myTheme.colorScheme.onPrimaryContainer,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              icon: Icon(
                                  MaterialCommunityIcons.truck_fast_outline),
                              label: Text(
                                AppLocalizations.of(context)!.createVisit,
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: Colors.white,
                                  fontSize: 14,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            );
          });
        }),
      );
    },
  );
}
