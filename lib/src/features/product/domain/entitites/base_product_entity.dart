import 'package:pwa_sales2go_flutter/src/features/product/domain/entitites/product_variant_entity.dart';

class BaseProductEntity {
  final String nameProduct;
  final String mainImageUrl;
  final String description;
  final double basePrice;
  final List<String> availableSizes;
  final List<String> availableDesigns;
  final List<String> availableLines;
  final List<ProductVariantEntity> products;
  final int totalSold;
  final DateTime newestProduct;

  BaseProductEntity({
    required this.nameProduct,
    required this.mainImageUrl,
    required this.description,
    required this.basePrice,
    required this.availableSizes,
    required this.availableDesigns,
    required this.availableLines,
    required this.products,
    required this.totalSold,
    required this.newestProduct,
  });

  factory BaseProductEntity.fromJson(Map<String, dynamic> json) {
    print("vamos a parsear:");
    print(json);

    final productos = (json['productos'] as List<dynamic>).map((productJson) {
      final productMap =
          Map<String, dynamic>.from(productJson as Map<Object?, Object?>);
      return ProductVariantEntity.fromJson(productMap);
    }).toList();

    // Extract the lowest price
    final double basePrice = productos.isNotEmpty
        ? productos.map((e) => e.price).reduce((a, b) => a < b ? a : b)
        : 0.0;

    // Compute total sold
    final int totalSold =
        productos.fold(0, (sum, product) => sum + product.timesSold);

    // Find the most recent modified date
    final DateTime newestProduct = productos.isNotEmpty
        ? productos
            .map((e) => e.lastModified)
            .reduce((a, b) => a.isAfter(b) ? a : b)
        : DateTime(1970, 1, 1);

    // Extract unique lines from products
    final availableLines =
        (json['linea'] as List<dynamic>).map((e) => e.toString()).toList();
    print("See lINEA: $availableLines");

    // Map availableSizes from "tamanio"
    final availableSizes = (json['tamanio'] as List<dynamic>)
        .map((size) => size.toString())
        .toList();
    print("See Sizes: $availableSizes");

    // Map availableDesigns from "disenio"
    final availableDesigns =
        (json['disenio'] as List<dynamic>).map((e) => e.toString()).toList();
    print("See Designs: $availableDesigns");

    return BaseProductEntity(
      nameProduct: json['nombre'] as String? ?? '',
      mainImageUrl: '', // Placeholder for now
      description: '', // Placeholder for now
      basePrice: basePrice,
      availableSizes: availableSizes,
      availableDesigns: availableDesigns,
      availableLines: availableLines,
      products: productos,
      totalSold: totalSold,
      newestProduct: newestProduct,
    );
  }
}
