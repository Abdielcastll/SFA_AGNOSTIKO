import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/auth/auth.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar_widgets/appbar_widget.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  var userCollection = FirebaseFirestore.instance.collection('usuarios');
  var userEmail = FirebaseAuth.instance.currentUser?.email;
  var roleCollection = FirebaseFirestore.instance.collection('roles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBarWidget(),
      ),
      body: Center(
        child: SizedBox(
          width: 150,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.lock_open, size: 20),
            label: const Text('Logout', style: TextStyle(fontSize: 15)),
            onPressed: () {
              AuthHelper.signOut(
                context,
              );
            },
          ),
        ),
      ),
    );
  }
}
