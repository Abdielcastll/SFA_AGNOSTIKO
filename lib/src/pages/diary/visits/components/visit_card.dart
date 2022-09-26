// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/widgets/visits_alerts_and_dialogs/completed_bottomsheet.dart';
import 'package:pwa_sales2go_flutter/src/widgets/visits_alerts_and_dialogs/onprocess_bottomsheet.dart';

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
    if (widget.widget.status == 'En proceso') {
      return Colors.amber.shade300;
    } else if (widget.widget.status == 'Completada') {
      return Colors.green;
    } else if (widget.widget.status == 'Cancelada') {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentClientName = Provider.of<Client?>(context)?.name ?? 'NaN';
    final currentClientAddress =
        Provider.of<Client?>(context)?.fiscalAdress ?? 'NaN';
    final currentClientIdType = Provider.of<Client?>(context)?.idType ?? 'NaN';
    final currentClientId = Provider.of<Client?>(context)?.id ?? 'NaN';
    final currentClientSpecial =
        Provider.of<Client?>(context)?.specialContributor ?? 'NaN';
    final currentClientPhone = Provider.of<Client?>(context)?.phone1 ?? 'NaN';
    final currentClientEmail = Provider.of<Client?>(context)?.email ?? 'NaN';
    final currentClientDispatchAdress =
        Provider.of<Client?>(context)?.dispatchAdress ?? 'NaN';
    final currentClientZones = Provider.of<Client?>(context)?.zone ?? 'NaN';
    final currentClientPrices = Provider.of<Client?>(context)?.prices ?? 'NaN';
    final currentDiscountMaster =
        Provider.of<Client?>(context)?.masterDiscount ?? {};
    final zonesSummary = Provider.of<ZoneSummary?>(context)?.summary ?? 'NaN';
    final userUID = Provider.of<UserModel>(context).uid;

    return GestureDetector(
      onTap: () {
        // Redireccionar a la funcion de los detalles de la visitas
        widget.widget.status == 'En proceso'
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
              );
      },
      child: Padding(
        padding: EdgeInsets.only(top: 3, left: 16, right: 16, bottom: 0),
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          // padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          width: 360.0,
          // height: 70,
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
                    padding: EdgeInsets.only(left: 14, top: 10),
                    child: Container(
                      width: 220,
                      child: Text(
                        '$currentClientName',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 14),
                    child: Text(
                      widget.widget.date,
                      style: TextStyle(
                        color: identifyColor(),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 14),
                      child: Container(
                        // margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        // height: 13,
                        width: 250,
                        child: Text(
                          currentClientAddress,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        // margin: EdgeInsets.only(bottom: 10),
                        height: 13,
                        width: 60,
                        child: Text(
                          widget.widget.status,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: identifyColor(),
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
  }
}
