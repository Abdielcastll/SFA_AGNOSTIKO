// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/diary/visits/components/visit_card.dart';

class VisitsOnProcess extends StatelessWidget {
  const VisitsOnProcess({
    Key? key,
    required this.onProcessList,
  }) : super(key: key);

  final List onProcessList;

  @override
  Widget build(BuildContext context) {
    print('cantidad en proceso: ${onProcessList.length}');
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
                  itemCount: onProcessList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final client = onProcessList[index];
                    // print(client);
                    return VisitCard(
                      name: client['name'],
                      adress: client['address'],
                      hour: client['hour'],
                      date: client['date'],
                      status: client['status'],
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
