// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({
    Key? key,
    required this.code,
    required this.line,
    required this.name,
    required this.imageUrl,
    required this.isProductNew,
  }) : super(key: key);

  final String code;
  final String line;
  final String name;
  final String imageUrl;
  final bool isProductNew;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 40),
      bottomNavigationBar: BottomDecoration(),
      backgroundColor: Colors.grey.shade200,
      body: ProductDetailsBody(
        code: widget.code,
        line: widget.line,
        imageUrl: widget.imageUrl,
        isProductNew: widget.isProductNew,
        name: widget.name,
      ),
    );
  }
}

class ProductDetailsBody extends StatelessWidget {
  const ProductDetailsBody({
    Key? key,
    required this.code,
    required this.line,
    required this.name,
    required this.imageUrl,
    required this.isProductNew,
  }) : super(key: key);

  final String code;
  final String line;
  final String name;
  final String imageUrl;
  final bool isProductNew;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 275,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 50),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                name,
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'Poppins-regular',
                    fontSize: 24,
                    color: myTheme.colorScheme.primary),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Text(line),
              ],
            ),
          )
        ],
      ),
    );
  }
}
