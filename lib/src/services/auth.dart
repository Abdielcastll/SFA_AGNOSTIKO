import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';

class AuthService {
  final FirebaseAuth _auth =
      FirebaseAuth.instanceFor(app: multitenantConfig.tenantApp!);
  final FirebaseFirestore firebaseInstance =
      FirebaseFirestore.instanceFor(app: multitenantConfig.tenantApp!);

  // Create object based on firebase user

  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid, email: user.email) : null;
  }

  // auth change user stream

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in with email and password

  Future<bool> signInWithEmailAndPassword(
      String email, String password, context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );
      User? user = result.user;
      if (user != null) {
        checkIfUserRecordExist(user, context);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

      Fluttertoast.showToast(
        msg: 'Los datos proporcionados son invalidos',
        backgroundColor: themeProvider.myTheme.colorScheme.secondary,
        textColor: Colors.white,
      );
      return false;
    }
  }

  // check if user record exist after logging

  checkIfUserRecordExist(User user, context) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    await firebaseInstance
        .collection('usuarios')
        .doc(user.uid)
        .get()
        .then((record) async {
      if (record.exists) {
        try {
          if (record.data()!['activo'] == true) {
            if (record.data()!['esVendedor'] ||
                record.data()!['rol'].id == 'S7iQ6hOGikhwrFUHmQtV') {
              return _userFromFirebaseUser(user);
            } else {
              await signOut();
              Fluttertoast.showToast(
                msg: 'Usuario no vendedor',
                backgroundColor: themeProvider.myTheme.colorScheme.secondary,
                textColor: Colors.white,
              );
            }
          } else {
            Fluttertoast.showToast(
              msg: 'Usuario no activo o bloqueado',
              backgroundColor: themeProvider.myTheme.colorScheme.secondary,
              textColor: Colors.white,
            );
          }
        } catch (e) {
          print(e);
          Fluttertoast.showToast(
            msg: 'Error en la petición',
            backgroundColor: themeProvider.myTheme.colorScheme.secondary,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Este usuario no existe',
          backgroundColor: themeProvider.myTheme.colorScheme.secondary,
          textColor: Colors.white,
        );
      }
    });
  }

  // sign out

  Future signOut() async {
    try {
      print('signed out pressed');

      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  CurrentUserInfo userDataFromsnapshot(DocumentSnapshot snapshot) {
    return CurrentUserInfo(
      dni: snapshot.data().toString().contains('nro_cedula')
          ? snapshot.get('nro_cedula')
          : 0,
      email: snapshot.data().toString().contains('email')
          ? snapshot.get('email')
          : 'NaN',
      name: snapshot.data().toString().contains('nombre')
          ? snapshot.get('nombre')
          : 'NaN',
      role: snapshot.data().toString().contains('rol')
          ? snapshot.get('rol').id
          : 'NaN',
      uid: snapshot.reference.id,
      zone: snapshot.data().toString().contains('zona')
          ? snapshot.get('zona').id
          : 'NaN',
      zoneDocument: snapshot.data().toString().contains('zona')
          ? snapshot.get('zona')
          : 'NaN',
    );
  }
}
