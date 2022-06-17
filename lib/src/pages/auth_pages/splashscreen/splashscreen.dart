//Flutter
import 'dart:async';
import 'package:flutter/material.dart';
//Firebase
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  splashScreenTimer() {
    Timer(
      const Duration(seconds: 2),
      () async {
        if (FirebaseAuth.instance.currentUser != null) {
          // User is signed in
          print('Usuario ya logeado, redireccionando a Home');
          Navigator.pushReplacementNamed(context, 'navi');
        } else {
          // User is not signed in
          print('No hay usuario logeado, redireccionando a Login');
          Navigator.pushReplacementNamed(context, 'login');
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    splashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF4f42ed),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset('assets/images/logo.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'SFA Agnostiko',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
