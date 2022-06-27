// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/products/product_details.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      return _ProductCard(
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

class _ProductCard extends StatelessWidget {
  _ProductCard({
    Key? key,
    required this.name,
    required this.productId,
    required this.design,
    required this.label,
    required this.category,
  }) : super(key: key);

  final String name;
  final String productId;
  final dynamic design;
  final dynamic label;
  final dynamic category;

  final _pricesQuery =
      FirebaseFirestore.instance.collection('lista_de_precios');

  final _stockQuery = FirebaseFirestore.instance.collection('stock');

  final String coinType = 'GENER-03';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 5.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: GestureDetector(
              onTap: () {
                print('tappeada tarjeta para acceder al producto');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetails(
                      name: name,
                      productId: productId,
                      design: design,
                      label: label,
                      category: category,
                    ),
                  ),
                );
              },
              child: Container(
                width: 360.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10.0, top: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productId,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[500]?.withOpacity(0.8),
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                'diseno',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[500]?.withOpacity(0.8),
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                'marca',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[500]?.withOpacity(0.8),
                                ),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                'stock',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[500]?.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Text(
                          'precio',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[500]?.withOpacity(0.8),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 80),
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
