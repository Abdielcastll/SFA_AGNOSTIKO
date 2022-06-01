import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/home_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/login_page.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({Key? key}) : super(key: key);

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  splashScreenTimer() {
    Timer(
      const Duration(seconds: 3),
      () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // called automatically when user comes to this screen
    // This is the first method called when the widget is created.
    super.initState();
    splashScreenTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4f42ed),
              Color.fromARGB(255, 130, 32, 147),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
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
