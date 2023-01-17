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
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({
    Key? key,
    this.listOfProducts,
    this.listOfPrices,
    this.userZoneDocument,
    this.showFullList,
  }) : super(key: key);

  final listOfProducts;
  final listOfPrices;
  final userZoneDocument;
  final bool? showFullList;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    // print(widget.listOfProducts?.length);

    return Scaffold(
      appBar: AppBarNavigation(
        message: AppLocalizations.of(context)!.products,
        userZoneDocument: widget.userZoneDocument,
      ),
      backgroundColor: myTheme.colorScheme.surface,
      body: MultiProvider(
        providers: [
          StreamProvider<QualitySummary?>.value(
            value: DatabaseServiceStreams().qualitySummary,
            initialData: null,
            catchError: (context, error) {
              return;
            },
          ),
          StreamProvider<CategorieSummary?>.value(
            value: DatabaseServiceStreams().categorieSummary,
            initialData: null,
            catchError: (context, error) {
              return;
            },
          ),
          StreamProvider<DesignSummary?>.value(
            value: DatabaseServiceStreams().designSummary,
            initialData: null,
            catchError: (context, error) {
              return;
            },
          ),
          StreamProvider<LineSummary?>.value(
            value: DatabaseServiceStreams().lineSummary,
            initialData: null,
            catchError: (context, error) {
              return;
            },
          ),
          StreamProvider<BrandSummary?>.value(
            value: DatabaseServiceStreams().brandSummary,
            initialData: null,
            catchError: (context, error) {
              return;
            },
          ),
          StreamProvider<SubCategorieSummary?>.value(
            value: DatabaseServiceStreams().subCategorieSummary,
            initialData: null,
            catchError: (context, error) {
              return;
            },
          ),
          StreamProvider<SizeSummary?>.value(
            value: DatabaseServiceStreams().sizeSummary,
            initialData: null,
            catchError: (context, error) {
              return;
            },
          ),
          StreamProvider<StockModel?>.value(
            value: DatabaseServiceStreams().stockValues,
            initialData: null,
            catchError: (context, error) {
              return;
            },
          ),
        ],
        child: ProductsBody(
          listOfProducts: widget.listOfProducts,
          listOfPrices: widget.listOfPrices,
          showFullList: widget.showFullList,
        ),
      ),
    );
  }
}

class ProductsBody extends StatefulWidget {
  ProductsBody({
    Key? key,
    this.listOfProducts,
    this.listOfPrices,
    this.showFullList,
  }) : super(key: key);

  final listOfProducts;
  final listOfPrices;
  final bool? showFullList;

  @override
  State<ProductsBody> createState() => _ProductsBodyState();
}

class _ProductsBodyState extends State<ProductsBody> {
  final searchController = TextEditingController();
  List<ShoppingCartProduct> selectedProducts = [];
  final _controller = ScrollController();
  List<Products> filteredProducts = [];

  // List<Products>? products;

  bool isChecked = false;
  bool isDescending = false;

