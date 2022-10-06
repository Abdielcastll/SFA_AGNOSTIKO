// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/examples/products_example.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
    required this.code,
    this.price,
    required this.line,
    required this.name,
    required this.imageUrl,
    required this.isProductNew,
    required this.stock,
    this.list,
  }) : super(key: key);

  final String code;
  final double? price;
  final String line;
  final String name;
  final String imageUrl;
  final bool isProductNew;
  final int stock;
  final List<Products>? list;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    // print(widget.list);
    return Scaffold(
      appBar: AppBar(elevation: 0, toolbarHeight: 40),
      backgroundColor: Colors.grey.shade200,
      body: ProductDetailsBody(
        code: widget.code,
        line: widget.line,
        imageUrl: widget.imageUrl,
        isProductNew: widget.isProductNew,
        name: widget.name,
        stock: widget.stock,
        list: widget.list,
        price: widget.price,
      ),
    );
  }
}

class ProductDetailsBody extends StatelessWidget {
  const ProductDetailsBody({
    Key? key,
    required this.code,
    this.price,
    required this.line,
    required this.name,
    required this.imageUrl,
    required this.isProductNew,
    required this.stock,
    this.list,
  }) : super(key: key);

  final String code;
  final double? price;
  final String line;
  final String name;
  final String imageUrl;
  final bool isProductNew;
  final int stock;
  final List<Products>? list;

  @override
  Widget build(BuildContext context) {
    // print(list);
    print(price);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              SizedBox(
                height: 275,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              isProductNew
                  ? Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: Icon(
                        CupertinoIcons.sparkles,
                        color: myTheme.colorScheme.primary,
                      ),
                    )
                  : Container(),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
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
                  color: myTheme.colorScheme.primary,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 40, 10, 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    '$line - ',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: 'Poppins-regular',
                    ),
                  ),
                  Text(
                    'Stock: $stock',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontFamily: 'Poppins-regular',
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 30.0),
                      // width: 160,
                      height: 38,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Redirigir a lista producto completas filtrada
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProductsPage(listOfProducts: list),
                              ),
                            );
                            print(
                                'Detalles de este producto en la lista completa');
                          },
                          icon: Icon(
                            MaterialCommunityIcons.view_list,
                            color: myTheme.colorScheme.primary,
                          ),
                          style: ButtonStyle(
                            shadowColor: MaterialStateProperty.all<Color>(
                                Colors.transparent),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 159, 165, 252)
                                  .withOpacity(0.3),
                            ),
                            overlayColor: MaterialStateProperty.all<Color>(
                                myTheme.colorScheme.primary.withOpacity(0.3)),
                          ),
                          label: Text(
                            'Ver en Lista',
                            style: TextStyle(
                                color: myTheme.colorScheme.primary,
                                fontFamily: 'Poppins-regular',
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(
              'Colores',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontFamily: 'Poppins-regular',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 20),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 5.0),
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: myTheme.colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5.0),
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: myTheme.colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 5.0),
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: myTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
              'ID: $code - Precio: $price',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontFamily: 'Poppins-regular',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
