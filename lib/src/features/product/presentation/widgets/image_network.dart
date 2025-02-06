import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/services/database_functions.dart';
import 'package:pwa_sales2go_flutter/src/utils/custom_cache_manager.dart';

class ImageFromInternet extends StatelessWidget {
  final String sku;
  final double width;
  final double height;
  final BoxFit fit;

  const ImageFromInternet({
    Key? key,
    required this.sku,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CircularProgressIndicator(),
          FutureBuilder<String>(
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
                  height: MediaQuery.of(context).size.width * 0.6,
                  width: MediaQuery.of(context).size.width * 0.5,
                  'assets/images/noproduct.jpg',
                  fit: BoxFit.fitHeight,
                );
              }

              final url = snapshot.data!;

              return CachedNetworkImage(
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width * 0.5,
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
                  height: MediaQuery.of(context).size.width * 0.6,
                  width: MediaQuery.of(context).size.width * 0.5,
                  'assets/images/noproduct.jpg',
                  fit: BoxFit.fitHeight,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
