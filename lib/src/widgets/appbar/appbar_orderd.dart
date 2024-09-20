// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppBarOrder extends StatelessWidget implements PreferredSizeWidget {
  const AppBarOrder({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return AppBar(
      foregroundColor: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     bottom: Radius.circular(20),
      //   ),
      // ),
      actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    actionsOverflowButtonSpacing: 1,
                    actionsPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              '¿Desea cancelar esta orden?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    themeProvider.myTheme.colorScheme.primary,
                                fontFamily: 'Poppins-regular',
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                themeProvider.myTheme.colorScheme.primary,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            child: Text(
                              'No',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final orderActive = Provider.of<OrderProvider>(
                                  context,
                                  listen: false);
                              objectBox.delelteAllShoppingCart();
                              orderActive.setOrder(false);
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                themeProvider
                                    .myTheme.colorScheme.onPrimaryContainer,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            child: Text(
                              'Si',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins-regular',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
          },
          splashRadius: 20.0,
          icon: const Icon(
            Icons.delete,
            size: 24,
            color: Color.fromARGB(255, 196, 196, 196),
          ),
        )
      ],
      automaticallyImplyLeading: false,
      title: Text(
        AppLocalizations.of(context)!.order,
        style: TextStyle(
          fontFamily: 'Poppins-Regular',
          fontSize: 21,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
      ),
      backgroundColor: themeProvider.myTheme.colorScheme.primary,
      elevation: 0,
    );
  }
}
