import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/visits_alerts_and_dialogs/completed_bottomsheet.dart';
import 'package:pwa_sales2go_flutter/src/widgets/visits_alerts_and_dialogs/visits_onprocess_bottomsheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VisitCard extends StatefulWidget {
  const VisitCard({
    Key? key,
    this.hour,
    this.date,
    this.status,
    this.visitDocumentId,
    this.commentary,
    this.clientReferenceId,
  }) : super(key: key);

  final visitDocumentId;
  final hour;
  final date;
  final status;
  final commentary;
  final clientReferenceId;

  @override
  State<VisitCard> createState() => _VisitCardState();
}

class _VisitCardState extends State<VisitCard> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Client?>.value(
          initialData: null,
          value: FirebaseFirestore.instance
              .collection('clientes')
              .doc(widget.clientReferenceId)
              .snapshots()
              .map(clientFromDocumentID),
          catchError: (context, error) {
            // print(error);
            return;
          },
        ),
        StreamProvider<ZoneSummary?>.value(
          initialData: null,
          value: DatabaseServiceStreams().zoneSummary,
        ),
      ],
      child: VIsitCardBody(widget: widget),
    );
  }
}

class VIsitCardBody extends StatefulWidget {
  const VIsitCardBody({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final VisitCard widget;

  @override
  State<VIsitCardBody> createState() => _VIsitCardBodyState();
}

class _VIsitCardBodyState extends State<VIsitCardBody> {
  identifyColor() {
    if (widget.widget.status == AppLocalizations.of(context)!.onProcess) {
      return Colors.amber.shade600;
    } else if (widget.widget.status ==
        AppLocalizations.of(context)!.completed) {
      return Colors.green.shade600;
    } else if (widget.widget.status == AppLocalizations.of(context)!.canceled) {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentClientName = Provider.of<Client?>(context)?.name ?? '';
    final currentClientAddress =
        Provider.of<Client?>(context)?.fiscalAdress ?? '';
    final currentClientIdType = Provider.of<Client?>(context)?.idType ?? '';
    final currentClientId = Provider.of<Client?>(context)?.id ?? '';
    final currentClientSpecial =
        Provider.of<Client?>(context)?.specialContributor ?? '';
    final currentClientPhone = Provider.of<Client?>(context)?.phone1 ?? '';
    final currentClientEmail = Provider.of<Client?>(context)?.email ?? '';
    final currentClientDispatchAdress =
        Provider.of<Client?>(context)?.dispatchAdress ?? '';
    final currentClientZones = Provider.of<Client?>(context)?.zone ?? '';
    final currentClientPrices = Provider.of<Client?>(context)?.prices ?? '';
    final currentDiscountMaster =
        Provider.of<Client?>(context)?.masterDiscount ?? {};
    final zonesSummary = Provider.of<ZoneSummary?>(context)?.summary ?? '';
    final userUID = Provider.of<UserModel>(context).uid;

    return currentClientName == ''
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Center(
              child: SpinKitCircle(
                color: myTheme.colorScheme.primary,
                size: 50,
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              widget.widget.status == AppLocalizations.of(context)!.onProcess
                  ? modalBottomSheetForOnProcess(
                      context,
                      widget.widget.commentary,
                      currentClientName,
                      currentClientIdType,
                      currentClientId,
                      currentClientSpecial,
                      currentClientPhone,
                      currentClientEmail,
                      currentClientAddress,
                      currentClientDispatchAdress,
                      zonesSummary[currentClientZones],
                      currentClientPrices,
                      currentDiscountMaster,
                      widget.widget.clientReferenceId,
                      userUID,
                      widget.widget.visitDocumentId,
                      currentClientId,
                      currentClientIdType,
                    )
                  : modalBottomSheetForCompleted(
                      context,
                      widget.widget.commentary,
                      currentClientName,
                      currentClientIdType,
                      currentClientId,
                      currentClientSpecial,
                      currentClientPhone,
                      currentClientEmail,
                      currentClientAddress,
                      currentClientDispatchAdress,
                      zonesSummary[currentClientZones],
                      currentClientPrices,
                      currentDiscountMaster,
                      widget.widget.clientReferenceId,
                      userUID,
                      widget.widget.visitDocumentId,
                      currentClientId,
                      currentClientIdType,
                    );
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 3, left: 14, right: 14, bottom: 0),
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                width: 360.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14, top: 10),
                          child: SizedBox(
                            width: 200,
                            child: Text(
                              '$currentClientName',
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Poppins-regular',
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 14, 0),
                          child: Text(
                            widget.widget.date,
                            style: TextStyle(
                              color: identifyColor(),
                              fontSize: 13,
                              fontFamily: 'Poppins-regular',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(14, 0, 0, 0),

                            // height: 13,
                            // width: 150,
                            // color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  currentClientId == 0
                                      ? 'Sin Identificación'
                                      : 'ID: ${currentClientIdType.toString()}-${currentClientId.toString()}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    // color: Colors.grey.shade500,
                                    color: myTheme.colorScheme.secondary,
                                    fontFamily: 'Poppins-regular',
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  // '${widget.widget.date}',
                                  // '000-000-0000',
                                  'TLF:$currentClientPhone',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    // color: Colors.grey.shade500,
                                    color: myTheme.colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(14, 0, 14, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              currentClientAddress,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                // fontWeight: FontWeight.w400,
                                color: myTheme.colorScheme.secondary,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              widget.widget.status,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: identifyColor(),
                                fontFamily: 'Poppins-regular',
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
  }
}
