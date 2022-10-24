import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

  // Create object based on firebase user

  UserModel? _userFromFirebaseUser(User? user) {
    return user != null ? UserModel(uid: user.uid, email: user.email) : null;
  }

  // auth change user stream

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in with email and password

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password.trim(),
      );
      User? user = result.user;
      if (user != null) {
        checkIfUserRecordExist(user);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Los datos proporcionados son invalidos',
        backgroundColor: myTheme.colorScheme.secondary,
        textColor: Colors.white,
      );
      return null;
    }
  }

  // check if user record exist after logging

  checkIfUserRecordExist(User user) async {
    await firebaseInstance
        .collection('usuarios')
        .doc(user.uid)
        .get()
        .then((record) async {
      if (record.exists) {
        try {
          if (record.data()!['activo'] == true) {
            await sharedPreferences!.setString('uid', user.uid);
            await sharedPreferences!
                .setString('email', user.email ?? 'No hay email');
            await sharedPreferences!
                .setString('nombre', record.data()!['nombre']);
            await sharedPreferences!
                .setInt('nro_cedula', record.data()!['nro_cedula']);
            List<String> indice = record.data()!['indice'].cast<String>();
            await sharedPreferences!.setStringList('indice', indice);
            await sharedPreferences!.setString('currentCoin', 'USD');
            if (record.data()!['rol'].id == 'S7iQ6hOGikhwrFUHmQtV') {
              await sharedPreferences!.setString('cargo', 'Administrador');
            } else {
              if (record.data()!['esGerente'] == false) {
                if (record.data()!['esVendedor'] == false) {
                  await sharedPreferences!.setString('cargo', 'Cobrador');
                } else {
                  await sharedPreferences!.setString('cargo', 'Vendedor');
                }
              } else {
                await sharedPreferences!.setString('cargo', 'Gerente');
              }
            }
            print('/////////////////////////////////////////////////');
            print('Saving Data on shared preferences');
            print(sharedPreferences!.getString('uid'));
            print(sharedPreferences!.getString('email'));
            print(sharedPreferences!.getString('nombre'));
            print(sharedPreferences!.getInt('nro_cedula'));
            print(sharedPreferences!.getStringList('indice'));
            print(sharedPreferences!.getString('cargo'));
            print('/////////////////////////////////////////////////');

            return _userFromFirebaseUser(user);
          } else {
            Fluttertoast.showToast(
              msg: 'Usuario no activo o bloqueado',
              backgroundColor: myTheme.colorScheme.secondary,
              textColor: Colors.white,
            );
          }
        } catch (e) {
          Fluttertoast.showToast(
            msg: 'Error en la petición',
            backgroundColor: myTheme.colorScheme.secondary,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Este usuario no existe',
          backgroundColor: myTheme.colorScheme.secondary,
          textColor: Colors.white,
        );
      }
    });
  }

  // sign out

  Future signOut() async {
    try {
      print('signed out pressed');
      await sharedPreferences!.setString('uid', '');
      await sharedPreferences!.setString('email', '');
      await sharedPreferences!.setString('nombre', '');
      await sharedPreferences!.setInt('nro_cedula', 0);
      await sharedPreferences!.setStringList('indice', []);
      await sharedPreferences!.setString('cargo', '');
      await sharedPreferences!.setString('cargo', '');
      print('/////////////////////////////////////////////////');
      print('Saving Data on shared preferences');
      print(sharedPreferences!.getString('uid'));
      print(sharedPreferences!.getString('email'));
      print(sharedPreferences!.getString('nombre'));
      print(sharedPreferences!.getInt('nro_cedula'));
      print(sharedPreferences!.getStringList('indice'));
      print(sharedPreferences!.getString('cargo'));
      print('/////////////////////////////////////////////////');

      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
