// AppBarOffline: AppBar que se muestra solo cuando no hay un usuario conectado
// y sirve para trasladarse al login.

import 'package:flutter/material.dart';

class AppBarOffline extends StatefulWidget {
  const AppBarOffline({Key? key}) : super(key: key);

  @override
  State<AppBarOffline> createState() => _AppBarOfflineState();
}

class _AppBarOfflineState extends State<AppBarOffline> {
  @override
  Widget build(BuildContext context) {
    // Obtener e imprimir en consola la ruta actual de la aplicación.
    final String? _route = ModalRoute.of(context)!.settings.name;
    print('Offline - Ruta: $_route');

    // Verificar si la ruta actual es la ruta de la página de login, si es asi,
    // cambiar a true.
    bool isRouteLogin = false;
    if (_route == 'login') {
      isRouteLogin = true;
    }

    // Retornar el Appbar que se va a usar.
    return AppBar(
      // Ocultar la flecha que deja regresar a la pantalla anterior para mayor
      // flexibilidad del leading del appbar.
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Text('Offline'),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF106cc8),
      // Elementos a la izquierda del Appbar.
      // Si route es true, mostrar el boton para regresar a la pagina principal,
      // en caso de false, no mostrar nada.
      leading: isRouteLogin ? _leadingOffline(context) : Container(),
      actions: [_actionsOffline(isRouteLogin)],
    );
  }

  // Widget que contiene el boton para regresar a la pagina principal y en caso
  // de ser necesario, aumentar los items que se necesitan en el leading.
  Widget _leadingOffline(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 8),
      child: IconButton(
        splashRadius: 20,
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pushNamed('/'),
      ),
    );
  }

  // Widget que muestra las acciones del Appbar offline, como funcion principal
  // mostrar el boton para acceder al login y en caso de ya estar en la ruta
  // login, esconder esos botones.
  Widget _actionsOffline(bool isRouteLogin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 120,
          padding: const EdgeInsets.only(top: 8, right: 5),
          child: Image.asset('/images/apps2go.png'),
        ),

        // Si la ruta ya es 'Login' no se mostrara esto
        if (isRouteLogin == false)
          Container(
            padding: const EdgeInsets.only(
              top: 5,
            ),
            child: const Center(
              child: Text(
                'Ingresar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Si la ruta ya es 'Login' no se mostrara esto
        if (isRouteLogin == false)
          Container(
            padding: const EdgeInsets.only(right: 8, top: 8),
            child: IconButton(
              splashRadius: 20,
              icon: const Icon(Icons.exit_to_app),
              // Cuando se presione el boton, se va a la ruta de login.
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('login');
              },
            ),
          ),
      ],
    );
  }
}
