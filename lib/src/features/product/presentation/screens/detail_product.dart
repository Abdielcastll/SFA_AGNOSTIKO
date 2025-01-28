// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/main.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/entitites/product_variant_entity.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/enums/product_size_enum.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/widgets/button.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/widgets/middle.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/widgets/productos_detail_body.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/widgets/top.dart';
import 'package:pwa_sales2go_flutter/src/models/shopping_cart_products.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/services/connection_service.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/widgets/appbar/appbar_navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailUI extends StatefulWidget {
  const ProductDetailUI({
    Key? key,
    required this.productName,
    required this.priceText,
    required this.sizes,
    required this.colorOptions,
    required this.genderOptions,
    required this.products,
  }) : super(key: key);

  final String productName;
  final String priceText;
  final List<ProductSize> sizes;
  final List<String> colorOptions;
  final List<String> genderOptions;
  final List<ProductVariantEntity> products;

  @override
  _ProductDetailUIState createState() => _ProductDetailUIState();
}

class _ProductDetailUIState extends State<ProductDetailUI> {
  ProductSize selectedSize = ProductSize.std;
  String selectedGender = "";
  String selectedDropdownColor = "";
  int selectedProduct = 0;
  int selectedProductStock = 0;

  @override
  void initState() {
    super.initState();

    selectedSize =
        widget.sizes.isNotEmpty ? widget.sizes.first : ProductSize.std;
    selectedGender =
        widget.genderOptions.isNotEmpty ? widget.genderOptions.first : "";
    selectedDropdownColor =
        widget.colorOptions.isNotEmpty ? widget.colorOptions.first : "";
    updateSelectedProduct();
  }

  /// Helper function to update the selected product
  void updateSelectedProduct() {
    final productIndex = widget.products.indexWhere((product) {
      final isSizeMatch = product.size == selectedSize;
      final isLineMatch = product.line == selectedDropdownColor;
      final isDesignMatch = product.design == selectedGender;
      return isSizeMatch && isLineMatch && isDesignMatch;
    });

    if (productIndex != -1) {
      print(
          "Match found! Product Index: $productIndex, SKU: ${widget.products[productIndex].sku}");
    } else {
      Fluttertoast.showToast(msg: 'No hay producto con esas caracteristicas');
      print("No match found. Defaulting to first product.");
    }

    setState(() {
      selectedProduct = productIndex != -1 ? productIndex : 0;
      print("selecting index: $selectedProduct");
    });
  }

