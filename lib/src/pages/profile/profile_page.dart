// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/teams_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/profile/components/list_tile_options.dart';
import 'package:pwa_sales2go_flutter/src/pages/profile/components/logout_button.dart';
import 'package:pwa_sales2go_flutter/src/pages/profile/components/user_info.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:pwa_sales2go_flutter/src/widgets/powered_by_agnostiko/powered_by_agnostiko.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNavigation(
        message: AppLocalizations.of(context)!.profile,
        isOrderActive: false,
      ),
      backgroundColor: Colors.grey.shade100,
      body: ProfileBody(),
    );
  }
}

class ProfileBody extends StatefulWidget {
  const ProfileBody({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final String? userName = sharedPreferences!.getString('nombre');
  final String? charge = sharedPreferences!.getString('cargo');
  final String? uid = sharedPreferences!.getString('uid');
  final String? email = sharedPreferences!.getString('email');

  @override
  Widget build(BuildContext context) {
    final userUID = Provider.of<UserModel>(context).uid;

    print('Idioma: ${AppLocalizations.of(context)!.language}');

    return MultiProvider(
      providers: [
        StreamProvider<CurrentUserInfo?>.value(
          value: FirebaseFirestore.instance
              .collection('usuarios')
              .doc(userUID)
              .snapshots()
              .map(currentUserInfoFromSnapshot),
          initialData: null,
        ),
        StreamProvider<ZoneSummary?>.value(
          value: DatabaseServiceStreams().zoneSummary,
          initialData: ZoneSummary([]),
        ),
        // StreamProvider<TeamsModel?>.value(
        //   value: FirebaseFirestore.instance
        //       .collection('equipos')
        //       .where('vendedores',
        //           arrayContains: FirebaseFirestore.instance
        //               .collection('usuarios')
        //               .doc(userUID))
        //       .snapshots()
        //       .map((teamfromSnapshot)),
        //   initialData: null,
        //   catchError: (context, error) {
        //     print(error);
        //     return;
        //   },
        // ),
      ],
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserInfo(userName: userName, charge: charge),
            SizedBox(height: 30),
            ListTileOptions(charge: charge, name: userName, email: email),
            SizedBox(height: 15),
            LogoutButton(),
            SizedBox(height: 15),
            PoweredByAgnostiko(),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
