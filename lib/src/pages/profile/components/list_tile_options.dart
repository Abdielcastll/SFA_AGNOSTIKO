// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/pages/users_and_teams/users_and_teams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ListTileOptions extends StatefulWidget {
  const ListTileOptions({
    Key? key,
    this.charge,
    this.name,
    this.email,
  }) : super(key: key);

  final String? charge;
  final String? name;
  final String? email;

  @override
  State<ListTileOptions> createState() => _ListTileOptionsState();
}

class _ListTileOptionsState extends State<ListTileOptions> {
  @override
  Widget build(BuildContext context) {
    String? selectedValue;

    bool isAdmin;
    if (widget.charge == 'Cobrador' || widget.charge == 'Administrador') {
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
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Zona de Ventas',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Container(
                      height: 50,
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TERRITORIO 1',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Gerente: ',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: myTheme.colorScheme.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Ana Avila 01',
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                  color: myTheme.colorScheme.secondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
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
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Informacion de este usuario',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Container(
                      height: 100,
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nombre: ${widget.name} ',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Email: ${widget.email}',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Cargo: ${widget.charge}',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          icon: MaterialIcons.mail_outline,
        ),
        ListTileProfile(
          title: 'Notificaciones',
          sub: 'Notificaciones de la aplicación y sus movimientos',
          function: () {
            // Funcion que redigire a las notificaciones del usuario
            Navigator.pushNamed(context, 'notifications');
          },
          icon: MaterialCommunityIcons.bell_outline,
        ),
        ListTileProfile(
          title: 'Cambiar Moneda',
          sub: 'Notificaciones de la aplicación y sus movimientos',
          function: () {
            // Funcion que redigire a las notificaciones del usuario
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    List? items = [
                      'Dolares (\$)',
                      'Bolivares (Bs)',
                      'Bitcoin (BTC)',
                    ];
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        'Cambiar Moneda',
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: myTheme.colorScheme.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  hint: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          selectedValue ?? 'Dolares (\$)',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: myTheme.colorScheme.primary
                                                .withOpacity(0.7),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: items
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    myTheme.colorScheme.primary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        selectedValue = value as String;
                                      },
                                    );
                                    // Mover la funcion en la base de datos para cambiar la lista
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                  iconSize: 11,
                                  iconEnabledColor: myTheme.colorScheme.primary
                                      .withOpacity(0.5),
                                  iconDisabledColor: Colors.grey,
                                  buttonHeight: 50,
                                  buttonWidth: 200,
                                  buttonPadding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  buttonDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: myTheme.colorScheme.primary
                                          .withOpacity(0.3),
                                    ),
                                    color: Colors.white,
                                  ),
                                  buttonElevation: 0,
                                  itemHeight: 40,
                                  itemPadding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  dropdownMaxHeight: 200,
                                  dropdownWidth: 200,
                                  dropdownPadding: null,
                                  dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  dropdownElevation: 8,
                                  scrollbarRadius: const Radius.circular(10),
                                  scrollbarThickness: 6,
                                  scrollbarAlwaysShow: true,
                                  offset: const Offset(-20, 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                });
          },
          icon: Icons.monetization_on,
        ),
        ListTileProfile(
          title: 'Ayuda',
          sub: 'Tips de Uso y centro de contacto',
          function: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Informacion de Soporte al usuario',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        color: myTheme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Container(
                      height: 150,
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Si necesita ayuda con algun lado de la aplicacion, comunicarse al:',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '731XXX000 EXT 000 ',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Email:',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'examplesupport@email.com',
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              color: myTheme.colorScheme.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
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
