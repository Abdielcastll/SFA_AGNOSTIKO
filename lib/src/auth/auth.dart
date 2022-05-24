// Paquetes para obtención de información del dispositivo
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
// Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// Material
import 'package:flutter/material.dart';

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
    _auth.signOut();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    Navigator.pushReplacementNamed(context, 'login');
    print('Logout exitoso');
  }
}
