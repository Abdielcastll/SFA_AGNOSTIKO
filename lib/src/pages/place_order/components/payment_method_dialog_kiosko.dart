import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/add_payment.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class PaymentMethodDialog extends StatefulWidget {
  final String userUid;
  final List<ShoppingCartProduct> products;
  final double ivaConverted;
  final double subTotalConverted;
  final double totalConverted;
  final dynamic client;

  const PaymentMethodDialog({
    required this.userUid,
    required this.products,
    required this.ivaConverted,
    required this.subTotalConverted,
    required this.totalConverted,
    required this.client,
  });

  @override
  _PaymentMethodDialogState createState() => _PaymentMethodDialogState();
}

bool loading = false;

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
  late String paymentMethod;
  final List<String> items = [
    'Seleciona',
    'Tarjeta de Debito',
    'Tarjeta de Credito',
    'Efectivo',
  ];

  @override
  void initState() {
    paymentMethod = items.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      actionsOverflowButtonSpacing: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Registrar Pago',
            style: TextStyle(
              fontFamily: 'Poppins-regular',
              color: myTheme.colorScheme.primary,
            ),
          ),
        ],
      ),
      content: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Metodo de Pago',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: myTheme.colorScheme.primary,
                fontFamily: 'Poppins-regular',
              ),
            ),
            const SizedBox(height: 10),
            loading
                ? const Padding(
                    padding: EdgeInsets.only(top: 35),
                    child: Row(
                      children: [
                        Spacer(),
                        CircularProgressIndicator(),
                        Spacer(),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Seleciona',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: myTheme.colorScheme.onPrimaryContainer,
                                  fontFamily: 'Poppins-regular',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins-regular',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))
                            .toList(),
                        value: paymentMethod,
                        onChanged: (value) {
                          setState(() {
                            paymentMethod = value!;
                          });
                          if (paymentMethod != 'Seleciona') {
                            processSelection(paymentMethod);
                          }
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  processSelection(paymentMethod) async {
    setState(() {
      loading = true;
    });
    final firebaseID = FirebaseFirestore.instance
        .collection('clientes')
        .doc(widget.client!.clientDocumentId)
        .collection('pedidos')
        .doc()
        .id;

    final invoiceNumber = await completePaymentProcess(
      widget.client,
      widget.userUid,
      '',
      0,
      widget.products,
      'Factura',
      'Fiscal',
      DateTime.now(),
      widget.ivaConverted,
      0,
      widget.subTotalConverted,
      widget.totalConverted,
      0,
      firebaseID,
    );

    Client currentClient = Client(
      active: widget.client!.active,
      specialContributor: widget.client!.specialContributor,
      madeBy: widget.client!.madeBy,
      masterDiscount: widget.client!.masterDiscount,
      fiscalAdress: widget.client!.fiscalAdress,
      dispatchAdress: widget.client!.dispatchAdress,
      email: widget.client!.email,
      prices: widget.client!.prices,
      modified: widget.client!.modified,
      name: widget.client!.name,
      id: widget.client!.id,
      prospect: widget.client!.prospect,
      phone1: widget.client!.phone1,
      phone2: widget.client!.phone2,
      idType: widget.client!.idType,
      zone: widget.client!.zone,
      clientDocumentId: widget.client!.clientDocumentId,
    );

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(
          name: 'PAGO-DIRECTO',
        ),
        builder: (BuildContext context) => AddPaymentPage(
          invoiceTotal: widget.totalConverted,
          remaining: widget.totalConverted,
          subTotal: widget.subTotalConverted,
          discountPercentage: 0,
          discount: 0,
          tax: widget.ivaConverted,
          percentageTax: 16,
          client: currentClient,
          invoiceDocumentID: firebaseID,
          invoiceNumber: invoiceNumber,
          payments: const [],
          isKiosko: true,
          paymentType: paymentMethod,
        ),
      ),
    );
    setState(() {
      loading = false;
    });
  }
}
