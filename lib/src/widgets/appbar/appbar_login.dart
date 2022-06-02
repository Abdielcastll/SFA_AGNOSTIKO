import 'package:flutter/material.dart';

class AppBarLogin extends StatelessWidget implements PreferredSizeWidget {
  const AppBarLogin({
    Key? key,
    required this.title,
    // required this.backgroundColor,
  }) : super(key: key);
  final String title;
  // final Color backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(55.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4f42ed),
              Color.fromARGB(255, 130, 32, 147),
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
    );
  }
}
