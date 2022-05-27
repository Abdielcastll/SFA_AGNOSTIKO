import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/auth/auth.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar_widgets/appbar_widget.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _auth = AuthHelper();
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final Stream<QuerySnapshot> _productsStream =
        FirebaseFirestore.instance.collection('productos').snapshots();
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBarWidget(),
      ),
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
                  _auth.signOut(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
