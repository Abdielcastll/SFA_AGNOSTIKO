// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/products/components/product_card.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_products.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarProducts(),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            _ProductList(),
          ],
        ),
      ),
    );
  }
}

class _ProductList extends StatefulWidget {
  const _ProductList({
    Key? key,
  }) : super(key: key);

  @override
  State<_ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<_ProductList> {
  final _productsQuery = FirebaseFirestore.instance.collection('productos');

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(top: 8.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      color: Colors.grey[100],
      child: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: _productsQuery.orderBy('codigo').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return Scrollbar(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final products = snapshot.data!.docs[index];
                      return ProductCard(
                        name: products['nombre'],
                        productId: products['codigo'],
                        design: products['diseno'],
                        label: products['marca'],
                        category: products['categoria'],
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Text('No hay productos activos'),
                );
              }
            }
            return Center(
              child: Text('Hubo un error en la interno con la conexion'),
            );
          },
        ),
      ),
    );
  }
}
