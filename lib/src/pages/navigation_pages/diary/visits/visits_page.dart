// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/examples/example_visit_list.dart';

import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/diary/visits/components/filter_visits.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/diary/visits/components/visits_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/diary/visits/components/visits_on_process.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  @override
  Widget build(BuildContext context) {
    final listExample = visitsList;
    List onProcess = [];
    List completed = [];
    for (var i = 0; i < listExample.length; i++) {
      if (listExample[i]['status'] == 'On process') {
        onProcess.add(listExample[i]);
      } else if (listExample[i]['status'] == 'Completed' ||
          listExample[i]['status'] == 'Cancelled') {
        completed.add(listExample[i]);
      }
      // print(cancelled);
    }
    print('pantalla visitas activa');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterSection(),
              SizedBox(height: 10),
              VisitsOnProcess(onProcessList: onProcess),
              VisitsList(completedList: completed),
            ],
          ),
        ),
      ),
    );
  }
}
