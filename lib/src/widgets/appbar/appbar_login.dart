import 'package:flutter/material.dart';

class AppBarLogin extends StatelessWidget implements PreferredSizeWidget {
  const AppBarLogin({
    Key? key,
    required this.title,
    required this.backgroundColor,
  }) : super(key: key);
  final String title;
  final Color backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(10.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Container(),
      centerTitle: true,
      elevation: 0,
      backgroundColor: backgroundColor,
    );
  }
}
