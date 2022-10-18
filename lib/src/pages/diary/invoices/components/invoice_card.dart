// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/invoice_modalbottomsheet.dart';

class InvoiceCard extends StatefulWidget {
  const InvoiceCard({
    Key? key,
    this.invoiceClient,
    this.invoiceOrder,
    this.invoiceDate,
    this.invoiceBalance,
    this.invoiceStatus,
    this.invoicePayments,
    this.invoiceNumber,
    this.invoiceTotal,
  }) : super(key: key);

  final invoiceClient;
  final invoiceOrder;
  final invoiceDate;
  final invoiceBalance;
  final invoiceStatus;
  final invoicePayments;
  final invoiceNumber;
  final invoiceTotal;

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<Client?>.value(
        initialData: null,
        value: FirebaseFirestore.instance
            .collection('clientes')
            .doc(widget.invoiceClient)
            .snapshots()
            .map(clientFromDocumentID),
      ),
      StreamProvider<ZoneSummary?>.value(
        initialData: null,
        value: DatabaseServiceStreams().zoneSummary,
      ),
    ], child: InvoiceCardBody(widget: widget));
  }
}

class InvoiceCardBody extends StatelessWidget {
  const InvoiceCardBody({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final InvoiceCard widget;

  @override
  Widget build(BuildContext context) {
    // print(Timestamp.fromDate(DateTime.parse(widget.invoiceDate)));
    Color? identifyColor() {
      if (widget.invoiceStatus == 'En proceso') {
        return Colors.amber.shade300;
      } else if (widget.invoiceStatus == 'Facturado') {
        return Colors.green;
      }
    }

    final currentClientName = Provider.of<Client?>(context)?.name ?? '';
    final currentClientSpecialContributor =
        Provider.of<Client?>(context)?.specialContributor ?? '';
    final currentClientAddress =
        Provider.of<Client?>(context)?.fiscalAdress ?? '';
    final currentClientIdType = Provider.of<Client?>(context)?.idType ?? '';
    final currentClientId = Provider.of<Client?>(context)?.id ?? '';
    final currentClientPhone = Provider.of<Client?>(context)?.phone1 ?? '';
    final currentClientPhone2 = Provider.of<Client?>(context)?.phone2 ?? '';
    final currentClientEmail = Provider.of<Client?>(context)?.email ?? '';
    final currentClientDispatchAdress =
        Provider.of<Client?>(context)?.dispatchAdress ?? '';
    final currentClientZones = Provider.of<Client?>(context)?.zone ?? '';
    final currentClientPrices = Provider.of<Client?>(context)?.prices ?? '';
    final currentClientRefID =
        Provider.of<Client?>(context)?.clientDocumentId ?? '';
    final zonesSummary = Provider.of<ZoneSummary?>(context)?.summary ?? '';

    final currentDiscountMaster =
        Provider.of<Client?>(context)?.masterDiscount ?? {};
    final userUID = Provider.of<UserModel>(context).uid;

    return GestureDetector(
      onTap: () {
        widget.invoiceStatus == 'En proceso'
            ? modalBottomSheetForInvoices(
                false,
                context,
                currentClientSpecialContributor,
                currentDiscountMaster,
                currentClientAddress,
                currentClientEmail,
                currentClientPrices,
                currentClientName,
                currentClientPhone,
                currentClientPhone2,
                zonesSummary[currentClientZones],
                currentClientId,
                currentClientIdType,
                currentClientRefID,
                widget.invoicePayments,
                widget.invoiceNumber,
                widget.invoiceTotal,
              )
            : modalBottomSheetForInvoices(
                true,
                context,
                currentClientSpecialContributor,
                currentDiscountMaster,
                currentClientAddress,
                currentClientEmail,
                currentClientPrices,
                currentClientName,
                currentClientPhone,
                currentClientPhone2,
                zonesSummary[currentClientZones],
                currentClientId,
                currentClientIdType,
                currentClientRefID,
                widget.invoicePayments,
                widget.invoiceNumber,
                widget.invoiceTotal,
              );
      },
      child: Padding(
        padding: EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 5),
        child: Container(
          width: 360.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 14, top: 10),
                    child: Container(
                      width: 200,
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
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Text(
                      '\$${widget.invoiceBalance}',
                      style: TextStyle(
                        color: identifyColor(),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 5, 0, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 13,
                      // width: 150,
                      child: Text(
                        'ID: $currentClientIdType-$currentClientId',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    Container(
                      height: 13,
                      // width: 95,
                      child: Text(
                        '${widget.invoiceDate}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    Container(
                      height: 13,
                      // width: 150,
                      child: Text(
                        'F#${widget.invoiceNumber}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    Container(
                      height: 13,
                      // width: 70,
                      child: Text(
                        '${widget.invoiceStatus}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: identifyColor(),
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
