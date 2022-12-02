import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/visit_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visit_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            element.isCancelled == false && element.isCompleted == false)
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Scrollbar(
            child: ListView.builder(
              // physics: const BouncingScrollPhysics(),
              itemCount: visitsOnProcess.length,
              itemBuilder: (BuildContext context, int index) {
                final visit = visitsOnProcess[index];
                final unformattedDate =
                    visit.date ?? Timestamp.fromDate(DateTime.now());
                final visitStatus = AppLocalizations.of(context)!.onProcess;
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
