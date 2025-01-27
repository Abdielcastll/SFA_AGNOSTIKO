// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/utils/custom_cache_manager.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String productDescription;
  final double productPrice;
  final String sku;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.sku,
  });

  @override
  Widget build(BuildContext context) {
    final formatedPrice = NumberFormat("\$#,##0.00").format(productPrice);

    return GestureDetector(
      onTap: () => print("Go to details page"),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder<String>(
                future: storage
                    .ref()
                    .child('imagenes')
                    .child('productos')
                    .child(sku)
                    .child('1')
                    .getDownloadURL()
                    .catchError((e) {
                  print('ERROR GETTING IMG');
                  print(e);
                  return ''; // Return an empty string if there's an error.
                }),
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
                      height: 100,
                      'assets/images/noproduct.jpg',
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
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      height: 100,
                      'assets/images/noproduct.jpg',
                      fit: BoxFit.fitHeight,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    productDescription,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    formatedPrice,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
