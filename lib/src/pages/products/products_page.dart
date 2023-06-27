// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/product_details/product_details.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({
    Key? key,
    this.listOfProducts,
    this.listOfPrices,
    this.userZoneDocument,
    this.showFullList,
    this.pricesName,
  }) : super(key: key);

  final listOfProducts;
  final listOfPrices;
  final userZoneDocument;
  final pricesName;
  final bool? showFullList;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;
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
          StreamProvider<Coin?>.value(
            initialData: Coin(),
            catchError: (context, error) {
              print(
                  'ERROR ON STREAM PROVIDER OF COINEXCHANGE RATES IN ADD CLIENT');
              print(error);
              return;
            },
            value: coinCollection
                .doc(currentCoinSelectedCode)
                .snapshots()
                .map(coinFromSnapshot),
          ),
        ],
        child: ProductsBody(
          listOfProducts: widget.listOfProducts,
          listOfPrices: widget.listOfPrices,
          showFullList: widget.showFullList,
          userZoneDocument: widget.userZoneDocument,
          pricesName: widget.pricesName,
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
    this.userZoneDocument,
    this.pricesName,
  }) : super(key: key);

  final listOfProducts;
  final listOfPrices;
  final bool? showFullList;
  final userZoneDocument;
  final pricesName;

  @override
  State<ProductsBody> createState() => _ProductsBodyState();
}

