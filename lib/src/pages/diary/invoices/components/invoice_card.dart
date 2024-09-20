// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
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
    required this.invoiceExchangeRatefromDB,
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
  final invoiceExchangeRatefromDB;

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  @override
  Widget build(BuildContext context) {
    print(
        '${widget.invoiceDocumentID} : ${widget.discountPercentage} : ${widget.discount}');
    return MultiProvider(providers: [
      StreamProvider<Client?>.value(
        initialData: null,
        value: clientesRef
            .doc(widget.invoiceClient)
            .snapshots()
            .map(Client.fromSnapshot),
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';

    final totalConverted = priceMultipliedByItsExchangeRatio2(
        productPrice: widget.invoiceBalance,
        coinDecimals: coinDecimals,
        coinExchangeRatio: double.parse(
            (widget.invoiceExchangeRatefromDB?['MXN'] ?? 1).toString()));

    var totalFormatted = formatDecimalPriceByRegion(price: totalConverted);

    Color identifyColor() {
      if (widget.invoiceStatus == AppLocalizations.of(context)!.onProcess) {
        return Colors.amber.shade600;
      } else if (widget.invoiceStatus ==
          AppLocalizations.of(context)!.invoiced) {
        return Colors.green.shade600;
      } else {
        return themeProvider.myTheme.colorScheme.secondary;
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

    return currentClientName == ''
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Center(
              child: SpinKitCircle(
                color: themeProvider.myTheme.colorScheme.primary,
                size: 50,
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              print(widget.invoiceExchangeRatefromDB);
              print(widget.invoiceDocumentID);

              widget.invoiceStatus == AppLocalizations.of(context)!.onProcess
                  ? modalBottomSheetForInvoices(
                      completed: false,
                      context: context,
                      specialContribuyer: currentClientSpecialContributor,
                      masterDiscount: currentDiscountMaster,
                      fiscalAddress: currentClientAddress,
                      email: currentClientEmail,
                      listOfPrices: currentClientPrices,
                      name: currentClientName,
                      tlf1: currentClientPhone,
                      tlf2: currentClientPhone2,
                      zone: zonesSummary[currentClientZones],
                      nameId: currentClientId,
                      typeId: currentClientIdType,
                      clientDocumentReferenceID: currentClientRefID,
                      invoicePayments: widget.invoicePayments,
                      invoiceNumber: widget.invoiceNumber,
                      invoiceTotal: widget.invoiceTotal,
                      client: currentClient,
                      invoiceDocumentID: widget.invoiceDocumentID,
                      currentClientDispatchAdress: currentClientDispatchAdress,
                      subTotal: widget.invoiceSubtotal,
                      percentageTax: widget.invoicePercetageTax,
                      tax: widget.invoiceTax,
                      discountPercentage: widget.discountPercentage,
                      discount: widget.discount,
                      invoiceDate: widget.invoiceDate,
                    )
                  : modalBottomSheetForInvoices(
                      completed: true,
                      context: context,
                      specialContribuyer: currentClientSpecialContributor,
                      masterDiscount: currentDiscountMaster,
                      fiscalAddress: currentClientAddress,
                      email: currentClientEmail,
                      listOfPrices: currentClientPrices,
                      name: currentClientName,
                      tlf1: currentClientPhone,
                      tlf2: currentClientPhone2,
                      zone: zonesSummary[currentClientZones],
                      nameId: currentClientId,
                      typeId: currentClientIdType,
                      clientDocumentReferenceID: currentClientRefID,
                      invoicePayments: widget.invoicePayments,
                      invoiceNumber: widget.invoiceNumber,
                      invoiceTotal: widget.invoiceTotal,
                      client: currentClient,
                      invoiceDocumentID: widget.invoiceDocumentID,
                      currentClientDispatchAdress: currentClientDispatchAdress,
                      subTotal: widget.invoiceSubtotal,
                      percentageTax: widget.invoicePercetageTax,
                      tax: widget.invoiceTax,
                      discountPercentage: widget.discountPercentage,
                      discount: widget.discount,
                      invoiceDate: widget.invoiceDate,
                    );
            },
            child: Padding(
              padding: EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 5),
              child: Container(
                padding: EdgeInsets.fromLTRB(14, 10, 14, 0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              '$currentClientName',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: "Poppins-Regular",
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              '$coinSymbol $totalFormatted',
                              style: TextStyle(
                                color: identifyColor(),
                                fontSize: 13,
                                fontFamily: "Poppins-Regular",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 13,
                            // width: 150,
                            child: Text(
                              currentClientId == 0
                                  ? "Sin Identificacion"
                                  : 'ID: $currentClientIdType-$currentClientId',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: "Poppins-regular",
                                color:
                                    themeProvider.myTheme.colorScheme.secondary,
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
                                fontSize: 10,
                                fontFamily: "Poppins-regular",
                                color:
                                    themeProvider.myTheme.colorScheme.secondary,
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
                                fontSize: 10,
                                fontFamily: "Poppins-regular",
                                color:
                                    themeProvider.myTheme.colorScheme.secondary,
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
                                fontFamily: "Poppins-Regular",
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
