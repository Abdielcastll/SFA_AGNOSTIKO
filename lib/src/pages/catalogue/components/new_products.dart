import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/features/product/data/product_list_info.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/screens/detail_product.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pwa_sales2go_flutter/src/utils/custom_cache_manager.dart';

class NewProductsWidget extends StatefulWidget {
  const NewProductsWidget({Key? key}) : super(key: key);

  @override
  State<NewProductsWidget> createState() => _NewProductsWidgetState();
}

class _NewProductsWidgetState extends State<NewProductsWidget> {
  @override
  Widget build(BuildContext context) {
    final stockValues = Provider.of<StockModel?>(context)?.stock ?? {};
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

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

          // Sort by newestProduct in descending order (most recent first)
          filteredItems
              .sort((a, b) => b.newestProduct.compareTo(a.newestProduct));

          // Limit to the top 10 newest items
          final topNewestItems = filteredItems.take(10).toList();

          return Container(
            margin: const EdgeInsets.fromLTRB(0, 12.0, 0, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Icon(
                          MaterialIcons.auto_awesome,
                          color: themeProvider
                              .myTheme.colorScheme.onPrimaryContainer,
                          size: 19,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    Container(
                      child: Text(
                        AppLocalizations.of(context)!.newProducts,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: themeProvider
                              .myTheme.colorScheme.onPrimaryContainer,
                          letterSpacing: 0.15,
                          fontSize: 16,
                          fontFamily: 'Poppins-Medium',
                        ),
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
                    itemCount: topNewestItems.length,
                    itemBuilder: (BuildContext context, index) {
                      final product = topNewestItems[index];
                      if ((stockValues[product.products.first.sku] ?? 000) >
                          0) {
                        return FutureBuilder<String?>(
                          future: storage
                              .ref()
                              .child('imagenes')
                              .child('productos')
                              .child(product.products.first.sku)
                              .child('1')
                              .getDownloadURL()
                              .catchError((e) {
                            print(e);
                            return e.message;
                          }),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final url = snapshot.data?.toString();
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
                                          genderOptions:
                                              product.availableDesigns,
                                          products: product.products,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: topNewestItems.last == product
                                      ? const EdgeInsets.fromLTRB(16, 12, 16, 8)
                                      : const EdgeInsets.fromLTRB(16, 12, 0, 8),
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          height: 150,
                                          width: 160,
                                          child: CachedNetworkImage(
                                            cacheManager:
                                                CustomCacheManager.instance,
                                            fit: BoxFit.cover,
                                            imageUrl: url!,
                                            placeholder: (context, url) =>
                                                Container(
                                                    alignment: Alignment.center,
                                                    width: 300,
                                                    child: const Center(
                                                        child:
                                                            CircularProgressIndicator())),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              'assets/images/noproduct.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 15),
                                        child: Text(
                                          product.nameProduct,
                                          textAlign: TextAlign.left,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: themeProvider.myTheme
                                                .colorScheme.onPrimaryContainer,
                                            fontFamily: 'Poppins-regular',
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
                                          genderOptions:
                                              product.availableDesigns,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        margin: const EdgeInsets.fromLTRB(
                                            5, 0, 0, 4),
                                        child: Text(
                                          product.nameProduct,
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: themeProvider.myTheme
                                                .colorScheme.onPrimaryContainer,
                                            fontFamily: 'Poppins-regular',
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
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
