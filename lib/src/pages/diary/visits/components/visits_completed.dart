import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/visit_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visit_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VisitsCompleted extends StatefulWidget {
  const VisitsCompleted({
    Key? key,
  }) : super(key: key);

  @override
  State<VisitsCompleted> createState() => _VisitsCompletedState();
}

class _VisitsCompletedState extends State<VisitsCompleted> {
  bool isDescending = false;

  @override
  Widget build(BuildContext context) {
    final visits = Provider.of<List<Visits>?>(context) ?? [];
    var dateFormatter = DateFormat('yyyy-MM-dd');

    final visitsCompleted = visits
        .where((element) =>
            element.isCancelled == true || element.isCompleted == true)
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      MaterialCommunityIcons.order_alphabetical_ascending,
                      color: Colors.grey.shade500,
                      size: 25,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isDescending
                          ? AppLocalizations.of(context)!.ascendingFilter
                          : AppLocalizations.of(context)!.descendingFilter,
                      style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onPressed: () {
                  // Re ordenar el list view alfabeticamente
                  setState(() => isDescending = !isDescending);
                },
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Scrollbar(
            child: ListView.builder(
              itemCount: visitsCompleted.length,
              itemBuilder: (BuildContext context, int index) {
                final sortedVisits = isDescending
                    ? visitsCompleted.reversed.toList()
                    : visitsCompleted;

                final visit = sortedVisits[index];

                final unformattedDate =
                    visit.date ?? Timestamp.fromDate(DateTime.now());
                final visitStatus = visit.isCompleted == true
                    ? AppLocalizations.of(context)!.completed
                    : AppLocalizations.of(context)!.canceled;
                final date =
                    DateTime.parse(unformattedDate.toDate().toString());
                final visitDate = dateFormatter.format(date);
                final visitCommentary = visit.commentary ??
                    AppLocalizations.of(context)!.commentaryUnavaliable;
                final clientDocID = visit.clientReferenceId;
                final visitDocID = visit.documentRefId;
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
      ],
    );
  }
}
