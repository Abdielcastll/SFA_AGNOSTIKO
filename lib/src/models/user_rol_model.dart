import 'package:cloud_firestore/cloud_firestore.dart';

class UserRole {
  bool? admin;
  bool? isRetail;
  bool? isManager;

  String name;

  List<Permission> permissions;

  UserRole({
    required this.permissions,
    required this.name,
    this.admin,
    this.isManager,
    this.isRetail,
  });

  factory UserRole.fromJson(Map<String, dynamic> jsonData) {
    Map<String, dynamic> permissionsJson = jsonData["permisos"];

    /* Map<String, dynamic> permisosFake = {
      "modulo": {
        "ver": true,
        "editar": true,
        "borrar": true,
        "agregar": true,
      },
      "modulo2": {
        "ver": true,
        "editar": true,
        "borrar": true,
        "agregar": true,
      },
    }; */

    List<Permission> permissions = [];

    permissionsJson.forEach((key, value) {
      final newPermission = Permission.fromJson(value, key);
      permissions.add(newPermission);
    });

    return UserRole(
      admin: jsonData["admin"],
      name: jsonData["nombre"],
      isManager: jsonData["esGerente"],
      isRetail: jsonData["esRetail"],
      permissions: permissions,
    );
  }

  factory UserRole.fromDocumentSnapshot(DocumentSnapshot docData) {
    Map<String, dynamic> permissionsJson = docData.get("permisos");
    /* Map<String, dynamic> permisosFake = {
      "modulo": {
        "ver": true,
        "editar": true,
        "borrar": true,
        "agregar": true,
      },
      "modulo2": {
        "ver": true,
        "editar": true,
        "borrar": true,
        "agregar": true,
      },
    }; */

    List<Permission> permissions = [];

    permissionsJson.forEach((key, value) {
      final newPermission = Permission.fromJson(value, key);
      permissions.add(newPermission);
    });

    return UserRole(
      admin: docData.data().toString().contains("admin")
          ? docData.get("admin")
          : false,
      name: docData.get("nombre"),
      isManager: docData.data().toString().contains("esGerente")
          ? docData.get("esGerente")
          : false,
      isRetail: docData.data().toString().contains("esRetail")
          ? docData.get("esRetail")
          : false,
      permissions: permissions,
    );
  }
}

class Permission {
  String module;
  bool get;
  bool delete;
  bool add;
  bool edit;

  Permission(
      {required this.module,
      required this.get,
      required this.add,
      required this.delete,
      required this.edit});

  factory Permission.fromJson(Map<String, dynamic> jsonData, String module) {
    return Permission(
        module: module,
        get: jsonData["ver"],
        add: jsonData["agregar"],
        delete: jsonData["borrar"],
        edit: jsonData["editar"]);
  }
}
