// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pwa_sales2go_flutter/src/pages/users_and_teams/teams/teams_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/users_and_teams/users/users_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_users_and_teams.dart';

class UsersAndTeamsPage extends StatelessWidget {
  const UsersAndTeamsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBarUsersAndTeams(),
        body: UsersAndTeamsBody(),
      ),
    );
  }
}

class UsersAndTeamsBody extends StatelessWidget {
  const UsersAndTeamsBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBarView(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          TeamsPage(),
          UsersPage(),
        ],
      ),
    );
  }
}
