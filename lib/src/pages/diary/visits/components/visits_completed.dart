import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/visit_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visit_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class VisitsCompleted extends StatefulWidget {
  const VisitsCompleted({
    Key? key,
    required this.isDescending,
  }) : super(key: key);

  final bool isDescending;

  @override
  State<VisitsCompleted> createState() => _VisitsCompletedState();
}

class _VisitsCompletedState extends State<VisitsCompleted> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var dateFormatter = DateFormat('dd-MM-yyyy');
    final visits = Provider.of<List<Visits>?>(context) ?? [];
    final visitsCompleted = visits
        .where((element) =>
            element.isCancelled == true || element.isCompleted == true)
        .toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        visitsCompleted.isNotEmpty
            ? Container(
                height: MediaQuery.of(context).size.height * 0.52,
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: visitsCompleted.length,
                    itemBuilder: (BuildContext context, int index) {
                      final sortedVisits = widget.isDescending
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
              )
            : Container(
                margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: Column(
                  children: [
                    if (_isLoading) ...[
                      Center(child: const CircularProgressIndicator()),
                    ] else ...[
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                // Colors.red.withOpacity(0.3)),
                                myTheme.colorScheme.primary.withOpacity(0.3)),
                        width: 120,
                        height: 120,
                        child: Opacity(
                          opacity: 0.8,
                          child: Icon(
                            MaterialCommunityIcons.truck_fast,
                            color: myTheme.colorScheme.onPrimaryContainer,
                            size: 60,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Center(
                          child: Container(
                            width: 250,
                            child: Text(
                              'No hay visitas registradas este día',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins-medium',
                                fontSize: 12,
                                color: myTheme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ],
    );
  }
}
