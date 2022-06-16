// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/bottom_decoration.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHome(
        title: 'Productos',
        backgroundColor: Color(0xFF4f42ed),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomDecoration(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _productsBody(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productsBody() {
    return SingleChildScrollView();
  }
}
