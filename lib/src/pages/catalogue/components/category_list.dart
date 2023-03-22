// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/src/models/prices_model.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/summary_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/products/products_page.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListOfCategories extends StatefulWidget {
  const ListOfCategories({Key? key}) : super(key: key);

  @override
  State<ListOfCategories> createState() => _ListOfCategoriesState();
}

class _ListOfCategoriesState extends State<ListOfCategories> {
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CategorieSummary?>(context)?.summary ?? {};
    List<MapEntry<String, dynamic>> listData = categories.entries.toList();
    listData.sort(
      (a, b) => a.value.toLowerCase().compareTo(
            b.value.toLowerCase(),
          ),
    );
    final Map<String, dynamic> sortedListData = Map.fromEntries(listData);
    final prices = Provider.of<Prices?>(context)?.prices ?? {};
    final pricesName = Provider.of<Prices?>(context)?.name ?? {};
    final products = Provider.of<List<Products>?>(context) ?? [];
    List categoriesSummary = sortedListData.values.toList();
    List categorieKeys = sortedListData.keys.toList();
    final userZoneDocument = Provider.of<CurrentUserInfo>(context).zoneDocument;
    // print(categorieKeys);
    // print(categoriesSummary);
    // print(productsList);
    print(products.length);
    print('CANTIDAD PRODUCTOS DB');
    print(sortedListData);
    // categorieKeys.sort((a, b) {
    //   return a.toLowerCase().compareTo(b.toLowerCase());
    // });
    // categoriesSummary.sort((a, b) {
    //   return a.toLowerCase().compareTo(b.toLowerCase());
    // });
    // categories.sort((a, b) {
    //   return a.toLowerCase().compareTo(b.toLowerCase());
    // });
    // print(categories);
    // print(categoriesSummary);

    return Container(
      margin: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.category_outlined,
                color: myTheme.colorScheme.onPrimaryContainer,
                size: 20.0,
              ),
              SizedBox(width: 8.0),
              Text(
                AppLocalizations.of(context)!.catalogue,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: myTheme.colorScheme.onPrimaryContainer,
                  fontSize: 16.0,
                  fontFamily: 'Poppins-regular',
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            height: 200,
            width: double.infinity,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount:
                  // 1,
                  categoriesSummary.length,
              itemBuilder: (BuildContext context, index) {
                final categorie = categoriesSummary[index];
                final key = categorieKeys[index];
                return GestureDetector(
                  onTap: () async {
                    List<Products>? filteredProducts = [];
                    filteredProducts.clear();
                    // print(categoriesCollection.doc(key));

                    await productsCollection
                        .where('categoria',
                            isEqualTo: categoriesCollection.doc(key))
                        .snapshots()
                        .forEach((element) {
                      for (var element in element.docs) {
                        Products product = Products(
                          quality: element.data()['calidad'].id ?? '',
                          catalogue: element.data()['catalogo'].id ?? '',
                          categorie: element.data()['categoria'].id ?? '',
                          code: element.data()['codigo'] ?? '',
                          design: element.data()['diseno'].id ?? '',
                          line: element.data()['linea'].id ?? '',
                          brand: element.data()['marca'].id ?? '',
                          lastModifiedDate: element.data()['modificado'] ?? '',
                          name: element.data()['nombre'] ?? '',
                          subCategorie: element.data()['subcategoria'].id ?? '',
                          size: element.data()['tamano'].id ?? '',
                          promotion:
                              element.data().toString().contains('promocion')
                                  ? element.data()['promocion'].id
                                  : '',
                          selected: false,
                        );
                        // print(product.categorie);
                        setState(() {
                          filteredProducts.add(product);
                        });
                      }
                      print(filteredProducts);
                      print(filteredProducts.first.name);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ProductsPage(
                            listOfProducts: filteredProducts,
                            listOfPrices: prices,
                            userZoneDocument: userZoneDocument,
                            showFullList: false,
                            pricesName: pricesName,
                          ),
                        ),
                      );
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0),
                    height: 240,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8)),
                            height: 240,
                            width: 120,
                            child: FutureBuilder(
                              future: productsCollection
                                  .where('categoria',
                                      isEqualTo: categoriesCollection.doc(key))
                                  .orderBy('modificado', descending: true)
                                  .limit(1)
                                  .snapshots()
                                  .first
                                  .then(
                                (value) {
                                  var cataloguePath = value.docs;
                                  print(
                                      'PRINTING CATALOGUE PATHs IDs IN CATEGORY LIST');
                                  for (var path in cataloguePath) {
                                    print(path.id);
                                    print(path.get('nombre'));
                                    var catalogueId = path
                                            .data()
                                            .toString()
                                            .contains('catalogo')
                                        ? path.get('catalogo').id
                                        : 'NO CATALOGUE ID FOUND';
                                    print(catalogueId);

                                    // print('TEST TO GET IMAGE');

                                    return catalogueId;
                                  }
                                },
                              ).catchError((e) {
                                print(
                                    'ERROR ON GETTING IMAGE PATH FROM FIREBASE COLLECTION IN CATEGORY LIST');
                                print(e);
                              }),
                              builder: (context, snapshot) {
                                final catalogueID = snapshot.data!.toString();
                                if (snapshot.hasData) {
                                  return FutureBuilder<String?>(
                                    future: FirebaseStorage.instance
                                        .ref()
                                        .child('imagenes')
                                        .child('catalogos')
                                        .child(catalogueID)
                                        .child('1')
                                        .getDownloadURL()
                                        .catchError((e) {
                                      print(
                                          'ERROR ON GETTING IMAGE FROM FIREBASE STORAGE IN CATEGORY LIST');
                                      print(e);
                                      return 'assets/images/nocategorie.jpg';
                                    }),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final url = snapshot.data!.toString();
                                        print('URL FOR CATEGORIE');
                                        print(url);
                                        return CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              // 'assets/images/nocategorie.jpg',
                                              url,
                                          placeholder: (context, url) =>
                                              Container(
                                            width: 300,
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            'assets/images/nocategorie.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              'https://i.imgur.com/H9rVf4m.jpg',
                                          placeholder: (context, url) =>
                                              Container(
                                            width: 300,
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            'assets/images/nocategorie.jpg',
                                            fit: BoxFit.cover,
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
                                  return const SizedBox(
                                    width: 140,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                end: const Alignment(0.0, -1),
                                begin: const Alignment(0.0, 0.4),
                                colors: <Color>[
                                  const Color(0x8A000000),
                                  Colors.black12.withOpacity(0.0)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 0, 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            '$categorie',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Poppins-regular',
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
