// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
              _ShowProductPics(),
              _DetailsCard(
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

class _ShowProductPics extends StatelessWidget {
  const _ShowProductPics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 328.0,
            height: 328.0,
            color: Colors.transparent,
            child: Image.network(
              'https://i.pinimg.com/474x/39/0d/cc/390dccf32a0ee4023cf7c56979133283.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    Key? key,
    required this.name,
    required this.productId,
  }) : super(key: key);

  final String name;
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.435,
      child: Padding(
        padding: EdgeInsets.only(right: 16, left: 16, top: 10, bottom: 30),
        child: Container(
          width: double.infinity,
          height: 70.0,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 328,
                color: Colors.transparent,
                height: 70,
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.only(top: 7),
                      width: 90,
                      height: 36,
                      color: Colors.white,
                      child: Text(
                        'Precio \$',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 156,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          //
                        },
                        style: ElevatedButton.styleFrom(
                          primary: myTheme.colorScheme.secondary,
                        ),
                        icon: Icon(
                          Icons.add_shopping_cart_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Nuevo Pedido',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                'Marca',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 21),
              Row(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    'Stock: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '000',
                    // Future Stock
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 21),
              Text(
                'ID: $productId',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
