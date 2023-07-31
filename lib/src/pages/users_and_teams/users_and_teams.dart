import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/users_and_teams/teams/teams_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/users_and_teams/users/users_page.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_users_and_teams.dart';

class UsersAndTeamsPage extends StatelessWidget {
  const UsersAndTeamsPage({Key? key, required this.userZoneDocument})
      : super(key: key);

  final userZoneDocument;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: const AppBarUsersAndTeams(),
        body: UsersAndTeamsBody(userZoneDocument: userZoneDocument),
      ),
    );
  }
}

class UsersAndTeamsBody extends StatelessWidget {
  const UsersAndTeamsBody({Key? key, required this.userZoneDocument})
      : super(key: key);

  final userZoneDocument;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBarView(
        children: [
          const TeamsPage(),
          UsersPage(userZoneDocument: userZoneDocument),
        ],
      ),
    );
  }
}
