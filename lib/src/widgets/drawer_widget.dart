import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
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
              children: const [
                //user name
                Text(
                  'Nombre de usuario - Rango',
                  style: TextStyle(
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
                  color: Colors.grey,
                  thickness: 2,
                ),
                //home
                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Colors.grey,
                  ),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    //
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
