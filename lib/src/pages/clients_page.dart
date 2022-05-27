import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ClientsPage extends StatefulWidget {
  ClientsPage({Key? key}) : super(key: key);

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final Stream<QuerySnapshot> _clientesStream =
        FirebaseFirestore.instance.collection('clientes').snapshots();
    return Scaffold(
      body: Center(
        child: Text('Clientes'),
      ),
    );
  }
}