class _ProductsBodyState extends State<ProductsBody> {
  final searchController = TextEditingController();
  final _controller = ScrollController();
  List<ShoppingCartProduct> selectedProducts = [];
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
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: myTheme.colorScheme.primary,
                  duration: const Duration(seconds: 1),
                  content: Text(
                    "Cargando $newValor productos adicionales",
                    style: const TextStyle(
                      fontFamily: 'Poppins-regular',
                    ),
                  ),
                ),
              );

            print('Bottom products page');
          }
        }
      }
    });
  }

  final List<String> items = ['10', '50', '100'];
  String? selectedValue;

  //Test
  String? phosTest = 'Phos';
  //Test

  @override
  Widget build(BuildContext context) {
    // Orden activa
    final orderActive = Provider.of<OrderProvider>(context);
    // Resumenes
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
    // Moneda actual
    final coinName = Provider.of<Coin?>(context)?.name ?? '';
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 0;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';
    final coinCode = Provider.of<Coin?>(context)?.code ?? '';
    // Scroll limits
    final productsLimit =
        Provider.of<CounterLimitFirestore>(context).getProductsLimit;
    final productsScrollLimit =
        Provider.of<CounterLimitFirestore>(context).getScrollProductLimit;
    // Produtos
    final products = Provider.of<List<Products>?>(context) ?? [];

    return coinName.toString().isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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

                        objectBox
                            .insertManyShoppingCartProducts(selectedProducts);
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              backgroundColor: myTheme.colorScheme.primary,
                              duration: const Duration(seconds: 1),
                              content: const Text(
                                "Productos añadidos exitosamente",
                                style: TextStyle(
                                  fontFamily: 'Poppins-regular',
                                ),
                              ),
                            ),
                          );
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TEST
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(8, 16, 0, 0),
                        height: 40,
                        width: 200,
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
                            filled: true,
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.fromLTRB(14, 0, 0, 0),
                            hintText:
                                AppLocalizations.of(context)!.searchProductCode,
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 12,
                              color: Color(0xFF5A5D77),
                            ),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.5),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: myTheme.colorScheme.primary
                                    .withOpacity(0.5),
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.go,
                          onChanged: ((value) {
                            if (value.isEmpty) {
                              setState(() {
                                filteredProducts.clear();
                              });
                            }
                          }),
                          onSubmitted: ((value) async {
                            print(value);
                            filteredProducts.clear();
                            await productsCollection
                                .where('codigoIndice',
                                    arrayContains:
                                        value.toString().toLowerCase())
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
                                  lastModifiedDate:
                                      element.data()['modificado'],
                                  name: element.data()['nombre'],
                                  subCategorie:
                                      element.data()['subcategoria'].id,
                                  size: element.data()['tamano'].id,
                                  promotion: element
                                          .data()
                                          .toString()
                                          .contains('promocion')
                                      ? element.data()['promocion'].id
                                      : '',
                                  selected: false,
                                );
                                setState(() {
                                  filteredProducts.add(product);
                                });
                              }
                            });
                          }),
                          // onChanged: ((value) => print(value)),
                        ),
                      ),
                      Container(
                        margin: widget.showFullList == true
                            ? EdgeInsets.fromLTRB(4, 16, 0, 0)
                            : EdgeInsets.fromLTRB(4, 16, 0, 8),
                        height: 40,
                        width: 68,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFDFE0FF)),
                        child: IconButton.filled(
                          onPressed: () =>
                              setState(() => isDescending = !isDescending),
                          icon: isDescending
                              ? Icon(
                                  MaterialCommunityIcons
                                      .sort_alphabetical_descending,
                                  color: myTheme.colorScheme.onPrimaryContainer,
                                )
                              : Icon(
                                  MaterialCommunityIcons
                                      .sort_alphabetical_ascending,
                                  color: myTheme.colorScheme.onPrimaryContainer,
                                ),
                        ),
                      ),
                      Container(
                        margin: widget.showFullList == true
                            ? EdgeInsets.fromLTRB(4, 16, 0, 0)
                            : EdgeInsets.fromLTRB(4, 16, 0, 8),
                        height: 40,
                        width: 68,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Color(0xFFDFE0FF)),
                        child: IconButton(
                          onPressed: () async {
                            // Filtro avanzado de productos
                            List<String> selectedValues = [];
                            String? selectedCategorie;
                            String? selectedSubCategorie;
                            String? selectedLine;
                            String? selectedQuality;
                            String? selectedSize;
                            String? combinationKeyForSubCategories;
                            String? combinationKeyForLines;
                            Map<String, dynamic> summaryDataCategories = {};
                            List<String> categoriesKeys = [];
                            List<String> categoriesValues = [];
                            Map<String, dynamic> combinationsDataSubCategories =
                                {};
                            Map<String, dynamic> summarysDataSubCategories = {};
                            List<String> subCategoriesValues = [];
                            Map<String, dynamic> combinationsDataLines = {};
                            Map<String, dynamic> summarysDataLines = {};
                            List<String> linesValues = [];
                            List<String> linesKeys = [];
                            Map<String, dynamic> summarysDataQuality = {};
                            Map<String, dynamic> summarysDataSize = {};
                            List<String> sizeList = [];
                            List<String> qualityList = [];

                            await subCategoriesCollection
                                .doc('resumen')
                                .get()
                                .then(
                              (value) {
                                summaryDataCategories =
                                    value.data().toString().contains('nombres')
                                        ? value.get('nombres')
                                        : {'n/a': 'n/a'};
                                summaryDataCategories.entries.forEach((name) {
                                  categoriesKeys.add(name.key);
                                  categoriesValues.add(name.value);
                                });
                              },
                            );

                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => StatefulBuilder(
                                builder: (BuildContext context, setState) {
                                  return Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AlertDialog(
                                          scrollable: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          title: Text('Filtro de productos'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // Selecciona de las sub-categorias
                                                // de la DB
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 10, 0, 10),
                                                  child: Text('Categoria'),
                                                ),
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    items: categoriesValues
                                                        .map((categorie) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: categorie,
                                                              child: Text(
                                                                categorie,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: selectedCategorie,
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        selectedCategorie =
                                                            value as String;
                                                      });

                                                      setState(() {
                                                        selectedSubCategorie =
                                                            null;
                                                        selectedLine = null;
                                                        selectedQuality = null;
                                                        selectedSize = null;
                                                        combinationsDataSubCategories
                                                            .clear();
                                                        summarysDataSubCategories
                                                            .clear();
                                                        subCategoriesValues
                                                            .clear();
                                                        combinationsDataLines
                                                            .clear();
                                                        summarysDataLines
                                                            .clear();
                                                        linesValues.clear();
                                                        linesKeys.clear();
                                                        summarysDataQuality
                                                            .clear();
                                                        qualityList.clear();
                                                        summarysDataSize
                                                            .clear();
                                                        sizeList.clear();
                                                      });

                                                      summaryDataCategories
                                                          .entries
                                                          .forEach((name) {
                                                        if (name.value ==
                                                            selectedCategorie!) {
                                                          setState(() {
                                                            combinationKeyForSubCategories =
                                                                name.key
                                                                    .toString();
                                                          });
                                                        }
                                                      });
                                                      print(
                                                          'Categoria seleccionada');
                                                      print(selectedCategorie);
                                                      print('Combinacion');
                                                      print(
                                                          combinationKeyForSubCategories);

                                                      await categoriesCollection
                                                          .doc('resumen')
                                                          .get()
                                                          .then((value) {
                                                        setState(
                                                          () {
                                                            summarysDataSubCategories = value
                                                                    .data()
                                                                    .toString()
                                                                    .contains(
                                                                        'nombres')
                                                                ? value.get(
                                                                    'nombres')
                                                                : {
                                                                    'n/a': 'n/a'
                                                                  };
                                                            combinationsDataSubCategories = value
                                                                    .data()
                                                                    .toString()
                                                                    .contains(
                                                                        'Combinaciones')
                                                                ? value.get(
                                                                    'Combinaciones')
                                                                : {
                                                                    'n/a': [
                                                                      'n/a',
                                                                      'n/a'
                                                                    ],
                                                                  };
                                                          },
                                                        );
                                                      });

                                                      // selectedValues.add(summaryDataCategories)
                                                    },
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14,
                                                              right: 14),
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.5),
                                                        ),
                                                        color: myTheme
                                                            .colorScheme
                                                            .background,
                                                      ),
                                                      // elevation: 0,
                                                    ),
                                                    menuItemStyleData:
                                                        const MenuItemStyleData(
                                                      height: 40,
                                                    ),
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.5),
                                                        ),
                                                        // color: myTheme
                                                        //     .colorScheme.primary
                                                        //     .withOpacity(0.5),
                                                      ),
                                                      elevation: 1,
                                                      offset:
                                                          const Offset(0, 0),
                                                      scrollbarTheme:
                                                          ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(40),
                                                        thickness:
                                                            MaterialStateProperty
                                                                .all(6),
                                                        thumbVisibility:
                                                            MaterialStateProperty
                                                                .all(true),
                                                      ),
                                                    ),
                                                    iconStyleData:
                                                        IconStyleData(
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                      ),
                                                      iconSize: 14,
                                                      iconEnabledColor: myTheme
                                                          .colorScheme.primary,
                                                      iconDisabledColor:
                                                          Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                // Selecciona de las categorias
                                                // de la DB
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 10, 0, 10),
                                                  child: Text('Tipo'),
                                                ),
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    items: List<String>.from(
                                                            combinationsDataSubCategories[
                                                                    combinationKeyForSubCategories] ??
                                                                subCategoriesValues)
                                                        .map((subCategorie) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value:
                                                                  subCategorie,
                                                              child: Text(
                                                                summarysDataSubCategories[
                                                                    subCategorie],
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: selectedSubCategorie,
                                                    onChanged: selectedCategorie ==
                                                                null ||
                                                            combinationsDataSubCategories
                                                                .isEmpty
                                                        ? null
                                                        : (value) async {
                                                            setState(() {
                                                              selectedSubCategorie =
                                                                  value
                                                                      as String;
                                                              combinationKeyForLines =
                                                                  '$combinationKeyForSubCategories+$selectedSubCategorie';
                                                            });
                                                            setState(() {
                                                              selectedLine =
                                                                  null;
                                                              selectedQuality =
                                                                  null;
                                                              selectedSize =
                                                                  null;
                                                              combinationsDataLines
                                                                  .clear();
                                                              summarysDataLines
                                                                  .clear();
                                                              linesValues
                                                                  .clear();
                                                              linesKeys.clear();
                                                              summarysDataQuality
                                                                  .clear();
                                                              qualityList
                                                                  .clear();
                                                              summarysDataSize
                                                                  .clear();
                                                              sizeList.clear();
                                                            });
                                                            await linesCollection
                                                                .doc('resumen')
                                                                .get()
                                                                .then(
                                                              (value) {
                                                                setState(() {
                                                                  summarysDataLines = value
                                                                          .data()
                                                                          .toString()
                                                                          .contains(
                                                                              'nombres')
                                                                      ? value.get(
                                                                          'nombres')
                                                                      : {
                                                                          'n/a':
                                                                              'n/a'
                                                                        };
                                                                  combinationsDataLines = value
                                                                          .data()
                                                                          .toString()
                                                                          .contains(
                                                                              'combinaciones')
                                                                      ? value.get(
                                                                          'combinaciones')
                                                                      : {
                                                                          'n/a':
                                                                              [
                                                                            'n/a',
                                                                            'n/a'
                                                                          ],
                                                                        };
                                                                  summarysDataLines
                                                                      .entries
                                                                      .forEach(
                                                                          (name) {
                                                                    linesKeys
                                                                        .add(name
                                                                            .key);
                                                                    linesValues
                                                                        .add(name
                                                                            .value);
                                                                  });
                                                                });
                                                              },
                                                            );
                                                          },
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14,
                                                              right: 14),
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.5),
                                                        ),
                                                        color: myTheme
                                                            .colorScheme
                                                            .background,
                                                      ),
                                                      // elevation: 0,
                                                    ),
                                                    menuItemStyleData:
                                                        const MenuItemStyleData(
                                                      height: 40,
                                                    ),
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.5),
                                                        ),
                                                        // color: myTheme
                                                        //     .colorScheme.primary
                                                        //     .withOpacity(0.5),
                                                      ),
                                                      elevation: 1,
                                                      offset:
                                                          const Offset(0, 0),
                                                      scrollbarTheme:
                                                          ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(40),
                                                        thickness:
                                                            MaterialStateProperty
                                                                .all(6),
                                                        thumbVisibility:
                                                            MaterialStateProperty
                                                                .all(true),
                                                      ),
                                                    ),
                                                    iconStyleData:
                                                        IconStyleData(
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                      ),
                                                      iconSize: 14,
                                                      iconEnabledColor: myTheme
                                                          .colorScheme.primary,
                                                      iconDisabledColor:
                                                          Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                // Selecciona de las lineas de la DB
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 10, 0, 10),
                                                  child: Text('Linea'),
                                                ),
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    items: List<String>.from(
                                                            combinationsDataLines[
                                                                    combinationKeyForLines] ??
                                                                linesValues)
                                                        .map((line) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: line,
                                                              child: Text(
                                                                summarysDataLines[
                                                                    line],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: selectedLine,
                                                    onChanged:
                                                        selectedSubCategorie ==
                                                                    null ||
                                                                combinationsDataLines
                                                                    .isEmpty
                                                            ? null
                                                            : (value) async {
                                                                setState(() {
                                                                  selectedLine =
                                                                      value
                                                                          as String;
                                                                });
                                                                setState(() {
                                                                  selectedQuality =
                                                                      null;
                                                                  selectedSize =
                                                                      null;

                                                                  summarysDataQuality
                                                                      .clear();
                                                                  qualityList
                                                                      .clear();
                                                                  summarysDataSize
                                                                      .clear();
                                                                  sizeList
                                                                      .clear();
                                                                });
                                                                // TEST

                                                                await qualityCollection
                                                                    .doc(
                                                                        'resumen')
                                                                    .get()
                                                                    .then(
                                                                        (value) {
                                                                  setState(
                                                                    () {
                                                                      summarysDataQuality = value
                                                                              .data()
                                                                              .toString()
                                                                              .contains(
                                                                                  'nombres')
                                                                          ? value.get(
                                                                              'nombres')
                                                                          : {
                                                                              'n/a': 'n/a'
                                                                            };
                                                                    },
                                                                  );
                                                                });
                                                                await productsCollection
                                                                    .where(
                                                                        'subcategoria',
                                                                        isEqualTo:
                                                                            subCategoriesCollection.doc(
                                                                                combinationKeyForSubCategories))
                                                                    .where(
                                                                        'categoria',
                                                                        isEqualTo:
                                                                            categoriesCollection.doc(
                                                                                selectedSubCategorie))
                                                                    .where(
                                                                        'linea',
                                                                        isEqualTo:
                                                                            linesCollection.doc(
                                                                                selectedLine))
                                                                    .snapshots()
                                                                    .forEach(
                                                                        (element) {
                                                                  print(
                                                                      'Length quality: ${element.toString().length}');
                                                                  for (var element
                                                                      in element
                                                                          .docs) {
                                                                    var quality = element
                                                                            .data()
                                                                            .toString()
                                                                            .contains(
                                                                                'calidad')
                                                                        ? element
                                                                            .get('calidad')
                                                                            .id
                                                                        : '';
                                                                    if (qualityList
                                                                            .contains(quality) ==
                                                                        false) {
                                                                      print(
                                                                          'Quality added: $quality');
                                                                      setState(
                                                                          () {
                                                                        qualityList
                                                                            .add(quality);
                                                                      });
                                                                      print(
                                                                          qualityList);
                                                                    }
                                                                  }
                                                                });
                                                              },
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14,
                                                              right: 14),
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.5),
                                                        ),
                                                        color: myTheme
                                                            .colorScheme
                                                            .background,
                                                      ),
                                                      // elevation: 0,
                                                    ),
                                                    menuItemStyleData:
                                                        const MenuItemStyleData(
                                                      height: 40,
                                                    ),
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.5),
                                                        ),
                                                        // color: myTheme
                                                        //     .colorScheme.primary
                                                        //     .withOpacity(0.5),
                                                      ),
                                                      elevation: 1,
                                                      offset:
                                                          const Offset(0, 0),
                                                      scrollbarTheme:
                                                          ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(40),
                                                        thickness:
                                                            MaterialStateProperty
                                                                .all(6),
                                                        thumbVisibility:
                                                            MaterialStateProperty
                                                                .all(true),
                                                      ),
                                                    ),
                                                    iconStyleData:
                                                        IconStyleData(
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                      ),
                                                      iconSize: 14,
                                                      iconEnabledColor: myTheme
                                                          .colorScheme.primary,
                                                      iconDisabledColor:
                                                          Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                // Selecciona de las calidades de la DB
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 10, 0, 10),
                                                  child: Text('Calidad'),
                                                ),
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    items: List<String>.from(
                                                            qualityList)
                                                        .map((quality) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: quality,
                                                              child: Container(
                                                                width: 150,
                                                                child: Text(
                                                                  // quality,
                                                                  summarysDataQuality[
                                                                      quality],
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 3,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: selectedQuality,
                                                    onChanged: selectedLine ==
                                                            null
                                                        ? null
                                                        : (value) async {
                                                            setState(() {
                                                              selectedQuality =
                                                                  value
                                                                      as String;
                                                            });
                                                            setState(() {
                                                              selectedSize =
                                                                  null;
                                                              summarysDataSize
                                                                  .clear();
                                                              sizeList.clear();
                                                            });

                                                            await sizesCollection
                                                                .doc('resumen')
                                                                .get()
                                                                .then((value) {
                                                              setState(
                                                                () {
                                                                  summarysDataSize = value
                                                                          .data()
                                                                          .toString()
                                                                          .contains(
                                                                              'nombres')
                                                                      ? value.get(
                                                                          'nombres')
                                                                      : {
                                                                          'n/a':
                                                                              'n/a'
                                                                        };
                                                                },
                                                              );
                                                            });
                                                            await productsCollection
                                                                .where(
                                                                    'subcategoria',
                                                                    isEqualTo:
                                                                        subCategoriesCollection.doc(
                                                                            combinationKeyForSubCategories))
                                                                .where(
                                                                    'categoria',
                                                                    isEqualTo:
                                                                        categoriesCollection.doc(
                                                                            selectedSubCategorie))
                                                                .where('linea',
                                                                    isEqualTo:
                                                                        linesCollection.doc(
                                                                            selectedLine))
                                                                .where(
                                                                    'calidad',
                                                                    isEqualTo:
                                                                        qualityCollection.doc(
                                                                            selectedQuality))
                                                                .snapshots()
                                                                .forEach(
                                                                    (element) {
                                                              print(
                                                                  'Lenght size: ${element.toString().length}');
                                                              for (var element
                                                                  in element
                                                                      .docs) {
                                                                var size = element
                                                                        .data()
                                                                        .toString()
                                                                        .contains(
                                                                            'tamano')
                                                                    ? element
                                                                        .get(
                                                                            'tamano')
                                                                        .id
                                                                    : '';
                                                                if (sizeList.contains(
                                                                        size) ==
                                                                    false) {
                                                                  print(
                                                                      'size added: $size');
                                                                  setState(() {
                                                                    sizeList.add(
                                                                        size);
                                                                  });
                                                                  print(
                                                                      sizeList);
                                                                }
                                                              }
                                                            });
                                                          },
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14,
                                                              right: 14),
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.5),
                                                        ),
                                                        color: myTheme
                                                            .colorScheme
                                                            .background,
                                                      ),
                                                      // elevation: 0,
                                                    ),
                                                    menuItemStyleData:
                                                        const MenuItemStyleData(
                                                      height: 40,
                                                    ),
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.5),
                                                        ),
                                                        // color: myTheme
                                                        //     .colorScheme.primary
                                                        //     .withOpacity(0.5),
                                                      ),
                                                      elevation: 1,
                                                      offset:
                                                          const Offset(0, 0),
                                                      scrollbarTheme:
                                                          ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(40),
                                                        thickness:
                                                            MaterialStateProperty
                                                                .all(6),
                                                        thumbVisibility:
                                                            MaterialStateProperty
                                                                .all(true),
                                                      ),
                                                    ),
                                                    iconStyleData:
                                                        IconStyleData(
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                      ),
                                                      iconSize: 14,
                                                      iconEnabledColor: myTheme
                                                          .colorScheme.primary,
                                                      iconDisabledColor:
                                                          Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                // Selecciona de los tamaños de la DB
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 10, 0, 10),
                                                  child: Text('Tamaños'),
                                                ),
                                                DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    items: List<String>.from(
                                                            sizeList)
                                                        .map((size) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: size,
                                                              child: Text(
                                                                summarysDataSize[
                                                                    size],
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: selectedSize,
                                                    onChanged:
                                                        selectedQuality == null
                                                            ? null
                                                            : (value) {
                                                                setState(() {
                                                                  selectedSize =
                                                                      value
                                                                          as String;
                                                                });
                                                              },
                                                    buttonStyleData:
                                                        ButtonStyleData(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 14,
                                                              right: 14),
                                                      height: 40,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.5),
                                                        ),
                                                        color: myTheme
                                                            .colorScheme
                                                            .background,
                                                      ),
                                                      // elevation: 0,
                                                    ),
                                                    menuItemStyleData:
                                                        const MenuItemStyleData(
                                                      height: 40,
                                                    ),
                                                    dropdownStyleData:
                                                        DropdownStyleData(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(14),
                                                        border: Border.all(
                                                          color: myTheme
                                                              .colorScheme
                                                              .primary
                                                              .withOpacity(0.5),
                                                        ),
                                                        // color: myTheme
                                                        //     .colorScheme.primary
                                                        //     .withOpacity(0.5),
                                                      ),
                                                      elevation: 1,
                                                      offset:
                                                          const Offset(0, 0),
                                                      scrollbarTheme:
                                                          ScrollbarThemeData(
                                                        radius: const Radius
                                                            .circular(40),
                                                        thickness:
                                                            MaterialStateProperty
                                                                .all(6),
                                                        thumbVisibility:
                                                            MaterialStateProperty
                                                                .all(true),
                                                      ),
                                                    ),
                                                    iconStyleData:
                                                        IconStyleData(
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_forward_ios_outlined,
                                                      ),
                                                      iconSize: 14,
                                                      iconEnabledColor: myTheme
                                                          .colorScheme.primary,
                                                      iconDisabledColor:
                                                          Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      myTheme
                                                          .colorScheme.primary,
                                                    ),
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                      ),
                                                    ),
                                                  ),
                                                  icon: Icon(
                                                    MaterialCommunityIcons
                                                        .backspace,
                                                    size: 16,
                                                  ),
                                                  label: Text(
                                                    'Cancelar',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton.icon(
                                                  onPressed:
                                                      combinationKeyForSubCategories ==
                                                              null
                                                          ? null
                                                          : () async {
                                                              print(
                                                                  'Keys seleccionadas');
                                                              DocumentReference<
                                                                      Map<String,
                                                                          dynamic>>
                                                                  firestoreCategorie =
                                                                  subCategoriesCollection
                                                                      .doc(
                                                                          combinationKeyForSubCategories);

                                                              print(
                                                                  'combinationKeyForSubCategories: $combinationKeyForSubCategories');
                                                              if (selectedSubCategorie !=
                                                                  null) {
                                                                print(
                                                                    'selectedSubCategorie: $selectedSubCategorie');
                                                              }
                                                              if (selectedLine !=
                                                                  null) {
                                                                print(
                                                                    'selectedLine: $selectedLine');
                                                              }
                                                              if (selectedQuality !=
                                                                  null) {
                                                                print(
                                                                    'selectedQuality: $selectedQuality');
                                                              }
                                                              if (selectedSize !=
                                                                  null) {
                                                                print(
                                                                    'selectedSize: $selectedSize');
                                                              }

                                                              DocumentReference<
                                                                      Map<String,
                                                                          dynamic>>
                                                                  firestoreSubCategorie =
                                                                  categoriesCollection
                                                                      .doc(
                                                                          selectedSubCategorie);
                                                              DocumentReference<
                                                                      Map<String,
                                                                          dynamic>>
                                                                  firestoreLine =
                                                                  linesCollection
                                                                      .doc(
                                                                          selectedLine);
                                                              DocumentReference<
                                                                      Map<String,
                                                                          dynamic>>
                                                                  firestoreQuality =
                                                                  qualityCollection
                                                                      .doc(
                                                                          selectedQuality);
                                                              DocumentReference<
                                                                      Map<String,
                                                                          dynamic>>
                                                                  firestoreSize =
                                                                  sizesCollection
                                                                      .doc(
                                                                          selectedSize);
                                                              print(
                                                                  firestoreCategorie);
                                                              print(
                                                                  firestoreSubCategorie);
                                                              print(
                                                                  firestoreLine);
                                                              print(
                                                                  firestoreQuality);
                                                              print(
                                                                  firestoreSize);
                                                              setState(() {
                                                                filteredProducts
                                                                    .clear();
                                                              });

                                                              // if (selectedLine !=
                                                              //                                                             null)
                                                              //                                                         }
                                                              //  if (selectedQuality !=
                                                              //                                                             null)
                                                              //  if (selectedSize !=
                                                              //                                                             null)
                                                              //  if (selectedSubCategorie !=
                                                              //     null){}

                                                              if (selectedCategorie != null &&
                                                                  selectedSubCategorie ==
                                                                      null &&
                                                                  selectedLine ==
                                                                      null &&
                                                                  selectedQuality ==
                                                                      null &&
                                                                  selectedSize ==
                                                                      null) {
                                                                print(
                                                                    'Solo se seleciono categoria');
                                                                await productsCollection
                                                                    .where(
                                                                        'subcategoria',
                                                                        isEqualTo:
                                                                            firestoreCategorie)
                                                                    .snapshots()
                                                                    .forEach(
                                                                        (element) {
                                                                  for (var element
                                                                      in element
                                                                          .docs) {
                                                                    Products
                                                                        product =
                                                                        Products(
                                                                      quality: element
                                                                          .data()[
                                                                              'calidad']
                                                                          .id,
                                                                      catalogue: element
                                                                          .data()[
                                                                              'catalogo']
                                                                          .id,
                                                                      categorie: element
                                                                          .data()[
                                                                              'categoria']
                                                                          .id,
                                                                      code: element
                                                                              .data()[
                                                                          'codigo'],
                                                                      design: element
                                                                          .data()[
                                                                              'diseno']
                                                                          .id,
                                                                      line: element
                                                                          .data()[
                                                                              'linea']
                                                                          .id,
                                                                      brand: element
                                                                          .data()[
                                                                              'marca']
                                                                          .id,
                                                                      lastModifiedDate:
                                                                          element
                                                                              .data()['modificado'],
                                                                      name: element
                                                                              .data()[
                                                                          'nombre'],
                                                                      subCategorie: element
                                                                          .data()[
                                                                              'subcategoria']
                                                                          .id,
                                                                      size: element
                                                                          .data()[
                                                                              'tamano']
                                                                          .id,
                                                                      promotion: element
                                                                              .data()
                                                                              .toString()
                                                                              .contains(
                                                                                  'promocion')
                                                                          ? element
                                                                              .data()['promocion']
                                                                              .id
                                                                          : '',
                                                                      selected:
                                                                          false,
                                                                    );
                                                                    print(
                                                                        product);

                                                                    setState(
                                                                        () {
                                                                      filteredProducts
                                                                          .add(
                                                                              product);
                                                                    });
                                                                    print(
                                                                        'productos filtrados: ${filteredProducts.length}');
                                                                  }
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  ScaffoldMessenger
                                                                      .of(context)
                                                                    ..removeCurrentSnackBar()
                                                                    ..showSnackBar(
                                                                      SnackBar(
                                                                        backgroundColor: myTheme
                                                                            .colorScheme
                                                                            .primary,
                                                                        duration:
                                                                            const Duration(seconds: 1),
                                                                        content:
                                                                            Text(
                                                                          "${filteredProducts.length} Producto(s) Filtrado(s)",
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-regular',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                });
                                                              } else if (selectedCategorie != null &&
                                                                  selectedSubCategorie !=
                                                                      null &&
                                                                  selectedLine ==
                                                                      null &&
                                                                  selectedQuality ==
                                                                      null &&
                                                                  selectedSize ==
                                                                      null) {
                                                                print(
                                                                    'seleccionado categoria y subcategoria');
                                                                await productsCollection
                                                                    .where(
                                                                        'subcategoria',
                                                                        isEqualTo:
                                                                            firestoreCategorie)
                                                                    .where(
                                                                        'categoria',
                                                                        isEqualTo:
                                                                            firestoreSubCategorie)
                                                                    .snapshots()
                                                                    .forEach(
                                                                        (element) {
                                                                  for (var element
                                                                      in element
                                                                          .docs) {
                                                                    Products
                                                                        product =
                                                                        Products(
                                                                      quality: element
                                                                          .data()[
                                                                              'calidad']
                                                                          .id,
                                                                      catalogue: element
                                                                          .data()[
                                                                              'catalogo']
                                                                          .id,
                                                                      categorie: element
                                                                          .data()[
                                                                              'categoria']
                                                                          .id,
                                                                      code: element
                                                                              .data()[
                                                                          'codigo'],
                                                                      design: element
                                                                          .data()[
                                                                              'diseno']
                                                                          .id,
                                                                      line: element
                                                                          .data()[
                                                                              'linea']
                                                                          .id,
                                                                      brand: element
                                                                          .data()[
                                                                              'marca']
                                                                          .id,
                                                                      lastModifiedDate:
                                                                          element
                                                                              .data()['modificado'],
                                                                      name: element
                                                                              .data()[
                                                                          'nombre'],
                                                                      subCategorie: element
                                                                          .data()[
                                                                              'subcategoria']
                                                                          .id,
                                                                      size: element
                                                                          .data()[
                                                                              'tamano']
                                                                          .id,
                                                                      promotion: element
                                                                              .data()
                                                                              .toString()
                                                                              .contains(
                                                                                  'promocion')
                                                                          ? element
                                                                              .data()['promocion']
                                                                              .id
                                                                          : '',
                                                                      selected:
                                                                          false,
                                                                    );
                                                                    print(
                                                                        product);

                                                                    setState(
                                                                        () {
                                                                      filteredProducts
                                                                          .add(
                                                                              product);
                                                                    });
                                                                    print(
                                                                        'productos filtrados: ${filteredProducts.length}');
                                                                  }
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  ScaffoldMessenger
                                                                      .of(context)
                                                                    ..removeCurrentSnackBar()
                                                                    ..showSnackBar(
                                                                      SnackBar(
                                                                        backgroundColor: myTheme
                                                                            .colorScheme
                                                                            .primary,
                                                                        duration:
                                                                            const Duration(seconds: 1),
                                                                        content:
                                                                            Text(
                                                                          "${filteredProducts.length} Producto(s) Filtrado(s)",
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-regular',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                });
                                                              } else if (selectedCategorie != null &&
                                                                  selectedSubCategorie !=
                                                                      null &&
                                                                  selectedLine !=
                                                                      null &&
                                                                  selectedQuality ==
                                                                      null &&
                                                                  selectedSize ==
                                                                      null) {
                                                                print(
                                                                    'seleccionado categoria / subcategoria / Linea');
                                                                await productsCollection
                                                                    .where(
                                                                        'subcategoria',
                                                                        isEqualTo:
                                                                            firestoreCategorie)
                                                                    .where(
                                                                        'categoria',
                                                                        isEqualTo:
                                                                            firestoreSubCategorie)
                                                                    .where(
                                                                        'linea',
                                                                        isEqualTo:
                                                                            firestoreLine)
                                                                    .snapshots()
                                                                    .forEach(
                                                                        (element) {
                                                                  for (var element
                                                                      in element
                                                                          .docs) {
                                                                    Products
                                                                        product =
                                                                        Products(
                                                                      quality: element
                                                                          .data()[
                                                                              'calidad']
                                                                          .id,
                                                                      catalogue: element
                                                                          .data()[
                                                                              'catalogo']
                                                                          .id,
                                                                      categorie: element
                                                                          .data()[
                                                                              'categoria']
                                                                          .id,
                                                                      code: element
                                                                              .data()[
                                                                          'codigo'],
                                                                      design: element
                                                                          .data()[
                                                                              'diseno']
                                                                          .id,
                                                                      line: element
                                                                          .data()[
                                                                              'linea']
                                                                          .id,
                                                                      brand: element
                                                                          .data()[
                                                                              'marca']
                                                                          .id,
                                                                      lastModifiedDate:
                                                                          element
                                                                              .data()['modificado'],
                                                                      name: element
                                                                              .data()[
                                                                          'nombre'],
                                                                      subCategorie: element
                                                                          .data()[
                                                                              'subcategoria']
                                                                          .id,
                                                                      size: element
                                                                          .data()[
                                                                              'tamano']
                                                                          .id,
                                                                      promotion: element
                                                                              .data()
                                                                              .toString()
                                                                              .contains(
                                                                                  'promocion')
                                                                          ? element
                                                                              .data()['promocion']
                                                                              .id
                                                                          : '',
                                                                      selected:
                                                                          false,
                                                                    );
                                                                    print(
                                                                        product);

                                                                    setState(
                                                                        () {
                                                                      filteredProducts
                                                                          .add(
                                                                              product);
                                                                    });
                                                                    print(
                                                                        'productos filtrados: ${filteredProducts.length}');
                                                                  }
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  ScaffoldMessenger
                                                                      .of(context)
                                                                    ..removeCurrentSnackBar()
                                                                    ..showSnackBar(
                                                                      SnackBar(
                                                                        backgroundColor: myTheme
                                                                            .colorScheme
                                                                            .primary,
                                                                        duration:
                                                                            const Duration(seconds: 1),
                                                                        content:
                                                                            Text(
                                                                          "${filteredProducts.length} Producto(s) Filtrado(s)",
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-regular',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                });
                                                              } else if (selectedCategorie != null &&
                                                                  selectedSubCategorie !=
                                                                      null &&
                                                                  selectedLine !=
                                                                      null &&
                                                                  selectedQuality !=
                                                                      null &&
                                                                  selectedSize ==
                                                                      null) {
                                                                print(
                                                                    'seleccionado categoria / subcategoria / Linea / calidad');
                                                                await productsCollection
                                                                    .where(
                                                                        'subcategoria',
                                                                        isEqualTo:
                                                                            firestoreCategorie)
                                                                    .where(
                                                                        'categoria',
                                                                        isEqualTo:
                                                                            firestoreSubCategorie)
                                                                    .where(
                                                                        'linea',
                                                                        isEqualTo:
                                                                            firestoreLine)
                                                                    .where(
                                                                        'calidad',
                                                                        isEqualTo:
                                                                            firestoreQuality)
                                                                    .snapshots()
                                                                    .forEach(
                                                                        (element) {
                                                                  for (var element
                                                                      in element
                                                                          .docs) {
                                                                    Products
                                                                        product =
                                                                        Products(
                                                                      quality: element
                                                                          .data()[
                                                                              'calidad']
                                                                          .id,
                                                                      catalogue: element
                                                                          .data()[
                                                                              'catalogo']
                                                                          .id,
                                                                      categorie: element
                                                                          .data()[
                                                                              'categoria']
                                                                          .id,
                                                                      code: element
                                                                              .data()[
                                                                          'codigo'],
                                                                      design: element
                                                                          .data()[
                                                                              'diseno']
                                                                          .id,
                                                                      line: element
                                                                          .data()[
                                                                              'linea']
                                                                          .id,
                                                                      brand: element
                                                                          .data()[
                                                                              'marca']
                                                                          .id,
                                                                      lastModifiedDate:
                                                                          element
                                                                              .data()['modificado'],
                                                                      name: element
                                                                              .data()[
                                                                          'nombre'],
                                                                      subCategorie: element
                                                                          .data()[
                                                                              'subcategoria']
                                                                          .id,
                                                                      size: element
                                                                          .data()[
                                                                              'tamano']
                                                                          .id,
                                                                      promotion: element
                                                                              .data()
                                                                              .toString()
                                                                              .contains(
                                                                                  'promocion')
                                                                          ? element
                                                                              .data()['promocion']
                                                                              .id
                                                                          : '',
                                                                      selected:
                                                                          false,
                                                                    );
                                                                    print(
                                                                        product);

                                                                    setState(
                                                                        () {
                                                                      filteredProducts
                                                                          .add(
                                                                              product);
                                                                    });
                                                                    print(
                                                                        'productos filtrados: ${filteredProducts.length}');
                                                                  }
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  ScaffoldMessenger
                                                                      .of(context)
                                                                    ..removeCurrentSnackBar()
                                                                    ..showSnackBar(
                                                                      SnackBar(
                                                                        backgroundColor: myTheme
                                                                            .colorScheme
                                                                            .primary,
                                                                        duration:
                                                                            const Duration(seconds: 1),
                                                                        content:
                                                                            Text(
                                                                          "${filteredProducts.length} Producto(s) Filtrado(s)",
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-regular',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                });
                                                              } else if (selectedCategorie != null &&
                                                                  selectedSubCategorie !=
                                                                      null &&
                                                                  selectedLine !=
                                                                      null &&
                                                                  selectedQuality !=
                                                                      null &&
                                                                  selectedSize !=
                                                                      null) {
                                                                print(
                                                                    'Se selecciono todas las opciones disponibles del filtro');
                                                                await productsCollection
                                                                    .where(
                                                                        'subcategoria',
                                                                        isEqualTo:
                                                                            firestoreCategorie)
                                                                    .where(
                                                                        'categoria',
                                                                        isEqualTo:
                                                                            firestoreSubCategorie)
                                                                    .where(
                                                                        'linea',
                                                                        isEqualTo:
                                                                            firestoreLine)
                                                                    .where(
                                                                        'calidad',
                                                                        isEqualTo:
                                                                            firestoreQuality)
                                                                    .where(
                                                                        'tamano',
                                                                        isEqualTo:
                                                                            firestoreSize)
                                                                    .snapshots()
                                                                    .forEach(
                                                                        (element) {
                                                                  for (var element
                                                                      in element
                                                                          .docs) {
                                                                    Products
                                                                        product =
                                                                        Products(
                                                                      quality: element
                                                                          .data()[
                                                                              'calidad']
                                                                          .id,
                                                                      catalogue: element
                                                                          .data()[
                                                                              'catalogo']
                                                                          .id,
                                                                      categorie: element
                                                                          .data()[
                                                                              'categoria']
                                                                          .id,
                                                                      code: element
                                                                              .data()[
                                                                          'codigo'],
                                                                      design: element
                                                                          .data()[
                                                                              'diseno']
                                                                          .id,
                                                                      line: element
                                                                          .data()[
                                                                              'linea']
                                                                          .id,
                                                                      brand: element
                                                                          .data()[
                                                                              'marca']
                                                                          .id,
                                                                      lastModifiedDate:
                                                                          element
                                                                              .data()['modificado'],
                                                                      name: element
                                                                              .data()[
                                                                          'nombre'],
                                                                      subCategorie: element
                                                                          .data()[
                                                                              'subcategoria']
                                                                          .id,
                                                                      size: element
                                                                          .data()[
                                                                              'tamano']
                                                                          .id,
                                                                      promotion: element
                                                                              .data()
                                                                              .toString()
                                                                              .contains(
                                                                                  'promocion')
                                                                          ? element
                                                                              .data()['promocion']
                                                                              .id
                                                                          : '',
                                                                      selected:
                                                                          false,
                                                                    );
                                                                    print(
                                                                        product);

                                                                    setState(
                                                                        () {
                                                                      filteredProducts
                                                                          .add(
                                                                              product);
                                                                    });
                                                                    print(
                                                                        'productos filtrados: ${filteredProducts.length}');
                                                                  }
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  ScaffoldMessenger
                                                                      .of(context)
                                                                    ..removeCurrentSnackBar()
                                                                    ..showSnackBar(
                                                                      SnackBar(
                                                                        backgroundColor: myTheme
                                                                            .colorScheme
                                                                            .primary,
                                                                        duration:
                                                                            const Duration(seconds: 1),
                                                                        content:
                                                                            Text(
                                                                          "${filteredProducts.length} Producto(s) Filtrado(s)",
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Poppins-regular',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                });
                                                              }
                                                            },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      myTheme.colorScheme
                                                          .onPrimaryContainer,
                                                    ),
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18.0),
                                                      ),
                                                    ),
                                                  ),
                                                  icon: Icon(
                                                    MaterialIcons.filter_list,
                                                    size: 20,
                                                  ),
                                                  label: Text(
                                                    'Filtrar',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily:
                                                          'Poppins-regular',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                            setState(() {});
                          },
                          icon: Icon(Icons.filter_alt_rounded,
                              color: myTheme.colorScheme.onPrimaryContainer),
                          splashRadius: 5,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      widget.showFullList == true
                          ? Container(
                              margin: EdgeInsets.only(top: 8, right: 8),
                              height: 40,
                              width: 68,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Color(0xFFDFE0FF)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      selectedValue == null
                                          ? productsLimit == 0
                                              ? 'Todos'
                                              : '$productsScrollLimit'
                                          : selectedValue.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins-regular',
                                        color: myTheme
                                            .colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  items: items
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins-regular',
                                                color: myTheme.colorScheme
                                                    .onPrimaryContainer,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    final productsLimitProvider =
                                        Provider.of<CounterLimitFirestore>(
                                            context,
                                            listen: false);
                                    setState(() {
                                      selectedValue = value as String;
                                    });
                                    if (selectedValue == 'Todos') {
                                      productsLimitProvider.setProductsLimit(
                                          0, 0);
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
                                  buttonStyleData: const ButtonStyleData(
                                    height: 40,
                                    width: 68,
                                    elevation: 1,
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                  ),
                                  alignment: Alignment.center,
                                  dropdownStyleData: DropdownStyleData(
                                    width: 68,
                                    elevation: 0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color: Color(0xFFDFE0FF),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      widget.showFullList == false
                          ? Container()
                          : filteredProducts.isEmpty
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(top: 8, right: 8),
                                  height: 40,
                                  width: 68,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Color(0xFFDFE0FF)),
                                  child: IconButton(
                                    onPressed: () {
                                      if (filteredProducts.isNotEmpty) {
                                        ScaffoldMessenger.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  myTheme.colorScheme.primary,
                                              duration:
                                                  const Duration(seconds: 1),
                                              content: const Text(
                                                "Filtros eliminados",
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                ),
                                              ),
                                            ),
                                          );
                                      }
                                      setState(() {
                                        filteredProducts.clear();
                                      });
                                    },
                                    icon: Icon(Icons.filter_alt_off_rounded,
                                        color: myTheme
                                            .colorScheme.onPrimaryContainer),
                                    splashRadius: 5,
                                  ),
                                ),
                    ],
                  ),
                  SizedBox(height: 8),
                  filteredProducts.isEmpty
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.70,
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
                              final productStock =
                                  stockValues[product.code] ?? 000;
                              final productBrand =
                                  brandsSummary[product.brand] ?? '';
                              final productCategorie =
                                  categoriesSummary[product.categorie] ?? '';
                              final productSubCategorie =
                                  subCategoriesSummary[product.subCategorie] ??
                                      '';
                              final productLine =
                                  linesSummary[product.line] ?? '';
                              final productQuality =
                                  qualitiesSummary[product.quality] ?? '';
                              final productSize =
                                  sizesSummary[product.size] ?? '';
                              final productDesign =
                                  designsSummary[product.design] ?? '';
                              final productPrice =
                                  widget.listOfPrices[product.code] ?? 0.00;
                              final priceProduct =
                                  priceMultipliedByItsExchangeRatio(
                                      productPrice: productPrice,
                                      coinDecimals: coinDecimals,
                                      coinExchangeRatio: coinExchangeRatio);
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
                                          availableStock: productStock,
                                          code: product.code.toString(),
                                          productId: product.code.toString(),
                                          listOfPricesId:
                                              widget.listOfPrices.toString(),
                                          totalAmount: productPrice.toString(),
                                          name: product.name,
                                          unitPrice: productPrice.toString(),
                                          urlPicture:
                                              product.catalogue.toString(),
                                        );
                                        setState(() => product.selected =
                                            !product.selected);
                                        selectedProducts.add(newProduct);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  myTheme.colorScheme.primary,
                                              duration:
                                                  const Duration(seconds: 1),
                                              content: const Text(
                                                "No hay stock disponible de este producto",
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                ),
                                              ),
                                            ),
                                          );
                                      }
                                    } else if (product.selected == true) {
                                      setState(() =>
                                          product.selected = !product.selected);
                                      selectedProducts.removeWhere(
                                          (item) => item.code == product.code);
                                    }
                                  },
                                  onLongPress: () {
                                    // Pendiente

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            FutureBuilder(
                                          future: FirebaseStorage.instance
                                              .ref()
                                              .child('imagenes')
                                              .child('catalogos')
                                              .child(product.catalogue)
                                              .child('1')
                                              .getDownloadURL()
                                              .catchError((e) {
                                            print('ERROR GETTING IMG');
                                            print(e);
                                          }),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final url =
                                                  snapshot.data?.toString();

                                              print(product.catalogue);

                                              return ProductDetails(
                                                code: product.code,
                                                price: productPrice,
                                                line: productLine,
                                                imageUrl: url ??
                                                    'https://i.imgur.com/BPbj6Gy.jpg',
                                                isProductNew: false,
                                                name: product.name,
                                                stock: productStock ?? 0,
                                                list: [
                                                  ProductsByDate(
                                                    quality: 'nan',
                                                    catalogue: 'test',
                                                    categorie: 'test',
                                                    code: 'test',
                                                    design: 'test',
                                                    line: 'test',
                                                    brand: 'test',
                                                    lastModifiedDate:
                                                        DateTime.now(),
                                                    name: 'test',
                                                    subCategorie: 'test',
                                                    size: 'test',
                                                    selected: false,
                                                  )
                                                ],
                                                isProductInAPromotion: false,
                                                prices: widget.listOfPrices,
                                                pricesName: widget.pricesName,
                                                catalogueID: product.catalogue,
                                                userZoneDocument:
                                                    widget.userZoneDocument,
                                                showListButton: false,
                                              );
                                            } else if (snapshot.hasError) {
                                              return ProductDetails(
                                                code: product.code,
                                                price: productPrice,
                                                line: productLine,
                                                imageUrl:
                                                    'https://i.imgur.com/BPbj6Gy.jpg',
                                                isProductNew: false,
                                                name: product.name,
                                                stock: productStock ?? 0,
                                                list: [
                                                  ProductsByDate(
                                                    quality: 'nan',
                                                    catalogue: 'test',
                                                    categorie: 'test',
                                                    code: 'test',
                                                    design: 'test',
                                                    line: 'test',
                                                    brand: 'test',
                                                    lastModifiedDate:
                                                        DateTime.now(),
                                                    name: 'test',
                                                    subCategorie: 'test',
                                                    size: 'test',
                                                    selected: false,
                                                  )
                                                ],
                                                isProductInAPromotion: false,
                                                prices: widget.listOfPrices,
                                                pricesName: widget.pricesName,
                                                catalogueID: product.catalogue,
                                                userZoneDocument:
                                                    widget.userZoneDocument,
                                                showListButton: false,
                                              );
                                            } else {
                                              return const SizedBox(
                                                width: 140,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  title: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                  activeColor: myTheme
                                                      .colorScheme.primary,
                                                  value: product.selected,
                                                  onChanged: (value) {
                                                    if (product.selected ==
                                                        false) {
                                                      if (productStock > 0) {
                                                        final newProduct =
                                                            ShoppingCartProduct(
                                                          productQuantity: 1,
                                                          code: product.code
                                                              .toString(),
                                                          productId: product
                                                              .code
                                                              .toString(),
                                                          listOfPricesId: widget
                                                              .listOfPrices
                                                              .toString(),
                                                          totalAmount:
                                                              productPrice
                                                                  .toString(),
                                                          name: product.name,
                                                          unitPrice:
                                                              productPrice
                                                                  .toString(),
                                                          availableStock:
                                                              productStock,
                                                          urlPicture: product
                                                              .catalogue
                                                              .toString(),
                                                        );
                                                        setState(() => product
                                                                .selected =
                                                            !product.selected);
                                                        selectedProducts
                                                            .add(newProduct);
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..removeCurrentSnackBar()
                                                          ..showSnackBar(
                                                            SnackBar(
                                                              backgroundColor:
                                                                  myTheme
                                                                      .colorScheme
                                                                      .primary,
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                              content:
                                                                  const Text(
                                                                "No hay stock disponible de este producto",
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Poppins-regular',
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                      }
                                                    } else if (product
                                                            .selected ==
                                                        true) {
                                                      setState(() => product
                                                              .selected =
                                                          !product.selected);
                                                      selectedProducts
                                                          .removeWhere((item) =>
                                                              item.code ==
                                                              product.code);
                                                    }
                                                  }),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              message:
                                                  '$coinSymbol ${formatDecimalPriceByRegion(price: Decimal.parse(priceProduct.toString()))}',
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                              final productStock =
                                  stockValues[product.code] ?? 000;
                              final productBrand =
                                  brandsSummary[product.brand] ?? '';
                              final productCategorie =
                                  categoriesSummary[product.categorie] ?? '';
                              final productSubCategorie =
                                  subCategoriesSummary[product.subCategorie] ??
                                      '';
                              final productLine =
                                  linesSummary[product.line] ?? '';
                              final productQuality =
                                  qualitiesSummary[product.quality] ?? '';
                              final productSize =
                                  sizesSummary[product.size] ?? '';
                              final productDesign =
                                  designsSummary[product.design] ?? '';
                              final productPrice =
                                  widget.listOfPrices[product.code] ?? 0;
                              final priceProduct =
                                  priceMultipliedByItsExchangeRatio(
                                      productPrice: productPrice,
                                      coinDecimals: coinDecimals,
                                      coinExchangeRatio: coinExchangeRatio);
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
                                          urlPicture:
                                              product.catalogue.toString(),
                                        );
                                        setState(() => product.selected =
                                            !product.selected);
                                        selectedProducts.add(newProduct);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  myTheme.colorScheme.primary,
                                              duration:
                                                  const Duration(seconds: 1),
                                              content: const Text(
                                                "No hay stock disponible de este producto",
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-regular',
                                                ),
                                              ),
                                            ),
                                          );
                                      }
                                    } else if (product.selected == true) {
                                      setState(() =>
                                          product.selected = !product.selected);
                                      selectedProducts.removeWhere(
                                          (item) => item.code == product.code);
                                    }
                                  },
                                  onLongPress: () {
                                    // Pendiente
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            FutureBuilder(
                                          future: FirebaseStorage.instance
                                              .ref()
                                              .child('imagenes')
                                              .child('catalogos')
                                              .child(product.catalogue)
                                              .child('1')
                                              .getDownloadURL()
                                              .catchError((e) {
                                            print(e);
                                          }),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final url =
                                                  snapshot.data!.toString();

                                              return ProductDetails(
                                                code: product.code,
                                                price: (productPrice),
                                                line: productLine,
                                                imageUrl: url,
                                                isProductNew: false,
                                                name: product.name,
                                                stock: productStock ?? 0,
                                                list: [
                                                  ProductsByDate(
                                                    quality: 'nan',
                                                    catalogue: 'test',
                                                    categorie: 'test',
                                                    code: 'test',
                                                    design: 'test',
                                                    line: 'test',
                                                    brand: 'test',
                                                    lastModifiedDate:
                                                        DateTime.now(),
                                                    name: 'test',
                                                    subCategorie: 'test',
                                                    size: 'test',
                                                    selected: false,
                                                  )
                                                ],
                                                isProductInAPromotion: false,
                                                prices: widget.listOfPrices,
                                                pricesName: widget.pricesName,
                                                catalogueID: product.catalogue,
                                                userZoneDocument:
                                                    widget.userZoneDocument,
                                                showListButton: false,
                                              );
                                            } else if (snapshot.hasError) {
                                              return ProductDetails(
                                                code: product.code,
                                                price: (productPrice),
                                                line: productLine,
                                                imageUrl:
                                                    'https://i.imgur.com/BPbj6Gy.jpg',
                                                isProductNew: false,
                                                name: product.name,
                                                stock: productStock ?? 0,
                                                list: [
                                                  ProductsByDate(
                                                    quality: 'nan',
                                                    catalogue: 'test',
                                                    categorie: 'test',
                                                    code: 'test',
                                                    design: 'test',
                                                    line: 'test',
                                                    brand: 'test',
                                                    lastModifiedDate:
                                                        DateTime.now(),
                                                    name: 'test',
                                                    subCategorie: 'test',
                                                    size: 'test',
                                                    selected: false,
                                                  )
                                                ],
                                                isProductInAPromotion: false,
                                                prices: widget.listOfPrices,
                                                pricesName: widget.pricesName,
                                                catalogueID: product.catalogue,
                                                userZoneDocument:
                                                    widget.userZoneDocument,
                                                showListButton: false,
                                              );
                                            } else {
                                              return const SizedBox(
                                                width: 140,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  title: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                  activeColor: myTheme
                                                      .colorScheme.primary,
                                                  value: product.selected,
                                                  onChanged: (value) {
                                                    if (product.selected ==
                                                        false) {
                                                      final newProduct =
                                                          ShoppingCartProduct(
                                                        productQuantity: 1,
                                                        code: product.code
                                                            .toString(),
                                                        productId: product.code
                                                            .toString(),
                                                        listOfPricesId: widget
                                                            .listOfPrices
                                                            .toString(),
                                                        totalAmount:
                                                            productPrice
                                                                .toString(),
                                                        name: product.name,
                                                        unitPrice: productPrice
                                                            .toString(),
                                                        availableStock:
                                                            productStock,
                                                        urlPicture:
                                                            product.catalogue,
                                                      );
                                                      selectedProducts
                                                          .add(newProduct);
                                                    } else if (product
                                                            .selected ==
                                                        true) {
                                                      selectedProducts
                                                          .removeWhere((item) =>
                                                              item.code ==
                                                              product.code);
                                                    }
                                                    setState(() => product
                                                        .selected = value!);
                                                  }),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              message: priceProduct
                                                  .toStringAsFixed(2),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
