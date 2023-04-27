// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void modalBottomSheetForOnProcess(
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
) {
  print('visitDocumentId: $visitDocumentId');
  final List<String> items = [
    AppLocalizations.of(context)!.completed,
    AppLocalizations.of(context)!.canceled,
  ];

  String? selectedValue;
  String? commentaryValue;

  showModalBottomSheet(
    elevation: 0,
    backgroundColor: Colors.white,
    barrierColor: myTheme.colorScheme.secondary.withOpacity(0.5),
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        AppLocalizations.of(context)!.commentary,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.onPrimaryContainer,
                          fontFamily: 'Poppins-regular',
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                      child: TextField(
                        style: TextStyle(
                          fontSize: 14,
                          color: myTheme.colorScheme.primary,
                        ),
                        keyboardType: TextInputType.text,
                        maxLines: 1,
                        maxLength: 200,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            MaterialCommunityIcons.tooltip_edit_outline,
                            color: myTheme.colorScheme.onPrimaryContainer,
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(14, 0, 0, 0),
                          hintText: commentary.toString(),
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: myTheme.colorScheme.primary.withOpacity(0.4),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: myTheme.colorScheme.primary.withOpacity(1),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(color: myTheme.colorScheme.primary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: myTheme.colorScheme.primary),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                        onChanged: (value) {
                          // CAmbiar valor dentro del comentario
                          commentaryValue = value;
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 15),
                      child: Text(
                        AppLocalizations.of(context)!.visitStatus,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: myTheme.colorScheme.onPrimaryContainer,
                          fontFamily: 'Poppins-regular',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
                                    color: myTheme.colorScheme.primary,
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
                                              .withOpacity(0.6)),
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
                            iconEnabledColor:
                                myTheme.colorScheme.primary.withOpacity(0.5),
                            iconDisabledColor: Colors.grey,
                          ),
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(left: 14, right: 14),
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
                            padding: const EdgeInsets.only(left: 14, right: 14),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 200,
                            // width: MediaQuery.of(context).size.width,
                            padding: null,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white,
                            ),
                            elevation: 1,
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(10),
                              thickness: MaterialStateProperty.all<double>(6),
                              thumbVisibility:
                                  MaterialStateProperty.all<bool>(true),
                            ),
                            offset: const Offset(0, 0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  myTheme.colorScheme.primary,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              label: Text(
                                AppLocalizations.of(context)!.seeClient,
                                style: const TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              icon: Icon(Icons.person),
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
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  myTheme.colorScheme.onPrimaryContainer,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              icon: Icon(
                                MaterialCommunityIcons.truck_fast,
                              ),
                              label: Text(
                                AppLocalizations.of(context)!.saveChanges,
                                style: const TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
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
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        title: Text(
                                          AppLocalizations.of(context)!
                                              .visitDeleteConfirmation,
                                          style: TextStyle(
                                            fontFamily: 'Poppins-regular',
                                            color:
                                                myTheme.colorScheme.secondary,
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
                                                  color: myTheme
                                                      .colorScheme.primary,
                                                  fontSize: 14,
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
                                                  color: myTheme
                                                      .colorScheme.primary),
                                              child: TextButton(
                                                onPressed: () async {
                                                  // Eliminar Visita en proceso de DB
                                                  var result = deleteVisit(
                                                    visitDocumentId,
                                                    userUID,
                                                  );
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                style: TextButton.styleFrom(
                                                  foregroundColor: myTheme
                                                      .colorScheme.primary,
                                                ),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .visitDelete,
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        'Poppins-regular',
                                                    color: Colors.white,
                                                    fontSize: 14,
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
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  myTheme.colorScheme.error,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              icon: const Icon(
                                  MaterialCommunityIcons.delete_circle_outline,
                                  color: Colors.white),
                              label: Text(
                                'Eliminar visita',
                                style: const TextStyle(
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
