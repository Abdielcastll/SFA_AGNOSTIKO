// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/users_and_teams/users_and_teams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class AppBarUsersAndTeams extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarUsersAndTeams({
    Key? key,
  }) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Usuarios y Equipos',
        style: const TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w300,
          fontFamily: 'Poppins-regular',
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: myTheme.colorScheme.primary,
      bottom: UsersAndTeamsTabBar(),
    );
  }
}

class UsersAndTeamsTabBar extends StatelessWidget
    implements PreferredSizeWidget {
  const UsersAndTeamsTabBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      splashBorderRadius: BorderRadius.circular(20),
      splashFactory: InkSplash.splashFactory,
      labelColor: Colors.white,
      indicatorColor: Colors.white,
      unselectedLabelColor: Colors.grey.shade400,
      indicatorWeight: 3,
      indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: const [
        Tab(
          text: 'Equipos',
        ),
        Tab(
          text: 'Usuarios',
        )
      ],
    );
  }
}
