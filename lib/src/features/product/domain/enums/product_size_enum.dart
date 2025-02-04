enum ProductSize {
  xs("Extra chico", "XS"),
  s("Chico", "S"),
  m("Mediano", "M"),
  l("Grande", "L"),
  xl("Extra grande", "XL"),
  std("Estándar", "Estándar");

  final String size;
  final String abbr;
  const ProductSize(this.size, this.abbr);

  @override
  String toString() => size;
}

extension ProductSizeExtension on ProductSize {
  static ProductSize fromString(String size) {
    switch (size.toLowerCase()) {
      case "extra chico":
      case "extra chica":
        return ProductSize.xs;
      case "chica":
      case "chico":
        return ProductSize.s;
      case "mediano":
      case "mediana":
        return ProductSize.m;
      case "grande":
        return ProductSize.l;
      case "extra grande":
        return ProductSize.xl;
      default:
        return ProductSize.std;
    }
  }
}
