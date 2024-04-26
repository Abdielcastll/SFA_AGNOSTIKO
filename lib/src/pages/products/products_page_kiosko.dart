// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/functions.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsPageKiosko extends StatefulWidget {
  const ProductsPageKiosko({
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
  State<ProductsPageKiosko> createState() => _ProductsPageKioskoState();
}

class _ProductsPageKioskoState extends State<ProductsPageKiosko> {
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
  }

  //Test
  String? phosTest = 'Phos';
  //Test

  @override
  Widget build(BuildContext context) {
    final stockValues = Provider.of<StockModel?>(context)?.stock ?? {};
    // Moneda actual
    final coinName = Provider.of<Coin?>(context)?.name ?? '';
    final coinDecimals = Provider.of<Coin?>(context)?.decimals ?? 0;
    final coinExchangeRatio = Provider.of<Coin?>(context)?.exchangeRatio ?? 0;
    final coinSymbol = Provider.of<Coin?>(context)?.symbol ?? '';

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
                else if (selectedProducts.isNotEmpty)
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
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          gravity: ToastGravity.TOP,
                          msg: 'Se ha agregado exitosamente al carrito',
                          fontSize: 20,
                          backgroundColor:
                              const Color.fromARGB(255, 149, 231, 184),
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
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: TextField(
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins-regular',
                            ),
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            maxLength: 200,
                            controller: searchController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusColor: Colors.white,
                              hintText: "Buscar",
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins-regular',
                                fontSize: 18,
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
                            onChanged: (value) {
                              setState(() {
                                if (value.isEmpty) {
                                  filteredProducts.clear();
                                } else {
                                  filteredProducts = products
                                      .where((product) => product.name
                                          .toLowerCase()
                                          .contains(
                                              value.toString().toLowerCase()))
                                      .toList();
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        height: 40,
                        width: 68,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xFFDFE0FF),
                        ),
                        child: IconButton(
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
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 17,
                              width: 17,
                              margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey.shade400,
                              ),
                              child: Checkbox(
                                value: false,
                                side: MaterialStateBorderSide.resolveWith(
                                  (states) => const BorderSide(
                                      width: 1.0, color: Colors.transparent),
                                ),
                                shape: const CircleBorder(),
                                activeColor: myTheme.colorScheme.primary,
                                onChanged: (bool? value) {
                                  null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 140,
                              child: TextFieldForCard(
                                message: "Nombre",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 150,
                              child: TextFieldForCard(
                                message: "Codigo de producto",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 50,
                              child: TextFieldForCard(
                                message: "Stock",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 50,
                              child: TextFieldForCard(
                                message: 'Precio',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
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
                        final product = sortedProducts[index];
                        final productStock = stockValues[product.code] ?? 000;
                        final productPrice =
                            widget.listOfPrices[product.code] ?? 0;
                        final priceProduct = priceMultipliedByItsExchangeRatio(
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
                                    urlPicture: product.catalogue.toString(),
                                  );
                                  setState(() =>
                                      product.selected = !product.selected);
                                  selectedProducts.add(newProduct);
                                } else {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            myTheme.colorScheme.primary,
                                        duration: const Duration(seconds: 1),
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
                                            10, 0, 0, 0),
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
                                                      color:
                                                          Colors.transparent)),
                                          shape: const CircleBorder(),
                                          activeColor:
                                              myTheme.colorScheme.primary,
                                          value: product.selected,
                                          onChanged: (value) {
                                            if (product.selected == false) {
                                              if (productStock > 0) {
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
                                                  urlPicture: product.catalogue
                                                      .toString(),
                                                );
                                                setState(() =>
                                                    product.selected =
                                                        !product.selected);
                                                selectedProducts
                                                    .add(newProduct);
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                  ..removeCurrentSnackBar()
                                                  ..showSnackBar(
                                                    SnackBar(
                                                      backgroundColor: myTheme
                                                          .colorScheme.primary,
                                                      duration: const Duration(
                                                          seconds: 1),
                                                      content: const Text(
                                                        "No hay stock disponible de este producto",
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Poppins-regular',
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                              }
                                            } else if (product.selected ==
                                                true) {
                                              setState(() => product.selected =
                                                  !product.selected);
                                              selectedProducts.removeWhere(
                                                  (item) =>
                                                      item.code ==
                                                      product.code);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        child: TextFieldForCard(
                                          message: product.name,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 150,
                                        child: TextFieldForCard(
                                          message: product.code,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: TextFieldForCard(
                                          message: productStock,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: TextFieldForCard(
                                          message:
                                              '$coinSymbol ${formatDecimalPriceByRegion(price: Decimal.parse(priceProduct.toString()))}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 110,
                                        width: 110,
                                        child: FutureBuilder(
                                          future: storage
                                              .ref()
                                              .child('imagenes')
                                              .child('catalogos')
                                              .child(
                                                  product.catalogue.toString())
                                              .child('1')
                                              .getDownloadURL()
                                              .catchError((e) {
                                            print(e);
                                            print(
                                                'ERROR OBTENIENDO IMG DE PRODUCTO EN ARRITO');
                                            return e.message;
                                          }),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              final url =
                                                  snapshot.data!.toString();
                                              return Container(
                                                height: 130,
                                                width: 95,
                                                decoration: const BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: url,
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 80,
                                                      child: const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      'assets/images/noproduct.jpg',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Container(
                                                height: 130,
                                                width: 95,
                                                decoration: const BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  8)),
                                                  child: Image.asset(
                                                    'assets/images/noproduct.jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return const SizedBox(
                                                width: 95,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  )
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
