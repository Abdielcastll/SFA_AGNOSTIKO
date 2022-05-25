import 'package:flutter/material.dart';

class ClientsPage extends StatefulWidget {
  ClientsPage({Key? key}) : super(key: key);

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Clientes'),
      ),
    );
  }
}
