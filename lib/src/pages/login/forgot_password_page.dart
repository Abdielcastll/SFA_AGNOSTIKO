import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/bottom_decoration.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reinicio de contraseña'),
        // centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF4f42ed),
      ),
      bottomNavigationBar: const BottomDecoration(),
      backgroundColor: Colors.white,
      body: forgotPasswordPageBody(),
    );
  }

  Widget forgotPasswordPageBody() {
    return Container();
  }
}
