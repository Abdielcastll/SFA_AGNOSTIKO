// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key, required this.name, required this.productId})
      : super(key: key);

  final String name;
  final String productId;

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
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            _ShowProductPics(),
            _DetailsCard(name: widget.name),
          ],
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
      // color: Colors.grey.shade200,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 328.0,
            height: 328.0,
            color: Colors.lightGreen,
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
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.435,
      child: Padding(
        padding: EdgeInsets.only(right: 16, left: 16, top: 21, bottom: 30),
        child: Container(
          width: double.infinity,
          height: 70.0,
          color: Colors.amber.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}
