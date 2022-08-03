// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/components/products.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class SelectedProducts extends StatefulWidget {
  const SelectedProducts({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectedProducts> createState() => _SelectedProductsState();
}

class _SelectedProductsState extends State<SelectedProducts> {
  List<Product> products = allProductInShoppingCart;

  cartStatus() {
    if (products.isEmpty) {
      return Text(
        'No hay productos seleccionados en su carrito',
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (products.isNotEmpty) {
      return;
    }
  }

  double totalPriceSum() {
    return products.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          alignment: Alignment.topLeft,
          color: Colors.transparent,
          child: cartStatus(),
        ),
        ProductsInCart(products: products),
        Container(
          height: 133,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Total del pedido:',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000C99),
                    ),
                  ),
                  SizedBox(width: 100),
                  Text(
                    '\$ ${totalPriceSum().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'Poppins-regular',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff000C99),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 340,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Agregar Productos
                      print('Agregar productos');
                    },
                    icon: Icon(
                      MaterialCommunityIcons.tag_plus,
                      size: 17,
                    ),
                    label: Text(
                      'Agregar productos',
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: myTheme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 340,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ElevatedButton(
                    onPressed: () {
                      // Continuar con la compra
                      print('Continuar con la compra');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: myTheme.colorScheme.secondary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CONTINUAR',
                          style: TextStyle(
                            fontFamily: 'Poppins-regular',
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
                          child: Icon(
                            SimpleLineIcons.arrow_right,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ProductsInCart extends StatefulWidget {
  const ProductsInCart({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List<Product> products;

  @override
  State<ProductsInCart> createState() => _ProductsInCartState();
}

class _ProductsInCartState extends State<ProductsInCart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 325,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
      ),
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: widget.products.length,
          itemBuilder: (context, index) {
            final product = widget.products[index];
            return Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/loading.gif'),
                      image: NetworkImage(
                        product.urlImg,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                            width: 190,
                            height: 40,
                            color: Colors.transparent,
                            child: Text(
                              product.productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Bottom Menus for changing details
                              print('Bottom Menu pressed');
                            },
                            icon: Icon(
                              Feather.more_vertical,
                              size: 15,
                            ),
                            splashRadius: 1,
                            splashColor: Colors.transparent,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              'U: ${product.productUnits}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins-regular',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text(
                              'P/U: ${product.unitPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Poppins-regular',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              'Total: ${product.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.purple.shade600,
                                fontFamily: 'Poppins-regular',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
