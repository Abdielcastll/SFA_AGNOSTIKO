//Flutter
import 'dart:async';
import 'package:flutter/material.dart';
//Firebase
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  splashScreenTimer() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, 'wrapper');
    });
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
          color: Color(0xFF2E3EAE),
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
