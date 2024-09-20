//Flutter
// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  splashScreenTimer() {
    Timer(const Duration(seconds: 3), () {
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
                padding: EdgeInsets.all(12.0),
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(height: 20),
              Text(
                'Field Sales',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.white,
                  fontFamily: 'Poppins-Bold',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
