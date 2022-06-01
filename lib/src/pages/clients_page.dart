// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/auth/auth.dart';

class ClientsPage extends StatefulWidget {
  ClientsPage({Key? key}) : super(key: key);

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final Stream<QuerySnapshot> _clientesStream =
      FirebaseFirestore.instance.collection('clientes').snapshots();

  // final _auth = AuthHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const PreferredSize(
      //   preferredSize: Size.fromHeight(65.0),
      //   child: AppBarWidget(),
      // ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Text('Esta es la pagina donde se mostraran los productos:'),
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.lock_open, size: 20),
                label: const Text('Logout de prueba',
                    style: TextStyle(fontSize: 15)),
                onPressed: () {
                  // _auth.signOut(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
