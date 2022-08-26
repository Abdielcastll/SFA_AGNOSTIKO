// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/examples/products_example.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/components/product_list.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key, this.listOfProducts}) : super(key: key);

  final listOfProducts;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNavigation(message: 'Productos'),
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomDecoration(),
      body: ProductsBody(listOfProducts: widget.listOfProducts),
    );
  }
}

class ProductsBody extends StatefulWidget {
  const ProductsBody({
    Key? key,
    this.listOfProducts,
  }) : super(key: key);

  final listOfProducts;

  @override
  State<ProductsBody> createState() => _ProductsBodyState();
}

class _ProductsBodyState extends State<ProductsBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          ProductList(listOfProducts: widget.listOfProducts),
          // _ProductList(),
        ],
      ),
    );
  }
}
