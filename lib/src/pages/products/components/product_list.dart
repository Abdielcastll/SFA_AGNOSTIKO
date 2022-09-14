// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pwa_sales2go_flutter/examples/products_example.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ProductList extends StatefulWidget {
  ProductList({
    Key? key,
    this.listOfProducts,
  }) : super(key: key);

  final listOfProducts;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final searchController = TextEditingController();
  var products;
  final moneySymbol = '\$';
  bool isChecked = false;
  bool isDescending = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    products = widget.listOfProducts;
  }

  void searchProduct(String query) {
    final suggestions = allProducts.where((element) {
      final productName = element.name.toLowerCase();
      final input = query.toLowerCase();

      return productName.contains(input);
    }).toList();
    setState(() {
      products = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-regular',
            ),
            keyboardType: TextInputType.text,
            maxLines: 1,
            maxLength: 200,
            textCapitalization: TextCapitalization.characters,
            controller: searchController,
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
              hintText: 'Buscar nombre',
              hintStyle: TextStyle(
                fontFamily: 'Poppins-regular',
                fontSize: 14,
              ),
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: myTheme.colorScheme.primary.withOpacity(0.5),
                ),
              ),
            ),
            onChanged: searchProduct,
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20.0, 5.0, 0, 0),
          child: Row(
            children: [
              TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      MaterialCommunityIcons.order_alphabetical_ascending,
                      color: Colors.grey.shade500,
                      size: 25,
                    ),
                    SizedBox(width: 5),
                    Text(
                      isDescending ? 'Ascendente' : 'Descendente',
                      style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          color: Colors.grey.shade500,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // splashRadius: 15,
                onPressed: () {
                  // Re ordenar el list view alfabeticamente
                  setState(() => isDescending = !isDescending);
                },
              ),
              IconButton(
                icon: Icon(
                  MaterialCommunityIcons.filter_variant,
                  color: Colors.grey.shade500,
                  size: 25,
                ),
                splashRadius: 15,
                onPressed: () {
                  // Abrir si se quiere ver por prospecto o no
                  Fluttertoast.showToast(
                    msg:
                        'Boton para re-ordenar la lista en orden ascendente y descendente',
                    textColor: Colors.white,
                    backgroundColor: myTheme.colorScheme.primary,
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          // margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.67,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: products!.length,
            itemBuilder: (BuildContext context, index) {
              final sortedProducts =
                  isDescending ? products.reversed.toList() : products;
              final product = sortedProducts![index];
              return Container(
                margin: EdgeInsets.only(bottom: 10.0),
                height: 120,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  onTap: () {
                    // Activar check para abrir opciones
                  },
                  onLongPress: () {
                    // Redireccionar a detalles del producto
                  },
                  title: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 17,
                              width: 17,
                              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey.shade400,
                              ),
                              child: Checkbox(
                                  side: MaterialStateBorderSide.resolveWith(
                                      (states) => BorderSide(
                                          width: 1.0,
                                          color: Colors.transparent)),
                                  shape: CircleBorder(),
                                  activeColor: myTheme.colorScheme.primary,
                                  value: isChecked,
                                  onChanged: (value) {
                                    setState(() => isChecked = value!);
                                  }),
                            ),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 90,
                              child: TextFieldForCard(
                                message: product.name,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            TextFieldForCard(
                              message: 'Codigo:',
                              bold: FontWeight.bold,
                            ),
                            TextFieldForCard(
                              message: 'Stock:',
                              bold: FontWeight.bold,
                            ),
                            TextFieldForCard(
                              message: 'Precio:',
                              bold: FontWeight.bold,
                            ),
                            TextFieldForCard(
                              message: 'Marca:',
                              bold: FontWeight.bold,
                            ),
                            TextFieldForCard(
                              message: 'Categoria:',
                              bold: FontWeight.bold,
                            ),
                            TextFieldForCard(
                              message: 'Sub-Categoria:',
                              bold: FontWeight.bold,
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            TextFieldForCard(
                              message: product.code,
                            ),
                            TextFieldForCard(
                              message: '000',
                            ),
                            TextFieldForCard(
                              message: '$moneySymbol 00.00',
                            ),
                            TextFieldForCard(
                              message: product.brand,
                            ),
                            TextFieldForCard(
                              message: product.categorie,
                            ),
                            TextFieldForCard(
                              message: product.subcategorie,
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            TextFieldForCard(
                              message: 'Linea:',
                              bold: FontWeight.bold,
                            ),
                            TextFieldForCard(
                              message: 'Calidad:',
                              bold: FontWeight.bold,
                            ),
                            TextFieldForCard(
                              message: 'Tamano:',
                              bold: FontWeight.bold,
                            ),
                            TextFieldForCard(
                              message: 'Diseno:',
                              bold: FontWeight.bold,
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            TextFieldForCard(
                              message: product.line,
                            ),
                            TextFieldForCard(
                              message: product.quality,
                            ),
                            TextFieldForCard(
                              message: product.size,
                            ),
                            TextFieldForCard(
                              message: product.design,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TextFieldForCard extends StatelessWidget {
  const TextFieldForCard({
    Key? key,
    this.message,
    this.bold,
  }) : super(key: key);

  final message;
  final bold;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(
        fontFamily: 'Poppins-regular',
        fontSize: 11,
        fontWeight: bold,
      ),
    );
  }
}
