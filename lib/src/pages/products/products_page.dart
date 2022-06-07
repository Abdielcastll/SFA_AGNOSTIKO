// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_home.dart';
import 'package:pwa_sales2go_flutter/src/widgets/drawer/drawer_widget.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream =
        FirebaseFirestore.instance.collection('productos').snapshots();
    final Stream<QuerySnapshot> preciosStream =
        FirebaseFirestore.instance.collection('lista_de_precios').snapshots();
    final Stream<QuerySnapshot> stockStream =
        FirebaseFirestore.instance.collection('stock').snapshots();

    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBarHome(
        title: 'Productos',
        backgroundColor: Color(0xFF4f42ed),
      ),
      body: productsBody(productsStream, stockStream, preciosStream),
    );
  }

  Widget productsBody(productsStream, preciosStream, stockStream) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[200],
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                child: SingleChildScrollView(
                  child: StreamBuilder(
                    stream: productsStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Column(
                          children: [
                            Text('Error: ${snapshot.error}'),
                            SizedBox(height: 10),
                            Text('Revisar reglas de Firebase'),
                          ],
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          padding: const EdgeInsets.only(top: 60),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF4f42ed)),
                          ),
                        );
                      }
                      return Container(
                          child: Text('Revisar reglas para permisos'));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
