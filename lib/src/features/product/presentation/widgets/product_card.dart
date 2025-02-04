import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/core/font_size.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/entitites/base_product_entity.dart';
import 'package:pwa_sales2go_flutter/src/features/product/presentation/screens/detail_product.dart';
import 'package:pwa_sales2go_flutter/src/models/stock_model.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/services/database_streams.dart';
import 'package:pwa_sales2go_flutter/src/utils/custom_cache_manager.dart';

class ProductCard extends StatelessWidget {
  final BaseProductEntity baseProduct;
  final String sku;

  const ProductCard({
    super.key,
    required this.baseProduct,
    required this.sku,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice =
        NumberFormat("\$#,##0.00").format(baseProduct.basePrice);
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MultiProvider(
              providers: [
                StreamProvider<StockModel?>.value(
                  value: DatabaseServiceStreams().stockValues,
                  initialData: null,
                  catchError: (context, error) {
                    return;
                  },
                ),
              ],
              child: ProductDetailUI(
                productName: baseProduct.nameProduct,
                priceText: formattedPrice,
                sizes: baseProduct.availableSizes,
                colorOptions: baseProduct.availableLines,
                genderOptions: baseProduct.availableDesigns,
                products: baseProduct.products,
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: colorScheme.inversePrimary,
        ),
        child: Column(
          children: [
            Expanded(
                flex: 3,
                child: FutureBuilder<String>(
                  future: _getProductThumbnailUrl(sku),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.expand();
                    }

                    final url = snapshot.data as String;
                    return ProductThumbnail(url);
                  },
                )),
            Expanded(
              flex: 2,
              child: ProductDescription(baseProduct),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> _getProductThumbnailUrl(String sku) async {
  const defaultImage = 'assets/images/noproduct.jpg';

  final String imageUrl = await storage
      .ref()
      .child('imagenes')
      .child('productos')
      .child(sku)
      .child('1')
      .getDownloadURL()
      .catchError((e) {
    debugPrint("Cannot get image $e, setting default");
    return defaultImage;
  });

  return imageUrl.isNotEmpty ? imageUrl : defaultImage;
}

class ProductThumbnail extends StatelessWidget {
  final String imageUrl;
  const ProductThumbnail(
    this.imageUrl, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl,
      cacheManager: CustomCacheManager.instance,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
          Image.asset(imageUrl, fit: BoxFit.cover),
    );
  }
}

Widget _buildConditionalAvailableList(List<dynamic> list, TextStyle textStyle,
    {String prefix = "Disponible en"}) {
  list.removeWhere((element) => element == "NA");

  if (list.isEmpty) {
    return const SizedBox.shrink();
  }

  return Text(
    "$prefix: ${list.join(", ")}",
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: textStyle,
  );
}

class ProductDescription extends StatelessWidget {
  final BaseProductEntity baseProduct;
  const ProductDescription(
    this.baseProduct, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice =
        NumberFormat("\$#,##0.00").format(baseProduct.basePrice);

    final boldText =
        TextStyle(fontWeight: FontWeight.bold, fontSize: FontSize.fontL);
    final ligthText =
        TextStyle(fontWeight: FontWeight.w200, fontSize: FontSize.fontS);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            baseProduct.nameProduct,
            style: boldText,
          ),
          _buildConditionalAvailableList(
            baseProduct.availableDesigns,
            ligthText,
            prefix: "Diseños",
          ),
          _buildConditionalAvailableList(
            List.from(baseProduct.availableSizes.map((e) => e.abbr)),
            ligthText,
            prefix: "Tallas",
          ),
          _buildConditionalAvailableList(
            baseProduct.availableLines,
            ligthText,
            prefix: "Lineas",
          ),
          Text(
            formattedPrice,
            style: boldText,
          ),
        ],
      ),
    );
  }
}
