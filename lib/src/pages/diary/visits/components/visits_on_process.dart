import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/visit_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visit_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class VisitsOnProcess extends StatefulWidget {
  const VisitsOnProcess({
    Key? key,
  }) : super(key: key);

  @override
  State<VisitsOnProcess> createState() => _VisitsOnProcessState();
}

class _VisitsOnProcessState extends State<VisitsOnProcess> {
  bool isDescending = false;
  DateTime today = DateTime.now();
  var dateFormatter = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    final visits = Provider.of<List<Visits>?>(context) ?? [];
    final currentDay =
        Provider.of<CounterLimitFirestore>(context).currentDayVisits;
    final currentDateTime = currentDay.toDate();
    String formattedDate = dateFormatter.format(currentDateTime);
    print('currentDay: $currentDay');
    print('currentDateTime: $currentDateTime');
    print('formattedDate: $formattedDate');

    final visitsOnProcess = visits
        .where((element) =>
            element.isCancelled == false && element.isCompleted == false)
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
                    Text(formattedDate),
                    IconButton(
                      onPressed: () async {
                        final currentDayProvider =
                            Provider.of<CounterLimitFirestore>(context,
                                listen: false);

                        DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: currentDay.toDate(),
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
                  ],
                ),
              ),
            ],
          ),
        ),
        visitsOnProcess.isNotEmpty
            ? Container(
                height: MediaQuery.of(context).size.height * 0.65,
                child: Scrollbar(
                  child: ListView.builder(
                    // physics: const BouncingScrollPhysics(),
                    itemCount: visitsOnProcess.length,
                    itemBuilder: (BuildContext context, int index) {
                      final sortedVisits = isDescending
                          ? visitsOnProcess.reversed.toList()
                          : visitsOnProcess;

                      final visit = sortedVisits[index];
                      final unformattedDate =
                          visit.date ?? Timestamp.fromDate(DateTime.now());
                      final visitStatus =
                          AppLocalizations.of(context)!.onProcess;
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
