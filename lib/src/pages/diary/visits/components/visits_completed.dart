import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/visit_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visit_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class VisitsCompleted extends StatefulWidget {
  const VisitsCompleted({
    Key? key,
  }) : super(key: key);

  @override
  State<VisitsCompleted> createState() => _VisitsCompletedState();
}

class _VisitsCompletedState extends State<VisitsCompleted> {
  bool isDescending = false;
  DateTime today = DateTime.now();
  var dateFormatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final visits = Provider.of<List<Visits>?>(context) ?? [];
    final currentDay =
        Provider.of<CounterLimitFirestore>(context).currentDayVisits;
    final currentDateTime = currentDay?.toDate();
    String formattedDate =
        dateFormatter.format(currentDateTime ?? DateTime.now());

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
              const SizedBox(width: 20),
              Container(
                height: 40,
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: myTheme.colorScheme.secondary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(currentDay !=
                            Timestamp.fromDate(DateTime(
                              DateTime.now().year + 99,
                              DateTime.now().month + 99,
                              DateTime.now().day + 99,
                              0,
                              0,
                              0,
                              0,
                              0,
                            ))
                        ? formattedDate
                        : 'Todos'),
                    IconButton(
                      onPressed: () async {
                        final currentDayProvider =
                            Provider.of<CounterLimitFirestore>(context,
                                listen: false);

                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2030),
                        );
                        if (newDate == null) {
                          return;
                        }
                        setState(() {
                          today = newDate;
                          formattedDate = dateFormatter.format(newDate);
                          final newDay = Timestamp.fromDate(newDate);
                          currentDayProvider.setNewDayVisits(newDay);
                        });
                      },
                      splashRadius: 5,
                      icon: Icon(
                        Icons.calendar_month,
                        color: myTheme.colorScheme.primary.withOpacity(0.8),
                        size: 20,
                      ),
                    ),
                    Container(
                      width: 40,
                      child: IconButton(
                        onPressed: () {
                          final currentDayProvider =
                              Provider.of<CounterLimitFirestore>(context,
                                  listen: false);
                          setState(() {
                            currentDayProvider
                                .setNewDayVisits(Timestamp.fromDate(DateTime(
                              DateTime.now().year + 99,
                              DateTime.now().month + 99,
                              DateTime.now().day + 99,
                              0,
                              0,
                              0,
                              0,
                              0,
                            )));
                          });
                        },
                        icon: Icon(
                          Icons.disabled_by_default_outlined,
                          color: myTheme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        visitsCompleted.isNotEmpty
            ? Container(
                height: MediaQuery.of(context).size.height * 0.52,
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
              )
            : Container(
                margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: Image.asset(
                        'assets/images/nodiary.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      // color: Colors.green,
                      // height: 150,
                      // margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          'No hay visitas este día',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14,
                            color: myTheme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
