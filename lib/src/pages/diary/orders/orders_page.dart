// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/examples/example_orders_list.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/filter_orders..dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/orders_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/orders/components/orders_on_process.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final listExample = ordersList;
    List onProcess = [];
    List completed = [];
    for (var i = 0; i < listExample.length; i++) {
      if (listExample[i]['completed'] == 'true') {
        completed.add(listExample[i]);
      } else if (listExample[i]['completed'] == 'false') {
        onProcess.add(listExample[i]);
      }
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: OrdersBody(onProcess: onProcess, completed: completed),
      ),
    );
  }
}

class OrdersBody extends StatelessWidget {
  const OrdersBody({
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
        children: [
          SizedBox(height: 10),
          OrdersOnProcess(onProcessList: onProcess),
          CompletedOrders(completedList: completed),
        ],
      ),
    );
  }
}
