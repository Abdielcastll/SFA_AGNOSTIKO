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
  // Funcion para logearse dentro de la aplicacion
  Future signIn({email, password, context}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim().toLowerCase(),
        password: password.text.trim(),
      );
      Navigator.pushReplacementNamed(context, 'product');
      print('Login exitoso');
    } catch (e) {
      print(e);
    }
  }

  // Funcion para deslogearse dentro de la aplicacion
  Future signOut(context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, 'login');
      print('Logout exitoso');
    } catch (e) {
      print(e);
    }
  }
}

// UserHelper de prueba, no se usa dentro de la app principal porque se usan
// usuarios pre-establecidos - Posee funciones para usos futuros de
// los modulos futuros que usan colecciones dentro de usuarios.
// TODO: Investigar mas sobre el uso de colecciones dentro de usuarios

// class UserHelper {
//   static FirebaseFirestore _db = FirebaseFirestore.instance;

//   static saveUser(User user) async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     Map<String, dynamic> userData = {
//       'active': true,
//       'email': user.email,
//       'esGerente': false,
//       'esVendedor': true,
//       'idRol': '',
//       'indice': '',
//       'nombre': '',
//       'nro_ci': '',
//       'password': '',
//       'rol': '',
//       'zona': '',
//       // 'last login': user.metadata.lastSignInTime.millisecondsSinceEpoch,
//       // 'created at': user.metadata.creationTime.millisecondsSinceEpoch,
//       // 'build_number': buildNumber,
//     };

//     final userRef = _db.collection('users').doc(user.uid);

//     if ((await userRef.get()).exists) {
//       await userRef.update({
//         // 'last login': user.metadata.lastSignInTime.millisecondsSinceEpoch,
//         // 'build_number': buildNumber,
//       });
//     } else {
//       await userRef.set(userData);
//     }
//     await _saveDevice(user);
//   }

//   static _saveDevice(User user) async {
//     DeviceInfoPlugin devicePlugin = DeviceInfoPlugin();
//     String? deviceId;

//     Map<String, dynamic> deviceData;
//     if (Platform.isAndroid) {
//       final deviceInfo = await devicePlugin.androidInfo;
//       deviceId = deviceInfo.androidId;
//       deviceData = {
//         'os_version': deviceInfo.version.sdkInt.toString(),
//         'plaftorm': 'Android',
//         'model': deviceInfo.model,
//         'device': deviceInfo.device,
//       };
//     }
//     if (Platform.isIOS) {
//       final deviceInfo = await devicePlugin.iosInfo;
//       deviceId = deviceInfo.identifierForVendor;
//       deviceData = {
//         'os_version': deviceInfo.systemVersion,
//         'plaftorm': 'IOS',
//         'model': deviceInfo.model,
//         'device': deviceInfo.name,
//       };
//     }
//     final nowMs = DateTime.now().millisecondsSinceEpoch;

//     final deviceRef = _db
//         .collection('users')
//         .doc(user.uid)
//         .collection('devices')
//         .doc(deviceId);
//     if ((await deviceRef.get()).exists) {
//       await deviceRef.update({
//         'updated_at': nowMs,
//         'unistalled:': false,
//       });
//     } else {
//       await deviceRef.set({
//         'created_at': nowMs,
//         'updated_at': nowMs,
//         'unistalled:': false,
//         'id': deviceId,
//         // 'device_info': deviceData,
//       });
//     }
//   }
// }
