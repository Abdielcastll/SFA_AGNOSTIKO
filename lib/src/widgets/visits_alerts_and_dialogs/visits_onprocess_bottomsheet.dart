// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void modalBottomSheetForOnProcess({
  context,
  commentary,
  currentClientName,
  idType,
  id,
  specialContributor,
  currentClientPhone,
  currentClientEmail,
  currentClientAddress,
  currentClientDispatchAdress,
  currentClientZones,
  currentClientPrices,
  currentDiscountMaster,
  clientReferenceId,
  userUID,
  visitDocumentId,
  currentClientId,
  currentClientIdType,
  date,
}) {
  print('visitDocumentId: $visitDocumentId');
  final List<String> items = [
    AppLocalizations.of(context)!.completed,
    AppLocalizations.of(context)!.canceled,
  ];

  String? selectedValue;
  String? commentaryValue;

  showModalBottomSheet(
    isScrollControlled: true,
    elevation: 0,
    backgroundColor: Colors.white,
    barrierColor: myTheme.colorScheme.secondary.withOpacity(0.5),
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(10),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.80,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        currentClientName,
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF1B1B1F),
                          fontFamily: 'Poppins-regular',
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFF5A5D77),
                          size: 20,
                        ),
                        SizedBox(width: 9),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5A5D77),
                              fontFamily: 'Poppins-medium',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Divider(),
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: Text(
                        'Persona de contacto',
                        style: TextStyle(
                          fontSize: 16,
                          color: myTheme.colorScheme.onPrimaryContainer,
                          fontFamily: 'Poppins-medium',
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentClientPhone,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF5A5D77),
                            fontFamily: 'Poppins-medium',
                          ),
                        ),
                        Text(
                          currentClientEmail,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF5A5D77),
                            fontFamily: 'Poppins-medium',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: Text(
                        'Comentario',
                        style: TextStyle(
                          fontSize: 16,
                          color: myTheme.colorScheme.onPrimaryContainer,
                          fontFamily: 'Poppins-medium',
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 14,
                          color: myTheme.colorScheme.primary,
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: 2,
                        maxLength: 200,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(14, 20, 14, 5),
                          // hintText: commentary.toString(),
                          hintText: 'Información adicional de la visita',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14,
                            color: Color(0xFF5A5D77),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Color(0xFFDFE0FF),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color(0xFFDFE0FF),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFDFE0FF),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        onChanged: (value) {
                          // CAmbiar valor dentro del comentario
                          commentaryValue = value;
                        },
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: Text(
                        'Estado de la visita',
                        style: TextStyle(
                          fontSize: 16,
                          color: myTheme.colorScheme.onPrimaryContainer,
                          fontFamily: 'Poppins-medium',
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedValue ??
                                      AppLocalizations.of(context)!
                                          .selectStatus,
                                  style: TextStyle(
                                    fontSize: 12,
                                    // fontWeight: FontWeight.bold,
                                    color: Color(0xFF5A5D77),
                                    fontFamily: 'Poppins-regular',
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
                                        fontSize: 12,
                                        fontFamily: 'Poppins-regular',
                                        color: myTheme.colorScheme.primary
                                            .withOpacity(0.8),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });
                          },
                          iconStyleData: IconStyleData(
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                            iconSize: 11,
                            iconEnabledColor: Color(0xFFDFE0FF),
                            iconDisabledColor: Colors.grey,
                          ),
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(left: 14, right: 14),
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
                            padding: const EdgeInsets.only(left: 14, right: 14),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            padding: null,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            elevation: 1,
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(8),
                              thickness: MaterialStateProperty.all<double>(6),
                              thumbVisibility:
                                  MaterialStateProperty.all<bool>(true),
                            ),
                            offset: const Offset(0, 0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              overlayColor: MaterialStateProperty.resolveWith(
                                (states) {
                                  return states.contains(MaterialState.pressed)
                                      ? myTheme.colorScheme.primary
                                      : null;
                                },
                              ),
                              splashFactory: NoSplash.splashFactory,
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: BorderSide(
                                    color: myTheme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.seeClient,
                              style: TextStyle(
                                fontFamily: 'Poppins-medium',
                                color: myTheme.colorScheme.primary,
                                fontSize: 11,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ClientDetails(
                                    specialContribuyer: specialContributor,
                                    masterDiscount: currentDiscountMaster,
                                    fiscalAddress: currentClientAddress,
                                    email: currentClientEmail,
                                    listOfPrices: currentClientPrices,
                                    name: currentClientName,
                                    tlf1: currentClientPhone,
                                    tlf2: currentClientPhone,
                                    zone: currentClientZones,
                                    nameId: currentClientId,
                                    typeId: currentClientIdType,
                                    clientDocumentReferenceID:
                                        clientReferenceId,
                                    dispatchAddress:
                                        currentClientDispatchAdress,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: 150,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              overlayColor: MaterialStateProperty.resolveWith(
                                (states) {
                                  return states.contains(MaterialState.pressed)
                                      ? myTheme.colorScheme.primary
                                      : null;
                                },
                              ),
                              splashFactory: NoSplash.splashFactory,
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: BorderSide(
                                    color: myTheme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.saveChanges,
                              style: TextStyle(
                                fontFamily: 'Poppins-medium',
                                color: myTheme.colorScheme.primary,
                                fontSize: 11,
                              ),
                            ),
                            onPressed: () async {
                              dynamic result = updateVisitData(
                                visitDocumentId,
                                selectedValue,
                                userUID,
                                commentaryValue,
                                context,
                              );
                              if (result != null) {
                                Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .modifiedVisit);
                                Navigator.pop(context);
                              } else if (result == null) {
                                Fluttertoast.showToast(
                                    msg: AppLocalizations.of(context)!
                                        .modifiedVisitError);
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Center(
                        child: TextButton(
                          onPressed: () async {
                            // Eliminar Visita en proceso de DB
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: Text(
                                      AppLocalizations.of(context)!
                                          .visitDeleteConfirmation,
                                      style: TextStyle(
                                        fontFamily: 'Poppins-regular',
                                        color: myTheme.colorScheme.secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .goBack,
                                            style: TextStyle(
                                              fontFamily: 'Poppins-regular',
                                              color:
                                                  myTheme.colorScheme.primary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 150,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color:
                                                  myTheme.colorScheme.primary),
                                          child: TextButton(
                                            onPressed: () async {
                                              // Eliminar Visita en proceso de DB
                                              await deleteVisit(
                                                visitDocumentId,
                                                userUID,
                                              );
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  myTheme.colorScheme.primary,
                                            ),
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .visitDelete,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins-regular',
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Text(
                            // AppLocalizations.of(context)!.visitDelete,
                            'Eliminar',
                            style: TextStyle(
                              fontFamily: 'Poppins-medium',
                              color: Color(0xFF5A5D77),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

class TextBoxWidget extends StatelessWidget {
  const TextBoxWidget({
    Key? key,
    this.message,
  }) : super(key: key);

  final message;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.fromLTRB(10, 15, 0, 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(
          color: myTheme.colorScheme.primary.withOpacity(0.5),
        ),
      ),
      child: Text(
        '$message',
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 14,
          color: myTheme.colorScheme.primary.withOpacity(0.5),
        ),
      ),
    );
  }
}
