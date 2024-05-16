// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/product_details/product_details.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/services/cloud_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MostSelledProducts extends StatefulWidget {
  const MostSelledProducts({Key? key}) : super(key: key);

  @override
  State<MostSelledProducts> createState() => _MostSelledProductsState();
}

class _MostSelledProductsState extends State<MostSelledProducts> {
  @override
  Widget build(BuildContext context) {
    // final productsBySales = Provider.of<List<ProductsByDate>?>(context) ?? [];

    final linesSummary = Provider.of<LineSummary?>(context)?.summary ?? {};
    final stockValues = Provider.of<StockModel?>(context)?.stock ?? {};
    final products = Provider.of<List<Products>?>(context) ?? [];
    final prices = Provider.of<Prices?>(context)?.prices ?? {};
    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;
    final pricesName = Provider.of<Prices?>(context)?.name ?? {};

    return FutureBuilder(
      future: getDataFromBQ(queryProductosMasVendidos),
      builder: (context, snapshot) {
        final List<ProductsByDate> productsBySales = [];
        var productsBySalesList = productsBySales;
        if (snapshot.hasData) {
          final data = snapshot.data! as List;
          // print(data);
          data.forEach(
            (el) {
              String elQuality = el['calidad'];
              String quality = elQuality.replaceAll(RegExp('"'), '');
              String elCatalogue = el['catalogo'];
              String catalogue = elCatalogue.replaceAll(RegExp('"'), '');
              String elCategorie = el['categoria'];
              String categorie = elCategorie.replaceAll(RegExp('"'), '');
              String elCode = el['codigo'];
              String code = elCode.replaceAll(RegExp('"'), '');
              String elDesign = el['diseno'];
              String design = elDesign.replaceAll(RegExp('"'), '');
              String elBrand = el['marca'];
              String brand = elBrand.replaceAll(RegExp('"'), '');
              String elName = el['nombre'];
              String name = elName.replaceAll(RegExp('"'), '');
              String elSubcategorie = el['subcategoria'];
              String subcategorie = elSubcategorie.replaceAll(RegExp('"'), '');
              String elSize = el['tamano'];
              String size = elSize.replaceAll(RegExp('"'), '');
              String elLine = el['linea'];
              String line = elLine.replaceAll(RegExp('"'), '');

              var msp = ProductsByDate(
                quality: firebase.doc(quality).id,
                catalogue: firebase.doc(catalogue).id,
                categorie: firebase.doc(categorie).id,
                code: code,
                design: firebase.doc(design).id,
                line: firebase.doc(line).id,
                brand: firebase.doc(brand).id,
                lastModifiedDate: Timestamp.now(),
                name: name,
                subCategorie: firebase.doc(subcategorie).id,
                size: firebase.doc(size).id,
                selected: false,
              );

              productsBySales.add(msp);
            },
          );
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
                        color: myTheme.colorScheme.onPrimaryContainer,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      AppLocalizations.of(context)!.mostSelled,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: myTheme.colorScheme.onPrimaryContainer,
                        letterSpacing: 0.15,
                        fontSize: 16,
                        fontFamily: 'Poppins-medium',
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
                    itemCount: productsBySalesList.length,
                    itemBuilder: (BuildContext context, index) {
                      final product = productsBySalesList[index];
                      if ((stockValues[product.code] ?? 000) > 0) {
                        return FutureBuilder<String>(
                          future: storage
                              .ref()
                              .child('imagenes')
                              .child('productos')
                              .child(product.code)
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
                                  print(prices[product.code]);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProductDetails(
                                        code: product.code,
                                        line: linesSummary[product.line],
                                        imageUrl: url,
                                        isProductNew: false,
                                        price: (double.parse(
                                          prices[product.code].toString(),
                                        )),
                                        name: product.name,
                                        stock: stockValues[product.code] ?? 0,
                                        list: productsBySalesList
                                            .where((element) =>
                                                element.name == product.name)
                                            .toList(),
                                        isProductInAPromotion: false,
                                        prices: prices,
                                        catalogueID: product.catalogue,
                                        userZoneDocument: userZoneDocument,
                                        showListButton: true,
                                        // pricesName: pricesName,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: productsBySales.last == product
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          height: 150,
                                          width: 160,
                                          child: CachedNetworkImage(
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
                                            5.0, 0, 0, 18),
                                        child: Text(
                                          '${product.name}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: myTheme
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
                                  final counterLimitProvider =
                                      Provider.of<CounterLimitFirestore>(
                                          context,
                                          listen: false);
                                  if (products.length > 100) {
                                    counterLimitProvider.setProductsLimit(
                                        10, 10);
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProductDetails(
                                        code: product.code,
                                        price: (double.parse(
                                          prices[product.code].toString(),
                                        )),
                                        line: linesSummary[product.line],
                                        imageUrl:
                                            'https://i.imgur.com/BPbj6Gy.jpg',
                                        isProductNew: false,
                                        name: product.name,
                                        stock: stockValues[product.code] ?? 0,
                                        list: productsBySalesList
                                            .where((element) =>
                                                element.name == product.name)
                                            .toList(),
                                        isProductInAPromotion: false,
                                        prices: prices,
                                        userZoneDocument: userZoneDocument,
                                        showListButton: true,
                                        pricesName: pricesName,
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
                                          '${product.name}',
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: myTheme
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
                        // return Container();
                        return FutureBuilder<String>(
                          future: storage
                              .ref()
                              .child('imagenes')
                              .child('productos')
                              .child(product.code)
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
                                },
                                child: Container(
                                  margin: productsBySales.last == product
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: SizedBox(
                                          height: 150,
                                          width: 160,
                                          child: CachedNetworkImage(
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
                                            5.0, 0, 0, 18),
                                        child: Text(
                                          '${product.name}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: myTheme
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
                                  final counterLimitProvider =
                                      Provider.of<CounterLimitFirestore>(
                                          context,
                                          listen: false);
                                  if (products.length > 100) {
                                    counterLimitProvider.setProductsLimit(
                                        10, 10);
                                  }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProductDetails(
                                        code: product.code,
                                        price: (double.parse(
                                          prices[product.code].toString(),
                                        )),
                                        line: linesSummary[product.line],
                                        imageUrl:
                                            'https://i.imgur.com/BPbj6Gy.jpg',
                                        isProductNew: false,
                                        name: product.name,
                                        stock: stockValues[product.code] ?? 0,
                                        list: productsBySalesList
                                            .where((element) =>
                                                element.name == product.name)
                                            .toList(),
                                        isProductInAPromotion: false,
                                        prices: prices,
                                        userZoneDocument: userZoneDocument,
                                        showListButton: true,
                                        pricesName: pricesName,
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
                                          '${product.name}',
                                          textAlign: TextAlign.start,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: myTheme
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
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
              child: Container(
            child: Text('Error cargando productos mas vendidos'),
          ));
        } else {
          return Container();
        }
      },
    );
  }
}
