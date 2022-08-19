// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/product_details/product_details.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
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

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final String coinType = 'GENER-03';

  @override
  Widget build(BuildContext context) {
    print(widget.label);
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
                      name: widget.name,
                      productId: widget.productId,
                      design: widget.design,
                      label: widget.label,
                      category: widget.category,
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
                              widget.name,
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
                                widget.productId,
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
