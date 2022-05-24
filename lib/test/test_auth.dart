//   // SaveUser de prueba, no se usa dentro de la app principal porque se usa
//   // usuarios pre-establecidos - No usar para.

// // Paquetes para obtención de información del dispositivo
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// // Firestore
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// // Material
// import 'package:flutter/material.dart';

// class TestUserHelper {
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
//     if(Platform.isAndroid) {
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
// final deviceInfo = await devicePlugin.iosInfo;
//       deviceId = deviceInfo.identifierForVendor;
//       deviceData = {
//         'os_version': deviceInfo.version.sdkInt.toString(),
//         'plaftorm': 'Android',
//         'model': deviceInfo.model,
//         'device': deviceInfo.device,
//       };
//     }
//   }
// }
