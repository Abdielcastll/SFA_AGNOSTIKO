// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/examples/example_invoices_list.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/filter_invoices.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/invoice_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/invoices/components/invoices_on_process.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({Key? key}) : super(key: key);

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  @override
  Widget build(BuildContext context) {
    final listExample = invoicesList;
    List onProcess = [];
    List completed = [];
    for (var i = 0; i < listExample.length; i++) {
      if (listExample[i]['pagada'] == false) {
        onProcess.add(listExample[i]);
      } else if (listExample[i]['pagada'] == true) {
        completed.add(listExample[i]);
      }
    }
    print('pantalla facturas activa');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: InvoicesBody(onProcess: onProcess, completed: completed),
      ),
    );
  }
}

class InvoicesBody extends StatelessWidget {
  const InvoicesBody({
    Key? key,
    required this.onProcess,
    required this.completed,
  }) : super(key: key);

  final List onProcess;
  final List completed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          SizedBox(height: 10),
          InvoicesOnProcess(onProcessList: onProcess),
          InvoicesList(completedList: completed),
        ],
      ),
    );
  }
}
