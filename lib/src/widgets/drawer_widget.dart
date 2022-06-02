import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/widgets/splashscreen_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String? name = 'Nombre de usuarios';
  String? cargo = 'Cargo';
  retrieveSharedData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? name = sharedPreferences.getString('name');
    setState(() {});
  }

  @override
  void initState() {
    retrieveSharedData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black54,
      child: ListView(
        children: [
          //header
          Container(
            padding: const EdgeInsets.only(top: 26, bottom: 12),
            child: Column(
              children: [
                //user name
                Text(
                  '$name - $cargo',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          //body
          Container(
            padding: const EdgeInsets.only(
              top: 1,
            ),
            child: Column(
              children: [
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                //home
                ListTile(
                  leading: const Icon(
                    Icons.home_rounded,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    'Inicio',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    //
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                //home
                ListTile(
                  leading: const Icon(
                    Icons.notifications_rounded,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    'Notificaciones',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    //
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                //home
                ListTile(
                  leading: const Icon(
                    Icons.library_books_rounded,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    'Catalogo',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    //
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

                //home
                ListTile(
                  leading: const Icon(
                    Icons.view_list_rounded,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    'Productos',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    //
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                //home
                ListTile(
                  leading: const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    'Clientes',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    //
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                //home
                ListTile(
                  leading: const Icon(
                    Icons.book_rounded,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    'Visitas',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    //
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                //home
                ListTile(
                  leading: const Icon(
                    Icons.local_shipping_rounded,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    'Pedidos',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    //
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                //home
                ListTile(
                  leading: const Icon(
                    Icons.inbox_rounded,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    'Facturas',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    //
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.red,
                  thickness: 2,
                ),
                //home
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    //Cerrar Sesion
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SplashScreenWidget()));
                    Fluttertoast.showToast(msg: 'Sesion cerrada.');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
