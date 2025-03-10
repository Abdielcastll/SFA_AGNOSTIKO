class ProductVariantEntity {
  final String productId;
  final String quality;
  final String category;
  final String sku;
  final String barCode;
  final String design;
  final String line;
  final String brand;
  final String name;
  final String subCategory;
  final String size;
  final double price;
  final List<String> imageUrl;
  final int stock;
  final int timesSold;
  final DateTime lastModified;

  ProductVariantEntity({
    required this.productId,
    required this.quality,
    required this.category,
    required this.sku,
    required this.barCode,
    required this.design,
    required this.line,
    required this.brand,
    required this.name,
    required this.subCategory,
    required this.size,
    required this.price,
    required this.imageUrl,
    required this.stock,
    required this.lastModified,
    required this.timesSold,
  });

  factory ProductVariantEntity.fromJson(Map<String, dynamic> json) {
    return ProductVariantEntity(
      productId: json['id'] as String? ?? '',
      quality: json['calidad'] as String? ?? '',
      category: json['categoria'] as String? ?? '',
      sku: json['codigo'] as String? ?? '',
      barCode: json['codigoBarra'] as String? ?? '',
      design: json['disenio'] as String? ?? '',
      line: json['linea'] as String? ?? '',
      brand: json['marca'] as String? ?? '',
      name: json['nombre'] as String? ?? '',
      subCategory: json['subcategoria'] as String? ?? '',
      size: json['tamano'] as String? ?? '',
      price: (json['precio'] as num?)?.toDouble() ?? 0.0,
      imageUrl: [], // Placeholder if no image URLs available in the JSON
      stock: 0, // Placeholder if no stock info is available in the JSON
      timesSold: (json['cantidadVecesVendida'] as num?)?.toInt() ?? 0,
      lastModified: json['modificado'] is String
          ? DateTime.parse(json['modificado'])
          : DateTime(1970, 1, 1),
    );
  }
}
