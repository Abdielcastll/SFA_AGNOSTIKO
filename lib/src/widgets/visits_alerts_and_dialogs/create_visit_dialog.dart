// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showCreateClientDialog(context, uid) {
  var dateFormatter = DateFormat('dd/MM/yyyy');
  DateTime today = DateTime.now();
  String formattedDate = dateFormatter.format(today);
  final nameOfCurrentUser =
      Provider.of<CurrentUserInfo>(context, listen: false).name;

  String? selectedValueA;
  String? selectedValueB;
  bool isLoading = false;
  bool isAllSelected = false;
  bool light = false;
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
            value: clientesRef.snapshots().map(clientNameFromDocumentID),
            initialData: const [],
          ),
        ],
        child: StatefulBuilder(builder: (context, setState) {
          final zonesSummary =
              Provider.of<ZoneSummary?>(context)?.summary ?? {};
          final zonesList = zonesSummary.values.toList();
          final List<String> zonesStrings = List<String>.from(zonesList);

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
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              title: Text(
                AppLocalizations.of(context)!.newVisit,
                style: TextStyle(
                  fontFamily: 'Poppins-regular',
                  color: myTheme.colorScheme.onPrimaryContainer,
                  fontSize: 22,
                ),
              ),
              content: SingleChildScrollView(
                child: Container(
                  child: isLoading == true
                      ? Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      // LoadingWidget(
                      //     message: AppLocalizations.of(context)!.creatingVisit)
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!.date,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4353C2),
                                    fontFamily: 'Poppins-medium',
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.all(10),
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Color(0xFFDFE0FF),
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
                                        color: Color(0xFF4353C2),
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
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2010),
                                            lastDate: DateTime(2030),
                                            builder: (context, child) {
                                              return Theme(
                                                data:
                                                    Theme.of(context).copyWith(
                                                  dialogTheme: DialogTheme(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              28), // this is the border radius of the picker
                                                    ),
                                                  ),
                                                  colorScheme: ColorScheme.dark(
                                                    primary: myTheme
                                                        .colorScheme.primary,
                                                    onPrimary: Colors.white,
                                                    surface: Colors.white,
                                                    onSurface:
                                                        Color(0xFF1D1B20),
                                                  ),
                                                  textButtonTheme:
                                                      TextButtonThemeData(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: myTheme
                                                          .colorScheme
                                                          .primary, // button text color
                                                    ),
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
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
                                          color: Color(0xFF4353C2),
                                          size: 19,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!.seller,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4353C2),
                                    fontFamily: 'Poppins-medium',
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Color(0xFFDFE0FF),
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
                                        color: Color(0xFF4353C2),
                                        fontFamily: 'Poppins-regular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!.salesArea,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4353C2),
                                    fontFamily: 'Poppins-medium',
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
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
                                              fontSize: 14,
                                              fontFamily: 'Poppins-regular',
                                              color: Color(0xFF4353C2),
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
                                                  fontFamily: 'Poppins-regular',
                                                  color: Color(0xFF4353C2),
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
                                      height: 56,
                                      padding: const EdgeInsets.only(right: 14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Color(0xFFDFE0FF),
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
                              SizedBox(height: 12),
                              selectedValueA != null
                                  ? Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .clients,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF4353C2),
                                              fontFamily: "Poppins-medium",
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        isAllSelected == false
                                            ? Container(
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
                                                              fontFamily:
                                                                  'Poppins-regular',
                                                              color: Color(
                                                                  0xFF4353C2),
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
                                                                  fontFamily:
                                                                      'Poppins-regular',
                                                                  color: Color(
                                                                      0xFF4353C2),
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
                                                        color:
                                                            Color(0xFF4353C2),
                                                      ),
                                                      iconSize: 10,
                                                      iconEnabledColor:
                                                          Color(0xFF4353C2),
                                                      iconDisabledColor:
                                                          Colors.grey,
                                                    ),
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      height: 56,
                                                      // width: 200,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14,
                                                              right: 14),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        border: Border.all(
                                                          color:
                                                              Color(0xFFDFE0FF),
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
                                        SizedBox(height: 12),
                                        clientsFiltered.isNotEmpty
                                            ? Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
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
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      FlutterSwitch(
                                                        onToggle: (val) {
                                                          setState(() {
                                                            light = val;
                                                            selectedValueB =
                                                                null;
                                                            isAllSelected =
                                                                !isAllSelected;
                                                          });
                                                        },
                                                        width: 39,
                                                        height: 24,
                                                        toggleSize: 12,
                                                        value: light,
                                                        borderRadius: 26,
                                                        padding: 6,
                                                        activeColor: Colors
                                                            .green.shade300,
                                                        inactiveColor:
                                                            Color(0xFFDFE0FF),
                                                        inactiveToggleColor:
                                                            Color(0xFF5A5D77),
                                                      ),
                                                    ],
                                                  ),
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
                isLoading == true
                    ? Container()
                    : Row(
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
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        myTheme.colorScheme.onPrimaryContainer,
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                    icon: Icon(MaterialCommunityIcons
                                        .truck_fast_outline),
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
                                          await createVisitData(uid,
                                              client.clientDocumentId, today);
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
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        myTheme.colorScheme.onPrimaryContainer,
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                    icon: Icon(MaterialCommunityIcons
                                        .truck_fast_outline),
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
