import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final String? name = sharedPreferences?.getString('nombre');
    final String? cargo = sharedPreferences?.getString('cargo');

    return Drawer(
      backgroundColor: const Color.fromRGBO(79, 66, 237, 1),
      width: MediaQuery.of(context).size.width * 0.6,
      child: ListView(
        children: [
          //header
          Container(
            padding: const EdgeInsets.only(top: 20.0, bottom: 12),
            child: Column(
              children: [
                const Text(
                  'SFS Agnostiko',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                //user name
                Text(
                  '$name',
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$cargo',
                  style: const TextStyle(
                    fontSize: 15,
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
              top: 20.0,
            ),
            child: Column(
              children: [
                //home
                ListTile(
                  leading: const Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Dashboard',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.of(context).pushNamed('dashboard'),
                ),
                //home

                ListTile(
                  leading: const Icon(
                    Icons.library_books_rounded,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Catalogo',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.of(context).pushNamed('catalogue'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.view_list_rounded,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Productos',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.pushNamed(context, 'products'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Clientes',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, 'clients');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.book_rounded,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Visitas',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.of(context).pushNamed('visits'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.local_shipping_rounded,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Pedidos',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.of(context).pushNamed('orders'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.inbox_rounded,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Facturas',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () => Navigator.of(context).pushNamed('invoices'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Colors.orange,
                  ),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, 'splashscreen');
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
