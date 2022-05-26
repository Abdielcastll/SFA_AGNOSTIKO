import 'package:flutter/material.dart';

class AppBarOffline extends StatefulWidget {
  const AppBarOffline({Key? key}) : super(key: key);

  @override
  State<AppBarOffline> createState() => _AppBarOfflineState();
}

class _AppBarOfflineState extends State<AppBarOffline> {
  @override
  Widget build(BuildContext context) {
    final String? route = ModalRoute.of(context)!.settings.name;
    print('Offline - Ruta: $route');

    bool isRouteLogin = false;
    if (ModalRoute.of(context)!.settings.name == 'login') {
      isRouteLogin = true;
    }
    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Text('Offline'),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF106cc8),
      leading: isRouteLogin
          ? Container(
              padding: const EdgeInsets.only(left: 10, top: 8),
              child: IconButton(
                splashRadius: 20,
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pushNamed('/'),
              ),
            )
          : Container(),
      actions: [
        Container(
          width: 120,
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: Image.asset('/images/apps2go.png'),
        ),
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
        if (isRouteLogin == false)
          Container(
            padding: const EdgeInsets.only(right: 10, top: 8),
            child: IconButton(
              splashRadius: 20,
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('login');
              },
            ),
          ),
      ],
    );
  }
}
