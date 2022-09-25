// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/visit_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visit_card.dart';

class VisitsOnProcess extends StatelessWidget {
  const VisitsOnProcess({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visits = Provider.of<List<Visits>?>(context) ?? [];
    var dateFormatter = DateFormat('yyyy-MM-dd');

    final visitsOnProcess = visits
        .where((element) =>
            element.isCancelled == false || element.isCompleted == false)
        .toList();

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
                  itemCount: visitsOnProcess.length,
                  itemBuilder: (BuildContext context, int index) {
                    final visit = visitsOnProcess[index];
                    final visitClientDocumentId =
                        visit.clientReferenceId ?? 'NaN';
                    final unformattedDate = visit.date ?? 'NaN';
                    final visitStatus = 'En proceso';
                    final date =
                        DateTime.parse(unformattedDate.toDate().toString());
                    final visitDate = dateFormatter.format(date);
                    final visitCommentary = visit.commentary;
                    // print(unFormattedDate);
                    // print(date);
                    // print(visitDate);
                    // print(client);
                    return VisitCard(
                      visitClientDocumentId: visitClientDocumentId,
                      date: visitDate,
                      status: visitStatus,
                      commentary: visitCommentary,
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
