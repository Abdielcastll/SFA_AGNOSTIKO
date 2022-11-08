// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/teams_model.dart';
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
  }) : super(key: key);

  final String? charge;
  final String? name;
  final String? email;

  @override
  State<ListTileOptions> createState() => _ListTileOptionsState();
}

class _ListTileOptionsState extends State<ListTileOptions> {
  final String? currentCoin = sharedPreferences!.getString('currentCoin');

  @override
  Widget build(BuildContext context) {
    final zoneSummary = Provider.of<ZoneSummary?>(context)!.summary ?? [];
    final userDoc = Provider.of<CurrentUserInfo?>(context);
    // final currentUserTeam = Provider.of<TeamsModel?>(context) ?? {};
    // print(currentUserTeam);
    // print(userDoc!.zone);
    // print(zoneSummary);

    identifyZone() {
      if (userDoc!.zone == null) {
        return "No hay zona disponible";
      } else {
        print(zoneSummary[userDoc.zone]);
        return zoneSummary[userDoc.zone];
      }
    }

    String? selectedValue;
    bool isAdmin;

    if (currentCoin == 'VED') {
      selectedValue = 'Bolivares (VED - Bs)';
    } else if (currentCoin == 'EUR') {
      selectedValue = 'Euros (EUR - €)';
    } else if (currentCoin == 'BTC') {
      selectedValue = 'Bitcoin (BTC - ฿)';
    } else if (currentCoin == 'USD') {
      selectedValue = 'Dolares (USD - \$)';
    }

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
            //Funcion para abrir dialog que muere zona de ventas y gerente
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
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
                    content: Container(
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
                  // Redireccion a Usuarios y equipos
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsersAndTeamsPage(),
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
            //Funcion para bottom Sheet menu para cambiar nombr
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
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
                    content: Container(
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
            // Funcion que redigire a las notificaciones del usuario
            Navigator.pushNamed(context, 'notifications');
          },
          icon: MaterialCommunityIcons.bell_outline,
        ),
        ListTileProfile(
          title: AppLocalizations.of(context)!.changeCurrency,
          sub: AppLocalizations.of(context)!.changeCurrencyDesc,
          function: () {
            // Funcion que redigire a las notificaciones del usuario
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    List? items = [
                      'Dolares (USD - \$)',
                      'Bolivares (VED - Bs)',
                      'Euros (EUR - €)',
                      'Bitcoin (BTC - ฿)',
                    ];
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        'Cambiar Moneda',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: myTheme.colorScheme.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  hint: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "$selectedValue",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: myTheme.colorScheme.primary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: items
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    myTheme.colorScheme.primary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        selectedValue = value as String;
                                        // 'Dolares (USD - \$)',
                                        // 'Bolivares (VED - Bs)',
                                        // 'Euros (EUR - €)',
                                        // 'Bitcoin (BTC - ฿)',
                                        if (value.toString().contains('\$')) {
                                          print('Cambio de moneda a: USD');
                                          // selectedValue = 'USD';
                                        } else if (value
                                            .toString()
                                            .contains('Bs')) {
                                          print('Cambio de moneda a: BS');
                                          // selectedValue = 'VED';
                                        } else if (value
                                            .toString()
                                            .contains('€')) {
                                          print('Cambio de moneda a: EUR');
                                          // selectedValue = 'EUR';
                                        } else if (value
                                            .toString()
                                            .contains('฿')) {
                                          print('Cambio de moneda a: BTC');
                                          // selectedValue = 'BTC';
                                        }
                                      },
                                    );
                                    // Mover la funcion en la base de datos para cambiar la lista
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 11,
                                  iconEnabledColor: myTheme.colorScheme.primary
                                      .withOpacity(0.5),
                                  iconDisabledColor: Colors.grey,
                                  buttonHeight: 50,
                                  buttonWidth: 200,
                                  buttonPadding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: myTheme.colorScheme.primary
                                          .withOpacity(0.3),
                                    ),
                                    color: Colors.white,
                                  ),
                                  buttonElevation: 0,
                                  itemHeight: 40,
                                  itemPadding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  dropdownMaxHeight: 200,
                                  dropdownWidth: 200,
                                  dropdownPadding: null,
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  dropdownElevation: 8,
                                  scrollbarRadius: const Radius.circular(10),
                                  scrollbarThickness: 6,
                                  scrollbarAlwaysShow: true,
                                  offset: const Offset(-20, 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Regresar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Aceptar'),
                          onPressed: () {
                            // 'Dolares (USD - \$)',
                            // 'Bolivares (VED - Bs)',
                            // 'Euros (EUR - €)',
                            // 'Bitcoin (BTC - ฿)',
                            if (selectedValue.toString().contains('\$')) {
                              print('Cambio de moneda a: USD');
                              sharedPreferences?.setString(
                                  'currentCoin', 'USD');
                              Navigator.pop(context);
                            } else if (selectedValue
                                .toString()
                                .contains('Bs')) {
                              print('Cambio de moneda a: Bolivares');
                              sharedPreferences?.setString(
                                  'currentCoin', 'VED');
                              Navigator.pop(context);
                            } else if (selectedValue.toString().contains('€')) {
                              print('Cambio de moneda a: Euro');
                              sharedPreferences?.setString(
                                  'currentCoin', 'EUR');
                              Navigator.pop(context);
                            } else if (selectedValue.toString().contains('฿')) {
                              print('Cambio de moneda a: Bitcoin');
                              sharedPreferences?.setString(
                                  'currentCoin', 'BTC');
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    );
                  });
                });
          },
          icon: Icons.monetization_on,
        ),
        ListTileProfile(
          title: AppLocalizations.of(context)!.help,
          sub: AppLocalizations.of(context)!.helpDesc,
          function: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
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
                    content: Container(
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
