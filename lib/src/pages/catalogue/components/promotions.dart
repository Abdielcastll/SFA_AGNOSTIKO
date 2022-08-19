// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class PromotionsWidget extends StatefulWidget {
  const PromotionsWidget({
    Key? key,
    required this.productsWithPromotion,
  }) : super(key: key);

  final List productsWithPromotion;

  @override
  State<PromotionsWidget> createState() => _PromotionsWidgetState();
}

class _PromotionsWidgetState extends State<PromotionsWidget> {
  @override
  Widget build(BuildContext context) {
    // print(widget.productsWithPromotion);
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                MdiIcons.starOutline,
                color: myTheme.colorScheme.secondary,
                size: 25.0,
              ),
              SizedBox(width: 5.0),
              Text(
                'Promociones',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: myTheme.colorScheme.secondary,
                  fontSize: 16.0,
                  fontFamily: 'Poppins-regular',
                ),
              ),
            ],
          ),
          SizedBox(
            height: 160,
            width: double.infinity,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: widget.productsWithPromotion.length,
              itemBuilder: (BuildContext context, index) {
                final productWithPromotion =
                    widget.productsWithPromotion[index];
                // print(productWithPromotion.name);
                return GestureDetector(
                  onTap: () {
                    //TODO: Redireccionar a producto en promoción,
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        height: 120,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            '${productWithPromotion.imageUrl}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: 300,
                        height: 20,
                        child: Text(
                          productWithPromotion.name,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: myTheme.colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
