import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pwa_sales2go_flutter/src/utils/utils.dart';

class AuthHelper {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static signIn({
    required String email,
    required String password,
    context,
  }) async {
    final res = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Navigator.pushReplacementNamed(context, 'product');
    final User? user = res.user;
    return user;
  }

  static signOut(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    _auth.signOut();
    Navigator.pushReplacementNamed(context, 'login');
    print('Logout exitoso');
  }
}
