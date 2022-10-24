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
import 'package:pwa_sales2go_flutter/src/widgets/visits_alerts_and_dialogs/create_client_dialog.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({Key? key}) : super(key: key);

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    return StreamProvider<List<Visits>>.value(
      value: FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user?.uid)
          .collection('visitas')
          .snapshots()
          .map(visitsFromSnasphot),
      initialData: const [],
      catchError: (context, error) {
        print(error);
        return [];
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          floatingActionButton: Wrap(
            direction: Axis.vertical,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: myTheme.colorScheme.primary,
                  onPressed: () {
                    // ShowDialog de a;adir visita
                    showCreateClientDialog(context, user?.uid);
                  },
                  child: Icon(
                    MaterialCommunityIcons.calendar_plus,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: VisitsBody(),
        ),
      ),
    );
  }
}

class VisitsBody extends StatelessWidget {
  const VisitsBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          VisitsOnProcess(),
          VisitsCompleted(),
        ],
      ),
    );
  }
}
