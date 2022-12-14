// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/models/visit_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visits_completed.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/visits/components/visits_on_process.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/loading/loading_widget.dart';
import 'package:pwa_sales2go_flutter/src/widgets/visits_alerts_and_dialogs/create_client_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    return
        // StreamProvider<List<Visits>>.value(
        //   value: FirebaseFirestore.instance
        //       .collection('usuarios')
        //       .doc(user?.uid)
        //       .collection('visitas')
        //       .orderBy('fecha', descending: true)
        //       .snapshots()
        //       .map(visitsFromSnasphot),
        //   initialData: const [],
        //   catchError: (context, error) {
        //     // print(error);
        //     return [];
        //   },
        //   child:
        SafeArea(
      child: Scaffold(
        backgroundColor: myTheme.colorScheme.surface,
        // floatingActionButton: Wrap(
        //   direction: Axis.vertical,
        //   children: [
        //     Container(
        //       margin: EdgeInsets.all(10.0),
        //       child: FloatingActionButton(
        //         elevation: 0,
        //         backgroundColor: myTheme.colorScheme.primary,
        //         onPressed: () {
        //           // ShowDialog de a;adir visita
        //           showCreateClientDialog(context, user?.uid);
        //         },
        //         child: Icon(
        //           MaterialCommunityIcons.calendar_plus,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        body: VisitsBody(),
      ),
    );
    // );
  }
}

class VisitsBody extends StatefulWidget {
  const VisitsBody({
    Key? key,
  }) : super(key: key);

  @override
  State<VisitsBody> createState() => _VisitsBodyState();
}

class _VisitsBodyState extends State<VisitsBody> {
  bool seeCompleted = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: CircularProgressIndicator(),
      ),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
      //       children: [
      //         Container(
      //           width: 120,
      //           margin: const EdgeInsets.fromLTRB(16, 10, 0, 10),
      //           child: Text(
      //             seeCompleted == true
      //                 ? AppLocalizations.of(context)!.completed
      //                 : AppLocalizations.of(context)!.onProcess,
      //             textAlign: TextAlign.start,
      //             style: TextStyle(
      //               color: seeCompleted == true
      //                   ? Colors.green.shade600
      //                   : Colors.amber.shade600,
      //               fontSize: 15,
      //               fontWeight: FontWeight.bold,
      //               fontFamily: 'Poppins-regular',
      //             ),
      //           ),
      //         ),
      //         Container(
      //           margin: const EdgeInsets.fromLTRB(30, 0, 0, 0),
      //           child: Text(
      //             'Ver completados',
      //             style: TextStyle(
      //               fontSize: 15,
      //               // fontWeight: FontWeight.bold,
      //               fontFamily: 'Poppins-regular',
      //             ),
      //           ),
      //         ),
      //         Checkbox(
      //           activeColor: myTheme.colorScheme.primary,
      //           value: seeCompleted,
      //           onChanged: (value) {
      //             setState(() {
      //               seeCompleted = !seeCompleted;
      //             });
      //           },
      //         ),
      //       ],
      //     ),
      //     seeCompleted == false ? VisitsOnProcess() : VisitsCompleted(),
      //   ],
      // ),
    );
  }
}
