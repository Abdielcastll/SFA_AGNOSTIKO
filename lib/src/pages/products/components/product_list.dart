// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pwa_sales2go_flutter/examples/products_example.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';

class ProductList extends StatefulWidget {
  ProductList({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final searchController = TextEditingController();
  List<ProductExample> products = allProducts;
  final moneySymbol = '\$';

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
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(top: 15.0, left: 16.0),
            width: 160,
            height: 38,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ElevatedButton(
                onPressed: () {
                  // Abrir bottomsheet para filtros
                },
                style: ButtonStyle(
                  shadowColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 159, 165, 252).withOpacity(0.3),
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                      myTheme.colorScheme.primary.withOpacity(0.3)),
                ),
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtrar y Ordenar',
                      style: TextStyle(
                          color: myTheme.colorScheme.primary,
                          fontFamily: 'Poppins-regular',
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      MaterialIcons.filter_alt,
                      color: myTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          // margin: EdgeInsets.only(top: 10.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (BuildContext context, index) {
              final product = products[index];
              return Container(
                margin: EdgeInsets.only(top: 10.0),
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
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.shade400,
                              ),
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