  @override
  Widget build(BuildContext context) {
    final stockValues = Provider.of<StockModel?>(context)?.stock ?? {};
    final userZoneDocument = context.watch<CurrentUserInfo>().zoneDocument;
    final orderActive = Provider.of<OrderProvider>(context);
    final user = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBarNavigation(
        message: AppLocalizations.of(context)!.products,
        userZoneDocument: userZoneDocument,
      ),
      body: NewProductDetailsBody(
        topSection: ProductsDetailsTopSections(
          sku: widget.products[selectedProduct].sku,
          productName: widget.productName,
          selectedSize: selectedSize,
          descripcion: "",
          sizes: widget.sizes,
          onSizeSelected: (value) {
            setState(() {
              selectedSize = value;
              updateSelectedProduct();
            });
          },
        ),
        middleSection: ProductsDetailsMiddleSection(
          priceText: widget.products[selectedProduct].price.toString(),
          stockText:
              stockValues[widget.products[selectedProduct].sku].toString(),
          colorNames: widget.colorOptions,
          selectedDropdownColor: selectedDropdownColor,
          onDropdownColorSelected: (value) {
            setState(() {
              selectedDropdownColor = value;
              updateSelectedProduct();
            });
          },
          genderOptions: widget.genderOptions,
          selectedGender: selectedGender,
          onGenderSelected: (value) {
            setState(() {
              selectedGender = value;
              updateSelectedProduct();
            });
          },
        ),
        bottomSection: BottonSection(
          onAddToCart: () async {
            // Lógica para añadir al carrito
            print("Añadido al carrito con:");
            print("Producto seleccionado: ${widget.products[selectedProduct]}");
            if (orderActive.orderActive == false) {
              bool internet = await checkInternetConnection(context);
              if (internet) {
                orderActive.setOrder(true, null);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(
                      name: "ORDER",
                    ),
                    builder: (context) =>
                        StreamProvider<CurrentUserInfo?>.value(
                      value: usersCollection.doc(user.uid).snapshots().map(
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
                      child: const OrderPage(),
                    ),
                  ),
                );
              }
              if (stockValues[widget.products[selectedProduct].sku]! > 0) {
                final productsInCart =
                    await objectBox.getAllShoppingCartProducts();
                bool isProductAlreadyInCart = false;
                for (var element in productsInCart) {
                  if (element.code == widget.products[selectedProduct].sku) {
                    print(
                        'Product is already in the cart, increasing quantity by 1');
                    isProductAlreadyInCart = true;
                    final updatedProduct = ShoppingCartProduct(
                      id: element.id,
                      availableStock: element.availableStock,
                      productQuantity: element.productQuantity! + 1,
                      code: element.code,
                      listOfPricesId: element.listOfPricesId,
                      name: element.name,
                      productId: element.productId,
                      unitPrice: element.unitPrice.toString(),
                      totalAmount: element.totalAmount.toString(),
                      urlPicture: element.urlPicture.toString(),
                    );
                    if (element.productQuantity! + 1 <=
                        element.availableStock!) {
                      objectBox.insertShoppingCartProduct(updatedProduct);
                      Fluttertoast.showToast(
                          msg:
                              'Producto ${element.code} añadido correctamente');
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              'producto sin stock: ${widget.products[selectedProduct].sku}');
                    }
                    break;
                  }
                }
                if (!isProductAlreadyInCart) {
                  final newProduct = ShoppingCartProduct(
                    productQuantity: 1,
                    code: widget.products[selectedProduct].sku,
                    productId: widget.products[selectedProduct].sku,
                    //listOfPricesId: pricesName.toString(),
                    totalAmount:
                        widget.products[selectedProduct].price.toString(),
                    name: widget.products[selectedProduct].name,
                    unitPrice:
                        widget.products[selectedProduct].price.toString(),
                    availableStock:
                        stockValues[widget.products[selectedProduct].sku],
                    //urlPicture: catalogueID.toString(),
                  );
                  if (newProduct.productQuantity! <=
                      newProduct.availableStock!) {
                    objectBox.insertShoppingCartProduct(newProduct);
                    Fluttertoast.showToast(
                        msg:
                            'Producto ${newProduct.code} añadido correctamente');
                  } else {
                    Fluttertoast.showToast(
                        msg:
                            'producto sin stock: ${widget.products[selectedProduct].sku}');
                  }
                }
              } else {
                Fluttertoast.showToast(
                    msg: 'No hay stock disponible para este producto');
              }
            } else {
              if (stockValues[widget.products[selectedProduct].sku]! > 0) {
                final productsInCart =
                    await objectBox.getAllShoppingCartProducts();
                bool isProductAlreadyInCart = false;
                for (var element in productsInCart) {
                  if (element.code == widget.products[selectedProduct].sku) {
                    print(
                        'Product is already in the cart, increasing quantity by 1');
                    isProductAlreadyInCart = true;
                    final updatedProduct = ShoppingCartProduct(
                      id: element.id,
                      availableStock: element.availableStock,
                      productQuantity: element.productQuantity! + 1,
                      code: element.code,
                      listOfPricesId: element.listOfPricesId,
                      name: element.name,
                      productId: element.productId,
                      unitPrice: element.unitPrice.toString(),
                      totalAmount: element.totalAmount.toString(),
                      urlPicture: element.urlPicture.toString(),
                    );
                    if (element.productQuantity! + 1 <=
                        element.availableStock!) {
                      objectBox.insertShoppingCartProduct(updatedProduct);
                      Fluttertoast.showToast(
                          msg:
                              'Producto ${element.code} añadido correctamente');
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              'producto sin stock: ${widget.products[selectedProduct].sku}');
                    }
                    break;
                  }
                }
                if (!isProductAlreadyInCart) {
                  final newProduct = ShoppingCartProduct(
                    productQuantity: 1,
                    code: widget.products[selectedProduct].sku,
                    productId: widget.products[selectedProduct].sku,
                    //listOfPricesId: pricesName.toString(),
                    totalAmount:
                        widget.products[selectedProduct].price.toString(),
                    name: widget.products[selectedProduct].name,
                    unitPrice:
                        widget.products[selectedProduct].price.toString(),
                    availableStock:
                        stockValues[widget.products[selectedProduct].sku],
                    //urlPicture: catalogueID.toString(),
                  );
                  if (newProduct.productQuantity! <=
                      newProduct.availableStock!) {
                    objectBox.insertShoppingCartProduct(newProduct);
                    Fluttertoast.showToast(
                        msg:
                            'Producto ${newProduct.code} añadido correctamente');
                  } else {
                    Fluttertoast.showToast(
                        msg:
                            'producto sin stock: ${widget.products[selectedProduct].sku}');
                  }
                }
              } else {
                Fluttertoast.showToast(
                    msg: 'No hay stock disponible para este producto');
              }
            }
          },
        ),
      ),
    );
  }
}
