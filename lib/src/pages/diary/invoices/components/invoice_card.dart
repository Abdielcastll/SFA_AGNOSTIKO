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
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/invoices_alerts_and_dialogs/invoice_modalbottomsheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    this.invoiceDocumentID,
    this.invoicePercetageTax,
    required this.invoiceTax,
    this.invoiceSubtotal,
    this.discount,
    this.discountPercentage,
  }) : super(key: key);

  final invoiceClient;
  final invoiceOrder;
  final invoiceDate;
  final invoiceBalance;
  final invoiceStatus;
  final invoicePayments;
  final invoiceNumber;
  final invoiceTotal;
  final invoiceDocumentID;
  final invoicePercetageTax;
  final double invoiceTax;
  final invoiceSubtotal;
  final discountPercentage;
  final discount;

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
        catchError: (context, error) {
          return;
        },
      ),
      StreamProvider<ZoneSummary?>.value(
        initialData: null,
        value: DatabaseServiceStreams().zoneSummary,
      ),
    ], child: InvoiceCardBody(widget: widget));
  }
}

class InvoiceCardBody extends StatelessWidget {
  InvoiceCardBody({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final InvoiceCard widget;

  @override
  Widget build(BuildContext context) {
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;

    priceFormat(productPrice) {
      double correctAmount = double.parse(productPrice.toStringAsFixed(4));
      if (currentCoin!.contains('USD')) {
        return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
            .format(productPrice)
            .toString();
      } else if (currentCoin.contains('VED')) {
        return NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "Bs.",
        ).format(correctAmount * 4.58).toString();
      } else if (currentCoin.contains('EUR')) {
        return NumberFormat.currency(
          locale: 'es_ES',
          decimalDigits: 2,
          symbol: '€',
        ).format(correctAmount * 0.89).toString();
      } else if (currentCoin.contains('MXN')) {
        return NumberFormat.currency(
          locale: 'es_MX',
          decimalDigits: 2,
          symbol: '\$',
        ).format(correctAmount * 19.43);
      } else if (currentCoin.contains('BTC')) {
        return '฿ ${(correctAmount * 0.00011).toStringAsFixed(6)}';
      } else {
        return NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "PPR.",
        ).format(correctAmount * 4.58).toString();
      }
    }

    Color? identifyColor() {
      if (widget.invoiceStatus == AppLocalizations.of(context)!.onProcess) {
        return Colors.amber.shade600;
      } else if (widget.invoiceStatus ==
          AppLocalizations.of(context)!.invoiced) {
        return Colors.green.shade600;
      }
    }

    final currentClient = Provider.of<Client?>(context) ?? {};
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
        widget.invoiceStatus == AppLocalizations.of(context)!.onProcess
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
                currentClient,
                widget.invoiceDocumentID,
                currentClientDispatchAdress,
                widget.invoiceSubtotal,
                widget.invoicePercetageTax,
                widget.invoiceTax,
                widget.discountPercentage,
                widget.discount,
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
                currentClient,
                widget.invoiceDocumentID,
                currentClientDispatchAdress,
                widget.invoiceSubtotal,
                widget.invoicePercetageTax,
                widget.invoiceTax,
                widget.discountPercentage,
                widget.discount,
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
                        // '$currentClientName #${widget.invoiceNumber}',
                        '$currentClientName',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Poppins-regular",
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Text(
                      '${priceFormat(widget.invoiceBalance)}',
                      style: TextStyle(
                        color: identifyColor(),
                        fontSize: 15,
                        fontFamily: "Poppins-regular",
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 5, 0, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          fontFamily: "Poppins-regular",
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Container(
                      height: 13,
                      child: Text(
                        '${widget.invoiceDate}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Poppins-regular",
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Container(
                      height: 13,
                      child: Text(
                        'F#${widget.invoiceNumber}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Poppins-regular",
                          color: Colors.grey.shade500,
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
                          fontSize: 10,
                          fontFamily: "Poppins-regular",
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
