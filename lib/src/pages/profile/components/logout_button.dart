// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

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
            onPressed: () {
              _auth.signOut();
            },
            icon: Icon(
              MaterialCommunityIcons.logout,
              color: Colors.red,
            ),
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
              backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 252, 159, 159).withOpacity(0.3),
              ),
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.red.withOpacity(0.3)),
            ),
            label: Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Poppins-regular',
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
