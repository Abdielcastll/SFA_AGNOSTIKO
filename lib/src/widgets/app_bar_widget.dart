import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Text(' '),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF106cc8),
      actions: [
        Container(
          width: 100,
          padding: const EdgeInsets.only(top: 10),
          child: Image.asset('/images/apps2go.png'),
        ),
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
        Container(
          padding: const EdgeInsets.only(right: 10, top: 8),
          child: IconButton(
            splashRadius: 20,
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => {Navigator.of(context).pushNamed('login')},
          ),
        ),
      ],
    );
  }
}
