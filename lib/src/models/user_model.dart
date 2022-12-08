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
  final dni;
  final zone;

  CurrentUserInfo({
    this.name,
    this.dni,
    this.zone,
  });
}

CurrentUserInfo currentUserInfoFromSnapshot(doc) {
  return CurrentUserInfo(
    name: doc.data().toString().contains('nombre') ? doc.get('nombre') : null,
    dni: doc.data().toString().contains('nro_cedula')
        ? doc.get('nro_cedula')
        : 00000000,
    zone: doc.data().toString().contains('zona') ? doc.get('zona').id : null,
  );
}
