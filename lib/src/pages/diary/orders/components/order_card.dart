// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/widgets/orders_alerts_and_dialogs/orders_bottomsheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderCard extends StatefulWidget {
  const OrderCard({
    Key? key,
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
    this.coinsExchangeRates,
    this.correlativeNumber,
    required this.showButton,
    this.orderProductQuantities,
  }) : super(key: key);

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
  final correlativeNumber;
  final bool showButton;
  final orderProductQuantities;

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
          value: clientesRef
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
    final currentDiscountMaster =
        Provider.of<Client?>(context)?.masterDiscount ?? {};
    final zonesSummary = Provider.of<ZoneSummary?>(context)?.summary ?? '';
    final userUID = Provider.of<UserModel>(context).uid;
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '\$';
    // Get if user is a retail seller
    final userRole = Provider.of<UserRole?>(context, listen: true);
    // print('User Role ${userRole?.name}');
    // print("Retail: ${userRole?.isRetail}");
    final totalProducts = widget.widget.orderProductQuantities.reduce(
      (a, b) =>
          int.parse(a.toString()) +
          int.parse(
            b.toString(),
          ),
    );

    final totalConverted = priceMultipliedByItsExchangeRatio2(
        productPrice: widget.widget.total,
        coinDecimals: coinDecimals,
        coinExchangeRatio: double.parse(
            (widget.widget.coinsExchangeRates?['MXN'] ?? 1).toString()));

    var totalFormatted = formatDecimalPriceByRegion(price: totalConverted);

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
                      widget.widget.correlativeNumber,
                      isRetail: userRole?.isRetail ?? true,
                      showButton: widget.widget.showButton,
                      coinExchangeRateFromDB: double.parse(
                          (widget.widget.coinsExchangeRates?['MXN'] ?? 1)
                              .toString()))
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
                      widget.widget.correlativeNumber,
                      isRetail: userRole?.isRetail ?? true,
                      showButton: widget.widget.showButton,
                      coinExchangeRateFromDB:
                          double.parse((widget.widget.coinsExchangeRates?['MXN'] ?? 1).toString()));
            },
            child: Container(
              margin: EdgeInsets.only(top: 5, left: 14, right: 14, bottom: 5),
              padding: EdgeInsets.fromLTRB(14, 5, 0, 0),
              // width: 360.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            '$currentClientName',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins-regular',
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '$coinSymbol $totalFormatted',
                          style: TextStyle(
                            color: identifyStatusColor(),
                            fontSize: 13,
                            fontFamily: 'Poppins-Medium',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 15,
                    child: Text(
                      '$totalProducts items',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'Poppins-medium',
                        color: Color(0xFF7D5070),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          // height: 13,
                          width: 100,
                          child: Text(
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
                        ),
                        Container(
                          // height: 13,
                          width: 95,
                          child: Text(
                            '${widget.widget.date}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Poppins-medium',
                              color: identifyStatusColor(),
                            ),
                          ),
                        ),
                        Container(
                          // height: 13,
                          // width: 70,
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Text(
                            '${widget.widget.status}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Poppins-medium',
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
