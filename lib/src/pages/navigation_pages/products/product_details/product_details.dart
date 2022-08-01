// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/products/product_details/components/details_card.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation_pages/products/product_details/components/product_images.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails(
      {Key? key,
      required this.name,
      required this.productId,
      this.design,
      this.label,
      this.category})
      : super(key: key);

  final String name;
  final String productId;
  final dynamic design;
  final dynamic label;
  final dynamic category;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: myTheme.colorScheme.secondary,
        title: Text(
          widget.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: FloatingActionButton(
              heroTag: '1',
              backgroundColor: myTheme.colorScheme.secondary,
              onPressed: () {
                print('Boton de funciones para seleccionar y subir imagen');
                // Show dialog image
              },
              child: Icon(Icons.cloud_upload, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              ShowProductPics(),
              DetailsCard(
                name: widget.name,
                productId: widget.productId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
