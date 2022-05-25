import 'package:flutter/material.dart';

class AppBarOnline extends StatelessWidget {
  const AppBarOnline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.only(top: 10),
        child: const Text('Online'),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xFF106cc8),
      actions: [
        Container(
          width: 120,
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: Image.asset('/images/apps2go.png'),
        ),
      ],
    );
  }
}
