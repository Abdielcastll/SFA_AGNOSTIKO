// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/users_and_teams/users_and_teams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListTileOptions extends StatefulWidget {
  const ListTileOptions({
    Key? key,
    this.charge,
    this.name,
    this.email,
    required this.userZoneDocument,
  }) : super(key: key);

  final String? charge;
  final String? name;
  final String? email;
  final userZoneDocument;

  @override
  State<ListTileOptions> createState() => _ListTileOptionsState();
}

class _ListTileOptionsState extends State<ListTileOptions> {
  @override
  Widget build(BuildContext context) {
    final zoneSummary = Provider.of<ZoneSummary?>(context)!.summary ?? [];
    final userZone = Provider.of<CurrentUserInfo?>(context)?.zone ?? {};

    identifyZone() {
      if (userZone == '') {
        return "No hay zona disponible";
      } else {
        return zoneSummary[userZone];
      }
    }

    bool isAdmin;

    if (widget.charge == 'Administrador') {
      isAdmin = true;
    } else {
      isAdmin = false;
    }
    return Column(
      children: [
        ListTileProfile(
          title: AppLocalizations.of(context)!.salesArea,
          sub: AppLocalizations.of(context)!.salesAreaDesc,
          function: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Zona de Ventas',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: SizedBox(
                      height: 50,
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            identifyZone(),
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Gerente: ',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: myTheme.colorScheme.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Ana Avila',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: myTheme.colorScheme.secondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          icon: MaterialIcons.map,
        ),
        isAdmin
            ? ListTileProfile(
                title: AppLocalizations.of(context)!.usersAndTeams,
                sub: AppLocalizations.of(context)!.usersAndTeamsDesc,
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsersAndTeamsPage(
                          userZoneDocument: widget.userZoneDocument),
                    ),
                  );
                },
                icon: Icons.people_alt_outlined,
              )
            : Container(),
        ListTileProfile(
          title: AppLocalizations.of(context)!.account,
          sub: AppLocalizations.of(context)!.accountDesc,
          function: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Informacion de este usuario',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: SizedBox(
                      height: 100,
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre: ${widget.name} ',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Email: ${widget.email}',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Cargo: ${widget.charge}',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          icon: MaterialIcons.mail_outline,
        ),
        ListTileProfile(
          title: AppLocalizations.of(context)!.notifications,
          sub: AppLocalizations.of(context)!.notificationsDesc,
          function: () {
            Navigator.pushNamed(context, 'notifications');
          },
          icon: MaterialCommunityIcons.bell_outline,
        ),
        ListTileProfile(
          title: AppLocalizations.of(context)!.help,
          sub: AppLocalizations.of(context)!.helpDesc,
          function: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Informacion de Soporte al usuario',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: SizedBox(
                      height: 150,
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Si necesita ayuda con algun lado de la aplicacion, comunicarse al:',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '731XXX000 EXT 000 ',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Email:',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'examplesupport@email.com',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          icon: MaterialIcons.info_outline,
        ),
      ],
    );
  }
}

class ListTileProfile extends StatelessWidget {
  const ListTileProfile({
    Key? key,
    this.function,
    required this.title,
    required this.sub,
    required this.icon,
  }) : super(key: key);

  final function;
  final String title;
  final String sub;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: ListTile(
        leading: Container(
          child: Icon(
            icon,
            color: myTheme.colorScheme.secondary,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: myTheme.colorScheme.secondary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          sub,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: Colors.grey.shade500,
            fontSize: 12,
          ),
        ),
        onTap: function,
      ),
    );
  }
}
