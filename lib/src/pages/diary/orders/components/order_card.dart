// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/orders_alerts_and_dialogs/orders_bottomsheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderCard extends StatefulWidget {
  const OrderCard(
      {Key? key,
      this.clientReferenceId,
      this.date,
      this.total,
      this.orderDocumentId,
      this.status,
      this.isInvoicesFailed,
      this.commentary,
      this.products,
      this.subTotal,
      this.discountMaster,
      this.tax,
      this.coinsExchangeRates})
      : super(key: key);

  final clientReferenceId;
  final date;
  final total;
  final orderDocumentId;
  final status;
  final isInvoicesFailed;
  final commentary;
  final products;
  final subTotal;
  final discountMaster;
  final tax;
  final coinsExchangeRates;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
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
      child: OrderCardBody(widget: widget),
    );
  }
}

class OrderCardBody extends StatefulWidget {
  const OrderCardBody({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final OrderCard widget;

  @override
  State<OrderCardBody> createState() => _OrderCardBodyState();
}

class _OrderCardBodyState extends State<OrderCardBody> {
  final String? currentCoin =
      sharedPreferences!.getString('currentCoin') ?? 'Dolares - USD';

  priceFormat(productPrice) {
    if (currentCoin!.contains('USD') || currentCoin == null) {
      return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
          .format(productPrice)
          .toString();
    } else if (currentCoin!.contains('VED')) {
      return NumberFormat.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: "Bs.",
      ).format(productPrice * 4.58).toString();
    } else if (currentCoin!.contains('EUR')) {
      return NumberFormat.currency(
        locale: 'es_ES',
        decimalDigits: 2,
        symbol: '€',
      ).format(productPrice * 0.89).toString();
    } else if (currentCoin!.contains('MXN')) {
      return NumberFormat.currency(
        locale: 'es_MX',
        decimalDigits: 2,
        symbol: '\$',
      ).format(productPrice * 19.43);
    } else if (currentCoin!.contains('BTC')) {
      return '฿ ${(productPrice * 0.00011).toString()}';
    } else {
      return NumberFormat.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: "PPR.",
      ).format(productPrice * 4.58).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentClient = Provider.of<Client?>(context) ?? [];
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
    final currentClientRefID =
        Provider.of<Client?>(context)?.clientDocumentId ?? '';
    final zonesSummary = Provider.of<ZoneSummary?>(context)?.summary ?? '';

    final currentDiscountMaster =
        Provider.of<Client?>(context)?.masterDiscount ?? {};
    final userUID = Provider.of<UserModel>(context).uid;

    identifyStatusColor() {
      if (widget.widget.status == AppLocalizations.of(context)!.onProcess &&
          widget.widget.isInvoicesFailed == false) {
        return Colors.amber.shade600;
      } else if (widget.widget.status ==
              AppLocalizations.of(context)!.completed &&
          widget.widget.isInvoicesFailed == true) {
        return Colors.red;
      } else if (widget.widget.status ==
              AppLocalizations.of(context)!.completed &&
          widget.widget.isInvoicesFailed == false) {
        return Colors.green.shade600;
      }
    }

    return GestureDetector(
      onTap: () {
        widget.widget.status == AppLocalizations.of(context)!.onProcess
            ? modalBottomSheetForOrders(
                false,
                context,
                widget.widget.commentary,
                widget.widget.clientReferenceId,
                widget.widget.products,
                widget.widget.subTotal,
                widget.widget.discountMaster,
                widget.widget.tax,
                widget.widget.total,
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
                widget.widget.orderDocumentId,
                currentClientId,
                currentClientIdType,
                currentClient,
                widget.widget.date,
              )
            : modalBottomSheetForOrders(
                true,
                context,
                widget.widget.commentary,
                widget.widget.clientReferenceId,
                widget.widget.products,
                widget.widget.subTotal,
                widget.widget.discountMaster,
                widget.widget.tax,
                widget.widget.total,
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
                widget.widget.orderDocumentId,
                currentClientId,
                currentClientIdType,
                currentClient,
                widget.widget.date,
              );
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, left: 14, right: 14, bottom: 5),
        padding: EdgeInsets.fromLTRB(14, 5, 0, 5),
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
                SizedBox(
                  width: 200,
                  child: Text(
                    '$currentClientName',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Poppins-regular',
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text(
                    '${priceFormat(widget.widget.total)}',
                    style: TextStyle(
                      color: identifyStatusColor(),
                      fontSize: 16,
                      fontFamily: 'Poppins-regular',
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 13,
                    width: 150,
                    child: Text(
                      'ID: ${currentClientIdType.toString()}-${currentClientId.toString()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                  ),
                  Container(
                    height: 13,
                    width: 95,
                    child: Text(
                      '${widget.widget.date}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  Container(
                    height: 13,
                    width: 70,
                    child: Text(
                      '${widget.widget.status}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: identifyStatusColor(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
