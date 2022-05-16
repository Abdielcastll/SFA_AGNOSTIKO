import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar_offline.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBarOffline(),
      ),
      body: Center(
        child: Text('Login'),
      ),
    );
  }
}
