// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/teams_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/users_and_teams/users_and_teams.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../services/firebase_collections.dart';

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
  @override
  Widget build(BuildContext context) {
    final zoneSummary = Provider.of<ZoneSummary?>(context)!.summary ?? [];
    final userZone = Provider.of<CurrentUserInfo?>(context)?.zone ?? {};

    final currentCoin = Provider.of<CurrencyProvider>(context);

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
          title: AppLocalizations.of(context)!.changeCurrency,
          sub: AppLocalizations.of(context)!.changeCurrencyDesc,
          function: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StreamProvider<List<Coin>?>.value(
                      value:
                          coinCollection.snapshots().map(coinListfromSnapshot),
                      initialData: const [],
                      catchError: (context, error) {
                        return;
                      },
                      builder: (context, snapshot) {
                        String? selectedValue;

                        final coins = Provider.of<List<Coin>?>(context) ?? [];
                        List? coinList = [];
                        Map<String, dynamic>? coinExchangeList =
                            <String, dynamic>{'USD': 1};
                        //
                        coinList.add('Dolares - USD');
                        coins.map((coin) {
                          coinList.add(
                              '${coin.name} - ${coin.code} (${coin.symbol})');
                          final exchangeRate = <String, dynamic>{
                            '${coin.name} - ${coin.code} (${coin.symbol})':
                                '${coin.exchangeRatio}'
                          };
                          coinExchangeList.addEntries(exchangeRate.entries);
                        }).toList();

                        List? coinListSymbols = [];
                        coinListSymbols.add('USD');
                        coins
                            .map((coin) => coinListSymbols.add(coin.symbol))
                            .toList();
                        print(coinExchangeList);

                        return StatefulBuilder(builder: (context, setState) {
                          List? items = coinList;
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              'Cambiar Moneda',
                              style: TextStyle(
                                fontFamily: 'Poppins-regular',
                                color: myTheme.colorScheme.onPrimaryContainer,
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
                                        hint: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${currentCoin.currentCurrency}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: myTheme
                                                      .colorScheme.primary,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        items: items
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: myTheme
                                                          .colorScheme.primary,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        value: selectedValue,
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              selectedValue = value as String;
                                            },
                                          );
                                          print(
                                              '${coinExchangeList['$selectedValue']}');
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward_ios_outlined,
                                        ),
                                        iconSize: 11,
                                        iconEnabledColor: myTheme
                                            .colorScheme.primary
                                            .withOpacity(0.5),
                                        iconDisabledColor: Colors.grey,
                                        buttonHeight: 50,
                                        buttonWidth: 200,
                                        buttonPadding: const EdgeInsets.only(
                                            left: 14, right: 14),
                                        buttonDecoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        dropdownElevation: 8,
                                        scrollbarRadius:
                                            const Radius.circular(10),
                                        scrollbarThickness: 6,
                                        scrollbarAlwaysShow: true,
                                        offset: const Offset(-20, 0),
                                      ),
                                    ),
                                  ),
                                  selectedValue?.contains('USD') == false
                                      ? Column(
                                          children: [
                                            Container(
                                              child: Text(
                                                'Tasa de cambio',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  fontSize: 14,
                                                  color: myTheme
                                                      .colorScheme.secondary,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Text(
                                                '\$1 =  ${coinExchangeList['$selectedValue']}',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                  fontSize: 14,
                                                  color: myTheme
                                                      .colorScheme.secondary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(),
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
                                  final currentCoin =
                                      Provider.of<CurrencyProvider>(context,
                                          listen: false);

                                  currentCoin.setCurrentCoin(selectedValue);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        });
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
