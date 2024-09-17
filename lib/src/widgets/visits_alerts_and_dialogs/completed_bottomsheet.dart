// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void modalBottomSheetForCompleted({
  required BuildContext context,
  required String commentary,
  required String currentClientName,
  idType,
  required String id,
  specialContributor,
  currentClientPhone,
  required String currentClientEmail,
  required String currentClientAddress,
  required String currentClientDispatchAdress,
  currentClientZones,
  currentClientPrices,
  currentDiscountMaster,
  clientReferenceId,
  required String userUID,
  required String visitDocumentId,
  required String currentClientId,
  currentClientIdType,
  required String date,
}) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  showModalBottomSheet(
    isScrollControlled: true,
    elevation: 0,
    backgroundColor: Colors.white,
    barrierColor: themeProvider.myTheme.colorScheme.secondary.withOpacity(0.5),
    context: context,
    shape: RoundedRectangleBorder(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentClientName,
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF1B1B1F),
                        fontFamily: 'Poppins-regular',
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
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Comentario',
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider
                            .myTheme.colorScheme.onPrimaryContainer,
                        fontFamily: 'Poppins-medium',
                        letterSpacing: 0.15,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 350,
                      height: 65,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xFFDFE0FF),
                        ),
                      ),
                      child: Text(
                        '$commentary',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 14,
                          color: Color(0xFF5A5D77),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (globalRemoteConfig.clientesEnabled == true)
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.white,
                                ),
                                overlayColor: MaterialStateProperty.resolveWith(
                                  (states) {
                                    return states
                                            .contains(MaterialState.pressed)
                                        ? themeProvider
                                            .myTheme.colorScheme.primary
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
                                      color: themeProvider
                                          .myTheme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.seeClient,
                                style: TextStyle(
                                  fontFamily: 'Poppins-medium',
                                  color:
                                      themeProvider.myTheme.colorScheme.primary,
                                  fontSize: 12,
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
                      ],
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
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.fromLTRB(10, 15, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(
          color: themeProvider.myTheme.colorScheme.primary.withOpacity(0.5),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontFamily: 'Poppins-regular',
          fontSize: 14,
          color: themeProvider.myTheme.colorScheme.primary.withOpacity(0.5),
        ),
      ),
    );
  }
}
