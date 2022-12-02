// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({
    Key? key,
    this.listOfProducts,
    this.listOfPrices,
    this.isOrderActive,
  }) : super(key: key);

  final List<Products>? listOfProducts;
  final listOfPrices;
  final isOrderActive;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarNavigation(
        message: AppLocalizations.of(context)!.products,
        isOrderActive: widget.isOrderActive,
      ),
      backgroundColor: myTheme.colorScheme.surface,
      body: MultiProvider(
        providers: [
          StreamProvider<QualitySummary?>.value(
            value: DatabaseServiceStreams().qualitySummary,
            initialData: null,
            catchError: (context, error) {
              // print(error);
              return;
            },
          ),
          StreamProvider<CategorieSummary?>.value(
            value: DatabaseServiceStreams().categorieSummary,
            initialData: null,
            catchError: (context, error) {
              // print(error);
              return;
            },
          ),
          StreamProvider<DesignSummary?>.value(
            value: DatabaseServiceStreams().designSummary,
            initialData: null,
            catchError: (context, error) {
              // print(error);
              return;
            },
          ),
          StreamProvider<LineSummary?>.value(
            value: DatabaseServiceStreams().lineSummary,
            initialData: null,
            catchError: (context, error) {
              // print(error);
              return;
            },
          ),
          StreamProvider<BrandSummary?>.value(
            value: DatabaseServiceStreams().brandSummary,
            initialData: null,
            catchError: (context, error) {
              // print(error);
              return;
            },
          ),
          StreamProvider<SubCategorieSummary?>.value(
            value: DatabaseServiceStreams().subCategorieSummary,
            initialData: null,
            catchError: (context, error) {
              // print(error);
              return;
            },
          ),
          StreamProvider<SizeSummary?>.value(
            value: DatabaseServiceStreams().sizeSummary,
            initialData: null,
            catchError: (context, error) {
              // print(error);
              return;
            },
          ),
          StreamProvider<StockModel?>.value(
            value: DatabaseServiceStreams().stockValues,
            initialData: null,
            catchError: (context, error) {
              // print(error);
              return;
            },
          ),
        ],
        child: ProductsBody(
          listOfProducts: widget.listOfProducts,
          listOfPrices: widget.listOfPrices,
          isOrderActive: widget.isOrderActive,
        ),
      ),
    );
  }
}

class ProductsBody extends StatefulWidget {
  const ProductsBody({
    Key? key,
    this.listOfProducts,
    this.listOfPrices,
    required this.isOrderActive,
  }) : super(key: key);

  final List<Products>? listOfProducts;
  final listOfPrices;
  final bool isOrderActive;

  @override
  State<ProductsBody> createState() => _ProductsBodyState();
}

class _ProductsBodyState extends State<ProductsBody> {
  final searchController = TextEditingController();
  List<ShoppingCartProduct> selectedProducts = [];
  List<Products>? products;

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

  final String? currentCoin =
      sharedPreferences!.getString('currentCoin') ?? 'Dolares - USD';

