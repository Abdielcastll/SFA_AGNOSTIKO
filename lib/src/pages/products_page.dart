import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/auth/auth.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 150,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.lock_open, size: 20),
            label: const Text('Logout', style: TextStyle(fontSize: 15)),
            onPressed: () {
              signOut(
                context,
              );
            },
          ),
        ),
      ),
    );
  }
}
