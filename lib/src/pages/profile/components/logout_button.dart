import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/login/email_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/login/login_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: 160,
        height: 38,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ElevatedButton.icon(
            onPressed: () async {
              final j =
                  Provider.of<CounterLimitFirestore>(context, listen: false);
              j.setNewScreen(0);
              final orderActive =
                  Provider.of<OrderProvider>(context, listen: false);
              objectBox.delelteAllShoppingCart();
              orderActive.setOrder(false);
              _auth.signOut();
              //await sharedPreferences!.setString('tenantEmail', '');
            },
            icon: const Icon(
              MaterialCommunityIcons.logout,
              color: Colors.red,
            ),
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 252, 159, 159).withOpacity(0.3),
              ),
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.red.withOpacity(0.3)),
            ),
            label: Text(
              AppLocalizations.of(context)!.logOut,
              style: const TextStyle(
                color: Colors.red,
                fontFamily: 'Poppins-Regular',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
