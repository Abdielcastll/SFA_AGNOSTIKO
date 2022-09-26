// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:pwa_sales2go_flutter/src/widgets/bottom_decoratior.dart/bottom_decoration.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({
    Key? key,
    this.listOfProducts,
  }) : super(key: key);

  final listOfProducts;

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
          // StreamProvider<List<Products>?>.value(
          //   value: DatabaseService().products,
          //   initialData: const [],
          //   catchError: (context, error) {
          //     print(error);
          //     return;
          //   },
          // ),
          StreamProvider<QualitySummary?>.value(
            value: DatabaseServiceStreams().qualitySummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<CategorieSummary?>.value(
            value: DatabaseServiceStreams().categorieSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<DesignSummary?>.value(
            value: DatabaseServiceStreams().designSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<LineSummary?>.value(
            value: DatabaseServiceStreams().lineSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<BrandSummary?>.value(
            value: DatabaseServiceStreams().brandSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<SubCategorieSummary?>.value(
            value: DatabaseServiceStreams().subCategorieSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<SizeSummary?>.value(
            value: DatabaseServiceStreams().sizeSummary,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
          StreamProvider<StockModel?>.value(
            value: DatabaseServiceStreams().stockValues,
            initialData: null,
            catchError: (context, error) {
              print(error);
              return;
            },
          ),
        ],
        child: ProductsBody(listOfProducts: widget.listOfProducts),
      ),
    );
  }
}

class ProductsBody extends StatefulWidget {
  const ProductsBody({
    Key? key,
    this.listOfProducts,
  }) : super(key: key);

  final List<Products>? listOfProducts;

  @override
  State<ProductsBody> createState() => _ProductsBodyState();
}

class _ProductsBodyState extends State<ProductsBody> {
  List<Products>? products;
  final searchController = TextEditingController();
  final moneySymbol = '\$';
  bool isChecked = false;
  bool isDescending = false;

  @override
  void initState() {
    super.initState();
    products = widget.listOfProducts;
  }

  // Esta funcion se llama cada vez que el text field cambia
  void _searchProduct(String query) {
    List<Products>? suggestions = [];
    // si la barra de busqueda esta vacia o solo contiene espacios vacios,
    // se hara display de todos los items
    if (query.isEmpty) {
      suggestions = widget.listOfProducts;
    } else {
      suggestions = widget.listOfProducts
          ?.where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    // Refrescar la UI
    setState(() => products = suggestions);
  }

  @override
  Widget build(BuildContext context) {
    // print(products);
    final qualitiesSummary =
        Provider.of<QualitySummary?>(context)?.summary ?? {};
    final categoriesSummary =
        Provider.of<CategorieSummary?>(context)?.summary ?? {};
    final designsSummary = Provider.of<DesignSummary?>(context)?.summary ?? {};
    final linesSummary = Provider.of<LineSummary?>(context)?.summary ?? {};
    final brandsSummary = Provider.of<BrandSummary?>(context)?.summary ?? {};
    final subCategoriesSummary =
        Provider.of<SubCategorieSummary?>(context)?.summary ?? {};
    final sizesSummary = Provider.of<SizeSummary?>(context)?.summary ?? {};
    final stockValues = Provider.of<StockModel?>(context)?.stock ?? {};
    return SingleChildScrollView(
      child: Column(
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
              onChanged: _searchProduct,
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
                  onPressed: () {
                    // Re ordenar el list view alfabeticamente
                    setState(() => isDescending = !isDescending);
                  },
                ),
                // IconButton(
                //   icon: Icon(
                //     MaterialCommunityIcons.filter_variant,
                //     color: Colors.grey.shade500,
                //     size: 25,
                //   ),
                //   splashRadius: 15,
                //   onPressed: () {
                //     // Abrir si se quiere ver por prospecto o no
                //     Fluttertoast.showToast(
                //       msg:
                //           'Boton para re-ordenar la lista en orden ascendente y descendente',
                //       textColor: Colors.white,
                //       backgroundColor: myTheme.colorScheme.primary,
                //     );
                //   },
                // ),
              ],
            ),
          ),
          Container(
            // margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.67,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: products?.length,
              itemBuilder: (BuildContext context, index) {
                // Valores dentro de los resumenes
                //TODO: Revisar el cambio de orden para el filtro
                final sortedProducts =
                    isDescending ? products?.reversed.toList() : products;
                final product = sortedProducts![index];
                // final product = products![index];
                final productStock = stockValues[product.code] ?? 'NaN';
                final productBrand = brandsSummary[product.brand] ?? 'NaN';
                final productCategorie =
                    categoriesSummary[product.categorie] ?? 'NaN';
                final productSubCategorie =
                    subCategoriesSummary[product.subCategorie] ?? 'NaN';
                final productLine = linesSummary[product.line] ?? 'NaN';
                final productQuality =
                    qualitiesSummary[product.quality] ?? 'NaN';
                final productSize = sizesSummary[product.size] ?? 'NaN';
                final productDesign = designsSummary[product.design] ?? 'NaN';

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
                                message: productStock,
                              ),
                              TextFieldForCard(
                                message: '$moneySymbol 00.00',
                              ),
                              TextFieldForCard(
                                message: productBrand,
                              ),
                              TextFieldForCard(
                                message: productCategorie,
                              ),
                              TextFieldForCard(
                                message: productSubCategorie,
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
                                message: productLine,
                              ),
                              TextFieldForCard(
                                message: productQuality,
                              ),
                              TextFieldForCard(
                                message: productSize,
                              ),
                              TextFieldForCard(
                                message: productDesign,
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
      ),
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
      '$message',
      style: TextStyle(
        fontFamily: 'Poppins-regular',
        fontSize: 11,
        fontWeight: bold,
      ),
    );
  }
}
