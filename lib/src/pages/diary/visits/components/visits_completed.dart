// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/visit_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visit_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VisitsCompleted extends StatelessWidget {
  const VisitsCompleted({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final visits = Provider.of<List<Visits>?>(context) ?? [];
    var dateFormatter = DateFormat('yyyy-MM-dd');

    final visitsCompleted = visits
        .where((element) =>
            element.isCancelled == true || element.isCompleted == true)
        .toList();
    // print('Visitas completadas o canceladas: ${visitsCompleted.length}');

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
                padding: EdgeInsets.only(left: 16, top: 5),
                child: Text(
                  textAlign: TextAlign.start,
                  AppLocalizations.of(context)!.completed,
                  style: TextStyle(
                    color: Colors.green,
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
                  physics: ClampingScrollPhysics(),
                  itemCount: visitsCompleted.length,
                  itemBuilder: (BuildContext context, int index) {
                    final visit = visitsCompleted[index];
                    final unformattedDate =
                        visit.date ?? Timestamp.fromDate(DateTime.now());
                    final visitStatus =
                        visit.isCompleted == true ? 'Completada' : 'Cancelada';
                    final date =
                        DateTime.parse(unformattedDate.toDate().toString());
                    final visitDate = dateFormatter.format(date);
                    final visitCommentary =
                        visit.commentary ?? 'No hay Comentario disponible';
                    final clientDocID = visit.clientReferenceId;
                    final visitDocID = visit.documentRefId;
                    // print(unFormattedDate);
                    // print(date);
                    // print(visitDate);
                    // print(client);
                    return VisitCard(
                      visitDocumentId: visitDocID,
                      date: visitDate,
                      status: visitStatus,
                      commentary: visitCommentary,
                      clientReferenceId: clientDocID,
                    );
                  },
                ),
              ),
            ),
          ),
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.7,
          //   child: ListView.builder(
          //     physics: BouncingScrollPhysics(),
          //     itemCount: completedList.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       final client = completedList[index];
          //       // print(client);
          //       return VisitCard(
          //         name: client['name'],
          //         adress: client['address'],
          //         hour: client['hour'],
          //         date: client['date'],
          //         status: client['status'],
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
