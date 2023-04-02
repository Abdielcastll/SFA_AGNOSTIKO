import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
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
    // isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      // print(visitDocumentId);
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      AppLocalizations.of(context)!.commentary,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: myTheme.colorScheme.onPrimaryContainer,
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.fromLTRB(10, 30, 0, 0),
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
                        contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                        hintText: commentary.toString(),
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: myTheme.colorScheme.primary.withOpacity(0.4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: myTheme.colorScheme.primary.withOpacity(0.5),
                          ),
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: myTheme.colorScheme.onPrimaryContainer,
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedValue ??
                                  AppLocalizations.of(context)!.selectStatus,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: myTheme.colorScheme.onPrimaryContainer
                                    .withOpacity(0.5),
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: myTheme.colorScheme.primary,
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
                        iconEnabledColor:
                            myTheme.colorScheme.primary.withOpacity(0.5),
                        iconDisabledColor: Colors.grey,
                      ),
                      buttonStyleData: ButtonStyleData(
                        height: 50,
                        width: 200,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: myTheme.colorScheme.primary.withOpacity(0.3),
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
                        width: 200,
                        padding: null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        elevation: 8,
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(10),
                          thickness: MaterialStateProperty.all<double>(6),
                          thumbVisibility:
                              MaterialStateProperty.all<bool>(true),
                        ),
                        offset: const Offset(-20, 0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: myTheme.colorScheme.primary),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        myTheme.colorScheme.primary,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.seeClient,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins-regular',
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ClientDetails(
                                          specialContribuyer:
                                              specialContributor,
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
                              const SizedBox(width: 10),
                              Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: myTheme.colorScheme.primary),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        myTheme.colorScheme.secondary,
                                  ),
                                  child: Text(
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
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.red,
                                ),
                                child: IconButton(
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
                                                color: myTheme
                                                    .colorScheme.secondary,
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
                                                    AppLocalizations.of(
                                                            context)!
                                                        .goBack,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      color: myTheme
                                                          .colorScheme.primary,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 150,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
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
                                                      AppLocalizations.of(
                                                              context)!
                                                          .visitDelete,
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'Poppins-regular',
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  icon: const Icon(
                                      Icons.delete_forever_outlined,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.transparent,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        myTheme.colorScheme.primary,
                                  ),
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
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
