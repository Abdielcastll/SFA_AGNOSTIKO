// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void modalBottomSheetForCompleted({
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
  showModalBottomSheet(
    isScrollControlled: true,
    elevation: 0,
    backgroundColor: Colors.white,
    barrierColor: myTheme.colorScheme.secondary.withOpacity(0.5),
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
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
          // return SafeArea(
          //   child: Container(
          //     padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          //     child: SingleChildScrollView(
          //       child: Column(
          //         children: [
          //           Container(
          //             alignment: Alignment.centerLeft,
          //             margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          //             child: Text(
          //               AppLocalizations.of(context)!.commentary,
          //               style: TextStyle(
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.bold,
          //                 color: myTheme.colorScheme.onPrimaryContainer,
          //                 fontFamily: 'Poppins-regular',
          //               ),
          //             ),
          //           ),
          //           Container(
          //             width: 350,
          //             height: 40,
          //             alignment: Alignment.centerLeft,
          //             margin: EdgeInsets.fromLTRB(10, 15, 0, 10),
          //             padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(20),
          //               color: Colors.grey.shade100,
          //               border: Border.all(
          //                 color: myTheme.colorScheme.primary.withOpacity(0.5),
          //               ),
          //             ),
          //             child: Text(
          //               '$commentary',
          //               maxLines: 1,
          //               overflow: TextOverflow.ellipsis,
          //               style: TextStyle(
          //                 fontFamily: 'Poppins-regular',
          //                 fontSize: 14,
          //                 color: myTheme.colorScheme.primary,
          //               ),
          //             ),
          //           ),
          //           Container(
          //             margin: EdgeInsets.fromLTRB(14, 0, 0, 0),
          //             width: MediaQuery.of(context).size.width,
          //             child: ElevatedButton.icon(
          //               onPressed: () {
          //                 Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                     builder: (BuildContext context) => ClientDetails(
          //                       specialContribuyer: specialContributor,
          //                       masterDiscount: currentDiscountMaster,
          //                       fiscalAddress: currentClientAddress,
          //                       email: currentClientEmail,
          //                       listOfPrices: currentClientPrices,
          //                       name: currentClientName,
          //                       tlf1: currentClientPhone,
          //                       tlf2: currentClientPhone,
          //                       zone: currentClientZones,
          //                       nameId: currentClientId,
          //                       typeId: currentClientIdType,
          //                       clientDocumentReferenceID: clientReferenceId,
          //                       dispatchAddress: currentClientDispatchAdress,
          //                     ),
          //                   ),
          //                 );
          //               },
          //               style: ButtonStyle(
          //                 backgroundColor: MaterialStateProperty.all(
          //                   myTheme.colorScheme.primary,
          //                 ),
          //                 shape:
          //                     MaterialStateProperty.all<RoundedRectangleBorder>(
          //                   RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(18.0),
          //                   ),
          //                 ),
          //               ),
          //               icon: Icon(Icons.person),
          //               label: Text(
          //                 AppLocalizations.of(context)!.seeClient,
          //                 style: TextStyle(
          //                   fontFamily: 'Poppins-regular',
          //                   color: Colors.white,
          //                   fontSize: 14,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // );
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
