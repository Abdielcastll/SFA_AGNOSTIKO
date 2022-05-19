import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pwa_sales2go_flutter/src/utils/utils.dart';

Future signIn(
  context,
  emailController,
  passwordController,
) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim().toLowerCase(),
      password: passwordController.text.trim(),
    );
    //Una vez logeado, se redirecciona a la página productos.
    Navigator.pushReplacementNamed(context, 'product');
    // Test para ver que se esta mandando en el email y contraseña.
    print(emailController);
    print(passwordController);
  } on FirebaseAuthException catch (e) {
    print('Error en el logeo');

    Utils.showSnackBar(e.message);
  }
}

Future signOut(context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, 'login');
  } on FirebaseAuthException catch (e) {
    print('Error en el logeo');
    Utils.showSnackBar(e.message);
  }

  // navigatorKey.currentState!.popUntil((route) => route.isFirst);
}
