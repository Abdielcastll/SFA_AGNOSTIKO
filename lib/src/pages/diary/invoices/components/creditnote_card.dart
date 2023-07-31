// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';

class CreditNoteCard extends StatefulWidget {
  const CreditNoteCard({
    Key? key,
    this.creditNoteClient,
    this.creditNoteOrder,
    this.creditNoteDate,
    this.creditNoteBalance,
    this.creditNotePayments,
    this.creditNoteNumber,
    this.creditNoteTotal,
    this.creditNoteIsValid,
    this.creditNoteIsEliminated,
  }) : super(key: key);

  final creditNoteClient;
  final creditNoteOrder;
  final creditNoteDate;
  final creditNoteBalance;
  final creditNoteIsValid;
  final creditNoteIsEliminated;
  final creditNotePayments;
  final creditNoteNumber;
  final creditNoteTotal;

  @override
  State<CreditNoteCard> createState() => _CreditNoteCardState();
}

class _CreditNoteCardState extends State<CreditNoteCard> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      StreamProvider<Client?>.value(
        initialData: null,
        value: clientesRef
            .doc(widget.creditNoteClient)
            .snapshots()
            .map(Client.fromSnapshot),
        catchError: (context, error) {
          print(error);
          return;
        },
      ),
      StreamProvider<ZoneSummary?>.value(
        initialData: null,
        value: DatabaseServiceStreams().zoneSummary,
      ),
    ], child: CreditCardBody(widget: widget));
  }
}

class CreditCardBody extends StatefulWidget {
  const CreditCardBody({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final CreditNoteCard widget;

  @override
  State<CreditCardBody> createState() => _CreditCardBodyState();
}

class _CreditCardBodyState extends State<CreditCardBody> {
  String? creditNoteStatus;

  void identifyStatus() {
    if (widget.widget.creditNoteIsValid == true &&
        widget.widget.creditNoteIsEliminated == false) {
      creditNoteStatus = 'En proceso';
    } else if (widget.widget.creditNoteIsValid == true &&
        widget.widget.creditNoteIsEliminated == true) {
      creditNoteStatus = 'Eliminado';
    } else if (widget.widget.creditNoteIsValid == false &&
        widget.widget.creditNoteIsEliminated == false) {
      creditNoteStatus = 'Pagado';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    identifyStatus();
  }

  @override
  Widget build(BuildContext context) {
    Color? identifyColor() {
      if (creditNoteStatus == 'En Proceso') {
        return Colors.amber;
      } else if (creditNoteStatus == 'Eliminado') {
        return Colors.red;
      } else if (creditNoteStatus == 'Pagado') {
        return Colors.green;
      }
      return null;
    }

    //   var sumOfValidPayments = paymentsValidPay.fold(0, (i, element) {
    //   return i + element['monto'];
    // });
    // print(sumOfValidPayments);
    // final remaining = invoiceTotal - sumOfValidPayments;
    // final leftoverAmount;
    // if (remaining < 0) {
    //   leftoverAmount = 0.00;
    // } else {
    //   leftoverAmount = remaining;
    // }

    final currentClientName = Provider.of<Client?>(context)?.name ?? 'NaN';

    return Padding(
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
                    // '\$${widget.widget.creditNoteBalance}',
                    '000',
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
                      'NC #${widget.widget.creditNoteNumber}',
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
                      'Saldo: ',
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
                      '$creditNoteStatus',
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
    );
  }
}