  priceFormat(productPrice) {
    if (currentCoin!.contains('USD') || currentCoin == null) {
      return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
          .format(productPrice)
          .toString();
    } else if (currentCoin!.contains('VED')) {
      return NumberFormat.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: "Bs.",
      ).format(productPrice * 4.58).toString();
    } else if (currentCoin!.contains('EUR')) {
      return NumberFormat.currency(
        locale: 'es_ES',
        decimalDigits: 2,
        symbol: '€',
        customPattern: '\u00a4 #,##.#',
      ).format(productPrice * 0.89).toString();
    } else if (currentCoin!.contains('MXN')) {
      return NumberFormat.currency(
        locale: 'es_MX',
        decimalDigits: 2,
        symbol: '\$',
        customPattern: '\u00a4 #,##.#',
      ).format(productPrice * 0.89);
    } else if (currentCoin!.contains('BTC')) {
      return '฿ ${(productPrice * 0.00011).toString()}';
    } else {
      return NumberFormat.currency(
        locale: 'es_VE',
        decimalDigits: 2,
        symbol: "PPR.",
      ).format(productPrice * 4.58).toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});

    final userCharge = sharedPreferences!.getString('cargo');
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

    return Scaffold(
      backgroundColor: myTheme.colorScheme.surface,
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: [
          if (selectedProducts.isEmpty)
            Container()
          else if (selectedProducts.isNotEmpty && widget.isOrderActive == true)
            Container(
              height: 70,
              width: 70,
              margin: const EdgeInsets.all(10.0),
              child: FloatingActionButton(
                elevation: 2,
                backgroundColor: myTheme.colorScheme.primary,
                onPressed: () {
                  // Agregar productos al carrito

                  objectBox.insertManyShoppingCartProducts(selectedProducts);
                  Fluttertoast.showToast(
                      msg: 'Productos Añadidos exitosamente');
                },
                child: Icon(
                  Icons.add_shopping_cart_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
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
                textCapitalization: TextCapitalization.sentences,
                controller: searchController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.fromLTRB(14, 0, 0, 0),
                  hintText: AppLocalizations.of(context)!.searchProductName,
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
                mainAxisAlignment: MainAxisAlignment.start,
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
                          isDescending
                              ? AppLocalizations.of(context)!.ascendingFilter
                              : AppLocalizations.of(context)!.descendingFilter,
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
                ],
              ),
            ),
            Container(
              // margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.74,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: products?.length,
                itemBuilder: (BuildContext context, index) {
                  // Valores dentro de los resumenes
                  final sortedProducts =
                      isDescending ? products?.reversed.toList() : products;
                  final product = sortedProducts![index];
                  // final product = products![index];
                  final productStock = stockValues[product.code] ?? 000;
                  final productBrand = brandsSummary[product.brand] ?? '';
                  final productCategorie =
                      categoriesSummary[product.categorie] ?? '';
                  final productSubCategorie =
                      subCategoriesSummary[product.subCategorie] ?? '';
                  final productLine = linesSummary[product.line] ?? '';
                  final productQuality =
                      qualitiesSummary[product.quality] ?? '';
                  final productSize = sizesSummary[product.size] ?? '';
                  final productDesign = designsSummary[product.design] ?? '';
                  final productPrice = widget.listOfPrices[product.code] ?? 0;
                  final priceProduct = priceFormat(productPrice);

                  // final productPriceFormatted = priceFormat(productPrice);

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
                        if (product.selected == false) {
                          if (productStock > 0) {
                            final newProduct = ShoppingCartProduct(
                              productQuantity: 1,
                              code: product.code.toString(),
                              productId: product.code.toString(),
                              listOfPricesId: widget.listOfPrices.toString(),
                              totalAmount: productPrice.toString(),
                              name: product.name,
                              unitPrice: productPrice.toString(),
                              availableStock: productStock,
                            );

                            print(newProduct.unitPrice);
                            setState(
                                () => product.selected = !product.selected);
                            selectedProducts.add(newProduct);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    'No hay stock disponible de este producto');
                          }
                        } else if (product.selected == true) {
                          setState(() => product.selected = !product.selected);
                          selectedProducts
                              .removeWhere((item) => item.code == product.code);
                        }
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
                                if (widget.isOrderActive == true ||
                                    userCharge == 'Administrador' ||
                                    userCharge == 'Gerente')
                                  Container(
                                    height: 17,
                                    width: 17,
                                    margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.grey.shade400,
                                    ),
                                    child: Checkbox(
                                        side:
                                            MaterialStateBorderSide.resolveWith(
                                                (states) => BorderSide(
                                                    width: 1.0,
                                                    color: Colors.transparent)),
                                        shape: CircleBorder(),
                                        activeColor:
                                            myTheme.colorScheme.primary,
                                        value: product.selected,
                                        onChanged: (value) {
                                          if (product.selected == false) {
                                            final newProduct =
                                                ShoppingCartProduct(
                                              productQuantity: 1,
                                              code: product.code.toString(),
                                              productId:
                                                  product.code.toString(),
                                              listOfPricesId: widget
                                                  .listOfPrices
                                                  .toString(),
                                              totalAmount:
                                                  productPrice.toString(),
                                              name: product.name,
                                              unitPrice:
                                                  productPrice.toString(),
                                              availableStock: productStock,
                                            );
                                            print(newProduct.unitPrice);
                                            // print(newProduct.totalAmount);
                                            selectedProducts.add(newProduct);
                                          } else if (product.selected == true) {
                                            selectedProducts.removeWhere(
                                                (item) =>
                                                    item.code == product.code);
                                          }
                                          setState(
                                              () => product.selected = value!);
                                        }),
                                  ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 90,
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
                                  message:
                                      '${AppLocalizations.of(context)!.productCode}:',
                                  bold: FontWeight.bold,
                                ),
                                TextFieldForCard(
                                  message:
                                      '${AppLocalizations.of(context)!.stock}:',
                                  bold: FontWeight.bold,
                                ),
                                TextFieldForCard(
                                  message:
                                      '${AppLocalizations.of(context)!.price}:',
                                  bold: FontWeight.bold,
                                ),
                                TextFieldForCard(
                                  message:
                                      '${AppLocalizations.of(context)!.productBrand}:',
                                  bold: FontWeight.bold,
                                ),
                                TextFieldForCard(
                                  message:
                                      '${AppLocalizations.of(context)!.productCategorie}:',
                                  bold: FontWeight.bold,
                                ),
                                TextFieldForCard(
                                  message:
                                      '${AppLocalizations.of(context)!.productSubCategorie}:',
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
                                  message: priceProduct,
                                  // '',
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
                                  message:
                                      '${AppLocalizations.of(context)!.productLine}:',
                                  bold: FontWeight.bold,
                                ),
                                TextFieldForCard(
                                  message:
                                      '${AppLocalizations.of(context)!.productQuality}:',
                                  bold: FontWeight.bold,
                                ),
                                TextFieldForCard(
                                  message:
                                      '${AppLocalizations.of(context)!.productSize}:',
                                  bold: FontWeight.bold,
                                ),
                                TextFieldForCard(
                                  message:
                                      '${AppLocalizations.of(context)!.productDesign}:',
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
