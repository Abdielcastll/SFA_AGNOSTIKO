import 'package:pwa_sales2go_flutter/src/features/product/domain/entitites/product_variant_entity.dart';
import 'package:pwa_sales2go_flutter/src/features/product/domain/enums/product_size_enum.dart';

class BaseProductEntity {
  final String nameProduct;
  final String mainImageUrl;
  final String description;
  final double basePrice;
  final List<ProductSize> availableSizes;
  final List<String> availableDesigns;
  final List<String> availableLines;
  final List<ProductVariantEntity> products;

  BaseProductEntity({
    required this.nameProduct,
    required this.mainImageUrl,
    required this.description,
    required this.basePrice,
    required this.availableSizes,
    required this.availableDesigns,
    required this.availableLines,
    required this.products,
  });

  factory BaseProductEntity.fromJson(Map<String, dynamic> json) {
    print("vamos a parsear:");
    print(json);
    final productos = (json['productos'] as List<dynamic>).map((productJson) {
      // Explicitly cast productJson to Map<String, dynamic>
      final productMap =
          Map<String, dynamic>.from(productJson as Map<Object?, Object?>);
      return ProductVariantEntity.fromJson(productMap);
    }).toList();
   

    // Extract the lowest price
    final double basePrice = productos.isNotEmpty
        ? productos.map((e) => e.price).reduce((a, b) => a < b ? a : b)
        : 0.0;

    // Extract unique lines from products
    final availableLines =
        (json['linea'] as List<dynamic>).map((e) => e.toString()).toList();
        print("See lINEA: $availableLines");

    // Map availableSizes from "tamanio"
    final availableSizes = (json['tamanio'] as List<dynamic>)
        .map((size) => ProductSizeExtension.fromString(size.toString()))
        .toList();
     print("See lINEA: $availableSizes");
    // Map availableDesigns from "disenio"
    final availableDesigns =
        (json['disenio'] as List<dynamic>).map((e) => e.toString()).toList();

        print("See lINEA: $availableDesigns");

    return BaseProductEntity(
      nameProduct: json['nombre'] as String? ?? '',
      mainImageUrl: '', // Placeholder for now
      description: '', // Placeholder for now
      basePrice: basePrice,
      availableSizes: availableSizes,
      availableDesigns: availableDesigns,
      availableLines: availableLines,
      products: productos,
    );
  }
}
