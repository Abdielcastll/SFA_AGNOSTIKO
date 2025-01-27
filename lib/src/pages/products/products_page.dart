// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decimal/decimal.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/models/clients_model.dart';
import 'package:pwa_sales2go_flutter/src/models/coin_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/place_oder_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/product_details/product_details.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/services/connection_service.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:pwa_sales2go_flutter/src/utils/custom_cache_manager.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final currentCoin = Provider.of<CurrencyProvider>(context).currentCurrency;
    List<String> currentCoinSplit = currentCoin!.split(' ');
    String currentCoinSelectedCode = currentCoinSplit.last;
    return Scaffold(
      appBar: AppBarNavigation(
        message: AppLocalizations.of(context)!.products,
        userZoneDocument: widget.userZoneDocument,
      ),
      backgroundColor: themeProvider.myTheme.colorScheme.surface,
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

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
                  backgroundColor: themeProvider.myTheme.colorScheme.primary,
                  duration: const Duration(seconds: 1),
                  content: Text(
                    "Cargando $newValor productos adicionales",
                    style: const TextStyle(
                      fontFamily: 'Poppins-Regular',
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
    // Scroll limits
    final productsLimit =
        Provider.of<CounterLimitFirestore>(context).getProductsLimit;
    final productsScrollLimit =
        Provider.of<CounterLimitFirestore>(context).getScrollProductLimit;
    // Produtos
    final products = Provider.of<List<Products>?>(context) ?? [];
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final user = Provider.of<UserModel>(context);

    return coinName.toString().isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: themeProvider.myTheme.colorScheme.surface,
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
                      backgroundColor:
                          themeProvider.myTheme.colorScheme.primary,
                      onPressed: () async {
                        if (orderActive.orderActive == false) {
                          bool internet =
                              await checkInternetConnection(context);
                          if (internet) {
                            orderActive.setOrder(true, null);
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: const RouteSettings(
                                  name: "ORDER",
                                ),
                                builder: (context) =>
                                    StreamProvider<CurrentUserInfo?>.value(
                                  value: usersCollection
                                      .doc(user.uid)
                                      .snapshots()
                                      .map(
                                        AuthService().userDataFromsnapshot,
                                      ),
                                  initialData: CurrentUserInfo(
                                    name: '',
                                    dni: '',
                                    zone: '',
                                    zoneDocument: '',
                                    email: '',
                                    role: '',
                                    uid: '',
                                  ),
                                  catchError: (context, error) {
                                    print(error);
                                    return;
                                  },
                                  // builder: (context, child) {

                                  //   return NavigationPages();
                                  // });
                                  child: const OrderPage(),
                                ),
                              ),
                            );
                          }
                        }
                        // Fetch all products in the cart once
                        final productsInCart =
                            await objectBox.getAllShoppingCartProducts();

                        // Iterate through each selected product
                        for (var selectedProduct in selectedProducts) {
                          // Check if the selected product has stock
                          if (selectedProduct.availableStock! > 0) {
                            // Initialize a flag to check if the product is already in the cart
                            bool isProductAlreadyInCart = false;

                            // Iterate through the products in the cart
                            for (var cartProduct in productsInCart) {
                              if (cartProduct.code == selectedProduct.code) {
                                // Product is already in the cart, increase its quantity
                                print(
                                    'Product ${selectedProduct.code} is already in the cart, increasing quantity by 1');
                                isProductAlreadyInCart = true;

                                // Create an updated product with increased quantity
                                final updatedProduct = ShoppingCartProduct(
                                  id: cartProduct.id,
                                  availableStock: cartProduct.availableStock,
                                  productQuantity:
                                      cartProduct.productQuantity! + 1,
                                  code: cartProduct.code,
                                  listOfPricesId: cartProduct.listOfPricesId,
                                  name: cartProduct.name,
                                  productId: cartProduct.productId,
                                  unitPrice: cartProduct.unitPrice.toString(),
                                  totalAmount:
                                      cartProduct.totalAmount.toString(),
                                  urlPicture: cartProduct.urlPicture.toString(),
                                );

                                // Update the product in ObjectBox
                                if (cartProduct.productQuantity! + 1 <
                                    selectedProduct.availableStock!) {
                                  await objectBox.insertShoppingCartProduct(
                                      updatedProduct);
                                  // Show a toast message for the updated quantity
                                  Fluttertoast.showToast(
                                      msg:
                                          'Producto ${selectedProduct.code} añadido correctamente');

                                  break; // Exit the loop as we've found the product
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          'Ya no hay stock de: ${cartProduct.code}');
                                  break; // Exit the loop as we've found the product
                                }
                              }
                            }

                            // If the product is not already in the cart, add it as a new product
                            if (!isProductAlreadyInCart) {
                              final newProduct = ShoppingCartProduct(
                                productQuantity: 1,
                                code: selectedProduct.code,
                                productId: selectedProduct.productId,
                                listOfPricesId: selectedProduct.listOfPricesId,
                                totalAmount:
                                    selectedProduct.unitPrice.toString(),
                                name: selectedProduct.name,
                                unitPrice: selectedProduct.unitPrice.toString(),
                                availableStock: selectedProduct.availableStock,
                                urlPicture: selectedProduct.urlPicture,
                              );

                              // Insert the new product into ObjectBox
                              if (newProduct.productQuantity! <=
                                  selectedProduct.availableStock!) {
                                await objectBox
                                    .insertShoppingCartProduct(newProduct);
                                // Show a toast message for the updated quantity
                                Fluttertoast.showToast(
                                    msg:
                                        'Producto ${selectedProduct.code} añadido correctamente');
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        'Ya no hay stock de: ${selectedProduct.code}');
                              }
                            }
                          } else {
                            // Show a toast message if no stock is available for the product
                            Fluttertoast.showToast(
                                msg:
                                    'No hay stock disponible para ${selectedProduct.code}');
                          }
                        }

                        // Show feedback based on remote config
                        if (globalRemoteConfig.conversionKiosko! == false) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    themeProvider.myTheme.colorScheme.primary,
                                duration: const Duration(seconds: 1),
                                content: const Text(
                                  "Productos añadidos exitosamente",
                                  style: TextStyle(
                                    fontFamily: 'Poppins-Regular',
                                  ),
                                ),
                              ),
                            );
                        } else if (globalRemoteConfig.conversionKiosko ==
                            true) {
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            gravity: ToastGravity.TOP,
                            msg: 'Se ha agregado exitosamente al carrito',
                            fontSize: 20,
                            backgroundColor:
                                const Color.fromARGB(255, 149, 231, 184),
                          );
                        }
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
                            fontFamily: 'Poppins-Regular',
                          ),
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          maxLength: 200,
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
                              fontFamily: 'Poppins-Regular',
                              fontSize: 12,
                              color: Color(0xFF5A5D77),
                            ),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: themeProvider.myTheme.colorScheme.primary
                                    .withOpacity(0.5),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: themeProvider.myTheme.colorScheme.primary
                                    .withOpacity(0.5),
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.go,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                filteredProducts.clear();
                              });
                            } else {
                              setState(() {
                                String searchQuery = value.toLowerCase();
                                filteredProducts = products.where((product) {
                                  return product.name
                                      .toLowerCase()
                                      .contains(searchQuery);
                                }).toList();
                              });
                            }
                          },
                          onSubmitted: ((value) {
                            setState(() {
                              filteredProducts.clear();
                              String searchQuery = value.toLowerCase();
                              filteredProducts = products.where((product) {
                                return product.name
                                    .toLowerCase()
                                    .contains(searchQuery);
                              }).toList();
                            });
                          }),
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
                          onPressed: () =>
                              setState(() => isDescending = !isDescending),
                          icon: isDescending
                              ? Icon(
                                  MaterialCommunityIcons
                                      .sort_alphabetical_descending,
                                  color: themeProvider
                                      .myTheme.colorScheme.onPrimaryContainer,
                                )
                              : Icon(
                                  MaterialCommunityIcons
                                      .sort_alphabetical_ascending,
                                  color: themeProvider
                                      .myTheme.colorScheme.onPrimaryContainer,
                                ),
                        ),
                      ),

                      //todo bajar el boton cuando se arregle el filtro
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
                                        color: themeProvider.myTheme.colorScheme
                                            .onPrimaryContainer,
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
                                                color: themeProvider
                                                    .myTheme
                                                    .colorScheme
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
                                              backgroundColor: themeProvider
                                                  .myTheme.colorScheme.primary,
                                              duration:
                                                  const Duration(seconds: 1),
                                              content: const Text(
                                                "Filtros eliminados",
                                                style: TextStyle(
                                                  fontFamily: 'Poppins-Regular',
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
                                        color: themeProvider.myTheme.colorScheme
                                            .onPrimaryContainer),
                                    splashRadius: 5,
                                  ),
                                ),
                    ],
                  ),
                  SizedBox(height: 8),
                  filteredProducts.isEmpty
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 90,
                          child: Scrollbar(
                            thickness: 10,
                            thumbVisibility: true,
                            controller: _controller,
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
                                        : widget.listOfProducts?.reversed
                                            .toList()
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
                                    subCategoriesSummary[
                                            product.subCategorie] ??
                                        '';
                                final productLine =
                                    linesSummary[product.line] ?? '';
                                final productQuality =
                                    qualitiesSummary[product.quality] ?? '';
                                final productSize =
                                    sizesSummary[product.size] ?? '';
                                final productDesign =
                                    designsSummary[product.design] ?? '';
                                final productPrice = widget
                                        .listOfPrices[product.code] is int
                                    ? widget.listOfPrices[product.code] * 1.0
                                    : widget.listOfPrices[product.code] ?? 0.00;
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
                                    onLongPress: () {
                                      if (product.selected == false) {
                                        if (productStock > 0) {
                                          final newProduct =
                                              ShoppingCartProduct(
                                            productQuantity: 1,
                                            availableStock: productStock,
                                            code: product.code.toString(),
                                            productId: product.code.toString(),
                                            listOfPricesId:
                                                widget.listOfPrices.toString(),
                                            totalAmount:
                                                productPrice.toString(),
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
                                                backgroundColor: themeProvider
                                                    .myTheme
                                                    .colorScheme
                                                    .primary,
                                                duration:
                                                    const Duration(seconds: 1),
                                                content: const Text(
                                                  "No hay stock disponible de este producto",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Regular',
                                                  ),
                                                ),
                                              ),
                                            );
                                        }
                                      } else if (product.selected == true) {
                                        setState(() => product.selected =
                                            !product.selected);
                                        selectedProducts.removeWhere((item) =>
                                            item.code == product.code);
                                      }
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              FutureBuilder(
                                            future: storage
                                                .ref()
                                                .child('imagenes')
                                                .child('productos')
                                                .child(product.code)
                                                .child('1')
                                                .getDownloadURL()
                                                .catchError((e) {
                                              print('ERROR GETTING IMG');
                                              print(e);
                                              return e.message;
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
                                                      //catalogue: 'test',
                                                      categorie: 'test',
                                                      code: 'test',
                                                      barCode: 'test',
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
                                                  catalogueID:
                                                      product.catalogue,
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
                                                      //catalogue: 'test',
                                                      categorie: 'test',
                                                      code: 'test',
                                                      barCode: 'test',
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
                                                  catalogueID:
                                                      product.catalogue,
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
                                              Container(
                                                height: 17,
                                                width: 17,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
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
                                                  activeColor: themeProvider
                                                      .myTheme
                                                      .colorScheme
                                                      .primary,
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
                                                                  themeProvider
                                                                      .myTheme
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
                                                                      'Poppins-Regular',
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
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          ProductImageWidget(
                                              productCode: product.code),
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
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 90,
                          child: Scrollbar(
                            thickness: 10,
                            thumbVisibility: true,
                            controller: _controller,
                            child: ListView.builder(
                              controller: _controller,
                              physics: const BouncingScrollPhysics(),
                              itemCount: filteredProducts.length,
                              itemBuilder: (BuildContext context, index) {
                                final sortedProducts = isDescending
                                    ? filteredProducts.reversed.toList()
                                    : filteredProducts;
                                final product = sortedProducts[index];
                                final productStock =
                                    stockValues[product.code] ?? 000;
                                final productBrand =
                                    brandsSummary[product.brand] ?? '';
                                final productCategorie =
                                    categoriesSummary[product.categorie] ?? '';
                                final productSubCategorie =
                                    subCategoriesSummary[
                                            product.subCategorie] ??
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
                                    onLongPress: () {
                                      if (product.selected == false) {
                                        if (productStock > 0) {
                                          final newProduct =
                                              ShoppingCartProduct(
                                            productQuantity: 1,
                                            code: product.code.toString(),
                                            productId: product.code.toString(),
                                            listOfPricesId:
                                                widget.listOfPrices.toString(),
                                            totalAmount:
                                                productPrice.toString(),
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
                                                backgroundColor: themeProvider
                                                    .myTheme
                                                    .colorScheme
                                                    .primary,
                                                duration:
                                                    const Duration(seconds: 1),
                                                content: const Text(
                                                  "No hay stock disponible de este producto",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Poppins-Regular',
                                                  ),
                                                ),
                                              ),
                                            );
                                        }
                                      } else if (product.selected == true) {
                                        setState(() => product.selected =
                                            !product.selected);
                                        selectedProducts.removeWhere((item) =>
                                            item.code == product.code);
                                      }
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              FutureBuilder(
                                            future: storage
                                                .ref()
                                                .child('imagenes')
                                                .child('productos')
                                                .child(product.code)
                                                .child('1')
                                                .getDownloadURL()
                                                .catchError((e) {
                                              print(e);
                                              return e.message;
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
                                                      //catalogue: 'test',
                                                      categorie: 'test',
                                                      code: 'test',
                                                      barCode: 'test',
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
                                                  catalogueID:
                                                      product.catalogue,
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
                                                      //catalogue: 'test',
                                                      categorie: 'test',
                                                      code: 'test',
                                                      barCode: 'test',
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
                                                  catalogueID:
                                                      product.catalogue,
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
                                              Container(
                                                height: 17,
                                                width: 17,
                                                margin:
                                                    const EdgeInsets.fromLTRB(
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
                                                                color:
                                                                    Colors
                                                                        .transparent)),
                                                    shape: const CircleBorder(),
                                                    activeColor: themeProvider
                                                        .myTheme
                                                        .colorScheme
                                                        .primary,
                                                    value: product.selected,
                                                    onChanged: (value) {
                                                      if (product.selected ==
                                                          false) {
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
                                                          urlPicture:
                                                              product.catalogue,
                                                        );
                                                        selectedProducts
                                                            .add(newProduct);
                                                      } else if (product
                                                              .selected ==
                                                          true) {
                                                        selectedProducts
                                                            .removeWhere(
                                                                (item) =>
                                                                    item.code ==
                                                                    product
                                                                        .code);
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
                                          const SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: FutureBuilder<String>(
                                                  future: storage
                                                      .ref()
                                                      .child('imagenes')
                                                      .child('productos')
                                                      .child(product.code)
                                                      .child('1')
                                                      .getDownloadURL()
                                                      .catchError((e) {
                                                    print('ERROR GETTING IMG');
                                                    print(e);
                                                    return ''; // Return an empty string if there's an error.
                                                  }),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      // Show a loading spinner while fetching the URL.
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    }

                                                    if (snapshot.hasError ||
                                                        snapshot.data == null ||
                                                        snapshot
                                                            .data!.isEmpty) {
                                                      // Show the placeholder image if there's an error or no data.
                                                      return Image.asset(
                                                        height: 100,
                                                        'assets/images/noproduct.jpg',
                                                        fit: BoxFit.fitHeight,
                                                      );
                                                    }

                                                    final url = snapshot.data!;

                                                    return CachedNetworkImage(
                                                      height: 100,
                                                      cacheManager:
                                                          CustomCacheManager
                                                              .instance,
                                                      fit: BoxFit.fitHeight,
                                                      imageUrl: url,
                                                      placeholder:
                                                          (context, url) =>
                                                              Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        height: 100,
                                                        'assets/images/noproduct.jpg',
                                                        fit: BoxFit.fitHeight,
                                                      ),
                                                    );
                                                  },
                                                ),
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
        fontFamily: 'Poppins-Regular',
        fontSize: 11,
        fontWeight: bold,
      ),
    );
  }
}

class ProductImageWidget extends StatefulWidget {
  final String productCode;

  const ProductImageWidget({Key? key, required this.productCode})
      : super(key: key);

  @override
  _ProductImageWidgetState createState() => _ProductImageWidgetState();
}

class _ProductImageWidgetState extends State<ProductImageWidget> {
  late Future<String> _imageUrlFuture;

  @override
  void initState() {
    super.initState();
    _imageUrlFuture = _fetchImageUrl();
  }

  Future<String> _fetchImageUrl() async {
    try {
      return await storage
          .ref()
          .child('imagenes')
          .child('productos')
          .child(widget.productCode)
          .child('1')
          .getDownloadURL();
    } catch (e) {
      print('ERROR GETTING IMG');
      print(e);
      return ''; // Return an empty string if there's an error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FutureBuilder<String>(
            future: _imageUrlFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show a loading spinner while fetching the URL.
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                // Show the placeholder image if there's an error or no data.
                return Image.asset(
                  'assets/images/noproduct.jpg',
                  height: 100,
                  fit: BoxFit.fitHeight,
                );
              }

              final url = snapshot.data!;

              return CachedNetworkImage(
                height: 100,
                cacheManager: CustomCacheManager.instance,
                fit: BoxFit.fitHeight,
                imageUrl: url,
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/noproduct.jpg',
                  height: 100,
                  fit: BoxFit.fitHeight,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
