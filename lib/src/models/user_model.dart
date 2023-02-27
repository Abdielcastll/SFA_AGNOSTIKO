import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/models/user_rol_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';

class UserModel {
  final String? uid;
  final String? email;

  UserModel({
    this.uid,
    this.email,
  });
}

class CurrentUserInfo {
  final name;
  final email;
  final dni;
  final zone;
  final zoneDocument;
  final uid;
  final role;

  CurrentUserInfo({
    this.name,
    this.dni,
    this.zone,
    this.zoneDocument,
    this.email,
    this.role,
    this.uid,
  });

  Future<UserRole?> getUserRole() async {
    print('OBTENIENDO ROL');
    if (role == '') {
      return null;
    }
    final r = await getUserRol(role);
    return r;
  }
}

class CurrentUserProvider extends ChangeNotifier {
  CurrentUserInfo? _currentUserInfo;

  CurrentUserInfo? get currentUserInfo => _currentUserInfo;

  void setCurrentUserInfo(CurrentUserInfo? user, choice) {
    if (choice == true) {
      _currentUserInfo = user;
      notifyListeners();
    } else if (choice == false) {
      _currentUserInfo = CurrentUserInfo(
        name: '',
        dni: '',
        zone: '',
        zoneDocument: '',
        email: '',
        role: '',
        uid: '',
      );
      notifyListeners();
    }
  }
}
