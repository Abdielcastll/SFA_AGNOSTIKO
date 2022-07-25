// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/diary/invoices/widgets/invoice_card.dart';

class InvoicesOnProcess extends StatefulWidget {
  InvoicesOnProcess({
    Key? key,
    required this.onProcessList,
  }) : super(key: key);

  final List onProcessList;

  @override
  State<InvoicesOnProcess> createState() => _InvoicesOnProcessState();
}

class _InvoicesOnProcessState extends State<InvoicesOnProcess> {
  @override
  Widget build(BuildContext context) {
    print('cantidad en proceso: ${widget.onProcessList.length}');
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  textAlign: TextAlign.start,
                  'Por Realizar',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            child: Container(
              height: 230,
              child: Scrollbar(
                child: ListView.builder(
                  // physics: BouncingScrollPhysics(),
                  itemCount: widget.onProcessList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final invoice = widget.onProcessList[index];
                    // print(invoice);
                    return InvoiceCard(
                      name: invoice['nombre'] ?? 'No name',
                      orderId: invoice['orderID'] ?? 'No id',
                      date: invoice['date'] ?? 'No date',
                      total: invoice['total'] ?? 'no total',
                      completed: invoice['pagada'] ?? false,
                      salesman: invoice['salesman'] ?? 'no salesman',
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
