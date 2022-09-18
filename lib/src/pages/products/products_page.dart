// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({
    Key? key,
    this.productName,
    this.categorieName,
  }) : super(key: key);

  final productName;
  final categorieName;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNavigation(message: 'Productos'),
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomDecoration(),
      body: MultiProvider(
        providers: [
          StreamProvider<List<Products>?>.value(
            value: DatabaseService().products,
            initialData: const [],
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<QualitySummary?>.value(
            value: DatabaseService().qualitySummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<CategorieSummary?>.value(
            value: DatabaseService().categorieSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<DesignSummary?>.value(
            value: DatabaseService().designSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<LineSummary?>.value(
            value: DatabaseService().lineSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<BrandSummary?>.value(
            value: DatabaseService().brandSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<SubCategorieSummary?>.value(
            value: DatabaseService().subCategorieSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<SizeSummary?>.value(
            value: DatabaseService().sizeSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<StockModel?>.value(
            value: DatabaseService().stockValues,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
        ],
        child: ProductsBody(
          productName: widget.productName,
          categorieName: widget.categorieName,
        ),
      ),
    );
  }
}

class ProductsBody extends StatefulWidget {
  const ProductsBody({
    Key? key,
    this.productName,
    this.categorieName,
  }) : super(key: key);

  final productName;
  final categorieName;

  @override
  State<ProductsBody> createState() => _ProductsBodyState();
}

class _ProductsBodyState extends State<ProductsBody> {
  final searchController = TextEditingController();
  var filter;
  final moneySymbol = '\$';
  bool isChecked = false;
  bool isDescending = false;

  @override
  void initState() {
    super.initState();
    filter = widget.productName;
  }

  @override
  Widget build(BuildContext context) {
    var productsList;
    if (widget.categorieName == null) {
      productsList = Provider.of<List<Products>?>(context)?.where((products) {
        final productName = products.name.toString().toLowerCase();
        final output = widget.productName.toString().toLowerCase();

        return productName.contains(output);
      }).toList();
    } else if (widget.productName == null) {
      productsList = Provider.of<List<Products>?>(context)?.where((products) {
        final categorieName = products.categorie.toString().toLowerCase();
        final output = widget.categorieName.toString().toLowerCase();

        return categorieName.contains(output);
      }).toList();
    }

    // print(productsList);
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
            // onChanged: searchProduct,
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
            itemCount: productsList?.length,
            itemBuilder: (BuildContext context, index) {
              final sortedProducts =
                  isDescending ? productsList?.reversed.toList() : productsList;
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
                              message: product.subCategorie,
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
