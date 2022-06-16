import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/search/search_delegate.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHome({
    Key? key,
    required this.title,
    required this.backgroundColor,
  }) : super(key: key);
  final String title;
  final Color backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(55.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: backgroundColor,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 7.0),
                constraints: const BoxConstraints(),
                splashRadius: 20.0,
                icon: const Icon(Icons.search_rounded),
                onPressed: () {
                  print('Search button pressed');
                  showSearch(context: context, delegate: DataSearch());
                },
              ),
            ),
            IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              constraints: const BoxConstraints(),
              splashRadius: 20.0,
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {
                print('Notification button pressed');
                Navigator.pushNamed(context, 'notifications');
              },
            ),
          ],
        )
      ],
    );
  }
}
