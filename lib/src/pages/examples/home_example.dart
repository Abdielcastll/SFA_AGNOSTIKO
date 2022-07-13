import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';

class HomeExample extends StatefulWidget {
  HomeExample({Key? key}) : super(key: key);

  @override
  State<HomeExample> createState() => _HomeExampleState();
}

class _HomeExampleState extends State<HomeExample> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brew crew'),
        backgroundColor: Colors.brown.shade400,
        elevation: 0.0,
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              // sign out
              await _auth.signOut();
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.brown.shade400,
              elevation: 0.0,
              shadowColor: Colors.transparent,
            ),
            icon: Icon(Icons.person),
            label: Text('Logout'),
          ),
        ],
      ),
      body: Center(child: Text('Home example')),
    );
  }
}