  @override
  void initState() {
    super.initState();
    // products = widget.listOfProducts;
    _controller.addListener(() {
      final productsLimitProvider =
          Provider.of<CounterLimitFirestore>(context, listen: false);
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          print('Top products page');
        } else {
          if (productsLimitProvider.getScrollProductLimit == 0) {
            productsLimitProvider.setProductsLimit(0, 0);
          } else {
            int newValor = int.parse(
                productsLimitProvider.getScrollProductLimit.toString());
            if (newValor == 10) {
              productsLimitProvider.setProductsLimit(
                  productsLimitProvider.getProductsLimit + newValor, 10);
            } else if (newValor == 50) {
              productsLimitProvider.setProductsLimit(
                  productsLimitProvider.getProductsLimit + newValor, 50);
            }
          }
          print('Bottom products page');
        }
      }
    });
  }

  // // Esta funcion se llama cada vez que el text field cambia
  // void _searchProduct(String query) {
  //   List<Products>? suggestions = [];
  //   // si la barra de busqueda esta vacia o solo contiene espacios vacios,
  //   // se hara display de todos los items
  //   if (query.isEmpty) {
  //     suggestions = widget.listOfProducts;
  //   } else {
  //     suggestions = widget.listOfProducts
  //         ?.where((product) =>
  //             product.name.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   }
  //   // Refrescar la UI
  //   setState(() => products = suggestions);
  // }

  // Future

  final List<String> items = ['10', '50', 'Todos'];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final orderActive = Provider.of<OrderProvider>(context);

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
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    final productsLimit =
        Provider.of<CounterLimitFirestore>(context).getProductsLimit;
    final productsScrollLimit =
        Provider.of<CounterLimitFirestore>(context).getScrollProductLimit;

    final products = Provider.of<List<Products>?>(context) ?? [];
    // print(widget.listOfProducts.length ?? 0);

    priceFormat(productPrice) {
      double correctAmount = double.parse(productPrice.toStringAsFixed(2));
      if (currentCoin!.contains('USD')) {
        return NumberFormat.simpleCurrency(locale: 'en-US', decimalDigits: 2)
            .format(productPrice)
            .toString();
      } else if (currentCoin.contains('VED')) {
        return NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "Bs.",
        ).format(correctAmount * 4.58).toString();
      } else if (currentCoin.contains('EUR')) {
        return NumberFormat.currency(
          locale: 'es_ES',
          decimalDigits: 2,
          symbol: '€',
        ).format(correctAmount * 0.89).toString();
      } else if (currentCoin.contains('MXN')) {
        return NumberFormat.currency(
          locale: 'es_MX',
          decimalDigits: 2,
          symbol: '\$',
        ).format(correctAmount * 19.43);
      } else if (currentCoin.contains('BTC')) {
        return '฿ ${(correctAmount * 0.00011).toString()}';
      } else {
        return NumberFormat.currency(
          locale: 'es_VE',
          decimalDigits: 2,
          symbol: "PPR.",
        ).format(correctAmount * 4.58).toString();
      }
    }

    print(filteredProducts.length);

    return Scaffold(
      backgroundColor: myTheme.colorScheme.surface,
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        children: [
          if (selectedProducts.isEmpty)
            Container()
          else if (selectedProducts.isNotEmpty &&
              orderActive.orderActive == true)
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
                child: const Icon(
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
            // Text(filteredProducts.length.toString()),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                style: const TextStyle(
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
                  contentPadding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                  hintText: AppLocalizations.of(context)!.searchProductCode,
                  // AppLocalizations.of(context)!.searchProductName,
                  hintStyle: const TextStyle(
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
                textInputAction: TextInputAction.go,
                onChanged: ((value) {
                  if (value.isEmpty) {
                    filteredProducts.clear();
                  }
                }),
                onSubmitted: ((value) async {
                  print(value);
                  filteredProducts.clear();
                  await productsCollection
                      .where('codigoIndice',
                          arrayContains: value.toString().toLowerCase())
                      .snapshots()
                      .forEach((element) {
                    for (var element in element.docs) {
                      Products product = Products(
                        quality: element.data()['calidad'].id,
                        catalogue: element.data()['catalogo'].id,
                        categorie: element.data()['categoria'].id,
                        code: element.data()['codigo'],
                        design: element.data()['diseno'].id,
                        line: element.data()['linea'].id,
                        brand: element.data()['marca'].id,
                        lastModifiedDate: element.data()['modificado'],
                        name: element.data()['nombre'],
                        subCategorie: element.data()['subcategoria'].id,
                        size: element.data()['tamano'].id,
                        promotion:
                            element.data().toString().contains('promocion')
                                ? element.data()['promocion'].id
                                : '',
                        selected: false,
                        // quality: 'test',
                        // catalogue: 'test',
                        // categorie: 'test',
                        // code: 'test',
                        // design: 'test',
                        // line: 'test',
                        // brand: 'test',
                        // lastModifiedDate: 'test',
                        // name: 'test',
                        // subCategorie: 'test',
                        // size: 'test',
                        // promotion: 'test',
                        // // element.data().toString().contains('promocion')
                        // //     ? element.data()['promocion'].id
                        // //     : '',
                        // selected: false,
                      );
                      setState(() {
                        filteredProducts.add(product);
                      });
                    }
                  });
                  // filteredProducts.clear();
                  // setState(() {
                  //   filteredProducts = newList;
                  // });
                  // print(filteredProducts);
                }),
                // onChanged: ((value) => print(value)),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20.0, 5.0, 0, 0),
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
                        const SizedBox(width: 5),
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
                  const SizedBox(width: 20),
                  widget.showFullList == true
                      ? DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            hint: Text(
                              selectedValue == null
                                  ? productsLimit == 0
                                      ? 'Todos'
                                      : '$productsScrollLimit'
                                  : selectedValue.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: items
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: selectedValue,
                            onChanged: (value) {
                              final productsLimitProvider =
                                  Provider.of<CounterLimitFirestore>(context,
                                      listen: false);
                              setState(() {
                                selectedValue = value as String;
                              });
                              if (selectedValue == 'Todos') {
                                productsLimitProvider.setProductsLimit(0, 0);
                              } else {
                                int newValor =
                                    int.parse(selectedValue.toString());
                                if (newValor == 10) {
                                  productsLimitProvider.setProductsLimit(
                                      newValor, 10);
                                } else if (newValor == 50) {
                                  productsLimitProvider.setProductsLimit(
                                      newValor, 50);
                                }
                              }
                            },
                            buttonHeight: 40,
                            buttonWidth: 140,
                            itemHeight: 40,
                            // dropdownElevation: 20,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            // Text(
            //   // 'Products actuales: ${widget.listOfProducts?.length ?? 'vacio'}'
            //   'Productos acutales: ${widget.showFullList == true ? products.length : widget.listOfProducts?.length}',
            // ),
            filteredProducts.isEmpty
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.74,
                    child: ListView.builder(
                      controller: _controller,
                      physics: const BouncingScrollPhysics(),
                      itemCount: widget.showFullList == true
                          ? products.length
                          : widget.listOfProducts?.length,
                      itemBuilder: (BuildContext context, index) {
                        final sortedProducts = isDescending
                            ? widget.showFullList == true
                                ? products.reversed.toList()
                                : widget.listOfProducts?.reversed.toList()
                            : widget.showFullList == true
                                ? products
                                : widget.listOfProducts;
                        final product = sortedProducts![index];
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
                        final productDesign =
                            designsSummary[product.design] ?? '';
                        final productPrice =
                            widget.listOfPrices[product.code] ?? 0;
                        final priceProduct = priceFormat(productPrice);
                        // if (productStock > 0) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
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
                                    listOfPricesId:
                                        widget.listOfPrices.toString(),
                                    totalAmount: productPrice.toString(),
                                    name: product.name,
                                    unitPrice: productPrice.toString(),
                                    availableStock: productStock,
                                    urlPicture: product.catalogue.toString(),
                                  );
                                  setState(() =>
                                      product.selected = !product.selected);
                                  selectedProducts.add(newProduct);
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          'No hay stock disponible de este producto');
                                }
                              } else if (product.selected == true) {
                                setState(
                                    () => product.selected = !product.selected);
                                selectedProducts.removeWhere(
                                    (item) => item.code == product.code);
                              }
                            },
                            title: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // if (orderActive.orderActive == true ||
                                      //     userCharge == 'Administrador' ||
                                      //     userCharge == 'Gerente')
                                      Container(
                                        height: 17,
                                        width: 17,
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.grey.shade400,
                                        ),
                                        child: Checkbox(
                                            side: MaterialStateBorderSide
                                                .resolveWith((states) =>
                                                    const BorderSide(
                                                        width: 1.0,
                                                        color: Colors
                                                            .transparent)),
                                            shape: const CircleBorder(),
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
                                                  urlPicture: product.catalogue,
                                                );
                                                selectedProducts
                                                    .add(newProduct);
                                              } else if (product.selected ==
                                                  true) {
                                                selectedProducts.removeWhere(
                                                    (item) =>
                                                        item.code ==
                                                        product.code);
                                              }
                                              setState(() =>
                                                  product.selected = value!);
                                            }),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        child: TextFieldForCard(
                                          message: product.name,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFieldForCard(
                                        message: product.code,
                                      ),
                                      TextFieldForCard(
                                        message: productStock,
                                      ),
                                      TextFieldForCard(
                                        message: priceProduct,
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
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                        // } else {
                        //   return Container();
                        // }
                      },
                    ),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.74,
                    child: ListView.builder(
                      controller: _controller,
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredProducts.length,
                      itemBuilder: (BuildContext context, index) {
                        final sortedProducts = isDescending
                            ? filteredProducts.reversed.toList()
                            : filteredProducts;
                        final product = sortedProducts![index];
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
                        final productDesign =
                            designsSummary[product.design] ?? '';
                        final productPrice =
                            widget.listOfPrices[product.code] ?? 0;
                        final priceProduct = priceFormat(productPrice);
                        // if (productStock > 0) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
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
                                    listOfPricesId:
                                        widget.listOfPrices.toString(),
                                    totalAmount: productPrice.toString(),
                                    name: product.name,
                                    unitPrice: productPrice.toString(),
                                    availableStock: productStock,
                                    urlPicture: product.catalogue.toString(),
                                  );
                                  setState(() =>
                                      product.selected = !product.selected);
                                  selectedProducts.add(newProduct);
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          'No hay stock disponible de este producto');
                                }
                              } else if (product.selected == true) {
                                setState(
                                    () => product.selected = !product.selected);
                                selectedProducts.removeWhere(
                                    (item) => item.code == product.code);
                              }
                            },
                            title: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // if (orderActive.orderActive == true ||
                                      //     userCharge == 'Administrador' ||
                                      //     userCharge == 'Gerente')
                                      Container(
                                        height: 17,
                                        width: 17,
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.grey.shade400,
                                        ),
                                        child: Checkbox(
                                            side: MaterialStateBorderSide
                                                .resolveWith((states) =>
                                                    const BorderSide(
                                                        width: 1.0,
                                                        color: Colors
                                                            .transparent)),
                                            shape: const CircleBorder(),
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
                                                  urlPicture: product.catalogue,
                                                );
                                                selectedProducts
                                                    .add(newProduct);
                                              } else if (product.selected ==
                                                  true) {
                                                selectedProducts.removeWhere(
                                                    (item) =>
                                                        item.code ==
                                                        product.code);
                                              }
                                              setState(() =>
                                                  product.selected = value!);
                                            }),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        child: TextFieldForCard(
                                          message: product.name,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFieldForCard(
                                        message: product.code,
                                      ),
                                      TextFieldForCard(
                                        message: productStock,
                                      ),
                                      TextFieldForCard(
                                        message: priceProduct,
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
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                        // } else {
                        //   return Container();
                        // }
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
