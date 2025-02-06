// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/features/product/data/product_list_info.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/screens/detail_product.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/product_details/product_details.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/services/cloud_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/utils/custom_cache_manager.dart';

class MostSelledProducts extends StatefulWidget {
  const MostSelledProducts({Key? key}) : super(key: key);

  @override
  State<MostSelledProducts> createState() => _MostSelledProductsState();
}

class _MostSelledProductsState extends State<MostSelledProducts> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final stockValues = Provider.of<StockModel?>(context)?.stock ?? {};

    return FutureBuilder<ProductListInfo>(
      future: ProductListInfo.instance,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error loading products: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData || ProductListInfo.products.isEmpty) {
          return const Center(child: Text("Sin productos disponibles"));
        }

        // Get product list and filter out empty product variants
        final items = ProductListInfo.products;
        final filteredItems =
            items.where((item) => item.products.isNotEmpty).toList();

        // Sort by totalSold in descending order
        filteredItems.sort((a, b) => b.totalSold.compareTo(a.totalSold));

        // Limit to the top 10 items
        final topItems = filteredItems.take(10).toList();
        return Container(
          margin: const EdgeInsets.fromLTRB(0, 12.0, 0, 15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Icon(
                      MaterialCommunityIcons.chart_timeline_variant_shimmer,
                      color:
                          themeProvider.myTheme.colorScheme.onPrimaryContainer,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    AppLocalizations.of(context)!.mostSelled,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color:
                          themeProvider.myTheme.colorScheme.onPrimaryContainer,
                      letterSpacing: 0.15,
                      fontSize: 16,
                      fontFamily: 'Poppins-Medium',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 230,
                width: double.infinity,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: topItems.length,
                  itemBuilder: (BuildContext context, index) {
                    final product = topItems[index];
                    if ((stockValues[product.products.first.sku] ?? 000) > 0) {
                      return FutureBuilder<String>(
                        future: storage
                            .ref()
                            .child('imagenes')
                            .child('productos')
                            .child(product.products.first.sku)
                            .child('1')
                            .getDownloadURL()
                            .catchError((e) {
                          return '';
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            String url = snapshot.data!.toString();
                            return GestureDetector(
                              onTap: () {
                                final formattedPrice =
                                    NumberFormat("\$#,##0.00")
                                        .format(product.basePrice);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MultiProvider(
                                      providers: [
                                        StreamProvider<StockModel?>.value(
                                          value: DatabaseServiceStreams()
                                              .stockValues,
                                          initialData: null,
                                          catchError: (context, error) {
                                            return;
                                          },
                                        ),
                                      ],
                                      child: ProductDetailUI(
                                        productName: product.nameProduct,
                                        priceText: formattedPrice,
                                        sizes: product.availableSizes,
                                        colorOptions: product.availableLines,
                                        genderOptions: product.availableDesigns,
                                        products: product.products,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: topItems.last == product
                                    ? const EdgeInsets.fromLTRB(16, 12, 16, 0)
                                    : const EdgeInsets.fromLTRB(16, 12, 0, 0),
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.transparent,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: SizedBox(
                                        height: 150,
                                        width: 160,
                                        child: CachedNetworkImage(
                                          cacheManager:
                                              CustomCacheManager.instance,
                                          fit: BoxFit.cover,
                                          imageUrl: url,
                                          placeholder: (context, url) =>
                                              Container(
                                            alignment: Alignment.center,
                                            width: 300,
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            'assets/images/noproduct.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          5.0, 0, 0, 18),
                                      child: Text(
                                        '${product.nameProduct}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: themeProvider.myTheme
                                              .colorScheme.onPrimaryContainer,
                                          fontFamily: 'Poppins-Regular',
                                          fontSize: 12,
                                          letterSpacing: 0.25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return GestureDetector(
                              onTap: () {
                                final formattedPrice =
                                    NumberFormat("\$#,##0.00")
                                        .format(product.basePrice);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MultiProvider(
                                      providers: [
                                        StreamProvider<StockModel?>.value(
                                          value: DatabaseServiceStreams()
                                              .stockValues,
                                          initialData: null,
                                          catchError: (context, error) {
                                            return;
                                          },
                                        ),
                                      ],
                                      child: ProductDetailUI(
                                        productName: product.nameProduct,
                                        priceText: formattedPrice,
                                        sizes: product.availableSizes,
                                        colorOptions: product.availableLines,
                                        genderOptions: product.availableDesigns,
                                        products: product.products,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(
                                    0.0, 12.0, 16.0, 8),
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        height: 150,
                                        width: 160,
                                        child: Image.network(
                                          'https://i.imgur.com/BPbj6Gy.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(5, 0, 0, 4),
                                      child: Text(
                                        '${product.nameProduct}',
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: themeProvider.myTheme
                                              .colorScheme.onPrimaryContainer,
                                          fontFamily: 'Poppins-Regular',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox(
                              width: 140,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      // return Container();
                      return FutureBuilder<String>(
                        future: storage
                            .ref()
                            .child('imagenes')
                            .child('productos')
                            .child(product.products.first.sku)
                            .child('1')
                            .getDownloadURL()
                            .catchError((e) {
                          return '';
                        }),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final url = snapshot.data!.toString();
                            return GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      backgroundColor: themeProvider
                                          .myTheme.colorScheme.primary,
                                      duration: const Duration(seconds: 1),
                                      content: const Text(
                                        "No hay stock disponible de este producto",
                                        style: TextStyle(
                                          fontFamily: 'Poppins-Regular',
                                        ),
                                      ),
                                    ),
                                  );
                              },
                              child: Container(
                                margin: topItems.last == product
                                    ? const EdgeInsets.fromLTRB(16, 12, 16, 0)
                                    : const EdgeInsets.fromLTRB(16, 12, 0, 0),
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.transparent,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: SizedBox(
                                        height: 150,
                                        width: 160,
                                        child: CachedNetworkImage(
                                          cacheManager:
                                              CustomCacheManager.instance,
                                          fit: BoxFit.cover,
                                          imageUrl: url,
                                          placeholder: (context, url) =>
                                              Container(
                                            alignment: Alignment.center,
                                            width: 300,
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            'assets/images/noproduct.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          5.0, 0, 0, 18),
                                      child: Text(
                                        '${product.nameProduct}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: themeProvider.myTheme
                                              .colorScheme.onPrimaryContainer,
                                          fontFamily: 'Poppins-Regular',
                                          fontSize: 12,
                                          letterSpacing: 0.25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return GestureDetector(
                              onTap: () {
                                final formattedPrice =
                                    NumberFormat("\$#,##0.00")
                                        .format(product.basePrice);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MultiProvider(
                                      providers: [
                                        StreamProvider<StockModel?>.value(
                                          value: DatabaseServiceStreams()
                                              .stockValues,
                                          initialData: null,
                                          catchError: (context, error) {
                                            return;
                                          },
                                        ),
                                      ],
                                      child: ProductDetailUI(
                                        productName: product.nameProduct,
                                        priceText: formattedPrice,
                                        sizes: product.availableSizes,
                                        colorOptions: product.availableLines,
                                        genderOptions: product.availableDesigns,
                                        products: product.products,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(
                                    0.0, 12.0, 16.0, 8),
                                width: 140,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        height: 150,
                                        width: 160,
                                        child: Image.network(
                                          'https://i.imgur.com/BPbj6Gy.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          const EdgeInsets.fromLTRB(5, 0, 0, 4),
                                      child: Text(
                                        '${product.nameProduct}',
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: themeProvider.myTheme
                                              .colorScheme.onPrimaryContainer,
                                          fontFamily: 'Poppins-Regular',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox(
                              width: 140,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
