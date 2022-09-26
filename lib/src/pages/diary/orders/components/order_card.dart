// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_details/client_details.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/orders_alerts_and_dialogs/orders_bottomsheet.dart';

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

class OrderCardBody extends StatelessWidget {
  const OrderCardBody({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final OrderCard widget;

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
    final currentClientRefID =
        Provider.of<Client?>(context)?.clientDocumentId ?? 'NaN';
    final zonesSummary = Provider.of<ZoneSummary?>(context)?.summary ?? 'NaN';

    final currentDiscountMaster =
        Provider.of<Client?>(context)?.masterDiscount ?? {};
    final userUID = Provider.of<UserModel>(context).uid;

    identifyStatusColor() {
      if (widget.status == 'En proceso' && widget.isInvoicesFailed == false) {
        return Colors.amber;
      } else if (widget.status == 'Completada' &&
          widget.isInvoicesFailed == true) {
        return Colors.red;
      } else if (widget.status == 'Completada' &&
          widget.isInvoicesFailed == false) {
        return Colors.green;
      }
    }

    return GestureDetector(
      onTap: () {
        // Redireccionar a detalles del pedido
        widget.status == 'En proceso'
            ? modalBottomSheetForOrders(
                false,
                context,
                widget.commentary,
                widget.clientReferenceId,
                widget.products,
                widget.subTotal,
                widget.discountMaster,
                widget.tax,
                widget.total,
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
                widget.clientReferenceId,
                userUID,
                widget.orderDocumentId,
              )
            : modalBottomSheetForOrders(
                true,
                context,
                widget.commentary,
                widget.clientReferenceId,
                widget.products,
                widget.subTotal,
                widget.discountMaster,
                widget.tax,
                widget.total,
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
                widget.clientReferenceId,
                userUID,
                widget.orderDocumentId,
              );
      },
      child: Padding(
        padding: EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 5),
        child: Container(
          // margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                      '\$${widget.total}',
                      style: TextStyle(
                        color: identifyStatusColor(),
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
                  children: [
                    Container(
                      height: 13,
                      width: 150,
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
                      width: 95,
                      child: Text(
                        '${widget.date}',
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
                      width: 70,
                      child: Text(
                        '${widget.status}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
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
      ),
    );
  }
}
