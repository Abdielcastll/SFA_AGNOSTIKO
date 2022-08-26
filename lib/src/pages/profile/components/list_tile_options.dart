// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/pages/users_and_teams/users_and_teams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ListTileOptions extends StatelessWidget {
  const ListTileOptions({
    Key? key,
    this.charge,
  }) : super(key: key);

  final String? charge;

  @override
  Widget build(BuildContext context) {
    bool isAdmin;
    if (charge == 'Cobrador' || charge == 'Administrador') {
      isAdmin = true;
    } else {
      isAdmin = false;
    }
    print(isAdmin);
    return Column(
      children: [
        ListTileProfile(
          title: 'Zona de Ventas',
          sub: 'Zona de ventas asignada y gerentes',
          function: () {
            //Funcion para abrir dialog que muere zona de ventas y gerente
          },
          icon: MaterialIcons.map,
        ),
        isAdmin
            ? ListTileProfile(
                title: 'Usuarios y Equipos',
                sub: 'Administra a tus equipos y sus integrantes',
                function: () {
                  // Redireccion a Usuarios y equipos
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => UsersAndTeamsPage(),
                    ),
                  );
                },
                icon: Icons.people_alt_outlined,
              )
            : Container(),
        ListTileProfile(
          title: 'Cuenta',
          sub: 'Correo, contraseñas y ajustes de perfil',
          function: () {
            //Funcion para bottom Sheet menu para cambiar nombr
          },
          icon: MaterialIcons.mail_outline,
        ),
        ListTileProfile(
          title: 'Notificaciones',
          sub: 'Notificaciones de la aplicación y sus movimientos',
          function: () {
            // Funcion que redigire a las notificaciones del usuario
          },
          icon: MaterialCommunityIcons.bell_outline,
        ),
        ListTileProfile(
          title: 'Ayuda',
          sub: 'Tips de Uso y centro de contacto',
          function: () {
            //
          },
          icon: MaterialIcons.info_outline,
        ),
      ],
    );
  }
}

class ListTileProfile extends StatelessWidget {
  const ListTileProfile({
    Key? key,
    this.function,
    required this.title,
    required this.sub,
    required this.icon,
  }) : super(key: key);

  final function;
  final String title;
  final String sub;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: ListTile(
        leading: Container(
          child: Icon(
            icon,
            color: myTheme.colorScheme.secondary,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: myTheme.colorScheme.secondary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          sub,
          style: TextStyle(
            fontFamily: 'Poppins-regular',
            color: Colors.grey.shade500,
            fontSize: 12,
          ),
        ),
        onTap: function,
      ),
    );
  }
}
