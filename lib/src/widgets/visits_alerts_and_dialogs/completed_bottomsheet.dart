// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void modalBottomSheetForCompleted(
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
  showModalBottomSheet(
    elevation: 0,
    backgroundColor: Colors.white,
    barrierColor: myTheme.colorScheme.secondary.withOpacity(0.5),
    // isScrollControlled: true,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(16),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                      width: 350,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10, 15, 0, 10),
                      padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade100,
                        border: Border.all(
                          color: myTheme.colorScheme.primary.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        '$commentary',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          color: myTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(14, 0, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => ClientDetails(
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
                                clientDocumentReferenceID: clientReferenceId,
                                dispatchAddress: currentClientDispatchAdress,
                              ),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            myTheme.colorScheme.primary,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        icon: Icon(Icons.person),
                        label: Text(
                          AppLocalizations.of(context)!.seeClient,
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
      margin: EdgeInsets.fromLTRB(10, 15, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
